//
//  TweetsViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]?

    override func viewDidLoad() {
        TwitterClient.sharedInstance.homeTimelineWithCompletion() { (tweets: [Tweet]?, error: NSError?) -> Void in
            self.tweets = tweets
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

}
