//
//  DataManager.swift
//  US States
//
//  Created by John Hannan on 7/2/15.
//  Copyright (c) 2015 John Hannan. All rights reserved.
//

// The Data Manager implements the Core Data Stack and provides the following public methods/variables
//  managedObjectContext - needed by the model
//  saveContext() method
//  fetchManagedObjectsForEntity method for performing a fetch

import Foundation
import CoreData


// Model should support this protocol
protocol DataManagerDelegate : class {  // need the class so delegate can be weak var
    var xcDataModelName : String { get }
    func createDatabase() -> Void
}

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private init() {
        
    }
    
    weak var delegate : DataManagerDelegate? {
        didSet {
            if !databaseExists {
                delegate!.createDatabase()
            }
        }
    }
    
 
    
    //MARK: Core Data Stack
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.psu.cse.hannan.US_States" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // let NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: self.delegate!.xcDataModelName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
        // let model URL = NSBundle.mainBundle().URLForResource(self.delegate!.xcDataModelName, withExtension: "momd")!
        // return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let sqliteName = self.delegate!.xcDataModelName + ".sqlite"
        let url = self.applicationDocumentsDirectory.appendingPathComponent(sqliteName)
        //let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(sqliteName)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            //try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.undoManager = UndoManager()
        
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: Database File Manager
    private lazy var databasePath : URL = {
        let sqlite = self.delegate!.xcDataModelName + ".sqlite"
        let path = self.applicationDocumentsDirectory.appendingPathComponent(sqlite)
        return path}()
        
    
    
    private lazy var databaseExists : Bool = {
        let exists = FileManager.default.fileExists(atPath: self.databasePath.path)
        return exists}()
    
    
    //MARK: Fetching Data
    
    // fetch all objects for the given entity that satisfy the given predicate, and sort according to the sort keys
    // return the result as an array of NSManagedObjects
    func fetchManagedObjectsForEntity(entityName:String, sortKeys keys:[String], predicate pred:NSPredicate?) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = pred
        
        var descriptors : [NSSortDescriptor] = Array()
        for key in keys {
            let sortDescriptor = NSSortDescriptor(key: key, ascending: true)
            descriptors.append(sortDescriptor)
        }
        request.sortDescriptors = descriptors
        let context = self.managedObjectContext
        let results = (try! context.fetch(request)) as! [NSManagedObject]
        return results
    }
    
}
