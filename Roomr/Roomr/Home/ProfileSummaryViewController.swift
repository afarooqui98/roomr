//
//  ProfileSummaryViewController.swift
//  Roomr
//
//  Created by Katie Kwak on 11/19/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class ProfileSummaryViewController: UIViewController {
    
    @IBOutlet weak var user_imageView: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var gender_label: UILabel!
    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var preference_label: UILabel!
    @IBOutlet weak var bio_label: UILabel!
    
    var user_image: UIImage?
    var user_name: String?
    var user_age: String?
    var user_preference: String?
    var user_gender: String?
    var user_bio: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_imageView.image = user_image
        name_label.text = user_name
        gender_label.text = user_gender
        age_label.text = user_age
        preference_label.text = user_preference
        bio_label.text = user_bio
    }
    

} /* ProfileSummaryViewController: pops up when user taps down on Koloda/Card view */
