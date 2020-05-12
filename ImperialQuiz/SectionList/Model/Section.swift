//
//  Section.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

struct Section: Equatable {
    
    let title: String
    let listImage: UIImage
    let description: String
    let galleryImages: [UIImage]
    
    init(title: String, listImage: UIImage = UIImage(named: "Default")!, description: String = "", galleryImages: [UIImage] = [UIImage]() ) {
        self.title = title
        self.listImage = listImage
        self.description = description
        self.galleryImages = galleryImages
    }
    
}
