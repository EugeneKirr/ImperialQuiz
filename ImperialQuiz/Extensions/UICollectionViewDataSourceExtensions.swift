//
//  UICollectionViewDataSourceExtensions.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 11/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UICollectionViewDataSource {
    
    func configureReusableProjectCell<C: UICollectionViewCell>(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ projectCell: ProjectCells, configuration: (C) -> Void) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: projectCell.identifier, for: indexPath) as? C else { fatalError("Invalid Cell Type") }
        configuration(cell)
        return cell
    }
    
}

