//
//  ProfileSummary.swift
//  Roomr
//
//  Created by Katie Kwak on 11/19/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit

class ProfileSummary {

    let user_key: String
    var user_image: UIImage?
    var user_name: String?
    var user_dob: String?
    var user_gender: String?
    var gender_preference: String?
    var housing_preference: Int?
    var cleanliness: Int?
    var volume: Int?
    var room_pics:  [UIImage?]
    var user_info: String?
    var user_age: Int?
    var location: String?
    var major: String?
    var school: String?



    init(image: UIImage?, name: String?, dob: String?, gender: String?, gender_pref: String?,
         housing_pref: Int?, clean: Int?, vol: Int?, pics: [UIImage?], info: String?, uid: String) {
        self.user_key = uid
        user_image = image
        user_name = name
        user_dob = dob
        user_gender = gender
        gender_preference = gender_pref
        housing_preference = housing_pref
        cleanliness = clean
        volume = vol
        room_pics = pics
        user_info = info
        
        if let birthday = user_dob {
            user_age = calculateAge(birthdate: birthday)
        }
    }
    
    
    func calculateAge(birthdate: String) -> Int? {
        let current_year = Calendar.current.component(.year, from: Date())
        
        // birthday string formatted as: xx-xx-xxxx,
        // make substring containing only the year
        if let birth_year = Int(birthdate.dropFirst(6)) {
            return current_year - birth_year
        } else {
            return nil
        }
    } /* calculateAge(): given date of birth, calculate age */
    
} /* ProfileSummary: Summary of info on user, shown on home screen */
