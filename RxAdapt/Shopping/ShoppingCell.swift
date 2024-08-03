//
//  ShoppingCell.swift
//  RxAdapt
//
//  Created by 강석호 on 8/2/24.
//

import UIKit
import RxSwift

final class ShoppingCell: UITableViewCell {
    
    static let identifier = "ShoppingCell"
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemBlue
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(checkmarkButton.snp.leading).offset(-8)
        }
        
        checkmarkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(32)
        }
    }
    
    func configure(with item: ShoppingItem) {
        titleLabel.text = item.title
        let imageName = item.isChecked ? "checkmark.square.fill" : "checkmark.square"
        checkmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
