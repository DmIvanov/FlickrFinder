//
//  NetworkService.swift
//  FlickrFinder
//
//  Created by Ivanov, D. (Dmitrii) on 29/01/2023.
//

import Foundation

/// Object responsible for interacting with the remote API
class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    let apiURL = "https://api.flickr.com/services/rest/?"
    let generalURLParams: [String: String] = [
        "api_key" : "1508443e49213ff84d566777dc211f2a",
        "format" : "json",
        "nojsoncallback" : "1"
    ]
    let urlParamsSafeSearchKey = "safe_search"
    let urlParamsSafeSearchValue = "1"
    let urlParamsPageKey = "page"
    let urlParamsQueryKey = "text"
    let urlParamsMethodKey = "method"
    let urlParamsPageSizeKey = "per_page"
    let urlParamsPageSizeValue = 25
    
    private let networkClient: NetworkClientProtocol
    private let parser: APIResponseParser
    
    // MARK: - Lyfecycle
    
    init(networkClient: NetworkClientProtocol = URLSession.shared, parser: APIResponseParser = APIResponseParser()) {
        self.parser = parser
        self.networkClient = networkClient
    }

    // MARK: - Public

    func loadPhotos(query: String, page: UInt) async throws -> [PhotoItem] {
        let params: [String: String] = [
            urlParamsSafeSearchKey : urlParamsSafeSearchValue,
            urlParamsPageSizeKey : "\(urlParamsPageSizeValue)",
            urlParamsPageKey : "\(page)",
            urlParamsQueryKey : query
        ]

        // Flickr API doesn't allow to use `photosSearch` method without any query
        if query.count > 0 {
            return try await sendRequest(method: APIMethod.photosSearch, requestParams: params, parser: parser.processGetPhotosResponse)
        } else {
            return try await sendRequest(method: APIMethod.photosGet, requestParams: params, parser: parser.processGetPhotosResponse)
        }
    }

    // MARK: - Private

    private func sendRequest<T>(method: APIMethod, requestParams: [String: String], parser: ((Data) throws -> T)) async throws -> T {
        var params = generalURLParams
        requestParams.forEach { (key, value) in
            params[key] = value
        }
        params[urlParamsMethodKey] = method.rawValue
        var components = URLComponents(string: apiURL)!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        let urlRequest = URLRequest(url: components.url!)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try parser(data)
    }
}

protocol NetworkServiceProtocol {
    func loadPhotos(query: String, page: UInt) async throws -> [PhotoItem]
}

enum APIMethod: String {
    case photosGet = "flickr.photos.getRecent"
    case photosSearch = "flickr.photos.search"
}

enum APIError: Error {
    case RequestIsInProgress
    case WrongJSONFormat
    case CorruptedResponse
}

protocol NetworkClientProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkClientProtocol {}

class APIResponseParser {

    // APIMethod.photosGet
    // APIMethod.photosSearch
    func processGetPhotosResponse(responseData: Data) throws -> [PhotoItem] {
        let decoder = JSONDecoder()
        let responseObject = try decoder.decode(PhotosGetResponse.self, from: responseData)
        return responseObject.photos.photo
    }
}

struct PhotosGetResponse: Codable {
    struct Photos: Codable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [PhotoItem]
    }
    let stat: String
    let photos: Photos
}
