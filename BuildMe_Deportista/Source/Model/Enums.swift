//
//  Enums.swift
//  BuildMe_Deportista
//
//  Created by Alejandro Rodríguez Cañete on 23/5/24.
//

import Foundation

enum MuscleGroup: String, Decodable {
    case chest = "Pecho"
    case back = "Espalda"
    case legs = "Piernas"
    case arms = "Brazos"
    case shoulders = "Hombros"
    case abs = "Abdominales"
    case calves = "Gemelos"
    case glutes = "Glúteos"
    case traps = "Trapecios"
    case forearms = "Antebrazos"
    case obliques = "Oblicuos"
    case triceps = "Tríceps"
    case biceps = "Bíceps"
    case quadriceps = "Cuádriceps"
    case hamstrings = "Isquiotibiales"
    case lats = "Dorsales"
    case deltoids = "Deltoides"
    case neck = "Cuello"
    case lowerBack = "Espalda baja"
    case upperBack = "Espalda alta"
}

enum Day: String, Decodable, CaseIterable {
    case monday = "Lunes"
    case tuesday = "Martes"
    case wednesday = "Miércoles"
    case thursday = "Jueves"
    case friday = "Viernes"
    case saturday = "Sábado"
    case sunday = "Domingo"
}

enum TargetAudience: String, Decodable {
    case beginner = "Principiante"
    case intermediate = "Intermedio"
    case advanced = "Avanzado"
}

enum Intensity: String, Decodable {
    case low = "Baja"
    case moderate = "Moderada"
    case high = "Alta"
}

enum Goals: String, Decodable {
    case muscleBuilding = "Construcción de músculo"
    case weightLoss = "Pérdida de peso"
    case strengthTraining = "Entrenamiento de fuerza"
    case enduranceTraining = "Entrenamiento de resistencia"
    case flexibility = "Flexibilidad"
}

enum MealType: String, Decodable {
    case breakfast = "Desayuno"
    case lunch = "Almuerzo"
    case dinner = "Cena"
    case snack = "Snack"
    case midMorningSnack = "Media Mañana"
}

enum TaskType: String, Codable {
    case diet = "Planning Dieta Diario Completado"
    case workout = "Día de Entrenamiento Completado"
}
