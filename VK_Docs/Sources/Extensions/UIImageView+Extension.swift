//
//  UIImageView+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

//import Alamofire
//
//let imageCache = NSCache<AnyObject, AnyObject>()
//
//class CustomImageView: UIImageView {
//    var imageUrlString: String?
//    func loadImageFromUrl(urlString: String) {
//        
//        imageUrlString = urlString
//        guard let url = URL(string: urlString) else { return }
//        image = nil
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//        
//        
//        
//        Alamofire.request(url)
//            .validate()
//            .responseJSON { (response) in
//                DispatchQueue.main.async {
//                    guard let data = response.data else { return }
//                    let imageToCache = UIImage(data: data)
//                    print("Getting image")
//                    if self.imageUrlString == urlString {
//                        self.image = imageToCache
//                    }
//                    if let imageToCache = imageToCache {
//                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
//                    }
//                }
//        }
//    }
//}
