//
//  SerialOtherChatItemViewModel.swift
//  Virtual-Korea
//
//  Created by 이청수 on 2022/06/22.
//

import UIKit

final class SerialOtherChatItemViewModel: ChatItemViewModel {

    override var identifier: String {
        return "SerialOtherChatCell"
    }

    override var textColor: UIColor? {
        return super.textColor ?? UIColor.label
    }

}
