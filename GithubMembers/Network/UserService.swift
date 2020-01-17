//
//  UserService.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

protocol Networkable {
  var isLoggedIn: BehaviorRelay<Bool> { get }
  func logIn(with credentials: Credentials) -> Observable<User>
  func users(since: Int?) -> Observable<[User]>
  func next() -> Observable<[User]>
  func user(userName: String) -> Observable<User>
}

final class UserService: Networkable {
  let isLoggedIn = BehaviorRelay<Bool>(value: false)
  private var provider = MoyaProvider<UserTarget>()
  private var nextPageIndex: Int = 0

  func logIn(with credentials: Credentials) -> Observable<User> {
    authenticate(with: credentials)
    return provider.rx.request(.logIn)
      .filterSuccessfulStatusCodes()
      .map(User.self)
      .asObservable()
      .do(onNext: { user in
        guard user.username == credentials.username else { return }
        self.authenticate(with: credentials)
        self.isLoggedIn.accept(true)
      })
  }

  private func authenticate(with credentials: Credentials) {
    let authorization = credentials.username + ":" + credentials.password
    guard let token = authorization.toBase64() else { return }
    let authPlugin = AccessTokenPlugin { token }
    provider = MoyaProvider<UserTarget>(plugins: [authPlugin])
  }

  private func parseLink(from header: String) {
    var dictionary: [String: String] = [:]
    header.components(separatedBy: ",").forEach {
      let components = $0.components(separatedBy:"; ")
      let path = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
      dictionary[components[1]] = path
    }
    guard let path = dictionary["rel=\"next\""] else { return }
    guard let index = Int(path.components(separatedBy: "=").last ?? "") else { return }
    nextPageIndex = index
  }

  func users(since: Int?) -> Observable<[User]> {
    return provider.rx.request(.users(since: since))
      .do(onSuccess: { response in
        guard let linkHeader = response.response?.value(forHTTPHeaderField: "Link") else { return }
        self.parseLink(from: linkHeader)
      })
      .filterSuccessfulStatusCodes()
      .map([User].self)
      .asObservable()
  }

  func next() -> Observable<[User]> {
    return users(since: nextPageIndex)
  }

  func user(userName: String) -> Observable<User> {
    return provider.rx.request(.user(userName: userName))
      .filterSuccessfulStatusCodes()
      .map(User.self)
      .asObservable()
  }

}

extension String {
  func toBase64() -> String? {
    guard let data = self.data(using: String.Encoding.utf8) else { return nil }
    return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
  }
}
