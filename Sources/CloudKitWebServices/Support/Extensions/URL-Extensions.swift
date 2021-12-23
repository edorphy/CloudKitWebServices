//
//  URL-Extensions.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension URL {

    func appendingQueryItem(name: String, value: String?) -> URL {

        guard var urlComponents = URLComponents(string: absoluteString) else { return self }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []

        // Create query item
        let queryItem = URLQueryItem(name: name, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        // swiftlint:disable:next force_unwrapping
        return urlComponents.url!
    }
}
