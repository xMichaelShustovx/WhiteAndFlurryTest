//
//  FeedViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class FeedViewController: UIViewController {
 
    // MARK: - Properties and variables
    
    var collectionView: UICollectionView?
    var photos = [Photo]()
    var searchBar = SearchBarView()

    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        PhotosModel.shared.delegate.append(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (self.view.frame.size.width / 3) - 1,
                                 height: (self.view.frame.size.width / 3) - 1)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard collectionView != nil else { return }
        
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        self.view.addSubview(searchBar)
        self.view.addSubview(collectionView!)
        searchBar.frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: 100))
        collectionView?.frame = CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 100))
        
    }
}

// MARK: - Collection View Delegate Methods

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        let currentPhoto = self.photos[indexPath.row]
        cell?.displayPhoto(photo: currentPhoto)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        present(DetailViewController(photo: self.photos[indexPath.row]), animated: true, completion: nil)
    }
    
}

// MARK: PhotoModel Delegate Methods

extension FeedViewController: PhotosModelProtocol {
    
    func photosRetrieved() {
        
        self.photos = PhotosModel.shared.photoArray
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func photoByIdRetrieved(photo: Photo) {
        
    }
}
