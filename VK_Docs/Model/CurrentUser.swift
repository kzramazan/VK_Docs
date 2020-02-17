//
//  CurrentUser.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

class CurrentUser: NSObject {
    let id: Int?
    let firstName: String?
    let lastName: String?
    
    static var shared: CurrentUser? {
        get {
            return CurrentUser(dict: UserDefaults.standard.object(forKey: Constants.sharedProfile) as? NSDictionary)
        }
        set {
            if let user = newValue {
                UserDefaults.standard.set(getDictFromCurrentUser(user: user), forKey: Constants.sharedProfile)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.sharedProfile)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    init(id: Int, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(dict: NSDictionary?) {
        self.id = dict?["id"] as? Int
        self.firstName = dict?["first_name"] as? String
        self.lastName = dict?["lastName"] as? String
    }
    
    init(object: NSObject?) {
        self.id = object?.value(forKey: "id") as? Int ?? nil
        self.firstName = object?.value(forKey: "first_name") as? String ?? nil
        self.lastName = object?.value(forKey: "last_name") as? String ?? nil
    }
    
    class func getDictFromCurrentUser(user: CurrentUser?) -> NSDictionary {
        guard let user = user else { return [:]}
        return ["first_name": user.firstName!, "last_name": user.lastName!, "id": user.id!]
    }
}
