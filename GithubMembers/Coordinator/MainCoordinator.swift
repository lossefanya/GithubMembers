//
//  MainCoordinator.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit
import RxSwift

final class MainCoordinator {
  private let window: UIWindow
  private let network: Networkable
  private var nav: UINavigationController?
  private let bag = DisposeBag()

  init(window: UIWindow, network: Networkable) {
    self.window = window
    self.network = network
  }

  func start() {
    let viewModel = MemberListViewModel(network: network)
    viewModel.detailToShow.subscribe(onNext: showDetail).disposed(by: bag)
    viewModel.isLoggedIn.skip(1).subscribe(onNext: presentLogin).disposed(by: bag)
    let viewController = MemberListViewController.make()
    viewController.viewModel = viewModel
    let nav = UINavigationController(rootViewController: viewController)
    window.rootViewController = nav
    self.nav = nav
  }

  func presentLogin(_ isLoggedIn: Bool) {
    guard !isLoggedIn else { return }
    guard let nav = nav else { fatalError("start() has not been called.") }
    let viewModel = LoginViewModel(network: network)
    let viewController = LoginViewController.make()
    viewController.viewModel = viewModel
    viewController.modalPresentationStyle = .fullScreen
    nav.present(viewController, animated: true)
    viewModel.isLoggedIn
      .subscribe(onNext: { isLoggedIn in
        if isLoggedIn { viewController.dismiss(animated: true) }
      })
      .disposed(by: bag)
  }

  func showDetail(_ viewModel: MemberDetailViewModel) {
    guard let nav = nav else { fatalError("start() has not been called.") }
    let viewController = MemberDetailViewController.make()
    viewController.viewModel = viewModel
    nav.pushViewController(viewController, animated: true)
  }
}
