//
//  DetailMediaViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 19.07.2022.
//

import UIKit

final class DetailMediaViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var filmPosterImage: UIImageView!
    @IBOutlet weak private var filmTitleLabel: UILabel!
    @IBOutlet weak private var mediaReleaseDataLabel: UILabel!
    @IBOutlet weak private var mediaRetingLabel: UILabel!
    @IBOutlet weak private var filmDescriptionLabel: UILabel!
    @IBOutlet weak private var addToWatchLaterListButton: UIButton!
    @IBOutlet weak private var scrollContentView: UIView!
    
    //MARK: - Variables
    
    private var configuration: DetailsScreenConfiguration?
    private var cacheManager = CacheManager()
    private var detailManager = DetailManager()
    
    //MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupContent()
    }
    
    //MARK: - Actions
    
    @IBAction private func saveButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Remove from watch list" {
            if let configuration {
                detailManager.deleteMedia(with: configuration)
                showDeletedAlert()
                sender.setTitle("Add to watch list", for: .normal)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            RealmDataManager.shared.saveMedia(with: configuration?.mediaRealmDataInstance)
            showSaveMediaAlert()
            sender.setTitle("Remove from watch list", for: .normal)
        }
    }
    
    //MARK: - Functions
    
    func configure (witch configuration: DetailsScreenConfiguration) {
        self.configuration = configuration
    }
    
    private func showSaveMediaAlert() {
        let alert = UIAlertController(title: "Saved", message: "You have successfully saved to your watch later list", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showDeletedAlert() {
        let alert = UIAlertController(title: "Deleted", message: "You have successfully delete from watch list", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showAlreadySavedAlert() {
        let alert = UIAlertController(title: "Error", message: "You already saved this item", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func setupUI() {
        let fetchedObject = RealmDataManager.shared.getMedia()
        
        for object in fetchedObject {
            if object.name == configuration?.mediaTitle {
                addToWatchLaterListButton.setTitle("Remove from watch list", for: .normal)
            }
        }
        self.view.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        scrollContentView.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        navigationController?.navigationBar.backgroundColor = AppConstants.Design.Color.Primary.blueHeaderColor
        filmPosterImage.layer.cornerRadius = 32
    }
        
    private func setupContent() {
        if let configuration {
            filmTitleLabel.text = configuration.mediaTitle
            filmDescriptionLabel.text = configuration.mediaOverviewDescription
            mediaRetingLabel.text = "Rating: \(String(describing: configuration.mediaRatingGrade))\\10"
            if configuration.mediaType == .movie {
                mediaReleaseDataLabel.text = "Release date: \(String(describing: configuration.mediaReleaseDate))"
            } else {
                mediaReleaseDataLabel.text = "First air date: \(String(describing: configuration.mediaReleaseDate))"
            }
            cacheManager.downloadImage(url: configuration.mediaPosterPath, complition: { image in
                self.filmPosterImage.image = image
            })
        }
    }
}
