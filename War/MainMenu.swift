//
//  MainMenu.swift
//  War
//
//  Created by Apple Dev on 2016-07-18.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    var image = UIImage()
    
    // Mark: Properties 
    @IBOutlet weak var icon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    //Changing icon view to the actual image
    
   var appIcon = UIImageView(frame: CGRectMake(0, 0, 300, 300))
        appIcon.image = UIImage(named: "icon")
        icon.addSubview(appIcon)
    
    }
    
  

}
