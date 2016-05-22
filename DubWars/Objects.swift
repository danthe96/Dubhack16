//
//  Objects.swift
//  DubWars
//
//  Created by Carl Julius Gödecken on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias DubPair = (Dub, Dub)

class Contest {
    let id: String
    let dubs: [Dub]
    
    
    init?(json: JSON) {
        if let id = json["snipId"].string, dubValues = json["dubs"].dictionary?.values,
            dubs = json["dubs"].dictionary?.values.flatMap({ json -> Dub? in
                if let elo = json["elo"].int {
                    return Dub(json: json["video"], elo: elo)
                }
                return nil
            }) where dubs.count == json["dubs"].dictionary?.values.count {
            self.id = id
            self.dubs = dubValues.flatMap {Dub(json: $0["video"], elo: ($0["elo"].int)!)}.sort({$0.elo > $1.elo})
        }   else    {
            print("Error parsing Contest: \(json.rawString() ?? "nil")")
            return nil
        }
    }
    
    func createBattle() -> [DubPair] {
        var pool = dubs
        var selected = [(Dub, Dub)]()
        
        while pool.count > 1 {
            let other = Int(arc4random_uniform(UInt32(pool.count)))
            let dub1 = pool[other]
            pool.removeAtIndex(other)
            let one = Int(arc4random_uniform(UInt32(pool.count)))
            let dub2 = pool[one]
            pool.removeAtIndex(one)
            
            selected.append((dub1, dub2))
        }
        return selected
    }
    
    class func createMultiBattle(contests: [Contest]) -> [DubPair]  {
        return contests.map { $0.createBattle() }
            .reduce([(Dub, Dub)](), combine: {(accumulator, new) -> [DubPair] in
                var accumulator = accumulator
                accumulator.appendContentsOf(new)
                return accumulator
        })
    }
}

class Dub {
    let thumbnailURL: NSURL
    let videoURL: NSURL
    let snipID: String  // i.e. contestId
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
    
    init?(json: JSON, elo:Int) {
        if let thumbnailURL = NSURL(string: json["thumbnail"].stringValue),
        videoURL = NSURL(string: json["video"].stringValue),
        user = json["creator"].string,
            snipID = json["snip"].string  {
            self.thumbnailURL = thumbnailURL
            self.videoURL = videoURL
            self.user = user
            self.snipID = snipID
            self.elo = elo
        }   else {
            print("Error parsing Dub: \(json.rawString() ?? "nil")")
            return nil
        }
    }
}