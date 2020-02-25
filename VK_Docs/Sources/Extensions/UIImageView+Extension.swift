//
//  UIImageView+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageFromUrl(urlString: String) {
        
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        
        
        Alamofire.request(url)
            .validate()
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    guard let data = response.data else { return }
                    let imageToCache = UIImage(data: data)
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    if let imageToCache = imageToCache {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                }
        }
    }
}

extension CALayer {
    func addGradientBorder(colors:[UIColor],width:CGFloat = 1) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        
        gradientLayer.startPoint = CGPoint(x:0.0, y:0.0)
        gradientLayer.endPoint = CGPoint(x:1.0,y:1.0)
        gradientLayer.colors = colors.map({$0.cgColor})

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = shapeLayer

        self.addSublayer(gradientLayer)
    }
}
