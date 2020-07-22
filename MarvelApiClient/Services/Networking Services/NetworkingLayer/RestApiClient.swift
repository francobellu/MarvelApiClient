//
//  RestApiClient.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

enum NetworkError: Error{
  case dataCorrupted
}

// Protocol for MOCK/Real session
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

// MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class RestApiClient {

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol = URLSession(configuration: .default)) {
    self.session = session
  }

  public typealias NetworkCompletion = (Result<(URLResponse, Data), Error>) -> Void
  public typealias NetworkCompletionResult = Result<(URLResponse, Data), Error>

  /// Sends a request to Marvel servers, calling the completion method when finished
  func send<T: APIRequest>(_ request: T, completion: @escaping NetworkCompletion) {
    // CREATE THE URL INCLUDING THE PARAMETERS
    guard let endpoint = request.endpoint() else { return }
    print("Request: \(endpoint)")
    let task = session.dataTask(with: URLRequest(url: endpoint)) { data, response, error in
      var result: NetworkCompletionResult
      if let error = error {
        result = .failure(error)
      }
      if let response = response, let data = data  {
        // debug: print json data before to decode
        print(data)
        if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
          print("Data: \(data),  json: \(jsonData)")
        }
        result = .success((response, data))
      } else{
        result = .failure(NetworkError.dataCorrupted)
      }
      completion(result)
    }
    task.resume()
  }
}
