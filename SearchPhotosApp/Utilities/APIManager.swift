//
//  APIManager.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 01/11/22.
//

import Foundation

enum NetworkResponse<T, U: Error> {
    case success(T)
    case failure(U)
}

enum NetworkError: Error {
    case network(Error)
    case decoding(Error)

    var errorMessage: String {
        switch self {
        case .network:
            return "Fetching Error Occured."
        case .decoding:
            return "Decoding Error Occured."
        }
    }
}


class APIManager {
    
    func getApiData<T:Decodable>(requestUrl: URL, completionHandler:@escaping(NetworkResponse<T, NetworkError>) -> Void) {
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        request.addValue("Client-ID 4442d2bb442f675", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (responseData, httpUrlResponse, error) in
            
            if(error == nil && responseData != nil && responseData?.count != 0) {
                //print(String.init(data: responseData!, encoding: .utf8))
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(.success(result))
                }
                catch let parsingError{
                    debugPrint("error occured while decoding = \(parsingError)")
                    _=completionHandler(.failure(.decoding(parsingError)))
                }
            } else {
                debugPrint("error = \(error!)")
                _=completionHandler(.failure(.network(error!)))
            }
            
        }.resume()
    }
}
