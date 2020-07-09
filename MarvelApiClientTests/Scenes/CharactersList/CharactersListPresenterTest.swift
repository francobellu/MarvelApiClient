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

class CharactersListPresenterTest: XCTestCase {
  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  lazy var mockIterator: MockCharactersListInteractor = {
    let mockInteractor = MockCharactersListInteractor(dependencies: mockAppDependencies)
    print("FB: mockInteractor:")
    print(Unmanaged.passUnretained(mockInteractor).toOpaque())
    return mockInteractor
  }()

  var testResults: [CharacterResult]! = nil

  override func setUpWithError() throws{
    // Given
//    testResults = getObjects(from: "MockedResponseGetCharacters")
    mockIterator.mockCharactersListInteractorData = getObjects(from: "MockedResponseGetCharacters")

    // When
    sut = CharactersListPresenter(dependencies: mockAppDependencies,
                                  coordinatorDelegate: mockCoordinator,
                                  interactor: mockIterator)

    // Then
    XCTAssertTrue(sut.title.value == "Marvel Comics")
  }

  override func tearDownWithError() throws {
    testResults = nil
    sut = nil
  }

  func testIsLoading() throws {

    // Given
    XCTAssert(sut.isLoading.value ==  false)

    let exp = XCTestExpectation(description: "wait for list")
    sut.isLoading.completion = {
      exp.fulfill()
    }

    // When
    sut.getNextCharactersList()
    XCTAssert(sut.isLoading.value ==  true)

    // Then
    wait(for: [exp], timeout: 50)
    XCTAssert(sut.isLoading.value ==  false)
  }

  func testGetNextCharactersList() throws {

    // Given
    XCTAssert(sut.cellViewModels.value.isEmpty )

    let exp = XCTestExpectation(description: "wait for list")
    sut.cellViewModels.completion = {
      exp.fulfill()
    }

    // When
    sut.getNextCharactersList()

    // Then
    wait(for: [exp], timeout: 50)
    print("FB: sut.cellViewModels.value.count: \(sut.cellViewModels.value.count)")
    XCTAssert(sut.cellViewModels.value.count == 20 )
  }

  func testDidSelect() throws{
    // Given
    XCTAssert(sut.cellViewModels.value.isEmpty )

    let exp = XCTestExpectation(description: "wait for list")
    sut.cellViewModels.completion = {
      exp.fulfill()
    }

    sut.getNextCharactersList()
    wait(for: [exp], timeout: 50)

    // When
    self.sut.didSelectCharacter(at: 0)

    // Then

    XCTAssert(sut.cellViewModels.value.count == 20 )
    let viewModel = sut.cellViewModels.value[0]
    let character = CharacterResult(name: viewModel.title, imageUrl: viewModel.imgViewUrl)

    XCTAssert(self.mockCoordinator.coordinatorState ==  .didSelect(character: character))
  }

  func testDidGoBack() throws {
      // Given
      XCTAssert(sut.cellViewModels.value.isEmpty )

      // When
      self.sut.didGoBack()

      // Then
      XCTAssert(self.mockCoordinator.coordinatorState ==  .didGoBack)
    }
}

