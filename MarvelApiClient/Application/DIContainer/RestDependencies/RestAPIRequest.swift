//
//  RestAPIRequest.swift
//  
//
//  Created by franco bellu on 29/07/2020.
//

import Foundation

//public protocol NetworkCancellable {
//    func cancel()
//}
//
//public enum NetworkError: Error{
//  case dataTaskCancelled
//  case generic(message: String)
//  case error(_ error: Error)
//  case notConnected
//  case authenticationError
//  case badRequest
//  case outdated
//  case unableToDecode
//}
//
//public enum RestServiceError: Error {
//    case noResponse
//    case parsing(Error)
//    case networkFailure(NetworkError)
//    case resolvedNetworkFailure(Error)
//}
//
//public protocol RestServiceErrorLogger {
//  func log(error: Error)
//}
//
//public protocol ResponseRequestable {
////    associatedtype Response
//
//  //    var responseDecoder: ResponseDecoder { get }
//  /// Response (will be wrapped with a DataContainer)
//  associatedtype Response: Decodable
//
//  func decode(_ data: Data) -> Result<Response, Error>
//}





////// All requests must conform to this protocol
/// - Discussion: You must conform to Encodable too, so that all stored public parameters
///   of types conforming this protocol will be encoded as parameters.
public protocol RestAPIRequest: ResponseRequestable{

//  /// Response (will be wrapped with a DataContainer)
//  associatedtype Response: Decodable
//
//  func decode(_ data: Data) -> Result<Response, Error>

  var resourceName: String { get }

  var method: RestMethod { get }

  var urlParameters: [String: String]? { get }
  var encodableUrlParameters: Encodable?  { get }

  var headerParamaters: [String: String]? { get }

  var bodyParameters: [String: String]? { get }
  var encodableBodyParamaters: Encodable?  { get }

  var bodyEncoding: BodyEncoding? { get }



  func extractApiObjectFrom(_ data: Data) -> Result<Self.Response, Error>
}

enum RequestGenerationError: Error {
    case components
}

extension RestAPIRequest{

  ///  Decodes the  response data  stripping all the wrappers.  In the process  all the possible errors are handled
  /// - Parameters:
  ///   - data: The data as returned by the Service
  /// - Returns: A Result encasulating the response object for the request or an Error
  func decode(_ data: Data) -> Result<Response, Error> {
    return extractApiObjectFrom(data)
  }

  // Encodes a URL based on the given request using
  // Create a URLComponents url composing:
  // 1) baseUrl = baseEndpointUrl +  request.resourceName
  // 2) commonQueryItems ( marvel-specific params)
  // 3) customQueryItems ( request-specific params)

  private func url(with config: NetworkConfigurable) throws -> URL {

    // Construct the URL including the url encoced parameters ( api parameters + request-specific parameters)

    let completeUrl = URL(string: resourceName, relativeTo: config.baseURL)
    let completeUrl2 =  (completeUrl != nil) ?  completeUrl! : config.baseURL

    guard var urlComponents = URLComponents(url: completeUrl2, resolvingAgainstBaseURL: true) else { throw RequestGenerationError.components }

    // Build common query items needed for all Marvel requests
    var commonApiItems: [URLQueryItem]? = nil
    if let apiUrlParams = config.urlParameters{
      commonApiItems = buildApiQueryItems(apiParams: apiUrlParams)
      print(apiUrlParams)
    }

    // Build customQueryItems ( request-specific params)
    let customQueryItems = buildCustomQueryItems(urlParameters)

    urlComponents.queryItems = commonApiItems

    if let customQueryItems = customQueryItems{
      urlComponents.queryItems?.append(contentsOf: customQueryItems)
    }

    guard let url = urlComponents.url else { throw RequestGenerationError.components }

    return url
  }

  public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {

    let url = try self.url(with: config)
    var urlRequest = URLRequest(url: url)

    // headerParamaters can override apiConfig.headers
    var allHeaders: [String: String]? = nil
    if let apiHeaders = config.headerParamaters{
      allHeaders = apiHeaders // get a mutable copy
      if let reqHeaders = headerParamaters  {
        reqHeaders.forEach { allHeaders!.updateValue($1, forKey: $0) }
      }
    }

    // Body parametrers can be either in the encodable form ( to be decoded as dictionary) or ar already as dictionary
    let bodyParamaters = try encodableBodyParamaters?.toDictionary() ?? self.bodyParameters
    if let bodyParams = bodyParamaters, !bodyParams.isEmpty, let bodyEncoding = bodyEncoding {
      urlRequest.httpBody = encodeBody(bodyParamaters: bodyParams, bodyEncoding: bodyEncoding)
    }
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = allHeaders
    return urlRequest
  }

  //   func apiUrlParams(config: ApiNetworkConfiguration) throws -> [String: String]{
  //
//    let timestamp = "\(Date().timeIntervalSince1970)"
//    let str = "\(timestamp)\(configprivateKey)\(publicKey)"
//    guard let digest =  str.insecureMD5Hash() else { throw MarvelError.encoding }
//
//    let result = [ "ts": timestamp,
//                   "hash": digest,
//                   "apikey": publicKey ]
//
//    return result
//  }

  private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        case .stringEncodingAscii:
            return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }


  // Build commonQueryItems ( marvel-specific params)
  private func buildApiQueryItems(apiParams: [String: String]) -> [URLQueryItem]?{

    return apiParams.map{ ( key, value)  in
      URLQueryItem(name: key, value: value)
    }
  }

  // Build customQueryItems ( request-specific params)
  private func buildCustomQueryItems(_ parameters: [String: String]?) -> [URLQueryItem]?{
    var result: [URLQueryItem]? = nil
    if let params = parameters, !params.isEmpty {
      result = params.map { item, value in
        URLQueryItem(name: item, value: value)
      }
    }
    return result
  }
}

//// Encapsulate the Service configuration
//public protocol RestServiceConfigProtocol{
//  var baseEndpointString: String { get }
//  var publicKey: String { get }
//  var privateKey: String { get }
//
//  // The way the url is build is API specific
//  func buildEndpointUrlFor(resourceName: String, parameters: [String: String]? ) -> URL?
//}


private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }
}
