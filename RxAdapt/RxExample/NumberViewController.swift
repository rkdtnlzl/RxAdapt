//
//  NumberViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumberViewController: BaseViewController {
    
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let result = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(number1)
        view.addSubview(number2)
        view.addSubview(number3)
        view.addSubview(result)
    }
    
    override func configureUI() {
        number1.layer.borderColor = UIColor.black.cgColor
        number1.layer.borderWidth = 1
        
        number2.layer.borderColor = UIColor.black.cgColor
        number2.layer.borderWidth = 1
        
        number3.layer.borderColor = UIColor.black.cgColor
        number3.layer.borderWidth = 1
        
        result.layer.borderColor = UIColor.black.cgColor
        result.layer.borderWidth = 1
        result.backgroundColor = .lightGray
    }
    
    override func configureConstraints() {
        number1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(44)
        }
    }

}
