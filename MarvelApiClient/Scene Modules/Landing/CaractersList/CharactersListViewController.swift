//
//  CharactersListViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController, StoryboardInstantiable, DataBinding {
  // MARK: - CharactersListPresenterToViewProtocol
  lazy var viewDidLoadChanged: ((Bool) -> Void)? = {  [weak self] (viewDidLoad) in
    self?.prepareView()
    self?.presenter.getNextCharactersList()
  }

  lazy var titleChanged: ((String) -> Void)? = {[weak self] (title) in
    self?.title = title
  }

  lazy var presentationModelChanged: (([CharacterCellPresentationModel]) -> Void)? = { [weak self] (_) in
    self?.tableView.reloadData()
  }

  lazy var isLoadingChanged: ((Bool) -> Void)? = { [weak self] (isLoading) in
    self?.updateLoadingStatus()
  }

  lazy var isErrorChanged: ((Error?) -> Void)? = { [weak self] (error: Error?) in
    guard let error = error else{ fatalError()}
    self?.showErrorAlert(error: error)
  }

  // MARK: -
  func prepareView(){
    setBackBtnInterceptMechanism()
  }

  var presenter: CharactersListPresenterProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: "characterCellId")
    }
  }

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    initBinding()

    // Title
    self.title = presenter.title.value

    // ActivityIndicator
    updateLoadingStatus()

    presenter.viewDidLoad.value = true
  }

  // Then handle the button selection
  @objc func goBack() {
    // Here we just remove the back button, you could also disabled it or better yet show an activityIndicator
    self.navigationItem.leftBarButtonItem = nil
    let allowGoBack = true
    if allowGoBack {
      // Don't forget to re-enable the interactive gesture
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
      presenter.didGoBack()
    }
  }

  private func initBinding() {
    // viewDidLoad
    presenter.viewDidLoad.valueChanged = viewDidLoadChanged

    // Title
    presenter.title.valueChanged = titleChanged

    // TableView
    presenter.presentationModel.valueChanged = presentationModelChanged

    // ActivityIndicator
    presenter.isLoading.valueChanged = isLoadingChanged

    // Error Dialog
    presenter.isError.valueChanged = isErrorChanged
  }

  private func updateLoadingStatus(){
    let isLoading = self.presenter.isLoading
    var alpha: CGFloat = -1
    if isLoading.value {
      self.activityIndicator.startAnimating()
      alpha = 0.0
    } else {
      self.activityIndicator.stopAnimating()
      alpha = 1.0
    }
    UIView.animate(withDuration: 0.2, animations: {
      self.tableView.alpha = alpha
    })
  }

  /// this technics loses the swipe right gesture to go back!!!
  private func setBackBtnInterceptMechanism() {

    // Disable the swipe to make sure you get your chance to save
    guard let navigationController = self.navigationController else { return }
    navigationController.interactivePopGestureRecognizer?.isEnabled = false

    // Replace the default back button with one which we can intercpt the action
    navigationItem.setHidesBackButton(true, animated: false)
    let backButton = UIBarButtonItem(title: "Back",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(goBack))
    navigationItem.leftBarButtonItem = backButton
  }
}

// MARK: - UITableViewDataSource
extension CharactersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.presentationModel.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier:"characterCellId", for: indexPath)

    let rowViewModel = presenter.presentationModel.value[indexPath.row]

    guard let myCell = cell as? CharacterCell else{ fatalError()}
    _ = myCell.contentView
    myCell.config(with: rowViewModel)

    // Check if the last row number is the same as the last current data element
    if indexPath.row == presenter.presentationModel.value.count - 1 {
      presenter.getNextCharactersList()
    }
    return myCell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    presenter.presentationModel.value.count > 0 ? 1 : 0
  }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectCharacter(at: indexPath.row)
  }
}
