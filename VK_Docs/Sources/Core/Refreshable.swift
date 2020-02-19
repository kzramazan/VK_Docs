//
//  Refreshable.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/19/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol Refreshable {
    var refreshControl: UIRefreshControl { get }
    
    func stopRefreshing()
    func startRefreshing()
    
}

extension Refreshable {
    func stopRefreshing() {
        DispatchQueue.main.async {
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func startRefreshing() {
        DispatchQueue.main.async {
            if !self.refreshControl.isRefreshing {
                self.refreshControl.beginRefreshing()
            }
        }
    }
}
