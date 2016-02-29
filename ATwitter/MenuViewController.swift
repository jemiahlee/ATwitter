//
//  MenuViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/28/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import AFNetworking
import UIKit

class MenuViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileCell: UIView!
    @IBOutlet weak var homeTimelineCell: UIView!

    var profileController: UIViewController!
    var homeTimelineController: UIViewController!

    var hamburgerViewController: HamburgerViewController!

    var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        homeTimelineController = storyboard.instantiateViewControllerWithIdentifier("TweetNavigationController")

        viewControllers.append(profileController!)
        viewControllers.append(homeTimelineController!)

        hamburgerViewController.contentViewController = homeTimelineController

        let user = User.currentUser
        if user != nil {
            nameLabel.text = (user!.name)!
            screennameLabel.text = "\((user!.screenname)!)"
            avatarImageView.setImageWithURL(user!.profileImageURL!, placeholderImage: nil)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row != 0 {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row - 1]
            hamburgerViewController.contentViewController.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
}
