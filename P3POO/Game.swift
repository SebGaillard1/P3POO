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
    
    func printCharactersList(characters: [Character], status: StatusType) {
        
        var index = 0 // Le chiffre qui s'affiche dans la console permettant le choix du personnage
        var info: String // Informations qu'on affiche au joueur
        var action: String // Action réalisé par la personnage, on le print
        
        switch status {
        case StatusType.attacker:
            action = "attaquer"
        case StatusType.attacked:
            action = "recevoir l'attaque"
        case StatusType.healer:
            action = "soigner"
        case StatusType.healed:
            action = "recevoir le soin"
        }
        
        print("\nLe joueur \(currentPlayer) choisi le personnage qui va \(action) :")
        
        // Ici boucle for pour afficher la liste de personnages qui peuvent attaquer avec leurs infos utiles
        for character in characters {
            
            if character.life > 0 {
                index += 1
                
                switch status {
                case StatusType.attacker:
                    info = "\(character.weapon.degats) dgts"
                case StatusType.attacked:
                    info = "\(character.life) pdv"
                case StatusType.healer:
                    info = "\(character.heal) soin"
                case StatusType.healed:
                    info = "\(character.life) pdv"
                }
                
                print("\(index) - \(character.type) : \(character.name), \(info)")
            }
        }
    }
    
    func chooseAttacker(player: Player) {
        
        let charactersAlive = getCharactersAlive(characters: player.characters)
        printCharactersList(characters: charactersAlive, status: StatusType.attacker)
        userSelectCharacterDoing(characters: charactersAlive, action: ActionType.attack)
    }
    
    func chooseHealer(player: Player) {
        
        let charactersAlive = getCharactersAlive(characters: player.characters)
        printCharactersList(characters: charactersAlive, status: StatusType.healer)
        userSelectCharacterDoing(characters: charactersAlive, action: ActionType.heal)
    }
    
    func userSelectCharacterDoing(characters: [Character], action: ActionType) {
        
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
            chooseTargetAndAttackOrHeal(attacker: characters[0], player: player, enemy: enemy, action: action)
        case "2":
            if characters.count > 1 {
                chooseTargetAndAttackOrHeal(attacker: characters[1], player: player, enemy: enemy, action: action)
            } else {
                print("Saisie invalide, recommencez")
                userSelectCharacterDoing(characters: characters, action: action)
            }
        case "3":
            if characters.count > 2 {
                chooseTargetAndAttackOrHeal(attacker: characters[2], player: player, enemy: enemy, action: action)
            } else {
                print("Saisie invalide, recommencez")
                userSelectCharacterDoing(characters: characters, action: action)
            }
        default:
            print("Saisie invalide, recommencez")
            userSelectCharacterDoing(characters: characters, action: action)
        }
    }
    
    func chooseTargetAndAttackOrHeal(attacker: Character, player: Player, enemy: Player, action: ActionType) {
        
        if action == ActionType.attack {
            printCharactersList(characters: enemy.characters, status: StatusType.attacked)
            let target = selectTarget(characters: getCharactersAlive(characters: enemy.characters))
            tryRandomChest(characterAttacking: attacker)
            attacker.attack(target: target)
            endOfTurn(charactersAliveList: getCharactersAlive(characters: enemy.characters))
        } else {
            printCharactersList(characters: player.characters, status: StatusType.healed)
            let target = selectTarget(characters: getCharactersAlive(characters: player.characters))
            target.heal(healer: attacker)
            endOfTurn(charactersAliveList: getCharactersAlive(characters: player.characters))
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
    
    func endOfTurn(charactersAliveList: [Character]) {
        
        if charactersAliveList.isEmpty {
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
        print("\nLa partie s'est terminée en \(numberOfTurn) tours")
        
        for character in player1.characters {
            print("\(character.type) : \(character.name), \(character.life) pdv")
        }
        print("\n")
        for character in player2.characters {
            print("\(character.type) : \(character.name), \(character.life) pdv")
        }
    }
}

