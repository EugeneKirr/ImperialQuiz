//
//  UIInteractionDelegate.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol UIInteractionDelegate: AnyObject {
    
    var navigationController: UINavigationController? { get }
    
    func showFinishAlert(newRating: Int)
    
    func showDeleteAlert(title: String, completion: @escaping () -> Void)
    
}
