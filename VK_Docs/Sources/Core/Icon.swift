//
//  Icon.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

enum Icon: String {
    case goods = "profile"
    case photoAlbums = "catalogue"
    case contentSharing = "home"
    case groups
    case settings
    
    var getIcon: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
