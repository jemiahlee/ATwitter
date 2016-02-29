//
//  HamburgerViewController.swift
//  ATwitter
//
//  Created by Jeremiah Lee on 2/28/16.
//  Copyright © 2016 Jeremiah Lee. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!

    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuViewController.view.frame = menuView.bounds
            self.addChildViewController(menuViewController)
            menuViewController.willMoveToParentViewController(self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }

    var contentViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            contentViewController.view.frame = contentView.bounds
            self.addChildViewController(contentViewController)
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            closeMenu()
        }
    }

    override func viewDidLoad() {

    }

    func openMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 50
            self.view.layoutIfNeeded()
        })
    }

    func closeMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMarginConstraint.constant
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 {
                self.openMenu()
            }
            else {
                self.closeMenu()
            }
        }

    }
}
