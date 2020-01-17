//
//  MemberDetailViewModel.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import RxSwift
import RxCocoa

final class MemberDetailViewModel {
  let network: Networkable
  let avatarUrl: URL
  let username: String
  let info = BehaviorRelay<[MemberDetailCellViewModel]>(value: [])
  let errorMessage = PublishRelay<String>()
  let bag = DisposeBag()

  init(network: Networkable, avatarUrl: URL, username: String) {
    self.network = network
    self.avatarUrl = avatarUrl
    self.username = username
  }

  func loadUserInfo() {
    network.user(userName: username)
      .subscribe(
        onNext: { [weak self] user in self?.info.accept(user.info) },
        onError: { [weak self] error in self?.errorMessage.accept(error.localizedDescription) }
      )
      .disposed(by: bag)
  }
}

extension User {
  var info: [MemberDetailCellViewModel] {
    var info = [MemberDetailCellViewModel]()
    if let name = name { info.append(MemberDetailCellViewModel(key: "Name", value: name))}
    if let company = company { info.append(MemberDetailCellViewModel(key: "Company", value: company)) }
    if let location = location { info.append(MemberDetailCellViewModel(key: "Location", value: location)) }
    if let email = email { info.append(MemberDetailCellViewModel(key: "Email", value: email)) }
    if let hireable = hireable { info.append(MemberDetailCellViewModel(key: "Hireable", value: hireable ? "Yes" : "No")) }
    if let bio = bio { info.append(MemberDetailCellViewModel(key: "Bio", value: bio)) }
    if let repoCount = repoCount { info.append(MemberDetailCellViewModel(key: "Repositories", value: "\(repoCount)")) }
    if let gistCount = gistCount { info.append(MemberDetailCellViewModel(key: "Gists", value: "\(gistCount)")) }
    if let followers = followers { info.append(MemberDetailCellViewModel(key: "Followers", value: "\(followers)")) }
    if let following = following { info.append(MemberDetailCellViewModel(key: "Following", value: "\(following)")) }
    return info
  }
}
