//
//  SearchResultCollectionViewCell.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 23.07.2022.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    //MARK: Configure Movie
    func configure(withModelMovie movie: Result) {
        self.movieNameLabel.text = movie.title
        self.mediaTypeLabel.text = movie.overview
        guard let posterPath = movie.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        moviePoster.sd_setImage(with: imageURL)
        moviePoster.layer.cornerRadius = 24
    }
    //MARK: Configure TV
    func configure(withModelShow show: Result) {
        self.movieNameLabel.text = show.name
        self.mediaTypeLabel.text = show.overview
        guard let posterPath = show.posterPath else { return }
        guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
        moviePoster.sd_setImage(with: imageURL)
        moviePoster.layer.cornerRadius = 24
    }
    override func prepareForReuse() {
        self.movieNameLabel.text = nil
        self.moviePoster.image = nil
    }
}
