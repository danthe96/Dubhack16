//
//  MainViewController.swift
//  DubWars
//


import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON

class MainViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var battleButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    private let database = FIRDatabase.database().reference()
    
    private var contestsHandle:FIRDatabaseHandle? = nil
    
     private var selectedContest:Contest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        battleButton.layer.cornerRadius = battleButton.frame.width/2
        battleButton.clipsToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 150, 0)
        
        contestsHandle = database.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let contestsJSON = JSON(snapshot.value as! [String : AnyObject]!)["dubwars"]["contests"]
            Globals.contests = contestsJSON.dictionaryValue.flatMap {Contest(json: $0.1)}
            
            print(snapshot.value)
            
            self.tableView.reloadData()
            
        })
    }
    
    private var contests = [Contest]()
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.contests = Globals.contests
        return contests.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("contestCell"),
            contest = contests[safe: indexPath.row]{
            
            let thumbnail = cell.viewWithTag(101) as! UIImageView
            if let firstDub = contest.dubs.first {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if let data = NSData(contentsOfURL: firstDub.thumbnailURL){
                        dispatch_async(dispatch_get_main_queue(), {
                            thumbnail.image = UIImage(data: data)
                            thumbnail.layer.cornerRadius = 10
                            thumbnail.clipsToBounds = true
                            
                            thumbnail.setNeedsLayout()
                            thumbnail.layoutIfNeeded()
                        })
                    }
                })
            }
            
            //TODO
            
            let contestTitle = cell.viewWithTag(102) as! UILabel
            contestTitle.text = contest.name
            
            let snipID = contest.id
            let soundName = cell.viewWithTag(103) as! UILabel
            let playButton = cell.viewWithTag(104) as! UIButton
            playButton.addTarget(self, action: #selector(MainViewController.playButtonClicked(_:)), forControlEvents: .TouchUpInside)
            if let snip = Globals.snips[snipID]{
                soundName.text = snip["name"].string ?? "Sound name"
            } else{
                DubsmashClient.instance.loadSnip(snipID, callback: {snip in
                    soundName.text = snip["name"].string ?? "Sound name"
                })
            }
            
            let submitButton = cell.viewWithTag(105) as! UIButton
            //TODO
            
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
    
    func playButtonClicked(sender: UIButton){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "battle" {
            if let destination = segue.destinationViewController as? UIViewController {
                // TODO nichts übergeben bzw contest = all oder sowas
            }
        } else if segue.identifier == "showScoreboardSegue" {
            if let destination = segue.destinationViewController as? ScoreboardViewController {
                destination.contest = selectedContest
            }
        }
    }
}