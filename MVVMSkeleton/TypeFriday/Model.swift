//
//  Model.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import Foundation

class Model {

    var wordToFind: String = ""
    var nbSuccess: Int = 0

    init() {
        self.wordToFind = wordToFindFromUserDefaults()
        self.nbSuccess = nbSuccessFromUserDefaults()
    }
}

extension Model {

    // Not yet from User Defaults
    fileprivate func wordToFindFromUserDefaults() -> String {
        return "Friday"
    }

    // Not yet from User Defaults
    fileprivate func nbSuccessFromUserDefaults() -> Int {
        return 0
    }

    func incrementSuccess() {
        
    }
}
