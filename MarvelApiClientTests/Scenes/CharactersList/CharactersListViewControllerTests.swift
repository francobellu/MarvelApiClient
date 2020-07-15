//
//  CharactersListViewControllerTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
import XCTest

@testable import MarvelApiClient

final class CharactersListViewControllerTests: XCTestCase {

  var testCharacters: [CharacterResult] {
    getObjects(from: "MockedResponseGetCharacters")
  }

  var sut: CharactersListViewController!
  var presenterMock: CharacterListPresenterMock!
  var dataSourceMock: UITableViewDataSource!

  override func setUpWithError() throws {
    presenterMock = CharacterListPresenterMock()

    sut = CharactersListViewController.instantiateViewController()
    sut.presenter = presenterMock

    XCTAssertTrue( presenterMock.viewDidLoad.value == false, line: #line)
    sut.loadViewIfNeeded()
    XCTAssertTrue( presenterMock.viewDidLoad.value == true, line: #line)
  }

  override func tearDownWithError() throws {
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

  // MARK: - Title
  func testTitleIsSet() {
    
    // Given
    let titleExp = XCTestExpectation(description: "TitleIsSet")

    presenterMock.title.valueChanged = { [weak self] (title) in
      self?.sut.title = title
      titleExp.fulfill()
    }

    let testTitle = "testTitle"

    // When
    presenterMock.title.value = testTitle

    // Then
    wait(for: [titleExp], timeout: 5)
    XCTAssertTrue( sut.title == testTitle, line: #line)
  }

  // MARK: - Title
  func testActivityIndicator_setToFalse() {

    // Given
    let testIsLoadingFalse = false
    sut.activityIndicator.startAnimating()
    XCTAssertTrue( sut.activityIndicator.isAnimating == true, line: #line)
    let isLoadingExp = XCTestExpectation(description: "IsLoading")

    presenterMock.isLoading.valueChanged = { [weak self] (isLoading) in
      self?.sut.isLoadingChanged(isLoading)
      isLoadingExp.fulfill()
    }

    // When
    presenterMock.isLoading.value = testIsLoadingFalse

    // Then
    wait(for: [isLoadingExp], timeout: 5)
    XCTAssertTrue( sut.activityIndicator.isAnimating == false, line: #line)
  }

  func testActivityIndicator_setToTrue() {
    // Given
    let testIsLoadingTrue = true
    let isLoadingExp = XCTestExpectation(description: "IsLoading")
    XCTAssertTrue( sut.activityIndicator.isAnimating == false, line: #line)

    presenterMock.isLoading.valueChanged = { [weak self] (isLoading) in
      self?.sut.isLoadingChanged(isLoading)
      isLoadingExp.fulfill()
    }

    // When
    presenterMock.isLoading.value = testIsLoadingTrue

    // Then
    wait(for: [isLoadingExp], timeout: 5)
    XCTAssertTrue( sut.activityIndicator.isAnimating == true, line: #line)
  }

  func testPrepareView() {
    // Given
    let navContr = UINavigationController()
    navContr.pushViewController(sut, animated: false)

    // When
    sut.prepareView()

    // Then
    guard let navigationController = sut.navigationController else {
      XCTAssert(false, "sut should have a NavigationBar")
      return
    }
    
    guard let leftBtn = sut.navigationItem.leftBarButtonItem else {
      XCTAssert(false, "leftBtn should exist")
      return
    }

    XCTAssertTrue(leftBtn.title == "Back", line: #line)
    XCTAssertFalse(navigationController.interactivePopGestureRecognizer!.isEnabled )
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

    let isLoadingExp = XCTestExpectation(description: "IsLoading")

    presenterMock.cellPresentationModels.valueChanged = {  (cellPresentationModels) in
      tableViewMock.reloadData()
      isLoadingExp.fulfill()
    }

    // When
    presenterMock.cellPresentationModels.value = testCharacters.map{ CharacterCellPresentationModel(character: $0) }

    // Then
    wait(for: [isLoadingExp], timeout: 5)
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
    presenterMock.testCharacterCellViewModel = testCharacters.map{ CharacterCellPresentationModel(character: $0) }

    // When
    presenterMock.getNextCharactersList()

    // Then
    let count = sut.tableView(tableViewMock, numberOfRowsInSection: 0)
    XCTAssertTrue( count == 20, line: #line)
  }
}

final class CharacterListViewController_DataSourceTests: XCTestCase {
  var sut: UITableViewDataSource!
  var presenterMock: CharacterListPresenterMock!
  var tableViewMock: UITableView!
  var vc: CharactersListViewController!
  var testCellsViewModel: [CharacterCellPresentationModel] = []

  override func setUpWithError() throws {

    // The DataSource is the SUT
    presenterMock = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
    testCellsViewModel = testCharacters.map{ CharacterCellPresentationModel(character: $0) }

    vc = CharactersListViewController.instantiateViewController()
    vc.presenter = presenterMock
    vc.loadViewIfNeeded()

    sut = vc

    tableViewMock = UITableView()
    tableViewMock.register(CharacterCell.self, forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    tableViewMock.estimatedRowHeight = 44
  }

  override func tearDownWithError() throws {
    sut = nil
    vc = nil
    presenterMock = nil
  }

  func testNumberOfRows() {
    // Given
    let tableViewMock2 = UITableView() // even more simple table view for this test

    // When
    vc.presenter.cellPresentationModels.value = testCellsViewModel

    // Then
    let numberOfRows = sut.tableView(tableViewMock2, numberOfRowsInSection: 0)
    XCTAssertEqual(numberOfRows, 20, "Number of rows in table should match number of items in the presenter")
  }

  func testHasZeroSectionsWhenZeroCellModelViews() {
    // Given

    // When
    vc.presenter.cellPresentationModels.value = []

    // Then
    XCTAssertEqual(sut.numberOfSections!(in: tableViewMock), 0, "TableView should have zero sections when no items are present")
  }

  func testHasOneSectionWhenItemsArePresent() {
    // Given

    // When
    vc.presenter.cellPresentationModels.value = testCellsViewModel

    // Then
    XCTAssertEqual(sut.numberOfSections!(in: tableViewMock), 1, "TableView should have 1 sections when items are present")
  }

  func testCellForRow() {

    // Given

    // When
    vc.presenter.cellPresentationModels.value = testCellsViewModel

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
  var testCellsViewModel: [CharacterCellPresentationModel] = []

  override func setUpWithError() throws {
    // The DataSource is the SUT
    presenterMock = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
    testCellsViewModel = testCharacters.map{ CharacterCellPresentationModel(character: $0) }

    vc = CharactersListViewController.instantiateViewController()
    vc.presenter = presenterMock
    vc.loadViewIfNeeded()

    sut = vc

    tableViewMock = UITableView()
    tableViewMock.register(CharacterCell.self, forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    tableViewMock.estimatedRowHeight = 44
  }

  override func tearDownWithError() throws {
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
  var viewDidLoad: Observable<Bool> = Observable(value:false)

  var cellPresentationModels: Observable<[CharacterCellPresentationModel]>  = Observable(value:[])
  
  var title: Observable<String> = Observable.init(value:  "")
  
  var isLoading: Observable<Bool> = Observable.init(value: false)
  

  var numberOfSections: Int = 1


  // Local data getters
  func charactersCount() -> Int {
    charactersCountCalled += 1
    return cellPresentationModels.value.count
  }

  // Async calls
  func getNextCharactersList() {
    getNextCharactersListCalled += 1
    self.cellPresentationModels.value += self.testCharacterCellViewModel
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

  var testCharacterCellViewModel: [CharacterCellPresentationModel] = []

  var didSelectCalled = 0
  //    var charsCount = 0

  func didSelectCharacter(at: Int){
    didSelectCalled += 1
  }
}


