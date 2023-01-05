//
//  ViewController.swift
//  TMdb Course Project
//
//  Created by Иван Бегичев on 28.06.2022.
//

import UIKit

final class TrandigMediaViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var trandigMediaTableView: UITableView!
    @IBOutlet weak private var navBar: UINavigationItem!
    
    //MARK: - Variables
    
    private var arrayOfMedia: [Media] = []
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trandigMediaTableView.delegate = self
        trandigMediaTableView.dataSource = self
        setupInterface()
        networkRequest()
    }
    
    //MARK: - Functions
    
    private func networkRequest() {
        ApiManager.shared.getTrandingMovies { show in
            if let result = show.results {
                self.arrayOfMedia = result
            }
            DispatchQueue.main.async {
                self.trandigMediaTableView.reloadData()
            }
        }
    }
    
    private func setupInterface() {
        view.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        trandigMediaTableView.separatorStyle = .none
        trandigMediaTableView.backgroundColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        trandigMediaTableView.showsVerticalScrollIndicator = false
        segmentedControl.tintColor = AppConstants.Design.Color.Primary.blueBackgroundColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.opaqueSeparator],
                                                for: UIControl.State.normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                                for: UIControl.State.selected)
        segmentedControl.setTitle("Movies", forSegmentAt: 0)
        segmentedControl.setTitle("TV", forSegmentAt: 1)
    }
    
    //MARK: - Actions
    
    @IBAction private func WhenSelected(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if arrayOfMedia.isEmpty || arrayOfMedia.first?.mediaType == .tv {
                ApiManager.shared.getTrandingMovies { show in
                    self.arrayOfMedia = show.results ?? []
                    DispatchQueue.main.async {
                        self.trandigMediaTableView.reloadData()
                    }
                }
            }
        case 1:
            if arrayOfMedia.isEmpty || arrayOfMedia.first?.mediaType == .movie {
                ApiManager.shared.getTrandingShows { show in
                    self.arrayOfMedia = show.results ?? []
                    DispatchQueue.main.async {
                        self.trandigMediaTableView.reloadData()
                    }
                }
            }
        default:
            break
        }
    }
}

//MARK: - UITableView Data Source

extension TrandigMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(AppConstants.Identifiers.mainScreenTableViewCellNib, forCellReuseIdentifier: AppConstants.Identifiers.mainScreenTableViewCellIdentifier)
        if let cell  = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.mainScreenTableViewCellIdentifier)
            as? MainScreenTableViewCell {
            let item = arrayOfMedia[indexPath.row]
            let configuration = MainScreenCellConfiguration(title: (item.title ?? item.name) ?? "", releaseDate: item.releaseDate ?? "", mediaRating: String(describing: Int(item.voteAverage ?? 0)), mediaDescription: item.overview ?? "", posterPathURL: item.posterPath ?? "", mediaType: item.mediaType ?? MediaType.movie)
            cell.configure(with: configuration)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = arrayOfMedia[indexPath.row]
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
            DispatchQueue.main.async {
                detailsStoryboard.configure(witch: configuration)
                self.navigationController?.pushViewController(detailsStoryboard, animated: true)
            }
        }
    }
}

//MARK: - UITableView Delegate

extension TrandigMediaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
