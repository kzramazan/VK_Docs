//
//  PhotoAlbumCollectionViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol PhotoAlbumCollectionViewCellDelegate {
    func removeBtnTapped(album: VKCustomAlbum)
}

class PhotoAlbumCollectionViewCell: UICollectionViewCell & ViewEditable {
    var delegate: PhotoAlbumCollectionViewCellDelegate?
    private var album: VKCustomAlbum?
    
    internal lazy var removeBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "remove_cell"), for: .normal)
        button.addTarget(self, action: #selector(removeBtnTapped), for: .touchUpInside)
        return button
    }()
    
    internal var isAnimate: Bool = false {
        didSet {
            removeBtn.isHidden = !isAnimate
        }
    }

    private var albumPhotoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.mainFontSemiBold(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private var numberOfPhotosLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.mainFontSemiBold(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = UIColor(hex: "#909499")
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        numberOfPhotosLabel.text = nil
        albumPhotoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(album: VKCustomAlbum) {
        self.album = album
        if let imageStr = album.getImageUrl() {
            albumPhotoImageView.loadImageFromUrl(urlString: imageStr)
        }else {
            albumPhotoImageView.image = #imageLiteral(resourceName: "other_docs")
        }
        titleLabel.text = album.title
        numberOfPhotosLabel.text = album.size.description + " фотографии"
    }
    
    @objc private func removeBtnTapped() {
        guard let album = album else { return }
        delegate?.removeBtnTapped(album: album)
    }
    
    private func configUI() {
        self.backgroundColor = .clear
        self.addSubview(albumPhotoImageView)
        self.addSubview(titleLabel)
        self.addSubview(numberOfPhotosLabel)
        self.addSubview(removeBtn)
        
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
        
        removeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(-5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumPhotoImageView.snp.bottom).offset(7)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        numberOfPhotosLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }

}
