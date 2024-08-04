//
//  PhoneViewModel.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import RxSwift
import RxCocoa

final class PhoneViewModel {

    let phoneText = BehaviorRelay<String>(value: "")
    let isValid: Observable<Bool>
    let validText = Observable.just("전화번호를 정확히 입력하세요.")
    
    init() {
        isValid = phoneText
            .map { $0.count == 11 }
    }
}
