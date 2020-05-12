//
//  DetailsSections.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 12/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum DetailsSections: Int, CaseIterable {
    case gallery
    case description
    case actions
    
    init(_ section: Int) {
        guard let caseValue = DetailsSections(rawValue: section) else { fatalError("Invalid Section") }
        self = caseValue
    }
}
