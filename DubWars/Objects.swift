//
//  Objects.swift
//  DubWars
//
//  Created by Carl Julius Gödecken on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import SwiftyJSON

class Contest {
    let name: String
    let id: String
    let dubs: [Dub]
    
    init(json: JSON) {
        self.id = json["snipId"].string!
        self.name = json["name"].string!
        self.dubs = json["dubs"].dictionary!.values.flatMap {Dub(json: $0["video"], elo: $0["elo"].int!)}.sort({$0.elo > $1.elo})
    }
    
    func createBattle() -> [(Dub, Dub)] {
        var pool = dubs
        var selected = [(Dub, Dub)]()
        
        for i in 0 ..< pool.count {
            var other = Int(arc4random_uniform(UInt32(pool.count)))
            let one = (i + 12345) % pool.count
            if one == other {
                other = (other + 1) % pool.count
            }
            selected.append((dubs[one], dubs[other]))
            pool.removeAtIndex(other)
        }
        return selected
    }
}

class Dub {
    let thumbnailURL: NSURL
    let videoURL: NSURL
    let snipID: String
    let user: String
    let elo: Int
    
    var timesSelected = 0
    
    init(thumbnailURL: NSURL, videoURL: NSURL, snipID: String, user: String, elo: Int) {
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.snipID = snipID
        self.user = user
        self.elo = elo
    }
    
    init(json: JSON, elo:Int) {
        self.thumbnailURL = NSURL(string: json["thumbnail"].stringValue)!
        self.videoURL = NSURL(string: json["video"].stringValue)!
        self.user = json["creator"].string!
        self.snipID = json["snip"].string!
        self.elo = elo
    }
}