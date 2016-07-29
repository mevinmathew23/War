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
    
    var Back: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    var Front: UIImageView! = UIImageView(frame: CGRectMake(0, 0, 120, 170))
    var backImage = UIImage(named: "cardBackPSI")
    
    let settings = Settings()
    func updateCardBack() {
        backImage = settings.cardImage.image
    }
}



