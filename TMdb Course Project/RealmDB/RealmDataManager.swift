//
//  RealmDataManager.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 31.07.2022.
//

import Foundation
import RealmSwift

struct DataManager {
    private let realm = try? Realm()
    func saveMedia(with model: Result?) {
        var mediaRealm = Media()
        mediaRealm.name = model?.title ?? model?.name ?? "No name"
        mediaRealm.id = model?.id ?? 0
        mediaRealm.posterPath = model?.posterPath ?? ""
        mediaRealm.releaseDate = model?.releaseDate ?? model?.firstAirDate  ?? "No data"
        mediaRealm.mediaDescription = model?.overview ?? "No data"
        mediaRealm.rating = model?.voteAverage ?? 0.0
        mediaRealm.mediaRaw = model?.mediaType?.rawValue ?? ""
        //Writing media in realm
        try? realm?.write {
            realm?.add(mediaRealm)
        }
    }
    func getMedia() -> [Media] {
        var media = [Media]()
        guard let mediaResults = realm?.objects(Media.self) else { return [] }
        for item in mediaResults {
            media.append(item)
        }
        return media
    }
    func deleteMedia(toDelete: Media){
        try! realm?.write {
            realm?.delete(toDelete)
        }
    }
}

