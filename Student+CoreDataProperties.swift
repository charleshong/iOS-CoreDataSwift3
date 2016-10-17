//
//  Student+CoreDataProperties.swift
//  CoreDataSwift3
//
//  Created by sherriff on 10/17/16.
//  Copyright © 2016 Mark Sherriff. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var name: String?
    @NSManaged public var compid: String?

}
