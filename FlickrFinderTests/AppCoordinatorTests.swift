//
//  AppCoordinatorTests.swift
//  FlickrFinderTests
//
//  Created by Ivanov, D. (Dmitrii) on 30/01/2023.
//

@testable import FlickrFinder
import XCTest

final class AppCoordinatorTests: XCTestCase {
    
    var sut: AppCoordinator!
    var window: UIWindow!
    var viewControllerFactoryMock: ViewControllerFactoryMock!
    var networkService: NetworkServiceMock!
    var imageLoader: ImageLoaderMock!
    
    @MainActor
    override func setUp() {
        window = UIWindow()
        viewControllerFactoryMock = ViewControllerFactoryMock()
        networkService = NetworkServiceMock()
        imageLoader = ImageLoaderMock()
        
        sut = AppCoordinator(mainWindow: window,
                                 networkService: networkService,
                                 imageLoader: imageLoader,
                                 viewControllerFactory: viewControllerFactoryMock)
    }
    
    override func tearDown() {
        window = nil
        viewControllerFactoryMock = nil
        networkService = nil
        imageLoader = nil
        sut = nil
    }
    
    @MainActor
    func testAppDidLaunch() {
        sut.appDidLaunch(options: nil)
        
        XCTAssertEqual(viewControllerFactoryMock.networkServiceParam, networkService)
        XCTAssertEqual(viewControllerFactoryMock.imageLoaderParam, imageLoader)
        
        XCTAssertNotNil(window.rootViewController)
        XCTAssert(window.rootViewController is UINavigationController)
        XCTAssertEqual((window.rootViewController as! UINavigationController).topViewController, viewControllerFactoryMock.viewControllerMock)
    }
    
    @MainActor
    func testPhotoItemDidPick() {
        let testId = "mock_id"
        let mockPhotoItem = PhotoItem.makeMock(id: testId)
        sut.didPickPhotItem(mockPhotoItem)
        
        XCTAssertNil(window.rootViewController)
        XCTAssertEqual(viewControllerFactoryMock.imageLoaderParam, imageLoader)
        XCTAssertEqual(viewControllerFactoryMock.photoItemParam?.id, testId)
    }
}
