//
//  ListViewController.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

/// View controller for the list screen
class ListViewController: UITableViewController {

    private enum CellId {
        static let normal = "ListCell"
        static let loader = "ListCellLoader"
    }
    
    private enum Layout {
        static let rowHeight = 90.0
        static let headerTopPadding = 20.0
        static let headerBottomPadding = 60.0
        static let headerHorisontalPadding = 10.0
    }
    
    // MARK: - Properties
    
    private let viewModel: ListViewModel
    private var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photos"
        setupTableView()
        setupSearchController()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: CellId.normal)
        tableView.rowHeight = Layout.rowHeight
        tableView.backgroundColor = .lightGray
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.barTintColor = UIColor.lightGray
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func handleError(uiError: Error?) {
        let alert = UIAlertController(title: "Something went wrong",
                                      message: uiError?.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - ListViewModelDelegate

extension ListViewController: ListViewModelDelegate {
    
    func dataUpdateFinished(uiError: Error?) {
        if let uiError {
            handleError(uiError: uiError)
        } else if viewModel.photos.isEmpty {
            // proper empty screen, hiding tableView
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
}

// MARK: - UITableView dataSource/delegate

extension ListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsAmount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewModel.model(index: indexPath.row) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.normal, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.configure(with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didPickItem(index: indexPath.row)
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate

extension ListViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchDidCancel()
    }
}
