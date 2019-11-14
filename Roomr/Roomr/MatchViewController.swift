//
//  MatchViewController.swift
//  Roomr
//
//  Created by Sophia on 11/13/19.
//  Copyright © 2019 Ahmed Farooqui. All rights reserved.
//

import UIKit


class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var peopleInit: [People] = []
    var peopleQuery: [People] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.SearchBar.delegate = self
        self.peopleInit = People.createArray()
        self.peopleQuery = People.createArray()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
