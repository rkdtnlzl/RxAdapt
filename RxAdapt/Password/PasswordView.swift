//
//  PasswordView.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit
import SnapKit

final class PasswordView: BaseView {
    
    let passwordTextFeild = UITextField()
    let nextButton = UIButton()
    let descriptionLabel = UILabel()
    
    
    override func configureHierarchy() {
        addSubview(passwordTextFeild)
        addSubview(nextButton)
        addSubview(descriptionLabel)
    }
    
    override func configureUI() {
        passwordTextFeild.placeholder = "비밀번호를 입력하세요"
        passwordTextFeild.layer.cornerRadius = 10
        passwordTextFeild.layer.borderColor = UIColor.black.cgColor
        passwordTextFeild.layer.borderWidth = 0.5
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.layer.cornerRadius = 10
    }
    
    override func configureConstraints() {
        passwordTextFeild.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextFeild.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
    }
}

