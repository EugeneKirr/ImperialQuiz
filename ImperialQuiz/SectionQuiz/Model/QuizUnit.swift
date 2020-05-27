//
//  QuizUnit.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

struct QuizUnit {
    
    let sectionTitle: String
    let name: String
    let image: UIImage
    
    init(sectionTitle: String = "", name: String, image: UIImage = UIImage(named: "Default")!) {
        self.sectionTitle = sectionTitle
        self.name = name
        self.image = image
    }
    
}
