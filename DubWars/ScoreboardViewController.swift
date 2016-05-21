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
    
    var snipId: String = ""
    private var selectedVideo: NSURL? = nil
    var contest: Contest!
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contest.dubs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("dubCell"),
            let dub = contest.dubs[safe: indexPath.row]{
            print(dub)
            
            let thumbnail = cell.viewWithTag(101) as! UIImageView
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if let data = NSData(contentsOfURL: dub.thumbnailURL){
                        dispatch_async(dispatch_get_main_queue(), {
                            thumbnail.image = UIImage(data: data)
                            thumbnail.layer.cornerRadius = 10
                            thumbnail.clipsToBounds = true
                        
                            thumbnail.setNeedsLayout()
                            thumbnail.layoutIfNeeded()
                        })
                    }
                })
            
            let usernameLabel = cell.viewWithTag(102) as! UILabel
            
            usernameLabel.text = dub.user
            
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "dubCell")

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let dub = contest.dubs[safe: indexPath.row]{
            self.selectedVideo = dub.videoURL
        }
        self.performSegueWithIdentifier("showDubDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBattleSegue" {
            if let destination = segue.destinationViewController as? UIViewController {
                // TODO contest name/sound übergeben
            }
        }
        else if segue.identifier == "showDubDetailSegue" {
            if let destination = segue.destinationViewController as? DubDetailViewController {
                destination.videoURL = self.selectedVideo
            }
        }
    }


    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
