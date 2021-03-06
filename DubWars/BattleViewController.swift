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
import FirebaseDatabase
import Spring

class BattleViewController: UIViewController {
    
    var contest: Contest?
    var videos: [(Dub, Dub)]?
    
    static let colorRight = UIColor(red: 0xBB, green: 0x3F, blue: 0x61)
    static let colorLeft = UIColor(red: 0xE8, green: 0xA1, blue: 0x3F)
    
    //static let storage = FIRStorage.storage()
    static var videoQueue = [(String, String)]()
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    
    @IBOutlet var leftOverlay: UIView!
    @IBOutlet var rightOverlay: UIView!
    
    @IBOutlet var dubsmashLightsaber: UIImageView!
    @IBOutlet var greenLightsaber: UIImageView!
    
    var myParentVC: UIViewController!
    
    
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true
        
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 12
        
        if let contest = contest {
            videos = contest.createBattle()
        } else if videos == nil {
            delay(0.25) { self.navigationController!.popToViewController(self.myParentVC, animated: true) }
            return
        }
        //LoadingOverlay.shared.showOverlay(self.view)
        
        dubsmashLightsaber.transform = CGAffineTransformMakeRotation((15 * CGFloat(M_PI)) / 180.0)
        greenLightsaber.transform = CGAffineTransformMakeRotation((345 * CGFloat(M_PI)) / 180.0)
        initializePlayers()
        
        
        newRound()
        
    }
    
    var semaphore: dispatch_semaphore_t! = dispatch_semaphore_create(0)
    
    var dub1, dub2: Dub?
    func newRound() {
        semaphore = dispatch_semaphore_create(0)
        let (dub1, dub2) = videos!.removeLast()
        self.dub1 = dub1
        self.dub2 = dub2
        
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
        leftPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.height/2, height: self.view.frame.size.width)
        rightPlayerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.height/2, height: self.view.frame.size.width)
        
        leftPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        rightPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        leftView.layer.insertSublayer(leftPlayerLayer, below: leftOverlay.layer)
        rightView.layer.insertSublayer(rightPlayerLayer, below: rightOverlay.layer)
        
        let leftTapGesture = UITapGestureRecognizer(target: self, action: Selector("handleLeftTap:"))
        leftView.addGestureRecognizer(leftTapGesture)
        let rightTapGesture = UITapGestureRecognizer(target: self, action: Selector("handleRightTap:"))
        rightView.addGestureRecognizer(rightTapGesture)
        
    }
    
    func checkVideosLeft () {
        if videos?.count <= 1 {
            performSegueWithIdentifier("unwindToMenu", sender: nil)
        }
        else {
            newRound()
            startPlaybackWhenReady()
        }
    }
    
    func loadVideos(urls: (NSURL, NSURL)) {
        let leftItem = AVPlayerItem(URL: urls.0)
        let rightItem = AVPlayerItem(URL: urls.1)
        leftPlayer.replaceCurrentItemWithPlayerItem(leftItem)
        rightPlayer.replaceCurrentItemWithPlayerItem(rightItem)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BattleViewController.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: leftItem)
    }
    
    override func viewDidAppear(animated: Bool) {
        startPlaybackWhenReady()
    }
    
    func startPlaybackWhenReady() {
        dispatch_async(dispatch_get_main_queue()) {
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
            self.leftPlayer!.play()
            self.rightPlayer!.play()
        }
        
    }
    
    func playerDidFinishPlaying() {
        let t1 = CMTimeMake(5, 100);
        self.leftPlayer.seekToTime(t1)
        self.rightPlayer.seekToTime(t1)
        self.rightPlayer.play()
        self.leftPlayer.play()
    }
    
//    func showVotingOverlay() {
//        
//        [leftOverlay, rightOverlay].forEach {
//            $0.alpha = 0.0
//            $0.hidden = false
//        }
//        UIView.animateWithDuration(0.25) {
//            self.leftOverlay.alpha = 1.0
//            self.rightOverlay.alpha = 1.0
//        }
//    }
//    
//    func hideVotingOverlay() {
//        UIView.animateWithDuration(0.25) {
//            self.leftOverlay.alpha = 0.0
//            self.rightOverlay.alpha = 0.0
//        }
//    }

    
    @IBOutlet var leftSelectionLabel: UILabel!
    @IBOutlet var rightSelectionLabel: UILabel!
    

     func handleLeftTap(sender: UITapGestureRecognizer) {
        (greenLightsaber as? SpringImageView)?.animate()
        UIView.animateWithDuration(0.25, animations: {
            self.leftOverlay.backgroundColor = UIColor(redInt: 0x45, greenInt: 0x8B, blueInt: 0x00, alphaInt: 0x80)
            self.leftOverlay.hidden = false
            }, completion: { _ in
                delay(0.25) {
                    UIView.animateWithDuration(0.25, animations: {
                        self.leftOverlay.hidden = true
                        }, completion: {_ in
                            self.checkVideosLeft()
                    })
                }
        })
        submitVoting(forId: dub1!.snipID, winningUser: dub1!.user, losingUser: dub2!.user)
    }
    
     func handleRightTap(sender: UITapGestureRecognizer) {
        (dubsmashLightsaber as? SpringImageView)?.animate()
        (dubsmashLightsaber as? SpringImageView)?.animateNext {
            (self.dubsmashLightsaber as? SpringImageView)!.rotate = 15
        }
        UIView.animateWithDuration(0.25, animations: {
            self.rightOverlay.backgroundColor = UIColor(redInt: 0x45, greenInt: 0x8B, blueInt: 0x00, alphaInt: 0x80)
            self.rightOverlay.hidden = false
            }, completion: { _ in
                self.checkVideosLeft()
                UIView.animateWithDuration(0.25, animations: {
                    self.rightOverlay.hidden = true
                    }, completion: {_ in
                        self.checkVideosLeft()
                })
        })
        submitVoting(forId: dub1!.snipID, winningUser: dub2!.user, losingUser: dub1!.user)
    }
    
    private let database = FIRDatabase.database().reference()
    
    
    func submitVoting(forId id: String, winningUser: String, losingUser: String)    {
        let votes = database.child("dubwars").child("votes")
        let key = votes.childByAutoId().key
        let entry = ["snipID": id,
                     "winner": winningUser,
                     "loser": losingUser]
        let updates = ["/\(key)": entry]
        votes.updateChildValues(updates)
    }

     override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
  }
    override func shouldAutorotate() -> Bool {
        return false
    }
}