//
//  PasswordViewModel.swift
//  RxAdapt
//
//  Created by 강석호 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    struct Input {
        let passwordText: ControlProperty<String>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let validation: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let isValid = input.passwordText
            .map { password in
                let regex = "^[A-Za-z0-9]{6,}$"
                let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
                return predicate.evaluate(with: password)
            }
        
        let validation = isValid
            .map { $0 ? "사용가능한 비밀번호입니다." : "똑바로 입력하세요."}
        
        return Output(isValid: isValid, validation: validation)
    }
}
