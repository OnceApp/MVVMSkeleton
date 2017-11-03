//
//  RootViewController.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private let button: UIButton = {
        let _b = UIButton(type: UIButtonType.custom)
        _b.backgroundColor = .gray
        _b.setTitleColor(.white, for: .normal)
        _b.translatesAutoresizingMaskIntoConstraints = false
        _b.setTitle("Go to the controller", for: .normal)
        _b.addTarget(self, action: #selector(goToController), for: .touchUpInside)
        return _b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
    }
}

extension RootViewController {

    // goTocontroller content should be in a Coordinator
    // view controllers should not know anything about other view controllers
    @objc fileprivate func goToController() {
        let viewController = TypeFridayViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
