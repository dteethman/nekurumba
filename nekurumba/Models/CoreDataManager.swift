//
//  CoreDataModel.swift
//  aaaa
//
//  Created by Дмитрий Зубков on 17.07.2020.
//

import CoreData
import UIKit

struct TrackedSmoke {
    var year: Int
    var month: Int
    var day: Int
    var hour: Int
    var minute: Int
}

class CoreDataManager {
    let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    lazy var context = persistentContainer?.viewContext
    
    func loadAllData() -> [SmokeTracker]? {
        let fetchRequest: NSFetchRequest<SmokeTracker> = SmokeTracker.fetchRequest()
        
        if let objects = try? context!.fetch(fetchRequest) as [SmokeTracker] {
            return objects
        } else {
            return nil
        }
    }
    
    func loadForDate(year: Int, month: Int, day: Int) -> [SmokeTracker]? {
        let fetchRequest: NSFetchRequest<SmokeTracker> = SmokeTracker.fetchRequest()
        
        let yearPredicate = NSPredicate(format: "year == %d", Int32(year))
        let monthPredicate = NSPredicate(format: "month == %d", Int32(month))
        let dayPredicate = NSPredicate(format: "day == %d", Int32(day))
        
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, monthPredicate, yearPredicate])
        
        let sortDescriptors = [
            NSSortDescriptor(key: "year", ascending: true),
            NSSortDescriptor(key: "month", ascending: true),
            NSSortDescriptor(key: "day", ascending: true),
            NSSortDescriptor(key: "hour", ascending: true),
            NSSortDescriptor(key: "minute", ascending: true),
            
        ]
        
        fetchRequest.predicate = andPredicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        if let objects = try? context!.fetch(fetchRequest) as [SmokeTracker] {
            return objects
        } else {
            return nil
        }
    }
    
    func addData(date: Date) {
        let calendar = Calendar.current
        
        guard let entity = NSEntityDescription.entity(forEntityName: "SmokeTracker", in: context!) else {
            fatalError("Could not find entity description SmokeTracker!")
        }
        let year = Int32(calendar.component(.year, from: date))
        let month = Int32(calendar.component(.month, from: date))
        let day = Int32(calendar.component(.day, from: date))
        let hour = Int32(calendar.component(.hour, from: date))
        let minute = Int32(calendar.component(.minute, from: date))
            
        let tracker = NSManagedObject(entity: entity, insertInto: context)
        tracker.setValue(year, forKey: "year")
        tracker.setValue(month, forKey: "month")
        tracker.setValue(day, forKey: "day")
        tracker.setValue(hour, forKey: "hour")
        tracker.setValue(minute, forKey: "minute")
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func printSmokeData(_ data: [SmokeTracker]?) {
        if data != nil {
            for d in data! {
                print(d.year, d.month, d.day, d.hour, d.minute)
            }
        } else {
            print("data id nil")
        }
    }
}
