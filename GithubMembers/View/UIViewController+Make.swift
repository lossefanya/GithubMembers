//
//  UIViewController+Make.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit

protocol Identifiable {}
extension Identifiable {
  static var identifier: String { return String(describing: Self.self) }
}

extension UITableViewCell: Identifiable {}
extension UIViewController: Identifiable {}

extension UIViewController {
  static func make() -> Self {
    let id = identifier
    let storyBoard = UIStoryboard(name: id, bundle: nil)
    return unsafeDowncast(storyBoard.instantiateViewController(withIdentifier: id), to: self)
  }
}


