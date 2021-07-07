//
//  PersonalTableViewController.swift
//  CoreDataProject
//
//  Created by Oguzhan Ozturk on 6.07.2021.
//

import UIKit
import CoreData

class PersonalTableViewController: UITableViewController {

    private var datas : [NSManagedObject] = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       getData()
    }
    
    private func getData(){
        DBHelper.sharedStore.getAllObjects { [weak self] (datas) in
            guard let datas = datas else{ print("Error")
                return
            }
            self?.datas = datas
            self?.tableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = datas[indexPath.row].value(forKey: "name") as? String
        
        return cell
        
    }
    

}
