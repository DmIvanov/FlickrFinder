//
//  Mocks.swift
//  FlickrFinderTests
//
//  Created by Ivanov, D. (Dmitrii) on 30/01/2023.
//

@testable import FlickrFinder
import UIKit
import XCTest

class ViewControllerFactoryMock: ViewControllerFactory {
 
    let viewControllerMock = UIViewController()
    var networkServiceParam: NetworkServiceMock?
    var imageLoaderParam: ImageLoaderMock?
    var photoItemParam: PhotoItem?
    
    override func listViewController(networkService: any NetworkServiceProtocol, imageLoader: ImageLoading, sceneDelegate: PhotoListSceneDelegate) -> UIViewController {
        networkServiceParam = networkService as? NetworkServiceMock
        imageLoaderParam = imageLoader as? ImageLoaderMock
        return viewControllerMock
    }
    
    override func detailsViewController(photoItem: PhotoItem, imageLoader: ImageLoading) -> UIViewController {
        photoItemParam = photoItem
        imageLoaderParam = imageLoader as? ImageLoaderMock
        return viewControllerMock
    }
}

class NetworkServiceMock: NetworkServiceProtocol, Equatable {
    var queryParam: String?
    var pageParam: UInt?
    
    static func == (lhs: NetworkServiceMock, rhs: NetworkServiceMock) -> Bool {
        lhs === rhs
    }
    
    func loadPhotos(query: String, page: UInt) async throws -> [PhotoItem] {
        queryParam = query
        pageParam = page
        return [
            PhotoItem.makeMock(id: "0"),
            PhotoItem.makeMock(id: "1"),
            PhotoItem.makeMock(id: "2")
        ]
    }
}

class ImageLoaderMock: ImageLoading, Equatable {

    var expectation: XCTestExpectation?
    var urlStringParam: String?
    
    static func == (lhs: ImageLoaderMock, rhs: ImageLoaderMock) -> Bool {
        lhs === rhs
    }
    
    func loadImage(urlString: String?, completion: @escaping ImageGettingComplition) {
        urlStringParam = urlString
        DispatchQueue.main.async {
            self.expectation?.fulfill()
            completion(.success((UIImage(), "")))
        }
    }
    
    func cancelLoading(urlString: String?) {}
}

class ListViewControllerMock: ListViewModelDelegate {
    
    var expectation: XCTestExpectation?
    var dataUpdateFinishedCalled = false
    
    func dataUpdateFinished(uiError: Error?) {
        dataUpdateFinishedCalled = true
        expectation?.fulfill()
    }
}

extension PhotoItem {
    static func makeMock(id: String = "testId", title: String = "testTitle") -> PhotoItem {
        PhotoItem(farm: 0, id: id, server: "mock", secret: "mock", title: title)
    }
}
