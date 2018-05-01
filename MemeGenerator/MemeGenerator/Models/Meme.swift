//
//  Meme.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import Foundation

struct Meme: Codable {
    var id: String
    var name: String
    var url: String
  
    init() {
        id = ""
        name = ""
        url = ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
}
