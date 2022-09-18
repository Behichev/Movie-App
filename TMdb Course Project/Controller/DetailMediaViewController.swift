//
//  DetailMediaViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 19.07.2022.
//

import UIKit
import SDWebImage
import YouTubeiOSPlayerHelper

class DetailMediaViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var filmPosterImage: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    @IBOutlet weak var mediaReleaseDataLabel: UILabel!
    @IBOutlet weak var mediaRetingLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var filmDescriptionLabel: UILabel!
    @IBOutlet weak var addToWatchLaterListButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    
    var mediaRealm: Result?
    var filmName = ""
    var filmDescription = ""
    var filmPoster = URL(string: "")
    var filmData = ""
    var filmRating = ""
    var filmTrailer = ""
    var isFromNetwork: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColors()
        setupContent()
        //View with media trailer
        playerView.load(withVideoId: filmTrailer, playerVars: ["playinline":1])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButton()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        switch isFromNetwork {
        case true:
            saveMedia()
        case false:
            deleteMedia()
        default:
            break
        }
        
    }
    //MARK: - Functions
    func showSaveMovieAlert() {
        let alert = UIAlertController(title: "Saved", message: "You have successfully saved the movie", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showSaveTvAlert() {
        let alert = UIAlertController(title: "Saved", message: "You have successfully saved TV", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(title: "Deleted", message: "You have successfully delete from watch list", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlreadySavedAlert() {
        let alert = UIAlertController(title: "Error", message: "You already saved this item", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func saveMedia() {
        if let movie = mediaRealm {
            DataManager().saveMedia(with: mediaRealm)
            if movie.mediaType?.rawValue == Optional("movie") {
                showSaveMovieAlert()
            } else {
                showSaveTvAlert()
            }
        }
    }
    
    func deleteMedia() {
        let movies = DataManager().getMedia()
        
        for movie in movies {
            if movie.name == filmName {
                DataManager().deleteMedia(toDelete: movie)
                showDeleteAlert()
            }
        }
    }
    
    private func setupButton() {
        let movies = DataManager().getMedia()
        
        for movie in movies {
            if movie.name == filmName && isFromNetwork == false {
                addToWatchLaterListButton.titleLabel?.text = "Remove"
            }
        }
    }
    
    private func setupColors() {
        self.view.backgroundColor = Constants.Colors.blueBackgroundColor
        scrollContentView.backgroundColor = Constants.Colors.blueBackgroundColor
        navigationController?.navigationBar.backgroundColor = Constants.Colors.blueHeaderColor
    }
    
    private func setupContent() {
        self.filmNameLabel.text = filmName
        self.filmDescriptionLabel.text = filmDescription
        self.mediaRetingLabel.text = filmRating
        self.mediaReleaseDataLabel.text = filmData
        self.playerView.load(withVideoId: filmTrailer)
        self.filmPosterImage.sd_setImage(with: filmPoster)
        filmPosterImage.layer.cornerRadius = 32
    }
    
}
