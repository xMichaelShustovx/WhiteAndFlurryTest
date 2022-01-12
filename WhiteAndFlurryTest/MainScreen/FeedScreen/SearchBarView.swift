//
//  SearchBarView.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

protocol SearchBarViewProtocol {
    
    func getUserSearchString(searchString: String)
}

class SearchBarView: UIView {

    // MARK: - Properties and variables
    
    var delegate: SearchBarViewProtocol?
    
    let bar: UISearchBar = {
        let result = UISearchBar()
        result.placeholder = "Search for..."
        result.backgroundImage = UIImage()
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let findButton: UIButton = {
        let result = UIButton()
        result.setTitle("Find", for: .normal)
        result.setTitleColor(.white, for: .normal)
        result.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        result.backgroundColor = .blue
        result.layer.cornerRadius = 10
        result.clipsToBounds = true
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRect())
        
        self.customizeView()
        self.setConstraints()
        self.setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func customizeView() {
        self.backgroundColor = .white
    }
    
    private func setConstraints() {
        [self.bar, self.findButton].forEach{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            bar.heightAnchor.constraint(equalToConstant: 50),
            bar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bar.leftAnchor.constraint(equalTo: self.leftAnchor),
            bar.rightAnchor.constraint(equalTo: findButton.leftAnchor),
            
            findButton.widthAnchor.constraint(equalToConstant: 80),
            findButton.heightAnchor.constraint(equalToConstant: 36),
            findButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7),
            findButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -7)
        ])
    }
    
    private func setAction() {
        
        self.findButton.addAction(UIAction(handler: { _ in
            
            let searchString = self.bar.text ?? ""
            
            self.delegate?.getUserSearchString(searchString: searchString)
            
        }), for: .touchUpInside)
    }
}
