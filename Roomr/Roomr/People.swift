//
//  People.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import Foundation
import UIKit
class People {
    let image: UIImage
    let name: String
    let message: String
    let date: String
    
    init(image: UIImage, name: String, message: String, date: String) {
        self.image = image
        self.name = name
        self.message = message
        self.date = date
    }
}
