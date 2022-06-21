//
//  SelfChatItemViewModel.swift
//  Virtual-Korea
//
//  Created by 이청수 on 2022/06/21.
//

import UIKit

final class SelfChatItemViewModel: ChatItemViewModel {

    override var identifier: String {
        return SelfChatCell.identifier
    }

    override var textColor: UIColor? {
        if let textColor = super.textColor {
            return textColor
        }
        if self.chat.side == nil {
            return .white
        }
        return .label
    }

}
