//
//  MatchViewController.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var peopleInit: [People] = []
    var peopleQuery: [People] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.SearchBar.delegate = self
        self.ref = Database.database().reference()
        let userID = "90VZVPq028eFEJPCt83PeLFPKem2"
        var allPeople: [People] = []
        
//        ref?.child("Contact").observe(DataEventType.value, with: { (snapshot) in
        ref?.child("user").child(userID).child("Contacts").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return }

            for person in snapshot {
                let name = person.childSnapshot(forPath: "Name").value as? String
                let msg = person.childSnapshot(forPath: "Msg").value as? String

                let people = People(image: #imageLiteral(resourceName: "example"), name: name ?? "nil", message: msg ?? "nil", date: "Nov 1st")

                allPeople.append(people)
            }
            self.peopleInit = allPeople
            self.peopleQuery = allPeople
            print(self.peopleInit)
            self.tableView.reloadData()
        }){(error) in
            print(error.localizedDescription)

        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.peopleQuery.count)
        return self.peopleQuery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = peopleQuery[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.setContact(profile: person)
        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            peopleQuery = self.peopleInit
            self.tableView.reloadData()
            
        } else {
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text: String) {
        peopleQuery = self.peopleInit.filter({(mod) -> Bool in
            return mod.name.lowercased().contains(text.lowercased())
        })
        self.tableView.reloadData()
    }
}
