//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Oguzhan Ozturk on 6.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nameText : UITextField!
    @IBOutlet var salaryText : UITextField!
    @IBOutlet var adrText : UITextField!
    @IBOutlet var descText : UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveComplete), name: .NSManagedObjectContextDidSave, object: nil)
        
        
        
    }

    @objc private func saveComplete(){
        print("Save Complete")
    }
    
    @IBAction func action(_ sender : Any){
        print(Thread.isMainThread)
        guard nameText.text != "" else{
            print("Fill all fields")
            return
        }
       
        guard Int(salaryText.text ?? "") != nil else{
            print("enter number")
            return
        }
        
        guard adrText.text != "" else{
            print("Fill all fields")
            return
        }
      
        guard descText.text != "" else{
            print("Fill all fields")
            return
        }
        
        let personObject = DBHelper.sharedStore.createObjectModel(entityName: "Person", values: ["name" : nameText.text! , "salary" : Int(salaryText.text!)!])

        let adrObject = DBHelper.sharedStore.createObjectModel(entityName: "Address", values: ["name" : adrText.text! , "desc" : descText.text!])
        
        DBHelper.sharedStore.createPersonModel(personModel: personObject!, addressModel: adrObject!)
        
        print(personObject)
        print(adrObject)
        print("***************************************")
        //print(DBHelper.sharedStore.managedContext.insertedObjects)
        
        DBHelper.sharedStore.saveObjects()
    }
    
    @IBAction func gotoPersonelPage(_ sender : Any){
        
        performSegue(withIdentifier: "gotoPersonel", sender: nil)
        
    }

}

