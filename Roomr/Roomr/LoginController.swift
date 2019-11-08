//
//  ViewController.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/7/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var faceBookButton: UIButton!
    @IBOutlet weak var studentEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

