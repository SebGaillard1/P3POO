//
//  Wizard.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Wizard: Character {
    init(wizardName: String) {
        super.init(life: 80, name: wizardName, arme: Weapon.init(name: "Sort", degats: 24), type: .Wizard, heal: 15)
    }
}
