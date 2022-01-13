//
//  FavouredPhotosViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class FavouredPhotosViewController: UIViewController {

    // MARK: - Properties and variables

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var starredPhotos = [StarredPhoto]()

    let tableView: UITableView = {
        let result = UITableView()
        result.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        result.showsVerticalScrollIndicator = false
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            self.starredPhotos = try self.context.fetch(StarredPhoto.fetchRequest())
        }
        catch {
            print("No photos in Core Data")
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            self.starredPhotos = try self.context.fetch(StarredPhoto.fetchRequest())
        }
        catch {
            print("No photos in Core Data")
        }
        
        self.tableView.reloadData()
    }

    // MARK: - Private methods

    private func setupUI() {
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

// MARK: - Table View Delegate Methods

extension FavouredPhotosViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.starredPhotos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell
        cell?.selectionStyle = .none
        cell?.setupUI(photo: self.starredPhotos[indexPath.row])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentPhoto = self.starredPhotos[indexPath.row]
        
        let user = User(name: currentPhoto.authorName ?? "")
        let urls = URLs(small: currentPhoto.photoURL ?? "")
        let location = Location(name: currentPhoto.location)
        let convertedPhoto = Photo(id: currentPhoto.id ?? "",
                                   created_at: currentPhoto.created_at ?? "",
                                   user: user,
                                   urls: urls,
                                   location: location,
                                   downloads: Int(currentPhoto.downloads),
                                   imageData: currentPhoto.imageData)
        
        let detailVC = DetailViewController(photo: convertedPhoto)
        detailVC.isStarred = true
        detailVC.delegate = self
        
        present(detailVC, animated: true, completion: nil)
    }
}

// MARK: - Detail View Delegate Methods

extension FavouredPhotosViewController: DetailViewControllerProtocol {
    
    func starButtonTapped() {
        
        do {
            self.starredPhotos = try self.context.fetch(StarredPhoto.fetchRequest())
        }
        catch {
            print("No photos in Core Data")
        }

        self.tableView.reloadData()
    }
}
