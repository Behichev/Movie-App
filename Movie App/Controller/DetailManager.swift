//
//  DetailManager.swift
//  Movie App
//
//  Created by Ivan Behichev on 04.02.2023.
//

import Foundation

struct DetailManager {
    let fetchedObjects = RealmDataManager.shared.getMedia()
    
    func deleteMedia(with media: DetailsScreenConfiguration) {
        for object in fetchedObjects {
            if object.name == media.mediaTitle {
                RealmDataManager.shared.deleteMedia(object: object)
            }
        }
    }
}
