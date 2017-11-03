//
//  TypeFridayViewModel.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import Foundation

// TypeFridayUpdatable is the protocol that the controller should conform to
// It is to receive the changes of the view model / model
protocol TypeFridayUpdatable: NSObjectProtocol {
    func update(_ previousState: TypeFridayState, _ newState: TypeFridayState)
}

// TypeFridayState is the whole/final protocol that the state embed in the view model should conform to
// The state has to be immutable: there is no method to set anything
typealias TypeFridayState = TypeFridayViewState & NavBarState

// TypeFridayEvent is the protocol that the view model should conform to
// in order to communicate with the controller
// Remark: state is not mutable. There is no way to change it beside in the view model itself.
protocol TypeFridayEvent {
    var state: TypeFridayState { get }
    func refresh()
    var updatable: TypeFridayUpdatable? { get set }
}

// TypeFridayViewModel is the whole/final protocol that the view model should conform to
typealias TypeFridayViewModel = TypeFridayEvent & TypeFridayViewCommand & NavBarCommand

// MARK: - TypeFridayStateImpl is the concrete type conform to TypeFridayState protocol
struct TypeFridayStateImpl: TypeFridayState {
    let word: String
    let wordCompletion: Int
    let showWordStatus: Bool
    let doneEnable: Bool
}

// MARK: - TypeFridayViewModelImpl is the concrete type conform to TypeFridayViewModel protocol
class TypeFridayViewModelImpl: TypeFridayViewModel {

    // MARK: TypeFridayEvent conformity
    var state: TypeFridayState

    func refresh() {
        updateState(newState: state)
    }

    weak var updatable: TypeFridayUpdatable?

    // MARK: TypeFridayViewCommand conformity
    func setWord(_ word: String) {
        let wordRange = model.wordToFind.range(of: word)
        let nbCharacter: Int = {
            guard let wordRange = wordRange else {
                return 0
            }
            return model.wordToFind.distance(from: wordRange.lowerBound, to: wordRange.upperBound)
        }()
        let completion = nbCharacter * 100 / model.wordToFind.count
        let newState = TypeFridayStateImpl(word: word,
                                           wordCompletion: completion,
                                           showWordStatus: (completion >= 33),
                                           doneEnable: (completion >= 100))
        updateState(newState: newState)
    }

    // MARK: NavBarCommand conformity
    func done(completionHandler: @escaping (Error?) -> Void) {
        model.incrementSuccess()
        completionHandler(nil)
    }

    // MARK: Initializer
    init(model: Model) {
        self.state = TypeFridayStateImpl(word: "", wordCompletion: 0, showWordStatus: false, doneEnable: false)
        self.model = model
    }

    private let model: Model
}

extension TypeFridayViewModelImpl {

    private func updateState(newState: TypeFridayState) {
        let pState = state
        state = newState
        // The updatable thing is an user interface class, let's be fair with it and execute it on the main thread
        DispatchQueue.main.async {
            self.updatable?.update(pState, newState)
        }
    }
}
