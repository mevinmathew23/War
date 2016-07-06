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
    
    @IBOutlet weak var cardViewP1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2Constraint: NSLayoutConstraint!
    
    let war = War();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.playRoundButton.setTitle("Play", forState: UIControlState.Normal)
        
        let tapP1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP1))
        let tapP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP2))
        tapP1.numberOfTapsRequired = 1
        tapP2.numberOfTapsRequired = 1
        cardViewP1.addGestureRecognizer(tapP1)
        cardViewP2.addGestureRecognizer(tapP2)
        
        
        /*war.play();
        
        if war.bPlayerOneWinner {
            print("Player one wins")
        } else{
            print("Player 2 wins")
        }*/
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
    
    @IBAction func playRoundTapped(sender: UIButton) {
        
        war.addCards("spades")
        war.addCards("clubs")
        war.addCards("diamonds")
        war.addCards("hearts")
        
        war.deckOfCards.shuffle();
        war.deal();
        
        drawCardP1(cardViewP1)
        drawCardP2(cardViewP2)
        
        playRoundButton.removeFromSuperview()
        
        // Animate cards dealt
        startAnimation()
    }
    
    // DECK COUNTERS
    
    func deckCounter() {
        // let deckCountP1 = UILabel(frame: 0, 0, 50, 50)
        
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
            }
        }
    }
    
    func evaluate() {
        if war.playerOneCardsInPlay[0].Value > war.playerTwoCardsInPlay[0].Value {
            war.playerOneCards.append(war.playerOneCardsInPlay[0])
            war.playerOneCards.append(war.playerTwoCardsInPlay[0])
            war.playerOneCardsInPlay.removeAtIndex(0)
            war.playerTwoCardsInPlay.removeAtIndex(0)
            print("P1 WINS")
            
            // Animate P1 Win
            normalWinP1()
        }
            
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            war.playerTwoCards.append(war.playerTwoCardsInPlay[0])
            war.playerTwoCards.append(war.playerOneCardsInPlay[0])
            war.playerTwoCardsInPlay.removeAtIndex(0)
            war.playerOneCardsInPlay.removeAtIndex(0)
            print(" P2 Wins")
            
            // Animate P2 Win
            normalWinP2()
        }
        else {
            print("WAR!")
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
            }, completion: nil)
        UIView.animateWithDuration(1.2, delay: 2, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = 900
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func normalWinP2() {
        UIView.animateWithDuration(1.2, delay: 2, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = 900
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1.2, delay: 2.8, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -500
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
