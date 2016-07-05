//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class Card {
    var Value : Int?;
    var Name : String?
}

var deckOfCards = [Card]()
var playerOneCards = [Card]()
var playerOneCardsInPlay = [Card]()
var playerTwoCardsInPlay = [Card]()
var playerOneStorage = [Card]()
var playerTwoStorage = [Card]()

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

addCards("spades")
addCards("clubs")
addCards("diamonds")
addCards("hearts")

// adding the four suits to a deck

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

//creating a shuffling function.

deckOfCards.shuffle()

var range = Int(deckOfCards.count / 2)

for i in 1...range {
    let index: Int = Int(arc4random_uniform(UInt32(deckOfCards.count - 1)));
    playerOneCards.append(deckOfCards[index])
    deckOfCards.removeAtIndex(index)
}

//putting 26 random cards into player one deck and the remaining into player two deck

var playerTwoCards = deckOfCards

for _ in 1...range {
    playerOneCards.shuffle()
    playerTwoCards.shuffle()
    
}

for i in playerOneCards {
    playerOneCardsInPlay.append(i)
}
for x in playerTwoCards {
    playerTwoCardsInPlay.append(x)
}
var playerOneWinCounter = 0
var playerTwoWinCounter = 0
var counterTemp = 0
for j in 0...2 {
    playerOneCardsInPlay.append(playerOneCards[j])
    playerTwoCardsInPlay.append(playerTwoCards[j])
    playerOneCards.removeAtIndex(j)
    playerTwoCards.removeAtIndex(j)
    if playerOneCardsInPlay[j].Value > playerTwoCardsInPlay[j].Value {
        playerOneWinCounter += 1
        
    }
    else if playerOneCardsInPlay[j].Value < playerTwoCardsInPlay[j].Value {
        playerTwoWinCounter += 1
    }
    else {
        warScenario(counterTemp)
        
    }
}





func warScenario( warCounter: Int) {
    
    var counterTemp = warCounter;
    
    if playerOneCards.count >= 3 && playerTwoCards.count >= 3 {
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
        
       //This part works
        
        for j in 0...2 {
            playerOneCardsInPlay.append(playerOneCards[j])
            playerTwoCardsInPlay.append(playerTwoCards[j])
            playerOneCards.removeAtIndex(j)
            playerTwoCards.removeAtIndex(j)
            if playerOneCardsInPlay[j].Value > playerTwoCardsInPlay[j].Value {
                playerOneWinCounter += 1
                
            }
            else if playerOneCardsInPlay[j].Value < playerTwoCardsInPlay[j].Value {
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
       }
