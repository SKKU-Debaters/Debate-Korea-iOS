//
//  ChatRoomViewController.swift
//  Discussion-Korea
//
//  Created by 이청수 on 2022/05/02.
//

import SnapKit
import UIKit
import RxSwift
import RxKeyboard

final class ChatRoomViewController: UIViewController {

    // MARK: properties

    var viewModel: ChatRoomViewModel!

    private let menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .label
        button.image = UIImage(systemName: "line.3.horizontal")
        button.accessibilityLabel = "메뉴"
        return button
    }()

    private let noticeView: UILabel = {
        // TODO: 별도의 View를 만들어서 content가 있는지 없는지에 따라 자동으로 hidden 처리하기
        let label = PaddingLabel(padding: UIEdgeInsets(
            top: 8.0, left: 20.0, bottom: 8.0, right: 20.0)
        )
        label.numberOfLines = 2
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .label
        label.backgroundColor = UIColor.systemBackground
//        label.layer.cornerRadius = 4
        label.layer.shadowOpacity = 0.15
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.masksToBounds = false
        return label
    }()

    private let messageCollectionView: UICollectionView = {
        let messageCollectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewLayout.init()
        )
        messageCollectionView.backgroundColor = UIColor.systemGray6
        messageCollectionView.register(
            SelfChatCell.self, forCellWithReuseIdentifier: SelfChatCell.identifier
        )
        messageCollectionView.register(
            OtherChatCell.self, forCellWithReuseIdentifier: OtherChatCell.identifier
        )
        messageCollectionView.register(
            SerialOtherChatCell.self,
            forCellWithReuseIdentifier: SerialOtherChatCell.identifier
        )
        messageCollectionView.register(
            BotChatCell.self, forCellWithReuseIdentifier: BotChatCell.identifier
        )
        messageCollectionView.register(
            SerialBotChatCell.self, forCellWithReuseIdentifier: SerialBotChatCell.identifier
        )
        return messageCollectionView
    }()

    private let messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.font = UIFont.systemFont(ofSize: 14.0)
        messageTextView.isScrollEnabled = false
        messageTextView.layer.borderColor = UIColor.systemGray5.cgColor
        messageTextView.layer.borderWidth = 1.0
        messageTextView.backgroundColor = .systemGray6
        messageTextView.layer.cornerRadius = 15.0
        messageTextView.layer.masksToBounds = true
        messageTextView.accessibilityLabel = "채팅 내용"
        messageTextView.accessibilityHint = "채팅할 내용 입력"
        return messageTextView
    }()

    private let sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.setBackgroundImage(UIImage(systemName: "paperplane"), for: .disabled)
        sendButton.tintColor = UIColor.accentColor
        // TODO: 보내기버튼 둥글게 적용하기
//        sendButton.layer.borderColor = UIColor.primaryColor?.cgColor
//        sendButton.layer.borderWidth = 1.0
//        sendButton.layer.cornerRadius = 13
        sendButton.isEnabled = false
        sendButton.accessibilityLabel = "채팅 보내기"
        return sendButton
    }()

    private let disposeBag = DisposeBag()

    // MARK: - init/deinit

    deinit {
        print("🗑", Self.description())
    }

    // MARK: - methods

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubViews()
        self.bindViewModel()
    }

    private func setSubViews() {
        self.view.addSubview(self.messageCollectionView)
        self.view.addSubview(self.noticeView)
        let inputBackground = UIView()
        inputBackground.backgroundColor = .systemBackground
        self.view.addSubview(inputBackground)
        self.view.addSubview(self.messageTextView)
        self.view.addSubview(self.sendButton)
        self.navigationItem.rightBarButtonItem = self.menuButton
        self.noticeView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.greaterThanOrEqualTo(50)
        }
        self.messageCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.messageTextView.snp.top).offset(-10)
        }
        inputBackground.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.messageCollectionView.snp.bottom)
            make.bottom.equalTo(self.messageTextView.snp.bottom).offset(10)
        }
        self.messageTextView.snp.contentCompressionResistanceVerticalPriority = 751
        self.messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        self.sendButton.snp.makeConstraints { make in
            make.leading.equalTo(self.messageTextView.snp.trailing).offset(10)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.centerY.equalTo(self.messageTextView)
            make.width.height.equalTo(26)
        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 80)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 7
        self.messageCollectionView.collectionViewLayout = flowLayout

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                self.view.frame.origin.y = -keyboardVisibleHeight
            })
            .disposed(by: disposeBag)

    }

    private func bindViewModel() {
        assert(self.viewModel != nil)

        let input = ChatRoomViewModel.Input(
            trigger: self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            send: self.sendButton.rx.tap.asDriver(),
            menu: self.menuButton.rx.tap.asDriver(),
            content: self.messageTextView.rx.text.orEmpty.asDriver(),
            disappear: self.rx.sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
                .mapToVoid()
                .asDriverOnErrorJustComplete()
        )
        let output = self.viewModel.transform(input: input)

        output.chatItems.drive(self.messageCollectionView.rx.items) { collectionView, index, model in
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.identifier, for: indexPath) as? ChatCell
            else { return UICollectionViewCell() }
            cell.bind(model)
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = cell.getAccessibilityLabel(model)
            return cell
        }.disposed(by: self.disposeBag)

        output.notice.map { $0.isEmpty }.drive(self.noticeView.rx.isHidden)
            .disposed(by: self.disposeBag)

        output.notice.drive(self.noticeView.rx.text)
            .disposed(by: self.disposeBag)

        output.sendEnable
            .drive(self.sendButton.rx.isEnabled)
            .disposed(by: self.disposeBag)

        output.editableEnable
            .drive(self.messageTextView.rx.isEditable)
            .disposed(by: self.disposeBag)

        output.sendEvent
            .drive(onNext: { [unowned self] in
                self.messageTextView.text = ""
            })
            .disposed(by: self.disposeBag)

        output.events.drive().disposed(by: self.disposeBag)
    }

}
