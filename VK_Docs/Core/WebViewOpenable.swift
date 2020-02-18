//
//  WebViewOpenable.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol WebViewOpenable: class {
    ///Return UIViewController with loading content web view
    func getLoadedWebViewVC(with url: URL?) -> UIViewController?
}

extension WebViewOpenable {
    func getLoadedWebViewVC(with url: URL?) -> UIViewController? {
        guard let url = url else { return nil }
        let vc = WebViewController()
        vc.loadWebView(url: url)
        return vc
    }
}
