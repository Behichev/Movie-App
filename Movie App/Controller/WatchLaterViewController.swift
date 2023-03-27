//
//  WatchLaterViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 30.07.2022.
//

import UIKit

final class WatchLaterViewController: UIViewController {
   
    //MARK: - Outlets
    @IBOutlet weak private var wacthLaterEmptyPlugView: UIView!
    @IBOutlet weak private var watchLaterTableView: UITableView!
  
    //MARK: - Properties
    private var moviesArray: [DatabaseMediaModel] = []
    
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        watchLaterTableView.delegate = self
        watchLaterTableView.dataSource = self
        setupUI()
        updateUI()
        fetchResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchResult()
        updateUI()
    }
    
    //MARK: - Functions
    private func fetchResult() {
        moviesArray = RealmDataManager().getMedia()
        watchLaterTableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        watchLaterTableView.separatorStyle = .none
        watchLaterTableView.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        watchLaterTableView.showsVerticalScrollIndicator = false
    }
    
    private func updateUI() {
        if moviesArray.isEmpty {
            wacthLaterEmptyPlugView.isHidden = false
        } else {
            wacthLaterEmptyPlugView.isHidden = true
        }
    }
}

//MARK: - UITableViewDataSource
extension WatchLaterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(AppConstants.Identifiers.mainScreenTableViewCellNib, forCellReuseIdentifier: AppConstants.Identifiers.mainScreenTableViewCellIdentifier)
        
        if let cell  = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.mainScreenTableViewCellIdentifier)
            as? MainScreenTableViewCell {
            let item = moviesArray[indexPath.row]
            let configuration = MainScreenCellConfiguration(title: item.name, releaseDate: item.releaseDate, mediaRating: String(describing: Int(item.rating)), mediaDescription: item.mediaDescription, posterPathURL: item.posterPath, mediaType: MediaType(rawValue: item.mediaRaw) ?? .movie)
            cell.configure(with: configuration)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailsStoryboard = AppConstants.Identifiers.storyboardName.instantiateViewController(withIdentifier: AppConstants.Identifiers.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
            let item = moviesArray[indexPath.row]
            let posterPath = item.posterPath
            guard let imageURL: URL = URL(string: AppConstants.API.imageURLpath + posterPath) else { return }
            var trailerId = ""
            if item.mediaRaw == MediaType.movie.rawValue {
                ApiManager.shared.getMovieTrailer(movieID: item.id) { trailer in
                    trailerId = trailer.results?.first?.key ?? ""
                }
            } else {
                ApiManager.shared.getTVtrailer(TVid: item.id) { movieTrailerModel in
                    trailerId = movieTrailerModel.results?.first?.key ?? ""
                }
            }
            let configuration = DetailsScreenConfiguration(mediaTitle: item.name, mediaOverviewDescription: item.mediaDescription, mediaPosterPath: imageURL, mediaReleaseDate: item.releaseDate, mediaRatingGrade: String(describing: Int(item.rating)), mediaTrailerID: trailerId, mediaType: MediaType.init(rawValue: item.mediaRaw) ?? .movie)
            detailsStoryboard.configure(witch: configuration)
            self.navigationController?.pushViewController(detailsStoryboard, animated: true)
        }
    }
}

//MARK: - UITableView Delegate
extension WatchLaterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

