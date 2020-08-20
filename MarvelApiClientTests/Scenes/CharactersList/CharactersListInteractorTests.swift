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
//  1.1) the Repository API is called -> repository SPY needed
//  1.2) the outputPort  API (presenter) delegate function domainData() is called  ->  repository SPY needed
//
// 2) As a consequence of calling interactor API execute(), the repository returns some data that is passed to the output port.
//    Test that the result generated by the repository is the same as the one reeived by the output port. -> repository STUB needed
//  2.1) Test success result case
//  2.2) Test failure result case ( MarvelError.noData)

class GetCharactersListInteractorInputPortTest: XCTestCase {


  // Test 1.1
  //
  // Test the GetCharactersListInteractorInputPort interface ( Presenter --> Interactor)
  //  - func execute()
  //
  // Test that calling sut.execute() the repository function is called correctly
  // For that a charactersRepositorySpy is needed
  func testInteractorCallsRepositoryToFetch(){
    // Given
    let testResult = Result<[Character], Error>.success(getCharactersEntitities(from: "MockedResponseGetCharacters")!)
    let charactersRepositorySpy =  CharactersRepositoryMock(mockResult: testResult)

//    let marvelApiConfig = MarvelApiRequestConfig()
//    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependencies(marvelApiConfig: marvelApiConfig), charactersRepositoryMock: charactersRepositorySpy)
    let sut = GetCharactersListInteractor(charactersRepository: charactersRepositorySpy)

    // When
    sut.execute()

    // Then
    XCTAssertTrue(charactersRepositorySpy.getCharactersListCalled, "getCharactersList() should be called")
  }

  // Test 1.2
  //
  // Test the GetCharactersListInteractorOutputPort interface ( Interactor --> Presenter )
  //  - func domainData(characters: [CharacterResult])
  //
  // Test that calling sut.execute() the presenter delegate method is called correctly
  // For that presenter Spy is needed
  // Also we need a repositoryFake that returns a resultDummy ( it is needed to compile but it is not actually used by the test)
  func testDomainData(){
    // Given

    let testResult = Result<[Character], Error>.success(getCharactersEntitities(from: "MockedResponseGetCharacters")!)
//    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependenciesMock(sessionNextData: Data()), charactersRepositoryMock: CharactersRepositoryMock(mockResult: testResult))
    let charactersRepositorySpy =  CharactersRepositoryMock(mockResult: testResult)
    
//    let charactersRepositorySpy = CharacterRepositoryTestDouble()
//    appDependenciesDummy.marvelApiClient = charactersRepositorySpy

    let presenterSpy = PresenterTestDouble()
    let sut = GetCharactersListInteractor(charactersRepository: charactersRepositorySpy)
    sut.outputPort = presenterSpy // TODO: this should be a dummy

    // When
    sut.execute()

    // Then
    XCTAssertTrue(presenterSpy.domainDataCalled, "getCharactersList() should be called")
  }

  // Test 2.1
  // As a consequence of calling interactor API execute(), the repository returns some data that is passed to the output port.
  // Test that the result generated by the repository is the same as the one received by the output port. -> Repository STUB needed
  //
  func testDomainData_SuccessResult(){
    // Given

    let testData = mockResponseData(for: "MockedResponseGetCharacters")
    let testResult = Result<[Character], Error>.success(getCharactersEntitities(from: "MockedResponseGetCharacters")!)
//    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependenciesMock(sessionNextData: testData), charactersRepositoryMock: CharactersRepositoryMock(mockResult: testResult))
    let presenterSpy = PresenterTestDouble()
    let charactersRepositorySpy =  CharactersRepositoryMock(mockResult: testResult)
    let sut = GetCharactersListInteractor(charactersRepository: charactersRepositorySpy)
    
    sut.outputPort = presenterSpy

    // Create async exp for the async interactor.getCharacters  operation
//    let exp = XCTestExpectation(description: "")

    // When
    sut.execute()

//    wait(for: [exp], timeout: 5)
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
  // As a consequence of calling interactor API execute(), the Repository returns some data that is passed to the output port.
  // Test that the result generated by the Repository is the same as the one received by the output port. -> Repository STUB needed
  //
  func testDomainData_FailureResult_NoData(){
    // Given

    // Initialize a Repository Stub with a test  result
     let testResult = Result<[Character], Error>.failure(MarvelError.noData)

    let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependenciesMock(sessionNextData: Data()), charactersRepositoryMock: CharactersRepositoryMock())

//    let charactersRepositoryStub = CharacterRepositoryTestDouble(stubbedResult: testResult)

//    charactersRepositoryStub.stubbedResult = testResult

//    appDependenciesDummy.marvelApiClient = charactersRepositoryStub
    let presenterSpy = PresenterTestDouble()
    let charactersRepositorySpy =  CharactersRepositoryMock(mockResult: testResult)
    let sut = GetCharactersListInteractor(charactersRepository: charactersRepositorySpy)
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

class CharacterRepositoryTestDouble: MarvelApiProtocol {

  var getCharactersListCalled = false
  var stubbedResult: Result<[CharacterResult], Error>?

  init(stubbedResult: Result<[CharacterResult], Error>? = nil) {
    // use a default result
    self.stubbedResult = Result<[CharacterResult], Error>.failure(MarvelError.noData)
  }

  func getCharactersList(completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
    getCharactersListCalled = true

    // Need to call campletion to test outputPort
    completion(stubbedResult!)
  }

  func getCharacter(with id: Int, completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
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

class CharactersRepositoryMock: CharactersRepository {
  //    @discardableResult
  let mockResult: Result<[Character], Error>
  var getCharactersListCalled = false

  init(mockResult: Result<[Character], Error> = .failure(MarvelError.noData) ){
    self.mockResult = mockResult
  }

  func getCharactersList( //query: MovieQuery, page: Int,
    //                         cached: @escaping (MoviesPage) -> Void,
    completion: @escaping (Result<[Character], Error>) -> Void)// -> Cancellable?
  {
    getCharactersListCalled = true
    completion(mockResult)
  }

  func getCharacter(with id: Int, completion: @escaping (Result<Character, Error>) -> Void){

  }
}
