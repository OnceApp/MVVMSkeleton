//
//  NavbarViewModelProtocol.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import Foundation

protocol NavBarCommand {
    func done(completionHandler: @escaping (Error?) -> Void)
}

protocol NavBarState {
    var doneEnable: Bool { get }
}
