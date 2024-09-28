//
//  StartGameViewPresenter.swift
//  GameTest
//
//  Created by Иван Незговоров on 27.09.2024.
//

protocol StartGameViewPresenterProtocol: AnyObject {
    func checkContinueGameAvailability()
    func startNewGame()
    func continueGame()
}

class StartGameViewPresenter {
    
    weak var view: StartGameViewProtocol?
    
    init(view: StartGameViewProtocol?) {
        self.view = view
    }
}

extension StartGameViewPresenter: StartGameViewPresenterProtocol {
    
    func checkContinueGameAvailability() {
        let gameExists = GamePersistence.loadCurrentGame() != nil
        view?.updateContinueGameButtonVisibility(isHidden: !gameExists)
    }
    
    func startNewGame() {
        if let gameVC = Builder.loadMainView(isNewGame: true) as? MainView {
            view?.goToNextVC(view: gameVC)
        }
    }
    
    func continueGame() {
        if let gameVC = Builder.loadMainView(isNewGame: false) as? MainView {
            view?.goToNextVC(view: gameVC)
        }
    }
}


