//
//  SectionDetailsViewController.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionDetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataProvider = SectionDetailsDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [SectionDetailsGalleryCell.self, SectionDetailsDescriptionCell.self, SectionDetailsActionCell.self].forEach {
            collectionView.register($0)
        }
        collectionView.delegate = dataProvider
        collectionView.dataSource = dataProvider
        dataProvider.delegate = self
        
        navigationItem.title = "Details"
    }
    
}
