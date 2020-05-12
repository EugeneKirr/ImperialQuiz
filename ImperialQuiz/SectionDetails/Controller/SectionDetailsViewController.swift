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
        registerCells([.sectionDetailsGalleryCell, .sectionDetailsDescriptionCell, .sectionDetailsActionCell])
        collectionView.delegate = dataProvider
        collectionView.dataSource = dataProvider
        dataProvider.delegate = self
        
        navigationItem.title = "Details"
    }
    
}
