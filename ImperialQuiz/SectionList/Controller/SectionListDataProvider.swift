//
//  SectionListDataProvider.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionListDataProvider: NSObject {
    
    private let sectionManager = SectionManager()
    
    weak var delegate: NavigationDelegate?
    
    var currentSections: [Section] {
        return sectionManager.fetchSections()
    }
    
    var isSectionRemovingActivated = false
    
}

extension SectionListDataProvider: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureReusableProjectCell(collectionView, indexPath, .sectionListCell) { (cell: SectionListCell) in
            cell.loadView(currentSections[indexPath.row])
        }
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch isSectionRemovingActivated {
        case true:
            delegate?.showDeleteAlert(title: currentSections[indexPath.row].title) { [weak self, weak collectionView] in
                self?.sectionManager.deleteSection(at: indexPath.row)
                collectionView?.deleteItems(at: [indexPath])
            }
        case false:
            delegate?.initializeAndPush(viewController: .sectionDetailsVC) { [weak self] (vc) in
                guard let self = self, let detailsVC = vc as? SectionDetailsViewController else { return }
                detailsVC.dataProvider.sectionOfInterest = self.currentSections[indexPath.row]
            }
        }
    }
    
}

extension SectionListDataProvider: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 0.25 * collectionView.bounds.height)
    }
    
}


extension SectionListDataProvider {
    
    func createNewSection(from rawModel: RawSectionData, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let quizManager = QuizUnitManager()
            quizManager.addNewQuizUnits(from: rawModel.units, for: rawModel.title)
            self?.sectionManager.addNewSection(from: rawModel)
            NotificationManager.shared.scheduleNewSectionLocalNotification(title: rawModel.title)
            DispatchQueue.main.async { completion() }
        }
    }
    
}
