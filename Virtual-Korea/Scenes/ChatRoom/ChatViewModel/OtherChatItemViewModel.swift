//
//  OtherChatItemViewModel.swift
//  Virtual-Korea
//
//  Created by 이청수 on 2022/06/22.
//

import UIKit

final class OtherChatItemViewModel: ChatItemViewModel {

    override var identifier: String {
        return OtherChatCell.identifier
    }

    override var textColor: UIColor? {
        return super.textColor ?? UIColor.label
    }

}
