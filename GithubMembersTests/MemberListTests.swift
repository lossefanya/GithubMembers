//
//  MemberListTests.swift
//  GithubMembersTests
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import XCTest
import RxSwift
@testable import GithubMembers

class MemberListTests: XCTestCase {
  private var mockNetwork: MockNetwork!
  private var viewModel: MemberListViewModel!
  private var bag: DisposeBag!

  override func setUp() {
    mockNetwork = MockNetwork()
    viewModel = MemberListViewModel(network: mockNetwork)
    bag = DisposeBag()
  }

  override func tearDown() {
    mockNetwork = nil
    viewModel = nil
    bag = nil
  }

  func testList() {
    mockNetwork.mockUsersResponse = (1...10).map { User.mockUser(id: $0)}
    viewModel.list()
    XCTAssertEqual(viewModel.cellViewModels.value.count, 10)
  }

  func testNext() {
    mockNetwork.mockUsersResponse = (1...10).map { User.mockUser(id: $0)}
    viewModel.list()
    mockNetwork.mockNextResponse = (11...20).map { User.mockUser(id: $0)}
    viewModel.next()
    XCTAssertEqual(viewModel.cellViewModels.value.count, 20)
  }

  func testSelect() {
    mockNetwork.mockUsersResponse = (1...10).map { User.mockUser(id: $0)}
    viewModel.list()
    let indexToSelect = 6
    viewModel.detailToShow.subscribe(onNext: { detailViewModel in
      XCTAssertEqual(detailViewModel.username, "User \(indexToSelect + 1)")
    }).disposed(by: bag)
    viewModel.select(index: indexToSelect)
  }

  func testErrorPopup() {
    viewModel.errorMessage.subscribe(onNext: { message in
      XCTAssertNotNil(message)
    }).disposed(by: bag)
    viewModel.list()
  }

}
