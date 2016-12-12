//
//  Targets+CoreDataProperties.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import UIKit

extension Targets {

    @NSManaged var productName: String?
    @NSManaged var price: NSNumber?
    @NSManaged var endDate: Date?
    @NSManaged var startDate: Date?
    @NSManaged var picture: Data?
    @NSManaged var ready: NSNumber?
    @NSManaged var id: NSNumber?

    
    class func createNewItem(_ moc: NSManagedObjectContext, id: NSNumber, productName: String, price: NSNumber, endDate: Date, startDate: Date, picture: Data, ready: NSNumber) {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Targets", into: moc) as! Targets
        
        newItem.id = id
        newItem.productName = productName
        newItem.price = price
        newItem.endDate = endDate
        newItem.startDate = startDate
        newItem.picture = picture
        newItem.ready = ready
        
        do {
            try moc.save()
        } catch {
            print("Не сохранено")
        }
    }
    
    class func fetchData() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Targets")
        
        do {
            dataWish = try moc.fetch(fetchRequest) as! [Targets]
        } catch {
            print("Ошибка запроса")
        }
    }
    
    class func getDataForKey(_ keyId: Int) -> [Targets] {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Targets")
        
        let predicate = NSPredicate(format: "id == \(Int64(keyId))")
        fetchRequest.predicate = predicate
        
        // получим данные
        var fetchResultID = [Targets]()
        do {
            fetchResultID = try moc.fetch(fetchRequest) as! [Targets]
        }
        catch {}
        
        return fetchResultID
        
    }
    
    class func clearData() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

        // получим данные
        do {
            let fetchRequest = NSFetchRequest(entityName: "Targets")
            let searchResult = try moc.fetch(fetchRequest) as! [Targets]
            
            for arg in searchResult {
                moc.delete(arg)
            }
            try moc.save()
        }
        catch {}
    }
    
    class func clearItem(_ id: NSNumber) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Targets")
        
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        
        // получим данные
        var fetchResultID = [Targets]()
        do {
            fetchResultID = try moc.fetch(fetchRequest) as! [Targets]
        }
        catch {}
        
        // нашли
        if fetchResultID.count > 0 {
            do {
                
                for arg in fetchResultID {
                    moc.delete(arg)
                }
                
                try moc.save()
            } catch{}
        }
    }

    

}
