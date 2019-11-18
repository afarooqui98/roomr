//
//  ViewController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/7/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInDelegate{
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var studentEmailButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.signIn()
        
        faceBookButton.titleLabel?.adjustsFontSizeToFitWidth = true
        studentEmailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        studentEmailButton.titleLabel?.minimumScaleFactor = 0.5
        faceBookButton.titleLabel?.minimumScaleFactor = 0.5
        
        faceBookButton.layer.cornerRadius = 10
        studentEmailButton.layer.cornerRadius = 10
        studentEmailButton.layer.borderWidth = 1
        studentEmailButton.layer.borderColor = UIColor(red:0.00, green:0.60, blue:1.00, alpha:1.0).cgColor
        // Do any additional setup after loading the view.
    }

    //Delegate functionality
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          print(error)
          return
        }
        
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credentials){ user, error in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
        }
    }
}

