//
//  RealmMediaModel.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 31.07.2022.
//

import Foundation
import RealmSwift

@objcMembers
class DatabaseMediaModel: Object {
    dynamic var name = ""
    dynamic var releaseDate = ""
    dynamic var mediaDescription = ""
    dynamic var rating = 0.0
    dynamic var posterPath = ""
    dynamic var id = 0
    dynamic var mediaRaw = MediaType.movie.rawValue
    
    var media: MediaType {
        get {
            for media in MediaType.allCases where mediaRaw == media.rawValue {
                return media
            }
            return .movie //default
        }
        set {
            mediaRaw = newValue.rawValue 
        }
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
    
}
