//
//  UIViewControllerExtensions.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension UIViewController: UIInteractionDelegate {
    
    func showFinishAlert(newRating: Int) {
        let titleEnding = (newRating > 0) ? String(repeating: "★", count: newRating) : "None"
        let ac = UIAlertController(title: "Your rating\n" + titleEnding, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.navigationController?.popToRootViewController(animated: true)
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
