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


func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}
func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
}

class Settings: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var audio: Audio?;
    var sounds: Sounds?;
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var newImage:UIImage?
    var newVolume:Float!
    var newBrightness:Float!
    var newMute:Bool!
    var newMuteSounds: Bool!
    let cardPath = fileInDocumentsDirectory("customCard")
    let backgroundPath = fileInDocumentsDirectory("customBackground")
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let volume = defaults.floatForKey("Volume")
        let brightness = defaults.floatForKey("Brightness")
        let mute = defaults.boolForKey("Mute")
        let sFX = defaults.boolForKey("soundFX")
        volumeControl.setValue(volume, animated: false)
        brightnessControl.setValue(brightness, animated: false)
        muteControl.setOn(mute, animated: false)
        soundFX.setOn(sFX, animated: false)
        
        if loadImageFromPath(cardPath) == nil {
            print("No new image selected.")
            cardImage.image = UIImage(named: "cardBackPSI")
        } else {
            cardImage.image = loadImageFromPath(cardPath)
        }
        if loadImageFromPath(backgroundPath) == nil {
            backgroundImage.image = UIImage(named: "backgroundPSI")
            print("No new background selected")
        } else {
            backgroundImage.image = loadImageFromPath(backgroundPath)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    // Mark: Properties
    
    @IBOutlet weak var volumeControl: UISlider!
    @IBOutlet weak var brightnessControl: UISlider!
    @IBOutlet weak var muteControl: UISwitch!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var soundFX: UISwitch!
    
    
    var changeCard: Bool? = nil
    var background: UIImage! = UIImage(named: "backgroundPSI")
    
    let p1Blue = UIColor(red: 68/255, green: 194/255, blue: 239/255, alpha: 1.0)
    let p2Red = UIColor(red: 1, green: 21/255, blue: 0, alpha: 1.0)
    
    
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
            saveImage(newImage!, path: cardPath)
            
        } else {
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            backgroundImage.image = selectedImage
            saveImage(selectedImage, path: backgroundPath)
            
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
        setDefaults()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    func saveImage(image: UIImage, path: String) -> Bool {
        let pngImageData = UIImagePNGRepresentation(image)
        // let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        if image == nil {
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)")
        return image
    }
    
    func removeImage(itemName:String, fileExtension: String) {
        let fileManager = NSFileManager.defaultManager()
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    let mainMenu = MainMenu()
    
    @IBAction func volumeChange(sender: UISlider) {
        newVolume = volumeControl.value
        if audio!.avPlayer.volume != 0 {
            audio!.avPlayer.volume = volumeControl.value
        }
    }
    @IBAction func brightnessChange(sender: UISlider) {
        newBrightness = brightnessControl.value
        UIScreen.mainScreen().brightness = CGFloat(newBrightness)
    }
    @IBAction func muteChange(sender: UISwitch) {
        newMute = muteControl.on
        if audio!.avPlayer != nil {
            if muteControl.on == true {
                audio!.avPlayer.volume = 0
            } else {
                audio!.avPlayer.volume = volumeControl.value
            }
        }
    }
    
    
    @IBAction func muteSoundFX(sender: UISwitch) {
        newMuteSounds = soundFX.on
    }
    
    @IBAction func resetCardBack(sender: UITapGestureRecognizer) {
        removeImage("customCard", fileExtension: "")
        cardImage.image = UIImage(named: "cardBackPSI")
        
    }
    
    @IBAction func resetBackground(sender: UITapGestureRecognizer) {
        removeImage("customBackground", fileExtension: "")
        backgroundImage.image = UIImage(named: "backgroundPSI")
        
    }
    @IBAction func resetAllData(sender: UITapGestureRecognizer) {
        
        removeImage("customCard", fileExtension: "")
        cardImage.image = UIImage(named: "cardBackPSI")
        removeImage("customBackground", fileExtension: "")
        backgroundImage.image = UIImage(named: "backgroundPSI")
    }
    
    
    
    func setDefaults() {
        if newVolume == nil {
            print("No new volume set")
        } else {
            defaults.setFloat(newVolume, forKey: "Volume")}
        if newBrightness == nil {
            print("No new brightness set")
        } else {
            defaults.setFloat(newBrightness, forKey: "Brightness")}
        if newMute == nil {
            print("No new mute option set")
        } else {
            defaults.setBool(newMute, forKey: "Mute")}
        if newMuteSounds == nil {
            print("No new mute sound FX option set")
        } else {
            defaults.setBool(newMuteSounds, forKey: "soundFX")
        }
    }
}
