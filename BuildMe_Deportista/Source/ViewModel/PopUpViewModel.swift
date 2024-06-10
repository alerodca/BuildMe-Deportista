//
//  PopUpViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 2/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class PopupViewModel {
    // Properties
    private let databaseRef = Database.database().reference()
    var typeTask: TaskType
    var observations: String = ""
    var selectedDate: Date = Date()
    var completedTask: TaskCompleted?
    
    // Bindings
    var onTaskSaved: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(typeTask: TaskType) {
        self.typeTask = typeTask
    }
    
    init(completedTask: TaskCompleted?) {
        self.completedTask = completedTask
        self.typeTask = completedTask?.typeTask ?? .diet
        self.observations = completedTask?.observations ?? ""
        self.selectedDate = completedTask?.date ?? Date()
    }
    
    func saveTask() {
        guard let uid = Auth.auth().currentUser?.uid else {
            onError?("Error: No hay ningún usuario autenticado")
            return
        }
        
        var enteredText = observations
        if enteredText.isEmpty {
            enteredText = "Ninguna observación asignada"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let newTaskUid: String
        if let completedTask = completedTask {
            newTaskUid = completedTask.taskUid
        } else {
            newTaskUid = databaseRef.child("CompletedTasks").childByAutoId().key ?? ""
        }
        
        let taskCompleted = TaskCompleted(typeTask: self.typeTask, date: selectedDate, observations: enteredText, uid: uid, taskUid: newTaskUid)
        let taskDictionary = taskCompleted.toDictionary()
        
        databaseRef.child(Constants.CompletedTasksChild).observeSingleEvent(of: .value) { (snapshot) in
            var duplicateTaskUid: String?
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let taskData = childSnapshot.value as? [String: Any],
                   let date = taskData["date"] as? String,
                   let typeTaskString = taskData["typeTask"] as? String,
                   let typeTask = TaskType(rawValue: typeTaskString),
                   typeTask == self.typeTask && date == formattedDate {
                    duplicateTaskUid = taskData["taskUid"] as? String
                    break
                }
            }
            
            if let duplicateTaskUid = duplicateTaskUid, duplicateTaskUid != newTaskUid {
                self.onError?("Error: Ya existe una tarea completada con el mismo tipo y fecha.")
            } else {
                let completedTasksRef = self.databaseRef.child(Constants.CompletedTasksChild).child(newTaskUid)
                completedTasksRef.setValue(taskDictionary) { (error, _) in
                    if let error = error {
                        self.onError?("Error al subir los datos: \(error.localizedDescription)")
                    } else {
                        self.onTaskSaved?()
                    }
                }
                if self.typeTask == .diet {
                    NotificationCenter.default.post(name: Notification.Name("DietTaskCompletedSuccessfully"), object: nil)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("WorkoutTaskCompletedSuccessfully"), object: nil)
                }
            }
        }
    }
}
