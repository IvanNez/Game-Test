//
//  Builder.swift
//  GameTest
//
//  Created by Иван Незговоров on 27.09.2024.
//

import UIKit

protocol BuilderProtocol {
    static func loadStartGameView() -> UIViewController
    static func loadMainView(isNewGame: Bool) -> UIViewController
}

class Builder: BuilderProtocol {
    
    static func loadStartGameView() -> UIViewController {
        let view = StartGameView()
        let presenter = StartGameViewPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func loadMainView(isNewGame: Bool) -> UIViewController {
        let view = MainView()
        let presenter = MainViewPresenter(view: view, isNewGame: isNewGame)
        view.presenter = presenter
        return view
    }
    
}
