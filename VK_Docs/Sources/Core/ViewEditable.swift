//
//  ViewEditable.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/28/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol ViewEditable {
    var removeBtn: UIButton { get }
    var isAnimate: Bool { get set }
}

extension ViewEditable where Self: UIView {
    mutating func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999

        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle

        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()

        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        removeBtn.isHidden = false
        isAnimate = true
  }
    
    mutating func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        self.removeBtn.isHidden = true
        isAnimate = false
    }
}
