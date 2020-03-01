//
//  GoodsInGroupCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class GoodsInGroupCell: UICollectionViewCell {
    private var albumPhotoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = Tint.emptyViewSubtitleColor.cgColor
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.mainFontSemiBold(ofSize: 13)
        label.textColor = Tint.emptyViewSubtitleColor
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.mainFontBold(ofSize: 14)
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        costLabel.text = nil
        albumPhotoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(good: GoodInGroup) {
        if let imageStr = good.thumbPhoto {
            albumPhotoImageView.loadImageFromUrl(urlString: imageStr)
        }else {
            albumPhotoImageView.image = #imageLiteral(resourceName: "other_docs")
        }
        
        titleLabel.text = good.title
        if let price = good.price.text {
            costLabel.text = price
        }
    }
    
    private func configUI() {
        self.backgroundColor = .clear
        self.addSubview(albumPhotoImageView)
        self.addSubview(titleLabel)
        self.addSubview(costLabel)
        
        makeConstraints()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
        
        albumPhotoImageView.layer.cornerRadius = albumPhotoImageView.frame.width / 21.125
    }
    
    private func makeConstraints() {
        albumPhotoImageView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(albumPhotoImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumPhotoImageView.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview()
        }
        
        costLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.trailing.equalToSuperview()
        }
    }
}
