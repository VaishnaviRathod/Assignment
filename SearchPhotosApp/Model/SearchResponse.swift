//
//  SearchResponse.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 02/11/22.
//

import Foundation
// API Response model on search
struct SearchResponse : Codable {
    let searchedData : [PhotosResponse]?
    let success : Bool?
    let status : Int?
    
    enum CodingKeys: String, CodingKey {
        case searchedData = "data"
        case success = "success"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        searchedData = try values.decodeIfPresent([PhotosResponse].self, forKey: .searchedData)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }
}
