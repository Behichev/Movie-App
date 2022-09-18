//
//  MainScreenTableViewCell.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 03.07.2022.
//

import UIKit
import SDWebImage

class MainScreenTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var showPosterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDataLabel: UILabel!
    @IBOutlet weak var ratingMediaLabel: UILabel!
    @IBOutlet weak var mainContentViewBackground: UIView!
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var mediaOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainContentViewBackground.backgroundColor = Constants.Colors.blueBackgroundColor
        backgroundViewCell.layer.cornerRadius = 16
    }
    //MARK: DB Movie Cell
    func configure(withModelDB dbFile: Media) {
        self.movieNameLabel.text = dbFile.name
        self.movieDataLabel.text = "Release date: " + dbFile.releaseDate
        if dbFile.rating == 0.0 {
            self.ratingMediaLabel.text = "No ratings yet"
        } else {
            self.ratingMediaLabel.text = "Rating: " + String(describing: Int(dbFile.rating)) + "\\10"
        }
        self.mediaOverviewLabel.text = dbFile.mediaDescription
        let posterPath = dbFile.posterPath
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        showPosterImageView.sd_setImage(with: imageURL)
        showPosterImageView.layer.cornerRadius = 8
    }
    //MARK: Movie Table Cell
    func configure(withModelMovie movie: Result) {
        self.movieNameLabel.text = movie.title
        self.movieDataLabel.text = "Realese date: " + (movie.releaseDate ?? "No data")
        
        if movie.voteAverage == 0.0 {
            self.ratingMediaLabel.text = "No ratings yet"
        } else {
            self.ratingMediaLabel.text = "Rating: " + String(describing: Int(movie.voteAverage ?? 0)) + "\\10"
        }
        self.mediaOverviewLabel.text = movie.overview
        guard let posterPath = movie.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        showPosterImageView.sd_setImage(with: imageURL)
        showPosterImageView.layer.cornerRadius = 8
    }
    //MARK: TV Table Cell
    func configure(withModelShow show: Result) {
        self.movieNameLabel.text = show.name
        self.movieDataLabel.text = "First air date: " + (show.firstAirDate ?? "No data")
        if show.voteAverage == 0.0 {
            self.ratingMediaLabel.text = "No ratings yet"
        } else {
            self.ratingMediaLabel.text = "Rating: " + String(describing: Int(show.voteAverage ?? 0)) + "\\10"
        }
        self.mediaOverviewLabel.text = show.overview
        guard let posterPath = show.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        showPosterImageView.sd_setImage(with: imageURL)
        showPosterImageView.layer.cornerRadius = 8
    }
    override func prepareForReuse() {
        self.movieNameLabel.text = nil
        self.showPosterImageView.image = nil
        self.movieDataLabel.text = nil
        self.ratingMediaLabel.text = nil
        self.mediaOverviewLabel.text = nil
    }
}





