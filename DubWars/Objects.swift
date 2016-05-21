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
        self.dubs = json["dubs"].dictionary!.values.flatMap {Dub(json: $0["video"])}
    }
}

class Dub {
    let thumbnailURL: NSURL
    let videoURL: NSURL
    let snipID: String
    let user: String
    
    init(thumbnailURL: NSURL, videoURL: NSURL, snipID: String, user: String) {
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.snipID = snipID
        self.user = user
    }
    
    init(json: JSON) {
        self.thumbnailURL = NSURL(string: json["thumbnail"].stringValue)!
        self.videoURL = NSURL(string: json["video"].stringValue)!
        self.user = json["creator"].string!
        self.snipID = json["snip"].string!
    }
}