//
//  ProfileViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/28/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import AFNetworking
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsView: UIView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!

    var user: User!

    override func viewDidLoad() {
        if user != nil {
            nameLabel.text = user.name!
            screennameLabel.text = "@\((user.screenname)!)"
            avatarImageView.setImageWithURL(user.profileImageURL!, placeholderImage: nil)

            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            followingCountLabel.text = formatter.stringFromNumber((user.followingCount)!)!
            followerCountLabel.text = formatter.stringFromNumber((user.followerCount)!)!
        }
    }
}
