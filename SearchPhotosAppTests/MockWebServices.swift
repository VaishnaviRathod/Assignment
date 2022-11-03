//
//  MockWebServices.swift
//  SearchPhotosAppTests
//
//  Created by Vaishnavi Rathod on 03/11/22.
//

import Foundation
@testable import SearchPhotosApp

enum MockAPIResponsesTypes {
    case valid
    case invalid
    
    var fileName:String {
        switch self {
        case .valid:
            return "MockValidResponse"
        case .invalid:
            return "MockInvalidResponse"
        }
    }
}

protocol MockServicesProtocol {
    func getPhotosBySearch(responseType: MockAPIResponsesTypes, completion: @escaping (SearchResponse?) -> Void)
}

class MockWebServices:MockServicesProtocol {
    func getPhotosBySearch(responseType: MockAPIResponsesTypes, completion: @escaping (SearchResponse?) -> Void) {
        
        guard let result = SearchResponse.parse(jsonFile: responseType.fileName) else {
            completion(nil)
           return
        }
        completion(result)
    }
}
