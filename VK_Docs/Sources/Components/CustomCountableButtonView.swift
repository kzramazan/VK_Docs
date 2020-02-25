//
//  CustomCountableButtonView.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/24/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class CustomCountableButtonView: UIView {
    var counter: Int = 0 {
        didSet {
            counterButtonTitleLabel.text = counter.description
        }
    }
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    private var backgrounView = UIView()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        label.numberOfLines = 1
        return label
    }()
    private var counterButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Tint.customButtonColor
        label.font = UIFont(name: "ArialMT", size: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var backgroundForCounter = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CustomCountableButtonView {
    func configUI() {
        backgroundForCounter.clipsToBounds = true
        backgroundForCounter.backgroundColor = .white
        
        self.addSubview(backgrounView)
        backgrounView.addSubview(titleLabel)
        backgrounView.addSubview(backgroundForCounter)
        backgroundForCounter.addSubview(counterButtonTitleLabel)
        
        makeConstraints()
        
        self.layoutSubviews()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
        
        backgroundForCounter.layer.cornerRadius = backgroundForCounter.frame.width / 2
    }
    
    func makeConstraints() {
        backgrounView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        counterButtonTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(counterButtonTitleLabel.snp.height)
        }
        
        backgroundForCounter.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(counterButtonTitleLabel).offset(4)
            make.top.left.equalTo(counterButtonTitleLabel).offset(-4)
            make.right.equalToSuperview()
        }
    }
}
