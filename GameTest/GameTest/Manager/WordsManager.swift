//
//  WordsLoader.swift
//  GameTest
//
//  Created by Иван Незговоров on 25.09.2024.
//
import Foundation

class WordsManager {
    static func loadWords() -> [String]? {
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let words = try JSONDecoder().decode(WordsContainer.self, from: data)
                return words.words
            } catch {
                print("Error loading words: \(error)")
            }
        }
        return nil
    }
}
