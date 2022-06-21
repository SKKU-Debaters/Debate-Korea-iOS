//
//  MockChatsUsecase.swift
//  Virtual-Korea-ViewModelTests
//
//  Created by 이청수 on 2022/06/21.
//

import Domain
import RxSwift

final class MockChatsUsecase: Domain.ChatsUsecase {

    // MARK: properties

    let chatsStream: PublishSubject<[Chat]>
    let connectStream: PublishSubject<Chat>
    let sendEventStream: PublishSubject<Void>
    let maskingStream: PublishSubject<String>

    // MARK: - init/deinit

    init() {
        self.chatsStream = PublishSubject<[Chat]>.init()
        self.connectStream = PublishSubject<Chat>.init()
        self.sendEventStream = PublishSubject<Void>.init()
        self.maskingStream = PublishSubject<String>.init()
    }

    // MARK: - methods

    func chats(roomUID: String) -> Observable<[Chat]> {
        self.chatsStream
    }
    
    func connect(roomUID: String, after chatUID: String?) -> Observable<Chat> {
        self.connectStream
    }
    
    func send(roomUID: String, chat: Chat) -> Observable<Void> {
        self.sendEventStream
    }
    
    func masking(roomUID: String) -> Observable<String> {
        self.maskingStream
    }

}
