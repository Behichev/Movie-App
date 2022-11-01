//
//  MainScreenTableViewExtension.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 03.07.2022.
//

import Foundation
import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(Constants.mainScreenTableViewCellNib, forCellReuseIdentifier: Constants.mainScreenTableViewCellIdentifier)
        
        if let cell  = tableView.dequeueReusableCell(withIdentifier: Constants.mainScreenTableViewCellIdentifier)
            as? MainScreenTableViewCell {
            
            let item = arrayMovies[indexPath.row]
            cell.configureCell(withModel: item)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = arrayMovies[indexPath.row]
        
        if let detailsStoryboard = Constants.storyboardName.instantiateViewController(withIdentifier: Constants.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
            
            guard let posterPath = item.posterPath else { return }
            guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
            
            detailsStoryboard.mediaPosterPath = imageURL
            detailsStoryboard.mediaOverviewDescription = item.overview ?? "None"
            detailsStoryboard.mediaRealmDataInstance = item
            detailsStoryboard.mediaTitle = item.name ?? item.title ?? "None"
            detailsStoryboard.mediaReleaseDate = "Release date: " + ((item.releaseDate ?? item.firstAirDate) ?? "No release date")
            
            if item.voteAverage == 0.0 {
                detailsStoryboard.mediaRatingGrade = "No ratings yet"
            } else {
                detailsStoryboard.mediaRatingGrade = "Rating: " + String(describing: Int(item.voteAverage ?? 0)) + "\\10"
            }
            
            switch segmentedControl.selectedSegmentIndex {
            case 0 :
                ApiManager.shared.getMovieTrailer(movieID: item.id ?? 0) { trailer in
                    detailsStoryboard.mediaTrailerID = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            case 1:
                ApiManager.shared.getTVtrailer(TVid: item.id ?? 0) { trailer in
                    detailsStoryboard.mediaTrailerID = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            default:
                break
            }
            
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


