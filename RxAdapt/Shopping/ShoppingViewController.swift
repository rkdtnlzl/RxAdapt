//
//  ShoppingViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ShoppingItem {
    let title: String
    var isChecked: Bool
}

final class ShoppingViewController: BaseViewController, UITableViewDelegate {
    
    let searchView = UIView()
    let textField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let disposeBag = DisposeBag()
    
    var data = [
        ShoppingItem(title: "그립톡 구매하기", isChecked: false),
        ShoppingItem(title: "사이다 구매", isChecked: false),
        ShoppingItem(title: "아이패드 최저가 알아보기", isChecked: false),
        ShoppingItem(title: "양말 구매하기", isChecked: false)
    ]
    
    lazy var list = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쇼핑"
        tableViewBind()
    }
    
    func tableViewBind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingCell.identifier, cellType: ShoppingCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.configure(with: element)
                cell.checkmarkButton.rx.tap
                    .bind { [weak self] in
                        self?.toggleCheckmark(at: row)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func toggleCheckmark(at index: Int) {
        var currentData = try! list.value()
        currentData[index].isChecked.toggle()
        list.onNext(currentData)
    }
    
    override func configureHierarchy() {
        view.addSubview(searchView)
        searchView.addSubview(textField)
        searchView.addSubview(addButton)
        view.addSubview(tableView)
    }
    
    override func configureUI() {
        tableView.register(ShoppingCell.self, forCellReuseIdentifier: ShoppingCell.identifier)
        
        searchView.backgroundColor = .systemGray5
        searchView.layer.cornerRadius = 5
        
        textField.placeholder = "무엇을 구매하실 건가요?"
        
        addButton.backgroundColor = .systemGray3
        addButton.layer.cornerRadius = 5
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
    }
    
    override func configureConstraints() {
        searchView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        textField.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchView).inset(5)
            make.leading.equalTo(searchView).inset(10)
            make.width.equalTo(250)
        }
        addButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(searchView).inset(10)
            make.trailing.equalTo(searchView).inset(10)
            make.width.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
