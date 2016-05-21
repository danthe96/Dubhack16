//
//  MainViewController.swift
//  DubWars
//


import Foundation
import UIKit
import FirebaseDatabase

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
        return UITableViewCell(style: .Default, reuseIdentifier: "contestCell")
    }
    
}