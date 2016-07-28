//
//  Settings.swift
//  War
//
//  Created by Apple Dev on 2016-07-26.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class Settings: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: UIPickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismisses picker if cancelled
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //Using the original image instead of a duplicate
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //Set photo as image view
        cardImage.image = selectedImage
        //Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    // Mark: Actions

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    // Mark: Properties
    @IBOutlet weak var volumeControl: UISlider!
    @IBOutlet weak var cardImage: UIImageView!
    
    // Selecting image from camera roll
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
   
    
   
    var audioPlayer = AVAudioPlayer()
    // Volume Adjusting function
    @IBAction func adjustingVolume(sender: AnyObject) {
        if audioPlayer != 1 {
            audioPlayer.volume = volumeControl.value
            
        }
        
    }
    
    let p1Blue = UIColor(red: 68/255, green: 194/255, blue: 239/255, alpha: 1.0)
    let p2Red = UIColor(red: 255/255, green: 23/255, blue: 0, alpha: 1.0)

}
