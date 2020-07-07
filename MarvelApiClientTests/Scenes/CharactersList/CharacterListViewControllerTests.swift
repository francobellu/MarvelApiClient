//
//  CharacterListViewControllerTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
import XCTest

@testable import MarvelApiClient


final class CharacterListViewControllerTests: XCTestCase {

  var testCharacters: [CharacterResult] {
    getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
  }

  var sut: CharactersListViewController!
  var presenterMock: CharacterListPresenterMock!

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
    XCTAssertNotNil(sut.tableViewOutlet)
    XCTAssertNotNil(sut.activityIndicator)
  }

  // MARK: Life cycle
  func testViewDidLoadIsCalledFromViewDidLoad() {
    XCTAssertTrue( 1 == presenterMock.viewDidLoadCalled, line: #line)

    XCTAssertTrue( sut.activityIndicator.isAnimating == true, line: #line)
  }

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

  func testTableView_Empty() {
    // Given
    let testCellViewModels = Observable<[CharacterCellViewModel]>(value: [])
    let tableViewExp = XCTestExpectation(description: "testCellViewModels == 0")
    presenterMock.cellViewModels.completion = {
      tableViewExp.fulfill()
    }

    // When
    presenterMock.cellViewModels.value = testCellViewModels.value

    // Then
    wait(for: [tableViewExp], timeout: 5)
    let count = sut.tableView.numberOfRows(inSection: 0)
    XCTAssertTrue( count == 0, line: #line)
  }

  func testTableView_NotEmpty() {
    // Given
    let tableViewExp = XCTestExpectation(description: "testCellViewModels != 0")

    presenterMock.cellViewModels.completion = {
      tableViewExp.fulfill()
    }

//    presenterMock.cellViewModels.value = testCharacters.map{ CharacterCellViewModel(character: $0) }

    // prepare the test data
    presenterMock.testCharacterCellViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }

    // When
    presenterMock.cellViewModels.completion = { tableViewExp.fulfill() }
    presenterMock.getNextCharactersList()

    // Then
    wait(for: [tableViewExp], timeout: 100)
    let count = sut.tableView.numberOfRows(inSection: 0)
    XCTAssertTrue( count != 0, line: #line)
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
//  var delegateDatasource: DelegateDatasourceMock!
  var tableViewMock: UITableView!
  var vc: CharactersListViewController!
  var testCellsViewModel: [CharacterCellViewModel] = []

  override func setUp() {
    presenterMock = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    testCellsViewModel = testCharacters.map{ CharacterCellViewModel(character: $0) }
//
    vc = CharactersListViewController.instantiateViewController()
    vc.presenter = presenterMock
    vc.loadViewIfNeeded()

    sut = vc

  }

  override func tearDown() {
    sut = nil
    vc = nil
    presenterMock = nil
  }

  func testNumberOfRows() {
    // Given
    let tableView = UITableView()

    // When
    vc.presenter.cellViewModels.value = testCellsViewModel

    // Then
    let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertTrue( 1 == presenterMock.charactersCountCalled, line: #line)
    XCTAssertEqual(numberOfRows, 20, "Number of rows in table should match number of items in the presenter")
  }

  func testCellForRow() {
    tableViewMock = UITableView()
    tableViewMock.register(CharacterCell.self, forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    tableViewMock.estimatedRowHeight = 44

    // Given
    vc.presenter.cellViewModels.value = testCellsViewModel

    // When
    let cell = sut.tableView(tableViewMock, cellForRowAt: IndexPath(row: 0, section: 0)) as! CharacterCell

    // Then
    XCTAssertEqual(cell.title.text, "3-D Man", "The first cell should display name of first character")
  }
}

final class CharacterListViewController_TableViewDelegateTests: XCTestCase {

  var sut: CharactersListViewController!
  var presenter: CharacterListPresenterMock!
  var delegateDatasource: DelegateDatasourceMock!
  var tableViewMock: UITableView!

  override func setUp() {
    presenter = CharacterListPresenterMock()
    let testCharacters: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    presenter.cellViewModels.value = testCharacters.map{ CharacterCellViewModel(character: $0) }

    sut = CharactersListViewController.instantiateViewController()
    sut.presenter = presenter
    sut.loadViewIfNeeded()
  }

  override func tearDown() {
    sut = nil
    presenter = nil
  }

  // MARK: User Interaction
  func testDidSelectIsCalled() {
    let delegateDatasourceMock = DelegateDatasourceMock()
    delegateDatasourceMock.presenter = presenter
    tableViewMock = UITableView()
    //    tableViewMock.dataSource = sut
    //    tableViewMock.delegate = sut
    sut.tableViewOutlet = tableViewMock
    sut.tableView2(tableViewMock, indexPath: IndexPath(row: 1, section: 0))
    //    (sut as UITableViewDelegate).tableView!(tableViewMock , didSelectRowAt: IndexPath(row: 1, section: 0))
    //    delegateDatasourceMock.tableView(tableViewMock , didSelectRowAt: IndexPath(row: 1, section: 0))
    //    XCTAssertTrue( 1 == delegateDatasourceMock.didSelectCalled, file: #filePath, line: #line)
    XCTAssertTrue( 1 == presenter.didSelectCalled, line: #line)
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
    DispatchQueue.global().async {
      self.cellViewModels.value = self.testCharacterCellViewModel
    }
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
}

extension CharacterListPresenterMock: DelegateDatasourceProtocol{
  func didSelectCharacter(at: Int){
    didSelectCalled += 1
  }
}

protocol DelegateDatasourceProtocol {
  //  func didSelectCell(data: String)
  func didSelectCharacter(at: Int)
}

class DelegateDatasourceMock: NSObject, UITableViewDelegate, UITableViewDataSource {

  var data: [String]?

  var numberOfSessiontCalled = 0
  var numberOfRowsInSectionCalled = 0
  var cellForRowAtCalled = 0
  var didSelectCalled = 0
  weak var presenter: CharactersListPresenterProtocol?

  //MARK: Datasource
  func numberOfSections(in tableView: UITableView) -> Int {
    numberOfSessiontCalled += 1
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    numberOfRowsInSectionCalled += 1
    if let count = data?.count {
      return count
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellForRowAtCalled += 1
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = data?[indexPath.row]

    return cell
  }

  //MARK: Delegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    didSelectCalled += 1
    presenter?.didSelectCharacter(at: indexPath.row)
//    if let data = data?[indexPath.row] {
//      presenter?.didSelectCharacter(at: indexPath.row)
//    }
  }
}


