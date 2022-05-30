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
    
    var roomCreateButton: UIButton?
    var roomSearchButton: UIButton?
    var roomRefreshButton: UIButton?
    var buttonStack: UIStackView?
    
    var chatTextField: UITextField?
    var chatTableView: UITableView?
    let chatIdentifier = "chat"
    
    var myUserId: Int
    var myNickName: String
    
    
    var lobbyUserList: [User] = []
    var roomList: [Room] = []
    var lobbyChattings: [Chat] = []
    
    
    lazy var sideMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(touchSideMenuButton(_:)))
        
        return button
    }()
    
    
    
    // MARK: - Method
    
    // MARK: Create View Method
    
    func addRoomListTableView(){
        
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(RoomCell.self, forCellReuseIdentifier: self.roomCellIdentifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        table.topAnchor.constraint(equalTo: layoutGuide.topAnchor,constant: 0).isActive = true
        table.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor,constant: -layoutGuide.layoutFrame.size.height/3).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor,constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor,constant: -20).isActive = true
        
        self.roomListTableView = table
        
    }
    
    func addButton(){
        
        guard let roomListTableView = self.roomListTableView else { return }
        
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("방 검색", for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 20,weight: .regular)
        searchButton.addTarget(self, action: #selector(self.touchRoomSearchButton(_:)), for: .touchUpInside)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
        self.roomSearchButton = searchButton
        
        
        let createButton = UIButton(type: .system)
        createButton.setTitle("방 생성", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 20,weight: .regular)
        createButton.addTarget(self, action: #selector(self.touchRoomCreateButton(_:)), for: .touchUpInside)
        createButton.setTitleColor(.systemBlue, for: .normal)
        
        self.roomCreateButton = createButton
        
        let refreshButton = UIButton(type: .system)
        refreshButton.setTitle("새로고침", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 20,weight: .regular)
        refreshButton.addTarget(self, action: #selector(self.touchRoomRefreshButton(_:)), for: .touchUpInside)
        refreshButton.setTitleColor(.systemBlue, for: .normal)
        
        self.roomRefreshButton = refreshButton
        
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [searchButton, refreshButton, createButton])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: roomListTableView.bottomAnchor,constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        
        self.buttonStack = stackView
        
    }
    
    func addChatView(){
        
        guard let buttonStack = self.buttonStack else { return }
        
        let textField = UITextField()
        
        self.view.addSubview(textField)
        
        textField.placeholder = "채팅을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.chatTextField = textField
        
        
        // ChattingTableView Setting
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        
        table.layer.cornerRadius = 3
        table.clipsToBounds = true
        table.backgroundColor = .systemGray5
        table.separatorStyle = .none
        table.allowsSelection = false
        table.sectionHeaderHeight = 0
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5 ).isActive = true
        
        self.chatTableView = table
    }
    
    
    // MARK: Action Method
    
    
    @objc func touchSideMenuButton(_ sender: UIButton) {
        /* 그냥 처음에 대충 넣은 것.
         let sideBar = SideMenuViewController()
         self.navigationController?.pushViewController(SideBar, animated: true)
         
         이번엔 present이용해서 사용.
         present(sideBar, animated: true, completion: nil)
         */
        
        let sideMenuViewController = SideMenuViewController(userList: self.lobbyUserList)
        let sideMenuNavi = SideMenuNavigationController(rootViewController: sideMenuViewController)
        
        sideMenuViewController.navigationItem.title = "사이드바"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        
        sideMenuNavi.navigationBar.scrollEdgeAppearance = appearance
        sideMenuNavi.navigationBar.standardAppearance = appearance
        
        present(sideMenuNavi,animated: true,completion: nil)
        
    }
    
    
    
    @objc func touchRoomCreateButton(_ sender: UIButton){
        
        /*
         let roomCreateButtonView = RoomCreateButtonController()
         roomCreateButtonView.modalTransitionStyle = .crossDissolve
         roomCreateButtonView.modalPresentationStyle = .overCurrentContext
         //present로 화면 전환 해보는 것 응용함.
         present(roomCreateButtonView,animated: true, completion: nil)
         */
        
        guard let height = self.roomListTableView?.frame.height else { return }
        guard let top = self.navigationController?.navigationBar.frame.height else { return }
        
        let roomSettingController = RoomCreating(myUserId, height, top)
        
        present(roomSettingController, animated: true)
        
    }
    
    
    @objc func touchRoomSearchButton(_ sender: UIButton){
        
        //let SignUpView = SignUpViewController()
        //self.navigationController?.pushViewController(SignUpView, animated: true)
        
    }
    
    @objc func touchRoomRefreshButton(_ sender: UIButton){
        
        SocketIOManager.shared.refreshRoomList()
        
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
            
            self?.roomListTableView?.reloadData()
            
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "로비"
        self.navigationItem.rightBarButtonItem = self.sideMenuButton
        
        self.addRoomListTableView()
        self.addButton()
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
//            games[room.gameType.rawValue]
            
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
            view.backgroundColor = .white
            
            let gameType = UILabel()
            
            gameType.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            gameType.text = "종류"
            gameType.textAlignment = .center
            gameType.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            gameType.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            
            let roomTitle = UILabel()
            
            roomTitle.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            roomTitle.text = "방 제목"
            roomTitle.textAlignment = .center
            roomTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
            roomTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            let password = UILabel()
            
            password.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            password.text = "암호"
            password.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let userCount = UILabel()
            
            userCount.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            userCount.text = "인원"
            userCount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let stackView = UIStackView(arrangedSubviews: [gameType, roomTitle, password, userCount])
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 20
            
            view.addSubview(stackView)
            
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            
            return view
            
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
                                                
       
        /*
        let roomId = roomList[indexPath.row].roomId
        
        SocketIOManager.shared.joinRoom(roomId: <#T##String#>, completionHanlder: <#T##([[String : Any]]) -> Void##([[String : Any]]) -> Void##(_ userList: [[String : Any]]) -> Void#>)
        
        let waittingRoom = WaittingRoom(userId: self.myUserId, nickName: self.myNickName, roomId: roomId)
        
        self.navigationController?.pushViewController(waittingRoom, animated: true)
        */
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
