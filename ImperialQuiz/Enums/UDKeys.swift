//
//  UDKeys.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/06/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum UDKeys {
    
    case isFirstLaunchHappened
    
}

extension UDKeys {
    
    var key: String {
        switch self {
        case .isFirstLaunchHappened: return "isFirstLaunchHappened"
        }
    }
    
}
