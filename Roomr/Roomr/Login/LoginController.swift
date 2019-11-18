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
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
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
    
    func pushNextController(existing user: Bool){
        if user == false {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "accountSetupNameController")
            let nameSetup = vc as! AccountSetupNameController
            self.navigationController?.pushViewController(nameSetup, animated: true)
        } else {
            let storyBoard = UIStoryboard(name: "HomeViewsStoryboard", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "homeViewController")
            let home = vc as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: {})
        }
    }

    //Delegate functionality
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          print(error)
          return
        }
        
        //firebase sign in
        guard let authentication = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credentials){ user, error in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
        }
        
        //push to onboarding or to home screen
        if let user = Auth.auth().currentUser {
            print(user.uid)
            let ref = self.ref.child("user").child(user.uid)
            ref.observeSingleEvent(of: .value, with: {snapshot in
                self.pushNextController(existing: snapshot.exists())
            })
        }
    }
}

