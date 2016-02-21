//
//  User.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import SwiftyJSON
import UIKit

var _currentUser: User?
let _currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: JSON?

    init(dictionary: JSON) {
        self.dictionary = dictionary

        name = dictionary["name"].stringValue
        screenname = dictionary["screen_name"].stringValue
        profileImageURL = dictionary["profile_image_url"].stringValue
        tagline = dictionary["description"].stringValue
    }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(_currentUserKey) as? NSData {
                    let json = JSON(data: data)
                    _currentUser = User(dictionary: json)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            if user != nil {
                let data = user!.dictionary!
                let data_string = "\(data)"
                NSUserDefaults.standardUserDefaults().setObject(data_string.dataUsingEncoding(NSUTF8StringEncoding), forKey: _currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: _currentUserKey)
            }

            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}