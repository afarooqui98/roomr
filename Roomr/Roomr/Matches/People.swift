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
    
    init(image: UIImage, name: String, date: Date) {
        self.image = image
        self.name = name
        self.date = Date()
       
    }
    
    static func createArray(_ db: DatabaseReference?) -> [People] {
        var allPeople: [People] = []
        
        db?.child("Contact").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }
            
            for person in snapshot {
                let name = person.childSnapshot(forPath: "Name").value as? String
                
                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil",  date: Date())
                
                allPeople.append(people)
            }
        }){(error) in
            print(error.localizedDescription)
           
        }

//        let person1 = People(image: #imageLiteral(resourceName: "example"), name: "Sophia", date:Date())
//        let person2 = People(image: #imageLiteral(resourceName: "example"), name: "Ahmed",date:Date())
//        let person3 = People(image: #imageLiteral(resourceName: "example"), name: "Hari",date:Date())
//        let person4 = People(image: #imageLiteral(resourceName: "example"), name: "Dylan", date:Date())
//        let person5 = People(image: #imageLiteral(resourceName: "example"), name: "Vincent",date:Date())
//        let person6 = People(image: #imageLiteral(resourceName: "example"), name: "Sai", date:Date())
//        let person7 = People(image: #imageLiteral(resourceName: "example"), name: "Tianyang", date:Date())
//        let person8 = People(image: #imageLiteral(resourceName: "example"), name: "Shelly", date:Date())
//        let person9 = People(image: #imageLiteral(resourceName: "example"), name: "Ryan", date:Date())
//        let person10 = People(image: #imageLiteral(resourceName: "example"), name: "Katie", date:Date())
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
