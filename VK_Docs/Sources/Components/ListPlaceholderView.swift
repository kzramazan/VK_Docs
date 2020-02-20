//
//  ListPlaceholderView.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import SnapKit

protocol ListPlaceholderViewDelegate {
    func didTapPlaceholderSubmitBtn(_ sender: UIButton)
}

class ListPlaceholderView: UIView {

    private lazy var containerView = UIView()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.mainFontBold(ofSize: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Tint.emptyViewSubtitleColor
        label.font = UIFont.mainFont(ofSize: 16)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = Tint.customButtonColor
        btn.layer.cornerRadius = 18
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.font = UIFont.mainFont(ofSize: 14)
        btn.addTarget(self, action: #selector(submitBtnHandler(_:)), for: .touchUpInside)
        return btn
    }()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    var btnName: String? {
        didSet {
            submitBtn.setTitle(btnName, for: .normal)
        }
    }
    var imageSize: CGSize? {
        didSet {
            guard image != nil else { return }
                
            imageView.snp.updateConstraints { make in
                guard let imageSize = imageSize else { return }
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        }
    }
    
    var delegate: ListPlaceholderViewDelegate?
    
    init(frame: CGRect = CGRect.zero, image: UIImage? = nil, title: String? = nil, subtitle: String? = nil, btnName: String? = nil) {
        super.init(frame: frame)
        
        setupContent(image: image, title: title, subtitle: subtitle, btnName: btnName)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard self.superview != nil else {
            return
        }
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
            make.size.equalToSuperview()
        }
        self.layoutIfNeeded()
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.greaterThanOrEqualTo(0)
            make.bottom.lessThanOrEqualTo(0)
        }
        
        [imageView, titleLabel, subtitleLabel, submitBtn].forEach {
            containerView.addSubview($0)
        }
        
        setupSubviews()
    }
    
    func setupSubviews() {
        imageView.isHidden = (image == nil)
        titleLabel.isHidden = (title == nil)
        subtitleLabel.isHidden = (subtitle == nil)
        submitBtn.isHidden = (btnName == nil)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        subtitleLabel.snp.removeConstraints()
        submitBtn.snp.removeConstraints()
        
        if image != nil {
            imageView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.size.equalTo(150)
                if subtitle == nil && btnName == nil && title == nil {
                    make.bottom.equalToSuperview()
                }
            }
        }
        if title != nil {
            titleLabel.snp.makeConstraints { (make) in
                if image == nil {
                    make.top.equalToSuperview()
                }else{
                    make.top.equalTo(imageView.snp.bottom).offset(16)
                }
                make.left.right.equalToSuperview()
                if subtitle == nil && btnName == nil {
                    make.bottom.equalToSuperview()
                }
            }
        }
        if subtitle != nil {
            subtitleLabel.snp.makeConstraints { (make) in
                if image == nil && title == nil {
                    make.top.equalToSuperview()
                }else if image != nil && title == nil {
                    make.top.equalTo(imageView.snp.bottom).offset(16)
                }else{
                    make.top.equalTo(titleLabel.snp.bottom).offset(16)
                }
                make.left.right.equalToSuperview()
                if btnName == nil {
                    make.bottom.equalToSuperview()
                }
            }
        }
        if btnName != nil {
            submitBtn.snp.makeConstraints { (make) in
                if subtitle != nil {
                    make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
                }else if subtitle == nil && title != nil {
                    make.top.equalTo(titleLabel.snp.bottom).offset(24)
                }else if subtitle == nil && title == nil && image != nil {
                    make.top.equalTo(imageView.snp.bottom).offset(24)
                }else{
                    make.top.equalToSuperview()
                }
                make.centerX.equalToSuperview()
                make.height.equalTo(36)
                make.width.equalTo(180)
                make.bottom.equalToSuperview()
            }
        }
        self.layoutIfNeeded()
    }
    
    func setupContent(image: UIImage? = nil, title: String? = nil, subtitle: String? = nil, btnName: String? = nil) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.btnName = btnName
    }
    
    func reset() {
        self.image = nil
        self.title = nil
        self.subtitle = nil
        self.btnName = nil
    }
}

extension ListPlaceholderView {
    @objc private func submitBtnHandler(_ sender: UIButton) {
        self.delegate?.didTapPlaceholderSubmitBtn(sender)
    }
}
