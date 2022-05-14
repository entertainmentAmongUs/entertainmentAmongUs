//
//  ViewController.swift
//  WaitingRoom
//
//  Created by 김윤수 on 2022/02/14.
//

import UIKit

class WaitingRoom: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    // MARK: - Properties
    
    /* MARK: View */
    var buttonStackView: UIStackView?
    var roomSettingButton: UIButton?
    var exitButton: UIButton?
    var readyButton: UIButton?
    var waitUserCollection: UICollectionView?
    var waitUserView: UIView?
    var chatTextfield: UITextField?
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
    
    
    /* MARK: Create View Method */
    func addWaitingUserView() {
        
        let view = UIView()
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(view)
        
        view.backgroundColor = .systemGray3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 0).isActive = true
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
    
    func addButtons(){
        
        guard let view = self.waitUserView else { return }
        
        
        // readButton Setting
        
        let ready = UIButton(type: .system)
        
        ready.backgroundColor = .white
        ready.addTarget(self, action: #selector(self.touchReadyButton(_:)), for: .touchUpInside)
        ready.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ready.setTitle("준비", for: .normal)
        ready.setTitle("준비 완료!", for: .selected)
        
        self.readyButton = ready
        
        
        // exitButton Setting
        
        let exit = UIButton(type: .system)
        
        exit.backgroundColor = .white
        exit.addTarget(self, action: #selector(self.touchExitButton(_:)), for: .touchUpInside)
        exit.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        exit.setTitle("나가기", for: .normal)
        
        self.exitButton = exit
        
        
        // roomSettingButton Setting
        
        let setting = UIButton(type: .system)
        
        setting.backgroundColor = .white
        setting.setTitle("방 설정", for: .normal)
        setting.addTarget(self, action: #selector(self.touchSettingButton(_:)), for: .touchUpInside)
        setting.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        setting.isEnabled = Bool(myProfile.userID == Myroom.masterUserID)
        
        self.roomSettingButton = setting
        
        
        /* 버튼을 모아놓은 스택 뷰 설정 */
        
        let stack = UIStackView(arrangedSubviews: [exit, ready, setting])
        
        self.view.addSubview(stack)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.buttonStackView = stack
        
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
        
        guard let buttons = self.buttonStackView else { return }
        
        
        // ChattingTextField Setting
        
        let textField = UITextField()
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(textField)
        
        textField.placeholder = "채팅을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant:  -20).isActive = true
//        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.chatTextfield = textField
        
        
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
        
        
        /* 채팅 테이블 뷰 오토 레이아웃 */
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: buttons.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5 ).isActive = true
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
    
    func exile(_ index: Int) {
        
        /* 유저 리스트에서 특정 인덱스의 유저 삭제 */
        
        /*
        guard let collection = self.waitUserCollection else { return }
        
        let new = Profile(userID: 0, image: nil, nickname: "", score: 0, winCount: 0, loseCount: 0)
        
        Myroom.users.insert(new, at: 8)
        collection.insertItems(at: [IndexPath(row: 8, section: 0)])
        
        Myroom.users.remove(at: index)
        collection.deleteItems(at: [IndexPath(row: index, section: 0)])
        
        */
        
    }

    func getRoomInfo(){
        
        SocketIOManager.shared.fetchRoomInfo(roomId: roomId) { [weak self] roomInfo in
            
            self?.roomInfo = roomInfo
            
            self?.navigationItem.title = roomInfo.title
            
            self?.waitUserCollection?.reloadData()
            
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
    
    
    // MARK: - Action Method
    
    @objc func touchReadyButton(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
//        self.myProfileCell?.isReady.toggle()
        
        SocketIOManager.shared.getReady(roomId: roomId, userId: myUserId)
        
    }
    
    @objc func touchExitButton(_ sender: UIButton) {
        
        /*
        guard let collection = self.waitUserCollection else { return }
        guard let cell = self.myProfileCell else { return }
        guard let index = collection.indexPath(for: cell) else { return }
         
        self.exile(index.row)
        
        /* 내가 방장일때 다른 유저에게 권한 위임 */
        if Myroom.masterUserID == myProfile.userID {
            Myroom.masterUserID = Myroom.users[index.row].userID ?? 0
            collection.reloadItems(at: [index])
            
        }
        
        /* 내가 방장일때 방 설정 버튼 활성화 */
        self.roomSettingButton?.isEnabled = Bool(Myroom.masterUserID == myProfile.userID)
         */
        
        SocketIOManager.shared.leaveRoom(roomId: roomId, userId: myUserId)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @objc func touchSettingButton(_ sender: UIButton){
        
        guard let height = self.waitUserCollection?.frame.height else { return }

        guard let top = self.navigationController?.navigationBar.frame.height else { return }
        
        guard let roomInfo = roomInfo else { return }

        let view = RoomSetting(roomInfo, height, top)
        
        self.present(view, animated: true, completion: nil)
        
    }
    
    @objc func getNewChatting(noti:Notification) {
        
        let newChat = noti.object as! Chat
        
        if newChat.roomId != roomId { return }
        
        chattings.append(newChat)
        
        chatTableView?.reloadData()
        
        chatTableView?.scrollToRow(at: IndexPath(row: chattings.count-1, section: 0), at: .bottom, animated: true)
        
        
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
        
        /*
        if info.userID == nil {
            return false
        }
        */
        
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
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        let chatRoom = ChattingRoom(roomId: roomId, nickName: myNickName, chattings: chattings)
        
        self.present(chatRoom, animated: true, completion: nil)
         
        return false
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        self.addWaitingUserView()
        self.addButtons()
        self.addWaitUserCollectionView()
        self.addChatView()
        
        getRoomInfo()
        getUserList()
        getReadyToKicked()
        
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

