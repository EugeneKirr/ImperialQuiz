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
    
    private let necronsDescription = "The Necrons are a mysterious race of robotic skeletal warriors that have lain dormant in their stasis-tombs for more than 60 million Terran years and who are the soulless creations and former servants of the ancient C'tan, the terrible Star Gods of Aeldari myth."
    private let necronsImages = [UIImage(named:"necrons_gallery_0")!, UIImage(named:"necrons_gallery_1")!, UIImage(named:"necrons_gallery_2")!, UIImage(named:"necrons_gallery_3")!, UIImage(named:"necrons_gallery_4")!, UIImage(named:"necrons_gallery_5")!, UIImage(named:"necrons_gallery_6")!]
    
    
    private func fetchDefaultSections() -> [Section] {
//        let orksSection = Section(title: "Orks", listImage: UIImage(named:"orks_list")!, description: orksDescription, galleryImages: orksImages, rating: 0)
//        let smSection = Section(title: "Space Marines", listImage: UIImage(named:"sm_list")!, description: smDescription, galleryImages: smImages, rating: 0)
//        let necronsSection = Section(title: "Necrons", listImage: UIImage(named: "necrons_list")!, description: necronsDescription, galleryImages: necronsImages, rating: 0)
        return [Section]()
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
            dict["rating"] = section.rating
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
        let rating = dictionary["rating"] as? Int ?? 0
        let section = Section(title: title, listImage: listImage, description: description, galleryImages: galleryImages, rating: rating)
        return section
    }

}

extension SectionManager {
    
    func updateSectionRating(with newValue: Int, sectionTitle: String, successCompletion: (() -> Void)? ) {
        guard let plistData = try? Data(contentsOf: sectionsPlistURL),
              var dicts = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String : Any]],
              let index = dicts.firstIndex(where: { $0["title"] as? String == sectionTitle }),
              let oldValue = dicts[index]["rating"] as? Int, oldValue < newValue else { return }
        dicts[index].updateValue(newValue, forKey: "rating")
        guard let updatedPlistData = try? PropertyListSerialization.data(fromPropertyList: dicts, format: .xml, options: .zero) else { fatalError() }
        try? updatedPlistData.write(to: sectionsPlistURL, options: .atomic)
        successCompletion?()
    }
    
}

extension SectionManager {
    
    func addNewSection(from rawModel: RawSectionData) {
        var images = [UIImage]()
        for imageString in rawModel.images {
            guard let imageURL = URL(string: imageString),
                  let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData) else { continue }
            images.append(image)
        }
//        let newSection = Section(title: rawModel.title,
//                                 listImage: images.removeFirst(),
//                                 description: rawModel.description,
//                                 galleryImages: images)
        let newSection = Section(title: rawModel.title, description: rawModel.description)
        var updatedSections = fetchSections()
        updatedSections.append(newSection)
        saveSections(updatedSections)
    }
    
}

extension SectionManager {
    
    func deleteSection(at sectionIndex: Int) {
        var updatedSections = fetchSections()
        let removedSection = updatedSections.remove(at: sectionIndex)
        saveSections(updatedSections)
        FileManager.default.deleteSectionAssociatedFiles(sectionTitle: removedSection.title)
    }
    
}
