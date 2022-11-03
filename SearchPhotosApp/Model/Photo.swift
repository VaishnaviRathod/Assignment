//
//  Images.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 02/11/22.
//

import Foundation
struct Photo : Codable {
    
    let id : String?
    let title : String?
    let description : String?
    let link : String?
    let isAnimated: Bool?
    
    init(id: String?, title: String?, description: String?, link: String?, isAnimated:Bool?) {
        self.id = id
        self.title = title
        self.description = description
        self.link = link
         self.isAnimated = isAnimated
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case link = "link"
        case isAnimated = "animated"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        isAnimated = try values.decodeIfPresent(Bool.self, forKey: .isAnimated)
    }

}
