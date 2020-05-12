//
//  ProjectVCs.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum ProjectVCs {
    
    case sectionListVC
    case sectionDetailsVC
    case sectionQuizVC
    
}

extension ProjectVCs {
    
    var storyboardName: String {
        switch self {
        case .sectionListVC: return "SectionList"
        case .sectionDetailsVC: return "SectionDetails"
        case .sectionQuizVC: return "SectionQuiz"
        }
    }

}

extension ProjectVCs {

    var vcIdentifier: String {
        switch self {
        case .sectionListVC: return "sectionListViewController"
        case .sectionDetailsVC: return "sectionDetailsViewController"
        case .sectionQuizVC: return "sectionQuizViewController"
        }
    }
    
}
