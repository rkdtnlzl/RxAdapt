//
//  PasswordViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PasswordViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let passwordView = PasswordView()
    private let passwordViewModel = PasswordViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = passwordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // loadView로 UI를 짜면 너무 코드가 길어지는 느낌...?
    func bind() {
        
        let input = PasswordViewModel.Input(passwordText: passwordView.passwordTextFeild.rx.text.orEmpty)
        
        let output = passwordViewModel.transform(input: input)
        
        output.validation
            .bind(to: passwordView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(to: passwordView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemRed : .lightGray
                owner.passwordView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
}
