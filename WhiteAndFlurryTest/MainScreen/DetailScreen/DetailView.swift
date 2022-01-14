//
//  DetailView.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

class DetailView: UIView {

    // MARK: - Properties and variables
    
    var photoImage: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFit
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var nameLabel: UILabel = {
        let result = UILabel()
        result.text = "Authors Name: "
        result.textAlignment = .left
        result.font = UIFont.boldSystemFont(ofSize: 20)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var dateLabel: UILabel = {
        let result = UILabel()
        result.text = "Date: "
        result.textAlignment = .left
        result.font = UIFont.boldSystemFont(ofSize: 15)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var locationLabel: UILabel = {
        let result = UILabel()
        result.text = "Location: "
        result.textAlignment = .left
        result.font = UIFont.systemFont(ofSize: 15)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var downloadsLabel: UILabel = {
        let result = UILabel()
        result.text = "Downloads: "
        result.textAlignment = .left
        result.font = UIFont.systemFont(ofSize: 15)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var starButton: UIButton = {
        let result = UIButton()
        result.setImage(UIImage(systemName: "star"), for: .normal)
        result.tintColor = .red
        result.backgroundColor = .clear
        result.isUserInteractionEnabled = false
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let cropButton: UIButton = {
        let result = UIButton()
        result.setImage(UIImage(systemName: "crop"), for: .normal)
        result.tintColor = .white
        result.backgroundColor = .blue
        result.layer.cornerRadius = 25
        result.clipsToBounds = true
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: CGRect())
        
        self.customizeView()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
    private func customizeView() {
        self.backgroundColor = .white
    }
    
    private func setConstraints() {
        
        [photoImage, nameLabel, dateLabel, locationLabel, downloadsLabel, starButton, cropButton].forEach{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            photoImage.widthAnchor.constraint(equalTo: self.widthAnchor),
            photoImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
            photoImage.topAnchor.constraint(equalTo: self.topAnchor),
            photoImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.topAnchor.constraint(equalTo: self.photoImage.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dateLabel.heightAnchor.constraint(equalToConstant: 50),
            dateLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
            dateLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            locationLabel.heightAnchor.constraint(equalToConstant: 50),
            locationLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor),
            locationLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            downloadsLabel.heightAnchor.constraint(equalToConstant: 50),
            downloadsLabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor),
            downloadsLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            downloadsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            starButton.widthAnchor.constraint(equalToConstant: 50),
            starButton.heightAnchor.constraint(equalToConstant: 50),
            starButton.centerYAnchor.constraint(equalTo: self.nameLabel.centerYAnchor),
            starButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            cropButton.widthAnchor.constraint(equalToConstant: 50),
            cropButton.heightAnchor.constraint(equalToConstant: 50),
            cropButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            cropButton.centerYAnchor.constraint(equalTo: self.downloadsLabel.centerYAnchor)
        ])
    }
}
