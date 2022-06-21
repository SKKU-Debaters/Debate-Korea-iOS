//
//  MockDiscussionUsecase.swift
//  Virtual-Korea-ViewModelTests
//
//  Created by 이청수 on 2022/06/21.
//

import Domain
import Foundation
import RxSwift

final class MockDiscussionUsecase: Domain.DiscussionUsecase {

    // MARK: properties

    let discussionStream: PublishSubject<Discussion>
    let addRoomEventStream: PublishSubject<Void>
    let statusStream: PublishSubject<Int>
    let remainTimeStream: PublishSubject<Date>
    let discussionResultStream: PublishSubject<Discussion.Result>

    // MARK: - init/deinit

    init() {
        self.discussionStream = PublishSubject<Discussion>.init()
        self.addRoomEventStream = PublishSubject<Void>.init()
        self.statusStream = PublishSubject<Int>.init()
        self.remainTimeStream = PublishSubject<Date>.init()
        self.discussionResultStream = PublishSubject<Discussion.Result>.init()
    }

    // MARK: - methods

    func discussions(roomUID: String) -> Observable<Discussion> {
        self.discussionStream
    }
    
    func add(roomUID: String, discussion: Discussion) -> Observable<Void> {
        self.addRoomEventStream
    }
    
    func status(roomUID: String) -> Observable<Int> {
        self.statusStream
    }
    
    func remainTime(roomUID: String) -> Observable<Date> {
        self.remainTimeStream
    }
    
    func discussionResult(userID: String, chatRoomID: String) -> Observable<Discussion.Result> {
        self.discussionResultStream
    }

}
