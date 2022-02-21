//
//  ChattingRoom.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/20.
//

import UIKit

class ChattingRoom: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    // MARK: - Properties
    
    /* MARK: Views */
    var chatTableView: UITableView?
    var chatTextField: UITextField?
    var returnButton: UIButton?
    
    /* MARK: Others */
    let chatIdentifier = "chat"
    var textFieldButtomConstraint: NSLayoutConstraint?
    
    
    // MARK: - Method
    
    func addTableView() {
        
        guard let textField = self.chatTextField else {return}
        
        let table = UITableView(frame: .zero, style: .insetGrouped)
        
        self.view.addSubview(table)
        
        table.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        table.delegate = self
        table.dataSource = self
    
//        table.layer.cornerRadius = 3
//        table.clipsToBounds = true
//        table.backgroundColor = .systemGray5
        
        table.separatorStyle = .singleLine
        table.allowsSelection = false
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10).isActive = true
        
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
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.placeholder = "욕설이나 비방 채팅은 삼가주세요"
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let bottom = textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
        bottom.isActive = true
        self.textFieldButtomConstraint = bottom
        
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.chatTextField = textField
        
    }
    
    
    /*
    func addReturnButton() {
        
        let button = UIButton(type: .system)
        
        self.returnButton = button
    }
    */
    
    
    func reloadChattings(_ index: IndexPath) {
        
        guard let waittingRoom = self.presentingViewController as? WaittingRoom else {return}
        
        waittingRoom.chatTableView?.reloadData()
        waittingRoom.chatTableView?.scrollToRow(at: index, at: .bottom, animated: false)
        
    }
    
    // MARK: - Action
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow (_ noti: Notification) {
        
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.textFieldButtomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -(10 + keyboardSize.height - self.view.safeAreaInsets.bottom)
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    @objc func keyboardWillHide (_ noti: Notification) {
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.textFieldButtomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -20
            self.view.layoutIfNeeded()
        }
        
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
        
        let info = chattings[indexPath.row]
        cell.nickname?.text = info.nickname
        cell.chatting?.text = info.message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let table = self.chatTableView else { return false }
        
        guard let message = textField.text else { return false }
        
        let count = chattings.count
        
        let newChat = Chat(nickname: "초보입니다", message: message)
        let index = IndexPath(row: count, section: 0)
        
        chattings.append(newChat)
        table.insertRows(at: [index], with: .bottom)
        table.scrollToRow(at: index, at: .bottom, animated: true)
        textField.text = nil
        
        self.reloadChattings(index)
        
        return true
        
    }
    
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

}
