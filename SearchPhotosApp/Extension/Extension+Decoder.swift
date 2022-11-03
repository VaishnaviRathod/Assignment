//
//  Extension+Decoder.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 01/11/22.
//

import Foundation


extension Decodable {
  static func parse(jsonFile: String) -> Self? {
    guard let url = Bundle.main.url(forResource: jsonFile, withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let output = try? JSONDecoder().decode(self, from: data)
        else {
      return nil
    }

    return output
  }
}
