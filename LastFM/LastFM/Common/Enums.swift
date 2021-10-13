//
//  Enums.swift
//  LastFM
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import Foundation

typealias ViewModelToViewCallBack = ((Bool, AppError?) -> Void)

// MARK: Enum used for server/business error
public enum AppError : Error {
    case networkError
    case dataEmpty
    case urlInvalid
    case invalidInput
    case invalidResponse
    
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("Server call error: Auth token may be wrong", comment: "")
        case .dataEmpty:
            return NSLocalizedString("Server call error: Response data is empty", comment: "")
        case .urlInvalid:
            return NSLocalizedString("Server call error: Url is invalid", comment: "")
        case .invalidInput:
            return NSLocalizedString("Server call error: Invalid request input", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Server call error: Invalid server response.", comment: "")
        }
    }
}
// MARK: Enum used for request method type
public enum RequestMethod:String {
    case PUT = "PUT"
    case GET = "GET"
    case POST = "POST"
}
// MARK: Enum for backend api names , url and default params
public enum API {
    case albumSearch
    case albumInfo
    func urlParams() -> [String:String] {
        var params = ["api_key": Constants.API_KEY, "format":"json"]
        switch self {
        case .albumSearch:
            params["method"] = "album.search"
        case .albumInfo:
            params["method"] = "album.getinfo"
        }
        return params
    }
}
