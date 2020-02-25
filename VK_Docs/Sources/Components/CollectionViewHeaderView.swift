//
//  CollectionViewHeaderView.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/25/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
class CollectionViewHeaderView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 16)
        label.textColor = UIColor(hex: "#818C99")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var titleStr: String? {
        didSet {
            titleLabel.text = titleStr
        }
    }
    
    var descriptionStr: String? {
        didSet {
            descriptionLabel.text = descriptionStr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-32).priority(.high)
        }
    }
}
