//
//  PhotoTableViewCell.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    // MARK: - Properties and variables
    
    static let identifier = "PhotoTableViewCell"
    
    var photo: Photo?
    
    let photoImage: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let authorLabel: UILabel = {
        let result = UILabel()
        result.textAlignment = .left
        result.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(photoImage)
        self.contentView.addSubview(authorLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = self.contentView.frame.size.height
        
        self.authorLabel.frame = CGRect(x: 15,
                                        y: 0,
                                        width: self.contentView.frame.size.width - 15 - imageSize,
                                        height: self.contentView.frame.size.height)
        
        self.photoImage.frame = CGRect(x: self.contentView.frame.size.width - imageSize,
                                       y: 0,
                                       width: imageSize,
                                       height: imageSize)
    }
    
    // MARK: - Public Methods
    
    func setupUI(photo: Photo) {
        
        // Set photo property
        self.photo = photo
        
        // Set authors name
        self.authorLabel.text = photo.user.name
        
        // Check if the image is in cache
        if let image = ImageCacheService.getImage(url: photo.urls.small) {
            
            // Use cached image
            DispatchQueue.main.async {
                self.photoImage.image = image
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

                    self.photoImage.image = image
                }
            }
        }
        
        // Start the data task
        dataTask.resume()
    }
}
