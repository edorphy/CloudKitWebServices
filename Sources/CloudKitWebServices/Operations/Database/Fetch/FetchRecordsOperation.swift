//
//  FetchRecordsOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/12/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

public class FetchRecordsOperation: DatabaseOperation {
    
    private let recordIDs: [Record.ID]
    
    public var perRecordResultBlock: ((Record.ID, Result<Record, Error>) -> Void)?
    
    /// The closure to execute after CloudKit retrieves all of the records.
    ///
    /// This property is a closure that returns no value and has the following parameters:
    /// - A dictionary that contains the records that CloudKit retrieves. Each key in the dictionary is a `RecordID` object that corresponds to a record you request. The value of each key is the actual `Record` object that CloudKit returns.
    /// - If CloudKit can't retrieve any of the records, an error that provides information about the failure; otherwise, `nil`.
    ///
    /// The fetch operation executes this closure only once, and it's your final opportunity to process the results. The closure executes after all of the individual progress closures, but before the operation's completion colsure. The colsure executes serially with respect to the other progress closures of the operation.
    ///
    /// The closure reports an error of type partialFailure when it retrieves only some of the records successfully. The `userInfo` dictionary of the error contains a `PartialErrorsByItemIDKey` key that has a dictionary as its value. The keys of the dictionary are the IDs of the records that the operation can't retreive, and the corresponding values are errors that contain information about the failures.
    ///
    /// If you intend to use this closure to process results, set it before you execute the operation or submit the operation to a queue.
    public var fetchRecordsCompletionBlock: (([Record.ID: Record]?, Error?) -> Void)?
    // TODO: Change this to: ((Result<Void, Error>) -> Void)?
    
    public init(recordIDs: [Record.ID]) {
        self.recordIDs = recordIDs
    }
    
    override public func main() {
        
        let request = createRequest()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.invokeCompletionBlock((nil, error!))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                self.invokeCompletionBlock((nil, NSError()))
                assertionFailure("Unexpected case. Debug this.")
                return
            }
            
            do {
                switch response.statusCode {
                case 200:
                    
                    let body = try JSONDecoder().decode(ResponseBody.self, from: data)
                    
                    var records: [Record.ID: Record] = [:]
                    var failureRecords: [Record.ID: RecordFetchErrorDictionary] = [:]
                    
                    body.records.forEach { recordResult in
                        
                        switch recordResult {
                        case .success(let recordDictionary):
                            let record = Record(recordDictionary: recordDictionary)
                            records[record.recordID] = record
                            self.invokeRecordResultBlock((record.recordID, .success(record)))
                            
                        case .failure(let errorDictionary):
                            // swiftlint:disable:next force_unwrapping
                            let recordID = Record.ID(recordName: errorDictionary.recordName!)
                            failureRecords[recordID] = errorDictionary
                            self.invokeRecordResultBlock((recordID, .failure(errorDictionary)))
                        }
                    }
                    
                    self.invokeCompletionBlock((records, PartialFailure(failedRecords: failureRecords)))
                    
                default:
                    let errorResponse = try JSONDecoder().decode(RecordFetchErrorDictionary.self, from: data)
                    self.invokeCompletionBlock((nil, errorResponse))
                }
            } catch {
                fatalError("Received an error decoding the fetch response: \(error)")
            }
            
            self.finish()
        }
        .resume()
    }
    
    private func invokeRecordResultBlock(_ completion: @autoclosure () -> (recordID: Record.ID, result: Result<Record, Error>)) {
        if let perRecordResultBlock = self.perRecordResultBlock {
            let result = completion()
            perRecordResultBlock(result.recordID, result.result)
        }
    }
    
    private func invokeCompletionBlock(_ completion: @autoclosure () -> (records: [Record.ID: Record]?, error: Error?)) {
        if let fetchRecordsCompletionBlock = self.fetchRecordsCompletionBlock {
            let result = completion()
            fetchRecordsCompletionBlock(result.records, result.error)
        }
    }
    
    private func createRequest() -> URLRequest {
        var request = URLRequest(url: getURL())
        request.httpMethod = "POST"
        
        let requestBody = RequestBody(
            records: recordIDs.map({ recordID in
                LookupRecordDictionary(recordName: recordID.recordName)
            })
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            fatalError("request encoding should never happen, but we should be more graceful with this")
        }
        
        return request
    }
}

extension FetchRecordsOperation {
    func getURL() -> URL {
        guard let database = self.database else {
            fatalError("the operation was not configured with a database which is required")
        }
        
        var url = getRecordsURL(database: database)
        url.appendPathComponent("lookup")
        
        return url
    }
}
