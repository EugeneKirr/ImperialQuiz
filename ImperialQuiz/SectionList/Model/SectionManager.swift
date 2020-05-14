//
//  SectionManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionManager {
    
    private let smDescription = "The Space Marine Legions, or the Legiones Astartes in High Gothic, were the original unit formations of the Space Marines created during the First Founding by the Emperor of Mankind on Terra in the late 30th Millennium."
    private let smImages = [UIImage(named:"sm_gallery_0")!, UIImage(named:"sm_gallery_1")!, UIImage(named:"sm_gallery_2")!, UIImage(named:"sm_gallery_3")!]
    
    private let orksDescription = "The Orks, also called greenskins, are a savage, warlike, green-skinned species of humanoids who are spread all across the Milky Way Galaxy."
    private let orksImages = [UIImage(named:"orks_gallery_0")!, UIImage(named:"orks_gallery_1")!, UIImage(named:"orks_gallery_2")!, UIImage(named:"orks_gallery_3")!, UIImage(named:"orks_gallery_4")!]
    
    private func fetchDefaultSections() -> [Section] {
        let orksSection = Section(title: "Orks", listImage: UIImage(named:"orks_list")!, description: orksDescription, galleryImages: orksImages)
        let smSection = Section(title: "Space Marines", listImage: UIImage(named:"sm_list")!, description: smDescription, galleryImages: smImages)
        return [smSection, orksSection]
    }
    
}

extension SectionManager {
    
    private var sectionsPlistURL: URL {
        return FileManager.default.getSectionsPlistURL()
    }
    
    private func saveSections(_ sections: [Section]) {
        for section in sections {
            FileManager.default.createSectionDirectoriesIfNeeded(sectionTitle: section.title)
        }
        createImages(from: sections)
        let dicts = createDictionaries(from: sections)
        guard let plistData = try? PropertyListSerialization.data(fromPropertyList: dicts, format: .xml, options: .zero) else { fatalError() }
        try? plistData.write(to: sectionsPlistURL, options: .atomic)
    }
    
    private func createDictionaries(from sections: [Section]) -> [[String: Any]] {
        var dicts = [[String: Any]]()
        for section in sections {
            var dict: [String : Any] = [:]
            dict["title"] = section.title
            dict["listImageName"] = section.title.lowercased().split(separator: " ").joined(separator: "_") + "_list.png"
            dict["description"] = section.description
            var galleryImageNames = [String]()
            for index in 0..<section.galleryImages.count {
                let imageName = section.title.lowercased().split(separator: " ").joined(separator: "_") + "_gallery_\(index).png"
                galleryImageNames.append(imageName)
            }
            dict["galleryImageNames"] = galleryImageNames
            dicts.append(dict)
        }
        return dicts
    }
    
    private func createImages(from sections: [Section]) {
        for section in sections {
            let listImageName = section.title.lowercased().split(separator: " ").joined(separator: "_") + "_list.png"
            FileManager.default.createNewImageFile(in: .sections, sectionTitle: section.title, imageName: listImageName, image: section.listImage)
            for index in 0..<section.galleryImages.count {
                let galleryImageName = section.title.lowercased().split(separator: " ").joined(separator: "_") + "_gallery_\(index).png"
                FileManager.default.createNewImageFile(in: .sections, sectionTitle: section.title, imageName: galleryImageName, image: section.galleryImages[index])
            }
        }
    }
    
}

extension SectionManager {
    
    func fetchSections() -> [Section] {
        var sections = [Section]()
        guard let plistData = try? Data(contentsOf: sectionsPlistURL),
              let dicts = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String : Any]] else {
                print("using default sections")
                let defaultSections = fetchDefaultSections()
                saveSections(defaultSections)
                return defaultSections
        }
        for dict in dicts {
            let section = createSection(from: dict)
            sections.append(section)
        }
        print("using sections.plist")
        return sections
    }
    
    private func createSection(from dictionary: [String: Any]) -> Section {
        let title = dictionary["title"] as? String ?? "Default"
        let description = dictionary["description"] as? String ?? "Default"
        let listImage: UIImage = {
            let imageName = dictionary["listImageName"] as? String ?? ""
            let imagePath = FileManager.default.getImagePath(in: .sections, sectionTitle: title, imageName: imageName)
            return UIImage(contentsOfFile: imagePath) ?? UIImage(named: "Default")!
        }()
        let galleryImages: [UIImage] = {
            var galleryImages = [UIImage]()
            let galleryNames = dictionary["galleryImageNames"] as? [String] ?? [String]()
            for galleryImageName in galleryNames {
                let imagePath = FileManager.default.getImagePath(in: .sections, sectionTitle: title, imageName: galleryImageName)
                guard let image = UIImage(contentsOfFile: imagePath) else { continue }
                galleryImages.append(image)
            }
            return galleryImages
        }()
        let section = Section(title: title, listImage: listImage, description: description, galleryImages: galleryImages)
        return section
    }

}
