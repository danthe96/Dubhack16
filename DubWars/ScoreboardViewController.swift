//
//  ScoreBoardViewController.swift
//  DubWars
//
//  Created by Alec Schneider on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON

class ScoreboardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contest: Contest!
    
    @IBOutlet var battleButton: UIButton!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battleButton.layer.cornerRadius = battleButton.frame.width/2
        battleButton.clipsToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 150, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationItem.title = Globals.snips[contest.id]?["name"].string ?? "test"
        
        self.navigationItem.rightBarButtonItem?.image = UIImage(imageLiteral: "ic_dubsmash").imageWithRenderingMode(.AlwaysOriginal)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "logo.png")!.resizableImageWithCapInsets(UIEdgeInsetsMake(16, 24, 0, 24), resizingMode: .Stretch), forBarPosition: .Any, barMetrics: .Default)
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addDub(sender: AnyObject) {
        if let url = NSURL(string: "https://dbsm.sh/s/\(contest.id)"){
            print(url)
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contest.dubs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("dubCell"),
            let dub = contest.dubs[safe: indexPath.row]{            
            let thumbnail = cell.viewWithTag(101) as! UIImageView
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                if let data = NSData(contentsOfURL: dub.thumbnailURL){
                    dispatch_async(dispatch_get_main_queue(), {
                        thumbnail.image = UIImage(data: data)
                        thumbnail.layer.cornerRadius = thumbnail.frame.width/2
                        thumbnail.clipsToBounds = true
                        
                        thumbnail.setNeedsLayout()
                        thumbnail.layoutIfNeeded()
                    })
                }
            })
            
            let usernameLabel = cell.viewWithTag(102) as! UILabel
            usernameLabel.text = "\(indexPath.row+1). \(dub.user)"
            
            let trophy = cell.viewWithTag(103) as! UIImageView
            if indexPath.row == 0{
                trophy.hidden = false
                
                trophy.image = UIImage(imageLiteral: "ic_trophy_gold").imageWithRenderingMode(.AlwaysTemplate)
                trophy.tintColor = UIColor(red: 218, green: 165, blue: 32)
            } else if indexPath.row == 1{
                trophy.hidden = false
                
                trophy.image = UIImage(imageLiteral: "ic_trophy_silver").imageWithRenderingMode(.AlwaysTemplate)
                trophy.tintColor = UIColor(red: 192, green: 192, blue: 192)
            } else if indexPath.row == 2{
                trophy.hidden = false
                
                trophy.image = UIImage(imageLiteral: "ic_trophy_bronze").imageWithRenderingMode(.AlwaysTemplate)
                trophy.tintColor = UIColor(red: 205, green: 127, blue: 50)
            } else{
                trophy.hidden = true
            }
            
            let eloText = cell.viewWithTag(104) as! UILabel
            eloText.text = "ELO: \(dub.elo)"
            
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "dubCell")
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.performSegueWithIdentifier("showDubDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch(segue.identifier ?? "") {
        case "showBattleSegue":
            
            if let destination = segue.destinationViewController as? BattleViewController {
                destination.contest = self.contest
                destination.myParentVC = self
            }
            
        case "showDubDetailSegue":
            if let destination = segue.destinationViewController as? DubDetailViewController {
                let selectedDub = contest.dubs[tableView.indexPathForSelectedRow!.row]
                destination.videoURL = selectedDub.videoURL
            }
        default:
            break
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        return .Portrait
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
