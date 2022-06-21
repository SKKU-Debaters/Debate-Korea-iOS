//
//  MockUserInfoUsecase.swift
//  Virtual-Korea-ViewModelTests
//
//  Created by 이청수 on 2022/06/08.
//

import Domain
import RxSwift

final class MockUserInfoUsecase: Domain.UserInfoUsecase {

    // MARK: properties

    let addEventStream: PublishSubject<Void>
    let addSideEventStream: PublishSubject<Void>
    let addUserInfoStream: PublishSubject<Void>
    let clearSideStream: PublishSubject<Void>
    let voteStream: PublishSubject<Void>
    let uidStream: PublishSubject<String>
    let roomUserInfoStream: PublishSubject<UserInfo?>
    let connectStream: PublishSubject<UserInfo>
    let userInfoStream: PublishSubject<UserInfo?>

    // MARK: - init/deinit

    init() {
        self.addEventStream = PublishSubject<Void>.init()
        self.addSideEventStream = PublishSubject<Void>.init()
        self.addUserInfoStream = PublishSubject<Void>.init()
        self.clearSideStream = PublishSubject<Void>.init()
        self.voteStream = PublishSubject<Void>.init()
        self.uidStream = PublishSubject<String>.init()
        self.roomUserInfoStream = PublishSubject<UserInfo?>.init()
        self.connectStream = PublishSubject<UserInfo>.init()
        self.userInfoStream = PublishSubject<UserInfo?>.init()
    }

    // MARK: - methods

    func add(roomID: String, userID: String) -> Observable<Void> {
        self.addEventStream
    }

    func add(roomID: String, userID: String, side: Side) -> Observable<Void> {
        self.addSideEventStream
    }

    func add(userInfo: UserInfo) -> Observable<Void> {
        self.addUserInfoStream
    }

    func clearSide(roomID: String, userID: String) -> Observable<Void> {
        self.clearSideStream
    }

    func vote(roomID: String, userID: String, side: Side) -> Observable<Void> {
        self.voteStream
    }

    func uid() -> Observable<String> {
        self.uidStream
    }

    func userInfo(roomID: String, with userID: String) -> Observable<UserInfo?> {
        self.roomUserInfoStream
    }

    func connect(roomID: String) -> Observable<UserInfo> {
        self.connectStream
    }

    func userInfo(userID: String) -> Observable<UserInfo?> {
        self.userInfoStream
    }

}
