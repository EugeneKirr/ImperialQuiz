//
//  QuizUnitManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 10/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class QuizUnitManager {
    
    var quizUnits = [QuizUnit]()
    
    enum DefaultSections: String {
        case spaceMarines = "Space Marines"
        case orks = "Orks"
    }
    
    let smUnitNames = ["Alpha Legion", "Blood Angels", "Dark Angels", "Death Guard", "Emperor's Children", "Imperial Fists", "Iron Hands", "Iron Warriors", "Night Lords", "Raven Guard", "Salamanders", "Sons of Horus", "Space Wolves", "Thousand Sons", "Ultramarines", "White Scars", "Word Bearers", "World Eaters"]
    let smImageNames = ["alpha_legion", "blood_angels", "dark_angels", "death_guard", "emperors_children", "imperial_fists", "iron_hands", "iron_warriors", "night_lords", "raven_guard", "salamanders", "sons_of_horus", "space_wolves", "thousand_sons", "ultramarines", "white_scars", "word_bearers", "world_eaters"]
    
    let orksUnitNames = ["Bad Moons", "Blood Axes", "Deathskulls", "Evil Sunz", "Goffs", "Snakebites"]
    let orksImageNames = ["bad_moons", "blood_axes", "deathskulls", "evil_sunz", "goffs", "snakebites"]
    
    func prepareQuizUnits(for sectionTitle: String) -> Int {
        switch sectionTitle {
        case DefaultSections.spaceMarines.rawValue: quizUnits = generateSMUnits().shuffled()
        case DefaultSections.orks.rawValue: quizUnits = generateOrksUnits().shuffled()
        default: break
        }
        return quizUnits.count
    }
    
    private func generateSMUnits() -> [QuizUnit] {
        var fetchedUnits = [QuizUnit]()
        for index in 0...(smUnitNames.count - 1) {
            let quizUnit = QuizUnit(sectionTitle: "Space Marines", name: smUnitNames[index], image: UIImage(named: smImageNames[index])! )
            fetchedUnits.append(quizUnit)
        }
        return fetchedUnits
    }
    
    private func generateOrksUnits() -> [QuizUnit] {
        var fetchedUnits = [QuizUnit]()
        for index in 0...(orksUnitNames.count - 1) {
            let quizUnit = QuizUnit(sectionTitle: "Orks", name: orksUnitNames[index], image: UIImage(named: orksImageNames[index])! )
            fetchedUnits.append(quizUnit)
        }
        return fetchedUnits
    }
    
}

extension QuizUnitManager {
    
    func fetchNewRoundOptions(quizRound: Int) -> ([String], Int) {
        var options = [String]()
        var currentQuizUnits = quizUnits
        let validOption = currentQuizUnits.remove(at: quizRound).name
        options.append(validOption)
        for _ in 0...2 {
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
