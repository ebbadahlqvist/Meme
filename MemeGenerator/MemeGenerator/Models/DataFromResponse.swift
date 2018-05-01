//
//  DataFromResponse.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import Foundation

struct DataFromResponse: Codable {
    var memes: [Meme]
    
    init() {
        memes = []
    }
    
    private enum CodingKeys: String, CodingKey {
        case memes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        memes = try container.decode([Meme].self, forKey: .memes)
    }
}
