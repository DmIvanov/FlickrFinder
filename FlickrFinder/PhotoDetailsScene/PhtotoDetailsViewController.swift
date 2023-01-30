//
//  PhtotoDetailsViewController.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 30/01/2023.
//

import UIKit

/// View controller for the details screen
class PhtotoDetailsViewController: UIViewController {

    // MARK: - Properties
    
    private let photoItem: PhotoItem
    private let imageLoader: ImageLoading
    
    private var imageView: UIImageView = {
        let imageView = UIImageView.autolayoutView()
        imageView.contentMode = .scaleAspectFit
        imageView.enableZoom()
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    init(photoItem: PhotoItem, imageLoader: ImageLoading) {
        self.photoItem = photoItem
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        imageLoader.cancelLoading(urlString: photoItem.imageURL())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.clipsToBounds = true
        setupLayout()
        imageLoader.loadImage(urlString: photoItem.imageURL()) { [weak self] result in
            guard let self else { return }
            guard case .success((let image, _)) = result else { return }
            self.imageView.image = image
        }
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
