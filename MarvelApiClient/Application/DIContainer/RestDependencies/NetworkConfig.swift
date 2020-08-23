//
//  ServiceConfig.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

public protocol NetworkConfigurable {
  var baseURL: URL { get }

  var urlParameters: [String: String]? { get }
  var encodableUrlParameters: Encodable? { get }

  var headerParamaters: [String: String]? { get }

  var bodyParameters: [String: String]? { get }
  var encodableBodyParamaters: Encodable? { get }

}

public struct ApiNetworkConfiguration: NetworkConfigurable {
  public let baseURL: URL

  public let urlParameters: [String: String]?
  public var encodableUrlParameters: Encodable?

  public var headerParamaters: [String: String]?

  public var bodyParameters: [String: String]?
  public var encodableBodyParamaters: Encodable?

  public var bodyEncoding: BodyEncoding?

  public init(baseURL: URL,
              headerParamaters: [String: String]?,
              urlParameters: [String: String]?,
              bodyEncoding: BodyEncoding = .jsonSerializationData
  ) {
    self.baseURL = baseURL
    self.headerParamaters = headerParamaters
    self.urlParameters = urlParameters
    self.bodyEncoding = bodyEncoding
    }
}
