//
//  UIAlertController+Alert.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit

extension UIAlertController {
  static func alert(
    title: String? = nil,
    message: String,
    context: UIViewController,
    actions: [(title: String, action: () -> Void)]
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach {
      let action = $0.action
      alert.addAction(UIAlertAction(title: $0.title, style: .default, handler: { _ in action() }))
    }
    context.present(alert, animated: true, completion: nil)
  }
}

extension UIViewController {
  func alert(message: String) {
    UIAlertController.alert(message: message, context: self, actions: [(title: "OK", action: {})])
  }
}
