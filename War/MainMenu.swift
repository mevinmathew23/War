//
//  MainMenu.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-09.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    let audio = Audio()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audio.readFileIntoAVPlayer("bgm", volume: 1.0)
        audio.setSessionPlayback()
        audio.toggleAVPlayer()

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Mark: Properties
    @IBOutlet weak var onePlayer: UIButton!
    @IBOutlet weak var twoPlayer: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var about: UIButton!
    
}
