//
//  Tweet.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import SwiftyJSON
import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?

    init(dictionary: JSON) {
        user = User(dictionary: dictionary["user"])
        text = dictionary["text"].stringValue
        createdAtString = dictionary["created_at"].stringValue

        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let createdAtString = createdAtString {
            createdAt = formatter.dateFromString(createdAtString)
        }

    }

    class func tweetsFromJSON(json: JSON) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in json.arrayValue {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
