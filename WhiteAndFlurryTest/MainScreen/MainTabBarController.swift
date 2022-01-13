//
//  MainTabBarController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties and variables
    
    let model = PhotosModel.shared
    
    var feedVC: FeedViewController?
    var favouredPhotosVC: FavouredPhotosViewController?
    
    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()

        self.model.getPhotos()
        
        self.feedVC = FeedViewController()
        self.favouredPhotosVC = FavouredPhotosViewController()

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
    
    func photosRetrieved() {
        
//        self.feedVC?.photos = photos
//        self.feedVC?.collectionView?.reloadData()
//        
//        self.favouredPhotosVC?.starredPhotos = photos
//        self.favouredPhotosVC?.tableView.reloadData()
    }
    
    func photoByIdRetrieved(photo: Photo) {
        
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
