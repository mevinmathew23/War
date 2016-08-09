//
//  Audio.swift
//  War
//
//  Created by Apple Dev on 2016-08-08.
//  Copyright © 2016 Apple Dev. All rights reserved.
//

import AVFoundation
import UIKit

class Audio : NSObject {
    
    var avPlayer:AVAudioPlayer!
    
    func readFileIntoAVPlayer(fileName: String, volume: Float) {
        if let sound = NSDataAsset(name: fileName) {
            do {
                setSessionPlayback()
                try avPlayer = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            } catch {
                print("error initializing AVAudioPlayer")
            }
        }
        
        avPlayer.delegate = self
        avPlayer.prepareToPlay()
        avPlayer.volume = volume
        
    }
    
    func setSessionPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.MixWithOthers)
            try audioSession.setActive(true)
        } catch {
            print("couldn't set category \(error)")
        }
    }
    
    func stopAVPlayer() {
        if avPlayer.playing {
            avPlayer.stop()
        }
    }
    
    func toggleAVPlayer() {
        if avPlayer.playing {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    func loopAVPlayer() {
            avPlayer.numberOfLoops = -1
    }
}

extension Audio : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
}