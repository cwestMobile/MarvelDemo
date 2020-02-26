//
//  Character.swift
//  MarvelDemo
//
//  Created by Casey West on 2/25/20.
//  Copyright © 2020 Casey West. All rights reserved.
//

import Foundation

/**
 - Use decodables for all JSON parsing
 */

struct Character: Decodable {
    
    let id: Int
    let name: String?
    let description: String?
    let resourceURI: String?
    let thumbnail: CharacterThumbnail?
    let comics: CharacterDetails?
    let stories: CharacterDetails?
    let events: CharacterDetails?
    let series: CharacterDetails?

}

struct CharacterDetails: Decodable {
    
    let available: Int
    let items: [CharacterDetailItem]?
    let returned: Int
    
}

struct CharacterDetailItem: Decodable {
    
    let name: String?
    
}

struct CharacterThumbnail: Decodable {
    
    let path: String?
    let ext: String?
    
    enum CodingKeys: String, CodingKey {
        case ext = "extension"
        case path
    }
    
}

/**
 - Used to group CharacterDetailItems into appropriate sections in the CharacterDetailViewController tableView
 */
struct GroupedCategory {
    
    let name : String
    var items : [CharacterDetailItem]
    
}
