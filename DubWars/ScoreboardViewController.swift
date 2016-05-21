//
//  ScoreBoardViewController.swift
//  DubWars
//
//  Created by Alec Schneider on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import UIKit
import Firebase

class ScoreboardViewController: ViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let database = FIRDatabase.database().reference()
    
    var snipId: String = "";
    var dubs: [String: AnyObject]?;
    // var currentContest: String;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        database.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let postDict = (snapshot.value as! [String : [String: String]])["dubwars"] as! [String: String]
            ö
            let dubs = postDict!["dubwars"]
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dubs!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
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
