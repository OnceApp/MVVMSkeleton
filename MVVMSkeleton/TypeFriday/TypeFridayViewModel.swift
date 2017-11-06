//
//  TypeFridayViewModel.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import Foundation

// cf. https://swift.org/documentation/api-design-guidelines/#strive-for-fluent-usage for naming convention
// Examples from standard library:
// - Equatable protocol https://developer.apple.com/documentation/swift/equatable (https://github.com/apple/swift/blob/a05cd35a7f8e3cc70e0666bc34b5056a543eafd4/stdlib/public/core/Equatable.swift#L156)
// - Codable protocol https://developer.apple.com/documentation/swift/codable (https://github.com/apple/swift/blob/2844583d7f9d51ce5c4da7776e19f0aab6f2e3f6/stdlib/public/core/Codable.swift#L43)
// - Collection protocol https://developer.apple.com/documentation/swift/collection (https://github.com/apple/swift/blob/26cdef13a70dbfc3144a45632695eaf967093863/stdlib/public/core/Collection.swift#L348)

// `TypeFridayUpdatable` a type that can be updated by `TypeFridayViewModel`
// It is the protocol that the controller should conform to,
// to be updated by the view model / model
protocol TypeFridayUpdatable: NSObjectProtocol {
    func update(_ previousState: TypeFridayState, _ newState: TypeFridayState)
}

// TypeFridayState a type that stores the `TypeFridayViewController` state
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
