//
//  MainMenu.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-09.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    let audio = Audio()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audio.readFileIntoAVPlayer("bgm", volume: 0.125)
        audio.toggleAVPlayer()
        audio.loopAVPlayer()
        
        let mute = Settings().defaults.boolForKey("Mute")
        
        if mute == true {
            audio.avPlayer.volume = 0
        } else {
            audio.avPlayer.volume = Settings().defaults.floatForKey("Volume")
        }
        
        

            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segSettings" {
            if let vc = segue.destinationViewController as? Settings {
                vc.audio = self.audio;
            }
        }
    }

    // Mark: Properties
    @IBOutlet weak var onePlayer: UIButton!
    @IBOutlet weak var twoPlayer: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var about: UIButton!
    
}
