//
//  MemberDetailTests.swift
//  GithubMembersTests
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import XCTest
import RxSwift
@testable import GithubMembers

class MemberDetailTests: XCTestCase {
  private var mockNetwork: MockNetwork!
  private var viewModel: MemberDetailViewModel!
  private var bag: DisposeBag!

  override func setUp() {
    let user = User.mockUser()
    let url = URL(string: user.avatar)!
    mockNetwork = MockNetwork()
    viewModel = MemberDetailViewModel(network: mockNetwork, avatarUrl:url, username: user.username)
    bag = DisposeBag()
  }

  override func tearDown() {
    mockNetwork = nil
    viewModel = nil
    bag = nil
  }

  func testCountOfAvailableInfo() {
    mockNetwork.mockUserResponse = User.mockUser()
    viewModel.loadUserInfo()
    XCTAssertEqual(viewModel.info.value.count, 5)
  }

  func testErrorPopup() {
    let expectation = XCTestExpectation(description: "Show popup when there's an error.")
    viewModel.errorMessage.subscribe(onNext: { message in
      XCTAssertNotNil(message)
      expectation.fulfill()
    }).disposed(by: bag)
    viewModel.loadUserInfo()
    wait(for: [expectation], timeout: 1)
  }
}


