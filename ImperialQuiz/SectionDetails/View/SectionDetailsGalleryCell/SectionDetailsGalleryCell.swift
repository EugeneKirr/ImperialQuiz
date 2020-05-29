//
//  SectionDetailsGalleryCell.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionDetailsGalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryView: UICollectionView!
    
    let dataProvider = GalleryDataProvider()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        galleryView.register(GalleryImageCell.self)
        galleryView.delegate = dataProvider
        galleryView.dataSource = dataProvider
    }
    
}
