//
//  MemberDetailCell.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit

final class MemberDetailCell: UITableViewCell {
  @IBOutlet var keyLabel: UILabel!
  @IBOutlet var valueLabel: UILabel!
  var viewModel: MemberDetailCellViewModel? {
    didSet {
      keyLabel?.text = nil
      valueLabel?.text = nil
      guard let viewModel = viewModel else { return }
      keyLabel?.text = viewModel.key
      valueLabel?.text = viewModel.value
    }
  }
}
