//
//  AppCoordinator.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

@MainActor
class AppCoordinator {
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let networkService: any NetworkServiceProtocol
    private let imageLoader: ImageLoading
    private let viewControllerFactory: ViewControllerFactory
    private var rootNavigationController: UINavigationController?
    
    // MARK: - Lyfecycle
    
    init(mainWindow: UIWindow, networkService: any NetworkServiceProtocol = NetworkService(), imageLoader: ImageLoading = ImageLoader(), viewControllerFactory: ViewControllerFactory = ViewControllerFactory()) {
        self.networkService = networkService
        self.imageLoader = imageLoader
        self.viewControllerFactory = viewControllerFactory
        self.window = mainWindow
        mainWindow.makeKeyAndVisible()
    }
    
    // MARK: - Public
    
    func appDidLaunch(options: [UIApplication.LaunchOptionsKey: Any]?) {
        let listViewController = viewControllerFactory.listViewController(
            networkService: networkService,
            imageLoader: imageLoader,
            sceneDelegate: self
        )
        start(with: listViewController)
    }
    
    // MARK: - Private
    
    private func start(with viewConroller: UIViewController) {
        rootNavigationController = navigationController(with: viewConroller)
        window.rootViewController = rootNavigationController!
    }
    
    private func navigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
        return navigationController
    }
}

// MARK: - PhotoListSceneDelegate

extension AppCoordinator: PhotoListSceneDelegate {
    func didPickPhotItem(_ photoItem: PhotoItem) {
        let detailsViewController = viewControllerFactory.detailsViewController(
            photoItem: photoItem,
            imageLoader: imageLoader
        )
        rootNavigationController?.pushViewController(detailsViewController, animated: true)
    }
}
