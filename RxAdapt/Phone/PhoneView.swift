//
//  PhoneView.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit
import SnapKit

final class PhoneView: BaseView {
    
    let phoneTextField = UITextField()
    let nextButton = UIButton()
    let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(phoneTextField)
        addSubview(nextButton)
        addSubview(descriptionLabel)
    }
    
    override func configureUI() {
        phoneTextField.placeholder = "전화번호를 입력하세요"
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.layer.borderWidth = 0.5
        phoneTextField.text = "010"
        phoneTextField.keyboardType = .phonePad
        
        nextButton.setTitle("다음", for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.layer.cornerRadius = 10
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .red
    }
    
    override func configureConstraints() {
        phoneTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.height.equalTo(44)
        }
    }
}
