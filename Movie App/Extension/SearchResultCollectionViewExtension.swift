//
//  SearchResultCollectionViewExtension.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 23.07.2022.
//

import Foundation
import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.searchResultIdentifier , for: indexPath) as? SearchResultCollectionViewCell {
            
            let item = searchResult[indexPath.item]
            cell.configureCell(withModel: item)

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let lineSpacing: CGFloat = 8
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let interSpacing: CGFloat = 8
        return interSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColums = 2
        let width = collectionView.frame.width
        let height = UIScreen.main.bounds.height / 2.5
        //for old iPhone models CGFloat(numberOfColums)
        let minInterSpacing: CGFloat = 8
        let widthCell = width / CGFloat(numberOfColums) - collectionView.contentInset.left - collectionView.contentInset.right - minInterSpacing
        let size = CGSize(width: widthCell, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResult[indexPath.row]
        
        if let detailsStoryboard = Constants.storyboardName.instantiateViewController(withIdentifier: Constants.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
           
                guard let posterPath = item.posterPath else { return }
                guard let imageURL: URL = URL(string: Constants.imageURLpath + posterPath) else { return }
                detailsStoryboard.mediaTitle = item.title ?? item.name ?? "No"
                detailsStoryboard.mediaRealmDataInstance = item
                detailsStoryboard.mediaPosterPath = imageURL
                detailsStoryboard.mediaOverviewDescription = item.overview ?? "None"
                detailsStoryboard.mediaReleaseDate = "Release date: " +  ((item.releaseDate ?? item.firstAirDate) ?? "No release date")
                
                if item.voteAverage == 0.0 {
                    detailsStoryboard.mediaRatingGrade = "No ratings yet"
                } else {
                    detailsStoryboard.mediaRatingGrade = "Rating: " + String(describing: Int(item.voteAverage ?? 0)) + "\\10"
                }
                
                switch searchTypeSegmentedControl.selectedSegmentIndex {
                case 0 :
                    ApiManager.shared.getMovieTrailer(movieID: item.id ?? 0) { trailer in
                        detailsStoryboard.mediaTrailerID = trailer.results?.first?.key ?? ""
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                        }
                    }
                case 1:
                    ApiManager.shared.getTVtrailer(TVid: item.id ?? 0) { trailer in
                        detailsStoryboard.mediaTrailerID = trailer.results?.first?.key ?? ""
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(detailsStoryboard, animated: true)
                        }
                    }
                default:
                    break
                }
            
        }
    }
}

