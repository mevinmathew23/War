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
    @IBOutlet weak var cardViewP1War1: UIView!
    @IBOutlet weak var cardViewP1War2: UIView!
    @IBOutlet weak var cardViewP1War3: UIView!
    
    @IBOutlet weak var cardViewP2: UIView!
    @IBOutlet weak var cardViewP2War1: UIView!
    @IBOutlet weak var cardViewP2War2: UIView!
    @IBOutlet weak var cardViewP2War3: UIView!
    
    // Top and bottom constraints
    
    @IBOutlet weak var cardViewP1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War3Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardViewP2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War3Constraint: NSLayoutConstraint!
    
    // Horizontally centered alignment
    
    @IBOutlet weak var cardViewP1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War3X: NSLayoutConstraint!
    
    @IBOutlet weak var cardViewP2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War3X: NSLayoutConstraint!
    
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playerOneCounter: UILabel!
    @IBOutlet weak var playerTwoCounter: UILabel!
    
    let war = War()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rotate player 2 counter
        playerTwoCounter.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        hideCounter()
        
        // Rotate player 2 Card view
        cardViewP2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
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
        self.cardViewP1Constraint.constant = -view.bounds.height
        self.cardViewP1War1Constraint.constant = -view.bounds.height
        self.cardViewP1War2Constraint.constant = -view.bounds.height
        self.cardViewP1War3Constraint.constant = -view.bounds.height
        
        self.cardViewP2Constraint.constant = -view.bounds.height
        self.cardViewP2War1Constraint.constant = -view.bounds.height
        self.cardViewP2War2Constraint.constant = -view.bounds.height
        self.cardViewP2War3Constraint.constant = -view.bounds.height
        
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Button Click Action
    
    @IBAction func playRoundTapped(sender: UIButton) {
        
        drawCardP1(cardViewP1)
        drawCardP2(cardViewP2)
        
        showCounter()
        updateCounter()
        
        hideButton()
        
        startAnimation()
    }
    
    // Evaluate upon flipping
    
    func evaluate() {
        
        if war.playerOneCardsInPlay[0].Value > war.playerTwoCardsInPlay[0].Value {
            normalWinP1()
            
            print("P1 wins this round")
        }
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            normalWinP2()
            
            print("P2 wins this round")
        }
        else {
            print("War!")
            moveToStorage()
            war.warScenario(0)
        }
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
        playerOneCounter.text = String(war.playerOneCards.count)
        playerTwoCounter.text = String(war.playerTwoCards.count)
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
        activeP1.Front.image = UIImage(named: String(activeP1.Name!))
        activeP1.Back.image = war.playerOneCardsInPlay[0].backImage
        
        player.addSubview(activeP1.Back)
    }
    
    func drawCardP2(player: UIView) {
        war.playerTwoCardsInPlay.append(war.playerTwoCards[0])
        let activeP2 = war.playerTwoCardsInPlay[0]
        war.playerTwoCards.removeAtIndex(0)
        activeP2.Front.image = UIImage(named: String(activeP2.Name!))
        activeP2.Back.image = war.playerOneCardsInPlay[0].backImage
        
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
                war.checkDeck()
                war.checkWinner()
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
                war.checkDeck()
                war.checkWinner()
            }
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
        UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = -self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP1AppendP1()
                self.updateCounter()
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                self.showButton()
        })
        UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP1AppendP2()
                self.updateCounter()
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        
    }
    
    func normalWinP2() {
        UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP2AppendP1()
                self.updateCounter()
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP2AppendP2()
                self.updateCounter()
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                self.showButton()
        })
    }
    
    func startWar() {
        
        // P1
        
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseOut], animations: {
            self.cardViewP1War1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0.3, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0.6, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // P2
        
        UIView.animateWithDuration(1, delay: 1, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0.4, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0.7, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    func moveToStorage() {
        UIView.animateWithDuration(0.6, delay: 1.5, options: [.CurveEaseOut], animations: {
            self.cardViewP1Constraint.constant = self.view.bounds.height/2
            self.cardViewP1X.constant = (self.view.bounds.width/2) - ((self.cardViewP1.bounds.width/2)-5)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendStorageP1()
        })
        UIView.animateWithDuration(0.6, delay: 1.6, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = self.view.bounds.height/2
            self.cardViewP2X.constant = -(self.view.bounds.width/2) + ((self.cardViewP2.bounds.width/2)+5)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendStorageP2()
        })
    }
}
