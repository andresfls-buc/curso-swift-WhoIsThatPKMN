//
//  GameModel.swift
//  who is that pokemon
//
//  Created by Andres Landazabal on 2025/05/31.
//

import Foundation

struct GameModel{
    var score = 0
    
    //Revisar si la respuesta es correcta
    
    mutating func checkAnswer(_ userAnswer: String, _ correctAnswer: String) -> Bool {
        if userAnswer.lowercased() == correctAnswer.lowercased() {
            score += 1
        return true
        }
        return false
     }
    
    // Obtener score
    
   func getScore() -> Int {
        return score
   }
    
    // Cambiar el score
    
    mutating  func setScore( score: Int) {
          self.score = score
      }
    
}
