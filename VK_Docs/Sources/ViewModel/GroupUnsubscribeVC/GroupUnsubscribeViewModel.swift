//
//  GroupUnsubscribeViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/22/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Pods_VK_Docs

class GroupUnsubscribeViewModel {
    private var groupList: [VKGroup] = []
    
    private var groupCellSelected: [Bool] = []
    var groupSelectionCompletion: (() -> Void)?
    
    func fetchGroupList(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        VKApiUsers.init().getSubscriptions(["extended": true, "count": 200, "fields": "description,members_count"]).execute(resultBlock: { [weak self] (response) in
            guard let self = self, let dict = response?.json as? [AnyHashable: Any],
                let items = dict["items"] as? [Any], let groups = VKGroups(array: items) else {
                failure(nil)
                return
            }
            self.groupList.removeAll()
            self.groupCellSelected.removeAll()
            print(groups.count)
            for i in 0...groups.count - 1 {
                let row = Int(i)
                print(groups.object(at: row)?.id)
                self.groupList.append(groups.object(at: row))
                self.groupCellSelected.append(false)
            }
            success()
        }, errorBlock: { (error) in
            failure(error?.localizedDescription)
        })
    }
    
//    func getDetailedGroupInfo(groupID: Int, success: @escaping () -> Void, failure: @escaping ErrorCompletion) {
//        VKApiGroups.init().getById(["id": groupID, ])?.execute(resultBlock: { (response) in
//
//        }, errorBlock: { (error) in
//            failure(error?.localizedDescription)
//        })
//    }
    
    
//    Optional(88229325)
//    Optional(97324424)
//    Optional(100611136)
//    Optional(101241966)
//    Optional(7710305)
//    Optional(166319830)
//    Optional(227788442)
    func deleteGroupList() {
        VKApiGroups.init().prepareRequest(withMethodName: "groups.leave", parameters: [VK_API_GROUP_ID: 101241966.description])?.execute(resultBlock: { (response) in
            
            print("Response: ", response)
        }, errorBlock: { (error) in
            print("Error: ", error?.localizedDescription)
        })
    }
    
    
    func getGroupList() -> [VKGroup] {
        return groupList
    }
    
    func getNumberOfGroups() -> Int {
        return groupList.count
    }
    
    func groupIsSelected(row: Int) -> Bool {
        return groupCellSelected[row]
    }
    
    func getGroupVK(row: Int) -> VKGroup {
        return groupList[row]
    }
    
    func handleGroupSelection(row: Int) {
        groupCellSelected[row] = !groupCellSelected[row]
        groupSelectionCompletion?()
    }
    
    func getNumberOfGroupsSelected() -> Int {
        let result = groupCellSelected.filter { $0 == true }
        return result.count
    }
    
    
}
