//
//  ViewController.swift
//  WaitingRoom
//
//  Created by 김윤수 on 2022/02/14.
//

import UIKit
import Spring

class WaitingRoom: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    // MARK: - Properties
    
    /* MARK: View */
    
    var roomSettingButton: UIBarButtonItem?
    var exitButton: UIBarButtonItem?
    var readyButton: UIButton?
    
    var waitUserCollection: UICollectionView?
    var waitUserView: UIView?
    var chatTableView: UITableView?
    
    /* MARK: Others */
    var waitUserViewHeightConstraint: NSLayoutConstraint?
    let profileIdentifier = "profile"
    let chatIdentifier = "chat"
    var myProfileCell: ProfileCell?
    
    var myNickName: String
    var myUserId: Int
    var roomId: String
    
    var roomInfo: Room?
    var chattings: [Chat] = []
    
    
    // MARK: - Method
    
    func setNavigationController() {
        
        /* 툴바 설정 */
        
        let chatButton = UIBarButtonItem(image: UIImage(systemName: "bubble.left.and.bubble.right")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchChatButton(_:)))
    
        toolbarItems = [UIBarButtonItem.flexibleSpace(),chatButton, UIBarButtonItem.flexibleSpace()]
        
        
        /* 네비게이션 아이템 설정 */
        let naviItem = self.navigationItem
        
        let titleView: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 25, weight: .bold)
            label.textColor = .black
            label.text = roomInfo?.title
            label.textAlignment = .center
            
            return label
            
        }()
        
        naviItem.titleView = titleView
        
        
        /* 로비의 네비게이션 바 버튼 아이템 설정 */
        let settingButton = UIBarButtonItem(image: .init(systemName: "gearshape")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchSettingButton(_:)))
        settingButton.isEnabled = myUserId == roomInfo?.hostId ? true : false
        
         let exitButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchExitButton(_:)))
        
        
        naviItem.setRightBarButton(settingButton, animated: true)
        naviItem.setLeftBarButton(exitButton, animated: true)
        
        self.roomSettingButton = settingButton
        self.exitButton = exitButton
        
        
    }
    
    /* MARK: Create View Method */
    func addWaitingUserView() {
        
        let view = UIView()
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(view)
        
        view.backgroundColor = .systemGray3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 20).isActive = true
        view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20).isActive = true
        view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -layoutGuide.layoutFrame.height/3).isActive = true
        
        /*
         
        let height = view.heightAnchor.constraint(equalToConstant: 2*self.view.safeAreaLayoutGuide.layoutFrame.size.height/3)
        height.isActive = true
        
        self.waitUserViewHeightConstraint = height
         
         */
        
        self.waitUserView = view
        
    }
    
    func addReadyButton(){
        
        guard let view = self.waitUserView else { return }
        
        // readButton Setting
        
        var config = UIButton.Configuration.plain()
        config.buttonSize = .small
        config.cornerStyle = .dynamic
        config.titleAlignment = .center
        
//        let ready = UIButton(configuration: config)
        let ready = SpringButton(configuration: config)
        
        self.view.addSubview(ready)
        
        ready.addTarget(self, action: #selector(self.touchReadyButton(_:)), for: .touchUpInside)
        
        ready.configurationUpdateHandler = { button in
            
            guard let button = button as? SpringButton else { return }
            
            var container = AttributeContainer()
            container.font = .systemFont(ofSize: 20, weight: .bold)
            
            var configuration = button.configuration
            
            switch button.state {
                
            case .selected:
                container.foregroundColor = .white
                configuration?.background.backgroundColor = .systemBlue
                configuration?.attributedTitle = AttributedString("준비 완료!", attributes: container)
                button.animation = "pop"
                button.curve = "spring"
                button.duration = 0.5
                button.force = 0.3
                button.animate()
            case .highlighted:
                break
            default:
                container.foregroundColor = .black
                configuration?.background.backgroundColor = .systemGray6
                configuration?.attributedTitle = AttributedString("준비", attributes: container)
                button.animation = "shake"
                button.curve = "spring"
                button.duration = 0.5
                button.force = 0.3
                button.animate()
                
            }
            
            button.configuration = configuration
            
        }
        
        /*
        /* 그림자 */
        ready.layer.shadowOffset = CGSize(width: 0, height: 3)
        ready.layer.shadowOpacity = 1.0
        ready.layer.shadowColor = UIColor.gray.cgColor
        ready.layer.shadowRadius = 1
        */
        
        ready.translatesAutoresizingMaskIntoConstraints = false
        ready.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        ready.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        ready.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        ready.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        
        self.readyButton = ready
        
        
    }
    
    func addWaitUserCollectionView() {
        
        guard let view = self.waitUserView else { return }
        
        
        // CollectionViewFlowLayout Setting
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        
        
        // CollectionView Setting
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(ProfileCell.self, forCellWithReuseIdentifier: self.profileIdentifier)
        
        
        /* 컬렉션 뷰 오토 레이아웃 설정 */
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.waitUserCollection = collection
        
    }
    
    
    func addChatView() {
        
        guard let buttons = self.readyButton else { return }

        let layoutGuide = self.view.safeAreaLayoutGuide
        
        // ChattingTableView Setting
        
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        /* 채팅 테이블 뷰 속성 설정 */
        table.delegate = self
        table.dataSource = self
        table.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        
        table.layer.cornerRadius = 3
        table.clipsToBounds = true
        table.separatorStyle = .none
        table.allowsSelection = false
        table.backgroundColor = .systemGray6
        
        
        /* 채팅 테이블 뷰 오토 레이아웃 */
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: buttons.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 0).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -0).isActive = true
        table.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0 ).isActive = true
        table.setContentHuggingPriority(.defaultLow, for: .vertical)
        table.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.chatTableView = table
        
        
    }
    
    
    /* MARK: Function Method */
    
    func updateWaitUserViewConstraint() {
        
        /* 화면이 변할때 마다 컬렉션 뷰 높이 갱신 */
        
        guard let constraint = self.waitUserViewHeightConstraint else {return}
        
        let height = 2*(self.view.safeAreaLayoutGuide.layoutFrame.height)/3
        
        constraint.constant = height
        
    }
    

    func getRoomInfo(){
        
        SocketIOManager.shared.fetchRoomInfo(roomId: roomId) { [weak self] roomInfo in
            
            self?.roomInfo = roomInfo
            
            (self?.navigationItem.titleView as? UILabel)?.text = roomInfo.title
            
            self?.waitUserCollection?.reloadData()
            
            self?.roomSettingButton?.isEnabled = roomInfo.hostId == self?.myUserId ? true : false
            
        }
        
    }
    
    func getUserList() {
        
        SocketIOManager.shared.fetchUserList { [weak self] userList in
            
            self?.roomInfo?.users = userList
            
            self?.waitUserCollection?.reloadData()
            
        }
        
    }
    
    func getReadyToKicked() {
        
        SocketIOManager.shared.getKicked { [unowned self] userId in
            
            if myUserId == userId {
                SocketIOManager.shared.leaveRoom(roomId: roomId, userId: myUserId)
                
                self.navigationController?.popViewController(animated: true)
                
                NotificationCenter.default.post(name: NSNotification.Name("getKickedNotification"), object: nil)
                
            }
        }
        
    }
    
    func getReadyToStarted() {
        
        SocketIOManager.shared.startGame { [unowned self] playingInfo in
            
            guard let userList = roomInfo?.users else { return }
            
            let playingRoom = PlayingRoom(userId: myUserId, nickName: myNickName, playingInfo: playingInfo, userList: userList, roomId: roomId)
            
            self.navigationController?.pushViewController(playingRoom, animated: true)
            
            readyButton?.isSelected = false
            
        }
        
        
    }
    
    
    // MARK: - Action Method
    
    @objc func touchReadyButton(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        SocketIOManager.shared.getReady(roomId: roomId, userId: myUserId)
        
    }
    
    @objc func touchExitButton(_ sender: UIBarButtonItem) {
        
        
        SocketIOManager.shared.leaveRoom(roomId: roomId, userId: myUserId)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @objc func touchChatButton(_ sender: UIBarButtonItem){
        
        guard let roomId = roomInfo?.roomId else { return }
        
        let chatRoom = ChattingRoom(roomId: roomId, nickName: self.myNickName, chattings: self.chattings)
        
        self.present(chatRoom, animated: true, completion: nil)
        
        
    }
    
    
    @objc func touchSettingButton(_ sender: UIBarButtonItem){
        
        guard let roomInfo = roomInfo else { return }

        let view = SettingRoom(userId: myUserId, roomInfo: roomInfo)
        
        self.navigationController?.pushViewController(view, animated: true)
        
    }
    
    @objc func getNewChatting(noti:Notification) {
        
        let newChat = noti.object as! Chat
        
        if newChat.roomId != roomId { return }
        
        chattings.append(newChat)
        
        let newIndex = IndexPath(row: chattings.count-1, section: 0)
        
        chatTableView?.insertRows(at: [newIndex], with: .left)
        
//        chatTableView?.reloadData()
        
        chatTableView?.scrollToRow(at: newIndex, at: .bottom, animated: true)
        
        
    }
    
    
    // MARK: - CollectionView DataSoruce
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomInfo?.users.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.profileIdentifier, for: indexPath) as! ProfileCell
        
        cell.isReady = false
        cell.isRoomMaster = false
        
        guard let user = roomInfo?.users[indexPath.row] else { return cell }
        
        /* 내 프로필이 담긴 셀 저장 */
        if user.userId == myUserId {
            self.myProfileCell = cell
        }
        
        /* 방장 셀의 속성 변경 */
        if roomInfo?.hostId == user.userId  {
            cell.isRoomMaster = true
        }
        
        if user.isReady == true {
            
            cell.isReady = true
        }
                   
        
        cell.nickname?.text = user.nickName
        cell.image?.image = UIImage(named: "ic_user_loading")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize()}
        
        /* 2x4 크기의 셀 사이즈 설정 */
        let size = CGSize(width: (collectionView.bounds.width - layout.minimumInteritemSpacing)/2, height: (collectionView.bounds.height - 3*layout.minimumLineSpacing)/4)
        
        return size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        
        guard let roomInfo = roomInfo else { return false }

        let user = roomInfo.users[indexPath.row]
        
        let profileView = ProfileViewController(roomId: roomId, userId: user.userId, myUserId: myUserId, hostId: roomInfo.hostId)
        
        self.present(profileView, animated: true, completion: nil)
        
        return false
        
    }
     
    
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.chatIdentifier, for: indexPath) as! ChatCell
        
        let chat = chattings[indexPath.row]
        cell.nickname?.text = chat.nickName
        cell.chatting?.text = chat.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setNavigationController()
        self.addWaitingUserView()
        self.addReadyButton()
        self.addWaitUserCollectionView()
        self.addChatView()
        
        getRoomInfo()
        getUserList()
        getReadyToKicked()
        getReadyToStarted()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.updateWaitUserViewConstraint()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        
    }
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(userId: Int, nickName: String, roomId: String) {
        self.myUserId = userId
        self.myNickName = nickName
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNewChatting(noti:)), name: Notification.Name("newChatNotification"), object: nil)
        
    }
    
    deinit {
        print("WaitingRoom deint")
    }
}

