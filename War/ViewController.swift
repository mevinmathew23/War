//
//  ViewController.swift
//  War
//
//  Created by Apple Dev on 2016-06-21.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

var roundCount = 1

class ViewController: UIViewController {
    
    let war = War()
    let settings = Settings()
    let audio = Audio()
    let sounds = Sounds()
    
    // War counters
    var playerOneWinCounter = 0
    var playerTwoWinCounter = 0
    var counterTemp = 0
    
    let overlay: UIView = UIView()
    
    let sFX = Settings().defaults.boolForKey("soundFX")
    
    var playerOneWin: Bool? = nil
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardViews()
        setWarViews()
        setChips()
        setNotifications()
        setPlayRoundButton()
        setBetButton()
        setTapGest()
        
        rotateForP2()
        
        // Hide views
        hideCounter()
        hideWallet()
        hideStorageCounter()
        chipsView.hidden = true
        placeBet.hidden = true
        
        changeBackground()
        resetGlobals()
        
        // Setup cards
        war.addCards("spades")
        war.addCards("clubs")
        war.addCards("diamonds")
        war.addCards("hearts")
        
        war.deckOfCards.shuffle()
        war.deal()
        
        // Rely on new card sizes
        setOverlay()
        setCounters()
        
        self.view.setNeedsLayout()
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    // Button Click Action
    
    @IBAction func playRoundTapped(sender: UIButton) {
        startRound()
        hideButton()
    }
    @IBAction func placeBets(sender: AnyObject) {
        bet(totalBet)
        isBettingPhase = false
        chipsView.hidden = true
        placeBet.hidden = true
        updateWallet()
        
        startAnimation()
    }
    @IBAction func Quit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Evaluation
    
    func evaluate() {
        
        if war.playerOneCardsInPlay[0].Value > war.playerTwoCardsInPlay[0].Value {
            //normalWinP1()
            playerOneWin = true
            notifyP1.text = "BLUE WINS ROUND " + String(roundCount)
            notifyP2.text = "BLUE WINS ROUND " + String(roundCount)
            notifyP1.textColor = settings.p1Blue
            notifyP2.textColor = settings.p1Blue
            
            showOverlay()
            
            roundCount += 1
            print("P1 wins this round")
        }
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            //normalWinP2()
            playerOneWin = false
            notifyP1.text = "RED WINS ROUND " + String(roundCount)
            notifyP2.text = "RED WINS ROUND " + String(roundCount)
            notifyP1.textColor = settings.p2Red
            notifyP2.textColor = settings.p2Red
            
            showOverlay()
            
            roundCount += 1
            print("P2 wins this round")
        }
        else {
            print("War!")
            moveToStorageTimer()
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
            startRound()
        }
        
    }
    
    
    // MARK: War Scenario
    
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
            storeWarTimer()
        }
        else if war.playerOneCardsInPlay[0].Value < war.playerTwoCardsInPlay[0].Value {
            print("P2 wins this battle...")
            playerTwoWinCounter += 1
            storeWarTimer()
        }
        else {
            print("Nobody wins this war...")
            warToStorageTimer()
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
            
            roundCount += 1
            
            hideStorageCounter()
            warWinP1Timer()
            
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
            
            roundCount += 1
            
            hideStorageCounter()
            warWinP2Timer()
        }
    }
    
    
    // MARK: Draw Cards
    
    func startRound() {
        guard (playerOneMoney <= 0 || playerTwoMoney <= 0) == false else {
            return
        }
        drawCardP1(cardViewP1)
        drawCardP2(cardViewP2)
        
        isBettingPhase = true
        shiftChips()
        
        showCounter()
        showWallet()
        updateCounter()
        updateWallet()
        updateChips()
        
        chipsView.hidden = false
        placeBet.hidden = false
    }
    
    //      Draw cards
    
    func drawCardP1(player: UIView) {
        guard war.playerOneCards.count > 0 else {
            return
        }
        war.playerOneCardsInPlay.append(war.playerOneCards[0])
        let activeP1 = war.playerOneCardsInPlay[0]
        war.playerOneCards.removeAtIndex(0)
        
        activeP1.Back = UIImageView(frame: CGRectMake(0,0, player.frame.width, player.frame.height))
        activeP1.Front = UIImageView(frame: CGRectMake(0,0, player.frame.width, player.frame.height))
        
        activeP1.Back.image = war.playerOneCardsInPlay[0].backImage
        activeP1.Front.image = UIImage(named: String(activeP1.Name!))
        
        player.userInteractionEnabled = true
        activeP1.ShowingFront = false
        player.addSubview(activeP1.Back)
    }
    
    func drawCardP2(player: UIView) {
        guard war.playerTwoCards.count > 0 else {
            return
        }
        war.playerTwoCardsInPlay.append(war.playerTwoCards[0])
        let activeP2 = war.playerTwoCardsInPlay[0]
        war.playerTwoCards.removeAtIndex(0)
        
        activeP2.Back = UIImageView(frame: CGRectMake(0,0, player.frame.width, player.frame.height))
        activeP2.Front = UIImageView(frame: CGRectMake(0,0, player.frame.width, player.frame.height))
        
        activeP2.Back.image = war.playerOneCardsInPlay[0].backImage
        activeP2.Front.image = UIImage(named: String(activeP2.Name!))
        
        player.userInteractionEnabled = true
        activeP2.ShowingFront = false
        player.addSubview(activeP2.Back)
    }
    
    
    //      Draw War Cards
    
    func drawWarCards() {
        guard  war.playerOneCards.count >= 3 && war.playerTwoCards.count >= 3 else {
            return
        }
        let cardViewP1Array: Array = [cardViewP1War1, cardViewP1War2, cardViewP1War3]
        let cardViewP2Array: Array = [cardViewP2War1, cardViewP2War2, cardViewP2War3]
        
        for j in 2.stride(through: 0, by: -1) {
            let j1 = war.playerOneCards[j]
            let j2 = war.playerTwoCards[j]
            
            let assignedViewP1 = cardViewP1Array[(2-j)]
            let assignedViewP2 = cardViewP2Array[(2-j)]
            
            j1.ShowingFront = false
            j2.ShowingFront = false
            
            war.playerOneCardsInPlay.append(j1)
            war.playerTwoCardsInPlay.append(j2)
            
            war.playerOneCards.removeAtIndex(j)
            war.playerTwoCards.removeAtIndex(j)
            
            j1.Back = UIImageView(frame: CGRectMake(0,0, assignedViewP1.frame.width, assignedViewP1.frame.height))
            j1.Front = UIImageView(frame: CGRectMake(0,0, assignedViewP1.frame.width, assignedViewP1.frame.height))
            j2.Back = UIImageView(frame: CGRectMake(0,0, assignedViewP2.frame.width, assignedViewP2.frame.height))
            j2.Front = UIImageView(frame: CGRectMake(0,0, assignedViewP2.frame.width, assignedViewP2.frame.height))
            
            j1.Front.image = UIImage(named: String(j1.Name!))
            j1.Back.image = j1.backImage
            j2.Front.image = UIImage(named: String(j2.Name!))
            j2.Back.image = j2.backImage
            
            updateCounter()
            
            assignedViewP1.addSubview(j1.Back)
            assignedViewP2.addSubview(j2.Back)
        }
        warTapGest1()
        startWar()
    }
    
    
    // MARK: Flip
    // Flip Functions
    
    func tappedP1() {
        print(war.playerOneCardsInPlay[0].Name!)
        if sFX == false {
            sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
            sounds.toggleAVPlayer()
        }
        if (war.playerOneCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Front, toView: war.playerOneCardsInPlay[0].Back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = false
            
        } else {
            cardViewP1.userInteractionEnabled = false
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Back, toView: war.playerOneCardsInPlay[0].Front, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: {
                finished in
                self.war.playerOneCardsInPlay[0].ShowingFront = true
                if self.war.playerOneCardsInPlay[0].ShowingFront && self.war.playerTwoCardsInPlay[0].ShowingFront {
                    self.evaluate()
                    self.war.checkDeck()
                }
            })
        }
    }
    func tappedP2() {
        print(war.playerTwoCardsInPlay[0].Name!)
        if sFX == false {
            sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
            sounds.toggleAVPlayer()
        }
        if (war.playerTwoCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Front, toView: war.playerTwoCardsInPlay[0].Back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = false
            
        } else {
            cardViewP2.userInteractionEnabled = false
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Back, toView: war.playerTwoCardsInPlay[0].Front, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: {
                finished in
                self.war.playerTwoCardsInPlay[0].ShowingFront = true
                if self.war.playerOneCardsInPlay[0].ShowingFront && self.war.playerTwoCardsInPlay[0].ShowingFront {
                    self.evaluate()
                    self.war.checkDeck()
                }
            })
        }
    }
    func tappedWarP1() {
        print(war.playerOneCardsInPlay[0].Name!)
        if sFX == false {
            sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
            sounds.toggleAVPlayer()
        }
        if (war.playerOneCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Front, toView: war.playerOneCardsInPlay[0].Back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerOneCardsInPlay[0].ShowingFront = false
            
        } else {
            
            if (playerOneWinCounter + playerTwoWinCounter) == 0 {
                cardViewP1War1.userInteractionEnabled = false
            } else if (playerOneWinCounter + playerTwoWinCounter) == 1 {
                cardViewP1War2.userInteractionEnabled = false
            } else if (playerOneWinCounter + playerTwoWinCounter) == 2 {
                cardViewP1War3.userInteractionEnabled = false
            }
            
            UIView.transitionFromView(war.playerOneCardsInPlay[0].Back, toView: war.playerOneCardsInPlay[0].Front, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: {
                finished in
                self.war.playerOneCardsInPlay[0].ShowingFront = true
                if self.war.playerOneCardsInPlay[0].ShowingFront && self.war.playerTwoCardsInPlay[0].ShowingFront {
                    self.evaluateWar()
                }
            })
        }
    }
    func tappedWarP2() {
        print(war.playerTwoCardsInPlay[0].Name!)
        if sFX == false {
            sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
            sounds.toggleAVPlayer()
        }
        if (war.playerTwoCardsInPlay[0].ShowingFront) {
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Front, toView: war.playerTwoCardsInPlay[0].Back, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            war.playerTwoCardsInPlay[0].ShowingFront = false
            
        } else {
            
            if (playerOneWinCounter + playerTwoWinCounter) == 0 {
                cardViewP2War1.userInteractionEnabled = false
            } else if (playerOneWinCounter + playerTwoWinCounter) == 1 {
                cardViewP2War2.userInteractionEnabled = false
            } else if (playerOneWinCounter + playerTwoWinCounter) == 2 {
                cardViewP2War3.userInteractionEnabled = false
            }
            
            UIView.transitionFromView(war.playerTwoCardsInPlay[0].Back, toView: war.playerTwoCardsInPlay[0].Front, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: {
                finished in
                self.war.playerTwoCardsInPlay[0].ShowingFront = true
                if self.war.playerOneCardsInPlay[0].ShowingFront && self.war.playerTwoCardsInPlay[0].ShowingFront {
                    self.evaluateWar()
                }
            })
        }
    }
    
    // MARK: Card Animations
    
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
    
    func normalWinP1Timer() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.normalWinP1), userInfo: nil, repeats: false)
    }
    
    func normalWinP1() {
        UIView.animateWithDuration(0.75, delay: 0.75, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = -self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP1AppendP1()
                self.updateCounter()
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                self.checkWinner()
        })
        UIView.animateWithDuration(0.75, delay: 0, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP2Constraint.constant = self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP1AppendP2()
                roundWinner(&playerOneMoney)
                self.updateWallet()
                self.updateCounter()
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide2", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
        
    }
    
    func normalWinP2Timer() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.normalWinP2), userInfo: nil, repeats: false)
    }
    
    func normalWinP2() {
        UIView.animateWithDuration(0.75, delay: 0, options: [.CurveEaseOut],animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP1Constraint.constant = self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP2AppendP1()
                roundWinner(&playerTwoMoney)
                self.updateWallet()
                self.updateCounter()
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
                
        })
        UIView.animateWithDuration(0.75, delay: 0.75, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -self.view.bounds.height
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.normalWinP2AppendP2()
                self.updateCounter()
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
                self.checkWinner()
        })
    }
    
    func startWar() {
        
        self.view.layoutIfNeeded()
        
        // P1
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
                self.sounds.playAVPlayer()
            }
            self.cardViewP1War1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardFlip2", volume: 1.0)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.3, delay: 0.3, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardFlip3", volume: 1.0)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.3, delay: 0.6, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // P2
        
        UIView.animateWithDuration(0.4, delay: 0, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardFlip", volume: 1.0)
                self.sounds.playAVPlayer()
            }
            self.cardViewP2War1Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardFlip2", volume: 1.0)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.3, delay: 0.4, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardFlip3", volume: 1.0)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.3, delay: 0.7, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = 50
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func moveToStorageTimer() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.moveToStorage), userInfo: nil, repeats: false)
    }
    
    func moveToStorage() {
        UIView.animateWithDuration(0.6, delay: 0, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP1Constraint.constant = self.view.bounds.height/4
            self.cardViewP1X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendAllP1()
        })
        UIView.animateWithDuration(0.6, delay: 0.1, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP2Constraint.constant = self.view.bounds.height/4
            self.cardViewP2X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendAllP2()
                self.drawWarCards()
                self.updateStorageCounter()
                self.showStorageCounter()
        })
    }
    
    func warToStorageTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.warToStorage), userInfo: nil, repeats: false)
    }
    
    func warToStorage() {
        UIView.animateWithDuration(0.5, delay: 0.1, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                self.sounds.playAVPlayer()
            }
            
            self.cardViewP1War1Constraint.constant = self.view.bounds.height/4
            self.cardViewP1War1X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendAllP1()
                self.updateCounter()
                self.updateStorageCounter()
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide2", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = self.view.bounds.height/4
            self.cardViewP2War1X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.war.appendAllP2()
                self.updateCounter()
                self.updateStorageCounter()
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.5, delay: 0.6, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = self.view.bounds.height/4
            self.cardViewP1War2X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 1.7, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = self.view.bounds.height/4
            self.cardViewP2War2X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.view.layoutIfNeeded()
                self.setWarViews()
                self.view.setNeedsLayout()
                self.drawWarCards()
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.5, delay: 0.5, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = self.view.bounds.height/4
            self.cardViewP1War3X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
        UIView.animateWithDuration(0.5, delay: 1.1, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = self.view.bounds.height/4
            self.cardViewP2War3X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
        })
    }
    
    func storeWarTimer() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.storeWar), userInfo: nil, repeats: false)
    }
    
    func storeWar() {
        if (playerOneWinCounter + playerTwoWinCounter) == 1 {
            UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
                
                self.cardViewP1War1Constraint.constant = self.view.bounds.height/4
                self.cardViewP1War1X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP1War2.userInteractionEnabled = true
                    self.war.appendStorageP1()
                    self.updateStorageCounter()
                    if self.sFX == false {
                        self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                        self.sounds.playAVPlayer()
                    }
                    
            })
            UIView.animateWithDuration(0.5, delay: 0.5, options: [.CurveEaseOut], animations: {
                self.cardViewP2War1Constraint.constant = self.view.bounds.height/4
                self.cardViewP2War1X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP2War2.userInteractionEnabled = true
                    self.war.appendStorageP2()
                    self.updateStorageCounter()
                    self.warTapGest2()
            })
        }
        else if (playerOneWinCounter + playerTwoWinCounter) == 2 {
            UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
                
                self.cardViewP1War2Constraint.constant = self.view.bounds.height/4
                self.cardViewP1War2X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP1War3.userInteractionEnabled = true
                    self.war.appendStorageP1()
                    self.updateStorageCounter()
                    if self.sFX == false {
                        self.sounds.readFileIntoAVPlayer("cardSlide2", volume: 1)
                        self.sounds.playAVPlayer()
                    }
                    
            })
            UIView.animateWithDuration(0.5, delay: 0.5, options: [.CurveEaseOut], animations: {
                self.cardViewP2War2Constraint.constant = self.view.bounds.height/4
                self.cardViewP2War2X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.cardViewP2War3.userInteractionEnabled = true
                    self.war.appendStorageP2()
                    self.updateStorageCounter()
                    self.warTapGest3()
            })
        }
        else if (playerOneWinCounter + playerTwoWinCounter) == 3 {
            UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
                if self.sFX == false {
                    self.sounds.readFileIntoAVPlayer("cardSlide", volume: 1)
                    self.sounds.playAVPlayer()
                }
                
                self.cardViewP1War3Constraint.constant = self.view.bounds.height/4
                self.cardViewP1War3X.constant = -(self.view.bounds.width/2) + (self.cardViewP1.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.war.appendStorageP1()
                    self.updateStorageCounter()
                    if self.sFX == false {
                        self.sounds.readFileIntoAVPlayer("cardSlide2", volume: 1)
                        self.sounds.playAVPlayer()
                    }
                    
            })
            UIView.animateWithDuration(0.5, delay: 0.5, options: [.CurveEaseOut], animations: {
                self.cardViewP2War3Constraint.constant = self.view.bounds.height/4
                self.cardViewP2War3X.constant = (self.view.bounds.width/2) - (self.cardViewP2.bounds.width/2)
                self.view.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.war.appendStorageP2()
                    self.updateStorageCounter()
                    self.warWinner()
            })
        }
    }
    func warWinP1Timer() {
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.warWinP1), userInfo: nil, repeats: false)
    }
    func warWinP1() {
        UIView.animateWithDuration(1, delay: 0.1, options: [.CurveEaseOut],animations: {
            self.cardViewP1Constraint.constant = -self.view.bounds.height
            self.cardViewP1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                roundWinner(&playerOneMoney)
                self.updateWallet()
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseOut], animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("riffle", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP2Constraint.constant = self.view.bounds.height
            self.cardViewP2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.3, options: [.CurveEaseOut], animations: {
            self.cardViewP1War1Constraint.constant = -self.view.bounds.height
            self.cardViewP1War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War1X.constant = 25
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.2, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = self.view.bounds.height
            self.cardViewP2War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War1Constraint.constant = -self.view.bounds.height
                self.cardViewP2War1X.constant = -25
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.5, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = -self.view.bounds.height
            self.cardViewP1War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War2X.constant = 40
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.4, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = self.view.bounds.height
            self.cardViewP2War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War2Constraint.constant = -self.view.bounds.height
                self.cardViewP2War2X.constant = -40
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.7, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = -self.view.bounds.height
            self.cardViewP1War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War3X.constant = 55
                self.view.layoutIfNeeded()
                self.cardViewP1.userInteractionEnabled = true
                self.cardViewP2.userInteractionEnabled = true
                self.startRound()
        })
        UIView.animateWithDuration(1, delay: 0.6, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = self.view.bounds.height
            self.cardViewP2War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War3Constraint.constant = -self.view.bounds.height
                self.cardViewP2War3X.constant = -55
                self.view.layoutIfNeeded()
                self.updateCounter()
        })
    }
    func warWinP2Timer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ViewController.warWinP2), userInfo: nil, repeats: false)
    }
    func warWinP2() {
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseOut],animations: {
            if self.sFX == false {
                self.sounds.readFileIntoAVPlayer("riffle", volume: 1)
                self.sounds.playAVPlayer()
            }
            self.cardViewP1Constraint.constant = self.view.bounds.height
            self.cardViewP1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1Constraint.constant = -self.view.bounds.height
                roundWinner(&playerTwoMoney)
                self.updateWallet()
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.1, options: [.CurveEaseOut], animations: {
            self.cardViewP2Constraint.constant = -self.view.bounds.height
            self.cardViewP2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2Constraint.constant = -self.view.bounds.height
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.2, options: [.CurveEaseOut], animations: {
            self.cardViewP1War1Constraint.constant = self.view.bounds.height
            self.cardViewP1War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War1Constraint.constant = -self.view.bounds.height
                self.cardViewP1War1X.constant = 25
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.3, options: [.CurveEaseOut], animations: {
            self.cardViewP2War1Constraint.constant = -self.view.bounds.height
            self.cardViewP2War1X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War1X.constant = -25
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.4, options: [.CurveEaseOut], animations: {
            self.cardViewP1War2Constraint.constant = self.view.bounds.height
            self.cardViewP1War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War2Constraint.constant = -self.view.bounds.height
                self.cardViewP1War2X.constant = 40
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.5, options: [.CurveEaseOut], animations: {
            self.cardViewP2War2Constraint.constant = -self.view.bounds.height
            self.cardViewP2War2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War2X.constant = -40
                self.view.layoutIfNeeded()
        })
        UIView.animateWithDuration(1, delay: 0.6, options: [.CurveEaseOut], animations: {
            self.cardViewP1War3Constraint.constant = self.view.bounds.height
            self.cardViewP1War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP1War3Constraint.constant = -self.view.bounds.height
                self.cardViewP1War3X.constant = 55
                self.view.layoutIfNeeded()
                self.updateCounter()
        })
        UIView.animateWithDuration(1, delay: 0.7, options: [.CurveEaseOut], animations: {
            self.cardViewP2War3Constraint.constant = -self.view.bounds.height
            self.cardViewP2War3X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.cardViewP2War3X.constant = -55
                self.view.layoutIfNeeded()
                self.cardViewP1.userInteractionEnabled = true
                self.cardViewP2.userInteractionEnabled = true
                self.startRound()
        })
    }
    
    func changeBackground() {
        let newImage = settings.loadImageFromPath(settings.backgroundPath)
        if newImage == nil {
            backgroundImageView.image = UIImage(named: "backgroundPSI")!
        } else {
            backgroundImageView.image = newImage!
        }
    }
    
    
    // MARK: Properties
    // Card Views
    
    @IBOutlet weak var cardViewP1: UIView!
    @IBOutlet weak var cardViewP1War1: UIView!
    @IBOutlet weak var cardViewP1War2: UIView!
    @IBOutlet weak var cardViewP1War3: UIView!
    
    @IBOutlet weak var cardViewP2: UIView!
    @IBOutlet weak var cardViewP2War1: UIView!
    @IBOutlet weak var cardViewP2War2: UIView!
    @IBOutlet weak var cardViewP2War3: UIView!
    
    @IBOutlet weak var cardViewP1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War1Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War2Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War3Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War3Height: NSLayoutConstraint!
    
    @IBOutlet weak var cardViewP2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War1Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War1Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War2Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War2Height: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War3Constraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War3Height: NSLayoutConstraint!
    
    @IBOutlet weak var cardViewP1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP1War3X: NSLayoutConstraint!
    
    @IBOutlet weak var cardViewP2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War1X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War2X: NSLayoutConstraint!
    @IBOutlet weak var cardViewP2War3X: NSLayoutConstraint!
    
    
    // Chips
    
    @IBOutlet weak var chipsView: Chips!
    @IBOutlet weak var chipsViewWidth: NSLayoutConstraint!
    @IBOutlet weak var chipsViewY: NSLayoutConstraint!
    @IBOutlet weak var chipsViewX: NSLayoutConstraint!
    
    
    // Misc. UI
    
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var playRoundButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var notifyP1: UILabel!
    @IBOutlet weak var notifyP1X: NSLayoutConstraint!
    @IBOutlet weak var notifyP1Y: NSLayoutConstraint!
    @IBOutlet weak var notifyP1Height: NSLayoutConstraint!
    @IBOutlet weak var notifyP1Width: NSLayoutConstraint!
    @IBOutlet weak var notifyP2: UILabel!
    @IBOutlet weak var notifyP2X: NSLayoutConstraint!
    @IBOutlet weak var notifyP2Y: NSLayoutConstraint!
    @IBOutlet weak var notifyP2Height: NSLayoutConstraint!
    @IBOutlet weak var notifyP2Width: NSLayoutConstraint!
    @IBOutlet weak var playerOneHeight: NSLayoutConstraint!
    @IBOutlet weak var playerTwoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var placeBet: UIButton!
    @IBOutlet weak var placeBetWidth: NSLayoutConstraint!
    @IBOutlet weak var placeBetX: NSLayoutConstraint!
    @IBOutlet weak var placeBetY: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playerOneCounter: UILabel!
    @IBOutlet weak var playerTwoCounter: UILabel!
    @IBOutlet weak var playerOneCounterWidth: NSLayoutConstraint!
    @IBOutlet weak var playerTwoCounterWidth: NSLayoutConstraint!
    @IBOutlet weak var playerOneWallet: UILabel!
    @IBOutlet weak var playerTwoWallet: UILabel!
    @IBOutlet weak var playerOneWalletWidth: NSLayoutConstraint!
    @IBOutlet weak var playerTwoWalletWidth: NSLayoutConstraint!
    @IBOutlet weak var playerOneStorageCounter: UILabel!
    @IBOutlet weak var playerTwoStorageCounter: UILabel!
    @IBOutlet weak var playerOneStorageCounterWidth: NSLayoutConstraint!
    @IBOutlet weak var playerTwoStorageCounterWidth: NSLayoutConstraint!
    @IBOutlet weak var playerOneStorageY: NSLayoutConstraint!
    @IBOutlet weak var playerTwoStorageY: NSLayoutConstraint!
    
    
    // MARK: Cards
    
    func setCardViews() {
        cardViewP1Constraint.constant = -view.bounds.height
        cardViewP2Constraint.constant = -view.bounds.height
        
        cardViewP1Height.constant = view.bounds.height/4
        cardViewP1War1Height.constant = view.bounds.height/4
        cardViewP1War2Height.constant = view.bounds.height/4
        cardViewP1War3Height.constant = view.bounds.height/4
        
        cardViewP2Height.constant = view.bounds.height/4
        cardViewP2War1Height.constant = view.bounds.height/4
        cardViewP2War2Height.constant = view.bounds.height/4
        cardViewP2War3Height.constant = view.bounds.height/4
    }
    func setWarViews() {
        cardViewP1War1Constraint.constant = -view.bounds.height
        cardViewP1War2Constraint.constant = -view.bounds.height
        cardViewP1War3Constraint.constant = -view.bounds.height
        
        cardViewP2War1Constraint.constant = -view.bounds.height
        cardViewP2War2Constraint.constant = -view.bounds.height
        cardViewP2War3Constraint.constant = -view.bounds.height
        
        cardViewP1War1X.constant = 25
        cardViewP1War2X.constant = 40
        cardViewP1War3X.constant = 55
        
        cardViewP2War1X.constant = -25
        cardViewP2War2X.constant = -40
        cardViewP2War3X.constant = -55
    }
    func rotateForP2() {
        // Rotate player 2 counter
        playerTwoCounter.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        playerTwoStorageCounter.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        playerTwoWallet.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        
        // Rotate player 2 card views
        cardViewP2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War1.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        cardViewP2War3.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
    }
    
    
    //MARK: Tap Gestures Recognizers
    
    func setTapGest() {
        let tapP1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP1))
        let tapP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedP2))
        tapP1.numberOfTapsRequired = 1
        tapP2.numberOfTapsRequired = 1
        cardViewP1.addGestureRecognizer(tapP1)
        cardViewP2.addGestureRecognizer(tapP2)
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
        tapWarP1.numberOfTapsRequired = 1
        tapWarP2.numberOfTapsRequired = 1
        cardViewP1War2.addGestureRecognizer(tapWarP1)
        cardViewP2War2.addGestureRecognizer(tapWarP2)
    }
    func warTapGest3() {
        let tapWarP1 = UITapGestureRecognizer(target: self, action: #selector (ViewController.tappedWarP1))
        let tapWarP2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedWarP2))
        tapWarP1.numberOfTapsRequired = 1
        tapWarP2.numberOfTapsRequired = 1
        cardViewP1War3.addGestureRecognizer(tapWarP1)
        cardViewP2War3.addGestureRecognizer(tapWarP2)
    }
    
    
    // MARK: Buttons
    
    func setPlayRoundButton() {
        playRoundButtonWidth.constant = view.bounds.width/3
        playRoundButton.titleLabel?.minimumScaleFactor = 0.05
        playRoundButton.titleLabel?.numberOfLines = 1
        playRoundButton.titleLabel?.adjustsFontSizeToFitWidth = true
        playRoundButton.titleLabel?.textAlignment = NSTextAlignment.Center
        playRoundButton.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        playRoundButton.setTitle("DEAL", forState: UIControlState.Normal)
    }
    func setBetButton() {
        placeBetWidth.constant = view.bounds.width/5
        placeBet.titleLabel?.minimumScaleFactor = 0.05
        placeBet.titleLabel?.numberOfLines = 1
        placeBet.titleLabel?.adjustsFontSizeToFitWidth = true
        placeBet.titleLabel?.textAlignment = NSTextAlignment.Center
        placeBet.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
    }
    func showButton() {
        playRoundButton.hidden = false
        playRoundButton.userInteractionEnabled = true
    }
    func hideButton() {
        playRoundButton.hidden = true
        playRoundButton.userInteractionEnabled = false
    }
    
    
    // MARK: Counters
    
    func setCounters() {
        playerOneStorageY.constant = (view.bounds.height/4) + (cardViewP1.bounds.height/2) - 30
        playerTwoStorageY.constant = (view.bounds.height/4) + (cardViewP2.bounds.height/2) - 30
        playerOneStorageCounterWidth.constant = cardViewP1.bounds.width
        playerTwoStorageCounterWidth.constant = cardViewP2.frame.width
        
        playerOneCounterWidth.constant = cardViewP1.frame.width
        playerTwoCounterWidth.constant = cardViewP2.frame.width
        
        playerOneWalletWidth.constant = cardViewP1.frame.width
        playerTwoWalletWidth.constant = cardViewP2.frame.width
        
        playerOneHeight.constant = playerOneCounter.frame.height
        playerTwoHeight.constant = playerTwoCounter.frame.height
    }
    
    
    //      Deck Counters
    
    func hideCounter() {
        playerOneCounter.hidden = true
        playerTwoCounter.hidden = true
    }
    func showCounter() {
        playerOneCounter.hidden = false
        playerTwoCounter.hidden = false
    }
    func updateCounter() {
        war.totalCounter()
        playerOneCounter.text = String(war.playerOneCards.count)
        playerTwoCounter.text = String(war.playerTwoCards.count)
    }
    
    
    //      Wallet Counters
    
    func hideWallet() {
        playerOneWallet.hidden = true
        playerTwoWallet.hidden = true
    }
    func showWallet() {
        playerOneWallet.hidden = false
        playerTwoWallet.hidden = false
    }
    func updateWallet() {
        if isBettingPhase == true {
            playerOneWallet.text = "$" + String(playerOneMoney-totalBet)
            playerTwoWallet.text = "$" + String(playerTwoMoney-totalBet)
        } else {
            playerOneWallet.text = "$" + String(playerOneMoney)
            playerTwoWallet.text = "$" + String(playerTwoMoney)
        }
    }
    
    
    //      Storage Counters
    
    func hideStorageCounter() {
        playerOneStorageCounter.hidden = true
        playerTwoStorageCounter.hidden = true
    }
    
    func showStorageCounter() {
        playerOneStorageCounter.hidden = false
        playerTwoStorageCounter.hidden = false
    }
    
    func updateStorageCounter() {
        playerOneStorageCounter.text = String(war.playerOneStorage.count)
        playerTwoStorageCounter.text = String(war.playerTwoStorage.count)
    }
    
    
    // MARK: Overlay and Notifications
    
    func setOverlay() {
        overlay.backgroundColor = UIColor.blackColor()
        overlay.layer.zPosition = 998
        overlay.alpha = 0.0
        overlay.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        overlay.userInteractionEnabled = false
        
        view.addSubview(overlay)
    }
    func setNotifications() {
        notifyP1Width.constant = view.bounds.width
        notifyP2Width.constant = view.bounds.width
        notifyP1Height.constant = view.frame.height/6
        notifyP2Height.constant = view.frame.height/6
        notifyP1X.constant = -view.bounds.width
        notifyP2X.constant = -view.bounds.width
        notifyP1Y.constant = view.bounds.height/12
        notifyP2Y.constant = -view.bounds.height/12
        notifyP1.layer.zPosition = 999
        notifyP2.layer.zPosition = 999
        notifyP2.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
    }
    func showOverlay() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
            self.overlay.alpha = 0.5
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.swipeIn()
        })
    }
    func hideOverlay() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
            self.overlay.alpha = 0.0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                if (self.playerOneWin == true) {
                    self.normalWinP1Timer()
                } else if (self.playerOneWin == false) {
                    self.normalWinP2Timer()
                }
        })
    }
    func swipeIn() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(0.75, delay: 0, options: [.CurveEaseOut], animations: {
            self.notifyP1X.constant = 0
            self.notifyP2X.constant = 0
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.swipeOut()
        })
    }
    func swipeOut() {
        view.layoutIfNeeded()
        UIView.animateWithDuration(0.75, delay: 0, options: [.CurveEaseIn], animations: {
            self.notifyP1X.constant = self.view.bounds.width
            self.notifyP2X.constant = self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: {
                finished in
                self.hideOverlay()
                self.notifyP1X.constant = -self.view.bounds.width
                self.notifyP2X.constant = -self.view.bounds.width
        })
    }
    
    
    // MARK: Chips
    
    func setChips() {
        let tapGest = UITapGestureRecognizer(target: self, action: #selector (ViewController.updateChips))
        tapGest.cancelsTouchesInView = false
        
        chipsViewWidth.constant = view.bounds.width/1.1
        
        chipsView.addGestureRecognizer(tapGest)
    }
    func shiftChips() {
        if isEven == true {
            chipsViewY.constant = -view.bounds.height/6
            placeBetY.constant = -view.bounds.height/3.5
            chipsView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
            placeBet.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))
            totalBet = 0
            selectedChips = []
        } else {
            chipsViewY.constant = view.bounds.height/6
            placeBetY.constant = view.bounds.height/3.5
            chipsView.transform = CGAffineTransformMakeRotation(0)
            placeBet.transform = CGAffineTransformMakeRotation(0)
            totalBet = 0
            selectedChips = []
        }
    }
    func updateChips() {
        updateWallet()
        if selectedChips.isEmpty {
            placeBet.enabled = false
            placeBet.alpha = 0.5
            placeBet.setTitle("BET", forState: .Normal)
        } else {
            placeBet.enabled = true
            placeBet.alpha = 1.0
            placeBet.setTitle("BET " + String(totalBet), forState: .Normal)
        }
    }
    
    
    // MARK: Miscellaneous
    
    func resetGlobals() {
        playerOneMoney = startingWallet
        playerTwoMoney = startingWallet
        selectedChips = []
        totalBet = 0
        roundCount = 1
        
    }
}