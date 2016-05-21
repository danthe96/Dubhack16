//
//  BattleViewController.swift
//  DubWars
//
//  Created by Carl Julius Gödecken on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class BattleViewController: ViewController {

    @IBOutlet var leftView: AVPlayerViewController!
    @IBOutlet var rightView: AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        leftView.showsPlaybackControls = false
        rightView.showsPlaybackControls = false
    }
    
    func loadVideosWithURLs(first: NSURL, second: NSURL) {
        let leftPlayer = AVPlayer(URL: NSURL(fileURLWithPath: ""))
        let rightPlayer = AVPlayer(URL: NSURL(fileURLWithPath: ""))
        
        rightPlayer.muted = true
        
        leftView.player = leftPlayer
        rightView.player = rightPlayer
    }
    
    func startPlayback() {
        leftView.player!.play()
        rightView.player!.play()
    }
}
