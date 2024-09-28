//
//  GameModel.swift
//  GameTest
//
//  Created by Иван Незговоров on 25.09.2024.
//

class GameModel {
    var targetWord: String
    var previousInput: [String] = []
    var attemptCount: Int
    var currentHorizontal: Int = 0
    
    init(targetWord: String) {
        self.targetWord = targetWord
        self.attemptCount = 0
    }
}
