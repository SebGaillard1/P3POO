//
//  Knight.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Knight: Character {
    init(knightName: String) {
        super.init(life: 100, name: knightName, arme: Weapon.init(name: "Épée", degats: 20), type: .Knight, heal: 10)
    }
}
