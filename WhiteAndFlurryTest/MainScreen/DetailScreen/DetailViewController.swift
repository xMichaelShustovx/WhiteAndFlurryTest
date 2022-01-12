//
//  DetailViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Properties and variables
    
    var photo: Photo
    
    lazy var detailView = DetailView()
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .pageSheet
        self.setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        self.detailView.photoImage.image = ImageCacheService.getImage(url: self.photo.urls.small)
        self.detailView.nameLabel.text = "Autor: \(self.photo.user.name)"
        
        let dateString = self.photo.created_at
        let formattedDate = dateString[..<dateString.firstIndex(of: "T")!].replacingOccurrences(of: "-", with: "/")
        self.detailView.dateLabel.text = "Date: \(formattedDate)"
        
        self.detailView.locationLabel.text = "Location: \(self.photo.location?.name ?? "Unknown")"
        self.detailView.downloadsLabel.text = "Downloads: \(String(self.photo.downloads ?? 0))"
        
        self.detailView.starButton.addAction(UIAction(handler: { _ in
            self.starredHandle()
        }), for: .touchUpInside)
    }
    
    private func starredHandle() {
        
        
    }
}
