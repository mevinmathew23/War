//
//  Card.swift
//  War
//
//  Created by Apple Dev on 2016-07-05.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class Card {
    
    
    
    var Value : Int?;
    var Name : String?
    var ShowingFront: Bool = false
    
    var Back: UIImageView = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    var Front: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    var backImage: UIImage!
    
    
    func setSize(a: UIView) {
        Back = UIImageView(frame: CGRectMake(0,0, a.frame.width, a.frame.height))
        Front = UIImageView(frame: CGRectMake(0,0, a.frame.width, a.frame.height))
    }
    
    let settings = Settings()
    func updateCardBack() {
        let newImage = settings.loadImageFromPath(settings.cardPath)
        if newImage == nil {
            let x = UIImage(named: "cardBackPSI")!
            backImage = x.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .Stretch)
        } else {
            let x = newImage!
            backImage = x.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .Stretch)
        }
    }
    
    init () {
        Back.contentMode = UIViewContentMode.ScaleAspectFill
        Front.contentMode = UIViewContentMode.ScaleAspectFill
        
        updateCardBack()
    }
}



