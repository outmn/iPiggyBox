//
//  Calculation+CoreDataProperties.swift
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


extension Calculation {

    @NSManaged var productName: String?
    @NSManaged var incomeDate: Date?
    @NSManaged var amount: NSNumber?
    @NSManaged var id: NSNumber?
    
    class func createNewItem(_ moc: NSManagedObjectContext, productName: String, incomeDate: Date, amount: NSNumber, id: NSNumber) {
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Calculation", into: moc) as! Calculation
        newItem.id = id
        newItem.productName = productName
        newItem.amount = amount
        newItem.incomeDate = incomeDate
        
        do {
            try moc.save()
        } catch {
            print("Ошибка сохранения данных в базу Calculation")
        }
    }
    
    class func fetchData() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Calculation")
        
        do {
            dataCalculation = try moc.fetch(fetchRequest) as! [Calculation]
        } catch {
            print("Ошибка запроса в базе Calculation")
        }
    }

    class func getDataForKey(_ keyId: Int) -> [Calculation] {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        var currentItem = [Calculation]()
        let fetchRequest = NSFetchRequest(entityName: "Calculation")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "id == \(Int64(keyId))")
        fetchRequest.predicate = predicate
        
        // получим данные
        var fetchResultID = [Calculation]()
        do {
            fetchResultID = try moc.fetch(fetchRequest) as! [Calculation]
        }
        catch {}
        
        // нашли
        if fetchResultID.count > 0 {
            currentItem = fetchResultID
        }
        
        return currentItem

    }
    
    
    class func clearData() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        
        // получим данные
        do {
            let fetchRequest = NSFetchRequest(entityName: "Calculation")
            let searchResult = try moc.fetch(fetchRequest) as! [Calculation]
            
            for arg in searchResult {
                moc.delete(arg)
            }
            try moc.save()
        }
        catch {}
    }


}
