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
    
    var photo: StarredPhoto?
    
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
    
    func setupUI(photo: StarredPhoto) {
        
        // Set photo property
        self.photo = photo
        
        // Set authors name
        self.authorLabel.text = photo.authorName
        
        // Set image
        let image = UIImage(data: photo.imageData ?? Data())
        self.photoImage.image = image
    }
}
