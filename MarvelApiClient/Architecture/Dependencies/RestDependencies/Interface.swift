//
//  File.swift
//  
//
//  Created by franco bellu on 29/07/2020.
//

import Foundation

////// TODO: what to do with this protocol?
////public protocol RestApiClientProtocol {
////  init(session: URLSessionProtocol)
////  func send<T: RestAPIRequest>(_ request: T, completion: @escaping URLRequestResultCompletion)
////  func cancel()
////}
//
//public enum RestMethod {
//    case get, post, put, patch, delete
//}
//
//// Encapsulate the Service configuration
//public protocol RestServiceConfigProtocol{
//  var baseEndpointString: String { get }
//  var publicKey: String? { get }
//  var privateKey: String? { get }
//
//  // The way the url is build is API specific
//  func buildEndpointUrl(for resourceName: String, and parameters: [String: String]? ) -> URL?
//}
//
///// All requests must conform to this protocol
///// - Discussion: You must conform to Encodable too, so that all stored public parameters
/////   of types conforming this protocol will be encoded as parameters.
//public protocol RestAPIRequest {
//
//  /// Response (will be wrapped with a DataContainer)
//  associatedtype Response: Decodable
//
//  /// Service data needed to construct the endpoint url
//  var apiRequestConfig: RestServiceConfigProtocol { get set}
//
//  /// Resource name needed to construct the endpoint url
//  var resourceName: String { get }
//
//  var method: RestMethod { get }
//
//  var parameters: [String: String]? { get }
//
//  ///  Decodes the  response data  stripping all the wrappers.  In the process  all the possible errors are handled
//  /// - Parameters:
//  ///   - data: The data as returned by the Service
//  /// - Returns: A Result encasulating the Response object requested by the request or an Error
//  func decode(_ data: Data) -> Result<Response,Error>
//
//}
