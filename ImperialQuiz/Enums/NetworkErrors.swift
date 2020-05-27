//
//  NetworkErrors.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 25/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    
    case url
    case data
    case decode
    
}

extension NetworkErrors {
    
    var id: Int {
        switch self {
        case .url: return 101
        case .data: return 102
        case .decode: return 103
        }
    }
    
    var description: String {
        switch self {
        case .url: return "\(id). Invalid server URL"
        case .data: return "\(id). No JSON data received"
        case .decode: return "\(id). Invalid decoding result"
        }
    }
    
}
