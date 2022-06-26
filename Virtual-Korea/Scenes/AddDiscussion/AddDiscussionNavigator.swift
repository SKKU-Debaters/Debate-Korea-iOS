//
//  AddDiscussionNavigator.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/07.
//

import Domain
import UIKit

protocol AddDiscussionNavigator {

    func toAddDiscussion(_ chatRoom: ChatRoom)
    func toChatRoom()

}
