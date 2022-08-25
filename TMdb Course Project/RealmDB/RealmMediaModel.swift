//
//  RealmMediaModel.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 31.07.2022.
//

import Foundation
import RealmSwift

class Media: Object {
    @objc dynamic var name = ""
    @objc dynamic var releaseDate = ""
    @objc dynamic var mediaDescription = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var posterPath = ""
    @objc dynamic var id = 0
    @objc dynamic var mediaRaw = MediaType.movie.rawValue
    
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
}
