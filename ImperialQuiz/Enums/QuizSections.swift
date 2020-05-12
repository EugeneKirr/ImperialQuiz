//
//  QuizSections.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 12/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum QuizSections: Int, CaseIterable {
    case image
    case options
    case confirm
    
    init(_ section: Int) {
        guard let caseValue = QuizSections(rawValue: section) else { fatalError("Invalid Section") }
        self = caseValue
    }
}
