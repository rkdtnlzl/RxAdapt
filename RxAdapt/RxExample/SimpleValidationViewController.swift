//
//  SimpleValidationViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

final class SimpleValidationViewController: BaseViewController {
    
    private let usernameOutlet = UITextField()
    private let usernameValidOutlet = UILabel()
    private let passwordOutlet = UITextField()
    private let passwordValidOutlet = UILabel()
    private let doSomethingOutlet = UIButton()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(usernameOutlet)
        view.addSubview(usernameValidOutlet)
        view.addSubview(passwordOutlet)
        view.addSubview(passwordValidOutlet)
        view.addSubview(doSomethingOutlet)
    }
    
    override func configureUI() {
        usernameOutlet.layer.borderColor = UIColor.black.cgColor
        usernameOutlet.layer.borderWidth = 1
        
        usernameValidOutlet.textColor = .red
        
        passwordOutlet.layer.borderColor = UIColor.black.cgColor
        passwordOutlet.layer.borderWidth = 1
        
        passwordValidOutlet.textColor = .red
        
        doSomethingOutlet.backgroundColor = .cyan
        doSomethingOutlet.layer.cornerRadius = 10
    }
    
    override func configureConstraints() {
        usernameOutlet.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
        usernameValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameOutlet.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        passwordOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
        passwordValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordOutlet.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
    }
    
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
