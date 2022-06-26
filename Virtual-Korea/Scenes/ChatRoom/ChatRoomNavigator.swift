//
//  ChatRoomNavigator.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/02.
//

import Domain
import RxSwift

protocol ChatRoomNavigator {

    func toChatRoom(_ uid: String, _ chatRoom: ChatRoom)
    func toSideMenu(_ chatRoom: ChatRoom)
    func toEnterAlert() -> Observable<Bool>
    func toSideAlert() -> Observable<Side>
    func toVoteAlert() -> Observable<Side>
    func toDiscussionResultAlert(result: Discussion.Result)
    func appear()
    func disappear()

}
