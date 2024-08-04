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
    let validText = Observable.just("8자 이상 입력하세요.")
    
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
        validText
            .bind(to: passwordView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = passwordView.passwordTextFeild.rx.text.orEmpty
            .map { $0.count >= 8}
        
        validation
            .bind(to: passwordView.nextButton.rx.isEnabled, passwordView.descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemRed : .lightGray
                owner.passwordView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
}
