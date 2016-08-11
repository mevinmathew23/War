//
//  War.swift
//  War
//
//  Created by Apple Dev on 2016-07-05.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class War {
    
    var deckOfCards = [Card]()
    var playerOneCards = [Card]()
    var playerOneCardsInPlay = [Card]()
    var playerTwoCardsInPlay = [Card]()
    var playerOneStorage = [Card]()
    var playerTwoStorage = [Card]()
    var playerTwoCards = [Card]()
    
    var bPlayerOneWinner: Bool? = nil
    
    //creating arrarys necessary to hold the cards for the game
    
    func addCards(Suit: String){
        for x in 2...5{
            let temp = Card();
            temp.Value = x;
            temp.Name = Suit + String(x);
            
            deckOfCards.append(temp);
        }
    }

    //creating a shuffling function.
    
    func deal(){
        let range = Int(deckOfCards.count / 2)
        
        for _ in 1...range {
            let index: Int = Int(arc4random_uniform(UInt32(deckOfCards.count - 1)));
            playerOneCards.append(deckOfCards[index])
            deckOfCards.removeAtIndex(index)
        }
        
        //putting 26 random cards into player one deck and the remaining into player two dec
        
        playerTwoCards = deckOfCards;
        
        for _ in 1...range {
            playerOneCards.shuffle()
            playerTwoCards.shuffle()
            
        }
    }
    
    func warScenario( warCounter: Int)  {
        
        var counterTemp = warCounter
        
        guard playerOneCards.count >= 3 else{
            playerOneCards.removeAll()
            return
        }
        
        guard playerTwoCards.count >= 3 else{
            playerTwoCards.removeAll()
            return
        }
        
        guard counterTemp < 3 else {
            return
        }
        
        counterTemp += 1
        var playerOneWinCounter = 0
        var playerTwoWinCounter = 0
        
        
        for x in playerOneCardsInPlay {
            playerOneStorage.append(x)
        }
        playerOneCardsInPlay.removeAll()
        
        for x in playerTwoCardsInPlay{
            playerTwoStorage.append(x)
        }
        playerTwoCardsInPlay.removeAll()
        
        
        
        for j in 2.stride(to: 0, by: -1) {
            let j1 = playerOneCards[j]
            let j2 = playerTwoCards[j]
            playerOneCardsInPlay.append(j1)
            playerTwoCardsInPlay.append(j2)
            playerOneCards.removeAtIndex(j)
            playerTwoCards.removeAtIndex(j)
            
            if j1.Value > j2.Value {
                playerOneWinCounter += 1
                
            }
            else if j1.Value < j2.Value {
                playerTwoWinCounter += 1
            }
            else {
                warScenario(counterTemp)
                
            }
        }
        if playerOneWinCounter >= 2 {
            for i in playerOneStorage {
                playerOneCards.append(i)
            }
            for j in playerTwoStorage {
                playerOneCards.append(j)
            }
            for k in playerOneCardsInPlay {
                playerOneCards.append(k)
            }
            for l in playerTwoCardsInPlay {
                playerOneCards.append(l)
            }
            playerOneStorage.removeAll()
            playerTwoStorage.removeAll()
            playerOneCardsInPlay.removeAll()
            playerTwoCardsInPlay.removeAll()
            
        } else if playerTwoWinCounter >= 2 {
            for i in playerOneStorage {
                playerTwoCards.append(i)
            }
            for j in playerTwoStorage {
                playerTwoCards.append(j)
            }
            for k in playerOneCardsInPlay {
                playerTwoCards.append(k)
            }
            for l in playerTwoCardsInPlay {
                playerTwoCards.append(l)
            }
            playerOneStorage.removeAll()
            playerTwoStorage.removeAll()
            playerOneCardsInPlay.removeAll()
            playerTwoCardsInPlay.removeAll()
            
        }
    }
    
    
    
    func normalWinP1AppendP1() {
        playerOneCardsInPlay[0].ShowingFront = false
        playerOneCards.append(playerOneCardsInPlay[0])
        playerOneCardsInPlay.removeAll()
    }
    
    func normalWinP1AppendP2() {
        playerTwoCardsInPlay[0].ShowingFront = false
        playerOneCards.append(playerTwoCardsInPlay[0])
        playerTwoCardsInPlay.removeAll()
    }
    
    func normalWinP2AppendP2() {
        playerTwoCardsInPlay[0].ShowingFront = false
        playerTwoCards.append(playerTwoCardsInPlay[0])
        playerTwoCardsInPlay.removeAll()
    }
    
    func normalWinP2AppendP1() {
        playerOneCardsInPlay[0].ShowingFront = false
        playerTwoCards.append(playerOneCardsInPlay[0])
        playerOneCardsInPlay.removeAll()
    }
    
    func appendStorageP1() {
        playerOneCardsInPlay[0].ShowingFront = false
        playerOneStorage.append(playerOneCardsInPlay[0])
        playerOneCardsInPlay.removeAtIndex(0)
    }
    
    func appendStorageP2() {
        playerTwoCardsInPlay[0].ShowingFront = false
        playerTwoStorage.append(playerTwoCardsInPlay[0])
        playerTwoCardsInPlay.removeAtIndex(0)
    }
    func appendAllP1() {
        for x in playerOneCardsInPlay {
            x.ShowingFront = false
            playerOneStorage.append(x)
        }
        playerOneCardsInPlay.removeAll()
    }
    
    func appendAllP2() {
        for x in playerTwoCardsInPlay {
            x.ShowingFront = false
            playerTwoStorage.append(x)
        }
        playerTwoCardsInPlay.removeAll()
    }
    
    func checkDeck() {
        if playerOneCards.count == 0 {
            bPlayerOneWinner = false
        } else if playerTwoCards.count == 0 {
            bPlayerOneWinner = true
        } else {
            bPlayerOneWinner = nil
        }
    }
    
    func checkWinner() {
        if bPlayerOneWinner == true {
            print("Player one wins")
        } else if bPlayerOneWinner == false {
            print("Player 2 wins")
        } else if bPlayerOneWinner == nil {
            print("No winner yet...")
        }
        
    }
}