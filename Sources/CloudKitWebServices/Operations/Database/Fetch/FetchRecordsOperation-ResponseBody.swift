//
//  FetchRecordsOperation.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 6/13/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension FetchRecordsOperation {
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
