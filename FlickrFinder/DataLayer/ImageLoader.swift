//
//  ImageLoader.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit.UIImage

typealias ImageGettingComplition = (Result<(UIImage, String), Error>)->()

/// Object responsible for downloading and caching images,
/// Loading of an image can be cancelled if not started yet
class ImageLoader: ImageLoading {
    
    // MARK: - Properties
    
    private var loadedImages = [String: UIImage]()
    private var runningRequests = [String: URLSessionDataTask]()
    private let session: URLSession = URLSession.shared
    
    func loadImage(urlString: String?, completion: @escaping ImageGettingComplition) {
        guard let urlString, let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(ImageLoagingError.invalidURL)) }
            return
        }
        if let image = loadedImages[urlString] {
            DispatchQueue.main.async { completion(.success((image, urlString))) }
            return
        }
        let task = session.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self else { return }
            defer { self.runningRequests.removeValue(forKey: urlString) }
            if let data, let image = UIImage(data: data) {
                self.loadedImages[urlString] = image
                DispatchQueue.main.async { completion(.success((image, urlString))) }
            } else {
                DispatchQueue.main.async { completion(.failure(ImageLoagingError.invalidData)) }
            }
        }
        task.resume()
        runningRequests[urlString] = task
    }
    
    func cancelLoading(urlString: String?) {
        guard let urlString else { return }
        runningRequests[urlString]?.cancel()
        runningRequests.removeValue(forKey: urlString)
    }
}

extension ImageLoader: Equatable {
    static func == (lhs: ImageLoader, rhs: ImageLoader) -> Bool {
        lhs === rhs
    }
}

protocol ImageLoading: AnyObject {
    func loadImage(urlString: String?, completion: @escaping ImageGettingComplition)
    func cancelLoading(urlString: String?)
}

enum ImageLoagingError: Error {
    case invalidURL
    case invalidData
}
