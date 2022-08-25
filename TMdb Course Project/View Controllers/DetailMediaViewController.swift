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
    var mediaDeleteFromRealm: Media?
    var isFromNetwork: Bool?
    var filmName = ""
    var filmDescription = ""
    var filmPoster = URL(string: "")
    var filmData = ""
    var filmRating = ""
    var filmTrailer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToWatchLaterListButton.titleLabel?.text = "Remove"
        setupColors()
        setupContent()
        setupButton()
        //View with media trailer
        playerView.load(withVideoId: filmTrailer, playerVars: ["playinline":1])
        
    }
    
    func setupColors() {
        self.view.backgroundColor = ViewController().blueBackgroundColor
        scrollContentView.backgroundColor = ViewController().blueBackgroundColor
        navigationController?.navigationBar.backgroundColor = ViewController().blueHeaderColor
    }
    func setupContent() {
        self.filmNameLabel.text = filmName
        self.filmDescriptionLabel.text = filmDescription
        self.mediaRetingLabel.text = filmRating
        self.mediaReleaseDataLabel.text = filmData
        self.playerView.load(withVideoId: filmTrailer)
        self.filmPosterImage.sd_setImage(with: filmPoster)
        filmPosterImage.layer.cornerRadius = 32
    }
    func setupButton() {
        if isFromNetwork == false {
            addToWatchLaterListButton.titleLabel?.text = "Remove from watch list"
        }
    }
    //MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //Save media to watch later list
        switch isFromNetwork {
        case true: if let movie = mediaRealm {
            DataManager().saveMedia(with: mediaRealm)
            //Create alert when film saved
            if mediaRealm?.mediaType?.rawValue == Optional("movie") {
                let alertController = UIAlertController(title: "Saved", message: "You have successfully saved the movie", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in }
                alertController.addAction(action)
                //Show alert
                present(alertController, animated: true)
            } else {
                let alertController = UIAlertController(title: "Saved", message: "You have successfully saved TV", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { _ in }
                alertController.addAction(action)
                //Show alert
                present(alertController, animated: true)
            }
        }
        case false:
            DataManager().deleteMedia(toDelete: mediaDeleteFromRealm!)
            let alertController = UIAlertController(title: "Deleted", message: "You have successfully delete from watch list", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(action)
            //Show alert
            present(alertController, animated: true)
        default:
            break
        }
    }
}



