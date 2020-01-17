//
//  MockNetwork.swift
//  GithubMembersTests
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import RxSwift
import RxCocoa
@testable import GithubMembers

class MockNetwork: Networkable {
  var mockLogInResponse: User?
  var mockUsersResponse: [User]?
  var mockNextResponse: [User]?
  var mockUserResponse: User?

  var isLoggedIn = BehaviorRelay<Bool>(value: false)

  func logIn(with credentials: Credentials) -> Observable<User> {
    guard let user = mockLogInResponse else { return Observable.error(MockError.mockError) }
    return Observable.just(user)
  }

  func users(since: Int?) -> Observable<[User]> {
    guard let users = mockUsersResponse else { return Observable.error(MockError.mockError) }
    return Observable.just(users)
  }

  func next() -> Observable<[User]> {
    guard let next = mockNextResponse else { return Observable.error(MockError.mockError) }
    return Observable.just(next)
  }

  func user(userName: String) -> Observable<User> {
    guard let user = mockUserResponse else { return Observable.error(MockError.mockError) }
    return Observable.just(user)
  }
}

enum MockError: LocalizedError {
  case mockError

  var errorDescription: String? {
    switch self {
    case .mockError: return "This is mock error."
    }
  }
}

extension User {
  static func mockUser(id: Int = 1) -> User {
    return User(
      username: "User \(id)",
      userId: id,
      avatar: "http://some.fake.url",
      name: "John Doe",
      company: nil,
      location: "Earth",
      email: nil,
      hireable: nil,
      bio: "Just testing",
      repoCount: 1,
      gistCount: 1,
      followers: nil,
      following: nil
    )
  }
}
