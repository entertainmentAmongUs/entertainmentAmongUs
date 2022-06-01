//
//  ChattingRoom.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/06/01.
//

import UIKit

class ChattingRoom: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    // MARK: - Properties
    
    /* MARK: Views */
    var chatTableView: UITableView?
    var chatTextField: UITextField?
    
    /* MARK: Others */
    let chatIdentifier = "chat"
    var textFieldBottomConstraint: NSLayoutConstraint?
    
    var myNickname: String
    var roomId: String
    
    var chattings: [Chat]
    
    
    // MARK: - Method
    
    func addTableView() {
        
        guard let textField = self.chatTextField else {return}
        
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.allowsSelection = false
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10).isActive = true
        table.setContentHuggingPriority(.defaultLow, for: .vertical)
        table.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.chatTableView = table
        
    }
    
    func addChatTextField() {
        
        let textField = UITextField()
        
        self.view.addSubview(textField)
        
        textField.delegate = self
        textField.borderStyle = .bezel
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.enablesReturnKeyAutomatically = true
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.placeholder = "욕설이나 비방 채팅은 삼가주세요"
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        /* 채팅 입력 필드의 하단 오토 레이아웃 저장 */
        
        let bottom = textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        bottom.isActive = true
        self.textFieldBottomConstraint = bottom
        
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.chatTextField = textField
        
    }
    
    func reloadChattings(_ index: IndexPath) {
        
        /* WaittingRoom의 채팅 테이블 뷰 갱신 */
        
        guard let waittingRoom = self.presentingViewController as? WaitingRoom else {return}
        
        waittingRoom.chatTableView?.reloadData()
        waittingRoom.chatTableView?.scrollToRow(at: index, at: .bottom, animated: false)
        
    }
    
    // MARK: - Action
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow (_ noti: Notification) {
        
        /* 키보드 높이에 맞춰 채팅 입력 필드의 오토 레이아웃 갱신 */
        
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.textFieldBottomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -(10 + keyboardSize.height - self.view.safeAreaInsets.bottom)
        }
        
        
    }
    
    @objc func keyboardWillHide (_ noti: Notification) {
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.textFieldBottomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -20
        }
        
    }
    
    @objc func keyboardDidShow(_ noti: Notification) {
        
        /* 키보드 등장 후 테이블 뷰 스크롤을  맨 밑으로 이동 */
        
        
        guard let table = self.chatTableView else { return }
        
        let chatCount = chattings.count
        
        if chatCount > 0 {
            
            table.scrollToRow(at: IndexPath(row: chattings.count-1, section: 0), at: .bottom, animated: true)
            
        }
        
    }
    
    
    @objc func getNewChatting(noti:Notification) {
        
        let newChat = noti.object as! Chat
        
        chattings.append(newChat)
        
        chatTableView?.reloadData()
        
        chatTableView?.scrollToRow(at: IndexPath(row: chattings.count-1, section: 0), at: .bottom, animated: true)
        
    }
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        
        
        self.addChatTextField()
        self.addTableView()
        
    }
    

    // MARK: - TableView Delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        /* 채팅 리스트에 새로운 채팅 추가 및 채팅 테이블 뷰 갱신 */
        
        /*
        guard let table = self.chatTableView else { return false }
        guard let message = textField.text else { return false }
        
        let count = chattings.count
        
        let newChat = Chat(nickname: myProfile.nickname, message: message)
        let index = IndexPath(row: count, section: 0)
        
        chattings.append(newChat)
        table.insertRows(at: [index], with: .bottom)
        table.scrollToRow(at: index, at: .bottom, animated: true)
        textField.text = nil
        
        self.reloadChattings(index)
        */
        
        guard let message = textField.text else { return false }
        
        SocketIOManager.shared.sendMessage(roomId: roomId, message: message, nickname: self.myNickname)
        textField.text = nil
        
        return true
        
    }
    
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("fatal Error")
    }
    
    init(roomId: String, nickName: String, chattings: [Chat]) {
        
        self.chattings = chattings
        self.myNickname = nickName
        self.roomId = roomId
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNewChatting(noti:)), name: Notification.Name("newChatNotification"), object: nil)
        
    }
    
    deinit {
        print("ChattingRoom deinit")
    }

}

