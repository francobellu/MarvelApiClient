//
//  HttpClient.swift
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

internal class HttpClient {

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol = URLSession(configuration: .default)) {
    self.session = session
  }

  /// Sends a request to Marvel servers, calling the completion method when finished
  internal func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<DataContainer<T.Response>>) {
    // swiftlint:disable:previous function_body_length
    // CREATE THE URL INCLUDING THE PARAMETERS
    guard let endpoint = request.endpoint() else { return }

    print("Request: \(endpoint)")
    let task = session.dataTask(with: URLRequest(url: endpoint)) { data, _, error in
      if let data = data {
        do {
          // Decode the top level response, and look up the decoded response to see
          // if it's a success or a failure

          //let marvelResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                 // try to read out a string array

          let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
          dump(marvelResponse)
          if let dataContainer = marvelResponse.data {
            completion(.success(dataContainer))
            //self.offset +=  self.limit
          } else {
            completion(.failure(MarvelError.decoding))
          }
        } catch {
          // TODO: What to do whith this?
          let errorData = try? JSONDecoder().decode(ErrorResponse.self, from: data)
          completion(.failure(error))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
}
