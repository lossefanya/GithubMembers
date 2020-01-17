//
//  UserTarget.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import Moya

enum UserTarget {
  case users(since: Int?)
  case user(userName: String)
  case logIn
}

extension UserTarget: TargetType, AccessTokenAuthorizable {
  var authorizationType: AuthorizationType { return .basic }
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  var method: Moya.Method { return .get }
  var sampleData: Data { return "".data(using: .utf8)! }
  var headers: [String : String]? { return nil }

  var path: String {
    switch self {
    case .users: return "users"
    case .user(let userName): return "users/\(userName)"
    case .logIn: return "user"
    }
  }

  var task: Task {
    switch self {
    case .users(let since):
      guard let since = since else { return .requestPlain }
      return .requestParameters(parameters: ["since": since], encoding: URLEncoding.default)
    default:
      return .requestPlain
    }
  }

}

