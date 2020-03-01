//
//  CertainGoodVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class CertainGoodVC: UIViewController {
    private let good: GoodInGroup
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = false
        view.isScrollEnabled = true
        view.backgroundColor = .white
        return view
    }()
    
    private var albumPhotoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.mainFontSemiBold(ofSize: 20)
        label.textColor = Tint.emptyViewSubtitleColor
        label.numberOfLines = 0
        return label
    }()
    
    private var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.mainFontSemiBold(ofSize: 20)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.mainFontSemiBold(ofSize: 15)
        return label
    }()
    
    private lazy var favouritesBtn: FavouritesAddButton = {
        let button = FavouritesAddButton()
        button.isFavourite = false
        button.addTarget(self, action: #selector(favouritesBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private let bottomView = UIView()
    
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
        configUI()
        
        updateInfo()
    }
    
    init(good: GoodInGroup) {
        self.good = good
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CertainGoodVC {
    //MARK: - Methods
    func updateInfo() {
        if let photoStr = good.thumbPhoto {
            albumPhotoImageView.loadImageFromUrl(urlString: photoStr)
        }
        
        titleLabel.text = good.title
        descriptionLabel.text = good.description
        costLabel.text = good.price.text
    }
    
    //MARK: - Actions
    @objc func favouritesBtnTapped() {
        favouritesBtn.isFavourite = !favouritesBtn.isFavourite
    }
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = .white
        bottomView.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(albumPhotoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(costLabel)
        
        view.addSubview(bottomView)
        bottomView.addSubview(favouritesBtn)
        
        makeConstraints()
        
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        
        favouritesBtn.layer.cornerRadius = favouritesBtn.frame.width / 35
    }
    
    func makeConstraints() {
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(68)
        }
        
        favouritesBtn.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(12)
            make.bottom.right.equalToSuperview().offset(-12)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.right.left.top.equalToSuperview()
            make.bottom.equalTo(favouritesBtn.snp.top)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.bottom.equalToSuperview()
        }
        
        albumPhotoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(albumPhotoImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumPhotoImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        costLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(costLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-25).priority(.high)
        }
    }
    
    func setNavItem() {
        let label = UILabel()
        label.text = good.title
        navigationItem.titleView = label
    }
}
