//
//  AboutViewController.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-08.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let overlay: UIView = UIView()
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setOverlay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Properties
    @IBOutlet weak var backButton: UIButton!
    
    
    // Mark: Actions
    @IBAction func pressBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setOverlay() {
        overlay.backgroundColor = UIColor.whiteColor()
        overlay.layer.zPosition = 998
        overlay.alpha = 0.5
        overlay.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        overlay.userInteractionEnabled = false
        
        view.addSubview(overlay)
    }
    
}
