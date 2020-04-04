//
//  DataHandler.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 04.04.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import Foundation
import CoreData

class DataHandler {
    
    static let shared = DataHandler()
    
    private init() {}
    
    /// Private function for fech request according to the table name
    /// - Parameters:
    ///   - tableName: table name for request
    ///   - userContext: context for request
    /// - Returns: return request data or nil if return error
    private func fechRequest(table tableName: String, context userContext: NSManagedObjectContext) -> [Any]? {
        let fechRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        do {
            let result = try userContext.fetch(fechRequest)
            return result
        } catch {
            return nil
        }
    }
    
    /// Private functino for clear table
    /// - Parameters:
    ///   - tableName: table name for clear
    ///   - userContext: user context for clear table
    /// - Returns: False if during removal arose error
    private func clearTable(table tableName: String, context userContext: NSManagedObjectContext) -> Bool {
        let allData = fechRequest(table: tableName, context: userContext)
        if allData != nil {
            for managedObject in allData! {
                let managedObjectData = managedObject as? NSManagedObject
                if managedObjectData != nil {
                    userContext.delete(managedObjectData!)
                } else {
                    return false
                }
            }
        } else {
            return false
        }
        return true
    }
}
