//
//  HamburgerMenuViewController.swift
//  Roomr
//
//  Created by Katie Kwak on 11/20/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import SideMenuSwift


class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class HamburgerMenuViewController: UIViewController, UINavigationControllerDelegate {
    
    var current_VC : String? // current view controller being presented

    override func viewDidLoad() {
        super.viewDidLoad()

        sideMenuController?.delegate = self
        
        // cache profile, settings, home, and matches view controllers into side menu controller
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
        let matchesStoryBoard = UIStoryboard(name: "match", bundle: nil)
        let homeStoryBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
        
        self.sideMenuController?.cache(viewControllerGenerator: {
            profileStoryBoard.instantiateViewController(withIdentifier: "TabController")
        }, with: "profileVC")
        
        self.sideMenuController?.cache(viewControllerGenerator: {
            matchesStoryBoard.instantiateViewController(withIdentifier: "MatchTabController")
        }, with: "matchesVC")
        
        self.sideMenuController?.cache(viewControllerGenerator: {
            profileStoryBoard.instantiateViewController(withIdentifier: "TabController")
        }, with: "settingsVC")
        
        
        self.sideMenuController?.cache(viewControllerGenerator: {
            homeStoryBoard.instantiateViewController(withIdentifier: "sideMenuController")
        }, with: "homeVC")
    } /* viewDidLoad() */
    
    
    
    
    func checkPresentedView(class_name: String) -> Bool {
        // obtain string names of cached VCs in our side menu controller
        guard let content_views = self.sideMenuController?.contentViewController.children.map ({ child -> String in
            return NSStringFromClass(child.classForCoder)
        }) else { return false }
        
        return content_views.contains(class_name)
        
    } /* checkPresentedView(): returns true if @viewID is being presented */

    
        
    
    @IBAction func editProfile_pressed(_ sender: UIButton) {
        if (current_VC == nil || current_VC != "Roomr.ProfileViewController") {
            self.sideMenuController?.setContentViewController(with: "profileVC", animated: Preferences.shared.enableTransitionAnimation)
            current_VC = "Roomr.ProfileViewController"
        }
        self.sideMenuController?.hideMenu()
    } /* editProfile_pressed() in side menu */
    
    
    
    @IBAction func matches_pressed(_ sender: UIButton) {
        if (current_VC == nil || current_VC != "Roomr.MatchViewController") {
            self.sideMenuController?.setContentViewController(with: "matchesVC", animated: Preferences.shared.enableTransitionAnimation)
            current_VC = "Roomr.MatchViewController"
        }
         self.sideMenuController?.hideMenu()
    } /* matches_pressed() in side menu */
    
    
    
    @IBAction func settings_pressed(_ sender: UIButton) {
        if (current_VC == nil || current_VC != "Roomr.SettingsViewController") {
            self.sideMenuController?.setContentViewController(with: "settingsVC", animated: Preferences.shared.enableTransitionAnimation)
            // TODO: add this after Ryan merges
//            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//            let vc = storyboard.instantiateViewController(identifier: "TabController") as! TabController
        //vc.defaultIndex = 0
//            self.sideMenuController?.setContentViewController(to: vc, animated: false, completion: nil)
            current_VC = "Roomr.SettingsViewController"
        }
        self.sideMenuController?.hideMenu()
    } /* settings_pressed() in side menu */

    
    
    @IBAction func home_pressed(_ sender: UIButton) {
        // only load home if it isn't already being presented

        // case when home vc is presented for first time, instead of checking current_VC
        // which would be nil, check the children of content view
        if (checkPresentedView(class_name: "Roomr.HomeViewController")) {
            current_VC = "Roomr.HomeViewController"
            return
        }
        
        if (current_VC == nil || current_VC != "Roomr.HomeViewController") {
            self.sideMenuController?.setContentViewController(with: "homeVC", animated: Preferences.shared.enableTransitionAnimation)
            current_VC = "Roomr.HomeViewController"
        }
        self.sideMenuController?.hideMenu()
    } /* home_pressed() in side menu */
} /* HamburgerMenuViewController */






extension HamburgerMenuViewController: SideMenuControllerDelegate {
    
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }

    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
    
}
