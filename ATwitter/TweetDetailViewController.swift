//
//  TweetDetailViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/21/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

let formatter = NSDateFormatter()

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
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
        formatter.dateFormat = "MM/dd/yy, hh:mm a"

        screennameLabel.text = "@\((tweet?.user?.screenname)!)"
        nameLabel.text = tweet?.user?.name
        tweetTextLabel.text = tweet?.text
        dateLabel.text = formatter.stringFromDate((tweet?.createdAt)!)
        updateFields()

        let avatarImageRequest = NSURLRequest(URL: (tweet?.user?.profileImageURL)!)
        avatarImageView.setImageWithURLRequest(avatarImageRequest, placeholderImage: nil,
            success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                self.avatarImageView.image = image
            }, failure: { (request, response,error) -> Void in
                print("Something went wrong with the image load")
            }
        )

        if (tweet?.isFavorited)! {
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
        }

        if (tweet?.isRetweeted)! {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action-inactive.png"), forState: .Normal)
        }
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
        tweet?.invertRetweet() { () -> Void in
            self.updateFields()
            self.invertRetweetedImage()
        }
    }

    @IBAction func favoriteClick(sender: AnyObject) {
        tweet?.invertFavorite() { () -> Void in
            self.updateFields()
            self.invertFavoriteImage()
        }
    }

    func invertFavoriteImage() {
        if (tweet?.isFavorited)! {
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
        }
    }

    func invertRetweetedImage() {
        if (tweet?.isRetweeted)! {
            retweetButton.setImage(UIImage(named: "retweet-action-inactive.png"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: .Normal)
        }
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
