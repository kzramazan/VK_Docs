//
//  UITableViewCell+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    class var identifier: String {
        let result = String(describing: self)
        return result
    }
}

public extension UICollectionViewCell {
    class var identifier: String {
        let result = String(describing: self)
        return result
    }
}
