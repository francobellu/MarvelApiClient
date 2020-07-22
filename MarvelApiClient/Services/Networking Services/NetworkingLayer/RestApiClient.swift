//
//  RestApiClient.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

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

  /// Sends a request to Marvel servers, calling the completion method when finished
  func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<DataContainer<T.Response>>) {
    // swiftlint:disable:previous function_body_length
    // CREATE THE URL INCLUDING THE PARAMETERS
    guard let endpoint = request.endpoint() else { return }

    print("Request: \(endpoint)")
    let task = session.dataTask(with: URLRequest(url: endpoint)) { data, _, error in
      if let data = data {
        do {
          // debug: print json data before to decode
          print(data)
          let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
          print("Data: \(data),  json: \(jsonData)")
          let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
          print("FB: marvelResponse: \(marvelResponse)")
          if let dataContainer = marvelResponse.data {
            completion(.success(dataContainer))
          } else {
            completion(.failure(MarvelError.decoding))
          }
        } catch {
          _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
          completion(.failure(MarvelError.decoding))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}
