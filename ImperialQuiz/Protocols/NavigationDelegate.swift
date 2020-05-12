//
//  NavigationDelegate.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 08/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol NavigationDelegate: AnyObject {
    
    func initializeAndPush(viewController: ProjectVCs, completion: ((UIViewController) -> Void)? )
    
    func popToParentVC()
    
    func popToRootVC()

}
