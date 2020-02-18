//
//  QuickLookOpenable.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol QuickLookOpenable: class {
    ///Return UIViewController with loading image
    func getLoadedQuickLookVC(with url: URL?) -> UIViewController?
}

extension QuickLookOpenable {
    func getLoadedQuickLookVC(with url: URL?) -> UIViewController? {
        guard let url = url else { return nil }
        let vc = QuickLookImageVC()
        vc.loadImage(urlPath: url.absoluteString)
        return vc
    }
}
