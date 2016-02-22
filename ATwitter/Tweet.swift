//
//  Tweet.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import SwiftDate
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
    var isRetweeted = false
    var favoriteCount = 0
    var retweetCount = 0

    init(dictionary: JSON) {
        self.dictionary = dictionary

        id = dictionary["id"].intValue
        user = User(dictionary: dictionary["user"])
        text = dictionary["text"].stringValue
        isFavorited = dictionary["favorited"].boolValue
        isRetweeted = dictionary["retweeted"].boolValue
        favoriteCount = dictionary["favorite_count"].intValue
        retweetCount = dictionary["retweet_count"].intValue
        createdAtString = dictionary["created_at"].stringValue

        dateParser.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let createdAtString = createdAtString {
            createdAt = dateParser.dateFromString(createdAtString)
        }
    }

    func age() -> String {
        return createdAt!.toRelativeString(abbreviated: true, maxUnits: 1)!
    }

    func invertFavorite(completion: () -> ()) {
        TwitterClient.sharedInstance.setTweetFavorite(self.id!, favorited: !self.isFavorited) { (updatedTweet: Tweet?, error: NSError?) -> Void in
            if updatedTweet != nil {
                self.isFavorited = (updatedTweet?.isFavorited)!
                if self.isFavorited {
                    self.favoriteCount += 1
                }
                else {
                    self.favoriteCount -= 1
                }
            }
        }
        completion()
    }

    func invertRetweet(completion: () -> ()) {
        TwitterClient.sharedInstance.retweet(self, completion: { (newTweet: Tweet?, error: NSError?) -> Void in
            if newTweet != nil {
                self.isRetweeted = !self.isRetweeted
                if self.isRetweeted {
                    self.retweetCount += 1
                }
                else {
                    self.retweetCount -= 1
                }
            }
        })
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
