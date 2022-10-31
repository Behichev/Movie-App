//
//  ApiManager.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 08.07.2022.
//

import Foundation

enum ApiType {
    case getTrandingMovies
    case getTrandingShows
    case getPopularPerson
    case searchMovie(search: String)
    case searchTV(search: String)
    case getMovieTrailer(movieID: Int)
    case getTVtrailer(TVid: Int)

    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var path: String {
        switch self {
        case .getTrandingMovies: return "trending/movie/week?api_key=4f8afb35881a873ad0abc5c32dcfbcb1"
        case .getTrandingShows: return "trending/tv/week?api_key=4f8afb35881a873ad0abc5c32dcfbcb1"
        case .getPopularPerson: return "trending/person/week?api_key=4f8afb35881a873ad0abc5c32dcfbcb1"
        case .searchMovie(search: let search): return "search/movie?api_key=4f8afb35881a873ad0abc5c32dcfbcb1&language=en-US&query=\(search)"
        case .searchTV(search: let search): return
            "search/tv?api_key=4f8afb35881a873ad0abc5c32dcfbcb1&language=en-US&query=\(search)"
        case .getMovieTrailer(movieID: let movieID): return
            "movie/\(String(describing: movieID))/videos?api_key=4f8afb35881a873ad0abc5c32dcfbcb1&language=en-US"
        case .getTVtrailer(TVid: let TVid): return "https://api.themoviedb.org/3/tv/\(TVid)/videos?api_key=4f8afb35881a873ad0abc5c32dcfbcb1&language=en-US"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL))!
        let request = URLRequest(url: url)
        return request
    }
}

class ApiManager {
    static let shared = ApiManager()
    
    func getTrandingMovies(complition: @escaping (TrandingMovies) -> Void) {
        let request = ApiType.getTrandingMovies.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let movies = try? JSONDecoder().decode(TrandingMovies.self, from: data) {
                complition(movies)
            }
        }
        task.resume()
    }
    
    func getTrandingShows(complition: @escaping (TrandingMovies) -> Void) {
        let request = ApiType.getTrandingShows.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let shows = try? JSONDecoder().decode(TrandingMovies.self, from: data) {
                complition(shows)
            }
        }
        task.resume()
    }
   
    func searchMovie(search: String, complition: @escaping (TrandingMovies) -> Void) {
        let request = ApiType.searchMovie(search: search).request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let searchMovieResult = try? JSONDecoder().decode(TrandingMovies.self, from: data) {
                complition(searchMovieResult)
            }
        }
        task.resume()
    }
   
    func searchShow(search: String, complition: @escaping (TrandingMovies) -> Void) {
        let request = ApiType.searchTV(search: search).request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let searchShowResult = try? JSONDecoder().decode(TrandingMovies.self, from: data) {
                complition(searchShowResult)
            }
        }
        task.resume()
    }
   
    func getMovieTrailer(movieID: Int, complition: @escaping (movieTrailerModel) -> Void) {
        let request = ApiType.getMovieTrailer(movieID: movieID).request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let movieTrailer = try? JSONDecoder().decode(movieTrailerModel.self, from: data) {
                complition(movieTrailer)
            }
        }
        task.resume()
    }
  
    func getTVtrailer(TVid: Int, complition: @escaping (movieTrailerModel) -> Void) {
        let request = ApiType.getTVtrailer(TVid: TVid).request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let TVTrailer = try? JSONDecoder().decode(movieTrailerModel.self, from: data) {
                complition(TVTrailer)
            }
        }
        task.resume()
    }
}
