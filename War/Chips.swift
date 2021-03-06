//
//  Chips.swift
//  War
//
//  Created by Apple Dev on 2016-08-12.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class Chips: UIView {

    // MARK: Properties
    var selectedChip: Int? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    var chipButtons = [UIButton]()
    
    let spacing = 5
    let chipCount = 5
    
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
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for x in 0..<chipCount {
            let button = UIButton()

            var chipImages = [UIImage(named: "bet5"), UIImage(named: "bet10"), UIImage(named: "bet20"), UIImage(named: "bet50"), UIImage(named: "bet100")]
            
            chipImages[x]?.description
            
            button.setImage(chipImages[x], forState: .Normal)
            button.setImage(chipImages[x], forState: .Selected)
            button.setImage(chipImages[x], forState: .Disabled)
            button.setImage(chipImages[x], forState: [.Highlighted, .Selected])
            
            
            // button.backgroundColor = UIColor.cyanColor()
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
        // print("Button has been tapped!")
        selectedChip = chipButtons.indexOf(button)! + 1
    }
    func updateButtonSelectionStates() {
        for (index, button) in chipButtons.enumerate() {
            // If the index of a button is less than the rating, that buton should be selected.
            button.enabled = playerOneMoney > translate(index)
            button.selected = index == selectedChip
        }
        func chipButtonTapped(button: UIButton) {
            selectedChip = chipButtons.indexOf(button)! + 1
            
            updateButtonSelectionStates()
        }
    }
    
}
