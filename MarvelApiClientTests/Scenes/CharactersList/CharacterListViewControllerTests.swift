//
//  CharacterListViewControllerTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
import XCTest

@testable import MarvelApiClient

//final class CharacterListViewControllerTests1: XCTestCase {
//
//  var testCharacters: [CharacterResult] {
//    getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
//  }
//
//  var sut: CharactersListViewController!
//  var dataSourceMock: UITableViewDataSource!
//
//  override func setUp() {
//
//    // SUT
//    sut = CharactersListViewController.instantiateViewController()
//    sut.loadViewIfNeeded()
//
//    // DataSource & Delegate Mock
//    dataSourceMock = DelegateDatasourceMock()
//  }
//
//  override func tearDown() {
//    sut = nil
//    dataSourceMock = nil
//  }
//}

final class CharacterListViewControllerTests: XCTestCase {

  var testCharacters: [CharacterResult] {
    getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
  }

  var sut: CharactersListViewController!
  var presenterMock: CharacterListPresenterMock!
  var dataSourceMock: UITableViewDataSource!

  override func setUp() {
    presenterMock = CharacterListPresenterMock()
//    presenterMock.cellViewModels.value = testCharacters.map{ CharacterCellViewModel(character: $0) }

    sut = CharactersListViewController.instantiateViewController()
    sut.presenter = presenterMock
    sut.loadViewIfNeeded()
  }

  override func tearDown() {
    sut = nil
    presenterMock = nil
  }

  // MARK: Initialization

  func testSutIsNotNil() {
    XCTAssertNotNil(sut)
  }

  // MARK: Outlets initialized
  func testOutletsConnectedWhenViewIsLoaded() {
    XCTAssertNotNil(sut.tableView)
    XCTAssertNotNil(sut.activityIndicator)
  }

//  // MARK: Life cycle
//  func testViewDidLoadIsCalledFromViewDidLoad() {
//    XCTAssertTrue( 1 == presenterMock.viewDidLoadCalled, line: #line)
//
//    XCTAssertTrue( sut.activityIndicator.isAnimating == true, line: #line)
//  }

  // MARK: - Title
  func testTitleIsSet() {
    // Given
    let testTitle = "testTitle"
    let titleExp = XCTestExpectation(description: "TitleIsSet")

    // When
    presenterMock.title.completion = {
      titleExp.fulfill()
    }
    presenterMock.title.value = testTitle

    // Then
    wait(for: [titleExp], timeout: 5)
    XCTAssertTrue( sut.title == testTitle, line: #line)
  }

  // MARK: - Title
  func testActivityIndicator() {
    // Given
    let testIsLoadingFalse = false
    let titleExp = XCTestExpectation(description: "IsLoading")
    presenterMock.isLoading.completion = {
      titleExp.fulfill()
    }

    // When
    presenterMock.isLoading.value = testIsLoadingFalse

    // Then
    wait(for: [titleExp], timeout: 5)
    XCTAssertTrue( sut.activityIndicator.isAnimating == false, line: #line)
  }

  // MARK: - TableView

//  func testControllerHasTableView() {
//      XCTAssertNotNil(sut.tableView,
//                      "Controller should have a tableview")
//  }

  func testTableViewDataSourceIsCharactersListPresenterToViewProtocol() {
      XCTAssertTrue(sut.tableView.dataSource is CharactersListPresenterToViewProtocol,
                    "TableView's data source should be a CharactersListPresenterToViewProtocol")
  }

  // TODO: Move to datasource tests
  func testTableView_Empty() {
    // Given
    let tableViewMock = UITableView()

    // When

    // Then
    let count = sut.tableView(tableViewMock, numberOfRowsInSection: 0)
    XCTAssertTrue( count == 0, line: #line)
  }

  // TODO: Move to datasource tests
  func testTableView_NotEmpty() {
    // Given
    let tableViewMock = UITableView()

    presenterMock.cellViewModels.value = testCharacters.map{ CharacterCellViewModel(character: $0) }

    // prepare the test data
    presenterMock.testCharacterCellViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }

    // When

    // Then
    let count = sut.tableView(tableViewMock, numberOfRowsInSection: 0)
    XCTAssertTrue( count == 20, line: #line)
  }

  func testTableViewHasCells() {
      let cell = sut.tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.characterCellId.identifier)

      XCTAssertNotNil(cell, "TableView should be able to dequeue cell with identifier: 'Cell'")
  }

  // MARK: Local data getters
  func testCharactersCount() {
    _ = presenterMock.charactersCount()
    XCTAssertTrue( 1 == presenterMock.charactersCountCalled, line: #line)
  }

  //  MARK: User Interaction
  func testDidGoBack() {
    sut.goBack()
    XCTAssertTrue( 1 == presenterMock.viewDidGoBackCalled, line: #line)
  }

  // MARK: Async calls

  func testTableView_NotEmpty_getNextCharactersList() {
    // Given
    let tableViewMock = UITableView()

    // prepare the test data
    presenterMock.testCharacterCellViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }

    // When
    presenterMock.getNextCharactersList()

    // Then
    let count = sut.tableView(tableViewMock, numberOfRowsInSection: 0)
    XCTAssertTrue( count == 20, line: #line)
  }


  // MARK: UI sub components
  //  func testActivityIndicator() {
  //    s
  //    presenter.didSelectCharacter(at: 0)
  //    XCTAssertTrue( 1 == presenter., file: #filePath, line: #line)
  //  }
}


final class CharacterListViewController_DataSourceTests: XCTestCase {
  var sut: UITableViewDataSource!
  var presenterMock: CharacterListPresenterMock!
  var tableViewMock: UITableView!
  var vc: CharactersListViewController!
  var testCellsViewModel: [CharacterCellViewModel] = []

  override func setUp() {
    super.setUp()

    // The DataSource is the SUT
    presenterMock = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    testCellsViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }

    vc = CharactersListViewController.instantiateViewController()
    vc.presenter = presenterMock
    vc.loadViewIfNeeded()

    sut = vc

    tableViewMock = UITableView()
    tableViewMock.register(CharacterCell.self, forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    tableViewMock.estimatedRowHeight = 44
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
    vc = nil
    presenterMock = nil
  }

  func testNumberOfRows() {
    // Given
    let tableViewMock2 = UITableView() // even more simple table view for this test

    // When
    vc.presenter.cellViewModels.value = testCellsViewModel

    // Then
    let numberOfRows = sut.tableView(tableViewMock2, numberOfRowsInSection: 0)
    XCTAssertTrue( 1 == presenterMock.charactersCountCalled, line: #line)
    XCTAssertEqual(numberOfRows, 20, "Number of rows in table should match number of items in the presenter")
  }

  func testHasZeroSectionsWhenZeroCellModelViews() {
    // Given

    // When
    vc.presenter.cellViewModels.value = []

    // Then
    XCTAssertEqual(sut.numberOfSections!(in: tableViewMock), 0, "TableView should have zero sections when no items are present")
  }

  func testHasOneSectionWhenItemsArePresent() {
    // Given

    // When
    vc.presenter.cellViewModels.value = testCellsViewModel

    // Then
    XCTAssertEqual(sut.numberOfSections!(in: tableViewMock), 1, "TableView should have 1 sections when items are present")
  }

  func testCellForRow() {

    // Given

    // When
    vc.presenter.cellViewModels.value = testCellsViewModel

    // Then
    let cell = sut.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 0)) as! CharacterCell
    XCTAssertEqual(cell.title.text, "3-D Man", "The first cell should display name of first character")
  }
//----------------------------------------------------------------------------------------------------//

  func testTableViewDelegateIsViewController() {
    XCTAssertTrue(vc.tableView.delegate === sut,
                  "Controller should be delegate for the table view")
  }
}

//----------------------------------------------------------------------------------------------------//

final class CharacterListViewController_TableViewDelegateTests: XCTestCase {

  var sut: UITableViewDelegate!
  var presenterMock: CharacterListPresenterMock!
  var tableViewMock: UITableView!
  var vc: CharactersListViewController!
  var testCellsViewModel: [CharacterCellViewModel] = []

  override func setUp() {
    super.setUp()
    // The DataSource is the SUT
    presenterMock = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    testCellsViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }

    vc = CharactersListViewController.instantiateViewController()
    vc.presenter = presenterMock
    vc.loadViewIfNeeded()

    sut = vc

    tableViewMock = UITableView()
    tableViewMock.register(CharacterCell.self, forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    tableViewMock.estimatedRowHeight = 44
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
    vc = nil
    presenterMock = nil
  }

  // MARK: User Interaction
  func testDidSelectIsCalled() {
    sut.tableView!(tableViewMock, didSelectRowAt: IndexPath(row: 1, section: 0))
    XCTAssertTrue( 1 == presenterMock.didSelectCalled, line: #line)
  }
}

// MARK: Mocks

class CharacterListPresenterMock: CharactersListPresenterProtocol {
  var cellViewModels: Observable<[CharacterCellViewModel]>  = Observable(value:[])
  
  var title: Observable<String> = Observable.init(value:  "")
  
  var isLoading: Observable<Bool> = Observable.init(value: false)
  

  var numberOfSections: Int = 1

  // View life cycle
  func viewDidLoad() {
    viewDidLoadCalled += 1
  }

  // Local data getters
  func charactersCount() -> Int {
    charactersCountCalled += 1
    return cellViewModels.value.count
  }

  func getCharacter(at index: Int) -> CharacterResult {
    let viewModel = cellViewModels.value[index]
    let character = CharacterResult(name: viewModel.title, imageUrl: viewModel.imgViewUrl)
    return character
  }

  // Async calls
  func getNextCharactersList() {
    getNextCharactersListCalled += 1
    self.cellViewModels.value += self.testCharacterCellViewModel
  }

  // User Interaction
  //  func didSelectCharacter(at: Int) {
  //    viewDidSelectCalled += 1
  //  }

  func didGoBack() {
    viewDidGoBackCalled += 1
  }

  // MARK: - Mock infrastructure
  var viewDidLoadCalled = 0
  var viewDidSelectCalled = 0
  var viewDidGoBackCalled = 0
  var charactersCountCalled = 0
  var getNextCharactersListCalled = 0

  var testCharacterCellViewModel: [CharacterCellViewModel] = []

  var didSelectCalled = 0
  //    var charsCount = 0

  func didSelectCharacter(at: Int){
    didSelectCalled += 1
  }
}


