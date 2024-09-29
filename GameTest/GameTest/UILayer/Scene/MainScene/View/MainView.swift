//
//  MainView.swift
//  GameTest
//
//  Created by Иван Незговоров on 25.09.2024.
//
import UIKit

protocol MainViewProtocol: AnyObject {
    func updateLetterGridForNewGame()
    func updateKeyboardState()
    func updateButtonStates()
    func fillLetterGrid(with inputs: [String])
    func updateColors()
    func updateLetterGrid()
    func showAlert(title: String, message: String)
}

class MainView: UIViewController {
    
    var presenter: MainViewPresenterProtocol!
    
    private lazy var letterGrid: [[UILabel]] = []
    private lazy var keyboardContainer = UIView()
    private lazy var readyButton = createActionButton(action: #selector(readyTapped), image: UIImage(resource: .completeNotEnable))
    private lazy var deleteButton = createActionButton(action: #selector(deleteTapped), image: UIImage(resource: .removeNotEnable))
    private lazy var keyboardStackView = createStackView(axis: .vertical, spacing: 5, distribution: .fillEqually)
    private lazy var firstRowStackView = UIStackView()
    private lazy var secondRowStackView = UIStackView()
    private lazy var thirdRowStackViewWithButtons = UIStackView()
    private lazy var fourdRowStackViewWithButton  = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.saveData()
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: -- Setup layer
private extension MainView {
    func setup() {
        view.backgroundColor = .black
        title = "5 букв"
        setupKeyboard()
        setupLetterGrid()
        presenter.start()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func setupLetterGrid() {
        let gridStackView = createStackView(axis: .vertical, spacing: 6, distribution: .fill)
        view.addSubview(gridStackView)
        
        for _ in 0..<6 {
            var rowLabels: [UILabel] = []
            let rowStackView = createStackView(axis: .horizontal, spacing: 6, distribution: .fillEqually)
            gridStackView.addArrangedSubview(rowStackView)
            
            for _ in 0..<5 {
                let label = createLabel()
                rowStackView.addArrangedSubview(label)
                rowLabels.append(label)
            }
            letterGrid.append(rowLabels)
        }
        
        NSLayoutConstraint.activate([
            gridStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gridStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gridStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gridStackView.heightAnchor.constraint(equalTo: gridStackView.widthAnchor, multiplier: 6.0/5.0),
        ])
    }
    
    func setupKeyboard() {
        let alphabet: [Character] = Array("ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ")
        let firstRowLetters = Array(alphabet.prefix(12))
        let secondRowLetters = Array(alphabet.dropFirst(12).prefix(11))
        let thirdRowLetters = Array(alphabet.dropFirst(23).prefix(9))
        
        firstRowStackView = createKeyboardRow(with: firstRowLetters)
        secondRowStackView = createKeyboardRow(with: secondRowLetters)
        thirdRowStackViewWithButtons = createStackView(axis: .horizontal, spacing: 5, distribution: .fillProportionally)
        fourdRowStackViewWithButton = createStackView(axis: .horizontal, spacing: 5, distribution: .fillProportionally)
        
        secondRowStackView.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        secondRowStackView.isLayoutMarginsRelativeArrangement = true
        
        keyboardStackView.addArrangedSubview(firstRowStackView)
        keyboardStackView.addArrangedSubview(secondRowStackView)
        fourdRowStackViewWithButton.addArrangedSubview(readyButton)
        
        for letter in thirdRowLetters {
            let button = createLetterButton(title: String(letter))
            thirdRowStackViewWithButtons.addArrangedSubview(button)
        }
        fourdRowStackViewWithButton.addArrangedSubview(thirdRowStackViewWithButtons)
        
        fourdRowStackViewWithButton.addArrangedSubview(deleteButton)
        keyboardStackView.addArrangedSubview(fourdRowStackViewWithButton)
        
        view.addSubview(keyboardStackView)
        
        NSLayoutConstraint.activate([
            readyButton.widthAnchor.constraint(equalTo: thirdRowStackViewWithButtons.widthAnchor, multiplier: 1.5/9),
            deleteButton.widthAnchor.constraint(equalTo: thirdRowStackViewWithButtons.widthAnchor, multiplier: 1.5/9),
            keyboardStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            keyboardStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            keyboardStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            keyboardStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)
        ])
    }
}

// MARK: -- Helper Methods
private extension MainView {
    func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func calculateCellSize() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let totalPadding: CGFloat = 16 * 2 + 6 * 4
        let availableWidth = screenWidth - totalPadding
        let cellSize = availableWidth / 5
        return cellSize
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.borderColor = UIColor.white.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let cellSize = calculateCellSize()
        label.heightAnchor.constraint(equalToConstant: cellSize).isActive = true
        label.widthAnchor.constraint(equalToConstant: cellSize).isActive = true
        
        return label
    }
    func createKeyboardRow(with letters: [Character]) -> UIStackView {
        let rowStackView = createStackView(axis: .horizontal, spacing: 5, distribution: .fill)
        for letter in letters {
            let button = createLetterButton(title: String(letter))
            rowStackView.addArrangedSubview(button)
        }
        return rowStackView
    }
    func createLetterButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
        return button
    }
    func createActionButton(action: Selector, image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    func passDataToAppDelegate() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.gameState = presenter.gameState
        }
    }
}

// MARK: MainViewProtocol
extension MainView: MainViewProtocol {
    func updateLetterGridForNewGame() {
        letterGrid.forEach { row in
            row.forEach { label in
                label.text = ""
                label.backgroundColor = .black
                label.layer.borderWidth = 1
                label.textColor = .white
                label.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    func updateKeyboardState() {
        guard let targetWord = presenter.gameState?.targetWord else { return }
        let allButtonRows = [firstRowStackView, secondRowStackView, thirdRowStackViewWithButtons]
        for rowStackView in allButtonRows {
            
            let buttons = rowStackView.arrangedSubviews.compactMap { $0 as? UIButton }
            for button in buttons {
                if button == readyButton || button == deleteButton {
                    continue
                }
                
                if presenter.reloadGame {
                    button.backgroundColor = .black
                    button.layer.borderColor = UIColor.white.cgColor
                    button.layer.borderWidth = 1
                    button.setTitleColor(.white, for: .normal)
                    continue
                }
                
                if let letter = button.titleLabel?.text?.lowercased() {
                    let indexInInput = presenter.currentInput.firstIndex(of: Character(letter))
                    if let indexInInput = indexInInput {
                        let inputIndex = presenter.currentInput.distance(from: presenter.currentInput.startIndex, to: indexInInput)
                        let targetIndex = targetWord.distance(from: targetWord.startIndex, to: targetWord.firstIndex(of: Character(letter)) ?? targetWord.endIndex)
                        if inputIndex == targetIndex {
                            button.backgroundColor = .green
                        } else {
                            if targetWord.contains(letter) {
                                button.backgroundColor = .white
                            } else {
                                button.backgroundColor = .lightGray
                            }
                        }
                        button.layer.borderColor = nil
                        button.layer.borderWidth = 0
                        button.setTitleColor(.black, for: .normal)
                    }
                }
            }
        }
    }
    func updateButtonStates() {
        let currentInput = presenter.currentInput
        if currentInput.count > 0 {
            deleteButton.isEnabled = true
            deleteButton.setImage(UIImage(resource: .removeEnable), for: .normal)
            if currentInput.count == 5 {
                readyButton.isEnabled = true
                readyButton.setImage(UIImage(resource: .completeEnable), for: .normal)
            } else {
                readyButton.isEnabled = false
                readyButton.setImage(UIImage(resource: .completeNotEnable), for: .normal)
            }
        } else {
            deleteButton.isEnabled = false
            deleteButton.setImage(UIImage(resource: .removeNotEnable), for: .normal)
            readyButton.isEnabled = false
            readyButton.setImage(UIImage(resource: .completeNotEnable), for: .normal)
        }
    }
    func fillLetterGrid(with inputs: [String]) {
        for (rowIndex, input) in inputs.enumerated() {
            guard rowIndex < letterGrid.count else { break }
            for (colIndex, letter) in input.enumerated() {
                guard colIndex < letterGrid[rowIndex].count else { break }
                letterGrid[rowIndex][colIndex].text = String(letter)
            }
        }
    }
    func updateColors() {
        guard let targetWord = presenter.gameState?.targetWord else { return }
        let currentInput = presenter.currentInput.lowercased()
        for index in 0..<currentInput.count {
            let letterIndex = currentInput.index(currentInput.startIndex, offsetBy: index)
            let letter = currentInput[letterIndex]
            let label = letterGrid[presenter.currentHorizontal][index]
            let targetLetterIndex = targetWord.index(targetWord.startIndex, offsetBy: index)
            label.layer.borderWidth = 0
            label.layer.borderColor = nil
            if targetWord[targetLetterIndex] == letter {
                label.backgroundColor = .green
                label.textColor = .black
            } else if targetWord.contains(letter) {
                label.backgroundColor = .white
                label.textColor = .black
            } else {
                label.backgroundColor = .gray
            }
        }
    }
    func updateLetterGrid() {
        let currentHorizontal = presenter.currentHorizontal
        let currentInput = presenter.currentInput
        for label in letterGrid[currentHorizontal] {
            label.text = ""
            label.backgroundColor = .black
        }
        
        for (colIndex, label) in letterGrid[currentHorizontal].enumerated() {
            if colIndex < currentInput.count {
                let letter = String(currentInput[currentInput.index(currentInput.startIndex, offsetBy: colIndex)]).uppercased()
                label.text = letter
                label.backgroundColor = .black
            }
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Играть еще раз", style: .default, handler: { [weak self] _ in
            self?.presenter.reloadGame = true
            self?.presenter.startNewGame()
        }))
        alert.addAction(UIAlertAction(title: "Выйти из игры", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
// MARK: -- Objc func
extension MainView {
    @objc func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text?.lowercased() else { return }
        presenter.letterTap(letter: letter)
    }
    @objc func deleteTapped() {
        presenter.deleteTap()
    }
    @objc func readyTapped() {
        presenter.readyTap()
    }
    @objc func appWillResignActive() {
        passDataToAppDelegate()
    }
    
}
