
//
//  SlideMenu.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-19.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

var selectedGameMode = ""

class SlideMenu: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMenuTitle()
        timer()
        
        containerWidth.constant = view.bounds.width / 1.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark: Properties
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var menuTitle: UILabel!
    
    func updateMenuTitle() {
        menuTitle.text = selectedGameMode + "Menu"
    }
    
    func timer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateMenuTitle), userInfo: nil, repeats: true)
    }
}
