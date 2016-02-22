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
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tweetTable: UITableView!

    override func viewDidLoad() {
        tweetTable.delegate = self
        tweetTable.dataSource = self

        tweetTable.estimatedRowHeight = 100
        tweetTable.rowHeight = UITableViewAutomaticDimension

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        tweetTable.insertSubview(refreshControl, atIndex: 0)

        refreshData(self)
    }

    func refreshData(sender: AnyObject) {
        TwitterClient.sharedInstance.homeTimelineWithCompletion() { (tweets: [Tweet]?, error: NSError?) -> Void in
            self.tweets = tweets
            self.tweetTable.reloadData()
            self.refreshControl.endRefreshing()
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backButton = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: "refreshData:")
        self.navigationItem.backBarButtonItem = backButton;

        if segue.identifier == "toTweetDetailSegue" {
            let vc = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tweetTable.indexPathForCell(sender as! UITableViewCell)
            vc.tweet = tweets![indexPath!.row]
        }
        else if segue.identifier == "toCreateTweetDetailSegue" {
            print("Would segue to CreateTweetViewController")
            // let vc = segue.destinationViewController as! CreateTweetViewController
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
}
