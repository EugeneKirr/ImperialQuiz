//
//  ProjectCells.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 07/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import Foundation

enum ProjectCells {
    
    case sectionListCell
    case sectionListPlaceholder
    case sectionDetailsGalleryCell
    case sectionDetailsDescriptionCell
    case sectionDetailsActionCell
    case sectionQuizImageCell
    case sectionQuizOptionCell
    case sectionQuizActionCell
    case galleryImageCell
    
}

extension ProjectCells {
    
    var identifier: String {
        switch self {
        case .sectionListCell: return "sectionListCell"
        case .sectionListPlaceholder: return "sectionListPlaceholder"
        case .sectionDetailsGalleryCell: return "sectionDetailsGalleryCell"
        case .sectionDetailsDescriptionCell: return "sectionDetailsDescriptionCell"
        case .sectionDetailsActionCell: return "sectionDetailsActionCell"
        case .sectionQuizImageCell: return "sectionQuizImageCell"
        case .sectionQuizOptionCell: return "sectionQuizOptionCell"
        case .sectionQuizActionCell: return "sectionQuizActionCell"
        case .galleryImageCell: return "galleryImageCell"
        }
    }
    
    var xibName: String {
        switch self {
        case .sectionListCell: return "SectionListCell"
        case .sectionListPlaceholder: return "SectionListPlaceholder"
        case .sectionDetailsGalleryCell: return "SectionDetailsGalleryCell"
        case .sectionDetailsDescriptionCell: return "SectionDetailsDescriptionCell"
        case .sectionDetailsActionCell: return "SectionDetailsActionCell"
        case .sectionQuizImageCell: return "SectionQuizImageCell"
        case .sectionQuizOptionCell: return "SectionQuizOptionCell"
        case .sectionQuizActionCell: return "SectionQuizActionCell"
        case .galleryImageCell: return "GalleryImageCell"
        }
    }
    
}
