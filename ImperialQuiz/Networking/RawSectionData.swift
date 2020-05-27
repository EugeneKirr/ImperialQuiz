//
//  RawSectionData.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 25/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

struct RawSectionData: Codable {
    
    let title: String
    let description: String
    let images: [String]
    let units: [RawUnitData]
    
}

struct RawUnitData: Codable {
    
    let name: String
    let image: String
    
}
