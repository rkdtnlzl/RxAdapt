//
//  TodoTableViewCell.swift
//  RxAdapt
//
//  Created by 강석호 on 8/8/24.
//

import UIKit
import SnapKit

final class TodoTableViewCell: UITableViewCell {
    
    static let identifier = "TodoTableViewCell"
    
    let todoTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .clear
        return button
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    
    private func configure() {
        contentView.addSubview(todoTitle)
        contentView.addSubview(checkButton)
        
        todoTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.trailing.equalTo(checkButton.snp.leading).offset(-8)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalTo(todoTitle)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
    }
}
