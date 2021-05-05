//
//  Dragon.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Dragon: Character {
    init(dragonName: String) {
        super.init(life: 50, name: dragonName, arme: Weapon.init(name: "Feu", degats: 40), type: .Dragon, heal: 20)
    }
}
