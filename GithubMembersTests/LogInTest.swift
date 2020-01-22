//
//  LogInTest.swift
//  GithubMembersTests
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import XCTest
import RxSwift
@testable import GithubMembers

class LogInTest: XCTestCase {
  private var mockNetwork: MockNetwork!
  private var viewModel: LoginViewModel!
  private var bag: DisposeBag!

  override func setUp() {
    mockNetwork = MockNetwork()
    viewModel = LoginViewModel(network: mockNetwork)
    bag = DisposeBag()
  }

  override func tearDown() {
    mockNetwork = nil
    viewModel = nil
    bag = nil
  }

  func testLogIn() {
    mockNetwork.mockLogInResponse = User.mockUser()
    viewModel.isLoggedIn.subscribe(onNext: { isLoggedIn in
      XCTAssertTrue(isLoggedIn)
    }).disposed(by: bag)
    viewModel.logIn(username: "", password: "")
  }

  func testErrorPopup() {
    viewModel.errorMessage.subscribe(onNext: { message in
      XCTAssertNotNil(message)
    }).disposed(by: bag)
    viewModel.logIn(username: "", password: "")
  }
}
