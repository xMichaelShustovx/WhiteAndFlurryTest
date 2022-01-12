//
//  MainTabBarController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties and variables
    
    let model = PhotosModel()
    var photos = [Photo]()
    
    var feedVC: FeedViewController?
    var favouredPhotosVC: FavouredPhotosViewController?
    
    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()

        self.model.delegate = self
        self.model.getPhotos()
        
        self.feedVC = FeedViewController(photos: self.photos)
        self.favouredPhotosVC = FavouredPhotosViewController(photos: self.photos)

        self.feedVC!.title = "Feed"
        self.favouredPhotosVC!.title = "Favoured"
        
        self.feedVC?.searchBar.delegate = self

        self.tabBar.backgroundColor = .white

        self.setViewControllers([feedVC!, favouredPhotosVC!], animated: false)
        
        guard self.tabBar.items?.count == 2 else {
            return
        }
        self.tabBar.items![0].image = UIImage(systemName: "square.grid.2x2")
        self.tabBar.items![1].image = UIImage(systemName: "star")
    }
}

// MARK: - Photo Model Delegate Method

extension MainTabBarController: PhotosModelProtocol {
    
    func photosRetrieved(photos: [Photo]) {
        
        self.photos = photos
        
        self.feedVC?.photos = photos
        self.feedVC?.collectionView?.reloadData()
        
        self.favouredPhotosVC?.starredPhotos = photos
        self.favouredPhotosVC?.tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Method

extension MainTabBarController: SearchBarViewProtocol {
    
    func getUserSearchString(searchString: String) {
        
        if searchString == "" {
            self.model.getPhotos()
            return
        }
        
        self.model.getPhotos(bySearch: searchString)
    }
}
