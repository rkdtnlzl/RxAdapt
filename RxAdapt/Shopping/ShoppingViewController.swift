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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let disposeBag = DisposeBag()
    
    private let viewModel = ShoppingViewModel()
    
    var data = [
        ShoppingItem(title: "그립톡 구매하기", isChecked: false),
        ShoppingItem(title: "사이다 구매", isChecked: false),
        ShoppingItem(title: "아이패드 최저가 알아보기", isChecked: false),
        ShoppingItem(title: "양말 구매하기", isChecked: false)
    ]
    
    var collectionData = [
        "키보드 사기",
        "마우스 사기",
        "배추 사기",
        "피자 먹기"
    ]
    
    lazy var list = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "쇼핑"
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = ShoppingViewModel.Input(
            addItemTrigger: addButton.rx.tap
                .withLatestFrom(textField.rx.text.orEmpty)
                .filter { !$0.isEmpty }
                .asObservable(),
            deleteItemTrigger: tableView.rx.itemDeleted.asObservable(),
            selectItemTrigger: tableView.rx.modelSelected(ShoppingItem.self).asObservable(),
            toggleCheckmarkTrigger: tableView.rx.itemAccessoryButtonTapped.map { $0.row }.asObservable(),
            collectionItemSelected: collectionView.rx.modelSelected(String.self).asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(cellIdentifier: ShoppingCell.identifier, cellType: ShoppingCell.self)) { (row, element, cell) in
                cell.configure(with: element)
                cell.backgroundColor = .systemGray6
                cell.checkmarkButton.rx.tap
                    .bind { [weak self] in
                        self?.toggleCheckmark(at: row)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.showEditItem
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (index, item) in
                self?.presentEditVC(for: index, item: item)
            })
            .disposed(by: disposeBag)
        
        Observable.just(collectionData)
            .bind(to: collectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = element
            }
            .disposed(by: disposeBag)
        
        output.collectionItemAdded
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.addItemToTableView(item)
            })
            .disposed(by: disposeBag)
    }
    
    func presentEditVC(for index: Int, item: ShoppingItem) {
        let editViewController = ShoppingEditViewController()
        editViewController.shoppingItem = item
        editViewController.index = index
        editViewController.list = viewModel.itemsRelay
        present(editViewController, animated: true, completion: nil)
    }
    
    func toggleCheckmark(at index: Int) {
        var currentData = try! list.value()
        currentData[index].isChecked.toggle()
        list.onNext(currentData)
    }
    
    func addItemToTableView(_ item: String) {
        var currentData = try! list.value()
        currentData.append(ShoppingItem(title: item, isChecked: false))
        list.onNext(currentData)
    }
    
    override func configureHierarchy() {
        view.addSubview(searchView)
        searchView.addSubview(textField)
        searchView.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(collectionView)
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
        
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
