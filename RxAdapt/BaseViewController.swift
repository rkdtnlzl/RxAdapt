//
//  BaseViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/31/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureUI()
        configureConstraints()
        configureTarget()
        configureNavigation()
    }
    
    func configureHierarchy() { }
    
    func configureUI() { }
    
    func configureConstraints() { }
    
    func configureTarget() { }
    
    func configureNavigation() { }
}
