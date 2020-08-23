//
//  AppErrorBuilder.swift
//  MarvelApiClient
//
//  Created by franco bellu on 23/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

//import Foundation
//
//public class AppErrorBuilder: NSObject, ErrorBuilder {
//
//  public class func error(forCode code: ErrorCode) -> NSError {
//    var userInfo = [String: Any]()
//    userInfo[NSLocalizedDescriptionKey] = localizedDescriptionForCode(code: code)
//    userInfo[NSLocalizedFailureReasonErrorKey] = failureReasonForCode(code: code)
//    return NSError(domain: moduleNameErrorDomain, code: code, userInfo: userInfo)
//  }
//
//  private class func localizedDescriptionForCode(code: ErrorCode) -> String {
//    switch code {
////    case AppErrorCode.anErrorCase.rawValue:
////      return NSLocalizedString("your localised error description", comment: "ModuleName")
//    default:
//      return NSLocalizedString("your localised error description", comment: moduleNameErrorDomain)
//    }
//  }
//
//  private class func failureReasonForCode(code: ErrorCode) -> String {
//    switch code {
////    case AppErrorCode.anErrorCase.rawValue:
////      return NSLocalizedString("your localised error failure reason", comment: "ModuleName")
//    default:
//       return NSLocalizedString("your localised error failure reason", comment: moduleNameErrorDomain)
//    }
//  }
//}
