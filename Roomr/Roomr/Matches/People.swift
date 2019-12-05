//
//  People.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class People {
    let image: UIImage
    let name: String
    let date: Date
    let profileURL: String
    let key: String
    
    init(image: UIImage, name: String, date: Date, url: String, key: String) {
        self.image = image
        self.name = name
        self.date = Date()
        self.profileURL = url
        self.key = key
    }
}
