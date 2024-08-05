//
//  PhoneViewModel.swift
//  RxAdapt
//
//  Created by 강석호 on 8/4/24.
//

import RxSwift
import RxCocoa

final class PhoneViewModel {
    struct Input {
        let phoneText: ControlProperty<String>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let validText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let isValid = input.phoneText
            .map { $0.count >= 11}
        
        let validText = Observable.just("전화번호를 정확히 입력하세요.")
        
        return Output(isValid: isValid,
                      validText: validText)
    }
}
