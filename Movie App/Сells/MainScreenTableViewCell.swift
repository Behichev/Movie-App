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
    @IBOutlet weak var mediaPosterImageView: UIImageView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDataLabel: UILabel!
    @IBOutlet weak var mediaRatingGradeLabel: UILabel!
    @IBOutlet weak var mainContentViewBackground: UIView!
    @IBOutlet weak var backgroundViewCell: UIView!
    @IBOutlet weak var mediaOverviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    //MARK: DB Movie Cell
    func configureCell(withModelDB dbFile: Media) {
        self.mediaTitleLabel.text = dbFile.name
        self.movieReleaseDataLabel.text = "Release date: " + dbFile.releaseDate
        if dbFile.rating == 0.0 {
            self.mediaRatingGradeLabel.text = "No ratings yet"
        } else {
            self.mediaRatingGradeLabel.text = "Rating: " + String(describing: Int(dbFile.rating)) + "\\10"
        }
        self.mediaOverviewLabel.text = dbFile.mediaDescription
        let posterPath = dbFile.posterPath
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        mediaPosterImageView.sd_setImage(with: imageURL)
        mediaPosterImageView.layer.cornerRadius = 8
    }
    //MARK: Movie Table Cell
    func configureCell(withModel model: Result) {
        self.mediaTitleLabel.text = model.title
        
        if model.releaseDate != nil {
            guard let releaseDate = model.releaseDate else { return }
            self.movieReleaseDataLabel.text = "Release date: " + releaseDate
        } else if model.firstAirDate != nil {
            guard let firsAirDate = model.firstAirDate else { return }
            self.movieReleaseDataLabel.text = "First air date: " + firsAirDate
        } else {
            self.movieReleaseDataLabel.text = "No release date information"
        }
        
        if model.voteAverage == 0.0 {
            self.mediaRatingGradeLabel.text = "No ratings yet"
        } else {
            self.mediaRatingGradeLabel.text = "Rating: " + String(describing: Int(model.voteAverage ?? 0)) + "\\10"
        }
        self.mediaOverviewLabel.text = model.overview
        guard let posterPath = model.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        mediaPosterImageView.sd_setImage(with: imageURL)
        mediaPosterImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        self.mediaTitleLabel.text = nil
        self.mediaPosterImageView.image = nil
        self.movieReleaseDataLabel.text = nil
        self.mediaRatingGradeLabel.text = nil
        self.mediaOverviewLabel.text = nil
    }
    
    private func setupUI() {
        mainContentViewBackground.backgroundColor = Constants.Colors.blueBackgroundColor
        backgroundViewCell.layer.cornerRadius = 16
    }
}





