//
//  DetailViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit
import CoreData
import Brightroom

protocol DetailViewControllerProtocol {
    func starButtonTapped()
}

class DetailViewController: UIViewController {

    // MARK: - Properties and variables
    
    var delegate: DetailViewControllerProtocol?
    
    var photo: Photo
    
    lazy var detailView = DetailView()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isStarred = false {
        
        didSet {
            if isStarred {
                DispatchQueue.main.async {
                    self.detailView.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.detailView.starButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        }
    }
    
    // MARK: - Initialization
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = detailView
        PhotosModel.shared.delegate.append(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .pageSheet
        self.setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        // Check if image is in CoreData or in cache and set it
        if let imageData = self.photo.imageData {
            self.detailView.photoImage.image = UIImage(data: imageData)
        }
        else {
            self.detailView.photoImage.image = ImageCacheService.getImage(url: self.photo.urls.small)
        }
        self.detailView.nameLabel.text = "Autor: \(self.photo.user.name)"
        
        // Set labels of detailed view
        let dateString = self.photo.created_at
        let formattedDate = dateString[..<dateString.firstIndex(of: "T")!].replacingOccurrences(of: "-", with: "/")
        self.detailView.dateLabel.text = "Date: \(formattedDate)"

        self.detailView.locationLabel.text = "Location: \(self.photo.location?.name ?? "Unknown")"
        self.detailView.downloadsLabel.text = "Downloads: \(String(self.photo.downloads ?? 0))"
        
        // Check if there is location and downloads and ask model to get data if not
        if self.photo.location?.name == nil || self.photo.downloads == nil {
            
            PhotosModel.shared.getPhotoDetailed(id: self.photo.id)
        }
        else {
            self.detailView.starButton.isUserInteractionEnabled = true
        }
        
        // Set action for star button
        self.detailView.starButton.addAction(UIAction(handler: { _ in
            self.starredHandle()
        }), for: .touchUpInside)
        
        // Set action for crop button
        self.detailView.cropButton.addTarget(self, action: #selector(press), for: .touchUpInside)
    }
    
    private func starredHandle() {
        
        if isStarred {
            
            // Delete from Core Data
            let fetchRequest = StarredPhoto.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id LIKE %@", self.photo.id)
            
            if let photoToDelete = try? self.context.fetch(fetchRequest) {
                
                self.context.delete(photoToDelete.first!)
            }
            
            self.isStarred.toggle()
        }
        else {
            
            // Add to Core Data
            let photo = StarredPhoto(context: self.context)
            photo.id = self.photo.id
            photo.created_at = self.photo.created_at
            photo.authorName = self.photo.user.name
            photo.location = self.photo.location?.name ?? "Unknown"
            photo.downloads = Int64(self.photo.downloads ?? 0)
            photo.photoURL = self.photo.urls.small
            
            let imageData = self.detailView.photoImage.image?.jpegData(compressionQuality: 1)
            photo.imageData = imageData
            
            do {
                try self.context.save()
            }
            catch {
                print("Couldn't save photo to CoreData")
                print(error)
            }
            
            self.isStarred.toggle()
        }
        
        self.delegate?.starButtonTapped()
    }
    
    // MARK: - Brightroom Methods
    @objc
    private func press() {
        
        let image = self.detailView.photoImage.image
        let imageProvider = ImageProvider(image: image ?? UIImage())
        let controller = PhotosCropViewController(imageProvider: imageProvider)
        controller.handlers.didCancel = { controller in
            controller.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Photo Model Delegate Methods

extension DetailViewController: PhotosModelProtocol {
    
    func photosRetrieved() {
        
    }
    
    func photoByIdRetrieved(photo: Photo) {
        
        self.photo = photo
        
        if let location = photo.location!.name {
            
            DispatchQueue.main.async {
                self.detailView.locationLabel.text = "Location: \(location)"
            }
        }
        
        if let downloads = photo.downloads {

            DispatchQueue.main.async {
                self.detailView.downloadsLabel.text = "Downloads: \(String(downloads))"
            }
        }
        
        // Check if current photo is in CoreData
        do {
            
            let fetchRequest = StarredPhoto.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id LIKE %@", self.photo.id)
            
            let photo = try self.context.fetch(fetchRequest)
                
            if photo.count != 0 {
                
                self.isStarred = true
                
            }
        }
        catch {
            print("Couldn't fetch data")
        }
        
        self.detailView.starButton.isUserInteractionEnabled = true
    }
}
