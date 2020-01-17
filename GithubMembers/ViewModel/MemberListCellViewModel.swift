//
//  MemberListCellViewModel.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import Foundation

struct MemberListCellViewModel {
  let avatarUrl: URL
  let username: String

  init?(_ user: User) {
    guard let url = URL(string: user.avatar) else { return nil }
    avatarUrl = url
    username = user.username
  }
}
