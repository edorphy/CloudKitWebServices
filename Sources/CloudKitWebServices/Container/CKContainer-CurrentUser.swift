//
//  CKContainer-CurrentUser.swift
//  CloudKitWebServices
//
//  Created by Eric Dorphy on 12/24/21.
//  Copyright © 2021 Twin Cities App Dev LLC. All rights reserved.
//

import Foundation

extension CKContainer {
    
    // TODO: This error object is temporary and will be hidden internally once WSWebAuthenticationSession code is working with something like a `showSignIn` func.
    public struct LoginError: Error {
        public let redirectURL: URL
    }
    
    public func fetchUserRecordID(completionHandler: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        let operation = CKFetchCurrentUserRecordOperation(session: self.session, containerURL: self.getContainerURL(), apiToken: self.apiToken) { result in
            completionHandler(result)
        }
        
        self.add(operation)
    }
}

private class CKFetchCurrentUserRecordOperation: CKOperation {
    
    private let session: URLSession
    
    private let containerURL: URL
    
    private let apiToken: CKContainer.APIToken
    
    private let resultBlock: (Result<CKRecord.ID, Error>) -> Void
    
    init(session: URLSession, containerURL: URL, apiToken: CKContainer.APIToken, resultBlock: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        self.session = session
        self.containerURL = containerURL
        self.apiToken = apiToken
        self.resultBlock = resultBlock
    }
    
    override func main() {
        
        // Fetching Current User (users/current)
        // https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitWebServicesReference/GetCurrentUser.html
        
        let task = self.session.dataTask(with: getRequestURL()) { data, response, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self.resultBlock(.failure(error!))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                fatalError("internal apple networking error")
            }

            switch response.statusCode {
            case 200:
                do {
                    let responseBody = try JSONDecoder().decode(OkResponseBody.self, from: data)
                    
                    self.resultBlock(.success(CKRecord.ID(recordName: responseBody.userRecordName)))
                } catch {
                    assertionFailure("failed to decode ok response body with error: \(error)")
                    self.resultBlock(.failure(error))
                }
                
            case 401:
                do {
                    let responseBody = try JSONDecoder().decode(UnauthorizedResponseBody.self, from: data)
                    
                    self.resultBlock(.failure(responseBody))
                    
                } catch {
                    assertionFailure("failed to decode unauthorized response body with error: \(error)")
                    self.resultBlock(.failure(error))
                }
                
            // AUTHENTICATION_REQUIRED
            case 421:
                do {
                    let responseBody = try JSONDecoder().decode(MisdirectedRequestResponseBody.self, from: data)
                    
                    print("OAuth Token: \(responseBody.redirectURL.absoluteString)")
                    
                    self.resultBlock(.failure(CKContainer.LoginError(redirectURL: responseBody.redirectURL)))
                } catch {
                    
                }
                
            default:
                fatalError("not implemented status code for users/current")
            }
        }
        
        task.resume()
    }
    
    private func getRequestURL() -> URL {
        containerURL.appendingPathComponent("public/users/current").appendingQueryItem(name: "ckAPIToken", value: self.apiToken)
    }
    
    private struct OkResponseBody: Codable {
        let userRecordName: String
        let firstName: String?
        let lastName: String?
    }
    
    private struct UnauthorizedResponseBody: Error, Codable {
        let uuid: UUID
        let serverErrorCode: String
        let reason: String
    }
    
    private struct MisdirectedRequestResponseBody: Error, Codable {
        let uuid: UUID
        let serverErrorCode: String
        let reason: String
        let redirectURL: URL
    }
}
