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
    
    //let vc = ViewController()
    
    
    //creating arrarys necessary to hold the cards for the game
    
    func addCards(Suit: String){
        for x in 2...14{
            let temp = Card();
            temp.Value = x;
            temp.Name = Suit + String(x);
            deckOfCards.append(temp);
        }
    }
    
    //A function to add all four suits of cards into an array to create a deck
    
    
    
    // adding the four suits to a deck
    
    
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
        
        var counterTemp = warCounter;
        
        guard  playerOneCards.count >= 3 else{
            playerOneCards.removeAll();
            return;
        }
        
        guard playerTwoCards.count >= 3 else{
            playerTwoCards.removeAll();
            return;
        }
        
        guard counterTemp < 3 else {
            return;
        }
        
        
        counterTemp += 1
        var playerOneWinCounter = 0
        var playerTwoWinCounter = 0
        
        
        for x in playerOneCardsInPlay {
            playerOneStorage.append(x)
        }
        playerOneCardsInPlay.removeAll();
        
        for x in playerTwoCardsInPlay{
            playerTwoStorage.append(x)
        }
        playerTwoCardsInPlay.removeAll()
        
        
        
        for j in 2.stride(to: 0, by: -1) {
            let j1 = playerOneCards[j];
            let j2 = playerTwoCards[j];
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
    
    func evaluate() {
        playerOneCardsInPlay.append(playerOneCards[0])
        playerOneCards.removeAtIndex(0)
        playerTwoCardsInPlay.append(playerTwoCards[0])
        playerTwoCards.removeAtIndex(0)
        
        if playerOneCardsInPlay[0].Value > playerTwoCardsInPlay[0].Value {
            playerOneCards.append(playerOneCardsInPlay[0])
            playerOneCards.append(playerTwoCardsInPlay[0])
            playerOneCardsInPlay.removeAll()
            playerTwoCardsInPlay.removeAll()
            
            // Animate
            //vc.normalWinP1()
            
            print("P1 wins this round")
        }
        else if playerOneCardsInPlay[0].Value < playerTwoCardsInPlay[0].Value {
            playerTwoCards.append(playerTwoCardsInPlay[0])
            playerTwoCards.append(playerOneCardsInPlay[0])
            playerTwoCardsInPlay.removeAll()
            playerOneCardsInPlay.removeAll()
            
            // Animate
            //vc.normalWinP2()
            
            print("P2 wins this round")
        }
        else {
            warScenario(0)
        }
    }
    
    func checkForWin() {
        if playerOneCards.count == 0 {
            bPlayerOneWinner = false
        } else if playerTwoCards.count == 0 {
            bPlayerOneWinner = true
        } else {
            bPlayerOneWinner = nil
        }
    }
}