//
//  ChatRoomViewModelTests.swift
//  Virtual-Korea-ViewModelTests
//
//  Created by 이청수 on 2022/06/21.
//

import Domain
import RxSwift
import RxCocoa
import RxTest
import XCTest

final class ChatRoomViewModelTests: XCTestCase {

    // MARK: properties

    private let chatRoom = ChatRoom(uid: "uid", title: "test", adminUID: "testUID")

    private var mockNavigator: MockChatRoomNavigator!
    private var chatsUsecase: MockChatsUsecase!
    private var userInfoUsecase: MockUserInfoUsecase!
    private var discussionUsecase: MockDiscussionUsecase!
    private var viewModel: ChatRoomViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    // MARK: - methods

    override func setUp() {
        super.setUp()
        self.mockNavigator = MockChatRoomNavigator()
        self.chatsUsecase = MockChatsUsecase()
        self.userInfoUsecase = MockUserInfoUsecase()
        self.discussionUsecase = MockDiscussionUsecase()
        self.viewModel = ChatRoomViewModel(
            chatRoom: self.chatRoom,
            navigator: self.mockNavigator,
            chatsUsecase: self.chatsUsecase,
            userInfoUsecase: self.userInfoUsecase,
            discussionUsecase: self.discussionUsecase
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        self.mockNavigator = nil
        self.chatsUsecase = nil
        self.userInfoUsecase = nil
        self.discussionUsecase = nil
        self.viewModel = nil
        self.disposeBag = nil
        self.scheduler = nil
        super.tearDown()
    }

    func test_찬성측인_경우_발언권이_없을때_편집이_불가능하다() {

        var testUserInfo = UserInfo(uid: "testUID", nickname: "testNickname")
        testUserInfo.side = .agree

        self.userInfoUsecase.uidStream = self.scheduler.createHotObservable([
            .next(230, "testUID"),
            .completed(232)
        ]).asObservable()

        self.userInfoUsecase.roomUserInfoStream = self.scheduler.createHotObservable([
            .next(235, testUserInfo),
            .completed(237)
        ]).asObservable()

        self.discussionUsecase.statusStream = self.scheduler.createHotObservable([
            .next(240, 3),
            .next(250, 6),
            .next(260, 7),
            .next(270, 8),
            .next(280, 11),
            .next(290, 13)
        ]).asObservable()

        let triggerTestableDriver: Driver<Void> = self.scheduler.createHotObservable([
            .next(210, ())
        ]).asDriverOnErrorJustComplete()

        let testableObserver = self.scheduler.createObserver(Bool.self)

        let input = ChatRoomViewModel.Input(
            trigger: triggerTestableDriver,
            send: Driver.just(()),
            menu: Driver.just(()),
            content: Driver.just(""),
            disappear: Driver.just(())
        )
        let output = self.viewModel.transform(input: input)

        output.editableEnable
            .drive(testableObserver)
            .disposed(by: self.disposeBag)

        self.scheduler.start()

        XCTAssertEqual(testableObserver.events, [
            .next(240, false),
            .next(250, false),
            .next(260, false),
            .next(270, false),
            .next(280, false),
            .next(290, false)
        ])
    }

}

extension ChatRoomViewModelTests {

    final class MockChatRoomNavigator: ChatRoomNavigator {

        let enterAlertStream: PublishSubject<Bool>
        let sideAlertStream: PublishSubject<Side>
        let voteAlertStream: PublishSubject<Side>

        init() {
            self.enterAlertStream = PublishSubject<Bool>.init()
            self.sideAlertStream = PublishSubject<Side>.init()
            self.voteAlertStream = PublishSubject<Side>.init()
        }

        func toChatRoom(_ chatRoom: ChatRoom) {}

        func toSideMenu(_ chatRoom: ChatRoom) {}

        func toEnterAlert() -> Observable<Bool> {
            self.enterAlertStream
        }

        func toSideAlert() -> Observable<Side> {
            self.sideAlertStream
        }

        func toVoteAlert() -> Observable<Side> {
            self.voteAlertStream
        }

        func toDiscussionResultAlert(result: Discussion.Result) {}

        func appear() {}

        func disappear() {}

    }

}
