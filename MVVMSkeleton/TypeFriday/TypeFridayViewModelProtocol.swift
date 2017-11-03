//
//  TypeFridayViewModelProtocol.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import Foundation

protocol TypeFridayViewCommand {
    mutating func setWord(_ word: String)
}

protocol TypeFridayViewState {
    var word: String { get }
    var wordCompletion: Int { get }
    var showWordStatus: Bool { get }
}
