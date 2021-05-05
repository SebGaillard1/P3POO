//
//  Ninja.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Ninja: Character {
    init(ninjaName: String) {
        super.init(life: 60, name: ninjaName, arme: Weapon.init(name: "Katana", degats: 35), type: .Ninja, heal: 17)
    }
}
