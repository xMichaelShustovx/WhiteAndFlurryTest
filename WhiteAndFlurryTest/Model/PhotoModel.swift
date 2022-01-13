//
//  PhotoModel.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import Foundation

protocol PhotosModelProtocol {
    
    func photosRetrieved()
    
    func photoByIdRetrieved(photo: Photo)
}

class PhotosModel {
    
    // MARK: - Properties and variables
    
    static let shared = PhotosModel()
    
    var delegate = [PhotosModelProtocol]()
    
    var photoArray = [Photo]()
    
    private let key = "md0OYnyRYpRWENPnAu0PiBGwVBUzjGLIx66PrtG1TQ4"
    
    // MARK: - Public Methods
    
    func getPhotos() {

        let url = URL(string: "https://api.unsplash.com/photos/random?count=30")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(self.key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                do {
                    
                    let result = try JSONDecoder().decode([Photo].self, from: data!)
                    
                    PhotosModel.shared.photoArray = result
                    
                    DispatchQueue.main.async {
                        PhotosModel.shared.delegate.forEach { $0.photosRetrieved() }
                    }
                }
                catch {
                    print("Couldn't recieve data")
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    func getPhotos(bySearch: String) {

        let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(bySearch.lowercased())")
        
        guard url != nil else { return }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(self.key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                do {
                    
                    let result = try JSONDecoder().decode(Results.self, from: data!)
                    
                    PhotosModel.shared.photoArray = result.results
                    
                    DispatchQueue.main.async {
                        PhotosModel.shared.delegate.forEach { $0.photosRetrieved() }
                    }
                }
                catch {
                    print("Couldn't recieve data")
                }
            }
        }
        
        dataTask.resume()
        
    }
    
    func getPhotoDetailed(id: String) {
        
        let url = URL(string: "https://api.unsplash.com/photos/\(id)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(self.key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                do {
                    
                    let result = try JSONDecoder().decode(Photo.self, from: data!)
                    
                    DispatchQueue.main.async {
                        PhotosModel.shared.delegate.forEach { $0.photoByIdRetrieved(photo: result) }
                    }
                }
                catch {
                    print("Couldn't recieve single photo data")
                }
            }
        }
        
        dataTask.resume()
    }
}
