//
//  MemberListViewModel.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 13.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

final class MemberListViewModel {
  let network: Networkable
  let cellViewModels = BehaviorRelay<[MemberListCellViewModel]>(value: [])
  let errorMessage = PublishRelay<String>()
  let detailToShow = PublishRelay<MemberDetailViewModel>()
  let isLoggedIn = BehaviorRelay<Bool>(value: false)
  let bag = DisposeBag()

  init(network: Networkable) {
    self.network = network
    self.network.isLoggedIn.bind(to: isLoggedIn).disposed(by: bag)
  }

  func list() {
    network.users(since: nil)
      .subscribe(
        onNext: { [weak self] users in
          let viewModels = users.compactMap { MemberListCellViewModel($0) }
          self?.cellViewModels.accept(viewModels)
        },
        onError: { [weak self] error in
          self?.errorMessage.accept(error.localizedDescription)
        }
      )
      .disposed(by: bag)
  }

  func next() {
    network.next()
      .subscribe(
        onNext: { [weak self] users in
          guard var viewModels = self?.cellViewModels.value else { return }
          let next = users.compactMap { MemberListCellViewModel($0) }
          viewModels.append(contentsOf: next)
          self?.cellViewModels.accept(viewModels)
        },
        onError: { [weak self] error in
          self?.errorMessage.accept(error.localizedDescription)
        }
      )
      .disposed(by: bag)
  }

  func select(index: Int) {
    let cellViewModel = cellViewModels.value[index]
    let detailViewModel = MemberDetailViewModel(
      network: network,
      avatarUrl: cellViewModel.avatarUrl,
      username: cellViewModel.username
    )
    detailToShow.accept(detailViewModel)
  }

  func logOut() {
    isLoggedIn.accept(false)
  }

}
