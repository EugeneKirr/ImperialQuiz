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

extension UIViewController {
    
    func showFinishAlert(newRating: Int) {
        let titleEnding = (newRating > 0) ? String(repeating: "★", count: newRating) : "None"
        let ac = UIAlertController(title: "Your rating\n" + titleEnding, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.popToRootVC()
        }
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
    func showDeleteAlert(title: String, completion: @escaping () -> Void) {
        let ac = UIAlertController(title: "Delete section \(title)?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            completion()
        }
        let no = UIAlertAction(title: "No", style: .default, handler: nil)
        ac.addAction(yes)
        ac.addAction(no)
        present(ac, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func showNetworkErrorAlert(_ error: NetworkErrors) {
        let ac = UIAlertController(title: error.description, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
}
