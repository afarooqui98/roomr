//
//  ContactCell.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit

class ContactCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    //    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Name: UILabel!
    //    @IBOutlet weak var Name: UILabel!
//    @IBOutlet weak var msg: UILabel!
    

    
    func setContact(profile: People) {
        // set up UI
        self.ImageView.contentMode = .scaleAspectFill
        self.ImageView.layer.cornerRadius = 40
        self.ImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ImageView.clipsToBounds = true
        
        // assign data
        self.ImageView.image = profile.image
        self.Name.text = profile.name
       
        
    }

}
