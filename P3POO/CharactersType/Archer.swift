//
//  Archer.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Archer: Character {
    init(archerName: String) {
        super.init(life: 90, name: archerName, arme: Weapon.init(name: "Flêches", degats: 22), type: .Archer, heal: 12)
    }
}
