//
//  PostalCode+CoreDataProperties.swift
//  WTest
//
//  Created by Rafael Costa Santos on 12/03/2021.
//
//

import Foundation
import CoreData


extension PostalCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostalCode> {
        return NSFetchRequest<PostalCode>(entityName: "PostalCode")
    }

    @NSManaged public var desig_postal: String?
    @NSManaged public var ext_cod_postal: String?
    @NSManaged public var num_cod_postal: String?

}

extension PostalCode : Identifiable {

}
