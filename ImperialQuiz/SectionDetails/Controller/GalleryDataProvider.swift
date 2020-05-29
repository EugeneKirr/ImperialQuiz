//
//  GalleryDataProvider.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class GalleryDataProvider: NSObject {
    
    var images = [UIImage]()
    
}

extension GalleryDataProvider: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(GalleryImageCell.self, for: indexPath) { [images] cell in
            cell.galleryImageView.image = images[indexPath.row]
            switch indexPath.row {
            case 0: cell.galleryImageView.contentMode = .scaleAspectFit
            default: cell.galleryImageView.contentMode = .scaleAspectFill
            }
        }
        
    }
    
}

extension GalleryDataProvider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.9 * collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
