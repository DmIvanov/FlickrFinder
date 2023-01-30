//
//  ListViewModel.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

/// View model for the list screen
@MainActor
class ListViewModel {
    
    // MARK: - Properties
    
    weak var view: ListViewModelDelegate?
    weak var sceneDelegate: PhotoListSceneDelegate?
    
    var photos = [PhotoItem]()
    
    private let minCharactersForSearch = 3
    private var currentQuery = ""
    private var pageToFetch: UInt = 1
    private let networkService: any NetworkServiceProtocol
    private let imageLoader: ImageLoading
    
    // MARK: - Lifecycle
    
    init(networkService: any NetworkServiceProtocol, imageLoader: ImageLoading) {
        self.networkService = networkService
        self.imageLoader = imageLoader
    }
    
    // MARK: - Public
    
    func viewDidLoad() {
        fetchData()
    }
    
    func itemsAmount() -> Int {
        photos.count
    }
    
    func model(index: Int) -> ListCellViewModel? {
        if index == photos.count-5 {
            pageToFetch += 1
            fetchData()
        }
        if index >= 0 && index < photos.count {
            return ListCellViewModel(photo: photos[index], imageLoader: imageLoader)
        }
        return nil
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText != currentQuery, searchText.count >= minCharactersForSearch {
            resetPhotos()
            currentQuery = searchText
            fetchData()
        }
    }
    
    func searchDidCancel() {
        currentQuery = ""
        resetPhotos()
        fetchData()
    }
    
    func didPickItem(index: Int) {
        guard index >= 0 && index < photos.count else { return }
        sceneDelegate?.didPickPhotItem(photos[index])
    }
    
    // MARK: - Private
    
    private func fetchData() {
        Task {
            do {
                let newPhotos = try await networkService.loadPhotos(query: currentQuery, page: pageToFetch)
                photos.append(contentsOf: newPhotos)
                view?.dataUpdateFinished(uiError: nil)
            } catch {
                view?.dataUpdateFinished(uiError: error)
            }
        }
    }
    
    private func resetPhotos() {
        pageToFetch = 0
        photos = [PhotoItem]()
        view?.dataUpdateFinished(uiError: nil)
    }
}

@MainActor
protocol ListViewModelDelegate: AnyObject {
    func dataUpdateFinished(uiError: Error?)
}

@MainActor
protocol PhotoListSceneDelegate: AnyObject {
    func didPickPhotItem(_ photoItem: PhotoItem)
}
