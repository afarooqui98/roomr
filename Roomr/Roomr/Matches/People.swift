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
    let message: String
    let date: String
    
    init(image: UIImage, name: String, message: String, date: String) {
        self.image = image
        self.name = name
        self.message = message
        self.date = date
    }
    
    static func createArray(_ db: DatabaseReference?) -> [People] {
        var allPeople: [People] = []
        
        db?.child("Contact").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            
            for person in snapshot {
                let name = person.childSnapshot(forPath: "Name").value as? String
                let msg = person.childSnapshot(forPath: "Msg").value as? String
            
                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil", message: msg ?? "nil", date: "Nov 1st")
                
                allPeople.append(people)
            }
        }){(error) in
            print(error.localizedDescription)
           
        }

//        let person1 = People(image: #imageLiteral(resourceName: "example"), name: "Sophia", message: "hi", date: "Nov 1st")
//        let person2 = People(image: #imageLiteral(resourceName: "example"), name: "Ahmed", message: "hi", date: "Nov 1st")
//        let person3 = People(image: #imageLiteral(resourceName: "example"), name: "Hari", message: "hi", date: "Nov 1st")
//        let person4 = People(image: #imageLiteral(resourceName: "example"), name: "Dylan", message: "hi", date: "Nov 1st")
//        let person5 = People(image: #imageLiteral(resourceName: "example"), name: "Vincent", message: "hi", date: "Nov 1st")
//        let person6 = People(image: #imageLiteral(resourceName: "example"), name: "Sai", message: "hi", date: "Nov 1st")
//        let person7 = People(image: #imageLiteral(resourceName: "example"), name: "Tianyang", message: "hi", date: "Nov 1st")
//        let person8 = People(image: #imageLiteral(resourceName: "example"), name: "Shelly", message: "hi", date: "Nov 1st")
//        let person9 = People(image: #imageLiteral(resourceName: "example"), name: "Ryan", message: "hi", date: "Nov 1st")
//        let person10 = People(image: #imageLiteral(resourceName: "example"), name: "Katie", message: "hi", date: "Nov 1st")
//        
//        allPeople.append(person1)
//        allPeople.append(person2)
//        allPeople.append(person3)
//        allPeople.append(person4)
//        allPeople.append(person5)
//        allPeople.append(person6)
//        allPeople.append(person7)
//        allPeople.append(person8)
//        allPeople.append(person9)
//        allPeople.append(person10)

        return allPeople
    }
}
