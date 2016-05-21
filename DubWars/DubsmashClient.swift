//
//  DubsmashClient.swift
//  DubWars
//
//  Created by Daniel Thevessen on 21/05/16.
//  Copyright © 2016 Carl Julius Gödecken. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DubsmashClient{
    
    static let CLIENT_ID = "***REMOVED***"
    static let CLIENT_SECRET = "***REMOVED***"
    
    static let instance = DubsmashClient()
    
    var currentToken:String = "***REMOVED***"
    
    private var timer:NSTimer?
    private var username:String?
    private var password:String?
    
    private init(){
        self.timer = NSTimer(timeInterval: 50*60.0, target:self, selector: #selector(DubsmashClient.loadToken), userInfo:nil, repeats:false)
        
    }
    
    func login(username: String, password: String, callback: (String)->()){
        self.username = username
        self.password = password
        
        loadTokenWith(callback)
    }
    
    func loadSnip(snipId: String, callback: ((JSON) -> ())?){
        
        let parameters:[String:AnyObject] = [
            "username": self.username!,
            "password": self.password!,
            "grant_type": "password",
            "client_id": DubsmashClient.CLIENT_ID,
            "client_secret": DubsmashClient.CLIENT_SECRET
        ]
        
        Alamofire.request(.GET, "https://dubhack.dubsmash.com/snips/2a5855", parameters: parameters, headers: ["Content-Type": "application/json"])
            .responseJSON { response in
                if let res = response.result.value{
                    let json = JSON(res)
                    Globals.snips.updateValue(json, forKey: snipId)
                    
                    callback?(json)
                }
        }
        
    }
    
    @objc
    func loadToken(){
        loadTokenWith(nil)
    }
    
    private func loadTokenWith(callback: ((String)->())?){
        let parameters = [
            "username": self.username!,
            "password": self.password!,
            "grant_type": "password",
            "client_id": DubsmashClient.CLIENT_ID,
            "client_secret": DubsmashClient.CLIENT_SECRET
        ] as [String:AnyObject]
        
        Alamofire.request(.POST, "https://dubhack.dubsmash.com/me/login", parameters: parameters, encoding: .JSON, headers: ["Content-Type": "application/json"])
            .responseJSON { response in
                if let JSON = response.result.value {
                    print(JSON)
                    self.currentToken = JSON["access_token"] as! String!
                    
                    callback?(self.currentToken)
                }
        }
        
//        timer!.fire()
    }
    
}
