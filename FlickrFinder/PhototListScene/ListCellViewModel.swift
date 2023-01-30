//
//  ListCellViewModel.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

struct ListCellViewModel {
    
    // MARK: - Properties
    
    var title: String {
        if let photoTitle = photo.title, !photoTitle.isEmpty {
            return photoTitle
        } else {
            return "(no title)"
        }
    }
    
    var imageURLString: String {
        photo.thumbnailURL()
    }
    
    private let photo: PhotoItem
    private let imageLoader: ImageLoading
    
    // MARK: - Lifecycle
    
    init(photo: PhotoItem, imageLoader: ImageLoading) {
        self.photo = photo
        self.imageLoader = imageLoader
    }
    
    func loadImage(completion: @escaping ImageGettingComplition) {
        imageLoader.loadImage(urlString: photo.thumbnailURL(), completion: completion)
    }
    
    func cancelLoading() {
        imageLoader.cancelLoading(urlString: photo.thumbnailURL())
    }
}

