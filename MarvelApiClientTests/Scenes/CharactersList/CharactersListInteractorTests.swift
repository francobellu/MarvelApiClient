//
//  CharactersListInteractorTest.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

// Test the GetCharactersListInteractorInputPort interface ( Presenter --> Interactor)
//  - func execute()
//
// Test that calling sut.execute() the workerSpy is called correctly ( getCharactersListCalled == true)
//
class GetCharactersListInteractorInputPortTest: XCTestCase {
  func testInteractorCallsWorkerToFetch(){
    // Given
    let mockAppDependencies = MockAppDependencies()
    let charactersWorkerSpy = CharacterWorkerSpy()
    mockAppDependencies.marvelApiClient = charactersWorkerSpy
    let sut = GetCharactersListInteractor(dependencies: mockAppDependencies)

    // When
    sut.execute()

    // Then
    XCTAssertTrue(charactersWorkerSpy.getCharactersListCalled, "getCharactersList() should be called")
  }
}

//------------------------ GetCharactersListInteractorOutputPort ------------------------

//  Test the GetCharactersListInteractorOutputPort interface ( Interactor --> Presenter )
//  - func domainData(characters: [CharacterResult])
//
// Test that calling sut.execute() the presenterSpy is called correctly ( domainDataCalled == true)
//
class GetCharactersListInteractorOutputPortTest: XCTestCase {
  func testDomainData(){
    // Given
    let mockAppDependencies = MockAppDependencies()
    let testResult = Result<DataContainer<GetCharacters.Response>, Error>.success(getResponse(from: "MockedResponseGetCharacters").data!)
//    guard case let .success(testDataContainer) = testResult else{
//      XCTAssertTrue(false, "result should have a valid dataContainer value")
//      fatalError()
//    }

    let charactersWorkerSpy = CharacterWorkerSpy()
    mockAppDependencies.marvelApiClient = charactersWorkerSpy
    let presenterSpy = PresenterSpy()
    let sut = GetCharactersListInteractor(dependencies: mockAppDependencies)
    sut.output = presenterSpy // TODO: tghis should be a fdummy

    // When
    sut.execute()


    // Then
    XCTAssertTrue(presenterSpy.domainDataCalled, "getCharactersList() should be called")
//
//
//    guard case let .success(dataContainer) = presenterSpy.result else{
//      XCTAssertTrue(false, "result should have a valid dataContainer value")
//      fatalError()
//    }
//    guard case let .failure(error) = presenterSpy.result else{
//      XCTAssertTrue(false, "result should have a valid dataContainer value")
//      fatalError()
//    }
//
////    let marvelError: MarvelError? = error as? MarvelError
//
//    guard case MarvelError.noData = error else{
//      XCTAssertTrue( false, "result should be MarvelError.noData")
//      fatalError()
//    }

//    XCTAssertTrue(presenterSpy.result == testDataContainer, "getCharactersList() should be called")
  }
}

// MOCKs

class CharacterWorkerSpy: MarvelApiProtocol {

  var getCharactersListCalled = false

  init() {
  }

  func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {
    getCharactersListCalled = true
    let result = Result<DataContainer<GetCharacters.Response>, Error>.failure(MarvelError.noData)
    completion(result)
  }

  func getCharacter(with id: Int, completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {
    getCharactersListCalled = true
  }

  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    fatalError()
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    fatalError()
  }
}

class PresenterSpy: GetCharactersListInteractorOutputPort {

  var domainDataCalled = false

  var result = Result<DataContainer<GetCharacters.Response>, Error>.success(getResponse(from: "MockedResponseGetCharacters").data!)

//  var fakeOkResult: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
//  var fakeFailResult: Error = MarvelError.noData

  func domainData(result: Result<DataContainer<GetCharacters.Response>, Error>) {
    domainDataCalled = true
    self.result = result

//    switch result {
//    case .success(let dataContainer):
//      fakeOkResult = dataContainer.results
//    case .failure(let error):
//      fakeFailResult = error
//    }
//    self.fakeOkResult = characters
  }
}

//
//
//class CharactersListInteractorTest: XCTestCase {
//
//  var sut: GetCharactersListInteractor! // swiftlint:disable:this implicitly_unwrapped_optional
//
//  let mockAppDependencies = MockAppDependencies()
//  var mockApiClient: MockApiClient!{
//    mockAppDependencies.marvelApiClient as? MockApiClient
//  }
//  let interactorOutputPortMock = GetCharactersListInteractorOutputPortMock()
//
//  override func setUpWithError() throws {
//    sut = GetCharactersListInteractor(dependencies: mockAppDependencies)
//    sut.output = interactorOutputPortMock
//  }
//
//  // MARK: - Business logic
//  func testSuccess() throws {
//    // CONFIGURE THE MOCK DATA WITH AN ARRAY OF EMPTY CharacterResult
//    let testResponse: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
//    XCTAssertTrue(testResponse.code == 200)
//    guard let testData = testResponse.data else{
//      XCTAssert(true, "data should exist")
//      return
//    }
//    XCTAssertTrue(testData.results.count == 20 )
//    sut.execute()
//
//    XCTAssertNotNil(interactorOutputPortMock.characters)
//    XCTAssertNotNil(interactorOutputPortMock.characters.count == testData.results.count)
//  }
//
//  func testFailure() throws {
//    let response: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
//    XCTAssertTrue(response.code == 404)
//    sut.execute()
//  }
//}







//------- Mock Objects

//class GetCharactersListInteractorOutputPortMock: GetCharactersListInteractorOutputPort{
//  var characters = [CharacterResult]()
//  func domainData(characters: [CharacterResult]) {
//     self.characters = characters
//  }
//}
