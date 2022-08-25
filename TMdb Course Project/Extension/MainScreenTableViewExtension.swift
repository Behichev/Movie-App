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
        let nib = UINib(nibName: "MainScreenTableViewCell", bundle: nil)
        let identifier = "MainScreenTableViewCell"
        tableView.register(nib, forCellReuseIdentifier: identifier)
        if let cell  = tableView.dequeueReusableCell(withIdentifier: identifier)
            as? MainScreenTableViewCell {
            let item = arrayMovies[indexPath.row]
            
            switch segmentedControl.selectedSegmentIndex {
            case 0 :
                cell.configure(withModelMovie: item)
            case 1:
                cell.configure(withModelShow: item)
            default:
                break
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = arrayMovies[indexPath.row]
        let main = UIStoryboard(name: "Main", bundle: nil)
        let identifier = "DetailViewControllerID"
        if let detailsStoryboard = main.instantiateViewController(withIdentifier: identifier) as?
            DetailMediaViewController {
            let responseURL = "https://image.tmdb.org/t/p/w1280/"
            guard let posterPath = item.posterPath else { return }
            guard let imageURL: URL = URL(string: responseURL + posterPath) else { return }
            
            switch segmentedControl.selectedSegmentIndex {
            case 0 :
                detailsStoryboard.filmName = item.title ?? "None"
                detailsStoryboard.filmDescription = item.overview ?? "None"
                detailsStoryboard.filmPoster = imageURL
                detailsStoryboard.filmData = "Realese date: " + (item.releaseDate ?? "No data")
                detailsStoryboard.isFromNetwork = true
                
                if item.voteAverage == 0.0 {
                    detailsStoryboard.filmRating = "No ratings yet"
                } else {
                    detailsStoryboard.filmRating = "Rating: " + String(describing: Int(item.voteAverage ?? 0)) + "\\10"
                }
                detailsStoryboard.mediaRealm = item
                ApiManager.shared.getMovieTrailer(movieID: item.id ?? 0) { trailer in
                    detailsStoryboard.filmTrailer = trailer.results?.first?.key ?? ""
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                    }
                }
            case 1:
                detailsStoryboard.filmName = item.originalName ?? "None"
                detailsStoryboard.filmDescription = item.overview ?? "None"
                detailsStoryboard.filmData = "Realese date: " + (item.firstAirDate ?? "No data")
                
                if item.voteAverage == 0.0 {
                    detailsStoryboard.filmRating = "No ratings yet"
                } else {
                    detailsStoryboard.filmRating = "Rating: " + String(describing: Int(item.voteAverage ?? 0)) + "\\10"
                }
                detailsStoryboard.mediaRealm = item
                detailsStoryboard.filmPoster = imageURL
                ApiManager.shared.getTVtrailer(TVid: item.id ?? 0) { trailer in
                    detailsStoryboard.filmTrailer = trailer.results?.first?.key ?? ""
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


