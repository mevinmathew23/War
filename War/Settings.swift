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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var changeCard: Bool? = nil
    var background: UIImage! = UIImage(named: "backgroundPSI")
    

    
    // Mark: UIBackgroundPickerControllerDelegate
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String :AnyObject]) {
//        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        
//        backgroundImage.image = selectedImage
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    
    
    // Mark: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user cancelled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if changeCard == true {
        
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
            
        } else {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage

            backgroundImage.image = selectedImage
            
        }

        
        //Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Mark: Actions
    @IBAction func selectBackgroundFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // UI Image picker controller is a view controller thay lets a user pick media fromt heir photo library
        let backgroundPickerController = UIImagePickerController()
        
        //Only allow photos to be picked not taken
        backgroundPickerController.sourceType = .PhotoLibrary
        
        // Make sure the VC is notified when the user picks an image
        backgroundPickerController.delegate = self
        
        presentViewController(backgroundPickerController, animated: true, completion: nil)
        
        changeCard = false
        
    }
    
    
    
    @IBAction func selectImageFromLibrary(sender: UITapGestureRecognizer) {

        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let picker = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        picker.sourceType = .PhotoLibrary
        
        //Make sure Settings is notified when the user picks an image.
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
        
        changeCard = true
    }
    
//    var audioPlayer = AVAudioPlayer()
//    @IBAction func volumeAdjust(sender: AnyObject) {
//        if audioPlayer != 0 {
//            audioPlayer.volume = volumeControl.value
//    }
//    
    
    
        
    
    
    @IBAction func pressDone(sender: UIBarButtonItem) {
        var config = Config()
        config.background = backgroundImage.image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    

    
    
        
    }
    


