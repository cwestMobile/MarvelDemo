//
//  MarvelResult.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import Foundation

/**
 - Use decodables for all JSON parsing
 */

struct MarvelResult: Decodable {
    
    let code: Int
    let status: String?
    let data: MarvelData
    
}

struct MarvelData: Decodable {
    
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Character]
    
}
