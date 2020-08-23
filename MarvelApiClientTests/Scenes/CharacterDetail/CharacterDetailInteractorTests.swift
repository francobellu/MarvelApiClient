//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
//
//import XCTest
//import Rest
//@testable import MarvelApiClient
//
//
//class CharacterDetailInteractorTest: XCTestCase {
//  var sut: CharacterDetailInteractor! // swiftlint:disable:this implicitly_unwrapped_optional
//
//  let appDependenciesDummy = AppDependenciesDummy()
////  var mockApiClient: MockApiClient!
//
//
//  override func setUpWithError() throws {
//    //    mockApiClient = appDependenciesDummy.marvelApiClient as? MockApiClient
//    sut = CharacterDetailInteractor(dependencies: appDependenciesDummy)
//  }
//
//  // MARK: - TEST Business logic
//
//  /// TEST  sut creation using init(dependencies: AppDependenciesProtocol, character: CharacterResult)
//  func testSuccess() throws {
//
//    // CONFIGURE THE MOCK DATA
//    let testCharacters: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
//    let getCharacterMock = GetCharacterMock(mockCharacterResults: testCharacters)
//
//    let testCharacter = testCharacters.first!
//    sut.getCharacter(with: testCharacter.id!) { result in
//
//      switch result {
//      case .success(let character):
//          XCTAssertNotNil(character)
//          XCTAssertNotNil(character.id == testCharacter.id)
//          return
//      case .failure:
//        XCTAssert(false)
//      }
//    }
//  }
//
//  class GetCharacterMock: MarvelApiRequest{
//    var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()
//    
//    let mockCharacterResults: [CharacterResult]?
//
//    var resourceName = "characters"
//
//    var method = RestMethod.get
//
//    var parameters: [String : String]?
//
//    var restDependencies: RestDependenciesProtocol = RestDependenciesMock(sessionNextData: mockCharacterResults)
//
//    typealias Response = [CharacterResult]
//    init(mockCharacterResults: [CharacterResult]? = nil ) {
//      self.mockCharacterResults = mockCharacterResults
//    }
//
//    func execute(completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
//      if let result = mockCharacterResults{
//        completion(.success(result))
//      } else{
//        completion(.failure(MarvelError.noData))
//      }
//    }
//  }
////  func testFailure() throws {
////
////    // CONFIGURE THE MOCK DATA WITH NIL
////    mockApiClient.mockApiClientData.mockCharacterResults = nil
////
////    let testCharacterId = 0
////    sut.getCharacter(with: testCharacterId, completion: { characterResult in
////      // TEST characters
////      XCTAssertNil(characterResult)
////    })
////  }
//}
