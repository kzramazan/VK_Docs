//
//  UITableView+Extension.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//


import UIKit
extension UITableView {
    
    /// Register UITableViewCell with Type
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        if Bundle.main.path(forResource: cellClass.identifier, ofType: "nib") != nil {
            register(UINib(nibName: cellClass.identifier, bundle: nil), forCellReuseIdentifier: cellClass.identifier)
        } else {
            register(cellClass, forCellReuseIdentifier: cellClass.identifier)
        }
    }
    /// Dequeuing UITableViewCell Type
    func dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellClass.identifier) as? T else {
            fatalError("Error: cannot dequeue cell with identifier: \(cellClass.identifier)")
        }
        return cell
    }
    /// Dequeuing with registration before
    func dequeueReusableCellWithRegistration<T: UITableViewCell>(_ cellClass: T.Type) -> T? {
        register(cellClass)
        let cell = dequeueReusableCell(cellClass)
        return cell
    }
    /// Remove TableFooterView.
    func removeTableFooterView() {
        tableFooterView = nil
    }
    
    /// Clear TableFooterView.
    func clearTableFooterView() {
        tableFooterView = UIView()
    }
}
