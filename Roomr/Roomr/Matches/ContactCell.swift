//
//  ContactCell.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase

class ContactCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var Name: UILabel!
    var person: People!{
        didSet{
            self.setContact()
        }
    }
    func setContact() {
        // set up UI
        self.ImageView.contentMode = .scaleAspectFill
        self.ImageView.layer.cornerRadius = 40
        self.ImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ImageView.clipsToBounds = true
        self.ImageView.layer.cornerRadius = (self.ImageView.frame.size.width ) / 2
        self.ImageView.layer.borderWidth = 3.0
        self.ImageView.layer.borderColor = UIColor.white.cgColor

        // assign data
//        self.ImageView.image = person.image
        self.Name.text = person.name
        
        // update image
        let imageStorageRef = Storage.storage().reference(forURL: person.profileURL)
        imageStorageRef.getData(maxSize: 2 * 1024 * 1024, completion:
            { (data,error) in
                if let error = error {
                    print("Error in downloading image \(error)")
                } else {
                    if let imageData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            self.ImageView.image = image
                        }
                    }
                }
        })
    }

}
