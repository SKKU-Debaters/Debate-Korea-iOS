//
//  DefaultAddChatRoomNavigator.swift
//  Virtual-Korea
//
//  Created by μ΄μ²­μ on 2022/06/26.
//

import Domain
import RxSwift
import UIKit

final class DefaultAddChatRoomNavigator: NSObject, AddChatRoomNavigator {

    // MARK: properties

    private let services: Domain.UsecaseProvider
    private let presentedViewController: UIViewController

    private var completion: ((URL?) -> Void)?

    private weak var presentingViewController: UIViewController?

    // MARK: - init/deinit

    init(services: Domain.UsecaseProvider, presentedViewController: UIViewController) {
        self.services = services
        self.presentedViewController = presentedViewController
    }

    deinit {
        print("π", self)
    }

    // MARK: - methods

    func toAddChatRoom(_ userID: String) {
        let viewController = AddChatRoomViewController()
        let viewModel = AddChatRoomViewModel(
            userID: userID,
            navigator: self,
            userInfoUsecase: self.services.makeUserInfoUsecase(),
            chatRoomUsecase: self.services.makeChatRoomsUsecase()
        )
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.presentedViewController.present(navigationController, animated: true)
        self.presentingViewController = viewController
    }

    func toChatRoomList() {
        self.presentedViewController.dismiss(animated: true)
    }

    func toSettingAppAlert() {
        let alert = UIAlertController(
            title: "μ€μ ",
            message: "κΆνμ΄ νμ©λμ΄μμ§ μμ΅λλ€. μ€μ  μ±μΌλ‘ μ΄λν΄μ κΆνμ νμ©ν΄μ£ΌμΈμ.",
            preferredStyle: .alert
        )
        let cancle = UIAlertAction(title: "μ·¨μ", style: .default)
        let confirm = UIAlertAction(title: "νμΈ", style: .default) { (UIAlertAction) in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alert.addAction(cancle)
        alert.addAction(confirm)
        self.presentingViewController?.present(alert, animated: true)
    }

    func toImagePicker() -> Observable<URL?> {
        return PublishSubject.create { [unowned self] subscribe in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.completion = { url in
                subscribe.onNext(url)
                subscribe.onCompleted()
            }
            self.presentingViewController?.present(imagePicker, animated: true)
            return Disposables.create()
        }.asObservable()
    }

    func toErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "μ€λ₯!",
            message: "μ€λ₯κ° λ°μνμ΅λλ€. μ¬μλν΄μ£ΌμΈμ..",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "νμΈ", style: .default)
        alert.addAction(confirm)
        self.presentingViewController?.present(alert, animated: true)
    }

}

extension DefaultAddChatRoomNavigator: UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let url = info[UIImagePickerController.InfoKey.imageURL] as? URL
        self.completion?(url)
        self.presentingViewController?.dismiss(animated: true)
    }

}
