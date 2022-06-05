//
//  Lobby.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/02.
//

import UIKit
import SideMenu

class Lobby: UIViewController  {
    
    // MARK: - Properties
    
    var sideButton: UIButton?
    
    var roomListTableView: UITableView?
    let roomCellIdentifier = "roomCell"
    
    var roomCreateButton: UIBarButtonItem?
    var sideMenuButton: UIBarButtonItem?
    var roomFilterButton: UIBarButtonItem?
    
    var buttonStack: UIStackView?
    
    var chatTextField: UITextField?
    var chatTableView: UITableView?
    let chatIdentifier = "chat"
    
    var myUserId: Int
    var myNickName: String
    
    
    var lobbyUserList: [User] = []
    var roomList: [Room] = []
    var lobbyChattings: [Chat] = []
    
    
    
    // MARK: - Method
    
    // MARK: Create View Method
    
    func setNavigationController() {
        
        /* 툴바 설정 */
        
        guard let toolBar = self.navigationController?.toolbar else { return }
        
        let toolBarAppearance = UIToolbarAppearance()
        toolBarAppearance.configureWithDefaultBackground()
        
        self.navigationController?.isToolbarHidden = false
        toolBar.standardAppearance = toolBarAppearance
        toolBar.scrollEdgeAppearance = toolBarAppearance
        
        let chatButton = UIBarButtonItem(image: UIImage(systemName: "bubble.left.and.bubble.right")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchChatButton(_:)))
    
        toolbarItems = [UIBarButtonItem.flexibleSpace(),chatButton, UIBarButtonItem.flexibleSpace()]
        
        
        /* 네비게이션 아이템 설정 */
        let naviItem = self.navigationItem
        
        let titleView: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 25, weight: .bold)
            label.textColor = .black
            label.text = "로비"
            label.textAlignment = .left
            
            return label
            
        }()
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        naviItem.scrollEdgeAppearance = appearance
        naviItem.standardAppearance = appearance
        
        
        /* 로비의 네비게이션 바 버튼 아이템 설정 */
        let sideButton = UIBarButtonItem(image: .init(systemName: "list.bullet")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchSideMenuButton(_:)))
        
         let createButton = UIBarButtonItem(image: UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchRoomCreateButton(_:)))
        
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), style: .plain, target: self, action: #selector(touchRoomFilterButton(_:)))
        
        naviItem.setRightBarButtonItems([sideButton, createButton, filterButton], animated: true)
        naviItem.setLeftBarButton(UIBarButtonItem(customView: titleView), animated: true)
        
        self.sideMenuButton = sideButton
        self.roomCreateButton = createButton
        self.roomFilterButton = filterButton
        
        
    }
    
    func addRoomListTableView(){
        
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(RoomCell.self, forCellReuseIdentifier: self.roomCellIdentifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.backgroundColor = .systemGray6
        table.sectionHeaderTopPadding = 10
        
        /*
        table.layer.shadowOffset = CGSize(width: 1, height: 1)
        table.layer.shadowOpacity = 0.5
        table.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        table.layer.shadowRadius = 0
        table.layer.masksToBounds = false
        */
        
        
        
        table.refreshControl = {
            let refresh = UIRefreshControl()
            refresh.addTarget(self, action: #selector(touchRoomRefreshButton(_:)), for: .valueChanged)
            return refresh
        }()
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        table.topAnchor.constraint(equalTo: layoutGuide.topAnchor,constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor,constant: -layoutGuide.layoutFrame.size.height/3).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,constant: 0).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor,constant: -0).isActive = true
        
        self.roomListTableView = table
        
    }
    
    
    func addChatView(){
        
        guard let roomListTableView = roomListTableView else {
            return
        }
        
        
        // ChattingTableView Setting
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        
        table.layer.cornerRadius = 3
        table.clipsToBounds = true
        table.backgroundColor = .systemGray6
        table.separatorStyle = .none
        table.allowsSelection = false
        table.sectionHeaderTopPadding = 10
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.topAnchor.constraint(equalTo: roomListTableView.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -0).isActive = true
        table.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0 ).isActive = true
        
        self.chatTableView = table
    }
    
    
    // MARK: Action Method
    
    
    @objc func touchSideMenuButton(_ sender: UIButton) {
       
        let sideMenuViewController = SideMenuViewController(userList: self.lobbyUserList)
        let sideMenuNavi = SideMenuNavigationController(rootViewController: sideMenuViewController)
        
        sideMenuViewController.navigationItem.title = "메뉴"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        
        sideMenuNavi.navigationBar.scrollEdgeAppearance = appearance
        sideMenuNavi.navigationBar.standardAppearance = appearance
        
        present(sideMenuNavi,animated: true,completion: nil)
        
    }
    
    
    
    @objc func touchRoomCreateButton(_ sender: UIButton){
        
        guard let height = self.roomListTableView?.frame.height else { return }
        guard let top = self.navigationController?.navigationBar.frame.height else { return }
        
//        let roomSettingController = RoomCreating(myUserId, height, top)
        let roomSettingController = SettingRoomController(userId: myUserId)
    
        self.navigationController?.pushViewController(roomSettingController, animated: true)
        
    }
    
    
    @objc func touchRoomFilterButton(_ sender: UIButton){
        
        //let SignUpView = SignUpViewController()
        //self.navigationController?.pushViewController(SignUpView, animated: true)
        
    }
    
    @objc func touchRoomRefreshButton(_ sender: UIButton){
        
        SocketIOManager.shared.refreshRoomList()
        
    }
    
    @objc func touchChatButton(_ sender: UIButton){
        
        let chatRoom = ChattingRoom(roomId: "LOBBY",nickName: self.myNickName, chattings: self.lobbyChattings)
        
        self.present(chatRoom, animated: true, completion: nil)
        
        
    }
    
    @objc func getNewChatting(noti:Notification) {
        
        let newChat = noti.object as! Chat
        
        if newChat.roomId != "LOBBY"{
            return
        }
        
        lobbyChattings.append(newChat)
        
        chatTableView?.reloadData()
        
        chatTableView?.scrollToRow(at: IndexPath(row: lobbyChattings.count-1, section: 0), at: .bottom, animated: true)
        
        
    }
    
    @objc func getLobbyUserList(noti:Notification) {
        
        let userList = noti.object as! [User]
        
        self.lobbyUserList = userList
        
    }
    
    @objc func enterCreatedRoom(noti: Notification) {
        
        let roomId = noti.object as! String
        let waittingRoom = WaitingRoom(userId: self.myUserId, nickName: self.myNickName, roomId: roomId)
        
        self.navigationController?.pushViewController(waittingRoom, animated: true)
        
    }
    
    @objc func showKickAlert(noti: Notification){
        
        let alertController = UIAlertController(title: "알림", message: "방장에 의해 추방당했습니다.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        self.present(alertController, animated: true)
        
    }
    
    // MARK: Function Method
    
    func tryConnectionToWebSocketServer(){
        
        SocketIOManager.shared.establishConnection(userId: self.myUserId, nickName: self.myNickName)
        
        
    }
    
    func getLobbyData(){
        
        SocketIOManager.shared.fetchLobbyUserList()
        
        SocketIOManager.shared.fetchLobbyChatting()
        
        SocketIOManager.shared.fetchRoomList { [weak self] roomList in
            
            self?.roomList = roomList
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self?.roomListTableView?.reloadData()
                self?.roomListTableView?.refreshControl?.endRefreshing()
            }
            
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setNavigationController()
        self.addRoomListTableView()
        self.addChatView()
        
        tryConnectionToWebSocketServer()
        getLobbyData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        fatalError("fatal Error")
    }
    
    init(id: Int, nickName: String) {
        self.myUserId = id
        self.myNickName = nickName
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNewChatting(noti:)), name: Notification.Name("newChatNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getLobbyUserList(noti:)), name: Notification.Name("getLobbyUserListNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enterCreatedRoom(noti:)), name: Notification.Name("enterCreatedRoomNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKickAlert(noti:)), name: Notification.Name("getKickedNotification"), object: nil)
    }
    
    
}

// MARK: - Extension

extension Lobby: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = tableView == roomListTableView ? roomList.count : lobbyChattings.count
        
        return numberOfRows
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == roomListTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.roomCellIdentifier, for: indexPath) as! RoomCell
            
            let room = roomList[indexPath.row]
            
            cell.gameTypeLabel?.text = room.gameType.rawValue
            
            cell.roomTitleLabel?.text = room.title
            
            cell.keyImageView?.image = UIImage(systemName: "key")
            
            if room.password == nil {
                cell.keyImageView?.alpha = 0
            } else {
                cell.keyImageView?.alpha = 1
            }
            
            cell.userCountLabel?.text = "\(room.maxUser)명"
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.chatIdentifier, for: indexPath) as! ChatCell
            let chat = lobbyChattings[indexPath.row]
            //RoomCell 변수 = model 변수
            
            cell.nickname?.text = chat.nickName
            cell.chatting?.text = chat.message
            
            return cell
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if tableView == self.roomListTableView {
            
            let view = UIView()
            view.backgroundColor = .systemGray6
            
            let gameType = UILabel()
            
            gameType.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            gameType.text = "종류"
            gameType.textAlignment = .center
            gameType.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            gameType.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            gameType.textColor = .gray
            
            let roomTitle = UILabel()
            
            roomTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            roomTitle.text = "방 제목"
            roomTitle.textAlignment = .center
            roomTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
            roomTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            roomTitle.textColor = .gray
            
            let password = UILabel()
            
            password.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            password.text = "암호"
            password.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            password.textColor = .gray
            
            let userCount = UILabel()
            
            userCount.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            userCount.text = "인원"
            userCount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            userCount.textColor = .gray
            
            let stackView = UIStackView(arrangedSubviews: [gameType, roomTitle, password, userCount])
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 20
            
            view.addSubview(stackView)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
            
            return view
            
        }
        
        return nil
         
    }
     
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.chatTableView {
            return "로비 채팅"
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let roomInfo = roomList[indexPath.row]
        
        let completionHandler: (_ status: JoinStatus) -> Void = {status in
            
            let message: String
            
             switch status {
                 
             case .success:
                 let waitingRoom = WaitingRoom(userId: self.myUserId, nickName: self.myNickName, roomId: roomInfo.roomId)
                 self.navigationController?.pushViewController(waitingRoom, animated: true)
                 return
             case .alreadyStarted:
                 message = "이미 게임이 시작된 방입니다."
             case .fullUser:
                 message = "방이 가득찼습니다."
             case .passwordIncorrect:
                 message = "비밀번호가 일치하지 않습니다."
             case .unexist:
                 message = "존재하지 않는 방입니다."
             }
            
            let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alertController, animated: true)
        }
        
        
        if let _ = roomInfo.password {
            
            let alertController = UIAlertController(title: "비밀번호", message: "비밀번호를 입력하세요", preferredStyle: .alert)
            alertController.addTextField()
            
            let cancleAction = UIAlertAction(title: "취소", style: .cancel)
            
            let okAction = UIAlertAction(title: "확인", style: .default) { [unowned self] action in
                let password = alertController.textFields?[0].text
                
                SocketIOManager.shared.joinRoom(roomId: roomInfo.roomId, userId: myUserId, password: password, completionHandler: completionHandler)
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancleAction)
            
            self.present(alertController, animated: true)
            
        } else {
            
            SocketIOManager.shared.joinRoom(roomId: roomInfo.roomId, userId: myUserId, password: nil, completionHandler: completionHandler)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
                                                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
}

//textField누르면 화면 전환 일어난다.
extension Lobby: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let chatRoom = ChattingRoom(roomId: "LOBBY",nickName: self.myNickName, chattings: self.lobbyChattings)
        self.present(chatRoom, animated: true, completion: nil)
        
        return false
        
    }
    
}
