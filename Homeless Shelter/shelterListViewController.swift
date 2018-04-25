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
    var filteredByGender = [shelter]()
    var filteredByAge = [shelter]()
    var filteredByGenderAndAge = [shelter]()
    
    var isSearching = false
    var isSearchingGender = false
    var isSearchingAge = false
    var genderSearching = false
    var ageRangeSearching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var genderSearchBar: UISearchBar!
    @IBOutlet weak var ageSearchBar: UISearchBar!
    
    @IBOutlet weak var shelterListTableView: UITableView!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageRangeLabel: UILabel!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var ageRangePickerView: UILabel!
    let genders = ["Any", "Male", "Female"]
    let ageRange = ["Anyone", "Children", "Young Adults", "Families w/ Newborns", "Families"]

 
    var address: String?
    var capacity: Double?
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var phone: String?
    var restrictions: String?
    var roomtype: String?
    var special: String?
    var shelterCount: String?


    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        let text = currentCell?.textLabel?.text
        for s in shelterList {
            if (s.name?.localizedCaseInsensitiveContains(text!))! {
                address = s.address
                capacity = s.capacity
                latitude = s.latitude
                longitude = s.longitude
                name = s.name
                phone = s.phone
                restrictions = s.restrictions
                roomtype = s.roomtype
                special = s.special
                shelterCount = s.shelterCount
            }
        }
        self.performSegue(withIdentifier: "shelterDataSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shelterDataSegue" {
            let secondViewController = segue.destination as! shelterDataViewController
            secondViewController.address = address
            secondViewController.capacity = capacity
            secondViewController.latitude = latitude
            secondViewController.longitude = longitude
            secondViewController.name = name
            secondViewController.phone = phone
            secondViewController.restrictions = restrictions
            secondViewController.roomtype = roomtype
            secondViewController.special = special
            secondViewController.shelterCount = shelterCount
        }
    }
    
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
    
//    func genderSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if genderSearchBar.text == nil || genderSearchBar.text == "" {
//            isSearchingGender = false
//            view.endEditing(true)
//            shelterListTableView.reloadData()
//        } else {
//            isSearchingGender = true
//            let text = genderSearchBar.text
//            filteredData = shelterList.filter({($0.restrictions?.localizedStandardContains(text!))!})
//            shelterListTableView.reloadData()
//        }
//    }
//
//    func ageSearchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if ageSearchBar.text == nil || ageSearchBar.text == "" {
//            isSearchingAge = false
//            view.endEditing(true)
//            shelterListTableView.reloadData()
//        } else {
//            isSearchingAge = true
//            let text = ageSearchBar.text
//            filteredData = shelterList.filter({($0.restrictions?.localizedCaseInsensitiveContains(text!))!})
//            shelterListTableView.reloadData()
//        }
//    }
    
    
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
                s.shelterCount = String(self.shelterList.count)
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
