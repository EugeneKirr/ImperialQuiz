//
//  SectionListViewController.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataProvider = SectionListDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells([.sectionListCell])
        collectionView.delegate = dataProvider
        collectionView.dataSource = dataProvider
        dataProvider.delegate = self
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .lightGray
        navigationController?.navigationBar.tintColor = .darkText
        navigationItem.title = "Section List"
    }

}
