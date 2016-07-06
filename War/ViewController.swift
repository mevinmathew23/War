//
//  ViewController.swift
//  War
//
//  Created by Apple Dev on 2016-06-21.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardViewP1: UIView!
    @IBOutlet weak var cardViewP2: UIView!
    
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playerOneCounter: UILabel!
    @IBOutlet weak var playerTwoCounter: UILabel!
    
    @IBOutlet weak var cardViewP1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2Constraint: NSLayoutConstraint!
    
    let war = War()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hideCounter()
        // Rotate player 2 counter
        playerTwoCounter.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        self.playRoundButton.setTitle("DEAL", forState: UIControlState.Normal)
        
        let tapP1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP1))
        let tapP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP2))
        tapP1.numberOfTapsRequired = 1
        tapP2.numberOfTapsRequired = 1
        cardViewP1.addGestureRecognizer(tapP1)
        cardViewP2.addGestureRecognizer(tapP2)
        
        // Setup cards
        war.addCards("spades")
        war.addCards("clubs")
        war.addCards("diamonds")
        war.addCards("hearts")
        
        war.deckOfCards.shuffle()
        war.deal()
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
    
    // Button Click Action
    
    @IBAction func playRoundTapped(sender: UIButton) {
        showCounter()
        
        updateCounter()
        
        drawCardP1(cardViewP1)
        drawCardP2(cardViewP2)
        
        hideButton()
        
        // Animate cards dealt
        startAnimation()
    }
    
    // DECK COUNTERS
    
    func hideCounter() {
        playerOneCounter.hidden = true
        playerTwoCounter.hidden = true
    }
    
    func showCounter() {
        playerOneCounter.hidden = false
        playerTwoCounter.hidden = false
    }
    
    func updateCounter() {
        playerOneCounter.text = String(war.playerOneCards.count + war.playerOneCardsInPlay.count)
        playerTwoCounter.text = String(war.playerTwoCards.count + war.playerTwoCardsInPlay.count)
    }
    
    // DRAW BUTTON TOGGLE
    
    func showButton() {
        playRoundButton.hidden = false
        playRoundButton.userInteractionEnabled = true
    }
    func hideButton() {
        playRoundButton.hidden = true
        playRoundButton.userInteractionEnabled = false
    }
    
    // DRAW CARDS
    
    func drawCardP1(player: UIView) {
        war.playerOneCardsInPlay.append(war.playerOneCards[0])
        let activeP1 = war.playerOneCardsInPlay[0]
        war.playerOneCards.removeAtIndex(0)
        activeP1.Back.image = war.playerOneCardsInPlay[0].backImage
        activeP1.Front.image = UIImage(named: String(activeP1.Name!))
        
        player.addSubview(activeP1.Back)
    }
    
    func drawCardP2(player: UIView) {
        war.playerTwoCardsInPlay.append(war.playerTwoCards[0])
        let activeP2 = war.playerTwoCardsInPlay[0]
        war.playerTwoCards.removeAtIndex(0)
        activeP2.Back.image = war.playerOneCardsInPlay[0].backImage
        activeP2.Front.image = UIImage(named: String(activeP2.Name!))
        
        player.addSubview(activeP2.Back)
    }
    
    // FLIP FUNCTIONS
    
    func tappedP1() {
        print(war.playerOneCardsInPlay[0].Name!)
        if (war.playerOneCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Front, toView: war.playerOneCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = false
            
        } else {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Back, toView: war.playerOneCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = true
            if war.playerOneCardsInPlay[0].ShowingFront && war.playerTwoCardsInPlay[0].ShowingFront {
                evaluate()
                war.checkForWin()
                
                if war.bPlayerOneWinner == true {
                    print("Player one wins")
                } else if war.bPlayerOneWinner == false {
                    print("Player 2 wins")
                } else if war.bPlayerOneWinner == nil {
                    print("No winner yet...")
                }
            }
        }
    }
    func tappedP2() {
        print(war.playerTwoCardsInPlay[0].Name!)
        if (war.playerTwoCardsInPlay[0].ShowingFront) {
            
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Front, toView: war.playerTwoCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = false
        } else {
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Back, toView: war.playerTwoCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = true
            if war.playerOneCardsInPlay[0].ShowingFront && war.playerTwoCardsInPlay[0].ShowingFront {
                evaluate()
                war.checkForWin()
                
                if war.bPlayerOneWinner == true {
                    print("Player one wins")
                } else if war.bPlayerOneWinner == false {
                    print("Player 2 wins")
                } else if war.bPlayerOneWinner == nil {
                    print("No winner yet...")
                }
            }
        }
    }
    
    func evaluate() {
        
        if war.playerOneCardsInPlay[0].Value > war.playerTwoCardsInPlay[0].Value {
            war.playerOneCards.append(war.playerOneCardsInPlay[0])
            war.playerOneCards.append(war.playerTwoCardsInPlay[0])
            war.playerOneCardsInPlay.removeAll()
            war.playerTwoCardsInPlay.removeAll()
            
            // Animate
            normalWinP1()
            
            print("P1 wins this round")
        }
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            war.playerTwoCards.append(war.playerTwoCardsInPlay[0])
            war.playerTwoCards.append(war.playerOneCardsInPlay[0])
            war.playerTwoCardsInPlay.removeAll()
            war.playerOneCardsInPlay.removeAll()
            
            // Animate
            normalWinP2()
            
            print("P2 wins this round")
        }
        else {
            print("War!")
            war.warScenario(0)
        }
    }
    
    // CARD ANIMATIONS
    
    func startAnimation() {
        UIView.animateWithDuration(0.8, delay: 0, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.8, delay: 0.3, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func normalWinP1() {
        UIView.animateWithDuration(1.2, delay: 2.8, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = -500
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.updateCounter()
                self.showButton()
        })
        UIView.animateWithDuration(1.2, delay: 2, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = 900
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.updateCounter()
                self.showButton()
        })
        
    }
    
    func normalWinP2() {
        UIView.animateWithDuration(1.2, delay: 2, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = 900
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.updateCounter()
                self.showButton()
        })
        UIView.animateWithDuration(1.2, delay: 2.8, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -500
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.updateCounter()
                self.showButton()
        })
    }
}
