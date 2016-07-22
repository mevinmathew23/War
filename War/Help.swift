//
//  Help.swift
//  War
//
//  Created by Apple Dev on 2016-07-22.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class Help: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //Back Button
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}