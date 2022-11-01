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
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var mediaReleaseDataLabel: UILabel!
    @IBOutlet weak var mediaRetingLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var filmDescriptionLabel: UILabel!
    @IBOutlet weak var addToWatchLaterListButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    
    var mediaRealmDataInstance: Media?
    var mediaTitle = ""
    var mediaOverviewDescription = ""
    var mediaPosterPath = URL(string: "")
    var mediaReleaseDate = ""
    var mediaRatingGrade = ""
    var mediaTrailerID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
        playerView.load(withVideoId: mediaTrailerID, playerVars: ["playinline":1])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButton()
    }
    
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        let objects = DataManager().getMedia()
        
        if objects.isEmpty {
            saveMedia()
        } else if addToWatchLaterListButton.titleLabel?.text == "Remove" {
            deleteMedia()
        } else {
            for object in objects {
                if object.name == mediaTitle {
                    showAlreadySavedAlert()
                } else {
                    saveMedia()
                }
            }
        }
        
    }
    //MARK: - Functions
    func showSaveMediaAlert() {
        let alert = UIAlertController(title: "Saved", message: "You have successfully saved to your watch later list", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showDeletedAlert() {
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
        if let movie = mediaRealmDataInstance {
            DataManager().saveMedia(with: movie)
        showSaveMediaAlert()
        }
    }
    
    func deleteMedia() {
        let objects = DataManager().getMedia()
        for object in objects {
            if object.name == mediaTitle {
                DataManager().deleteMedia(object: object)
            }
            showDeletedAlert()
        }
    }
    
    private func setupButton() {
        let movies = DataManager().getMedia()
        
        for movie in movies {
            if movie.name == mediaTitle {
                addToWatchLaterListButton.titleLabel?.text = "Remove"
            }
            
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = Constants.Colors.blueBackgroundColor
        scrollContentView.backgroundColor = Constants.Colors.blueBackgroundColor
        navigationController?.navigationBar.backgroundColor = Constants.Colors.blueHeaderColor
    }
    
    private func setupContent() {
        self.filmTitleLabel.text = mediaTitle
        self.filmDescriptionLabel.text = mediaOverviewDescription
        self.mediaRetingLabel.text = mediaRatingGrade
        self.mediaReleaseDataLabel.text = mediaReleaseDate
        self.playerView.load(withVideoId: mediaTrailerID)
        self.filmPosterImage.sd_setImage(with: mediaPosterPath)
        filmPosterImage.layer.cornerRadius = 32
    }
    
}
