//
//  UserSetupProfile.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit

/*housingPref: 1 means need apartment
                2 means need roommate
                3 means both
 cleanliness and volume go from 1-10*/
class UserSetupProfile{
    var uid : String
    var firstName : String
    var phoneNumber: String
    var DOB : Date
    var gender: String
    var genderPref: String
    var housingPref: Int
    var cleanliness: Float
    var volume: Float
    var pics : [UIImage]
    var bio: String
    var score: Float
    
    init(){
        self.uid = ""
        self.firstName = ""
        self.phoneNumber = ""
        self.DOB = Date()
        self.gender = ""
        self.genderPref = ""
        self.housingPref = 0
        self.cleanliness = 0.0
        self.volume = 0.0
        self.pics = []
        self.bio = ""
        self.score = 0.0
    }
}
