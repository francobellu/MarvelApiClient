//
//  CharactersListViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol CharactersListPresenterToViewProtocol: class{

  func prepareView()
  func reloadTableViewClosure()
}

class CharactersListViewController: UIViewController, StoryboardInstantiable {
  var presenter: CharactersListPresenterProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var tableViewOutlet: UITableView!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  lazy var tableView: UITableView = {
         tableViewOutlet.delegate = self
         tableViewOutlet.dataSource = self
         tableViewOutlet.register(UINib(nibName: R.nib.characterCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
         return tableViewOutlet
     }()

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = self.tableView // call the lazy tableView
    initBinding()
    presenter.viewDidLoad()
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

    // Title
    self.title = presenter.title.value
    presenter.title.valueChanged = { [weak self] (title) in
      self?.title = title
    }

    // TableView
    presenter.cellViewModels.valueChanged = { [weak self] (_) in
      DispatchQueue.main.async {
        self?.tableViewOutlet.reloadData()
      }
    }

    // ActivityIndicator
    updateLoadingStatus()
    presenter.isLoading.valueChanged = { [weak self] (isLoading) in
      self?.updateLoadingStatus()
    }
  }

  func tableView2(_ tableView: UITableView, indexPath: IndexPath) {
    presenter.didSelectCharacter(at: indexPath.row)
  }

  private func updateLoadingStatus(){
    DispatchQueue.main.async {
      let isLoading = self.presenter.isLoading
      if isLoading.value {
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
          self.tableViewOutlet.alpha = 0.0
        })
      } else {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
          self.tableViewOutlet.alpha = 1.0
        })
      }
    }
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
    return presenter.charactersCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.characterCellId.identifier, for: indexPath)

    let rowViewModel = presenter.cellViewModels.value[indexPath.row]

    guard let myCell = cell as? CharacterCell else{ fatalError()}
    myCell.config(with: rowViewModel)

    // Check if the last row number is the same as the last current data element
    if indexPath.row == presenter.charactersCount() - 1 {
      presenter.getNextCharactersList()
    }
    return myCell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    presenter.numberOfSections
  }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView2(tableView, indexPath: indexPath)
  }
}

// MARK: - CharactersListPresenterToViewProtocol
extension CharactersListViewController: CharactersListPresenterToViewProtocol {
  func reloadTableViewClosure(){
    DispatchQueue.main.async {
      self.tableViewOutlet.reloadData()
    }
  }

  func prepareView(){
    setBackBtnInterceptMechanism()
    presenter.getNextCharactersList()
  }
}
