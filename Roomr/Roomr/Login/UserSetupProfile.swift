//
//  UserSetupProfile.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/14/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit

class UserSetupProfile {
    var firstName : String
    var DOB : Date
    var gender: String
    var genderPref: String
    var housingPref: Int
    var cleanliness: Float
    var volume: Float
    var pics : [UIImage]
    
    init(){
        self.firstName = ""
        self.DOB = Date()
        self.gender = ""
        self.genderPref = ""
        self.housingPref = 0
        self.cleanliness = 0.0
        self.volume = 0.0
        self.pics = []
    }
}
