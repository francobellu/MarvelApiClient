////
////  CharactersListPresenterTests.swift
////  MarvelApiClientTests
////
////  Created by franco bellu on 20/05/2020.
////  Copyright © 2020 BELLU Franco. All rights reserved.
////
//
//import Foundation
//
//import XCTest
//@testable import MarvelApiClient
//
////class CharactersListPresenterToViewMock: CharactersListPresenterToViewProtocol{
////  var title = ""
////  var cellPresentationModelsChangedCalled = false
////  var viewDidLoadChangedCalled = false
////  var isLoadingChangedCalled = false
////  var prepareViewCalled = false
////
////  var expectation: XCTestExpectation?
////
////  var presenter: CharactersListPresenterProtocol!
////
//////  lazy var viewDidLoadChanged: ((Bool) -> Void)? = {  [weak self] (viewDidLoad) in
//////    self?.viewDidLoadChangedCalled = true
//////  }
//////
//////  lazy var titleChanged: ((String) -> Void)? = {[weak self] (title) in
//////    self?.title = title
//////  }
//////  lazy var cellPresentationModelsChanged: (([CharacterCellPresentationModel]) -> Void)? = { [weak self] (_) in
//////    DispatchQueue.main.async {
//////      self?.cellPresentationModelsChangedCalled = true
//////      self?.expectation?.fulfill()
//////    }
//////  }
//////
//////  func isLoadingChanged(_: Bool) -> Void  {
//////    isLoadingChangedCalled = true
//////  }
////
////  init(presenter: CharactersListPresenterProtocol) {
////    self.presenter = presenter
//////    initBinding()
////  }
////
//////  private func initBinding() {
//////    // viewDidLoad
//////    presenter.viewDidLoad.valueChanged = viewDidLoadChanged
//////
//////    // Title
//////    presenter.title.valueChanged = titleChanged
//////
//////    // TableView
//////    presenter.cellPresentationModels.valueChanged = cellPresentationModelsChanged
//////
//////    // ActivityIndicator
//////    presenter.isLoading.valueChanged = isLoadingChanged
//////  }
////
////
////  func prepareView(){
////    prepareViewCalled = true
////  }
////}
//
//class MockCharactersListInteractor: GetCharactersListInteractorInputPort{
//  weak var output: GetCharactersListInteractorOutputPort?
//
//  var mockCharactersListInteractorData:  [CharacterResult]?
//
//  required init(dependencies: AppDependenciesProtocol) {
//  }
//
//  func execute() {
//    DispatchQueue.global().async {
//      self.output?.domainData(result: self.mockCharactersListInteractorData! )
//    }
//  }
//}
//
///// Test the 4 bindings
//class CharactersListPresenterTest: XCTestCase {
//  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
//  var mockAppDependencies =  MockAppDependencies()
//  var mockCoordinator:  MockCharactersListCoordinatorDelegate!
//
////  var mockView: CharactersListPresenterToViewMock!
//
////  let mockCharactersListView =
//  lazy var mockInterator = MockCharactersListInteractor(dependencies: mockAppDependencies)
//
//  var testResults: [CharacterResult]! = nil
//
//  override func setUpWithError() throws{
//    // Given
//    mockCoordinator = MockCharactersListCoordinatorDelegate()
//
//
//    mockInterator.mockCharactersListInteractorData = getObjects(from: "MockedResponseGetCharacters")
//
//    // When
//    sut = CharactersListPresenter(dependencies: mockAppDependencies,
//                                  coordinatorDelegate: mockCoordinator,
//                                  interactor: mockInterator)
//
////    mockView = CharactersListPresenterToViewMock(presenter: sut)
//
//    mockInterator.output = sut
//    // Then
//    XCTAssertTrue(sut.title.value == "Marvel Comics")
//  }
//
//  override func tearDownWithError() throws {
//    mockCoordinator = nil
////    mockView = nil
//    testResults = nil
//    sut = nil
//  }
//
//  func testIsLoading() throws {
//
//    // Given
//    var isLoadingCalledTimes = 0
//    XCTAssertFalse(sut.isLoading.value)
//
//    // Create async exp for the async interactor.getCharacters  operation
//    let getCharactersExp = XCTestExpectation(description: "Wait for Characters")
//
//    // Bind isLoading value change to a mock closure
//    sut.isLoading.valueChanged = { isLoading in
//      isLoadingCalledTimes += 1
//    }
//
//    // Bind cellPresentationModels value change to a mock closure
//    sut.cellPresentationModels.valueChanged = { (_) in
//      DispatchQueue.main.async {
//        getCharactersExp.fulfill()
//      }
//    }
//
//    // When
//    sut.getNextCharactersList()
//    XCTAssertTrue(sut.isLoading.value)
//
//    // Then
//    wait(for: [getCharactersExp], timeout: 5)  // wait for the  async MockCharactersListInteractor.execute()
//    XCTAssertFalse(sut.isLoading.value)
//    XCTAssertEqual(isLoadingCalledTimes, 2)
//  }
//
//  func testGetNextCharactersList() throws {
//
//    // Given
//    XCTAssert(sut.cellPresentationModels.value.isEmpty )
//    let getCharactersExp = XCTestExpectation(description: "Wait for Characters")
//
//    // Bind cellPresentationModels value change to a mock closure
//    sut.cellPresentationModels.valueChanged = {(_) in
//      DispatchQueue.main.async {
//        getCharactersExp.fulfill()
//      }
//    }
//
//    // When
//    sut.getNextCharactersList()
//
//    // Then
//    wait(for: [getCharactersExp], timeout: 5) // wait for the  async MockCharactersListInteractor.execute()
//    print("FB: sut.cellPresentationModels.value.count: \(sut.cellPresentationModels.value.count)")
//    XCTAssert(sut.cellPresentationModels.value.count == 20 )
//  }
//
//  func testDidSelect() throws{
//    // Given
//    XCTAssert(sut.cellPresentationModels.value.isEmpty )
//
//    let getCharactersExp = XCTestExpectation(description: "wait for list")
//
//    // Bind cellPresentationModels value change to a mock closure
//    sut.cellPresentationModels.valueChanged = { (_) in
//      DispatchQueue.main.async {
//        getCharactersExp.fulfill()
//      }
//    }
//
//    sut.getNextCharactersList()
//    wait(for: [getCharactersExp], timeout: 5)
//
//    // When
//    self.sut.didSelectCharacter(at: 0)
//
//    // Then
//    XCTAssert(sut.cellPresentationModels.value.count == 20 )
//    let viewModel = sut.cellPresentationModels.value[0]
//    let character = CharacterResult(name: viewModel.title, imageUrl: viewModel.imgViewUrl)
//
//    XCTAssert(self.mockCoordinator.coordinatorState ==  .didSelect(character: character))
//  }
//
//  func testDidGoBack() throws {
//      // Given
//      XCTAssert(sut.cellPresentationModels.value.isEmpty )
//
//      // When
//      self.sut.didGoBack()
//
//      // Then
//      XCTAssert(self.mockCoordinator.coordinatorState ==  .didGoBack)
//    }
//}
//
