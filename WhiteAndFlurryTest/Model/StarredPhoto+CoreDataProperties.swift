//
//  StarredPhoto+CoreDataProperties.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 13.01.2022.
//
//

import Foundation
import CoreData


extension StarredPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarredPhoto> {
        return NSFetchRequest<StarredPhoto>(entityName: "StarredPhoto")
    }

    @NSManaged public var id: String?
    @NSManaged public var created_at: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var authorName: String?
    @NSManaged public var location: String?
    @NSManaged public var downloads: Int64
    @NSManaged public var photoURL: String?

}

extension StarredPhoto : Identifiable {

}
