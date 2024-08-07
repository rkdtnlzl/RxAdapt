//
//  TodoViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TodoViewController: BaseViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    let disposeBag = DisposeBag()
    let viewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let recentText = PublishSubject<String>()
        
        let input = TodoViewModel.Input(recentText: recentText)
        let output = viewModel.transform(input: input)
        
        output.todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoTableViewCell.identifier, cellType: TodoTableViewCell.self)) { (row, element, cell) in
                cell.todoTitle.text = element
            }
            .disposed(by: disposeBag)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: TodoCollectionViewCell.identifier, cellType: TodoCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = "\(element) \(row)"
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
//            .debug() // 테스트용이기에 나중에는 지우는게 맞다
            .map { "검색어는 \($0.0)" }
            .subscribe(with: self) { owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    override func configureUI() {
        navigationItem.titleView = searchBar
        
        collectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
