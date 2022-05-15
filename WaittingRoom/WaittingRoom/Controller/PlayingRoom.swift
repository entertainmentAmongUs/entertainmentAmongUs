//
//  PlayingRoom.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/15.
//

import UIKit

class PlayingRoom: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var chatView: UITableView?
    var announcementLabel: UILabel?
    var keywordLabel: UILabel?
    var bottomProfileView: UIStackView?
    var playerCollection: UICollectionView?
    var chatTextField: UITextField?
    var timeLabel: UILabel?
    
    var timeButtonStack: UIStackView?
    var timeReduceButton: UIButton?
    var timeExtendButton: UIButton?
    
    let chatCellIdentifier = "chatCell"
    let hintCellIdentifier = "hintCell"
    let playerCellIdentifier = "playerCell"
    var timeStackBottomConstraint: NSLayoutConstraint?
    
    var myNickName: String
    var myUserId: Int
    
    var playingInfo: PlayingInfo
    var userList: [UserInRoom]
    var chattings: [Chat] = []
    lazy var gestureRecognizer = UITapGestureRecognizer()
    
    
    // MARK: - Method
    
    // MARK: Create View Method
    
    func addAnnouncemnetLabel() {
        
        let label = UILabel()
        
        self.view.addSubview(label)
        
        label.font = .systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        
        /*
         label.backgroundColor = .white
         label.layer.cornerRadius = 15
         label.clipsToBounds = true
         */
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.announcementLabel = label

        
        let keyword = UILabel()
        
        self.view.addSubview(keyword)
        
        keyword.font = .systemFont(ofSize: 20, weight: .semibold)
        keyword.textAlignment = .center
        
        
        keyword.translatesAutoresizingMaskIntoConstraints = false
        keyword.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        keyword.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        keyword.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.keywordLabel = keyword
        
    }
    
    func addChatView() {
        
        guard let label = self.keywordLabel else {return}
        
        let table = UITableView(frame: .zero, style: .insetGrouped)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(ChatCell.self, forCellReuseIdentifier: chatCellIdentifier)
        table.register(HintCell.self, forCellReuseIdentifier: hintCellIdentifier)
        table.sectionHeaderTopPadding = 10
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        table.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        table.setContentHuggingPriority(.defaultLow, for: .vertical)
        table.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        self.chatView = table
        
        
    }
    
    
    func addChatTextField() {
        
        guard let table = self.chatView else {return}
        
        let textField = UITextField()
        
        self.view.addSubview(textField)
        
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "매너채팅 합시다"
        textField.enablesReturnKeyAutomatically = true
        textField.isEnabled = false
        textField.backgroundColor = .systemGray6
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        /*
         /* 채팅입력 창 하단 오토 레이아웃 저장 */
         let bottom = textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
         bottom.isActive = true
         
         self.textFieldBottomConstraint = bottom
         */
        
        
        
        
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        textField.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 10).isActive = true
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.chatTextField = textField
    }
    
    
    func addPlayerCollection() {
        
        
        //        let cellWidthAndHeight = (self.view.safeAreaLayoutGuide.layoutFrame.width-100)/4
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 15
        flow.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flow.itemSize = CGSize(width: 70, height: 90)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        
        self.view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(PlayerCell.self, forCellWithReuseIdentifier: playerCellIdentifier)
        collection.backgroundColor = .systemGray6
        collection.allowsSelection = false
        
        
        
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        collection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        collection.heightAnchor.constraint(equalToConstant: 90).isActive = true
        collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collection.setContentHuggingPriority(.defaultHigh, for: .vertical)
        collection.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.playerCollection = collection
        
        
    }
    
    func addTimerView() {
        
        guard let textfield = self.chatTextField else {return}
        
        let minus = UIButton(type: .system)
        let plus = UIButton(type: .system)
        
        minus.setTitle("시간 단축", for: .normal)
        minus.addTarget(self, action: #selector(touchTimeReduceButton(_:)), for: .touchUpInside)
        minus.isEnabled = false
        
        plus.setTitle("시간 연장", for: .normal)
        plus.addTarget(self, action: #selector(touchTimeExtendButton(_:)), for: .touchUpInside)
        plus.isEnabled = false
        
        self.timeReduceButton = minus
        self.timeExtendButton = plus
        
        let timer = UILabel()
        timer.text = "남은 시간"
        timer.textAlignment = .center
        timer.font = .systemFont(ofSize: 20, weight: .medium)
        
        self.timeLabel = timer
        
        
        let stack = UIStackView(arrangedSubviews: [minus, timer, plus])
        
        self.view.addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        stack.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 5).isActive = true
        
        let bottom = stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        
        bottom.isActive = true
        
        self.timeStackBottomConstraint = bottom
        
        
        //        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.timeButtonStack = stack
        
    }
    
    // MARK: Action Method
    
    @objc func getNewChatting(noti:Notification) {
        
        /*
        let newChat = noti.object as! Chat
        
        if newChat.roomId != roomId { return }
        
        chattings.append(newChat)
        
        chatTableView?.reloadData()
        
        chatTableView?.scrollToRow(at: IndexPath(row: chattings.count-1, section: 0), at: .bottom, animated: true)
        
        */
        
        
    }
    
    @objc func touchTimeExtendButton(_ sender: UIButton) {
        
        /*
        guard let label = self.timeLabel else {return}
        
        time += 10
        label.text = "남은 시간: \(Int(time))"
        
        sender.isEnabled = false
        */
        
    }
    
    @objc func touchTimeReduceButton(_ sender: UIButton) {
        
        /*
        guard let label = self.timeLabel else {return}
        
        time -= 10
        label.text = "남은 시간: \(Int(time))"
        
        sender.isEnabled = false
        */
    }
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ noti: Notification) {
        
        /* 키보드 높이에 맞춰 채팅 입력 필드의 오토 레이아웃 갱신 */
        
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.timeStackBottomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -(keyboardSize.height - self.view.safeAreaInsets.bottom)
        }
        
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        
        guard let duration = noti.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        guard let bottom = self.timeStackBottomConstraint else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -100
        }
    }
    
    @objc func keyboardDidShow(_ noti: Notification) {
        
        /* 키보드 등장 후 테이블 뷰 스크롤을 맨 밑으로 이동 */
        
        guard let table = self.chatView else { return }
        
        
        /*
        /* 자유 채팅 순서일때만 이동*/
        if currentOrder == players.count && chattings.count > 0 {
            
            table.scrollToRow(at: IndexPath(row: chattings.count-1, section: currentOrder), at: .bottom, animated: true)
            
        }
         */
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = .systemGray6
    
        self.gestureRecognizer.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(self.gestureRecognizer)
        
        self.addAnnouncemnetLabel()
        self.addChatView()
        self.addChatTextField()
        self.addPlayerCollection()
        self.addTimerView()
        
        
    }
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(userId: Int, nickName: String, playingInfo: PlayingInfo, userList: [UserInRoom]){
        self.myUserId = userId
        self.myNickName = nickName
        self.playingInfo = playingInfo
        self.userList = userList
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNewChatting(noti:)), name: Notification.Name("newChatNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }

}

extension PlayingRoom: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userList.count+1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = section < userList.count ? 1 : chattings.count
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section < userList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: hintCellIdentifier, for: indexPath) as!  HintCell
            
//            let hint = sections[indexPath.section]
            
            cell.chatting?.text = "예시입니다"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: chatCellIdentifier, for: indexPath) as! ChatCell
            
            cell.nickname?.text = chattings[indexPath.row].nickName
            cell.chatting?.text = chattings[indexPath.row].message
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view: UIView = {
            
            let view = UIView()
            
            let title = UILabel()
            
            view.addSubview(title)
            
            title.font = .systemFont(ofSize: 18, weight: .medium)
            title.text = section < userList.count ? " \(userList[playingInfo.order[section]].nickName)" : "자유채팅"
            
            title.translatesAutoresizingMaskIntoConstraints = false
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            title.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            return view
        }()
        
        return view
        
    }
    
}

extension PlayingRoom: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playerCellIdentifier, for: indexPath) as! PlayerCell
        
        let player = userList[playingInfo.order[indexPath.row]]
        
//        cell.playerImage?.image =
        cell.nicknameLabel?.text = player.nickName
        //        cell.isSelected = true
        
        /*
        if myProfile.userID == player.userID {
            self.myPlayerCell = cell
        }
        */
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let label = self.keywordLabel else {return}
        
        let player = userList[playingInfo.order[indexPath.row]]
        
        label.text = "\(player.nickName)님에게 투표하시겠습니까?"
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .allowUserInteraction]) {
            label.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        /*
        if myPlayerCell == collectionView.cellForItem(at: indexPath) {
            return false
        }
        */
        
        return true
    }
    
}
