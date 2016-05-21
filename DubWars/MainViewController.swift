//
//  MainViewController.swift
//  DubWars
//


import Foundation
import UIKit
import Firebase

class MainViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    private var contests:[[String:AnyObject?]]? = nil
    private let database = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCellWithIdentifier("contestCell"){
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