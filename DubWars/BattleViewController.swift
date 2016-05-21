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

class BattleViewController: ViewController {
    
    //static let storage = FIRStorage.storage()
    static var videoQueue = [(String, String)]()

    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    
    @IBOutlet var leftOverlay: UIView!
    @IBOutlet var rightOverlay: UIView!
    
    @IBOutlet var tieButton: UIButton!
    
    var videos: [(String, String)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        // dirty hack
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        //LoadingOverlay.shared.showOverlay(self.view)
        downloadAndPlayVideos()
    }
    
    let semaphore = dispatch_semaphore_create(2)
    
    func downloadAndPlayVideos() {
        /*
        // Create a reference to the file you want to download
        let currentVideos = BattleViewController.videoQueue.removeFirst()
        let video1Ref = storage.child("images/island.jpg")
        let video2Ref = storage.child("")
        
        let firstURL, secondUrl: NSURL?
        // Create local filesystem URL
        video1Ref.downloadURLWithCompletion { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
            } else {
                firstURL = URL
            }
            dispatch_semaphore_signal(semaphore)
        }
        video2Ref.downloadURLWithCompletion { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
            } else {
                secondUrl = URL
            }
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        LoadingOverlay.shared.hideOverlayView()
        if let firstURL = firstURL, secondUrl = secondUrl {
            loadPlayersWithURLs(firstURL, secondUrl)
        }
 */
        let first = NSBundle.mainBundle().URLForResource("big_buck_bunny", withExtension: "mp4")
        loadPlayersWithURLs((first!, first!))
    }
    
    var leftPlayer: AVPlayer?
    var rightPlayer: AVPlayer?
    func loadPlayersWithURLs(urls: (NSURL, NSURL)) {
        let leftItem = AVPlayerItem(URL: urls.0)
        leftPlayer = AVPlayer(playerItem: leftItem)
        rightPlayer = AVPlayer(URL: urls.1)
        
        rightPlayer!.muted = true
        
        let leftPlayerLayer = AVPlayerLayer(player: leftPlayer)
        let rightPlayerLayer = AVPlayerLayer(player: rightPlayer)
        leftPlayerLayer.frame = leftView.bounds
        rightPlayerLayer.frame = rightView.bounds
        
        leftPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        leftView.layer.insertSublayer(leftPlayerLayer, below: leftOverlay.layer)
        rightView.layer.insertSublayer(rightPlayerLayer, below: rightOverlay.layer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BattleViewController.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: leftItem)
    }
    
    override func viewDidAppear(animated: Bool) {
        startPlayback()
    }
    
    func startPlayback() {
        leftPlayer!.play()
        rightPlayer!.play()
    }
    
    func playerDidFinishPlaying() {
        showVotingOverlay()
    }
    
    func showVotingOverlay() {
        
        let leftOverlay = UIView(frame: leftView.bounds)
        leftOverlay.alpha = 0.0
        self.leftView.addSubview(leftOverlay)
        let items = [leftOverlay, self.rightOverlay, self.tieButton]
        items.forEach {
            $0.alpha = 0.0
            $0.hidden = false
        }
        UIView.animateWithDuration(0.25) {
            self.leftOverlay.alpha = 1.0
            self.rightOverlay.alpha = 1.0
            self.tieButton.alpha = 1.0
        }
    }
    
    @IBOutlet var leftSelectionLabel: UILabel!
    @IBOutlet var rightSelectionLabel: UILabel!
    
    @IBAction func didSelectLeft() {
        UIView.animateWithDuration(0.25) {
            self.leftSelectionLabel.alpha = 1.0
        }
        //TODO: save
    }
    @IBAction func didSelectRight() {
        UIView.animateWithDuration(0.25) {
            self.rightSelectionLabel.alpha = 1.0
        }
    }
    
    func showNextViewController() {
        performSegueWithIdentifier("replace", sender: self)
    }
    
}



class ReplaceSegue: UIStoryboardSegue {
    
    override func perform() {
        let navigationController: UINavigationController = sourceViewController.navigationController!
        
        var controllerStack = navigationController.viewControllers
        let index = controllerStack.indexOf(sourceViewController)!
        controllerStack[index] = destinationViewController
        
        navigationController.setViewControllers(controllerStack, animated: true)
    }
}