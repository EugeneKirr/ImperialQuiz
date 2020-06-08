//
//  QuizUnitManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class QuizUnitManager {
    
    private let imageStorageString = "https://s7.gifyu.com/images/"
    
    private var quizUnits = [QuizUnit]()

}
    
extension QuizUnitManager {
    
    func fetchQuizRoundsCount() -> Int {
        return quizUnits.count
    }
    
    func prepareQuizUnits(for sectionTitle: String) {
        var preparedUnits = [QuizUnit]()
        let unitsPlistURL = FileManager.default.getUnitsPlistURL(sectionTitle: sectionTitle)
        guard let plistData = try? Data(contentsOf: unitsPlistURL),
              let dicts = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]] else {
                return
        }
        for dict in dicts {
            let unit = createQuizUnit(from: dict)
            preparedUnits.append(unit)
        }
        quizUnits = preparedUnits.shuffled()
    }
    
    private func createQuizUnit(from dictionary: [String: Any]) -> QuizUnit {
        let sectionTitle = dictionary["sectionTitle"] as? String ?? "Default"
        let name = dictionary["name"] as? String ?? "Default"
        let image: UIImage = {
            let imageName = dictionary["imageName"] as? String ?? ""
            let imagePath = FileManager.default.getImagePath(in: .units, sectionTitle: sectionTitle, imageName: imageName)
            return UIImage(contentsOfFile: imagePath) ?? UIImage(named: "Default")!
        }()
        let quizUnit = QuizUnit(sectionTitle: sectionTitle, name: name, image: image)
        return quizUnit
    }
  
}

extension QuizUnitManager {
    
    private func saveQuizUnits(_ units: [QuizUnit], for sectionTitle: String) {
        FileManager.default.createSectionDirectoriesIfNeeded(sectionTitle: sectionTitle)
        createImages(from: units, sectionTitle: sectionTitle)
        let dicts = createDictionaries(from: units)
        guard let plistData = try? PropertyListSerialization.data(fromPropertyList: dicts, format: .xml, options: .zero) else { fatalError() }
        let unitsPlistURL = FileManager.default.getUnitsPlistURL(sectionTitle: sectionTitle)
        try? plistData.write(to: unitsPlistURL, options: .atomic)
    }
    
    private func createDictionaries(from units: [QuizUnit]) -> [[String: Any]] {
        var dicts = [[String: Any]]()
        for unit in units {
            var dict: [String : Any] = [:]
            dict["sectionTitle"] = unit.sectionTitle
            dict["name"] = unit.name
            dict["imageName"] = unit.name.lowercased().split(separator: " ").joined(separator: "_") + ".png"
            dicts.append(dict)
        }
        return dicts
    }
    
    
    private func createImages(from units: [QuizUnit], sectionTitle: String) {
        for unit in units {
            let imageName = unit.name.lowercased().split(separator: " ").joined(separator: "_") + ".png"
            FileManager.default.createNewImageFile(in: .units, sectionTitle: sectionTitle, imageName: imageName, image: unit.image)
        }
    }

}

extension QuizUnitManager {
    
    func fetchNewRoundOptions(quizRound: Int, numberOfOptions: Int) -> ([String], Int) {
        var options = [String]()
        var currentQuizUnits = quizUnits
        let validOption = currentQuizUnits.remove(at: quizRound).name
        options.append(validOption)
        for _ in 1..<numberOfOptions {
            currentQuizUnits.shuffle()
            let otherOption = currentQuizUnits.removeFirst().name
            options.append(otherOption)
        }
        options.shuffle()
        let vaildOptionIndex = options.firstIndex(of: validOption) ?? 0
        return (options, vaildOptionIndex)
    }
    
    func fetchRoundImage(quizRound: Int) -> UIImage {
        return quizUnits[quizRound].image
    }
    
}

extension QuizUnitManager {
    
    func addNewQuizUnits(from rawModels: [RawUnitData], for sectionTitle: String) {
        for rawModel in rawModels {
            guard let imageURL = URL(string: (imageStorageString + rawModel.image) ),
                  let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData) else { continue }
            let newUnit = QuizUnit(sectionTitle: sectionTitle, name: rawModel.name, image: image)
            quizUnits.append(newUnit)
        }
        saveQuizUnits(quizUnits, for: sectionTitle)
    }
    
}

extension QuizUnitManager {
    
    func deleteQuizUnits(for sectionTitle: String) {
        prepareQuizUnits(for: sectionTitle)
        for index in 0..<quizUnits.count {
            guard quizUnits[index].sectionTitle == sectionTitle else { continue }
            quizUnits.remove(at: index)
        }
        saveQuizUnits(quizUnits, for: sectionTitle)
    }
    
}
