//
//  ViewController.swift
//  War
//
//  Created by Apple Dev on 2016-06-21.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var firstCardConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondCardConstraint: NSLayoutConstraint!
    
    var deckOfCards: [String] = ["spades2","spades3","spades4","spades5","spades6","spades7","spades8","spades9","spades10","spades11","spades12","spades13","spades14","hearts2","hearts3","hearts4","hearts5","hearts6","hearts7","hearts8","hearts9","hearts10","hearts11","hearts12","hearts13","hearts14","clubs2","clubs3","clubs4","clubs5","clubs6","clubs7","clubs8","clubs9","clubs10","clubs11","clubs12","clubs13","clubs14","diamonds2","diamonds3","diamonds4","diamonds5","diamonds6","diamonds7","diamonds8","diamonds9","diamonds10","diamonds11","diamonds12","diamonds13","diamonds14"]
    
    var playerOneCards: [String] = []
    var playerTwoCards: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set initial cards outside of view
        self.firstCardConstraint.constant = 900
        self.secondCardConstraint.constant = -500
        self.view.layoutIfNeeded()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

   self.playRoundButton.setTitle("Play", forState: UIControlState.Normal)
    }

    @IBAction func playRoundTapped(sender: UIButton) {
        
        self.firstCardImageView.image = UIImage(named: "spades2")
        self.secondCardImageView.image = UIImage(named: "spades14")
        
        playRoundButton.removeFromSuperview()
        
        // Animate cards dealt
        UIView.animateWithDuration(0.8, animations: {
            self.firstCardConstraint.constant = 50
        }, completion: nil)
        UIView.animateWithDuration(0.8, delay: 0.3, options: [], animations: {
            self.secondCardConstraint.constant = 50
            }, completion: nil)
    }

}

