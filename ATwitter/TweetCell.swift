//
//  TweetCell.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import AFNetworking
import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!

    var tweet: Tweet? {
        didSet {
            tweetLabel.text = tweet?.text
            screennameLabel.text = "@" + (tweet?.user?.screenname)!
            nameLabel.text = tweet?.user?.name
            let avatarImageRequest = NSURLRequest(URL: (tweet?.user?.profileImageURL)!)
            avatarImageView.setImageWithURLRequest(avatarImageRequest, placeholderImage: nil,
                success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                    self.avatarImageView.image = image
                }, failure: { (request, response,error) -> Void in
                    print("Something went wrong with the image load")
                }
            )
            ageLabel.text = tweet?.age()
            setFavoritedImage()
        }
    }

    func setFavoritedImage() {
        if tweet!.isFavorited {
            print("Attempting to set the image to be the red heart")
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
        } else {
            print("Attempting to set the image to be the grey heart")
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
        }
    }

    @IBAction func replyToTweet(sender: AnyObject) {
    }

    @IBAction func retweetTweet(sender: AnyObject) {
    }

    @IBAction func favoriteTweet(sender: AnyObject) {
        tweet!.invertFavorite() { () -> Void in
            print("calling setFavoritedImage")
            self.setFavoritedImage()
        }
    }
}