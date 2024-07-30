//
//  FromViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FromViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
}
