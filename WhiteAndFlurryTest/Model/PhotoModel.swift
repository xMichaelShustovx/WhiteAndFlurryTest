//
//  PhotoModel.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import Foundation

protocol PhotosModelProtocol {
    
    func photosRetrieved(photos: [Photo])
}

class PhotosModel {
    
    
    // MARK: - Properties and variables
    
    var delegate: PhotosModelProtocol?
    
//    var photoArray = [Photo]()
    
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
                    
                    print("TOTAL RESULTS: \(result.count)")

//                    self.photoArray.append(contentsOf: result)
                    
                    
                    DispatchQueue.main.async {
                        self.delegate?.photosRetrieved(photos: result)
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

        let url = URL(string: "https://api.unsplash.com/photos?query=\(bySearch)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(self.key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                do {
                    
                    let result = try JSONDecoder().decode([Photo].self, from: data!)
                    
                    print("TOTAL RESULTS: \(result.count)")

//                    self.photoArray = result
                    
                    DispatchQueue.main.async {
                        self.delegate?.photosRetrieved(photos: result)
                    }
                }
                catch {
                    print("Couldn't recieve data")
                }
            }
        }
        
        dataTask.resume()
        
    }
}
