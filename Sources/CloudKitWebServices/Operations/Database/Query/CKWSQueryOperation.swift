//
//  CKWSQueryOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKWSQueryOperation: CKWSDatabaseOperation {
    
    public var query: CKWSQuery
    
    public var cursor: Cursor?
    
    public var resultsLimit: Int = CKWSQueryOperation.maximumResults
    
    /// An array of strings containing record field names that limits the amount of data returned in this operation. Only the fields specified in the array are returned. The default is `nil`, which fetches all record fields.
    public var desiredKeys: [String]?
    
    public var recordMatchedBlock: ((_ recordID: CKWSRecord.ID, _ recordResult: Result<CKWSRecord, Error>) -> Void)?
    
    public var queryResultBlock: ((_ operationResult: Result<CKWSQueryOperation.Cursor?, Error>) -> Void)?
    
    public init(query: CKWSQuery) {
        self.query = query
        self.cursor = nil
    }
    
    public init(cursor: CKWSQueryOperation.Cursor) {
        self.query = cursor.query
        self.cursor = cursor
    }
    
    override public func main() {
        let request = createRequest()
        
        guard let session = self.database?.container?.session else {
            fatalError("Operation should always be configured with a database and contianer")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.invokeRecordMatchedBlock(.failure(error!))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                self.invokeRecordMatchedBlock(.failure(NSError()))
                assertionFailure("Unexpected case. Debug this.")
                return
            }
            
            do {
                switch response.statusCode {
                case 200:
                    let body = try JSONDecoder().decode(ResponseBody.self, from: data)
                    
                    body.records.forEach { record in
                        // TODO: Automatically download the fields that are assets THEN invoke the result fetched block
                        self.invokeRecordFetchedBlock(CKWSRecord(recordDictionary: record))
                    }
                    
                    self.invokeRecordMatchedBlock(.success(Cursor(query: self.query, continuationMarker: body.continuationMarker)))
                    
                default:
                    let errorResponse = try JSONDecoder().decode(RecordFetchErrorDictionary.self, from: data)
                    self.invokeRecordMatchedBlock(.failure(errorResponse))
                }
            } catch {
                fatalError("decoding shouldn't fail, but if it does we should do something better here or fix it")
            }
            
            self.finish()
        }
        
        task.resume()
    }
    
    private func invokeRecordMatchedBlock(_ completion: @autoclosure () -> (Result<Cursor?, Error>)) {
        
        if let queryCompletionBlock = self.queryResultBlock {
            queryCompletionBlock(completion())
        }
    }
    
    private func invokeRecordFetchedBlock(_ record: @autoclosure () -> (CKWSRecord)) {
        if let recordFetchedBlock = self.recordMatchedBlock {
            
            let record = record()
            
            recordFetchedBlock(record.recordID, .success(record))
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

// TODO: Move to better place

extension CKWSQueryOperation {
    static let maximumResults: Int = 200
}

// MARK: - Request/Response Body Types

internal extension CKWSQueryOperation {
    struct RequestBody: Encodable {
        // TODO: ZoneID
        
        /// The maximum number of records to fetch.
        let resultsLimit: Int
        
        /// The query to apply.
        let query: QueryDictionary
        
        /// The location of the last batch of results. Use this key when the results of a previous fetch exceeds the maximum.
        let continuationMarker: String?
        
        /// An array of strings containing record field names that limits the amount of data returned in this operation. Only the fields specified in the array are returned. The default is `null`, which fetches all record fields.
        let desiredKeys: [String]?
        
        /// A Boolean value determining whether all zones should be searched. This key is ignored if zoneID is non-null. To search all zones, set to true. To search the default zone only, set to false.
        let zoneWide: Bool? = false
        
        /// A Boolean value indicating whether number fields should be represented by strings. The default value is false.
        let numbersAsStrings: Bool? = false
    }
    
    struct ResponseBody: Decodable {
        let records: [RecordDictionary]
        let continuationMarker: String?
    }
}
