//
//  QueryOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class QueryOperation: DatabaseOperation {
    
    public var query: Query
    
    public var cursor: Cursor?
    
    public var resultsLimit: Int = .maximumQueryLimit
    
    /// An array of strings containing record field names that limits the amount of data returned in this operation. Only the fields specified in the array are returned. The default is `nil`, which fetches all record fields.
    public var desiredKeys: [String]?
    
    public var recordFetchedBlock: ((Record) -> Void)?
    
    public var queryCompletionBlock: ((Result<Cursor?, Error>) -> Void)?
    
    public init(query: Query) {
        self.query = query
        self.cursor = nil
    }
    
    public init(cursor: Cursor) {
        self.query = cursor.query
        self.cursor = cursor
    }
    
    override public func main() {
        let request = createRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.invokeQueryCompletionBlock(.failure(error!))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                self.invokeQueryCompletionBlock(.failure(NSError()))
                assertionFailure("Unexpected case. Debug this.")
                return
            }
            
            do {
                switch response.statusCode {
                case 200:
                    let body = try JSONDecoder().decode(ResponseBody.self, from: data)
                    
                    body.records.forEach { record in
                        self.invokeRecordFetchedBlock(Record(recordDictionary: record))
                    }
                    
                    self.invokeQueryCompletionBlock(.success(Cursor(query: self.query, continuationMarker: body.continuationMarker)))
                    
                default:
                    let errorResponse = try JSONDecoder().decode(RecordFetchErrorDictionary.self, from: data)
                    self.invokeQueryCompletionBlock(.failure(errorResponse))
                }
            } catch {
                fatalError("decoding shouldn't fail, but if it does we should do something better here or fix it")
            }
            
            self.finish()
        }
        .resume()
    }
    
    private func invokeQueryCompletionBlock(_ completion: @autoclosure () -> (Result<Cursor?, Error>)) {
        
        if let queryCompletionBlock = self.queryCompletionBlock {
            queryCompletionBlock(completion())
        }
    }
    
    private func invokeRecordFetchedBlock(_ record: @autoclosure () -> (Record)) {
        if let recordFetchedBlock = self.recordFetchedBlock {
            recordFetchedBlock(record())
        }
    }
    
    private func createRequest() -> URLRequest {
        
        // TODO: Safely unwrap the token, if it doesn't exist, the request will fail. Don't even bother the network layer and invoke the completion with an error right away
        
        // swiftlint:disable:next force_unwrapping
        let url = getURL().appendingQueryItem(name: "ckAPIToken", value: database!.container?.apiToken)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = RequestBody(
            resultsLimit: self.resultsLimit,
            query: QueryDictionary(query: query),
            continuationMarker: self.cursor?.continuationMarker,
            desiredKeys: self.desiredKeys
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            fatalError("Received an unexpected encoding error encoding the query request body: \(error)")
        }
        
        return request
    }
    
    private func getURL() -> URL {
        guard let database = self.database else {
            fatalError("the operation was not configured with a database which is required")
        }
        
        let url = getRecordsURL(database: database)
        return url.appendingPathComponent("query")
    }
}

public extension QueryOperation {
    struct Cursor {
        let query: Query
        let continuationMarker: String
        
        init?(query: Query, continuationMarker: String?) {
            guard let continuationMarker = continuationMarker else {
                return nil
            }
            
            self.query = query
            self.continuationMarker = continuationMarker
        }
    }
}

// TODO: Move to better place

private extension Int {
    static let maximumQueryLimit: Int = 200
}
