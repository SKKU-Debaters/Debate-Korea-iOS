//
//  DefaultChatRoomListNavigator.swift
//  Virtual-Korea
//
//  Created by 이청수 on 2022/06/26.
//

import Domain
import UIKit
import RxSwift

final class DefaultChatRoomListNavigator: ChatRoomListNavigator {

    // MARK: properties

    private let services: Domain.UsecaseProvider
    private let navigationController: UINavigationController

    private weak var presentingViewController: UIViewController?

    // MARK: - init/deinit

    init(services: Domain.UsecaseProvider,
         navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }

    deinit {
        print("🗑", self)
    }

    // MARK: - methods

    func toChatRoomList() {
        let chatRoomListViewController = ChatRoomListViewController()
        let chatRoomListViewModel = ChatRoomListViewModel(
            navigator: self,
            chatRoomsUsecase: self.services.makeChatRoomsUsecase(),
            userInfoUsecase: self.services.makeUserInfoUsecase()
        )
        chatRoomListViewController.viewModel = chatRoomListViewModel
        self.navigationController.pushViewController(chatRoomListViewController, animated: true)
        self.presentingViewController = chatRoomListViewController
    }

    func toChatRoom(_ uid: String, _ chatRoom: ChatRoom) {
        let chatRoomNavigator = DefaultChatRoomNavigator(
            services: self.services,
            navigationController: self.navigationController
        )
        chatRoomNavigator.toChatRoom(uid, chatRoom)
    }

    func toAddChatRoom(_ userID: String) {
        guard let presentingViewController = presentingViewController
        else { return }
        let addChatRoomNavigator = DefaultAddChatRoomNavigator(
            services: self.services,
            presentedViewController: presentingViewController
        )
        addChatRoomNavigator.toAddChatRoom(userID)
    }

}
