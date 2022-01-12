//
//  PhotoCollectionViewCell.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties and variables
    
    static let identifier = "PhotoCollectionViewCell"
    
    var photo: Photo?
    
    private var photoImageView: UIImageView = {
        let result = UIImageView()
        result.image = UIImage(systemName: "line.3.crossed.swirl.circle")
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(photoImageView)
        self.contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoImageView.frame = self.contentView.frame
    }
    
    // MARK: - Public Methods
    
    func displayPhoto(photo: Photo) {
        
        // Reset the image
        self.photoImageView.image = UIImage(systemName: "line.3.crossed.swirl.circle")
        
        // Set photo property
        self.photo = photo
        
        // Check if the image is in cache
        if let image = ImageCacheService.getImage(url: photo.urls.small) {
            
            // Use cached image
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
            
            // Skip rest of the code
            return
        }
        
        // Download the image
        let url = URL(string: photo.urls.small)
        
        guard url != nil else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { data, _, error in
            if error == nil && data != nil {
                
                // Check if we downloaded the right image for current cell
                if url!.absoluteString != self.photo?.urls.small {
                    return
                }
                
                // Get the image
                let image = UIImage(data: data!)
                
                // Store the image data in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)
                
                // Set the image view
                DispatchQueue.main.async {

                    self.photoImageView.image = image
                }
            }
        }
        
        // Start the data task
        dataTask.resume()
    }
}
