//
//  TicketInfo+CoreDataProperties.swift
//  KWDC_Check-in
//
//  Created by mac on 10/13/24.
//
//

import Foundation
import CoreData


extension TicketInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketInfo> {
        return NSFetchRequest<TicketInfo>(entityName: "TicketInfo")
    }

    @NSManaged public var bookingNumber: Int64
    @NSManaged public var data: Data?
    @NSManaged public var name: String?
    @NSManaged public var qrUrlString: String?
    @NSManaged public var isWalletSaved: Bool
}
