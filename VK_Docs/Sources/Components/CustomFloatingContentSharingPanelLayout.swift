//
//  CustomFloatingPanelLayout.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/21/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation
import FloatingPanel

class CustomFloatingContentSharingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .full
    }
    
    var supportedPositions: Set<FloatingPanelPosition> = [.full]
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return UIScreen.main.bounds.height / 2.7
        default:
            return nil
        }
    }
    
    
}

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
