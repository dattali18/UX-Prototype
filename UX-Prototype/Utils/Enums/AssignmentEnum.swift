//
//  AssignmentEnum.swift
//  UX-Prototype
//
//  Created by Daniel Attali on 10/12/23.
//

import Foundation

enum AssignmentEnum: CustomStringConvertible {
    case homework
    case midterm
    case final
    
    init(description: String?) {
        if(description == nil) {
            fatalError("Invalid semester string")
        }
        
        switch description {
        case "Homework":
            self = .homework
        case "Midterm":
            self = .midterm
        case "Final":
            self = .final
        default:
            fatalError("Invalid semester string")
        }
    }
    
    var description: String {
        switch self {
        case .homework:
            return "Homework"
        case .midterm:
            return "Midterm"
        case .final:
            return "Final"
        }
    }
    
    var num: Int {
        switch self {
        case .homework:
            return 0
        case .midterm:
            return 1
        case .final:
            return 2
        }
    }
}
