//
//  ViewController.swift
//  GameTest
//
//  Created by Иван Незговоров on 25.09.2024.
//

import UIKit

protocol StartGameViewProtocol: AnyObject {
    func updateContinueGameButtonVisibility(isHidden: Bool)
    func goToNextVC(view: UIViewController)
}

class StartGameView: UIViewController {
    
    var presenter: StartGameViewPresenterProtocol!
    
    let newGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Начать новую игру", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(startNewGame), for: .touchUpInside)
        return button
    }()
    
    let continueGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Продолжить текущую игру", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(continueGame), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.checkContinueGameAvailability()
    }
}
// MARK: -- Setup layer
private extension StartGameView {
    func setup() {
        setupNavBar()
        setupViews()
    }
    
    func setupNavBar() {
        view.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        title = "Старт игры"
        navigationItem.backButtonTitle = ""
    }
    
    func setupViews() {
        view.addSubview(newGameButton)
        view.addSubview(continueGameButton)
        
        NSLayoutConstraint.activate([
            newGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            newGameButton.widthAnchor.constraint(equalToConstant: 250),
            newGameButton.heightAnchor.constraint(equalToConstant: 50),
            
            continueGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueGameButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 20),
            continueGameButton.widthAnchor.constraint(equalToConstant: 250),
            continueGameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: -- OBJC
extension StartGameView {
    @objc func startNewGame() {
        presenter.startNewGame()
    }
    @objc func continueGame() {
        presenter.continueGame()
    }
}

// MARK: -- StartGameViewProtocol
extension StartGameView: StartGameViewProtocol {
    func goToNextVC(view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
    func updateContinueGameButtonVisibility(isHidden: Bool) {
        continueGameButton.isHidden = isHidden
    }
}
