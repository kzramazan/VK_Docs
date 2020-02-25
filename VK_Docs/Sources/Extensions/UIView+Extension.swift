//
//  UIView+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/24/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

extension UIView {
    func addBackgroundBlur(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
}
