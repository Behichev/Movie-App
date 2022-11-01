//
//  SearchViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 21.07.2022.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    //MARK: - Data
    let searchController = UISearchController()
    var searchResult: [Media] = []
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    //MARK: - Functions
    private func setupUI() {
        //register Protocols
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //Setup Search Controller
        navigationItem.searchController = searchController
        searchController.searchBar.tintColor = UIColor(.yellow)
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                                              attributes: [NSAttributedString.Key.foregroundColor : (UIColor.lightGray)])
        searchController.searchBar.searchTextField.leftView?.tintColor = .lightGray
        //setup Collection View
        searchResultsCollectionView.backgroundColor = Constants.Colors.blueBackgroundColor
        searchResultsCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        
        if let layout = searchResultsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        //Setup Segmanted Control
        searchTypeSegmentedControl.tintColor = Constants.Colors.blueBackgroundColor
        searchTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator],
                                                      for: UIControl.State.normal)
        searchTypeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                      for: UIControl.State.selected)
        searchTypeSegmentedControl.setTitle("Movies", forSegmentAt: 0)
        searchTypeSegmentedControl.setTitle("TV", forSegmentAt: 1)
    }
    
}


