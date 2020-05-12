//
//  SectionDetailsDescriptionCell.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionDetailsDescriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func loadView(_ title: String, _ description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}
