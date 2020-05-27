//
//  FileManagerExtensions.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 13/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

extension FileManager {
    
    func createSectionDirectoriesIfNeeded(sectionTitle: String) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let newDirURL = docDirURL.appendingPathComponent("Sections/\(sectionTitle)/Images/Units/", isDirectory: true)
        guard !FileManager.default.fileExists(atPath: newDirURL.path) else { return }
        try? FileManager.default.createDirectory(at: newDirURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    func createNewImageFile(in category: ProjectCategories, sectionTitle: String, imageName: String, image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let imagePath = getImagePath(in: category, sectionTitle: sectionTitle, imageName: imageName)
        FileManager.default.createFile(atPath: imagePath, contents: imageData, attributes: nil)
    }
    
    func deleteImageFile(in category: ProjectCategories, sectionTitle: String, imageName: String) {
        let imagePath = getImagePath(in: category, sectionTitle: sectionTitle, imageName: imageName)
        try? FileManager.default.removeItem(atPath: imagePath)
    }
    
    func getImagePath(in category: ProjectCategories, sectionTitle: String, imageName: String) -> String {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        switch category {
        case .sections: return docDirURL.appendingPathComponent("Sections/\(sectionTitle)/Images/\(imageName)").path
        case .units: return docDirURL.appendingPathComponent("Sections/\(sectionTitle)/Images/Units/\(imageName)").path
        }
    }
    
    func getSectionsPlistURL() -> URL {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        return docDirURL.appendingPathComponent("Sections/sections.plist")
    }
    
    func getUnitsPlistURL(sectionTitle: String) -> URL {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        return docDirURL.appendingPathComponent("Sections/\(sectionTitle)/units.plist")
    }
    
}

extension FileManager {
    
    func deleteSectionAssociatedFiles(sectionTitle: String) {
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        let sectionURL = docDirURL.appendingPathComponent("Sections/\(sectionTitle)", isDirectory: true)
        try? FileManager.default.removeItem(at: sectionURL)
    }
    
}
