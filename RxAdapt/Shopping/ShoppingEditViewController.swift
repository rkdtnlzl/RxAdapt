//
//  ShoppingEditViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/3/24.
//

import UIKit
import SnapKit
import RxSwift

final class ShoppingEditViewController: BaseViewController {
    deinit {
        print("deinit \(self)")
    }
    
    var shoppingItem: ShoppingItem!
    var index: Int!
    var list: BehaviorSubject<[ShoppingItem]>!
    
    private let textField = UITextField()
    private let saveButton = UIButton(type: .system)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        bindActions()
    }
    
    private func setupView() {
        view.addSubview(textField)
        view.addSubview(saveButton)
        
        textField.borderStyle = .roundedRect
        textField.text = shoppingItem?.title
        
        saveButton.setTitle("저장하기", for: .normal)
        
        textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindActions() {
        saveButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(with: self) { owner, value in
                var updateItem = owner.shoppingItem!
                updateItem.title = value
                guard var currentData = try? owner.list.value() else { return }
                currentData[owner.index] = updateItem
                owner.list.onNext(currentData)
                owner.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
