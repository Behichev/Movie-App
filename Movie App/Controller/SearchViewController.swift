//
//  SearchViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 21.07.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak private var searchTypeSegmentedControl: UISegmentedControl!
    
    //MARK: - Variables
    
    private var searchResult: [Media] = []
    private let searchController = UISearchController()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Functions
    
    private func setupUI() {
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = UIColor(.yellow)
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                                              attributes: [NSAttributedString.Key.foregroundColor : (UIColor.lightGray)])
        searchController.searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchResultsCollectionView.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        searchResultsCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        
        if let layout = searchResultsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        searchTypeSegmentedControl.tintColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        searchTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator],
                                                          for: UIControl.State.normal)
        searchTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                          for: UIControl.State.selected)
        searchTypeSegmentedControl.setTitle("Movies", forSegmentAt: 0)
        searchTypeSegmentedControl.setTitle("TV", forSegmentAt: 1)
    }
    
}


//MARK: - UICollectionView Data Source

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Identifiers.searchResultIdentifier , for: indexPath) as? SearchResultCollectionViewCell {
            let item = searchResult[indexPath.item]
            cell.configureCell(withModel: item)
            
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionView Delegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = searchResult[indexPath.row]
        
        if let detailsStoryboard = AppConstants.Identifiers.storyboardName.instantiateViewController(withIdentifier: AppConstants.Identifiers.detailViewContrillerIdentifier) as?
            DetailMediaViewController {
            guard let posterPath = item.posterPath else { return }
            guard let imageURL: URL = URL(string: AppConstants.API.imageURLpath + posterPath) else { return }
            var mediaTrailer = ""
            
            if item.mediaType == .movie {
                ApiManager.shared.getMovieTrailer(movieID: item.id ?? 0) { trailer in
                    mediaTrailer = trailer.results?.first?.key ?? ""
                }
            } else {
                ApiManager.shared.getTVtrailer(TVid: item.id ?? 0) { trailer in
                    mediaTrailer = trailer.results?.first?.key ?? ""
                }
            }
            let configuration = DetailsScreenConfiguration(mediaRealmDataInstance: item,
                                                           mediaTitle: item.name ?? item.title ?? "None",
                                                           mediaOverviewDescription: item.overview ?? "None",
                                                           mediaPosterPath: imageURL,
                                                           mediaReleaseDate: (item.releaseDate ?? item.firstAirDate) ?? "",
                                                           mediaRatingGrade: (String(describing: Int(item.voteAverage ?? 0))),
                                                           mediaTrailerID: mediaTrailer, mediaType: item.mediaType ?? .movie)
            detailsStoryboard.configure(witch: configuration)
            self.navigationController?.pushViewController(detailsStoryboard, animated: true)
        }
    }
}

//MARK: - UICollectionView Delegate Flow Layout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
}

//MARK: - UISearchController Delegate

extension SearchViewController: UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        if searchTypeSegmentedControl.selectedSegmentIndex == 0 {
            ApiManager.shared.searchMovie(search: text.replacingOccurrences(of: " ", with: "%20")) { TrandingMovies in
                self.searchResult = TrandingMovies.results ?? []
                DispatchQueue.main.async {
                    self.searchResultsCollectionView.reloadData()
                }
            }
        } else {
            ApiManager.shared.searchShow(search: text.replacingOccurrences(of: " ", with: "%20")) { TrandingMovies in
                self.searchResult = TrandingMovies.results ?? []
                DispatchQueue.main.async {
                    self.searchResultsCollectionView.reloadData()
                }
            }
        }
    }
}

//MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
