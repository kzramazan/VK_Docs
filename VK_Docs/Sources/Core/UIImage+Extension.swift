//
//  UIImage+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/21/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(size : CGSize) -> UIImage {
        
        let refWidth : CGFloat = CGFloat(self.cgImage!.width)
        let refHeight : CGFloat = CGFloat(self.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        let imageRef = cgImage!.cropping(to: cropRect)!
        
        let cropped : UIImage = UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
        return cropped
    }
    
    func resize(newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}
