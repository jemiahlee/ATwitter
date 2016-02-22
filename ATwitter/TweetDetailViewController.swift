//
//  TweetDetailViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/21/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    internal var tweet: Tweet?

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!

    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false

        screennameLabel.text = "@\((tweet?.user?.screenname)!)"
        nameLabel.text = tweet?.user?.name
        tweetTextLabel.text = tweet?.text
        updateFields()

        let avatarImageRequest = NSURLRequest(URL: (tweet?.user?.profileImageURL)!)
        avatarImageView.setImageWithURLRequest(avatarImageRequest, placeholderImage: nil,
            success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                self.avatarImageView.image = image
            }, failure: { (request, response,error) -> Void in
                print("Something went wrong with the image load")
            }
        )
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButton;

        let vc = segue.destinationViewController as! CreateTweetViewController
        vc.tweet = tweet
    }


    @IBAction func replyClick(sender: AnyObject) {
        performSegueWithIdentifier("toReplySegue", sender: self)
    }

    @IBAction func retweetClick(sender: AnyObject) {
    }

    @IBAction func favoriteClick(sender: AnyObject) {
    }


    func updateFields() {
        favoriteCountLabel.text = "\((tweet?.favoriteCount)!)"
        retweetCountLabel.text = "\((tweet?.retweetCount)!)"

        if tweet != nil {
            if tweet!.favoriteCount == 1 {
                favoriteLabel.text = "FAVORITE"
            }
            else {
                favoriteLabel.text = "FAVORITES"
            }

            if tweet!.retweetCount == 1 {
                retweetsLabel.text = "RETWEET"
            }
            else {
                retweetsLabel.text = "RETWEETS"
            }
        }
    }

}
