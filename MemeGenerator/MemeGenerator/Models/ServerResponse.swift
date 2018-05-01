//
//  ServerResponse.swift
//  MemeGenerator
//
//  Created by Ebbas on 2018-04-28.
//  Copyright © 2018 enappstudio. All rights reserved.
//

import Foundation

struct ServerResponse: Codable {
    var success: Bool
    var data: DataFromResponse
    
    init() {
        success = false
        data = DataFromResponse()
    }
    
    private enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        data = try container.decode(DataFromResponse.self, forKey: .data)
    }
}
