//
//  LoginViewModel.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import RxSwift
import RxCocoa

final class LoginViewModel {
  private let network: Networkable
  let errorMessage = PublishRelay<String>()
  let isLoggedIn = PublishRelay<Bool>()
  let bag = DisposeBag()

  init(network: Networkable) {
    self.network = network
  }

  func logIn(username: String?, password: String?) {
    guard let username = username, let password = password else { return }
    network.logIn(with: Credentials(username: username, password: password))
      .subscribe(
        onNext: { _ in
          self.isLoggedIn.accept(true)
        },
        onError: { error in
          self.errorMessage.accept(error.localizedDescription)
        }
      )
      .disposed(by: bag)
  }
}
