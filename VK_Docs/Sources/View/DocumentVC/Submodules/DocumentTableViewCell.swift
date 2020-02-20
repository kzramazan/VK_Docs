//
//  DocumentTableViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk

protocol DocumentTableViewCellDelegate: AnyObject {
    func moreButtonTapped(vkDoc: VKDocs, at row: Int)
}

class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var docImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var row: Int?
    
    var delegate: DocumentTableViewCellDelegate?
    
    private var vkDoc: VKDocs? {
        didSet {
            guard let vkDoc = vkDoc else { return }
            let image = VKDocsStruct(vkDoc: vkDoc)
            if #available(iOS 13.0, *) {
                if let image = image.getImage?.withTintColor(UIColor(hex: "#3F8AE0"), renderingMode: .alwaysTemplate) {
                    docImageView.image = image
                }else {
                    docImageView.loadImageFromUrl(urlString: vkDoc.photo_100)
                }
            } else {
                docImageView.tintColor = UIColor(hex: "#3F8AE0")
            }
            
            if let title = vkDoc.title {
                titleLabel.text = title
            }
            
            var text = ""
            if let ext = vkDoc.ext {
                text += "\(ext.uppercased())"
            }
            if let size = vkDoc.size as? Int64 {
                let units = Units(bytes: size)
                text += " · \(units.getReadableUnit().uppercased())"
            }
            if let date = vkDoc.date as? TimeInterval {
                text += " · \(DateUtility.getDateStringPastDates(from: Date(timeIntervalSince1970: (date))))"
            }
            descriptionLabel.text = text
        }
    }
    
    func setCell(with vkDoc: VKDocs, at row: Int) {
        self.vkDoc = vkDoc
        self.row = row
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        docImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        self.separatorInset = .zero
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        guard let vkDoc = vkDoc, let row = row else { return }
        delegate?.moreButtonTapped(vkDoc: vkDoc, at: row)
    }
}
