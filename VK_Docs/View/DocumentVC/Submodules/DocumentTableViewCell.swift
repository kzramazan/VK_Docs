//
//  DocumentTableViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk

struct VKDocsStruct {
    private var vkDoc: VKDocs
    enum VKDocsExt: Int {
        case txt = 1
        case archive = 2
        case gif = 3
        case image = 4
        case audio = 5
        case video = 6
        case ebook = 7
        case other = 8
    }
    
    init(vkDoc: VKDocs) {
        self.vkDoc = vkDoc
    }
    
    var getImage: UIImage? {
        get {
            switch VKDocsExt(rawValue: vkDoc.type as! Int) {
            case .txt:
                return UIImage(named: "text_docs")
            case .archive:
                return UIImage(named: "zip_docs")
            case .gif:
                return UIImage(named: vkDoc.photo_100)
            case .audio:
                return UIImage(named: "audio_docs")
            case .video:
                return UIImage(named: "video_docs")
            case .ebook:
                return UIImage(named: "book_docs")
            default:
                return UIImage(named: "other_docs")
            }
        }
    }
}

class DocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var docImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var vkDoc: VKDocs? {
        didSet {
            guard let vkDoc = vkDoc else { return }
            let image = VKDocsStruct(vkDoc: vkDoc)
            docImageView.image = image.getImage
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
}
