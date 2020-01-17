//
//  MemberDetailViewController.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

final class MemberDetailViewController: UITableViewController {
  var avatarView: UIImageView!
  var viewModel: MemberDetailViewModel!
  let bag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = viewModel.username
    let width = UIScreen.main.bounds.size.width
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
    avatarView = imageView
    tableView.tableHeaderView = avatarView
    bind()
  }

  func bind() {
    avatarView.af_setImage(withURL: viewModel.avatarUrl)
    viewModel.info
      .subscribe(onNext: { [weak self] _ in self?.tableView.reloadData() })
      .disposed(by: bag)
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] message in self?.alert(message: message)})
      .disposed(by: bag)
    viewModel.loadUserInfo()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.info.value.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: MemberDetailCell.identifier, for: indexPath) as! MemberDetailCell
    cell.viewModel = viewModel.info.value[indexPath.row]
    return cell
  }

}
