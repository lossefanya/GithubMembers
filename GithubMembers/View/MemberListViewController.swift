//
//  MemberListViewController.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit
import RxSwift

final class MemberListViewController: UITableViewController {
  var viewModel: MemberListViewModel!
  let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Github Members"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !viewModel.isLoggedIn.value { viewModel.logOut() }
    if viewModel.cellViewModels.value.count == 0 { viewModel.list() }
  }

  func bind() {
    viewModel.cellViewModels
      .subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() })
      .disposed(by: bag)
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] message in self?.alert(message: message)})
      .disposed(by: bag)
    viewModel.list()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellViewModels.value.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MemberListCell.identifier, for: indexPath) as! MemberListCell
    let cellViewModel = viewModel.cellViewModels.value[indexPath.row]
    cell.viewModel = cellViewModel
    if indexPath.row == viewModel.cellViewModels.value.count - 1 {
      viewModel.next()
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.select(index: indexPath.row)
  }

}

