//
//  PhotoItem.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import Foundation

struct PhotoItem: Codable, Identifiable {
    let farm: Int
    let id: String
    let server: String
    let secret: String
    let title: String?

    func imageURL() -> String {
        return imageURL(size: "b")
    }

    func thumbnailURL() -> String {
        return imageURL(size: "m")
    }

    private func imageURL(size: String) -> String {
        return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret)_\(size).jpg"
    }
}
