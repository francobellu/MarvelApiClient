//
//  CharactersListPresenterTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

import XCTest
@testable import MarvelApiClient

// Interface analysis
//
// - Inputs from View:
//    - CharactersListPresenterProtocol ( V -> P)
//      - 1-4) binding elements.
//      - 5) getNextCharactersList()
//      - 6) didSelectCharacter(at index: Int)
//      - 7) didGoBack()
// - Input from Interactor:
//    - GetCharactersListInteractorOutputPort ( P -> I)
//      - 8) domainData(result: Result<DataContainer<GetCharacters.Response>, Error>)
//
//
// Test Plan. We can test:
// 1 - 4) For each binded data, changing the data in the P, the caller's callback is called. -> need a SPY variable. Test needs to be aync because Observable executes on async queue

// 5) domainData(result:)
//  5.1) with success result
//  5.2) with failure result
// 6) When calling getNextCharactersList() , then the OutputPort.domainData(result) is called asyncronously. Need a Spy
// 7) Calling didSelectCharacter(at index: Int), the C's didSelect() is called. -> need a Coordinator SPY
//  Also test that the presentationModel passed to the C is correct
// 8) Calling didGoBack(), the C's didGoBack() is called. -> need a Coordinator SPY

/// Test the 4 bindings
class CharactersListPresenterTest: XCTestCase {
  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  let marvelApiConfig = MarvelApiRequestConfig()
  lazy var appDependenciesDummy = {
    AppDependenciesDummy(restDependencies: RestDependencies(marvelApiConfig: marvelApiConfig), charactersRepositoryMock: ( CharactersRepositoryMock()))
  }()
  var coordinatorSpy: CharactersListCoordinatorDelegateSpy!

//  var mockView: CharactersListPresenterToViewMock!

//  let mockCharactersListView =
  lazy var interactorStub = CharactersListInteractorTestDouble()

  var testResults: [CharacterResult]! = nil

  override func setUpWithError() throws {
    // Given
    coordinatorSpy = CharactersListCoordinatorDelegateSpy()

//    interactorSpy.mockCharactersListInteractorData = getObjects(from: "MockedResponseGetCharacters")

    // When
    sut = CharactersListPresenter(dependencies: appDependenciesDummy,
                                  coordinatorDelegate: coordinatorSpy,
                                  interactor: interactorStub)

//    mockView = CharactersListPresenterToViewMock(presenter: sut)

//    mockInterator.output = sut
    // Then
    XCTAssertTrue(sut.title.value == charactersListTitle)
  }

  override func tearDownWithError() throws {
    coordinatorSpy = nil
//    mockView = nil
    testResults = nil
    sut = nil
  }

  // Test 1.1
  // Changing the data in the P, the caller's callback is called. -> need a SPY variable. Test needs to be aync because Observable executes on async queue
  func testIsLoadingBinding() throws {

    // Given
    var isLoadingSpy = false
    XCTAssertFalse(sut.isLoading.value)
    let testValue = true

    // Create async exp for the async interactor.getCharacters  operation
    let isLoadingExp = XCTestExpectation(description: "Wait for Async binding callback for isLoading")

    // Bind isLoading value change to a mock closure
    sut.isLoading.valueChanged = { isLoading in
      isLoadingSpy = true
      isLoadingExp.fulfill()
    }

    // When
    sut.isLoading.value = testValue

    // Then
    wait(for: [isLoadingExp], timeout: 5)  // wait for the async Observable callback
    XCTAssertEqual(isLoadingSpy, testValue)
  }
  // Test 1.2
  // Changing the data in the P, the caller's callback is called. -> need a SPY variable. Test needs to be aync because Observable executes on async queue
  func testViewDidLoadBinding() throws {

    // Given
    var viewDidLoadSpy = false
    XCTAssertFalse(sut.isLoading.value)
    let testValue = true

    // Create async exp for the async interactor.getCharacters  operation
    let viewDidLoadExp = XCTestExpectation(description: "Wait for Async binding callback for isLoading")

    // Bind isLoading value change to a mock closure
    sut.viewDidLoad.valueChanged = { viewDidLoad in
      viewDidLoadSpy = true
      viewDidLoadExp.fulfill()
    }

    // When
    sut.viewDidLoad.value = testValue

    // Then
    wait(for: [viewDidLoadExp], timeout: 5)  // wait for the  async MockCharactersListInteractor.execute()
    XCTAssertEqual(viewDidLoadSpy, testValue)
  }

  // Test 1.3
  // Changing the data in the P, the caller's callback is called. -> need a SPY variable. Test needs to be aync because Observable executes on async queue
  func testTitleBinding() throws {

    // Given
    var titleSpy = ""
    XCTAssertEqual(sut.title.value, charactersListTitle)
    let testValue = "TestTitle"

    // Create async exp for the async interactor.getCharacters  operation
    let titleExp = XCTestExpectation(description: "Wait for Async binding callback for isLoading")
    // Bind isLoading value change to a mock closure
    sut.title.valueChanged = { title in
      titleSpy = title
      titleExp.fulfill()
    }

    // When
    sut.title.value = testValue

    // Then
    wait(for: [titleExp], timeout: 5)  // wait for the  async MockCharactersListInteractor.execute()
    XCTAssertEqual(titleSpy, testValue)
  }

  // Test 1.4
  // Changing the data in the P, the caller's callback is called. -> need a SPY variable. Test needs to be aync because Observable executes on async queue
  func testPresentationModelBinding() throws {

    // Given
    var presentationModelSpy = [CharacterCellPresentationModel]()
    XCTAssertFalse(sut.isLoading.value)
    let characters: [Character] = ( getDtos(from: "MockedResponseGetCharacters") as [CharacterResult] ).map {$0.toDomain()}
    let presentationModel = buildPresentationModels(from: characters)
    let testValue = presentationModel

    // Create async exp for the async interactor.getCharacters  operation
    let presentationModelExp = XCTestExpectation(description: "Wait for Async binding callback for isLoading")

    // Bind isLoading value change to a mock closure
    sut.presentationModel.valueChanged = { presentationModel in
      presentationModelSpy = presentationModel
       presentationModelExp.fulfill()
    }

    // When
    sut.presentationModel.value = presentationModel

    // Then
    wait(for: [presentationModelExp], timeout: 5)  // wait for the  async MockCharactersListInteractor.execute()
    XCTAssertEqual(presentationModelSpy, testValue)
  }

  func testIsErrorBinding() throws {

    // Given
    var errorSpy =  MarvelError.none
    XCTAssertFalse(sut.isLoading.value)
    let testValue = MarvelError.noMarvelData

    // Create async exp for the async interactor.getCharacters  operation
    let presentationModelExp = XCTestExpectation(description: "Wait for Async binding callback for isLoading")

    // Bind isLoading value change to a mock closure
    sut.isError.valueChanged = { error in
      guard let error = error else { fatalError()}
      errorSpy = error as! MarvelError
      presentationModelExp.fulfill()
    }

    // When
    sut.isError.value = testValue

    // Then
    wait(for: [presentationModelExp], timeout: 5)  // wait for the  async MockCharactersListInteractor.execute()

    // Assert the error is MarvelError.noData
    guard case MarvelError.noMarvelData = errorSpy else {
      XCTAssertTrue( false, "result should be MarvelError.noData")
      return
    }
  }

  // Test 5.1
  // Test when calling domainData(result:) with success result, the presentationModel is correct
  func testDomainDataWithResultSuccess() throws {

    // Given
    XCTAssert(sut.presentationModel.value.isEmpty)
    let testCharacters = getCharactersEntitities(from: "MockedResponseGetCharacters")

    let testSuccessCharacters = Result<[Character], Error>.success(testCharacters!)
    guard case let .success(characters) = testSuccessCharacters else {
      XCTAssertTrue(false, "result should have a valid dataContainer value")
      return
    }
    let resultPresentationModel = buildPresentationModels(from: characters)

    // When
    sut.domainData(result: testSuccessCharacters)

    // Then
    XCTAssert(sut.presentationModel.value == resultPresentationModel )
  }

  // Test 5.2
  // Test when calling domainData(result:) with failure MarvelError.noData result, the presentationModel is empty and the error received is correct
  func testDomainDataWithResultFailureNoData() throws {

    // Given
    XCTAssert(sut.presentationModel.value.isEmpty)

    let testResultFailureNoData = Result<[Character], Error>.failure(MarvelError.noMarvelData)

    // When
    sut.domainData(result: testResultFailureNoData)

    // Then
    XCTAssert(sut.presentationModel.value.isEmpty)
  }

  // Test 6
  // Calling getNextCharactersList(), then I's getNextCharactersList is called, which will call the OutputPort.domaninData(result:) function
  // -> need to Stub Interactor and a GetCharactersListInteractorOutputPort Spy to test it is called
  func testGetNextCharactersList() throws {

    // Given
    let getCharactersExp = XCTestExpectation(description: "Wait for the async op to execute")
    // Set up interactorStub
    interactorStub.asyncOpExpectation = getCharactersExp
    let testDomainDataCalledSpy = false
    let outputSpy = GetCharactersListInteractorOutputPortSpy(domainDataCalledSpy: testDomainDataCalledSpy)
    interactorStub.output = outputSpy

    // When
    sut.getNextCharactersList()
    wait(for: [getCharactersExp], timeout: 5) // wait for the  async Observabvle object

    // Then
    XCTAssert(outputSpy.domainDataCalledSpy == true )
  }

  // Test 7
  //  Calling didSelectCharacter(at index: Int), the presentationModel passed to the C is correct
  //  Also test that the C's didSelect() is called. -> need a Coordinator SPY
  func testDidSelect() throws {
    // Given
    XCTAssert(sut.presentationModel.value.isEmpty )

    let characters: [Character]! = getCharactersEntitities(from: "MockedResponseGetCharacters")
    let presentationModel = buildPresentationModels(from: characters)
    let testValue = presentationModel

    sut.presentationModel.value = testValue
    XCTAssert(sut.presentationModel.value.count == testValue.count )

    // When
    self.sut.didSelectCharacter(at: 0)

    // Then
    XCTAssert(sut.presentationModel.value.count == 20 )
    let viewModel = sut.presentationModel.value[0]
    let character = Character(name: viewModel.title, imageUrl: viewModel.imgViewUrl)

    XCTAssert(coordinatorSpy.coordinatorState ==  .didSelect(character: character))
  }

  // Test 8
  func testDidGoBack() throws {
    // Given
    XCTAssert(sut.presentationModel.value.isEmpty )

    // When
    self.sut.didGoBack()

    // Then
    XCTAssert(coordinatorSpy.coordinatorState ==  .didGoBack)
  }
}

// MARK: - ----------------------- Test Doubles ------------------------

class CharactersListInteractorTestDouble: GetCharactersListInteractorInputPort {
  weak var output: GetCharactersListInteractorOutputPort?

  var executeCalled = false

  var stubbedResult = Result<[Character], Error>.failure(MarvelError.noMarvelData)
  var asyncOpExpectation: XCTestExpectation?

  func execute() {
    executeCalled = true
    DispatchQueue.global().async {
      self.output?.domainData(result: self.stubbedResult )
      self.asyncOpExpectation?.fulfill()
    }
  }
}

class CharactersListCoordinatorDelegateSpy: CharactersListCoordinatorDelegate {
  enum CoordinatorState: Equatable {
    static func == (lhs: CoordinatorState, rhs: CoordinatorState) -> Bool {

      switch (lhs, rhs) {
      case (.none, .none):
        return true
      case (.didGoBack, .didGoBack):
        return true
      case (.didSelect, .didSelect):
        return true
      default:
        return false
      }
    }

    case none
    case didGoBack
    case didSelect(character: Character)
  }
  var coordinatorState: CoordinatorState = .none

  func didGoBack() {
    coordinatorState  = .didGoBack
  }

  func didSelect(character: Character) {
    coordinatorState  = .didSelect(character: character)
  }
}

class GetCharactersListInteractorOutputPortSpy: GetCharactersListInteractorOutputPort {
  var domainDataCalledSpy = false
  init(domainDataCalledSpy: Bool = false) {
    self.domainDataCalledSpy = domainDataCalledSpy
  }

  func domainData(result: Result<[Character], Error>) {
    domainDataCalledSpy = true
  }
}
