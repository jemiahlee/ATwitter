//
//  TweetsViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?

    @IBOutlet weak var tweetTable: UITableView!

    override func viewDidLoad() {
        tweetTable.delegate = self
        tweetTable.dataSource = self

        tweetTable.estimatedRowHeight = 100
        tweetTable.rowHeight = UITableViewAutomaticDimension

        navigationController?.navigationBarHidden = false

        TwitterClient.sharedInstance.homeTimelineWithCompletion() { (tweets: [Tweet]?, error: NSError?) -> Void in
            self.tweets = tweets
            self.tweetTable.reloadData()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }

        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }


    /*
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }*/

}
