//
//  AboutViewController.swift
//  War
//
//  Created by Geoffrey Chen on 2016-08-08.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //aboutTextView.textColor = UIColor.whiteColor()
        
        
        
        aboutTextView.text = "     \"We believe good business software must be built on the business it serves.\"  \n\n The motto of PSI speaks for itself in demonstrating what PSI stands for and how each customer is treated with a personal connection  \n\n The PSI team is comprised of some of the ERP sector’s most experienced and knowledgeable people and they are devoted to each implementation. Perhaps that is why we sustain the highest standard of customer satisfaction. Based in Milton, Ontario since 1997, PSI fulfills our promises. We are committed to helping our clients gain control, reduce costs, and increase profit. Our software tools provide better visibility to an organization’s entire operation, no matter what industry or business sector."

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Properties
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var aboutTextView: UITextView!
    
    
    // Mark: Actions
    @IBAction func pressBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
