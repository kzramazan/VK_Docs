//
//  Units.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

public struct Units {
  
  public let bytes: Int64
  
  public var kilobytes: Double {
    return Double(bytes) / 1_024
  }
  
  public var megabytes: Double {
    return kilobytes / 1_024
  }
  
  public var gigabytes: Double {
    return megabytes / 1_024
  }
  
  public init(bytes: Int64) {
    self.bytes = bytes
  }
  
  public func getReadableUnit() -> String {
    
    switch bytes {
    case 0..<1_024:
      return "0 КБ"
    case 1_024..<(1_024 * 1_024):
      return "\(String(format: "%.2f", kilobytes)) КБ"
    case 1_024..<(1_024 * 1_024 * 1_024):
      return "\(String(format: "%.2f", megabytes)) МБ"
    case (1_024 * 1_024 * 1_024)...Int64.max:
      return "\(String(format: "%.2f", gigabytes)) ГБ"
    default:
      return "0 КБ"
    }
  }
}
