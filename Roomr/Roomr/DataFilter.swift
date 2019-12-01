//
//  File.swift
//  Roomr
//
//  Created by Ahmed Farooqui on 11/30/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit
import Firebase

func filterDataByPreference(_ currentProfile: UserSetupProfile) -> [UserSetupProfile] {
    let ref = Database.database().reference()
    var profiles : [UserSetupProfile]!
    
    let query = ref.child("user").queryLimited(toFirst: 10)
    query.observe(.childAdded) {(snapshot: DataSnapshot) in
        if let dict = snapshot.value as? [String: Any]{
            let score = computeScore(dict, currentProfile : currentProfile)
            if score >= 1.0 {
                let tempProfile = mapUserProfile(dict)
                tempProfile.score = score
                profiles.append(tempProfile)
            }
        }
    }
    
    return profiles
}

func computeScore(_ tempProfile: [String : Any], currentProfile: UserSetupProfile) -> Float{
    var score : Float = 0.0
    let housingPref = tempProfile["housingPref"] as! Int
    let gender = tempProfile["gender"] as! String
    let cleanliness = tempProfile["cleanliness"] as! Float
    let volume = tempProfile["volume"] as! Float
   
    switch housingPref {
    case 1:
        if currentProfile.housingPref == 2{
            score += 1.0
        } else if currentProfile.housingPref == 3{
            score += 0.25
        } else{
            score += 0.5
        }
    case 2:
        if currentProfile.housingPref == 2{
            score += 0.5
        } else if currentProfile.housingPref == 3{
            score += 0.25
        } else{
            score += 1.0
        }
    case 3:
        if currentProfile.housingPref == 2{
            score += 1.0
        } else if currentProfile.housingPref == 3{
            score += 0.25
        } else{
            score += 1.0
        }
    default:
        //somehow score is invalid/not set at login
        score += 0
    }
    
    if gender == currentProfile.genderPref || currentProfile.genderPref == "everyone"{
        score += 1.0
    }
    
    score = abs(cleanliness - currentProfile.cleanliness) <= 2.0 ? score + 1.0 : score
    score = abs(volume - currentProfile.volume) <= 2.0 ? score + 1.0 : score
    
    return score
}

func mapUserProfile(_ tempProfile: [String : Any]) -> UserSetupProfile{
    let name = tempProfile["firstName"] as! String
    let dob = tempProfile["DOB"] as! Date
    let housingPref = tempProfile["housingPref"] as! Int
    let gender = tempProfile["gender"] as! String
    let genderPref = tempProfile["genderPref"] as! String
    let cleanliness = tempProfile["cleanliness"] as! Float
    let volume = tempProfile["volume"] as! Float
    let bio = tempProfile["bio"] as! String
    
    let temp = UserSetupProfile.init()
    temp.firstName = name
    temp.DOB = dob
    temp.housingPref = housingPref
    temp.gender = gender
    temp.genderPref = genderPref
    temp.cleanliness = cleanliness
    temp.volume = volume
    temp.bio = bio
    
    return temp
}
