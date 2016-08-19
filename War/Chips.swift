//
//  Chips.swift
//  War
//
//  Created by Apple Dev on 2016-08-12.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

let viewController = ViewController()
var selectedChips = [Int]()
var touchedChip: Int? = nil
var totalBet: Int = 0
var isSolo: Bool! = false
var isEven: Bool! = false
var isBettingPhase: Bool! = true
var roundCount = 1

func translate(index: Int) -> Int {
    switch index {
    case 0:
        return 5
    case 1:
        return 10
    case 2:
        return 20
    case 3:
        return 50
    case 4:
        return 100
    default:
        return 0
    }
}

func betSum() {
    totalBet = 0
    for chips in selectedChips {
        totalBet += chips
    }
}

class Chips: UIView {
    
    // MARK: Properties
    
    var chipButtons = [UIButton]()
    
    let spacing = 0
    let chipCount = 5
    var isHighlighted: Bool = false

    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for x in 0..<chipCount {
            let button = UIButton()
            
            var chipImages = [UIImage(named: "bet5"), UIImage(named: "bet10"), UIImage(named: "bet20"), UIImage(named: "bet50"), UIImage(named: "bet100")]
            
            chipImages[x]?.description
            
            button.setImage(chipImages[x], forState: .Normal)

            
            button.adjustsImageWhenHighlighted = true
            button.adjustsImageWhenDisabled = true
            button.showsTouchWhenHighlighted = true
            
            button.addTarget(self, action: #selector(Chips.chipButtonTapped(_:)), forControlEvents: .TouchDown)
            chipButtons += [button]
            addSubview(button)
        }
    }
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize * chipCount) + (spacing * (chipCount - 1))
        
        return CGSize(width: width, height: buttonSize)
    }
    override func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0,y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in chipButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    
    // MARK: Button Action
    func chipButtonTapped(button: UIButton) {
        
        touchedChip = chipButtons.indexOf(button)!
        selectedChips.append(translate(chipButtons.indexOf(button)!))
        
        print("Button has been tapped!")
        for chips in selectedChips {
            print(String(chips))
        }
        
        updateButtonSelectionStates()
    }
    func updateButtonSelectionStates() {
        betSum()
        for (index, button) in chipButtons.enumerate() {
            
            if isSolo == false {
                button.enabled = whoBets(roundCount) >= translate(index) && totalBet <= whoBets(roundCount) - translate(index)
            } else {
                button.enabled = playerOneMoney > translate(index)
            }
            
            button.selected = index == touchedChip
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.setNeedsLayout()
        });
        
        func chipButtonTapped(button: UIButton) {
            touchedChip = chipButtons.indexOf(button)!
            selectedChips.append(translate(chipButtons.indexOf(button)!))
            
            updateButtonSelectionStates()
        }
    }
    
    func whoBets(round: Int) -> Int {
        if round % 2 == 0 {
            //print("Round is even, player 2 bets")
            isEven = true
            return playerTwoMoney
        } else {
            //print("Round is odd, player 1 bets")
            isEven = false
            return playerOneMoney
        }
    }
}
