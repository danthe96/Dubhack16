//
//  MainViewController.swift
//  DubWars
//


import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON
import AVKit
import AVFoundation

class MainViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var battleButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    private let database = FIRDatabase.database().reference()
    
    private var contestsHandle:FIRDatabaseHandle? = nil
    
    private var selectedContest:Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 150, 0)
        
        contestsHandle = database.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let contestsJSON = JSON(snapshot.value as! [String : AnyObject]!)["dubwars"]["contests"]
            Globals.contests = contestsJSON.dictionaryValue.flatMap {Contest(json: $0.1)}
            
            print(snapshot.value)
            
            self.tableView.reloadData()
            
        })
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "logo.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(16, 24, 0, 24), resizingMode: UIImageResizingMode.Stretch), forBarPosition: .Any, barMetrics: .Default)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private var contests = [Contest]() {
        didSet {
            updateBattleVisibility()
        }
    }
    
    func updateBattleVisibility() {
        for contest in contests {
            if contest.dubs.count > 1   {
                battleButton.hidden = false
                return
            }
            battleButton.hidden = true
        }
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.contests = Globals.contests
        return contests.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("contestCell"),
            contest = contests[safe: indexPath.row]{
            
            let thumbnail = cell.viewWithTag(101) as! UIImageView
            let playButton = cell.viewWithTag(104) as! UIButton
            if let firstDub = contest.dubs.first {
                playButton.addTarget(self, action: #selector(MainViewController.playButtonClicked(_:)), forControlEvents: .TouchUpInside)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if let data = NSData(contentsOfURL: firstDub.thumbnailURL){
                        dispatch_async(dispatch_get_main_queue(), {
                            thumbnail.image = UIImage(data: data)
                            thumbnail.layer.cornerRadius = thumbnail.frame.width/2
                            thumbnail.clipsToBounds = true
                            
                            thumbnail.setNeedsLayout()
                            thumbnail.layoutIfNeeded()
                        })
                    }
                })
            }
            
            let snipID = contest.id
            let soundName = cell.viewWithTag(103) as! UILabel
            if let snip = Globals.snips[snipID]{
                soundName.text = snip["name"].string ?? "Sound name"
            } else{
                DubsmashClient.instance.loadSnip(snipID, callback: {snip in
                    soundName.text = snip["name"].string ?? "Sound name"
                })
            }
            let secondaryLabel = cell.viewWithTag(105) as! UILabel
            secondaryLabel.text = "\(contest.dubs.count) dub\(contest.dubs.count != 1 ? "s" : "")"
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "contestCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let contest = contests[safe: indexPath.row] {
            self.selectedContest = contest
        }
        self.performSegueWithIdentifier("showScoreboardSegue", sender: self)
    }
    
    var runningPlayers = [String: AVPlayerLayer]()
    func playButtonClicked(sender: UIButton){
        if let clickedCell = sender.superview!.superview as? UITableViewCell,
            let indexPath = tableView.indexPathForCell(clickedCell),
            let contest = contests[safe: indexPath.row] where contest.dubs.count > 0{
            
            let videoView = clickedCell.viewWithTag(107)!
            let playButton = clickedCell.viewWithTag(104) as! UIButton
            if let videoPlayer = runningPlayers[contest.id]{
                if(videoPlayer.player?.rate == 0){
                    playButton.setImage(UIImage(named: "ic_pause"), forState: .Normal)
                    videoPlayer.player?.play()
                } else{
                    playButton.setImage(UIImage(named: "ic_play"), forState: .Normal)
                    videoPlayer.player?.pause()
                }
                
            } else{
                playButton.setImage(UIImage(named: "ic_pause"), forState: .Normal)
                
                let player = AVPlayer(URL: contest.dubs.first!.videoURL)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(itemDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
                
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = videoView.bounds
                
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
                videoView.layer.insertSublayer(playerLayer, above: videoView.layer)
                videoView.layer.cornerRadius = videoView.frame.width/2
                videoView.clipsToBounds = true
                player.play()
                
                if(runningPlayers.count > 12){
                    
                }
                
                runningPlayers.updateValue(playerLayer, forKey: contest.id)
            }
        }
    }
    
    func itemDidFinishPlaying(notification: NSNotification){
//        notification.userInfo
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBattleSegue" {
            if let destination = segue.destinationViewController as? BattleViewController {
                let eligibleContests = contests.filter {$0.dubs.count > 1}
                let randomContest = eligibleContests[safe: Int(arc4random_uniform(UInt32(contests.count)))]
                destination.contest = randomContest
            }
        } else if segue.identifier == "showScoreboardSegue" {
            if let destination = segue.destinationViewController as? ScoreboardViewController {
                destination.contest = selectedContest
            }
        }
    }
}