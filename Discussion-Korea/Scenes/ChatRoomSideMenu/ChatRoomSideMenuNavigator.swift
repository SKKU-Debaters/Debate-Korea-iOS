//
//  ChatRoomSideMenuNavigator.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/05.
//

import Domain

protocol ChatRoomSideMenuNavigator {

    func toChatRoomSideMenu(_ chatRoom: ChatRoom)
    func toChatRoomSchedule(_ chatRoom: ChatRoom)

}
