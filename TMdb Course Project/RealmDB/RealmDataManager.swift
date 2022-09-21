//
//  RealmDataManager.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 31.07.2022.
//

import Foundation
import RealmSwift

class DataManager {
    
    fileprivate lazy var mainRealm: Realm = {
        let config = Realm.Configuration(
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
            })
         Realm.Configuration.defaultConfiguration = config
        return try! Realm(configuration: .defaultConfiguration)
    }()
    
    
    func saveMedia(with model: Result?) {
        
        var mediaRealm = Media()
        
        mediaRealm.name = model?.title ?? model?.name ?? "No name"
        mediaRealm.id = model?.id ?? 0
        mediaRealm.posterPath = model?.posterPath ?? ""
        mediaRealm.releaseDate = model?.releaseDate ?? model?.firstAirDate  ?? "No data"
        mediaRealm.mediaDescription = model?.overview ?? "No data"
        mediaRealm.rating = model?.voteAverage ?? 0.0
        mediaRealm.mediaRaw = model?.mediaType?.rawValue ?? ""
        
        try! mainRealm.write {
            
            mainRealm.add(mediaRealm, update: .modified)
            
        }
    }
    
    func getMedia() -> [Media] {
        
        let mediaResults = mainRealm.objects(Media.self)
        
        return Array(mediaResults)
    }
    
    func deleteMedia(object: Object){
        
        try! mainRealm.write {
            
            mainRealm.delete(object)
            
        }
    }
    
}

