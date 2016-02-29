//
//  TwitterClient.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import BDBOAuth1Manager
import SwiftyJSON

let twitterConsumerKey = "97uHjncUkVhHh8AUdtdEBtl7y"
let twitterConsumerSecret = "VmnSb8fcDYrb8EGgPOaGOWWiVM721Zj7MYflmptIlDZoJcxhBs"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> Void)?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }

        return Static.instance
    }

    func getUserFeed(user: User, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        let params = ["screen_name": (user.screenname)!]
        self.GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsFromJSON(JSON(response!))
            completion(tweets: tweets, error: nil)
            print(tweets[0].dictionary)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
    }

    func homeTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsFromJSON(JSON(response!))
            completion(tweets: tweets, error: nil)
            print(tweets[0].dictionary)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
    }


    func loginWithCompletion(completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion
        
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("failed to get request token")
        }
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.requestSerializer.saveAccessToken(accessToken)

            self.GET("1.1/account/verify_credentials.json", parameters: nil,
                success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let user = User(dictionary: JSON(response!))
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                },
                failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    self.loginCompletion?(user: nil, error: error)
                }
            )
        }, failure: { (error: NSError!) -> Void in
            print("Error: Did not get the access token")
        })
    }

    func setTweetFavorite(id: Int, favorited: Bool, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var favorite_url = "1.1/favorites/create.json"

        if !favorited {
            favorite_url = "1.1/favorites/destroy.json"
        }

        self.POST(favorite_url, parameters: ["id": id],
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: JSON(response!))
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }

    func retweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        var retweet_url = "1.1/statuses/retweet/\((tweet.id)!).json"

        if tweet.isRetweeted {
            retweet_url = "1.1/statuses/unretweet/\((tweet.id)!).json"
        }

        let id: Int = (tweet.id)!
        self.POST(retweet_url, parameters: ["id": id],
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: JSON(response!))
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }

    func tweet(message: String, inReplyToStatusId: Int?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let tweet_url = "1.1/statuses/update.json"

        var parameters = ["status": message]
        if let replyId: Int = inReplyToStatusId {
            parameters["in_reply_to_status_id"] = "\(replyId)"
        }

        self.POST(tweet_url, parameters: parameters,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: JSON(response!))
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }
}