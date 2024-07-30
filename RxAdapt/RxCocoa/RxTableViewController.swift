//
//  RxTableViewController.swift
//  RxAdapt
//
//  Created by 강석호 on 7/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RxTableViewController: UIViewController {
    
    private let simpleTableView = UITableView()
    private let simpleLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setTableView()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(simpleTableView)
        view.addSubview(simpleLabel)
        
        simpleLabel.backgroundColor = .lightGray
        
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First item",
            "Second item",
            "Third item"
        ])
        
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭함"
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
