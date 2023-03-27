//
//  SearchResultCollectionViewCell.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 23.07.2022.
//

import UIKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak private var moviePoster: UIImageView!
    @IBOutlet weak private var movieNameLabel: UILabel!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var mediaTypeLabel: UILabel!
    //MARK: - Properties
    private var cacheManager = CacheManager()
    private var id: Int?
    //MARK: - Functions
    func configureCell(withModel model: Media) {
        id = model.id
        self.movieNameLabel.text = model.title ?? model.name
        self.mediaTypeLabel.text = model.overview
        guard let posterPath = model.posterPath else { return }
        guard let imageURL: URL = URL(string: AppConstants.API.imageURLpath + posterPath) else { return }
        cacheManager.downloadImage(url: imageURL) { [weak self] image in
            if self?.id == model.id {
                DispatchQueue.main.async {
                    self?.moviePoster.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        moviePoster.layer.cornerRadius = 24
    }
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
        self.movieNameLabel.text = nil
        self.moviePoster.image = nil
        self.mediaTypeLabel.text = nil
    }
}
