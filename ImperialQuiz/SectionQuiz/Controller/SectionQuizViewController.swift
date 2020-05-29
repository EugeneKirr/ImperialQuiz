//
//  SectionQuizViewController.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionQuizViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataProvider = SectionQuizDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [SectionQuizImageCell.self, SectionQuizOptionCell.self, SectionQuizActionCell.self].forEach {
            collectionView.register($0)
        }
        collectionView.delegate = dataProvider
        collectionView.dataSource = dataProvider
        dataProvider.delegate = self
        
        navigationItem.title = dataProvider.sectionTitle
    }

}
