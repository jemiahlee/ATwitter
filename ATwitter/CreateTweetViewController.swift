//
//  CreateTweetViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/21/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController, UITextViewDelegate {
    var tweet: Tweet?

    @IBOutlet weak var charactersLeftLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!

    override func viewDidLoad() {
        tweetTextView.delegate = self

        if let user = User.currentUser {
            screennameLabel.text = "@" + (user.screenname)!
            nameLabel.text = user.name!
            let avatarImageRequest = NSURLRequest(URL: (user.profileImageURL)!)
            avatarImageView.setImageWithURLRequest(avatarImageRequest, placeholderImage: nil,
                success: { (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                    self.avatarImageView.image = image
                }, failure: { (request, response,error) -> Void in
                    print("Something went wrong with the image load")
                }
            )
        }

        if tweet != nil {
            tweetTextView.text = "@\(tweet?.user?.screenname) "
        }

        updateTwitterCharacterCount()
    }

    func textViewDidChange(textView: UITextView) {
        updateTwitterCharacterCount()
    }

    func updateTwitterCharacterCount(){
        let TWITTER_CHARS = 140
        let current_length = tweetTextView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let remaining = TWITTER_CHARS - current_length
        if remaining > 0 {
            charactersLeftLabel.textColor = UIColor.blackColor()
        } else {
            charactersLeftLabel.textColor = UIColor.redColor()
        }
        charactersLeftLabel.text = "\(remaining) characters left"
    }
}
