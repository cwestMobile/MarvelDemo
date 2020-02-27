//
//  MarvelApiService.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import Foundation
import UIKit

class MarvelApiService : NSObject {
    
    public static let sharedInstance = MarvelApiService()

    /**
     - Test mode to bypass Marvel endpoint restrictions
     */
    private let testMode = true

    /**
     - API Keys & Base Endpoint. Generally wouldn't store these as plain text.
     */
    private let privateKey = "2609dfdf4b7a8d73153d2cfbd01120ad2ff7f34d"
    private let publicKey = "bd2e4092d2a7972954e4919aea276a1e"
    private let baseEndpoint = "https://gateway.marvel.com/v1/public/"

    /**
     - Get Marvel Character list
     - parameters:
        - offset: Starting location for API retrieval
     */
    public func getMarvelCharacters(offset: Int, completion: @escaping (Result<[Character], Error>) -> ()) {
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
        let offsetString = "\(offset)"
        
        guard let url = URL(string: baseEndpoint + "characters?ts=" + timestamp + "&limit=20&offset=" + offsetString + "&apikey=" + publicKey + "&hash=" + hash) else { return }

        /**
        - Don't use URLSession.shared() because we need the delegate to bypass the URLAuthenticationChallenge we receive
        */
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        urlSession.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                if let data = data {
                    // Use Decodable MarvelResult for simple JSON decoding and complete with success
                    let result = try JSONDecoder().decode(MarvelResult.self, from: data)
                    let characters = result.data.results
                    completion(.success(characters))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
}

extension MarvelApiService : URLSessionDelegate {
    
    /**
     - Override URLAuthenticationChallenge for Marvel API endpoint if testMode is active. Called when a connection level authentication challenge has occurred
     */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if testMode {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        else {
            completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
    
}

