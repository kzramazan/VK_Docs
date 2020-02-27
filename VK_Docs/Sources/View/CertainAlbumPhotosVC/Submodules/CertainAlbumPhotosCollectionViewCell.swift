//
//  CertainAlbumPhotosCollectionViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/28/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class CertainAlbumPhotosCollectionViewCell: UICollectionViewCell {
    private var photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(albumPhoto: VKCustomAlbumPhoto) {
        if let imageStr = albumPhoto.getImageUrl() {
            photoImageView.loadImageFromUrl(urlString: imageStr)
        }
    }
    
    private func configUI() {
        self.backgroundColor = .clear
        self.addSubview(photoImageView)
        
        makeConstraints()
        self.setNeedsDisplay()
        self.layoutIfNeeded()
    }
    
    private func makeConstraints() {
        photoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
