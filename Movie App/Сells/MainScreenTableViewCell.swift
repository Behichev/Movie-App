//
//  MainScreenTableViewCell.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 03.07.2022.
//

import UIKit

final class MainScreenTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var mediaPosterImageView: UIImageView!
    @IBOutlet weak private var mediaTitleLabel: UILabel!
    @IBOutlet weak private var movieReleaseDataLabel: UILabel!
    @IBOutlet weak private var mediaRatingGradeLabel: UILabel!
    @IBOutlet weak private var mainContentViewBackground: UIView!
    @IBOutlet weak private var backgroundViewCell: UIView!
    @IBOutlet weak private var mediaOverviewLabel: UILabel!
    
    //MARK: - Variables
    
    private var configuration: MainScreenCellConfiguration?
    private var cacheManager = CacheManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: - Functions
    
    func configure(with configuration: MainScreenCellConfiguration) {
        self.configuration = configuration
        mediaTitleLabel.text = configuration.title
        if configuration.mediaType == .movie {
            movieReleaseDataLabel.text = "Release date: \(configuration.releaseDate)"
        } else {
            movieReleaseDataLabel.text = "First air date: \(configuration.releaseDate)"
        }
        mediaRatingGradeLabel.text = "Rating: \(configuration.mediaRating)\\10"
        mediaOverviewLabel.text = configuration.mediaDescription
        if let imageURL = URL(string: AppConstants.API.imageURLpath + (configuration.posterPathURL)) {
            cacheManager.downloadImage(url: imageURL) { image in
                self.mediaPosterImageView.image = image
            }
        }
    }
    
    private func setupUI() {
        mainContentViewBackground.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        backgroundViewCell.layer.cornerRadius = 16
        mediaPosterImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        self.mediaTitleLabel.text = nil
        self.mediaPosterImageView.image = nil
        self.movieReleaseDataLabel.text = nil
        self.mediaRatingGradeLabel.text = nil
        self.mediaOverviewLabel.text = nil
    }
}
