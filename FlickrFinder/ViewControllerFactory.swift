//
//  ViewControllerFactory.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

class ViewControllerFactory {
        
    @MainActor
    func listViewController(networkService: any NetworkServiceProtocol, imageLoader: ImageLoading, sceneDelegate: PhotoListSceneDelegate) -> UIViewController {
        let model = ListViewModel(networkService: networkService, imageLoader: imageLoader)
        let viewController = ListViewController(viewModel: model)
        model.view = viewController
        model.sceneDelegate = sceneDelegate
        return viewController
    }
    
    @MainActor
    func detailsViewController(photoItem: PhotoItem, imageLoader: ImageLoading) -> UIViewController {
        return PhtotoDetailsViewController(photoItem: photoItem, imageLoader: imageLoader)
    }
}
