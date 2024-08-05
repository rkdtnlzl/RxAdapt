//
//  PhoneViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PhoneViewController: BaseViewController {
    deinit {
        print("deinit: \(self)")
    }
    
    private let phoneView = PhoneView()
    private let viewModel = PhoneViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = phoneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let input = PhoneViewModel.Input(phoneText: phoneView.phoneTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.validText
            .bind(to: phoneView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(to: phoneView.nextButton.rx.isEnabled, phoneView.descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isValid
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .lightGray
                owner.phoneView.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
