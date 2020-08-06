//
//  RestAPIRequest.swift
//  
//
//  Created by franco bellu on 29/07/2020.
//

import Foundation

/// All requests must conform to this protocol
/// - Discussion: You must conform to Encodable too, so that all stored public parameters
///   of types conforming this protocol will be encoded as parameters.
public protocol RestAPIRequest{

  /// Response (will be wrapped with a DataContainer)
  associatedtype Response: Decodable

  var apiRequestConfig: RestServiceConfigProtocol { get set}

  /// Endpoint for this request (the last part of the URL)
  var resourceName: String { get }
  var method: RestMethod { get }
  var parameters: [String: String]? { get }
  func decode(_ data: Data) -> Result<Response, Error>

}

// Encapsulate the Service configuration
public protocol RestServiceConfigProtocol{
  var baseEndpointString: String { get }
  var publicKey: String? { get }
  var privateKey: String? { get }

  // The way the url is build is API specific
  func buildEndpointUrlFor(resourceName: String, parameters: [String: String]? ) -> URL?
}
