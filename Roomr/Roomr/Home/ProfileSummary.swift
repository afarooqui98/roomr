//
//  ProfileSummary.swift
//  Roomr
//
//  Created by Katie Kwak on 11/19/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Koloda

class ProfileSummary {

    let user_key: String
    var user_name: String?
    var user_dob: String?
    var user_gender: String?
    var gender_preference: String?
    var housing_preference: Int?
    var cleanliness: Int?
    var volume: Int?
    var user_images: [UIImage]
    var user_info: String?
    var user_age: Int?
    var location: String?
    var major: String?
    var school: String?
    var likesCurrentUser: Bool // true if you are included in their list of likes (right swipes)
    var currentImgDisplayed: Int = 0 // index of image displayed in koloda view
    var profilePic_Url: String = ""


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

    
    
    
    init(name: String?, dob: String?, gender: String?, gender_pref: String?,
         housing_pref: Int?, clean: Int?, vol: Int?, info: String?, uid: String, likesYou: Bool, imgIndex: Int, kv: KolodaView) {
        self.user_key = uid
        user_name = name
        user_dob = dob
        user_gender = gender
        gender_preference = gender_pref
        housing_preference = housing_pref
        cleanliness = clean
        volume = vol
        user_images = [UIImage]()
        user_info = info
        likesCurrentUser = likesYou
        currentImgDisplayed = imgIndex
        
        if let birthday = user_dob {
            user_age = calculateAge(birthdate: birthday)
        }
        
        let user_folderURL = "gs://roomr-ecee8.appspot.com/" + self.user_key + "/"
        let imageStorageRef = Storage.storage().reference(forURL: user_folderURL)
        imageStorageRef.listAll { (result, error) in
          if let error = error {
            print("error listing user images \(error)")
          }
        
          for item in result.items {
            self.profilePic_Url = user_folderURL + result.items[0].name
            // The items under storageReference.
            item.getData(maxSize: 2 * 1024 * 1024, completion:
                { (data,error) in
                    if let error = error {
                        print("Error in downloading image \(error)")
                    } else {
                        if let imageData = data, let image = UIImage(data: imageData) {
                            self.user_images.append(image)
//                            DispatchQueue.main.async {
//                                kv.reloadData()
//                            }
                        }
                    }
                    DispatchQueue.main.async {
                        kv.reloadData()
                    }
            })
          } // for each image, convert to ui image
//            DispatchQueue.main.async {
//                kv.reloadData()
//            }

        } // list all images under user's foler in storage
    } /* init() */
    
    
} /* ProfileSummary: Summary of info on user, shown on home screen */
