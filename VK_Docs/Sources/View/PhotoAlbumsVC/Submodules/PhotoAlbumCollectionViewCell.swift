//
//  PhotoAlbumCollectionViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumPhotoImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    func configUI() {
        albumPhotoImageView.layer.cornerRadius = albumPhotoImageView.frame.width / 21.125
        albumPhotoImageView.clipsToBounds = true
        
        numberOfPhotosLabel.textColor = UIColor(hex: "#909499")
    }

}
