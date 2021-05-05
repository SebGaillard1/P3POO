//
//  Character.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Character {
    
    var life: Int
    var name: String
    var weapon: Weapon
    var type: Type
    var heal: Int
    
    init(life: Int, name: String, arme: Weapon, type: Type, heal: Int) {
        
        self.life = life
        self.name = name
        self.weapon = arme
        self.type = type
        self.heal = heal
    }
    
    func attack(target: Character) {
        
        target.life -= self.weapon.degats
        
        print("\(self.name) attaque \(target.name) avec \(self.weapon.name) et lui inflige \(self.weapon.degats) dégâts")
        if target.life <= 0 {
            target.life = 0
            print("\(target.name) est mort")
        } else {
            print("Il lui reste \(target.life) pdv")
        }
    }
    
    func heal(healer: Character){
        
        self.life += healer.heal
        
        print("\(healer.name) soigne \(self.name) de \(healer.heal) pdv")
        print("\(self.name) a désormais \(self.life) pdv")
    }
}

enum Type {
    
    case Knight
    case Archer
    case Wizard
    case Dragon
    case Ninja
    case Skeleton
}
