//
//  UIViewController +  ErrorDialog.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

extension UIViewController {

    func showErrorAlert(error: Error) {

        // create the alert
      let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
