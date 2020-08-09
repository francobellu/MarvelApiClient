//
//  CharactersListInteractorTest.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

// The interactor has:
// - one input function: execute()
// - one output function: domainData()
//
// Test Plan. We can test:
// 1) The right funcions are called as a consequence of calling interactor API execute():
//  1.1) the right worker API is called -> worker SPY needed
//  1.2) the outputPort  API (presenter) delegate function domainData() is called  ->  worker SPY needed
//
// 2) As a consequence of calling interactor API execute(), the worker returns some data that is passed to the output port.
//    Test that the result generated by the worker is the same as the one reeived by the output port. -> worker STUB needed
//  2.1) Test success result case
//  2.2) Test failure result case ( MarvelError.noData)

class GetCharactersListInteractorInputPortTest: XCTestCase {

  // Test 1.1
  //
  // Test the GetCharactersListInteractorInputPort interface ( Presenter --> Interactor)
  //  - func execute()
  //
  // Test that calling sut.execute() the worker function is called correctly
  // For that a charactersWorkerSpy is needed
  func testInteractorCallsWorkerToFetch(){
    // Given
    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependencies())
    let charactersWorkerSpy = CharacterWorkerTestDouble()
    appDependenciesDummy.marvelApiClient = charactersWorkerSpy
    let sut = GetCharactersListInteractor(dependencies: appDependenciesDummy)

    // When
    sut.execute()

    // Then
    XCTAssertTrue(charactersWorkerSpy.getCharactersListCalled, "getCharactersList() should be called")
  }

  // Test 1.2
  //
  // Test the GetCharactersListInteractorOutputPort interface ( Interactor --> Presenter )
  //  - func domainData(characters: [CharacterResult])
  //
  // Test that calling sut.execute() the presenter delegate method is called correctly
  // For that presenter Spy is needed
  // Also we need a workerFake that returns a resultDummy ( it is needed to compile but it is not actually used by the test)
  func testDomainData(){
    // Given
    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependencies())
    let charactersWorkerSpy = CharacterWorkerTestDouble()
    appDependenciesDummy.marvelApiClient = charactersWorkerSpy

    let presenterSpy = PresenterTestDouble()
    let sut = GetCharactersListInteractor(dependencies: appDependenciesDummy)
    sut.outputPort = presenterSpy // TODO: this should be a dummy

    // When
    sut.execute()

    // Then
    XCTAssertTrue(presenterSpy.domainDataCalled, "getCharactersList() should be called")
  }

  // Test 2.1
  // As a consequence of calling interactor API execute(), the worker returns some data that is passed to the output port.
  // Test that the result generated by the worker is the same as the one received by the output port. -> worker STUB needed
  //
  func testDomainData_SuccessResult(){
    // Given

    let testData = mockResponseData(for: "MockedResponseGetCharacters")
    let testResult = Result<[Character], Error>.success(getCharactersEntitities(from: "MockedResponseGetCharacters")!)
    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependenciesMock(sessionNextData: testData))
    let presenterSpy = PresenterTestDouble()
    let sut = GetCharactersListInteractor(dependencies: appDependenciesDummy)
    sut.outputPort = presenterSpy

    // When
    sut.execute()

    // Then
    guard case let .success(characters) = presenterSpy.result else{
      XCTAssertTrue(false, "result should have a valid dataContainer value")
      return
    }
    guard case let .success(testCharacters) = testResult else{
      XCTAssertTrue(false, "result should have a valid dataContainer value")
      return
    }

    XCTAssertTrue(characters == testCharacters, "The result received by the presenter is not correct")
  }

  // Test 2.2
  // As a consequence of calling interactor API execute(), the worker returns some data that is passed to the output port.
  // Test that the result generated by the worker is the same as the one received by the output port. -> worker STUB needed
  //
  func testDomainData_FailureResult_NoData(){
    // Given
    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependencies())

    // Initialize a worker Stub with a test  result
    let testResult = Result<GetCharacters.Response, Error>.failure(MarvelError.noData)
    let charactersWorkerStub = CharacterWorkerTestDouble(stubbedResult: testResult)

    charactersWorkerStub.stubbedResult = testResult

    appDependenciesDummy.marvelApiClient = charactersWorkerStub
    let presenterSpy = PresenterTestDouble()
    let sut = GetCharactersListInteractor(dependencies: appDependenciesDummy)
    sut.outputPort = presenterSpy // TODO: tghis should be a fdummy

    // When
    sut.execute()

    // Then
    guard case let .failure(error) = presenterSpy.result else{
      XCTAssertTrue(false, "result should have a valid error value")
      return
    }

    // Assert the error is MarvelError.noData
    guard case MarvelError.noData = error else{
      XCTAssertTrue( false, "result should be MarvelError.noData")
      return
    }
  }
}

// MARK: ------------------------ Test Doubles ------------------------

class CharacterWorkerTestDouble: MarvelApiProtocol {

  var getCharactersListCalled = false
  var stubbedResult: Result<GetCharacters.Response, Error>?

  init(stubbedResult: Result<GetCharacters.Response, Error>? = nil) {
    // use a default result
    self.stubbedResult = Result<GetCharacters.Response, Error>.failure(MarvelError.noData)
  }

  func getCharactersList(completion: @escaping (Result<GetCharacters.Response, Error>) -> Void) {
    getCharactersListCalled = true

    // Need to call campletion to test outputPort
    completion(stubbedResult!)
  }

  func getCharacter(with id: Int, completion: @escaping (Result<GetCharacters.Response, Error>) -> Void) {
    getCharactersListCalled = true
  }

  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    fatalError()
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    fatalError()
  }
}

class PresenterTestDouble: GetCharactersListInteractorOutputPort {
//  func domainData(result: Result<[GetCharacters.Response], Error>) {
//    <#code#>
//  }
  
  var domainDataCalled = false

  var result =  Result<[Character], Error>.failure(MarvelError.noData)
//  {
//    let dtos: [CharacterResult] =  getResponse(from: "MockedResponseGetCharacters").data!.results
//    let characters = dtos.map{$0.toDomain()}
//    return .success( characters )
//  }

  func domainData(result: Result<[Character], Error>) {
    domainDataCalled = true
    self.result = result
  }
}
