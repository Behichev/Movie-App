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
    @IBOutlet weak private var mediaTypeLabel: UILabel!
    
    private var cacheManager = CacheManager()
    //MARK: - Functions

    func configureCell(withModel model: Media) {
        self.movieNameLabel.text = model.title ?? model.name
        self.mediaTypeLabel.text = model.overview
        guard let posterPath = model.posterPath else { return }
        guard let imageURL: URL = URL(string: AppConstants.API.imageURLpath + posterPath) else { return }
        cacheManager.downloadImage(url: imageURL) { image in
            self.moviePoster.image = image
        }
        moviePoster.layer.cornerRadius = 24
    }
    
    override func prepareForReuse() {
        self.movieNameLabel.text = nil
        self.moviePoster.image = nil
        self.mediaTypeLabel.text = nil
    }
}
