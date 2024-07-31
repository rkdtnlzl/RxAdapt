//
//  SimpleTableViewViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewViewController: BaseViewController, UITableViewDelegate {
    
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                print("Tapped \(value)")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
