//
//  User.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import Foundation

struct User: Codable {
  let username: String
  let userId: Int
  let avatar: String
  let name: String?
  let company: String?
  let location: String?
  let email: String?
  let hireable: Bool?
  let bio: String?
  let repoCount: Int?
  let gistCount: Int?
  let followers: Int?
  let following: Int?


  enum CodingKeys: String, CodingKey {
    case username = "login"
    case userId = "id"
    case avatar = "avatar_url"
    case name
    case company
    case location
    case email
    case hireable
    case bio
    case repoCount = "public_repos"
    case gistCount = "public_gists"
    case followers
    case following
  }
}
