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

class ScoreboardViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var snipId: String = "";
    private var dubs: [JSON]?
    // var currentContest: String;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.dubs = Globals.contests?[self.snipId]["dubs"].array
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dubs?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("dubCell"),
            let dub = dubs?[safe: indexPath.row]{
            
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "dubCell")

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "battle" {
            if let destination = segue.destinationViewController as? ViewController {
                // TODO contest name/sound übergeben
            }
        }
        else if segue.identifier == "dubDetail" {
            if let destination = segue.destinationViewController as? ViewController {
                // dub infos übergeben
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
