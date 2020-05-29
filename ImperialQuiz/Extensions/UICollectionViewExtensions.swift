//
//  UICollectionViewExtensions.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 28/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        let describingString = String(describing: cellType)
        let nib = UINib(nibName: describingString, bundle: nil)
        register(nib, forCellWithReuseIdentifier: describingString)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath, configuration: ((T) -> Void)? ) -> T {
        let describingString = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: describingString, for: indexPath) as? T else { fatalError("Invalid Cell Type") }
        configuration?(cell)
        return cell
    }
    
}
