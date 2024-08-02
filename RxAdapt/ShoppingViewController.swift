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

final class ShoppingViewController: BaseViewController, UITableViewDelegate {
    
    let searchView = UIView()
    let textField = UITextField()
    let addButton = UIButton()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let disposeBag = DisposeBag()
    
    var data = ["그립톡 구매하기",
                "사이다 구매",
                "아이패드 최저가 알아보기",
                "양말 구매하기"
    ]
    
    lazy var list = BehaviorSubject(value: data)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쇼핑"
        
        list
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.square"))
                checkmarkImageView.tintColor = .systemBlue
                cell.accessoryView = checkmarkImageView
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        view.addSubview(searchView)
        searchView.addSubview(textField)
        searchView.addSubview(addButton)
        view.addSubview(tableView)
    }
    
    override func configureUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
