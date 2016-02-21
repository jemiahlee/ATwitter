//
//  Tweet.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import SwiftyJSON
import UIKit

let dateParser = NSDateFormatter()

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: JSON?
    var isFavorited = false

    init(dictionary: JSON) {
        self.dictionary = dictionary

        id = dictionary["id"].intValue
        user = User(dictionary: dictionary["user"])
        text = dictionary["text"].stringValue
        isFavorited = dictionary["favorited"].boolValue
        createdAtString = dictionary["created_at"].stringValue

        dateParser.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let createdAtString = createdAtString {
            createdAt = dateParser.dateFromString(createdAtString)
        }
    }

    func age() {

    }

    func invertFavorite(completion: () -> ()) {
        if self.isFavorited {
            TwitterClient.sharedInstance.setTweetAsNotFavorite(self.id!) { (updatedTweet: Tweet?, error: NSError?) -> Void in
                if updatedTweet != nil {
                    self.isFavorited = (updatedTweet?.isFavorited)!
                    print("Setting Tweet to \(self.isFavorited)")
                }
            }
        } else {
            TwitterClient.sharedInstance.setTweetAsFavorite(self.id!) { (updatedTweet: Tweet?, error: NSError?) -> Void in
                if updatedTweet != nil {
                    self.isFavorited = (updatedTweet?.isFavorited)!
                    print("Setting Tweet to \(self.isFavorited)")
                }
            }
        }
        completion()
    }
    
    class func tweetsFromJSON(json: JSON) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in json.arrayValue {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
