//
//  InfoTaskViewModel.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 31/5/24.
//

import Foundation
import Firebase

class InfoTaskViewModel {
    
    private var ref: DatabaseReference!
    private var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var tasks: [TaskCompleted] = [] {
        didSet {
            self.reloadDataHandler?()
        }
    }
    
    var reloadDataHandler: (() -> Void)?
    var showAlertHandler: ((_ title: String, _ message: String, _ isError: Bool) -> Void)?
    
    func fetchData() {
        guard let currentUser = currentUser else {
            print("Usuario no autenticado")
            return
        }
        let currentUid = currentUser.uid
        ref = Database.database().reference()
        
        ref.child("CompletedTasks").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("No se encontraron datos en el nodo especificado.")
                self?.tasks = []
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: Array(value.values), options: [])
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                var tasks = try decoder.decode([TaskCompleted].self, from: jsonData)
                tasks = tasks.filter { $0.uid == currentUid }
                
                self?.tasks = tasks
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
            }
        }) { error in
            print("Error al obtener datos: \(error.localizedDescription)")
        }
    }
    
    func deleteTask(at indexPath: IndexPath) {
        guard let currentUser = currentUser else {
            print("Usuario no autenticado")
            return
        }
        
        let currentUid = currentUser.uid
        
        guard indexPath.row < tasks.count else {
            return
        }
        
        let taskToDelete = tasks[indexPath.row]
        
        ref.child("CompletedTasks").child(taskToDelete.taskUid).removeValue { [weak self] error, _ in
            if let error = error {
                self?.showAlertHandler?("Error", "No se pudo eliminar la tarea.", true)
                print("Error al eliminar la tarea de Firebase:", error.localizedDescription)
            } else {
                self?.tasks.remove(at: indexPath.row)
                if self?.tasks.isEmpty ?? false {
                    self?.showAlertHandler?("Éxito", "Tarea eliminada exitosamente.", false)
                }
            }
        }
    }
}
