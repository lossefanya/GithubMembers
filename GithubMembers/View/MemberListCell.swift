//
//  MemberListCell.swift
//  GithubMembers
//
//  Created by Yeongweon Park on 14.01.20.
//  Copyright © 2020 young1park. All rights reserved.
//

import UIKit
import AlamofireImage

final class MemberListCell: UITableViewCell {

  @IBOutlet var avartarView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  var viewModel: MemberListCellViewModel? {
    didSet {
      avartarView.image = nil
      nameLabel.text = nil
      guard let viewModel = viewModel else { return }
      avartarView.af_setImage(withURL: viewModel.avatarUrl)
      nameLabel.text = viewModel.username
    }
  }

//  override func awakeFromNib() {
//      super.awakeFromNib()
//      // Initialization code
//  }
//
//  override func setSelected(_ selected: Bool, animated: Bool) {
//      super.setSelected(selected, animated: animated)
//
//      // Configure the view for the selected state
//  }

}
