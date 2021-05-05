//
//  GameExtension.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 05/05/2021.
//

import Foundation

extension Game {
    
    // Cette méthode renvoie un nom unique. (Elle est récursive tant que le nom saisi n'est pas unique)
    func uniqueName() -> String {
        
        print("Saisissez nom personnage :")
        
        var userInputName = readLine() ?? ""
        userInputName = userInputName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if userInputName.isEmpty {
            print("Nom vide, recommencez")
            userInputName = uniqueName()
        }
        
        if player1.characters.contains(where: { c in
            c.name == userInputName
        }) || player2.characters.contains(where: { c in
            c.name == userInputName
        }){
            print("Le nom existe déjà, recommencez")
            userInputName = uniqueName()
        }
        
        return userInputName // On return le nom choisi par l'utilisateur s'il est unique
    }
    
    // Cette méthode renvoi le tableau des personnages encore en vie
    func getCharactersAlive(characters: [Character]) -> [Character] {
        return characters.filter { (c) -> Bool in
            c.life > 0
        }
    }
    
    //MARK: - Partie coffre
    
    // Cette méthode fait apparaitre ou non un coffre et change l'arme du personnage
    func tryRandomChest(characterAttacking: Character) {
        
        let randomInt = Int.random(in: 0...99) // Génère un chiffre aléatoire entre 0 et 99
        switch randomInt {
        case 0..<5:
            characterAttacking.weapon = Weapon(name: "Épée légendaire", degats: 50)
            print("\nIncroyable, un coffre vient d'apparaître devant vous. Il contient une arme très rare : une épée légendaire !")
        case 5..<15:
            characterAttacking.weapon = Weapon(name: "Bâton magique", degats: 40)
            print("\nSuperbe, un coffre vient d'apparaître devant vous. Il contient une arme rare, un bâton magique !")
        case 15..<30:
            characterAttacking.weapon = Weapon(name: "Marteau", degats: 30)
            print("\nUn coffre vient d'apparaître devant vous, il contient un marteau !")
        case 30..<35:
            characterAttacking.weapon = Weapon(name: "Canne à pêche", degats: 10)
            print("\nUn coffre vient d'apparaître devant vous mais son contenu risque de vous déplaire... Il contient une canne à pêche !")
        default:
            () // On ne fait rien
        }
    }
}
