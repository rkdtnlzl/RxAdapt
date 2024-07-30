//
//  JustViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class JustViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
    }
}
