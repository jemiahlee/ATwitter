//
//  MentionsViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/28/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    @IBOutlet weak var mentionsView: UIView!

    override func viewDidLoad() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let tweetsViewController = storyBoard.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController

        tweetsViewController.mentions = true
        self.addChildViewController(tweetsViewController)
        tweetsViewController.willMoveToParentViewController(self)
        tweetsViewController.view.frame = mentionsView.bounds
        mentionsView.addSubview(tweetsViewController.view)
        tweetsViewController.didMoveToParentViewController(self)
    }
}
