//
//  ListTableViewCell.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    private enum Layout {
        static let titleFontSize = 14.0
        static let subtitleFontSize = 12.0
        static let rowHeight = 90.0
        static let contentPadding = 8.0
        static let titleSpasing = 14.0
        static let subtitleSpasing = 6.0
    }
    
    // MARK: - Properties
    
    private var viewModel: ListCellViewModel?
    
    private var titleLabel = UILabel.autolayoutView()
    private var thumbnailImageView = UIImageView.autolayoutView()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Layout.titleFontSize)
        titleLabel.numberOfLines = 4
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: Layout.contentPadding, bottom: 0, right: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        viewModel?.cancelLoading()
    }
    
    // MARK: - Public
    
    func configure(with model: ListCellViewModel) {
        viewModel = model
        titleLabel.text = model.title
        thumbnailImageView.image = nil
        model.loadImage { [weak self] result in
            guard let self, let viewModel = self.viewModel else { return }
            guard case .success((let image, let urlSrting)) = result, urlSrting == viewModel.imageURLString else { return }
            self.thumbnailImageView.image = image
        }
        layoutElements()
    }
    
    // MARK: - Private
    
    private func layoutElements() {
        let mainStack = UIStackView.autolayoutView()
        mainStack.axis = .horizontal
        mainStack.addArrangedSubview(thumbnailImageView)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.setCustomSpacing(Layout.contentPadding, after: thumbnailImageView)
        
        contentView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.contentPadding),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.contentPadding),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.contentPadding),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.contentPadding),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor)
        ])
    }
}
