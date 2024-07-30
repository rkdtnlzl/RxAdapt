//
//  RxTextFieldViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RxTextFieldViewController: UIViewController {
    
    private let signName = UITextField()
    private let signEmail = UITextField()
    private let signButton = UIButton()
    private let simpleLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setSign()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(signName)
        view.addSubview(signEmail)
        view.addSubview(signButton)
        view.addSubview(simpleLabel)
        
        signName.backgroundColor = .lightGray
        signEmail.backgroundColor = .lightGray
        signButton.backgroundColor = .lightGray
        simpleLabel.backgroundColor = .lightGray
        
        signName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signEmail.snp.makeConstraints { make in
            make.top.equalTo(signName.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(signEmail.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
    }
    
    func setSign() {
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, 이메일은 \(value2)이다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                print("showAlert")
            }
            .disposed(by: disposeBag)
    }
}
