//
//  WatchLaterViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 30.07.2022.
//

import UIKit

class WatchLaterViewController: UIViewController {
    //MARK: - Data
    var moviesArray: [DatabaseMediaModel] = []
    //MARK: - Outlets
    @IBOutlet weak var wacthLaterEmptyPlugVIew: UIView!
    @IBOutlet weak var watchLaterTableView: UITableView!
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        fetchResult()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchResult()
        updateUI()
    }
    //MARK: - Functions
    func fetchResult() {
        moviesArray = RealmDataManager().getMedia()
        watchLaterTableView.reloadData()
    }
    
    private func setupUI() {
        //register protocols
        watchLaterTableView.delegate = self
        watchLaterTableView.dataSource = self
        //setup colors
        view.backgroundColor = Constants.Colors.blueBackgroundColor
        watchLaterTableView.separatorStyle = .none
        watchLaterTableView.backgroundColor = Constants.Colors.blueBackgroundColor
        watchLaterTableView.showsVerticalScrollIndicator = false
    }
    func updateUI() {
        if moviesArray.isEmpty {
            wacthLaterEmptyPlugVIew.isHidden = false
        } else {
            wacthLaterEmptyPlugVIew.isHidden = true
        }
    }

}


