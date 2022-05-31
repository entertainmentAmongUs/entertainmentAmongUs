//
//  PlayingRoom.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/15.
//

import UIKit
import Alamofire

class PlayingRoom: UIViewController {
    
    // MARK: - Properties
    
    // MARK: About View
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
    var bottomHeight: CGFloat?
    
    lazy var gestureRecognizer = UITapGestureRecognizer()
    
    // MARK: About Game
    
    var myNickName: String
    var myUserId: Int
    var roomId: String
    var liarNickName: String?
    var isLiar: Bool
    
    var playingInfo: PlayingInfo
    var userList: [UserInRoom]
    var chattings: [Chat] = []
    var hint: [String] = []
    var time: Int {
        willSet {
            timeLabel?.text = "남은 시간: \(newValue)초"
        }
    }
    var currentOrder = -1
    var currentStatus = PlayStatus(rawValue: "READY")
//    var hintCount = 0
    var throwVoting = false
    var gameStartTimer: Timer?
    
    
    // MARK: - Method
    
    // MARK: Create View Method
    
    func addAnnouncemnetLabel() {
        
        let label = UILabel()
        
        self.view.addSubview(label)
        
        label.font = .systemFont(ofSize: 30, weight: .bold)
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
        
        keyword.font = .systemFont(ofSize: 18, weight: .regular)
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
        
        
        let cellHeight = (self.view.safeAreaLayoutGuide.layoutFrame.height/9).rounded()
        
        self.bottomHeight = cellHeight
        
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 15
        flow.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flow.itemSize = CGSize(width: cellHeight-20, height: cellHeight)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        
        self.view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(PlayerCell.self, forCellWithReuseIdentifier: playerCellIdentifier)
        collection.backgroundColor = .systemGray6
        collection.allowsSelection = true
        
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        collection.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        collection.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        collection.setContentHuggingPriority(.defaultHigh, for: .vertical)
        collection.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.playerCollection = collection
        
        
    }
    
    func addTimerView() {
        
        guard let textfield = self.chatTextField else {return}
        guard let height = self.bottomHeight else {return}
        
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
        timer.adjustsFontSizeToFitWidth = true
        
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
        
        let bottom = stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(height + 10.0))
        
        bottom.isActive = true
        
        self.timeStackBottomConstraint = bottom
        
        
        //        stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
        stack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        self.timeButtonStack = stack
        
    }
    
    func addSubViews() {
        
        self.addAnnouncemnetLabel()
        self.addChatView()
        self.addChatTextField()
        self.addPlayerCollection()
        self.addTimerView()
        
    }
    
    
    // MARK: Function Method
    
    func isEnableTextField (_ status: PlayStatus, _ order: Int) -> Bool {
        
        if status == .freeChat || (status == .hint && userList[order].userId == myUserId) {
            return true
        } else {
            return false
        }
        
    }
    
    func changeTextFieldState(_ turn: Bool) {
        
        guard let textField = chatTextField else { return }
        
        if turn {
            
            textField.isEnabled = true
            
            textField.backgroundColor = .white
            
        } else {
            
            textField.isEnabled = false
            
            textField.backgroundColor = .systemGray6
            
            self.view.endEditing(true)
            
        }

        
    }
    
    func checkChatStatus(text: String) {
        
        guard let status = currentStatus else { return }
        
        // 내가 힌트를 제시할 차례라면
        if status == .hint && userList[currentOrder].userId == myUserId {
            
            let count = hint.count
            
            hint[count-1] = text
            
            chatView?.reloadData()
            
            if let cell = chatView?.cellForRow(at: IndexPath(row: 0, section: count-1)) as? HintCell {
                UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .allowUserInteraction]) {
                    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                } completion: { _ in
                    cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
            
        }
        // 자유 토론 시간이라면
        else if status == .freeChat {
            
            SocketIOManager.shared.sendGameMessage(status: status.rawValue, roomId: roomId, message: text, nickname: myNickName)
            
        }
        
        
    }
    
    func sendHint() {
        
        guard let status = currentStatus else { return }
        
        
        if currentOrder >= 0 && userList[currentOrder].userId == myUserId {
            
            let count = hint.count
            
            SocketIOManager.shared.sendGameMessage(status: status.rawValue, roomId: roomId, message: hint[count-2], nickname: myNickName)
            
        }
        
        
    }
    
    func showLiar() {
        
        guard let announce = self.announcementLabel else { return }
        guard let keyword = keywordLabel else { return }
        
        if isLiar {
            
            announce.text = "당신은 라이어입니다!"
            keyword.text = "다른 유저들의 힌트를 보고 키워드를 알아내세요."
            
        } else {
            
            announce.text = "당신은 라이어가 아닙니다."
            keyword.text = "키워드: \(playingInfo.keyword)"
            
        }
        
        blink(announce)
        blink(keyword)

        
    }
    
    func changeVotingState(_ status: PlayStatus){
        
        guard let playerCollection = playerCollection else { return }

        
        if status == .vote {
            
            playerCollection.allowsSelection = true
            
        } else {
            
            playerCollection.allowsSelection = false
            
        }
        
    }
    
    func changeStatus(_ status: PlayStatus, _ order: Int) {
        
        guard let announce = self.announcementLabel else { return }
        
        if status != currentStatus {
            
            switch status {
                
            case .hint:
                break
            case .freeChat:
                
                hint.append("자유채팅 더미")
                chatView?.insertSections(IndexSet(integer: hint.count-1), with: .automatic)
//                hintCount += 1
                sendHint()
                
                announce.text = "남은 시간동안 자유롭게 토론하세요"
                blink(announce)
                
            case .vote:
                self.view.removeGestureRecognizer(gestureRecognizer)
                announce.text = "하단의 플레이어를 터치해서 라이어를 지명하세요"
                blink(announce)
            default:
                break
                
            }
            
            currentStatus = status
            
            changeTextFieldState(isEnableTextField(status, order))

        }
        
        // 힌트 제시 순서에 플레이어 차례가 바뀔경우
        if currentStatus == .hint && currentOrder != order {
            
            announce.text = "\(userList[order].nickName)님이 힌트를 입력중입니다."
            blink(announce)
            
            hint.append("힌트를 입력 중...")
            chatView?.insertSections(IndexSet(integer: hint.count-1), with: .automatic)
        
//            hintCount += 1
            
            changeTextFieldState(isEnableTextField(status, order))
            
            // 내 순서가 끝날때 힌트 전송
            sendHint()
            
            currentOrder = order
            
        }
        
        
    }
    
    func checkVoting() {
        
        if throwVoting == false && currentStatus == .vote && time <= 0 {
            
            SocketIOManager.shared.vote(roomId: roomId, targetId: myUserId)
            throwVoting = true
            
        }
        
    }
    
    
    func announcement() {
        
        showLiar()
        
        let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(10), repeats: false) { [weak self] timer in
            
            guard let roomId = self?.roomId else { return }
            
            let tickTokHandler: (_ tickTok: TickTok) -> Void = { tickTok in
                
                self?.time = tickTok.time
                
                self?.changeStatus(tickTok.status, tickTok.order)
                
                self?.checkVoting()
                
            }
            
            SocketIOManager.shared.endAnnouncemnet(roomId: roomId, completionHandler: tickTokHandler)
            
            SocketIOManager.shared.reVoting(completionHandler: tickTokHandler)
            
            SocketIOManager.shared.confirmVoting {  result in
                
                if result.status == .reVote {
                    
                    self?.throwVoting = false
                    
                } else {
                    
                    var maxVote = -1
                    var targetId = 0
                    
                    for player in result.result {
                        
                        if player.count > maxVote {
                            
                            maxVote = player.count
                            targetId = player.userId
                            
                            
                        }
                        
                    }
                    
                    let isLiarDefeat = Bool(targetId == self?.playingInfo.liarNumber)
                    guard let isLiar = self?.isLiar else { return }
                    let isVictory = (isLiar && !isLiarDefeat) || (!isLiar && isLiarDefeat) ? true : false
                    let message = isVictory ? "당신이 승리했습니다!" : "당신은 패배했습니다!"
                    
                    let alertController = UIAlertController(title: message, message: "라이어는 \(self?.liarNickName ?? "")님 이었습니다.", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "확인", style: .default))
                    
                    self?.present(alertController, animated: true)
                    
                    let outcome = Outcome(isVictory: isVictory, userId: self?.myUserId ?? -1)
                    
                    AF.request("\(baseURL)/profile/outcome", method: .post, parameters: outcome, encoder: .json(), headers: nil, interceptor: nil, requestModifier: nil).validate()
                    
                }
                
            }
            
            guard let label = self?.announcementLabel else {return}
            label.text = "다른 플레이어를 기다리는 중..."

        }
        
        gameStartTimer = timer
        
        RunLoop.main.add(timer, forMode: .common)
        
        
    }
    
    func getGameChatting() {
        
        SocketIOManager.shared.fetchGameChatting { [weak self] gameChat in
            
            switch gameChat.status {
                
            case .hint:
                
                guard let hintCount = self?.hint.count else { return }
                
                self?.hint[hintCount-2] = gameChat.message
                
                self?.chatView?.reloadData()
                
                self?.chatView?.scrollToRow(at: IndexPath(row: 0, section: hintCount-2), at: .top, animated: true)
                
                if let cell = self?.chatView?.cellForRow(at: IndexPath(row: 0, section: hintCount-2)) {
                
                    self?.blink(cell)
                
                }
            case .freeChat:
                
                self?.chattings.append(Chat(roomId: gameChat.roomId, nickName: gameChat.nickName, message: gameChat.message))
                
                guard let count = self?.chattings.count else { return }
                
                guard let hintCount = self?.hint.count else { return }
                
                let index = IndexPath(row: count-1, section: hintCount-1)
                
                self?.chatView?.insertRows(at: [index], with: .bottom)
                
                self?.chatView?.scrollToRow(at: index, at: .bottom, animated: true)

                //                self?.chatView?.reloadData()
                
            default:
                return
                
            }
            
        }
        
    }
    
    func endGame() {
        
        SocketIOManager.shared.endGame(announce: announcementLabel) { [weak self] in
            
            self?.gameStartTimer?.invalidate()
            self?.navigationController?.isNavigationBarHidden = false
            self?.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func prepareGame() {
        
        for user in userList {
            
            if user.userId == playingInfo.liarNumber {
                
                liarNickName = user.nickName
            }
            
        }
        
        announcement()
        getGameChatting()
        endGame()
        
    }
    
    func blink(_ view: UIView) {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut, .allowUserInteraction]) {
            view.alpha = 0.0
        } completion: { _ in
            view.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            view.layer.removeAllAnimations()
        }
        
    }
    
    func damping(_ view: UIView) {
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: [.curveEaseInOut]) {
            view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { _ in
            view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
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
        guard let height = self.bottomHeight else {return}
        
        UIView.animate(withDuration: duration) {
            bottom.constant = -(height + 10.0)
        }
    }
    
    @objc func keyboardDidShow(_ noti: Notification) {
        
        
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemGray6
    
        gestureRecognizer.addTarget(self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(self.gestureRecognizer)
        
        addSubViews()
        prepareGame()

    }
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(userId: Int, nickName: String, playingInfo: PlayingInfo, userList: [UserInRoom], roomId: String){
        self.myUserId = userId
        self.myNickName = nickName
        self.playingInfo = playingInfo
        self.userList = userList
        self.roomId = roomId
        self.time = -1
        self.isLiar = Bool(myUserId == playingInfo.liarNumber)
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }

}

// MARK: - UITableView DataSource

extension PlayingRoom: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return hint.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = section < userList.count ? 1 : chattings.count
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section < userList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: hintCellIdentifier, for: indexPath) as!  HintCell
            
//            let hint = hint[indexPath.section]
            
            cell.chatting?.text = hint[indexPath.section]
            
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

// MARK: - UICollectionView DataSource

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
        
        let player = userList[playingInfo.order[indexPath.row]]
        
        let alert = UIAlertController(title: "라이어 지명", message: "\(player.nickName)님에게 투표하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "투표", style: .default, handler: { [weak self] alert in
            
            SocketIOManager.shared.vote(roomId: self?.roomId, targetId: player.userId)
            
            self?.throwVoting = true
            
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { alert in
            collectionView.deselectItem(at: indexPath, animated: true)
        }))
        
        self.present(alert, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if currentStatus != .vote || throwVoting == true { return false }
        
        return true
    }
    
}

extension PlayingRoom: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return false }
        
       checkChatStatus(text: text)
        
        textField.text = nil
        
        return true
        
    }
    
}
