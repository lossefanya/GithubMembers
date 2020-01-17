//
//  LoginViewController.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit
import RxSwift

final class LoginViewController: UIViewController {
  var viewModel: LoginViewModel!
  @IBOutlet var usernameField: UITextField!
  @IBOutlet var passwordField: UITextField!
  private let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    usernameField.becomeFirstResponder()
  }

  func bind() {
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] message in self?.alert(message: message)})
      .disposed(by: bag)
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case usernameField: passwordField.becomeFirstResponder()
    case passwordField: viewModel.logIn(username: usernameField.text, password: passwordField.text)
    default: break
    }
    return true
  }
}
