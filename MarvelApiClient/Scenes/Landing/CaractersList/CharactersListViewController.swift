//
//  CharactersListViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController, StoryboardInstantiable {
  var presenter: CharactersListPresenterProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var tableView: UITableView! {
   didSet {
     tableView.delegate = self
     tableView.dataSource = self
     tableView.register(UINib(nibName: R.nib.characterCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
   }
  }

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
//    _ = self.tableView // call the lazy tableView
    initBinding()
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

    // Title
    presenter.viewDidLoad.valueChanged = { [weak self] (viewDidLoad) in
      self?.prepareView()
      self?.presenter.getNextCharactersList()
    }

    // Title
    self.title = presenter.title.value
    presenter.title.valueChanged = { [weak self] (title) in
      self?.title = title
    }

    // TableView
    presenter.cellPresentationModels.valueChanged = { [weak self] (_) in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }

    // ActivityIndicator
    updateLoadingStatus()
    presenter.isLoading.valueChanged = { [weak self] (isLoading) in
      self?.updateLoadingStatus()
    }
  }

  private func updateLoadingStatus(){
    DispatchQueue.main.async {
      let isLoading = self.presenter.isLoading
      if isLoading.value {
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
          self.tableView.alpha = 0.0
        })
      } else {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
          self.tableView.alpha = 1.0
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
    return presenter.cellPresentationModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.characterCellId.identifier, for: indexPath)

    let rowViewModel = presenter.cellPresentationModels.value[indexPath.row]

    guard let myCell = cell as? CharacterCell else{ fatalError()}
    _ = myCell.contentView
    myCell.config(with: rowViewModel)

    // Check if the last row number is the same as the last current data element
    if indexPath.row == presenter.cellPresentationModels.value.count - 1 {
      presenter.getNextCharactersList()
    }
    return myCell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    presenter.cellPresentationModels.value.count > 0 ? 1 : 0
  }
}

// MARK: - UITableViewDelegate
extension CharactersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     presenter.didSelectCharacter(at: indexPath.row)
  }
}

// MARK: - CharactersListPresenterToViewProtocol
extension CharactersListViewController: CharactersListPresenterToViewProtocol {
  func prepareView(){
    setBackBtnInterceptMechanism()
  }
}
