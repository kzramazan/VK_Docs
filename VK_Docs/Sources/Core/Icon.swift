//
//  Icon.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

enum Icon: String {
    case goods
    case photoAlbums
    case contentSharing
    case settings
    
    var getIcon: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
