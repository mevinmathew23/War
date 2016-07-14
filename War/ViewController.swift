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
    
    // War counters
    var playerOneWinCounter = 0
    var playerTwoWinCounter = 0
    var counterTemp = 0
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rotate player 2 counter
        playerTwoCounter.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        hideCounter()
        
        // Rotate player 2 card views
        cardViewP2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War1.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War3.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
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
            warScenario(0)
        }
    }
    
    func checkWinner() {
        if war.bPlayerOneWinner == true {
            print("Player one wins")
        } else if war.bPlayerOneWinner == false {
            print("Player 2 wins")
        } else if war.bPlayerOneWinner == nil {
            print("No winner yet...")
            showButton()
        }
        
    }
    
    // War Scenario
    
    func warScenario( warCounter: Int)  {
        
        cardViewP1.userInteractionEnabled = false
        cardViewP2.userInteractionEnabled = false
        
        counterTemp = warCounter
        
        guard war.playerOneCards.count >= 3 else{
            war.playerOneCards.removeAll()
            war.checkDeck()
            war.checkWinner()
            return
        }
        
        guard war.playerTwoCards.count >= 3 else{
            war.playerTwoCards.removeAll()
            war.checkDeck()
            war.checkWinner()
            return
        }
        
        guard counterTemp < 3 else {
            return
        }
        
        counterTemp += 1
        playerOneWinCounter = 0
        playerTwoWinCounter = 0
    }
    
    func evaluateWar() {
        
        if war.playerOneCardsInPlay[0].Value > war.playerTwoCardsInPlay[0].Value {
            print("P1 wins this battle...")
            playerOneWinCounter += 1
            storeWar()
        }
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            print("P2 wins this battle...")
            playerTwoWinCounter += 1
            storeWar()
        }
        else {
            print("Nobody wins this war...")
            moveToStorage()
            warScenario(counterTemp)
        }
    }
    
    func warWinner() {
        if playerOneWinCounter >= 2 {
            print("Player one wins the war!")
            for i in war.playerOneStorage {
                war.playerOneCards.append(i)
            }
            for j in war.playerTwoStorage {
                war.playerOneCards.append(j)
            }
            war.playerOneStorage.removeAll()
            war.playerTwoStorage.removeAll()
            war.playerOneCardsInPlay.removeAll()
            war.playerTwoCardsInPlay.removeAll()
            
            warWinP1()
            
        } else if playerTwoWinCounter >= 2 {
            print("Player two wins the war!")
            for i in war.playerOneStorage {
                war.playerTwoCards.append(i)
            }
            for j in war.playerTwoStorage {
                war.playerTwoCards.append(j)
            }
            war.playerOneStorage.removeAll()
            war.playerTwoStorage.removeAll()
            war.playerOneCardsInPlay.removeAll()
            war.playerTwoCardsInPlay.removeAll()
            
            warWinP2()
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
    
    // DRAW WAR CARDS
    
    func drawWarCards() {
        let cardViewP1Array: Array = [cardViewP1War1, cardViewP1War2, cardViewP1War3]
        let cardViewP2Array: Array = [cardViewP2War1, cardViewP2War2, cardViewP2War3]
        
        for j in 2.stride(through: 0, by: -1) {
            let j1 = war.playerOneCards[j]
            let j2 = war.playerTwoCards[j]
            
            let assignedViewP1 = cardViewP1Array[(2-j)]
            let assignedViewP2 = cardViewP2Array[(2-j)]
            
            war.playerOneCardsInPlay.append(j1)
            war.playerTwoCardsInPlay.append(j2)
            
            war.playerOneCards.removeAtIndex(j)
            war.playerTwoCards.removeAtIndex(j)
            
            j1.Front.image = UIImage(named: String(j1.Name!))
            j1.Back.image = j1.backImage
            j2.Front.image = UIImage(named: String(j2.Name!))
            j2.Back.image = j2.backImage
            
            assignedViewP1.addSubview(j1.Back)
            assignedViewP2.addSubview(j2.Back)
        }
        warTapGest1()
    }
    
    func warTapGest1() {
        let tapWarP1 = UITapGestureRecognizer(target: self, action: #selector (ViewController.tappedWarP1))
        let tapWarP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedWarP2))
        cardViewP1War1.userInteractionEnabled = true
        cardViewP2War1.userInteractionEnabled = true
        tapWarP1.numberOfTapsRequired = 1
        tapWarP2.numberOfTapsRequired = 1
        cardViewP1War1.addGestureRecognizer(tapWarP1)
        cardViewP2War1.addGestureRecognizer(tapWarP2)
    }
    func warTapGest2() {
        let tapWarP1 = UITapGestureRecognizer(target: self, action: #selector (ViewController.tappedWarP1))
        let tapWarP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedWarP2))
        cardViewP1War2.userInteractionEnabled = true
        cardViewP2War2.userInteractionEnabled = true
        tapWarP1.numberOfTapsRequired = 1
        tapWarP2.numberOfTapsRequired = 1
        cardViewP1War2.addGestureRecognizer(tapWarP1)
        cardViewP2War2.addGestureRecognizer(tapWarP2)
    }
    func warTapGest3() {
        let tapWarP1 = UITapGestureRecognizer(target: self, action: #selector (ViewController.tappedWarP1))
        let tapWarP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedWarP2))
        cardViewP1War3.userInteractionEnabled = true
        cardViewP2War3.userInteractionEnabled = true
        tapWarP1.numberOfTapsRequired = 1
        tapWarP2.numberOfTapsRequired = 1
        cardViewP1War3.addGestureRecognizer(tapWarP1)
        cardViewP2War3.addGestureRecognizer(tapWarP2)
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
            }
        }
    }
    func tappedWarP1() {
        print(war.playerOneCardsInPlay[0].Name!)
        if (war.playerOneCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Front, toView: war.playerOneCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = false
            
        } else {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Back, toView: war.playerOneCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = true
            if war.playerOneCardsInPlay[0].ShowingFront && war.playerTwoCardsInPlay[0].ShowingFront {
                
                evaluateWar()
            }
        }
    }
    func tappedWarP2() {
        print(war.playerTwoCardsInPlay[0].Name!)
        if (war.playerTwoCardsInPlay[0].ShowingFront) {
            
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Front, toView: war.playerTwoCardsInPlay[0].Back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = false
        } else {
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Back, toView: war.playerTwoCardsInPlay[0].Front, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = true
            if war.playerOneCardsInPlay[0].ShowingFront && war.playerTwoCardsInPlay[0].ShowingFront {
                
                evaluateWar()
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
                self.war.playerTwoCardsInPlay[0].Front.removeFromSuperview()
                self.war.normalWinP2AppendP2()
                self.updateCounter()
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                self.checkWinner()
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
        
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseOut], animations: {
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
                self.war.appendAllP1()
        })
        UIView.animateWithDuration(0.6, delay: 1.6, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = self.view.bounds.height/2
            self.cardViewP2X.constant = -(self.view.bounds.width/2) + ((self.cardViewP2.bounds.width/2)+5)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendAllP2()
                self.startWar()
                self.drawWarCards()
        })
    }
    
    func storeWar() {
        if (playerOneWinCounter + playerTwoWinCounter) == 1 {
            UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut], animations: {
                self.cardViewP1War1Constraint.constant = self.view.bounds.height/2
                self.cardViewP1War1X.constant = (self.view.bounds.width/2) - ((self.cardViewP1War1.bounds.width/2)-5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP1War1.userInteractionEnabled = false
                    self.war.appendStorageP1()
            })
            UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
                self.cardViewP2War1Constraint.constant = self.view.bounds.height/2
                self.cardViewP2War1X.constant = -(self.view.bounds.width/2) + ((self.cardViewP2War1.bounds.width/2)+5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP2War1.userInteractionEnabled = false
                    self.war.appendStorageP2()
                    self.warTapGest2()
            })
        }
        else if (playerOneWinCounter + playerTwoWinCounter) == 2 {
            UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut], animations: {
                self.cardViewP1War2Constraint.constant = self.view.bounds.height/2
                self.cardViewP1War2X.constant = (self.view.bounds.width/2) - ((self.cardViewP1War2.bounds.width/2)-5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP1War2.userInteractionEnabled = false
                    self.war.appendStorageP1()
            })
            UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
                self.cardViewP2War2Constraint.constant = self.view.bounds.height/2
                self.cardViewP2War2X.constant = -(self.view.bounds.width/2) + ((self.cardViewP2War2.bounds.width/2)+5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP2War2.userInteractionEnabled = false
                    self.war.appendStorageP2()
                    self.warTapGest3()
            })
        }
        else if (playerOneWinCounter + playerTwoWinCounter) == 3 {
            UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut], animations: {
                self.cardViewP1War3Constraint.constant = self.view.bounds.height/2
                self.cardViewP1War3X.constant = (self.view.bounds.width/2) - ((self.cardViewP1War3.bounds.width/2)-5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP1War3.userInteractionEnabled = false
                    self.war.appendStorageP1()
            })
            UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
                self.cardViewP2War3Constraint.constant = self.view.bounds.height/2
                self.cardViewP2War3X.constant = -(self.view.bounds.width/2) + ((self.cardViewP2War3.bounds.width/2)+5)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP2War3.userInteractionEnabled = false
                    self.war.appendStorageP2()
                    self.warWinner()
            })
        }
    }
    func warWinP1() {
        UIView.animateWithDuration(1, delay: 1.6, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = -self.view.bounds.height
            self.cardViewP1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = self.view.bounds.height
            self.cardViewP2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.8, options: [.CurveEaseOut], animations: {
            self.cardViewP1War1Constraint.constant = -self.view.bounds.height
            self.cardViewP1War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War1X.constant = 15
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.7, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = self.view.bounds.height
            self.cardViewP2War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War1Constraint.constant = -self.view.bounds.height
                self.cardViewP2War1X.constant = -15
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = -self.view.bounds.height
            self.cardViewP1War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War2X.constant = 30
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.9, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = self.view.bounds.height
            self.cardViewP2War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War2Constraint.constant = -self.view.bounds.height
                self.cardViewP2War2X.constant = -30
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 2.2, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = -self.view.bounds.height
            self.cardViewP1War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War3X.constant = 45
                self.view.layoutIfNeeded()
                self.showButton()
        })
        UIView.animateWithDuration(1, delay: 2.1, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = self.view.bounds.height
            self.cardViewP2War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War3Constraint.constant = -self.view.bounds.height
                self.cardViewP2War3X.constant = -45
                self.view.layoutIfNeeded()
                self.updateCounter()
        })
    }
    func warWinP2() {
        UIView.animateWithDuration(1, delay: 1.5, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = self.view.bounds.height
            self.cardViewP1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.6, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -self.view.bounds.height
            self.cardViewP2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.7, options: [.CurveEaseOut], animations: {
            self.cardViewP1War1Constraint.constant = self.view.bounds.height
            self.cardViewP1War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War1Constraint.constant = -self.view.bounds.height
                self.cardViewP1War1X.constant = 15
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.8, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = -self.view.bounds.height
            self.cardViewP2War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War1X.constant = -15
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 1.9, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = self.view.bounds.height
            self.cardViewP1War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War2Constraint.constant = -self.view.bounds.height
                self.cardViewP1War2X.constant = 30
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 2, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = -self.view.bounds.height
            self.cardViewP2War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War2X.constant = -30
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 2.1, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = self.view.bounds.height
            self.cardViewP1War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War3Constraint.constant = -self.view.bounds.height
                self.cardViewP1War3X.constant = 45
                self.view.layoutIfNeeded()
                self.updateCounter()
        })
        UIView.animateWithDuration(1, delay: 2.2, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = -self.view.bounds.height
            self.cardViewP2War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War3X.constant = -45
                self.view.layoutIfNeeded()
                self.showButton()
        })
    }
}
