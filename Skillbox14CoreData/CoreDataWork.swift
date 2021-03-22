//
//  CoreDataWork.swift
//  Skillbox14CoreData
//
//  Created by Артём on 6/5/20.
//  Copyright © 2020 Artem A. All rights reserved.
//
import UIKit
import CoreData

class CoreDataWork {
    
    var tasks: [NSManagedObject] = []
    
    static let shared = CoreDataWork()
    
    
    func getData() -> [NSManagedObject]{
    
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Task")
        do {
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let managedObjectContext = appDelegate.persistentContainer.viewContext
          let tasks = try managedObjectContext.fetch(fetchRequest)
          return tasks
        } catch let error as NSError {
          print("Error fetching NSManagedObject: \(error.localizedDescription), \(error.userInfo)")
        }
        return [NSManagedObject]()
        
    }
    
    
    func save(taskName: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Task",
                                       in: managedContext)!
        
        let task = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        task.setValue(taskName, forKeyPath: "taskName")
        
        do {
            try managedContext.save()
            
            tasks.append(task)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func remove(index: Int){
        tasks = getData()
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {return}

        let context:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        context.delete(tasks[index] as NSManagedObject)
        
        tasks.remove(at: index)
        appDelegate.saveContext()
        
       
    }
}
