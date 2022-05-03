//
//  Lobby.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/02.
//

import UIKit

class Lobby: UIViewController  {
    
    // MARK: - Properties
    
    var sideButton: UIButton?
    
    var roomListTableView: UITableView?
    var roomListTableViewHeightConstraint: NSLayoutConstraint?
    let roomCellIdentifier = "roomCell"
    
    var roomCreateButton: UIButton?
    var roomSearchButton: UIButton?
    var buttonStack: UIStackView?
    
    var chatTextField: UITextField?
    var chatTableView: UITableView?
    let chatIdentifier = "chat"
    
    var myUserId: Int
    var myNickName: String
    
    
    var connectedUserList: [[String:Any]] = []
    var roomList: [[String:Any]] = []
    var lobbyChattings: [[String:String]] = []
    
    
    lazy var rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem()
            
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
        searchButton.titleLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        searchButton.addTarget(self, action: #selector(self.touchRoomSearchButton(_:)), for: .touchUpInside)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
        self.roomSearchButton = searchButton
        
        
        let createButton = UIButton(type: .system)
        createButton.setTitle("방 생성", for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        createButton.addTarget(self, action: #selector(self.touchRoomCreateButton(_:)), for: .touchUpInside)
        createButton.setTitleColor(.systemBlue, for: .normal)
        
        self.roomCreateButton = createButton
        
        
        let stackView: UIStackView = {
           let stackView = UIStackView(arrangedSubviews: [searchButton, createButton])
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
    
    /*
    @objc func presentSideMenu(_ sender: UIButton) {
        /* 그냥 처음에 대충 넣은 것.
        let sideBar = SideMenuViewController()
        self.navigationController?.pushViewController(SideBar, animated: true)
        
        이번엔 present이용해서 사용.
        present(sideBar, animated: true, completion: nil)
         */
        
        let SideMenuViewController = SideMenuViewController()
        let CustomSideMenuNavi = CustomSideMenuNavigation(rootViewController: SideMenuViewController)

        
        present(CustomSideMenuNavi,animated: true,completion: nil)
    }
    
    */
    
    @objc func touchRoomCreateButton(_ sender: UIButton){
        
        /*
        let roomCreateButtonView = RoomCreateButtonController()
        roomCreateButtonView.modalTransitionStyle = .crossDissolve
        roomCreateButtonView.modalPresentationStyle = .overCurrentContext
        //present로 화면 전환 해보는 것 응용함.
        present(roomCreateButtonView,animated: true, completion: nil)
        */
        
    }
    
     
    @objc func touchRoomSearchButton(_ sender: UIButton){
        
        //let SignUpView = SignUpViewController()
        //self.navigationController?.pushViewController(SignUpView, animated: true)
        
    }
    
    @objc func getNewLobbyChatting(noti:Notification) {
        
        let newLobbyChat = noti.object as! [String:String]
        
        lobbyChattings.append(newLobbyChat)
        
        chatTableView?.reloadData()
        
        
    }
    
    @objc func getConnectedUserList(noti:Notification) {
        
        let userList = noti.object as! [[String: Any]]
        
        self.connectedUserList = userList
        
    }
    
    // MARK: Function Method
    
    func tryConnectionToWebSocketServer(){
        
        SocketIOManager.shared.establishConnection(userId: self.myUserId, nickName: self.myNickName)
        
        
    }
    
    func getLobbyData(){
        
        SocketIOManager.shared.getConnectedUserList()
        
        SocketIOManager.shared.getLobbyChatting()
        
        SocketIOManager.shared.getRoomList { [weak self] roomList in
            
            self?.roomList = roomList
            
            self?.roomListTableView?.reloadData()
            
        }
    }
   
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "로비"
        self.navigationItem.rightBarButtonItem = self.rightButton
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNewLobbyChatting(noti:)), name: Notification.Name("newLobbyChatMessageNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getConnectedUserList(noti:)), name: Notification.Name("getConnectedUserListNotification"), object: nil)
        
    }
        
    
}
    
// MARK: - Extension

extension Lobby: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = tableView == roomListTableView ? roomList.count : lobbyChattings.count
        
        return numberOfRows
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //3번
        if tableView == roomListTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.roomCellIdentifier, for: indexPath) as! RoomCell
            let room = roomList[indexPath.row]
            //RoomCell 변수 = model 변수
            cell.gameTypeLabel?.text = "\(room["gameType"] as! Int)"
            
            cell.roomTitleLabel?.text = room["title"] as? String
            
            if room["password"] as! String == "" {
                cell.keyImageView?.image = UIImage(systemName: "")
            }
            else {
                cell.keyImageView?.image = UIImage(systemName: "key")
            }
            
            cell.userCountLabel?.text = "\(room["maxUser"] as! Int)명"
            
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.chatIdentifier, for: indexPath) as! ChatCell
            let chat = lobbyChattings[indexPath.row]
            //RoomCell 변수 = model 변수
            
            cell.nickname?.text = chat["nickName"]
            cell.chatting?.text = chat["message"]
            
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
        
        let waittingRoom = WaittingRoom()
        
        self.navigationController?.pushViewController(waittingRoom, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
}

//textField누르면 화면 전환 일어난다.
extension Lobby: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let chatRoom = LobbyChattingRoom(nickName: self.myNickName, chattings: self.lobbyChattings)
        self.present(chatRoom, animated: true, completion: nil)
        
        return false
        
    }

}
