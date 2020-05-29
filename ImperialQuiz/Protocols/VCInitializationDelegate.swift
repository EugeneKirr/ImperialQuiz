//
//  VCInitializationDelegate.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 28/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

protocol VCInitializationDelegate: AnyObject {
    
    func initializeViewController<T: UIViewController>(_: T.Type) -> T

}

extension VCInitializationDelegate {
    
    func initializeViewController<T: UIViewController>(_: T.Type) -> T {
        let vcIdentifier = String(describing: T.self)
        let sbName = String(vcIdentifier.dropLast("ViewController".count))
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(identifier: vcIdentifier) as T
        return vc
    }
    
}
