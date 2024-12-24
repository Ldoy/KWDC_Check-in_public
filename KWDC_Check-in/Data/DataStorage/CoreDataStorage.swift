//
//  CoreDataManager.swift
//  KWDC_Check-in
//
//  Created by mac on 9/5/24.
//

import Foundation
import CoreData

class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewTicketData")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    fileprivate func saveInContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("fail to save ticket in core data. Error: \(error)")
        }
    }
    
    func saveTicket(_ data: Data, userName: String, qrUrl: String, bookigNumber: Int64) {
        if let previousTikcket = fetchTicket() {
            saveNewTicket(previousTikcket, data, userName, qrUrl, bookigNumber)
            print(qrUrl)
            saveInContext()
        } else {
            if let entityDescription = NSEntityDescription.entity(forEntityName: "TicketInfo",
                                                                  in: persistentContainer.viewContext) {
                let newTicket = TicketInfo(entity: entityDescription, insertInto: self.context)
                saveNewTicket(newTicket, data, userName, qrUrl, bookigNumber)
                saveInContext()
            } else {
                print("Failed to get entity description for Ticket")
            }
        }
    }
    
    func fetchTicket() -> TicketInfo? {
        let fetchRequest: NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
    
    func bringUserName() -> String {
        let fetchRequest = fetchTicket()
        let name = fetchRequest?.name
        
        if let name = name {
            return name
        } else {
            return "unknown"
        }
    }
    
    func bringUserBookingNumber() -> Int {
        let fetchRequest = fetchTicket()
        let errorNumber = -1

        guard let bookingNumber = fetchRequest?.bookingNumber else { return errorNumber }
        
        return Int(bookingNumber)
    }
    
    private func saveNewTicket(_ ticket: TicketInfo,
                               _ data: Data, _ userName: String,
                               _ qrUrl: String, _ bookingNumber: Int64) {
        ticket.data = data
        ticket.name = userName
        ticket.qrUrlString = qrUrl
        ticket.bookingNumber = bookingNumber
    }
}
