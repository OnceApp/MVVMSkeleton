//
//  TypeFridayView.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import UIKit

class TypeFridayView: UIView {

    var state: TypeFridayViewState? {
        willSet {
            if let newState = newValue {
                updateFromState(state ?? newState, to: newState)
            }
        }
    }
    var command: TypeFridayViewCommand?

    fileprivate let wordTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .lightGray
        t.translatesAutoresizingMaskIntoConstraints = false
        t.autocorrectionType = .no
        t.autocapitalizationType = .none
        return t
    }()
    fileprivate let statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .white
        l.textAlignment = .center
        l.textColor = .black
        l.text = ""
        l.isHidden = true
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        wordTextField.delegate = self


        addSubview(wordTextField)
        wordTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        wordTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        wordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        wordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: wordTextField.bottomAnchor).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        statusLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1, constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View update through state
extension TypeFridayView {

    func updateFromState(_ previousState: TypeFridayViewState, to newState: TypeFridayViewState) {
        statusLabel.isHidden = !newState.showWordStatus
        statusLabel.text = "Completion: \(newState.wordCompletion)%"
    }
}

// MARK: - Word input management
extension TypeFridayView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let word: NSString = (textField.text ?? "") as NSString
        let wordAfterUpdate = word.replacingCharacters(in: range, with: string)
        self.command?.setWord(wordAfterUpdate)
        return true
    }
}
