//
//  ChatRoomScheduleNavigator.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/06.
//

import Domain

protocol ChatRoomScheduleNavigator {

    func toChatRoomSchedule(_ chatRoom: ChatRoom)
    func toAddDiscussion(_ chatRoom: ChatRoom)
    func toChatRoom()

}
