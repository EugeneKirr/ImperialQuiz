//
//  SectionDetailsDataProvider.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionDetailsDataProvider: NSObject {
    
    var sectionOfInterest = Section(title: "")
    
    weak var delegate: UIInteractionDelegate?
    
}

extension SectionDetailsDataProvider: UICollectionViewDelegate, UICollectionViewDataSource, VCInitializationDelegate {
    
    // MARK: - DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DetailsSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let detailsSection = DetailsSections(section)
        switch detailsSection {
        case .gallery: return 1
        case .description: return 1
        case .actions: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailsSection = DetailsSections(indexPath.section)
        switch detailsSection {
        case .gallery:
            return collectionView.dequeueReusableCell(SectionDetailsGalleryCell.self, for: indexPath) { [sectionOfInterest] cell in
                cell.dataProvider.images = sectionOfInterest.galleryImages
            }
        case .description:
            return collectionView.dequeueReusableCell(SectionDetailsDescriptionCell.self, for: indexPath) { [sectionOfInterest] cell in
                cell.loadView(sectionOfInterest.title, sectionOfInterest.description)
            }
        case .actions:
            return collectionView.dequeueReusableCell(SectionDetailsActionCell.self, for: indexPath) { cell in
                cell.actionLabel.text = "Start"
            }
        }
        
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsSection = DetailsSections(indexPath.section)
        switch detailsSection {
        case .gallery, .description: return
        case .actions:
            let vc = initializeViewController(SectionQuizViewController.self)
            vc.dataProvider.sectionTitle = sectionOfInterest.title
            delegate?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SectionDetailsDataProvider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let detailsSection = DetailsSections(indexPath.section)
        switch detailsSection {
        case .gallery: return CGSize(width: collectionView.bounds.width, height: 0.5 * collectionView.bounds.height)
        case .description: return CGSize(width: collectionView.bounds.width, height: 0.4 * collectionView.bounds.height)
        case .actions: return CGSize(width: collectionView.bounds.width, height: 0.1 * collectionView.bounds.height)
        }
    }
    
}
