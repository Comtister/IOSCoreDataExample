//
//  DBHelper.swift
//  CoreDataProject
//
//  Created by Oguzhan Ozturk on 6.07.2021.
//

import Foundation
import CoreData

class DBHelper{
    //Singleton Object
    static let sharedStore = DBHelper()
    
    private(set) var persistentContainer : NSPersistentContainer
    private(set) var managedContext : NSManagedObjectContext
    
    private init(){
        self.persistentContainer = NSPersistentContainer(name: "BaseModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error{
                fatalError("Error Store Load \(error)")
            }
        
        }
        
        self.managedContext = persistentContainer.newBackgroundContext()
    }
    
    func clearContext(){
        managedContext.reset()
        managedContext.refreshAllObjects()
    }
    
    func deleteObjectInContext(object : NSManagedObject){
        managedContext.delete(object)
        managedContext.refreshAllObjects()
    }
    
    //Create object model in context and optional return
    func createObjectModel(entityName : String , values : [String : Any]) -> NSManagedObject?{
        var returnValue : NSManagedObject? = nil
        
            if let entityDesc = NSEntityDescription.entity(forEntityName: entityName, in: managedContext){
                
                let objectModel = NSManagedObject(entity: entityDesc, insertInto: managedContext)
                
                for value in values{
                    objectModel.setValue(value.value, forKey: value.key)
                }
                
                //managedContext.delete(objectModel)
                //managedContext.refreshAllObjects()
                returnValue = objectModel
                
            }else{
                print("Error Wrong entity name")
                returnValue = nil
            }
            
        
        return returnValue
        
    }
    // join person and address model
    func createPersonModel(personModel : NSManagedObject , addressModel : NSManagedObject) -> NSManagedObject{
        personModel.setValue(addressModel, forKey: "addresses")
        return personModel
    }
    
    //Save context current state in background thread
    func saveObjects(){
        
        persistentContainer.performBackgroundTask { [weak self](context) in
           
            do{
                try self?.managedContext.save()
            }catch{
                print("Save Error")
            }
        }
       
    }
    
    func getAllObjects(completion : @escaping ([NSManagedObject]?) -> Void){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        persistentContainer.performBackgroundTask { [weak self] (context) in
            do{
                let result = try self?.managedContext.fetch(fetchRequest) as! [NSManagedObject]
                
                DispatchQueue.main.async {
                    completion(result)
                }
               
            }catch{
                print("catch error")
            }
            
        }
        
      
    }
    
    func deleteObject(object : NSManagedObject){
        
        persistentContainer.performBackgroundTask { [weak self] (context) in
            
            self?.managedContext.delete(object)
            
            do{
                try context.save()
            }catch{
                print("Save Error")
            }
        }
        
    }
    
}
