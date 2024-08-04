//
//  BaseView.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureConstraints()
        configureUI()
        configureAddTarget()
    }
    
    func configureHierarchy() { }
    func configureConstraints() { }
    func configureUI() { }
    func configureAddTarget() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
