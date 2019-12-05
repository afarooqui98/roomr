//
//  FriendCell.swift
//  Roomr
//
//  Created by Sophia on 12/5/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import Firebase
class FriendCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    var person: People!{
        didSet{
            self.setContact()
        }
    }
    func setContact() {
            // set up image UI
            self.image.contentMode = .scaleAspectFill
            self.image.layer.cornerRadius = 40
            self.image.translatesAutoresizingMaskIntoConstraints = false
            self.image.clipsToBounds = true
            self.image.layer.cornerRadius = (self.image.frame.size.width ) / 2
            self.image.layer.borderWidth = 3.0
            self.image.layer.borderColor = UIColor.white.cgColor

            // assign data
    //        self.ImageView.image = person.image
            self.name.text = person.name
            
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
                                self.image.image = image
                            }
                        }
                    }
            })
        }
}
