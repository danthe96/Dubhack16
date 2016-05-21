//
//  DubDetailViewController.swift
//  DubWars
//
//  Created by Alec Schneider on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DubDetailViewController: ViewController {
    
    var videoURL: String = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: videoURL)
        let player = AVPlayer(URL: url!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        playerViewController.view.frame = self.view.frame
        self.view.addSubview(playerViewController.view)
        self.addChildViewController(playerViewController)
        
        player.play()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
