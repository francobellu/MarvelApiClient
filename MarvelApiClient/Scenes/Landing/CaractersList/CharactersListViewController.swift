//
//  CharactersListViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class CharactersListViewController: UIViewController, StoryboardInstantiable {
  var presenter: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = presenter.title
    tableView.dataSource = self
    tableView.delegate = self
    setBackBtnInterceptMechanism()
    tableView.register(UINib(nibName: R.nib.characterCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.characterCellId.identifier)
    activityIndicator.startAnimating()
    presenter.getNextCharactersList{
      // Reload Data
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.activityIndicator.stopAnimating()
      }
    }
  }

  /// this technics loses the swipe right gesture to go back!!!
  func setBackBtnInterceptMechanism() {

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
}

extension CharactersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.charactersCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let newCharacter = presenter.getCharacter(at: indexPath.row)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.characterCellId.identifier) as?
      CharacterCell else { return UITableViewCell() }

    cell.config(with: newCharacter)
    // Check if the last row number is the same as the last current data element
    if indexPath.row == presenter.charactersCount() - 1 {
      presenter.getNextCharactersList {
        DispatchQueue.main.async {
          tableView.reloadData()
        }
      }
    }
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

extension CharactersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let character = presenter.getCharacter(at: indexPath.row)
    presenter.didSelect(character: character)
  }
}
