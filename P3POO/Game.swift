//
//  Game.swift
//  P3POO
//
//  Created by Sebastien Gaillard on 04/05/2021.
//

import Foundation

class Game {
    
    var player1 = Player()
    var player2 = Player()
    
    var currentPlayer = 1
    var numberOfTurn = 0
    
    func startGame() {
        
        print("Bienvenue dans le jeu")
        createTeams()
    }
    
    func createTeams() {
        
        while player1.characters.count < 3 {
            fillListOfCharacters(player: player1, currentPlayer: 1)
        }
        
        while player2.characters.count < 3 {
            fillListOfCharacters(player: player2, currentPlayer: 2)
        }
        
        startFight()
    }
    
    func fillListOfCharacters(player: Player, currentPlayer: Int) {
        
        print("\nLe joueur \(currentPlayer) choisi son personnage \(player.characters.count + 1) : \n1 - Chevalier \n2 - Archer \n3 - Sorcier \n4 - Dragon \n5 - Ninja \n6 - Squelette \n\nTapez un chiffre puis appuyez sur Entrer.")
        
        let userInput = readLine() //On récupère l'input
        
        switch userInput { // Si la saisie est valide on ajoute un Character dans le tableau des Characters
        case "1":
            player.characters.append(Knight(knightName: uniqueName()))
        case "2":
            player.characters.append(Archer(archerName: uniqueName()))
        case "3":
            player.characters.append(Wizard(wizardName: uniqueName()))
        case "4":
            player.characters.append(Dragon(dragonName: uniqueName()))
        case "5":
            player.characters.append(Ninja(ninjaName: uniqueName()))
        case "6":
            player.characters.append(Skeleton(skeletonName: uniqueName()))
        default:
            print("\nSaisie invalide. Saisissez un chiffre entre 1 et 6.")
        }
    }
    
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
    
    // Cette méthode informe que le combat commence et lance le 1er tour
    func startFight() {
        
        print("----------------------------------------------------------------------")
        print("Le combat commence !")
        startTurn(player: player1)
    }
    
    // Cette méthode est appelée à chaque nouveau tour. En fonction du choix du joueur à qui c'est le tour, elle appelle la méthode d'attaque ou de soin.
    // Elle incrémente aussi le compteur de tours
    func startTurn(player: Player) {
        
        print("\nJoueur \(currentPlayer), veux tu :\n1 - Attaquer\n2 - Soigner")
        
        let userInput = readLine()
        
        switch userInput {
        case "1":
            numberOfTurn += 1
            chooseAttacker(player: player)
        case "2":
            numberOfTurn += 1
            chooseHealer(player: player)
        default:
            print("Saisie incorrecte. Saisissez 1 ou 2")
            startTurn(player: player)
        }
    }
    
    func printCharacters(characters: [Character], status: String) {
        
        var index = 0 // Le chiffre qui s'affiche dans la console permettant le choix du personnage
        var info: String
        var action: String
        
        switch status {
        case "attacker":
            action = "attaquer"
        case "attacked":
            action = "recevoir l'attaque"
        case "healer":
            action = "soigner"
        case "healed":
            action = "recevoir le soin"
        default:
            action = ""
            
        }
        
        print("\nLe joueur \(currentPlayer) choisi le personnage qui va \(action) :")
        
        // Ici boucle for pour afficher la liste de personnages qui peuvent attaquer avec leurs infos utiles
        for character in characters {
            
            if character.life > 0 {
                index += 1
                
                switch status {
                case "attacker":
                    info = "\(character.weapon.degats) dgts"
                case "attacked":
                    info = "\(character.life) pdv"
                case "healer":
                    info = "\(character.heal) soin"
                case "healed":
                    info = "\(character.life) pdv"
                default:
                    info = ""
                }
                
                print("\(index) - \(character.type) : \(character.name), \(info)")
            }
        }
    }
    
    func chooseAttacker(player: Player) {
        
        let charactersAlive = getCharactersAlive(characters: player.characters)
        printCharacters(characters: charactersAlive, status: "attacker")
        userSelectCharacterDoing(characters: charactersAlive, action: "attack")
    }
    
    func chooseHealer(player: Player) {
        
        let charactersAlive = getCharactersAlive(characters: player.characters)
        printCharacters(characters: charactersAlive, status: "healer")
        userSelectCharacterDoing(characters: charactersAlive, action: "heal")
    }
    
    func userSelectCharacterDoing(characters: [Character], action: String) {
        
        var enemy: Player
        var player: Player
        
        if currentPlayer == 1 {
            player = player1
            enemy = player2
        } else {
            player = player2
            enemy = player1
        }
        
        let userInput = readLine()
        
        switch userInput {
        case "1":
            chooseTarget(attacker: characters[0], player: player, enemy: enemy, action: action)
        case "2":
            if characters.count > 1 {
                chooseTarget(attacker: characters[1], player: player, enemy: enemy, action: action)
            } else {
                print("Saisie invalide, recommencez")
                userSelectCharacterDoing(characters: characters, action: action)
            }
        case "3":
            if characters.count > 2 {
                chooseTarget(attacker: characters[2], player: player, enemy: enemy, action: action)
            } else {
                print("Saisie invalide, recommencez")
                userSelectCharacterDoing(characters: characters, action: action)
            }
        default:
            print("Saisie invalide, recommencez")
            userSelectCharacterDoing(characters: characters, action: action)
        }
    }
    
    func chooseTarget(attacker: Character, player: Player, enemy: Player, action: String) {
        
        
        if action == "attack" {
            
            printCharacters(characters: enemy.characters, status: "attacked")
            let target = selectTarget(characters: getCharactersAlive(characters: enemy.characters))
            attacker.attack(target: target)
            endOfTurn(charactersList: getCharactersAlive(characters: enemy.characters))
        } else {
            
            printCharacters(characters: player.characters, status: "healed")
            let target = selectTarget(characters: getCharactersAlive(characters: player.characters))
            target.heal(healer: attacker)
            endOfTurn(charactersList: getCharactersAlive(characters: player.characters))
        }
    }
    
    func selectTarget(characters: [Character]) -> Character {
        
        var validUserInput = false
        
        while !validUserInput {
            let userInput = readLine()
            
            switch userInput {
            case "1":
                validUserInput = true
                return characters[0]
            case "2":
                if characters.count > 1 {
                    validUserInput = true
                    return characters[1]
                } else {
                    print("Saisie invalide, recommencez")
                }
            case "3":
                if characters.count > 2 {
                    validUserInput = true
                    return characters[2]
                } else {
                    print("Saisie invalide, recommencez")
                }
            default:
                print("Saisie invalide, recommencez")
            }
        }
    }
    
    
    func endOfTurn(charactersList: [Character]) {
        
        if charactersList.isEmpty {
            endGame()
        } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1
            
            if currentPlayer == 1 {
                startTurn(player: player1)
            } else {
                startTurn(player: player2)
            }
        }
    }
    
    func endGame() {
        
        print("\n\n---------------------------------------------")
        print("Fin de partie ! \nCompte rendu :")
        print("Le joueur \(currentPlayer) a gagné !")
        print("\nLa partie c'est terminée en \(numberOfTurn) tours")
        
        
        }
    
    // Cette méthode renvoi le tableau des personnages encore en vie du joueur 1
    func getCharactersAlive(characters: [Character]) -> [Character] {
        return characters.filter { (c) -> Bool in
            c.life > 0
        }
    }
    
}

