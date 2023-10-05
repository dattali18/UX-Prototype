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
    
    init(description: String?) {
        if(description == nil) {
            fatalError("Invalid semester string")
        }
        
        switch description {
        case "Spring":
            self = .spring
        case "Summer":
            self = .summer
        case "Fall":
            self = .fall
        default:
            fatalError("Invalid semester string")
        }
    }
    
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
    
    var num: Int {
        switch self {
        case .spring:
            return 0
        case .summer:
            return 1
        case .fall:
            return 2
        }
    }
}


func semesterFromString(str: String) -> SemesterEnum? {
    let semesterString: String? = str.split(separator: " ")[0].description
    let semester = SemesterEnum(description: semesterString)
    return semester
}
