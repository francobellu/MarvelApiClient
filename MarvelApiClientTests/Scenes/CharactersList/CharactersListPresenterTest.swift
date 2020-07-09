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
  var mockIterator: MockCharactersListInteractor!
//
  var testResults: [CharacterResult]! = nil

  override func setUpWithError() throws{
    
    testResults = getObjects(from: "MockedResponseGetCharacters")

    mockIterator =  MockCharactersListInteractor(dependencies: mockAppDependencies)

    mockIterator.mockCharactersListInteractorData.mockCharactersResults = testResults

    sut = CharactersListPresenter(dependencies: mockAppDependencies,
                                  coordinatorDelegate: mockCoordinator,
                                  interactor: mockIterator!)
  }

  func test() throws {

    // Given
    XCTAssert(sut.charactersCount() == 0 )

    // When
    sut.getNextCharactersList()
    XCTAssert(sut.charactersCount() == 20 )

    // TEST character at index 0 has expected id - getCharacter(at:)
    let character = self.sut.getCharacter(at: 0)
    XCTAssert(character.id == testResults.first!.id)

    XCTAssert(self.mockCoordinator.coordinatorState == .none)
    self.sut.didGoBack()
    self.mockCoordinator.coordinatorState = .didSelect(character: character)
  }
}
//
//class VCMock: XCTestCase {
//  var presenter: CharactersListPresenterProtocol! // swiftlint:disable:this implicitly_unwrapped_optional
//
//  var cellViewModelsChanged = false
//  var titleChanged = false
//  var activityIndicatorChanged = false
//
//  private func initBinding() {
//
//    // TableView
//    presenter.cellViewModels.valueChanged = { [weak self] (_) in
//      self?.cellViewModelsChanged = true
////      self?.tableViewXX.reloadData()
//    }
//
//    // Title
////    self.title = presenter.title.value
//    presenter.title.valueChanged = { [weak self] (title) in
//      self?.titleChanged = true
////      self?.title = title
//    }
//
//    // ActivityIndicator
////    updateLoadingStatus()
//    presenter.isLoading.valueChanged = { [weak self] (isLoading) in
//      self?.activityIndicatorChanged = true
////      self?.updateLoadingStatus()
//    }
//  }
//}
