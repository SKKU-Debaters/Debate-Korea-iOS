//
//  MockChatRoomUsecase.swift
//  Virtual-Korea-ViewModelTests
//
//  Created by 이청수 on 2022/06/08.
//

import Domain
import RxSwift

final class MockChatRoomUsecase: Domain.ChatRoomsUsecase {

    // MARK: properties

    let chatRoomsStream: Observable<ChatRoom>
    let createChatRoomStream: Observable<Void>
    let latestChatStream: Observable<Chat>
    let userNumberStream: Observable<UInt>

    // MARK: - init/deinit

    init() {
        self.chatRoomsStream = PublishSubject<ChatRoom>.init()
        self.createChatRoomStream = PublishSubject<Void>.init()
        self.latestChatStream = PublishSubject<Chat>.init()
        self.userNumberStream = PublishSubject<UInt>.init()
    }

    // MARK: - methods

    func chatRooms() -> Observable<ChatRoom> {
        self.chatRoomsStream
    }

    func create(chatRoom: ChatRoom) -> Observable<Void> {
        self.createChatRoomStream
    }
    
    func latestChat(chatRoomID: String) -> Observable<Chat> {
        self.latestChatStream
    }
    
    func numberOfUsers(chatRoomID: String) -> Observable<UInt> {
        self.userNumberStream
    }

}
