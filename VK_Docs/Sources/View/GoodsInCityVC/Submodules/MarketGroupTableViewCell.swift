//
//  MarketGroupTableViewCell.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/29/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class MarketGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var marketImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    
    func setCell(market: MarketGroup) {
        if let imageURL = market.photo100 {
            marketImageView.loadImageFromUrl(urlString: imageURL)
        }
        
        titleLabel.text = market.name
        groupTypeLabel.text = market.isClosed == 0 ? "Открытая группа" : "Закрытая группа"
    }
    
    func configUI() {
        marketImageView.layer.cornerRadius = marketImageView.frame.width / 2
        marketImageView.layer.borderWidth = 0.5
        marketImageView.layer.borderColor = Tint.emptyViewSubtitleColor.cgColor
        marketImageView.clipsToBounds = true
        
        groupTypeLabel.textColor = Tint.emptyViewSubtitleColor
    }
}
