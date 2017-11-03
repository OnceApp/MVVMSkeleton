//
//  TypeFridayViewController.swift
//  MVVMSkeleton
//
//  Created by Guillaume Sempé on 03/11/2017.
//  Copyright © 2017 Once Dating AG. All rights reserved.
//

import UIKit

class TypeFridayViewController: UIViewController {

    fileprivate let typeFridayView: TypeFridayView = TypeFridayView()
    fileprivate var viewModel: TypeFridayViewModel?

    deinit {
        print("deinit is call. To live check any retain cycle (should not be in prod)")
    }

    // init() is the convenient initializer to not force the callers to create a TypeFridayViewModel
    // This convenient initializer may not exist in every case. It depends if there is a default model usable
    convenience init() {
        self.init(viewModel: TypeFridayViewModelImpl(model: Model()))
    }

    // init(viewModel:) is the designated initializer of the subclass
    required init(viewModel newViewModel: TypeFridayViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = newViewModel
        registerSelfAsUpdatable()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        typeFridayView.state = viewModel?.state
        typeFridayView.command = viewModel

        view.backgroundColor = .gray
        navigationItem.rightBarButtonItem = doneBarButtonItem()
        view.addSubview(typeFridayView)
        typeFridayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        typeFridayView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        typeFridayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
        typeFridayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true

        viewModel?.refresh() // Force a refresh
    }

    private func registerSelfAsUpdatable() {
        { [weak self] in
            guard let `self` = self else {
                return
            }
            self.viewModel?.updatable = self
        }()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Updatable requirements
extension TypeFridayViewController: TypeFridayUpdatable {

    internal func update(_ previousState: TypeFridayState, _ newState: TypeFridayState) {
        navigationItem.rightBarButtonItem?.isEnabled = newState.doneEnable
        typeFridayView.state = newState
    }
}

// MARK: - Navigation bar requirements
extension TypeFridayViewController {

    fileprivate func doneBarButtonItem() -> UIBarButtonItem {
        let _doneButton: UIButton = UIButton(type: UIButtonType.custom)
        _doneButton.setTitle("DONE", for: .normal)
        _doneButton.setTitleColor(.black, for: .normal)
        _doneButton.setTitleColor(.lightGray, for: .disabled)
        _doneButton.isEnabled = false
        _doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return UIBarButtonItem(customView: _doneButton)
    }

    @objc fileprivate func doneAction() {
        viewModel?.done(completionHandler: { (error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("An error occured \(String(describing: error))")
                }
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
