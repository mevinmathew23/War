
//
//  SlideMenu.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-19.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class SlideMenu: UIViewController {
    
    var selectedGameMode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        updateMenuTitle(selectedGameMode)

       containerWidth.constant = view.bounds.width / 1.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark: Properties
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var menuTitle: UILabel!
    
    func updateMenuTitle(gameMode: String) {
        menuTitle.text = gameMode + "Menu"
    }
    
    

    }
