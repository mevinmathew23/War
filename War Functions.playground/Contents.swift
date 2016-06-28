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


//while playerOneCards.count and playerTwoCards.count != 0 {

playerOneCardsInPlay.append(playerOneCards[0])
playerOneCards.removeAtIndex(0)
playerTwoCardsInPlay.append(playerTwoCards[0])
playerTwoCards.removeAtIndex(0)
//}


if playerOneCardsInPlay[0].Value > playerTwoCardsInPlay[0].Value {
    playerOneCards.append(playerOneCardsInPlay[0])
    playerOneCards.append(playerTwoCardsInPlay[0])
    playerOneCardsInPlay.removeAtIndex(0)
    playerTwoCardsInPlay.removeAtIndex(0)
}
    
    else if playerOneCardsInPlay[0].Value < playerTwoCardsInPlay[0].Value {
    playerTwoCards.append(playerTwoCardsInPlay[0])
    playerTwoCards.append(playerOneCardsInPlay[0])
    playerTwoCardsInPlay.removeAtIndex(0)
    playerOneCardsInPlay.removeAtIndex(0)
    
}

else if playerOneCardsInPlay[0].Value == playerTwoCardsInPlay[0].Value {
    var playerOneWinCounter = 0
    var playerTwoWinCounter = 0
    for i in 0...2 {
        playerOneCardsInPlay.append(playerOneCards[i])
        playerTwoCardsInPlay.append(playerTwoCards[i])
        for j in 1...3 {
            if playerOneCardsInPlay[j].Value > playerTwoCardsInPlay[j].Value {
                playerOneWinCounter += 1
            }
            else if playerOneCardsInPlay[j].Value < playerTwoCardsInPlay[j].Value {
                playerTwoWinCounter += 1
            }
            else if playerOneCardsInPlay[j].Value == playerTwoCardsInPlay[j].Value {
                var secondPlayerOneWinCounter = 0
                var secondPlayerTwoWinCounter = 0
                for k in 0...2 {
                    playerOneCardsInPlay.append(playerOneCards[k])
                    playerTwoCardsInPlay.append(playerTwoCards[k])
                    for l in 4...6 {
                        if playerOneCardsInPlay[l].Value > playerTwoCardsInPlay[l].Value {
                            secondPlayerOneWinCounter += 1
                        }
                        else if playerOneCardsInPlay[l].Value < playerTwoCardsInPlay[l].Value {
                            secondPlayerTwoWinCounter += 1
                        }
                        else if playerOneCardsInPlay[l].Value == playerTwoCardsInPlay[l].Value {
                            var playerOneTotal = playerOneWinCounter + secondPlayerOneWinCounter
                            var playerTwoTotal = playerTwoWinCounter + secondPlayerTwoWinCounter
                            if playerOneTotal > playerTwoTotal {
                                for m in 0...playerOneCardsInPlay.count {
                                    playerOneCards.append(playerOneCardsInPlay[m])
                                    playerOneCards.append(playerTwoCardsInPlay[m])
                                    playerOneCardsInPlay.removeAtIndex(m)
                                    playerTwoCardsInPlay.removeAtIndex(m)
                                }
                                
                            }
                            else if playerOneTotal < playerTwoTotal {
                                for n in 0...playerTwoCardsInPlay.count {
                                    playerTwoCards.append(playerTwoCardsInPlay[n])
                                    playerTwoCards.append(playerOneCardsInPlay[n])
                                    playerTwoCardsInPlay.removeAtIndex(n)
                                    playerOneCardsInPlay.removeAtIndex(n)
                                }
                            }
                            else if playerOneTotal == playerTwoTotal {
                                for o in 0...playerOneCardsInPlay.count {
                                    playerOneCards.append(playerOneCardsInPlay[o])
                                    playerTwoCards.append(playerTwoCardsInPlay[o])
                                    playerOneCardsInPlay.removeAtIndex(o)
                                    playerTwoCardsInPlay.removeAtIndex(o)
                                }
                            }
                            
                        
                        }
                    }
                }
            }
        }
    }
}



    
    





