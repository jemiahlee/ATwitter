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

    override func viewDidLoad() {
        navigationController?.navigationBarHidden = false
        self.title = "ATwitter"

        if let navigationBar = navigationController?.navigationBar {
            print("Got into the navigationBar block")
            navigationBar.tintColor = UIColor.blueColor()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backButton = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButton;
    }
}
