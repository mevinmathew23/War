//
//  FullRes+CoreDataProperties.swift
//  War
//
//  Created by Apple Dev on 2016-08-05.
//  Copyright © 2016 Apple Dev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FullRes {

    @NSManaged var imageData: NSData?
    @NSManaged var thumbnail: Thumbnail?

}
