//
//  ViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/20/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

class ViewController: UIViewController {

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() { (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

