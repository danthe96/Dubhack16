//
//  MainViewController.swift
//  DubWars
//
//  Created by Daniel Thevessen on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    private var contests:[[String:AnyObject?]]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
}