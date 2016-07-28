//
//  Animations.swift
//  War
//
//  Created by Apple Dev on 2016-07-27.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

extension UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    func fadeIn(duration duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0) {
        UIView.animateWithDuration(duration, delay: delay, options: [], animations: {
            
            }, completion: nil)
    }
}
