//
//  CKFetchRecordsOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class CKFetchRecordsOperation: CKDatabaseOperation {
    
    // MARK: - Properties
    
    private let recordIDs: [CKRecord.ID]
    
    public var desiredKeys: [CKRecord.FieldKey]?
    
    public var perRecordResultBlock: ((_ recordID: CKRecord.ID, _ recordResult: Result<CKRecord, Error>) -> Void)?
    
    public var fetchRecordsResultBlock: ((_ operationResult: Result<Void, Error>) -> Void)?
    
    // MARK: - Initialization
    
    public init(recordIDs: [CKRecord.ID]) {
        self.recordIDs = recordIDs
    }
    
    override public func main() {
        
        let request: URLRequest
        
        do {
            request = try createRequest()
        } catch {
            fetchRecordsResultBlock?(.failure(error))
            self.finish()
            return
        }
        
        guard let session = self.database?.container?.session else {
            fatalError("Operation should always be configured with a database and contianer")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            defer {
                self.finish()
            }
            
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.invokeOperationResultBlock(error!)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                // TODO: If we can trust the new async/await method signature and documentation, if no error we should ALWAYS have data and response. Use internal error?
                self.invokeOperationResultBlock(NSError())
                assertionFailure("Unexpected case. Debug this.")
                return
            }
            
            do {
                switch response.statusCode {
                case 200:
                    
                    let body = try JSONDecoder().decode(ResponseBody.self, from: data)
                    
                    body.records.forEach { recordResult in
                        
                        switch recordResult {
                        case .success(let recordDictionary):
                            let record = CKRecord(recordDictionary: recordDictionary)
                            // TODO: Automatically download the fields that are assets THEN invoke the result fetched block
                            self.invokeRecordResultBlock((record.recordID, .success(record)))
                            
                        case .failure(let errorDictionary):
                            // swiftlint:disable:next force_unwrapping
                            let recordID = CKRecord.ID(recordName: errorDictionary.recordName!)
                            let error = CKError(errorDictionary: errorDictionary)
                            
                            self.invokeRecordResultBlock((recordID, .failure(error)))
                        }
                    }
                    
                    self.invokeOperationResultBlock(nil)
                    
                case 503:
                    self.invokeOperationResultBlock(CKError(code: .serviceUnavailable))
                    
                default:
                    let errorResponse = try JSONDecoder().decode(RecordFetchErrorDictionary.self, from: data)
                    self.invokeOperationResultBlock(errorResponse)
                }
            } catch {
                // TODO: Catch per status code and use a helper function
                fatalError("Received an error decoding the fetch response: \(error)")
            }
        }
        
        task.resume()
    }
    
    private func invokeRecordResultBlock(_ completion: @autoclosure () -> (recordID: CKRecord.ID, result: Result<CKRecord, Error>)) {
        if let perRecordResultBlock = self.perRecordResultBlock {
            let result = completion()
            perRecordResultBlock(result.recordID, result.result)
        }
    }
    
    private func invokeOperationResultBlock(_ completion: @autoclosure () -> (Error?)) {
        if let fetchRecordsResultBlock = self.fetchRecordsResultBlock {
            if let error = completion() {
                fetchRecordsResultBlock(.failure(error))
            } else {
                fetchRecordsResultBlock(.success(()))
            }
        }
    }
    
    private func createRequest() throws -> URLRequest {
        var request = URLRequest(url: getURL())
        request.httpMethod = "POST"
        
        let requestBody = RequestBody(
            records: recordIDs.map({ recordID in
                LookupRecordDictionary(recordName: recordID.recordName)
            }), desiredKeys: self.desiredKeys
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            // TODO: Convert this to throws invalidArguments error
            throw error
        }
        
        request.allowsCellularAccess = configuration.allowsCellularAccess
        request.timeoutInterval = configuration.timeoutIntervalForRequest
        
        return request
    }
}

extension CKFetchRecordsOperation {
    func getURL() -> URL {
        guard let database = self.database else {
            fatalError("the operation was not configured with a database which is required")
        }
        
        var url = getRecordsURL(database: database)
        url.appendPathComponent("lookup")
        
        return url
    }
}

// MARK: - Request/Response Body Types

internal extension CKFetchRecordsOperation {
    struct RequestBody: Encodable {
        
        /// Array of record dictionaries, described in Lookup Record Dictionary, identifying the records to fetch.
        let records: [LookupRecordDictionary]
        
        // TODO: ZoneID
        
        // TODO: DesiredKeys
        let desiredKeys: [CKRecord.FieldKey]?
        
        // Explicitly set this to false in case default behaivor changes. The Record Decoding is setup to expect this behavior.
        let numbersAsStrings: Bool = false
    }
    
    struct ResponseBody: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case records
        }
        
        let records: [Result<RecordDictionary, RecordFetchErrorDictionary>]
        
        init(from decoder: Decoder) throws {
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            var records = [Result<RecordDictionary, RecordFetchErrorDictionary>]()
            
            var resultsContainer = try values.nestedUnkeyedContainer(forKey: .records)
            
            while !resultsContainer.isAtEnd {
                
                // TODO: Make this better
                // Attempt to decode the success body, on failure decode the failure body. But this has a side effect if the success
                // body failed to decode because of a legitimate decode error and not simply just the incorrect type.
                // In other words, need to add detection for false negative decoding error on the RecordDictionary type.
                
                do {
                    let recordDictionary = try resultsContainer.decode(RecordDictionary.self)
                    records.append(.success(recordDictionary))
                } catch {
                    do {
                        let errorDictionary = try resultsContainer.decode(RecordFetchErrorDictionary.self)
                        records.append(.failure(errorDictionary))
                    } catch {
                        throw error
                    }
                }
            }
            
            self.records = records
        }
    }
}
