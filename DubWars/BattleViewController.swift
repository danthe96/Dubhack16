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
        leftPlayer = AVPlayer(URL: urls.0)
        rightPlayer = AVPlayer(URL: urls.1)
        
        rightPlayer!.muted = true
        
        let leftPlayerLayer = AVPlayerLayer(player: leftPlayer)
        let rightPlayerLayer = AVPlayerLayer(player: rightPlayer)
        leftPlayerLayer.frame = leftView.bounds
        rightPlayerLayer.frame = rightView.bounds
        leftView.layer.addSublayer(leftPlayerLayer)
        rightView.layer.addSublayer(rightPlayerLayer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        startPlayback()
    }
    
    func startPlayback() {
        leftPlayer!.play()
        rightPlayer!.play()
    }
    
    func showVotingOverlay() {
        let leftTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.didSelectLeft))
        leftOverlay.addGestureRecognizer(leftTapRecognizer)
        let rightTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BattleViewController.didSelectRight))
        leftOverlay.addGestureRecognizer(rightTapRecognizer)
        
        UIView.animateWithDuration(0.25) {
            self.leftOverlay.alpha = 1.0
            self.rightOverlay.alpha = 1.0
            self.tieButton.alpha = 1.0
        }
    }
    
    @IBOutlet var leftSelectionLabel: UILabel!
    @IBOutlet var rightSelectionLabel: UILabel!
    
    func didSelectLeft() {
        UIView.animateWithDuration(0.25) {
            self.leftSelectionLabel.alpha = 1.0
        }
        //TODO: save
    }
    func didSelectRight() {
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