//
//  Animations.swift
//  War
//
//  Created by Apple Dev on 2016-08-09.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class Animations: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func startAnimation(ConstraintP1: NSLayoutConstraint, ConstraintP2: NSLayoutConstraint) {
        UIView.animateWithDuration(0.8, delay: 0, options: [.CurveEaseOut],animations: {
            ConstraintP1.constant = 50
            ViewController().view.layoutIfNeeded()
            }, completion: nil)
        UIView.animateWithDuration(0.8, delay: 0.3, options: [.CurveEaseOut], animations: {
            ConstraintP2.constant = 50
            ViewController().view.layoutIfNeeded()
            }, completion: nil)
    }
}
