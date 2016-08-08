//
//  AboutViewController.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-08.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    

    
}
