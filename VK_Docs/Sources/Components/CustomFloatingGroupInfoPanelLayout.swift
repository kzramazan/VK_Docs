//
//  Custompanel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/25/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import FloatingPanel

class CustomFloatingGroupInfoPanelLayout: FloatingPanelLayout {
    var contentHeight: CGFloat = 0
    
    var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    var supportedPositions: Set<FloatingPanelPosition> = [.full]
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return UIScreen.main.bounds.height > contentHeight ? UIScreen.main.bounds.height - contentHeight : UIScreen.main.bounds.height
        default:
            return nil
        }
    }
}
