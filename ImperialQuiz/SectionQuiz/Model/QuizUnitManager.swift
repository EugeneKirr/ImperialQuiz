//
//  QuizUnitManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class QuizUnitManager {
    
    private var quizUnits = [QuizUnit]()
    
    private enum DefaultSections: String {
        case spaceMarines = "Space Marines"
        case orks = "Orks"
        case necrons = "Necrons"
    }
    
    private let smUnitNames = ["Alpha Legion", "Blood Angels", "Dark Angels", "Death Guard", "Emperor's Children", "Imperial Fists", "Iron Hands", "Iron Warriors", "Night Lords", "Raven Guard", "Salamanders", "Sons of Horus", "Space Wolves", "Thousand Sons", "Ultramarines", "White Scars", "Word Bearers", "World Eaters"]
    private let smImageNames = ["alpha_legion", "blood_angels", "dark_angels", "death_guard", "emperors_children", "imperial_fists", "iron_hands", "iron_warriors", "night_lords", "raven_guard", "salamanders", "sons_of_horus", "space_wolves", "thousand_sons", "ultramarines", "white_scars", "word_bearers", "world_eaters"]
    
    private let orksUnitNames = ["Bad Moons", "Blood Axes", "Deathskulls", "Evil Sunz", "Goffs", "Snakebites"]
    private let orksImageNames = ["bad_moons", "blood_axes", "deathskulls", "evil_sunz", "goffs", "snakebites"]
    
    private let necronsUnitNames = ["Sautekh", "Oruscar", "Oroskh", "Ogdobekh", "Nihilakh", "Nekthyst", "Charnovokh", "Atun", "Kardenath", "Mephrit", "Nephrekh", "Agdagath", "Arrynmarok", "Novokh", "Sekemtar", "Thokt", "Sarnekh"]
    private let necronsImageNames = ["sautekh", "oruscar", "oroskh", "ogdobekh", "nihilakh", "nekthyst", "charnovokh", "atun", "kardenath", "mephrit", "nephrekh", "agdagath", "arrynmarok", "novokh", "sekemtar", "thokt", "sarnekh"]
    
    private func prepareDefaultUnits(for sectionTitle: String) {
        var preparedUnits = [QuizUnit]()
        var unitNames = [String](), imageNames = [String]()
        switch sectionTitle {
        case DefaultSections.spaceMarines.rawValue:
            unitNames = smUnitNames
            imageNames = smImageNames
        case DefaultSections.orks.rawValue:
            unitNames = orksUnitNames
            imageNames = orksImageNames
        case DefaultSections.necrons.rawValue:
            unitNames = necronsUnitNames
            imageNames = necronsImageNames
        default: return
        }
        for index in 0..<unitNames.count {
            let quizUnit = QuizUnit(sectionTitle: sectionTitle, name: unitNames[index], image: UIImage(named: imageNames[index])! )
            preparedUnits.append(quizUnit)
        }
        quizUnits = preparedUnits.shuffled()
    }

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
                print("using default units")
                prepareDefaultUnits(for: sectionTitle)
                saveQuizUnits(quizUnits, for: sectionTitle)
                return
        }
        for dict in dicts {
            let unit = createQuizUnit(from: dict)
            preparedUnits.append(unit)
        }
        print("using units.plist")
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
            let newUnit = QuizUnit(sectionTitle: sectionTitle, name: rawModel.name)
            quizUnits.append(newUnit)
//            guard let imageURL = URL(string: rawModel.image),
//                  let imageData = try? Data(contentsOf: imageURL),
//                  let image = UIImage(data: imageData) else { continue }
//            let newUnit = QuizUnit(sectionTitle: sectionTitle, name: rawModel.name, image: image)
//            units.append(newUnit)
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
