//
//  Skeleton.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Skeleton: Character {
    init(skeletonName: String) {
        super.init(life: 40, name: skeletonName, arme: Weapon.init(name: "Os", degats: 30), type: .Skeleton, heal: 22)
    }
}
