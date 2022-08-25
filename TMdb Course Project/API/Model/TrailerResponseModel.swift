//
//  TrailerResponseModel.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 29.07.2022.
//
import Foundation

// MARK: - TrailerResponseModel
struct movieTrailerModel: Codable {
    let id: Int?
    let results: [TrailerResult]?
}
// MARK: - Result
struct TrailerResult: Codable {
    let iso639_1, iso3166_1, name, key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt, id: String?

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
    enum Site: String, Codable {
        case youTube = "YouTube"
        case vimeo = "Vimeo"

    }
    enum TypeEnum: String, Codable {
        case behindTheScenes = "Behind the Scenes"
        case featurette = "Featurette"
        case teaser = "Teaser"
        case trailer = "Trailer"
        case clip = "Clip"
    }
}



