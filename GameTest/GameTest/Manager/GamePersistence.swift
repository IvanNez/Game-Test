//
//  GamePersistence.swift
//  GameTest
//
//  Created by Иван Незговоров on 25.09.2024.
//

import Foundation

class GamePersistence {
    
    static func saveCurrentGame(_ game: GameModel?) {
        guard let game = game else { return }
        let defaults = UserDefaults.standard
        defaults.set(game.targetWord, forKey: "targetWord")
        defaults.set(game.previousInput, forKey: "previousInput")
        defaults.set(game.attemptCount, forKey: "attemptCount")
        defaults.set(game.currentHorizontal, forKey: "currentHorizontal")
        
    }
    
    static func loadCurrentGame() -> GameModel? {
        let defaults = UserDefaults.standard
        guard let targetWord = defaults.string(forKey: "targetWord"),
              let previousInput = defaults.array(forKey: "previousInput") as? [String],
              let attemptCount = defaults.value(forKey: "attemptCount") as? Int,
              let horizontal = defaults.value(forKey: "currentHorizontal") as? Int else {
            return nil
        }
        let game = GameModel(targetWord: targetWord)
        game.previousInput = previousInput
        game.attemptCount = attemptCount
        game.currentHorizontal = horizontal
        return game
    }
    
    static func deleteCurrentGame() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "targetWord")
        defaults.removeObject(forKey: "previousInput")
        defaults.removeObject(forKey: "attemptCount")
        defaults.removeObject(forKey: "currentHorizontal")
    }
}
