//
//  MainViewPresenter.swift
//  GameTest
//
//  Created by Иван Незговоров on 27.09.2024.
//

protocol MainViewPresenterProtocol: AnyObject {
    var gameState: GameModel? { get set }
    var isNewGame: Bool { get set }
    var isDeleteData: Bool { get set }
    var currentInput: String { get set }
    var currentHorizontal: Int { get set }
    var reloadGame: Bool { get set }
    func start()
    func letterTap(letter: String)
    func deleteTap()
    func startNewGame()
    func readyTap()
    func saveData()
    func deleteData()
}

class MainViewPresenter {
    weak var view: MainViewProtocol?
    
    var gameState: GameModel?
    var isNewGame: Bool = true
    var isDeleteData: Bool = false
    var currentInput: String = ""
    var currentHorizontal: Int = 0
    var reloadGame: Bool = false
    
    init(view: MainViewProtocol?, isNewGame: Bool) {
        self.view = view
        self.isNewGame = isNewGame
    }
    
    private func checkGuess() {
        guard let targetWord = gameState?.targetWord else { return }
        view?.updateColors()
        view?.updateKeyboardState()
        if currentInput == targetWord {
            reloadGame = true
            startNewGame()
        } else {
            gameState?.attemptCount += 1
            if gameState!.attemptCount >= 6 {
                isDeleteData = true
                GamePersistence.deleteCurrentGame()
                view?.showAlert(title: "Конец игры", message: "К сожалению попытки закончились - загаданное слово было \(targetWord.uppercased()), но вы можете сыграть еще раз")
            } else {
                currentHorizontal += 1
                saveData()
                currentInput = ""
                view?.updateButtonStates()
            }
        }
        
    }
    
    private func continueCurrentGame() {
        gameState = GamePersistence.loadCurrentGame()
        if let previousInput = gameState?.previousInput {
            view?.fillLetterGrid(with: previousInput)
            for i in 0..<previousInput.count {
                currentInput = previousInput[i].lowercased()
                if currentInput.count == 5 {
                    view?.updateColors()
                    view?.updateKeyboardState()
                    currentHorizontal += 1
                }
            }
            if currentInput.count == 5 {
                currentInput = ""
            }
        }
    }
}

extension MainViewPresenter: MainViewPresenterProtocol {
    func start() {
        if isNewGame {
            startNewGame()
        } else {
            continueCurrentGame()
        }
    }
    
    func startNewGame() {
        let words = WordsManager.loadWords() ?? []
        if let newWord = words.randomElement() {
            gameState = GameModel(targetWord: newWord)
        }
        
        view?.updateKeyboardState()
        reloadGame = false
        view?.updateLetterGridForNewGame()
        
        gameState?.attemptCount = 0
        currentInput = ""
        currentHorizontal = 0
        view?.updateButtonStates()
    }
    
    func letterTap(letter: String) {
        if currentInput.count < 5 && gameState!.attemptCount < 6 {
            currentInput.append(letter)
            view?.updateLetterGrid()
            view?.updateButtonStates()
        }
    }
    
    func deleteTap() {
        if currentInput.count > 0 {
            currentInput.removeLast()
            view?.updateLetterGrid()
            view?.updateButtonStates()
        }
    }
    
    func readyTap() {
        guard let targetWord = gameState?.targetWord else { return }
        if currentInput.count == targetWord.count {
            checkGuess()
        }
    }
    
    func saveData() {
        if !isDeleteData {
            if gameState?.previousInput.isEmpty != true {
                if gameState?.previousInput.last?.count != 5 {
                    gameState?.previousInput.removeLast()
                }
            }
            gameState?.previousInput.append(currentInput.uppercased())
            gameState?.currentHorizontal = currentHorizontal
            GamePersistence.saveCurrentGame(gameState)
        }
    }
    
    func deleteData() {
        GamePersistence.deleteCurrentGame()
    }
}
