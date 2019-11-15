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
    var pics : [UIImage]
    
    init(){
        self.firstName = ""
        self.DOB = Date()
        self.gender = ""
        self.genderPref = ""
        self.pics = []
    }
}
