//
//  UIColor+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(hex: String){
        var colorLine: String = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    
        if (colorLine.hasPrefix("#")) {
            colorLine.remove(at: colorLine.startIndex)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: colorLine).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

typealias Tint = UIColor

extension Tint {
    static let progressViewColor = UIColor(hex: "#2A6BCB")
    static let emptyViewSubtitleColor = UIColor(hex: "#818C99")
    static let customButtonColor = UIColor(hex: "#4986CC")
    static let textViewBackgroundColor = UIColor(hex: "#F2F3F5")
}
