//
//  shelterListViewController.swift
//  Homeless Shelter
//
//  Created by Johnny Maroun on 4/23/18.
//  Copyright © 2018 MarounApps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class shelterListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var shelterList = [shelter]()
    let cellId = "cellId"
    
    var filteredData = [shelter]()
    
    var isSearching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var shelterListTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return shelterList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        if isSearching {
            cell.textLabel?.text = filteredData[indexPath.row].name
        } else {
            cell.textLabel?.text = shelterList[indexPath.row].name
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            shelterListTableView.reloadData()
        } else {
            isSearching = true
            let text = searchBar.text
            filteredData = shelterList.filter({($0.name?.localizedCaseInsensitiveContains(text!))!})
            shelterListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shelterListTableView.delegate = self
        shelterListTableView.dataSource = self
        fetchShelters()
        
    }
    
    func afterFetch() {
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        print(self.shelterList.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        performSegue(withIdentifier: "cancelSegue", sender: nil)
    }
    
    func fetchShelters() {
        ref = FIRDatabase.database().reference()
        refHandle = ref.child("shelter").observe(.childAdded, with: { (snapshot) in
            if let address = snapshot.childSnapshot(forPath: "address").value {
                let capacity = snapshot.childSnapshot(forPath: "capacity").value
                let latitude = snapshot.childSnapshot(forPath: "latitude").value
                let longitude = snapshot.childSnapshot(forPath: "longitude").value
                let name = snapshot.childSnapshot(forPath: "name").value
                let phone = snapshot.childSnapshot(forPath: "phone").value
                let restrictions = snapshot.childSnapshot(forPath: "restrictions").value
                let roomType = snapshot.childSnapshot(forPath: "roomType").value
                let special = snapshot.childSnapshot(forPath: "special").value
                
                let s = shelter()
                s.address = address as? String
                s.capacity = capacity as? Double
                s.latitude = latitude as? Double
                s.longitude = longitude as? Double
                s.name = name as? String
                s.phone = phone as? String
                s.restrictions = restrictions as? String
                s.roomtype = roomType as? String
                s.special = special as? String
                
                self.shelterList.append(s)
                print(self.shelterList.count)
                if (self.shelterList.count == 14) {
                    self.ref.removeObserver(withHandle: self.refHandle)
                    self.afterFetch()
                }
                
                DispatchQueue.main.async {
                    self.shelterListTableView.reloadData()
                }
            }
        })
    }

}
