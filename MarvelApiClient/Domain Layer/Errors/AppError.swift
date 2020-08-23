//
//  AppError.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//enum AppError: Error{
//
//  // APP module
//  case marvelError_decoding
//  case marvelError_noMarvelData
//  case marvelError_insecureMD5Hash
//  case marvelError_rest
//  case restServiceError_noResponse
////  case restServiceError_networkFailure(NetworkError)
////  case restServiceError_restApiRequest(RestApiRequestError)
//  case networkError_responseCorrupted
//  case networkError_dataTaskCancelled
//  case networkError_notConnected
//  case networkError_statusCode(_: Int, data: Data? = nil)
//  case networkError_otherError(_ error: Error)
//}

public let moduleNameErrorDomain = "com.MarvelApiClient.App"

public enum AppErrorCode: ErrorCode {
  // APP module
  case marvelError_decoding
  case marvelError_noMarvelData
  case marvelError_insecureMD5Hash
  case marvelError_rest
  case restServiceError_noResponse
  case restServiceError_parsing
  //  case restServiceError_networkFailure(NetworkError)
  //  case restServiceError_restApiRequest(RestApiRequestError)
  case networkError_responseCorrupted
  case networkError_dataTaskCancelled
  case networkError_notConnected
//  case networkError_statusCode(_: Int, data: Data? = nil)
//  case networkError_otherError(_ error: Error)
}
