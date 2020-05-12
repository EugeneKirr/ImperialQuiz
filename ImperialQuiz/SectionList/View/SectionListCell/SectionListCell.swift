//
//  SectionListCell.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionListCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sectionImageView: UIImageView!
    
    func loadView(_ section: Section) {
        titleLabel.text = section.title
        sectionImageView.image = section.listImage
    }

}
