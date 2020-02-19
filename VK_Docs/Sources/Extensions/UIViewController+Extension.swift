//
//  UIViewController+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    
    class func instantiateFromStoryboard() -> Self {
        return instantiate()
    }
    
    private class func instantiate<T>() -> T {
        let name = "\(T.self)"
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name) as! T
    }
    
}
