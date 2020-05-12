//
//  UIViewControllerExtensions.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func registerCells(_ cells: [ProjectCells]) {
        for cell in cells {
            let nib = UINib(nibName: cell.xibName, bundle: nil)
            guard let collectionView = self.view as? UICollectionView else { return }
            collectionView.register(nib, forCellWithReuseIdentifier: cell.identifier)
        }
    }
    
}

extension UIViewController: NavigationDelegate {
    
    func initializeAndPush(viewController: ProjectVCs, completion: ((UIViewController) -> Void)?) {
        let storyboard = UIStoryboard(name: viewController.storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: viewController.vcIdentifier)
        self.navigationController?.pushViewController(viewController, animated: true)
        completion?(viewController)
    }
    
    func popToParentVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRootVC() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
