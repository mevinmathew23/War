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
import QuartzCore

class Settings: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var newImage:UIImage?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    // Mark: Properties
    @IBOutlet weak var volumeControl: UISlider!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    // Mark: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user cancelled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //The info directory contains multiple representations of the image and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //Set cardImage to display the selected image
        //mergeImage(selectedImage);
        
        let bottomImage = selectedImage //background image
        let topImage = UIImage(named: "cardOutline")
            
        let newSize = CGSize(width: 500, height: 726)
        UIGraphicsBeginImageContext(newSize)
        
        let bottomAreaSize = CGRect(x: 30, y: 27, width: 440, height: 672)
        bottomImage.drawInRect(bottomAreaSize)
        
        let topAreaSize = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        
        topImage!.drawInRect(topAreaSize, blendMode: CGBlendMode.Normal, alpha: 1)
        
        self.newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        cardImage.image = newImage

        
        //Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark: Actions
    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {

        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        imagePickerController.sourceType = .PhotoLibrary
        
        //Make sure Settings is notified when the user picks an image.
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
    
    
    
    @IBAction func doneButton(sender: UIBarButtonItem) {
        let card = Card()
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
    }
    
    
    
    

    
    
        
    }
    


