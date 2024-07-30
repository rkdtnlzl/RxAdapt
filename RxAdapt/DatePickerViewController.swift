//
//  DatePickerViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DatePickerViewController: UIViewController {
    
    let simplePickerView = UIPickerView()
    let simpleLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setPickerView()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(simplePickerView)
        view.addSubview(simpleLabel)
        
        simpleLabel.backgroundColor = .lightGray
        simpleLabel.textAlignment = .center
        
        simplePickerView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(200)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
    }
    
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
