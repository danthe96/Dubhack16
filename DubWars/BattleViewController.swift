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
import Firebase

class BattleViewController: UIViewController {
    
    var contest: Contest?
    
    //static let storage = FIRStorage.storage()
    static var videoQueue = [(String, String)]()

    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    
    @IBOutlet var leftOverlay: UIView!
    @IBOutlet var rightOverlay: UIView!
    
    @IBOutlet var tieButton: UIButton!
    
    var videos: [(Dub, Dub)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        // dirty hack
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        if let contest = contest {
            videos = contest.createBattle()
        } else {
            return
        }
        //LoadingOverlay.shared.showOverlay(self.view)
        initializePlayers()
        
        newRound()
        
    }
    
    let semaphore = dispatch_semaphore_create(0)
    
    func newRound() {
        if videos.count == 0 {
            self.navigationController!.popViewControllerAnimated(true)
            return
        }
        let (dub1, dub2) = videos.removeLast()
        
        // Create local filesystem URL
        NSURLSession.sharedSession().dataTaskWithURL(dub1.videoURL, completionHandler: { data1, response, error in
            if (error != nil) {
                // Handle any errors
                LoadingOverlay.shared.hideOverlayView()
            } else {
                NSURLSession.sharedSession().dataTaskWithURL(dub2.videoURL, completionHandler: { data2, response, error in
                    if (error != nil) {
                        // Handle any errors
                        LoadingOverlay.shared.hideOverlayView()
                    } else {
                        LoadingOverlay.shared.hideOverlayView()
                        do {
                            let url1 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("video1.mp4")
                        try data1!.writeToURL(url1, options: NSDataWritingOptions.AtomicWrite)
                            let url2 = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("video2.mp4")
                            try data2!.writeToURL(url2, options: NSDataWritingOptions.AtomicWrite)
                        self.loadVideos((url1, url2))
                        } catch let error as NSError {
                            print(error.localizedDescription)
                            return
                        }
                    }
                    dispatch_semaphore_signal(self.semaphore)
                }).resume()
            }
        }).resume()
        
        
        
//        let first = NSBundle.mainBundle().URLForResource("big_buck_bunny", withExtension: "mp4")
//        loadVideos((first!, first!))
    }
    
    var leftPlayer: AVPlayer!
    var rightPlayer: AVPlayer!
    
    func initializePlayers() {
        leftPlayer = AVPlayer()
        rightPlayer = AVPlayer()
        rightPlayer!.muted = true
        
        let leftPlayerLayer = AVPlayerLayer(player: leftPlayer)
        let rightPlayerLayer = AVPlayerLayer(player: rightPlayer)
        leftPlayerLayer.frame = leftView.bounds
        rightPlayerLayer.frame = rightView.bounds
        
        leftPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        rightPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        leftView.layer.insertSublayer(leftPlayerLayer, below: leftOverlay.layer)
        rightView.layer.insertSublayer(rightPlayerLayer, below: rightOverlay.layer)
        
    }
    
    func loadVideos(urls: (NSURL, NSURL)) {
        let test = AVAsset(URL: urls.0)
        let leftItem = AVPlayerItem(asset: test)
        let rightItem = AVPlayerItem(URL: NSBundle.mainBundle().URLForResource("big_buck_bunny", withExtension: "mp4")!)
        leftPlayer.replaceCurrentItemWithPlayerItem(leftItem)
        rightPlayer.replaceCurrentItemWithPlayerItem(rightItem)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BattleViewController.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: leftItem)
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            self.startPlayback()
        }
    }
    
    func startPlayback() {
        leftPlayer!.play()
        rightPlayer!.play()
    }
    
    func playerDidFinishPlaying() {
        showVotingOverlay()
    }
    
    func showVotingOverlay() {
        
        [leftOverlay, rightOverlay, tieButton].forEach {
            $0.alpha = 0.0
            $0.hidden = false
        }
        UIView.animateWithDuration(0.25) {
            self.leftOverlay.alpha = 1.0
            self.rightOverlay.alpha = 1.0
            self.tieButton.alpha = 1.0
        }
    }
    
    func hideVotingOverlay() {
        UIView.animateWithDuration(0.25) {
            self.leftOverlay.alpha = 0.0
            self.rightOverlay.alpha = 0.0
            self.tieButton.alpha = 0.0
        }
    }
    
    
    @IBOutlet var leftSelectionLabel: UILabel!
    @IBOutlet var rightSelectionLabel: UILabel!
    
    @IBAction func didSelectLeft(sender: AnyObject) {
        UIView.animateWithDuration(0.25) {
            self.leftSelectionLabel.alpha = 1.0
        }
        //TODO: save
    }
    
    @IBAction func didSelectRight(sender: AnyObject) {
        UIView.animateWithDuration(0.25) {
            self.rightSelectionLabel.alpha = 1.0
        }
    }
    
}