//
//  BirthDayViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class BirthDayViewController: BaseViewController {
    
    private let birthDayPicker = UIDatePicker()
    private let infoLabel = UILabel()
    private let stackView = UIStackView()
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let joinButton = UIButton()
    
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 8)
    let day = BehaviorRelay(value: 1)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindDatePicker()
    }
    
    private func bindDatePicker() {
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.day, .month, .year], from: date)
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(year, month, day)
            .map { year, month, day -> (String, Bool) in
                let today = Date()
                let calendar = Calendar.current
                let dateComponent = DateComponents(year: year, month: month, day: day)
                guard let birthDate = calendar.date(from: dateComponent) else {
                    return ("", false)
                }
                let ageComponents = calendar.dateComponents([.year], from: birthDate, to: today)
                let age = ageComponents.year ?? 0
                
                if age >= 17 {
                    return ("가입이 가능합니다.", true)
                } else {
                    return ("만 17세 이상만 가입할 수 있습니다.", false)
                }
            }
            .bind(with: self) { owner, result in
                let (text, isEnabled) = result
                owner.infoLabel.text = text
                owner.joinButton.isEnabled = isEnabled
                owner.joinButton.backgroundColor = isEnabled ? .blue : .lightGray
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(birthDayPicker)
        view.addSubview(infoLabel)
        view.addSubview(stackView)
        view.addSubview(joinButton)
    }
    
    override func configureUI() {
        birthDayPicker.datePickerMode = .date
        birthDayPicker.preferredDatePickerStyle = .wheels
        birthDayPicker.locale = Locale(identifier: "ko_KR")
        
        infoLabel.font = .systemFont(ofSize: 17)
        infoLabel.textColor = .black
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        yearLabel.font = .systemFont(ofSize: 17)
        yearLabel.textColor = .black
        
        monthLabel.font = .systemFont(ofSize: 17)
        monthLabel.textColor = .black
        
        dayLabel.font = .systemFont(ofSize: 17)
        dayLabel.textColor = .black
        
        joinButton.setTitle("가입하기", for: .normal)
        joinButton.backgroundColor = .lightGray
        joinButton.layer.cornerRadius = 10
        joinButton.isEnabled = false
    }
    
    override func configureConstraints() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        joinButton.snp.makeConstraints {
            $0.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(44)
        }
    }
}
