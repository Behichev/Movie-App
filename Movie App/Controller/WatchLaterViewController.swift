//
//  WatchLaterViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 30.07.2022.
//

import UIKit

class WatchLaterViewController: UIViewController {
    //MARK: - Data
    var moviesArray: [Media] = []
    //MARK: - Outlets
    @IBOutlet weak var watchLaterTableView: UITableView!
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchResult()
    }
    //MARK: - Functions
    func fetchResult() {
        moviesArray = DataManager().getMedia()
        watchLaterTableView.reloadData()
    }
    
    private func setupInterface() {
        //register protocols
        watchLaterTableView.delegate = self
        watchLaterTableView.dataSource = self
        //setup colors
        view.backgroundColor = Constants.Colors.blueBackgroundColor
        watchLaterTableView.separatorStyle = .none
        watchLaterTableView.backgroundColor = Constants.Colors.blueBackgroundColor
        watchLaterTableView.showsVerticalScrollIndicator = false
    }
}


