//
//  GroupUnsubscribeCollectionViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/22/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk

protocol GroupSelectableCell: UICollectionViewCell {
    var selectionView: UIView { get set }
    var groupImageView: CustomImageView { get set }
    var checkMarkView: UIImageView { get set }
    var groupImageLineView: UIView { get set }
    var isCellSelected: Bool { get set }
    
    func configBorderView()
}

extension GroupSelectableCell {
    func configBorderView() {
        selectionView.layer.cornerRadius = selectionView.frame.width / 2
        selectionView.layer.borderColor = UIColor.clear.cgColor
        selectionView.layer.borderWidth = 3
        self.addSubview(checkMarkView)
        checkMarkView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(groupImageView)
        }
        
        
        
        
        groupImageView.layer.cornerRadius = groupImageView.frame.width / 2
        groupImageView.clipsToBounds = true
        groupImageView.layer.borderColor = UIColor.clear.cgColor
        groupImageView.layer.borderWidth = 2
        
        groupImageLineView.layer.cornerRadius = groupImageLineView.frame.width / 2
        groupImageLineView.layer.borderColor = UIColor.lightGray.cgColor
        groupImageLineView.layer.borderWidth = 1
    }
    
}

private extension GroupSelectableCell {
    func animateCellSelection() {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.checkMarkView.isHidden = !self.isCellSelected
            self.selectionView.layer.borderColor = self.isCellSelected ? Tint.customButtonColor.cgColor : UIColor.clear.cgColor
            
            self.layoutIfNeeded()
        }
    }
    
}


class GroupUnsubscribeCollectionViewCell: UICollectionViewCell, GroupSelectableCell {
    var checkMarkView: UIImageView = UIImageView(image: UIImage(named: "check_circle"))
    
    var groupImageLineView: UIView = UIView()
    
    internal var selectionView = UIView()
    
    var isCellSelected: Bool = false {
        didSet {
            animateCellSelection()
        }
    }
    
    internal var groupImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.mainFontSemiBold(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        groupImageView.image = nil
        groupNameLabel.text = nil
    }
    
    func setVKGroup(vkGroup: VKGroup) {
        if let photo = vkGroup.photo_200 ?? vkGroup.photo_100 ?? vkGroup.photo_50 {
            groupImageView.loadImageFromUrl(urlString: photo)
        }
        
        groupNameLabel.text = vkGroup.name
    }
}

//MARK: - ConfigUI
private extension GroupUnsubscribeCollectionViewCell {
    func configUI() {
        self.addSubview(groupImageLineView)
        self.addSubview(groupImageView)
        
        self.addSubview(selectionView)
        self.addSubview(groupNameLabel)
        
        makeConstraints()
        
        self.layoutSubviews()
        configBorderView()
        self.layoutIfNeeded()
    }
    
    func makeConstraints() {
        selectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(self.frame.width)
        }
        
        groupImageLineView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(selectionView).offset(-1)
            make.top.left.equalTo(selectionView).offset(1)
        }
        
        groupImageView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(selectionView).offset(-3)
            make.top.left.equalTo(selectionView).offset(3)
        }
        
        groupNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(groupImageView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

