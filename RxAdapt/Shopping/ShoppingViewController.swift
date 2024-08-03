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
    var title: String
    var isChecked: Bool
}

final class ShoppingViewController: BaseViewController, UITableViewDelegate {
    deinit {
        print("deinit \(self)")
    }
    
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
        addButtonBind()
    }
    
    func tableViewBind() {
        list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingCell.identifier, cellType: ShoppingCell.self)) { [weak self] (row, element, cell) in
                guard let self = self else { return }
                cell.backgroundColor = .systemGray6
                cell.configure(with: element)
                cell.checkmarkButton.rx.tap
                    .bind { [weak self] in
                        self?.toggleCheckmark(at: row)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                var data = try! owner.list.value()
                data.remove(at: indexPath.row)
                owner.list.onNext(data)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShoppingItem.self)
            .bind(with: self) { owner, item in
                guard let index = try? owner.list.value().firstIndex(where: { $0.title == item.title }) else { return }
                owner.presentEditVC(for: index, item: item)
            }
            .disposed(by: disposeBag)
    }
    
    func addButtonBind() {
        addButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .map { ShoppingItem(title: $0, isChecked: false) }
            .bind(with: self, onNext: { owner, item in
                var data = try! owner.list.value()
                data.append(item)
                owner.list.onNext(data)
                owner.textField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    func presentEditVC(for index: Int, item: ShoppingItem) {
        let editViewController = ShoppingEditViewController()
        editViewController.shoppingItem = item
        editViewController.index = index
        editViewController.list = list
        present(editViewController, animated: true, completion: nil)
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
        tableView.backgroundColor = .white
        
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
