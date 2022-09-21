//
//  WatchLaterTableViewExtension.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 30.07.2022.
//

import Foundation
import UIKit


extension WatchLaterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        tableView.register(Constants.mainScreenTableViewCellNib, forCellReuseIdentifier: Constants.mainScreenTableViewCellIdentifier)
        
        if let cell  = tableView.dequeueReusableCell(withIdentifier: Constants.mainScreenTableViewCellIdentifier)
            as? MainScreenTableViewCell {
            let item = moviesArray[indexPath.row]
            cell.configure(withModelDB: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = moviesArray[indexPath.row]
        
        if let detailsStoryboard = Constants.storyboardName.instantiateViewController(withIdentifier: Constants.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
            
            let posterPath = item.posterPath
            guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
            detailsStoryboard.filmName = item.name
            detailsStoryboard.filmDescription = item.mediaDescription
            detailsStoryboard.filmPoster = imageURL
            detailsStoryboard.filmData = "Realese date: " + item.releaseDate

            
            if item.rating == 0.0 {
                detailsStoryboard.filmRating = "No ratings yet"
            } else {
                detailsStoryboard.filmRating = "Rating: " + String(describing: Int(item.rating)) + "\\10"
            }
            
            if item.mediaRaw == MediaType.movie.rawValue {
                ApiManager.shared.getMovieTrailer(movieID: item.id) { trailer in
                    detailsStoryboard.filmTrailer = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            } else {
                ApiManager.shared.getTVtrailer(TVid: item.id) { movieTrailerModel in
                    detailsStoryboard.filmTrailer = movieTrailerModel.results?.first?.key ?? ""
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}



