//
//  SettingNavigator.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/19.
//

import Domain
import UIKit

protocol SettingNavigator {

    func toSetting()
    func toOpenSource()

}

final class DefaultSettingNavigator: SettingNavigator {

    // MARK: properties

    private let services: Domain.UsecaseProvider
    private let navigationController: UINavigationController

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

    func toSetting() {
        self.makeOpaqueNavigationBar()
        let settingViewController = SettingViewController()
        settingViewController.contents = ["오픈소스 라이선스 이용고지"]
        settingViewController.selected = [toOpenSource]
        settingViewController.title = "설정"
        self.navigationController.pushViewController(settingViewController, animated: true)
    }

    private func makeOpaqueNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController.navigationBar.standardAppearance = appearance
    }

    func toOpenSource() {
        let openSourceNavigator = DefaultOpenSourceNavigator(navigationController: self.navigationController)
        openSourceNavigator.toOpenSource()
    }

}
