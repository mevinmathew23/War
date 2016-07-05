//
//  ViewController.swift
//  War
//
//  Created by Apple Dev on 2016-06-21.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class Card {
    var Value: Int?
    var Name: String?
    var ShowingFront: Bool = false
    
    var Back: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    var Front: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    let backImage = UIImage(named: "backOfDeck")
}

class ViewController: UIViewController {
    
    @IBOutlet weak var cardViewP1: UIView!
    @IBOutlet weak var cardViewP2: UIView!
    
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var cardViewP1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2Constraint: NSLayoutConstraint!
    
    var deckOfCards = [Card]()
    var playerOneCards = [Card]()
    var playerTwoCards = [Card]()
    var playerOneCardsInPlay = [Card]()
    var playerTwoCardsInPlay = [Card]()
    var playerOneStorage = [Card]()
    var playerTwoStorage = [Card]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playRoundButton.setTitle("Play", forState: UIControlState.Normal)
        
        let tapP1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP1))
        let tapP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP2))
        tapP1.numberOfTapsRequired = 1
        tapP2.numberOfTapsRequired = 1
        cardViewP1.addGestureRecognizer(tapP1)
        cardViewP2.addGestureRecognizer(tapP2)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set initial cards outside of view
        self.cardViewP1Constraint.constant = 900
        self.cardViewP2Constraint.constant = -500
        self.view.layoutIfNeeded()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Create arrays necessary to hold the cards
    func addCards(Suit: String){
        for x in 2...14{
            let temp = Card();
            temp.Value = x;
            temp.Name = Suit + String(x);
            deckOfCards.append(temp);
        }
    }
    
    func drawCardP1(player: UIView) {
        playerOneCardsInPlay.append(playerOneCards[0])
        let activeP1 = playerOneCardsInPlay[0]
        playerOneCards.removeAtIndex(0)
        activeP1.Back.image = playerOneCardsInPlay[0].backImage
        activeP1.Front.image = UIImage(named: String(activeP1.Name!))
        
        player.addSubview(activeP1.Back)
    }
    
    func drawCardP2(player: UIView) {
        playerTwoCardsInPlay.append(playerTwoCards[0])
        let activeP2 = playerTwoCardsInPlay[0]
        playerTwoCards.removeAtIndex(0)
        activeP2.Back.image = playerOneCardsInPlay[0].backImage
        activeP2.Front.image = UIImage(named: String(activeP2.Name!))
        
        player.addSubview(activeP2.Back)
    }
    
    @IBAction func playRoundTapped(sender: UIButton) {
        
        // A function to add all four suits of cards into an array to create a deck
        addCards("spades")
        addCards("clubs")
        addCards("diamonds")
        addCards("hearts")
        
        // Shuffle
        deckOfCards.shuffle()
        
        let range = Int(deckOfCards.count / 2)
        
        for _ in 1...range {
            let index: Int = Int(arc4random_uniform(UInt32(deckOfCards.count - 1)));
            playerOneCards.append(deckOfCards[index])
            deckOfCards.removeAtIndex(index)
        }
        
        // Remaining cards put in P2 deck
        playerTwoCards = deckOfCards
        
        for _ in 1...range {
            playerOneCards.shuffle()
            playerTwoCards.shuffle()
            
        }
        
        drawCardP1(cardViewP1)
        drawCardP2(cardViewP2)
        
        playRoundButton.removeFromSuperview()
        
        // Animate cards dealt
        UIView.animateWithDuration(0.8, animations: {
            self.cardViewP1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.8, delay: 0.3, options: [], animations: {
            self.cardViewP2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    // Tap to flip cards
    func tappedP1() {
        print(playerOneCardsInPlay[0].Name!)
        if (playerOneCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(playerOneCardsInPlay[0].Front, toView: playerOneCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            playerOneCardsInPlay[0].ShowingFront = false
            
        } else {
            UIView.transitionFromView(playerOneCardsInPlay[0].Back, toView: playerOneCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            playerOneCardsInPlay[0].ShowingFront = true
            if playerOneCardsInPlay[0].ShowingFront && playerTwoCardsInPlay[0].ShowingFront {
                evaluate()
            }
        }
    }
    func tappedP2() {
        print(playerTwoCardsInPlay[0].Name!)
        if (playerTwoCardsInPlay[0].ShowingFront) {
            
            UIView.transitionFromView(playerTwoCardsInPlay[0].Front, toView: playerTwoCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            playerTwoCardsInPlay[0].ShowingFront = false
        } else {
            UIView.transitionFromView(playerTwoCardsInPlay[0].Back, toView: playerTwoCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            playerTwoCardsInPlay[0].ShowingFront = true
            if playerOneCardsInPlay[0].ShowingFront && playerTwoCardsInPlay[0].ShowingFront {
                evaluate()
            }
        }
    }
    
    func evaluate() {
        
    }
}

// OUTSIDE OF CLASS

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
