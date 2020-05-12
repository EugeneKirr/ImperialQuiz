//
//  SectionManager.swift
//  ImperialQuiz
//
//  Created by Eugene Kireichev on 06/05/2020.
//  Copyright © 2020 Eugene Kireichev. All rights reserved.
//

import UIKit

class SectionManager {
    
    let smDescription = "The Space Marine Legions, or the Legiones Astartes in High Gothic, were the original unit formations of the Space Marines created during the First Founding by the Emperor of Mankind on Terra in the late 30th Millennium."
    let smImages = [UIImage(named:"sm_gallery_0")!, UIImage(named:"sm_gallery_1")!, UIImage(named:"sm_gallery_2")!, UIImage(named:"sm_gallery_3")!]
    
    let orksDescription = "The Orks, also called greenskins, are a savage, warlike, green-skinned species of humanoids who are spread all across the Milky Way Galaxy."
    let orksImages = [UIImage(named:"orks_gallery_0")!, UIImage(named:"orks_gallery_1")!, UIImage(named:"orks_gallery_2")!, UIImage(named:"orks_gallery_3")!, UIImage(named:"orks_gallery_4")!]
    
    func fetchDefaultSections() -> [Section] {
        let orksSection = Section(title: "Orks", listImage: UIImage(named:"orks_list")!, description: orksDescription, galleryImages: orksImages)
        let smSection = Section(title: "Space Marines", listImage: UIImage(named:"sm_list")!, description: smDescription, galleryImages: smImages)
        return [smSection, orksSection]
    }
    
    var sections = [Section(title: "Foo", description: "Qux"), Section(title: "Bar", description: "Rol"), Section(title: "Baz", description: "Lot")]
    
    func add(_ newSections: [Section]) {
        newSections.forEach { newSection in
            guard !sections.contains(newSection) else { return }
            sections.append(newSection)
        }
    }
    
    func removeAll() {
        sections.removeAll()
    }
    
}
