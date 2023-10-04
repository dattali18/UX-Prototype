//
//  SemesterEnum.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/4/23.
//

import Foundation

enum SemesterEnum: CustomStringConvertible {
    case spring
    case summer
    case fall
    
    var description: String {
        switch self {
        case .spring:
            return "Spring"
        case .summer:
            return "Summer"
        case .fall:
            return "Fall"
        }
    }
}
