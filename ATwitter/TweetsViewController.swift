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
    var sentTweet: Tweet?
    var user: User?              // tweetFunc: (() -> [Tweet]?)?
    var clickableNames = true
    var mentions = false

    @IBOutlet weak var tweetTable: UITableView!
    @IBOutlet weak var newTweetButton: UIBarButtonItem!

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

    override func viewDidAppear(animated: Bool) {
        print("got into viewDidAppear")
        if sentTweet != nil {
            tweets?.insert(sentTweet!, atIndex: 0)
            sentTweet = nil // shouldn't need this anymore.
            tweetTable.reloadData()
        }
        else {
            refreshData(self)
        }
    }

    override func viewWillAppear(animated: Bool) {
    }

    func refreshData(sender: AnyObject) {
        print("in refreshData, mentions is \(mentions)")
        if user == nil {
            if mentions {
                User.currentUser!.getMentionTweets() { (tweets: [Tweet]?, error: NSError?) -> Void in
                    self.tweets = tweets
                    self.tweetTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            else {
                User.currentUser!.getTimelineTweets() { (tweets: [Tweet]?, error: NSError?) -> Void in
                    self.tweets = tweets
                    self.tweetTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
        else {
        if mentions {
            user!.getMentionTweets() { (tweets: [Tweet]?, error: NSError?) -> Void in
                self.tweets = tweets
                self.tweetTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        else {
            user!.getFeedTweets() { (tweets: [Tweet]?, error: NSError?) -> Void in
                self.tweets = tweets
                self.tweetTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
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
        cell.clickableNames = clickableNames
        cell.tweet = tweets![indexPath.row]
        cell.controller = self
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "refreshData:")
        self.navigationItem.backBarButtonItem = backButton;

        if segue.identifier == "toTweetDetailSegue" {
            let vc = segue.destinationViewController as! TweetDetailViewController
            let indexPath = tweetTable.indexPathForCell(sender as! UITableViewCell)
            vc.tweet = tweets![indexPath!.row]
        }
        else if segue.identifier == "toCreateTweetDetailSegue" {
            let vc = segue.destinationViewController as! CreateTweetViewController
            if let cell = sender as? UITableViewCell {
                let indexPath = tweetTable.indexPathForCell(cell)
                vc.tweet = tweets![indexPath!.row]
            }
        }
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("TweetDetailViewController") as! TweetDetailViewController

        let tweet = tweets![indexPath.row]
        detailsViewController.tweet = tweet
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
