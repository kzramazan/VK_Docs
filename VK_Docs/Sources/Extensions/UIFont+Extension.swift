//
//  UIFont+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var selectedNameCellFont: UIFont {
        get {
            return UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    class var unselectedNameCellFont: UIFont {
        get {
            return UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "OpenSans", size: size)
    }
    
    static func mainFontBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Arial-BoldMT", size: size)
    }
    
    static func mainFontSemiBold(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "ArialMT", size: size)
    }
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
//        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
}
