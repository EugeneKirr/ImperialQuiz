//
//  SectionListPlaceholder.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 25/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionListPlaceholder: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
    }
    
}
