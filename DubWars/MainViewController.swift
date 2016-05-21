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
    
    @IBOutlet var tableView: UITableView!
    
    private var contests:[JSON]? = nil
    private let database = FIRDatabase.database().reference()
    
    private var contestsHandle:FIRDatabaseHandle? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contestsHandle = database.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let dict = JSON(snapshot.value as! [String : AnyObject]!)["dubwars"]["contests"]
            self.contests = dict.dictionaryValue.values.map({($0)})
            
            print(snapshot.value)
            
            self.tableView.reloadData()
            
        })
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return contests?.count ?? 0
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("contestCell"),
            let contest = contests?[safe: indexPath.row]{
            
            let thumbnail = cell.viewWithTag(101) as! UIImageView
            if let dubs = contest["dubs"].array,
                address = dubs.first?["video"]["thumbnail"].string,
                url = NSURL(string: address){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    if let data = NSData(contentsOfURL: url){
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
            //TODO
            
            let soundName = cell.viewWithTag(103) as! UILabel
            let playButton = cell.viewWithTag(104) as! UIButton
            
            
            
            let submitButton = cell.viewWithTag(105) as! UIButton
            //TODO
            
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "contestCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "battle" {
            if let destination = segue.destinationViewController as? ViewController {
                // TODO nichts übergeben bzw contest = all oder sowas
            }
        } else if segue.identifier == "showScoreboardSegue" {
            if let destination = segue.destinationViewController as? ScoreboardViewController {
                destination.snipId = "2a5855"
            }
        }
    }
}