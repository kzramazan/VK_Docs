//
//  SelectionTableViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFontSemiBold(ofSize: 17)
        return label
    }()
    
    private var selectionImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setCell(city: City, isSelected: Bool) {
        titleLabel.text = city.title
        selectionImageView.image = isSelected ? #imageLiteral(resourceName: "check_circle") : nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configUI() {
        addSubview(titleLabel)
        addSubview(selectionImageView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        selectionImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-18)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualTo(selectionImageView.snp.left).offset(12)
            make.centerY.equalToSuperview()
        }
    }
}
