//
//  TakeViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TakeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.repeatElement("jack")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
    }
}
