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
    
    weak var delegate: UIInteractionDelegate?
    
    var currentSections: [Section] {
        return sectionManager.fetchSections()
    }
    
    var isSectionRemovingActivated = false
    
}

extension SectionListDataProvider: UICollectionViewDelegate, UICollectionViewDataSource, VCInitializationDelegate {
    
    // MARK: - DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(SectionListCell.self, for: indexPath) { [currentSections] cell in
            cell.loadView(currentSections[indexPath.row])
        }
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch isSectionRemovingActivated {
        case true:
            delegate?.showDeleteAlert(title: currentSections[indexPath.row].title) { [weak sectionManager, weak collectionView] in
                sectionManager?.deleteSection(at: indexPath.row)
                collectionView?.deleteItems(at: [indexPath])
            }
        case false:
            let vc = initializeViewController(SectionDetailsViewController.self)
            vc.dataProvider.sectionOfInterest = currentSections[indexPath.row]
            delegate?.navigationController?.pushViewController(vc, animated: true)
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
        DispatchQueue.global(qos: .background).async { [weak sectionManager] in
            let quizManager = QuizUnitManager()
            quizManager.addNewQuizUnits(from: rawModel.units, for: rawModel.title)
            sectionManager?.addNewSection(from: rawModel)
            NotificationManager.shared.scheduleNewSectionLocalNotification(title: rawModel.title)
            DispatchQueue.main.async { completion() }
        }
    }
    
}
