//
//  ViewController.swift
//  GameRoom
//
//  Created by 김윤수 on 2022/03/05.
//

import UIKit

class GameRoom: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
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
    var time = 5.0
    
    var myPlayerCell: PlayerCell?
    var currentOrder = 0
    
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
    
    
    // MARK: GameProcessing Method
    
    func readyGame(){
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            
            
            if self.time < 0 {
                timer.invalidate()
                self.setKeywordAndLiar()
                return
            }
            
            guard let label = self.announcementLabel else {return}
            
            label.text = "\(Int(self.time))초 후 게임이 시작됩니다."
            self.time -= 1
            
        }
        
        /* 타이머 실행 중 스크롤링 가능하게 */
        RunLoop.current.add(timer, forMode: .common)
        
        /*
         DispatchQueue.main.asyncAfter(deadline: .now()+5) {
         
         timer.invalidate()
         
         self.setKeywordAndLiar()
         
         }
         */
        
        timer.fire()
        
    }
    
    func startGame() {
        
        time = 10
        currentOrder = 0
        
        
        updateCurrentPlayer()
        
    }
    
    func readyToDebate() {
        
        guard let chatField = self.chatTextField else { return }
        guard let chatView = self.chatView else { return }
        guard let announce = self.announcementLabel else { return }
        
        
        chatField.isEnabled = false
        chatField.backgroundColor = .systemGray6
        
        announce.text = "시간 종료!!"
        blink(announce)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            sections.append("자유 토론")
            chatView.insertSections(IndexSet(integer: self.currentOrder), with: .fade)
            
            announce.text = "자유롭게 토론을 진행하세요"
            
            self.blink(announce)
            
            chatField.isEnabled = true
            chatField.backgroundColor = .white
            
            self.time = 30
            
            self.goDebate()
        }
    }
    
    func goDebate() {
        
        guard let reduce = self.timeReduceButton else { return }
        guard let extend = self.timeExtendButton else { return }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [unowned self] timer in
            
            if time < 0 {
                
                timer.invalidate()
                
                print("토론 종료!")
                
                extend.isEnabled = false
                reduce.isEnabled = false
                
                self.readyToVoting()
                
                return
                
            }
            
            else if time < 15 {
                
                reduce.isEnabled = false
                
            }
            
            guard let label = self.timeLabel else { return }
            
            label.text = "남은 시간: \(Int(time))"
            
            time -= 1
            
        }
        
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
        
        /* 시간 조절 버튼 활성화 */
        reduce.isEnabled = true
        extend.isEnabled = true
        
    }
    
    func readyToVoting() {
        
        guard let announce = self.announcementLabel else {return}
        guard let collection = self.playerCollection else { return }
        guard let chatField = self.chatTextField else {return}
        
        self.view.removeGestureRecognizer(self.gestureRecognizer)
        
        chatField.backgroundColor = .systemGray6
        chatField.isEnabled = false
        
        announce.text = "잠시 후 투표가 시작됩니다."
        blink(announce)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            announce.text = "투표 시작!"
            self.blink(announce)
            
            collection.allowsSelection = true
            self.startVoting()
        }
        
    }
    
    func startVoting() {
        
        
        
    }
    
    func showCurrentPlayer() {
        
        guard let announce = self.announcementLabel else {return}
        
        guard let chatField = self.chatTextField else {return}
        
        if isMyTurn() {
            
            chatField.isEnabled = true
            chatField.backgroundColor = .white
            
            announce.textColor = .black
            announce.text = "제시어에 대한 힌트를 입력하세요"
            
        } else {
            
            chatField.isEnabled = false
            chatField.backgroundColor = .systemGray6
            
            let nickname = players[process.playerOrder[currentOrder]].nickname
            let range = NSRange(location: 0, length: nickname.count)
            
            let attribute = NSMutableAttributedString(string: "\(nickname)님이 힌트를 입력중입니다.")
            
            attribute.addAttributes([.font : UIFont.systemFont(ofSize: 30, weight: .bold)], range: range)
            attribute.addAttributes([.underlineColor : UIColor.black], range: range)
            attribute.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue], range: range)
            
            announce.attributedText = attribute
            announce.textColor = .black
            
        }
        
        blink(announce)
        
    }
    
    func updateCurrentPlayer() {
        
        time = 2
        
        /* 플레이어 순서를 레이블에 띄워주기 */
        showCurrentPlayer()
        
        
        /* 시간 제한 타이머 생성 */
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            
            if self.time < 0 {
                timer.invalidate()
                print("시간 지났어!!")
                
                self.CheckHintInput()
                
                self.currentOrder += 1
                
                if self.currentOrder == players.count {
                    self.readyToDebate()
                }
                else {
                    self.updateCurrentPlayer()
                }
                
                return
            }
            
            guard let label = self.timeLabel else {return}
            
            label.text = "남은 시간: \(Int(self.time))"
            self.time -= 1
        }
        
        
        /* 타이머 실행 중 스크롤링이 가능하게 */
        RunLoop.current.add(timer, forMode: .common)
        
        
        timer.fire()
        
        /*
         /* 플레이어 할당 시간 제한 설정 */
         DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
         
         timer.invalidate()
         
         self.currentOrder += 1
         
         if self.currentOrder == players.count {
         self.endGame()
         } else {
         self.updateCurrentPlayer()
         }
         }
         
         */
    }
    
    func setKeywordAndLiar() {
        
        guard let announce = self.announcementLabel else {return}
        guard let keyword = self.keywordLabel else {return}
        
        
        announce.text = "게임 시작!"
        
        blink(announce)
        
        if myProfile.userID == process.liarID {
            keyword.text = "당신은 라이어입니다."
            keyword.textColor = .red
        } else {
            keyword.text = "제시어: \(process.keyword)"
        }
        
        blink(keyword)
        
        /* 3초 후 게임 시작 */
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.startGame()
        }
        
    }
    
    func isMyTurn() -> Bool{
        
        if self.currentOrder == players.count {
            return false
        }
        
        let order = process.playerOrder[currentOrder]
        let currentPlayerID = players[order].userID
        
        if myProfile.userID == currentPlayerID {
            return true
        }
        else {
            return false
        }
        
    }
    
    func CheckHintInput() {
        
        guard let chatView = self.chatView else { return }
        
        if sections.count < currentOrder + 1 {
            
            sections.append("아무것도 입력되지 않았습니다.")
            
            chatView.insertSections(IndexSet(integer: currentOrder), with: .fade)
            
            chatView.scrollToRow(at: IndexPath(row: 0, section: currentOrder), at: .bottom, animated: true)
            
        } else {
            
            /* 모든 플레이어들에게 입력된 힌트 제시 */
            
        }
        
        
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
    
    // MARK: - Action
    
    @objc func touchTimeExtendButton(_ sender: UIButton) {
        
        guard let label = self.timeLabel else {return}
        
        time += 10
        label.text = "남은 시간: \(Int(time))"
        
        sender.isEnabled = false
        
        
    }
    
    @objc func touchTimeReduceButton(_ sender: UIButton) {
        
        guard let label = self.timeLabel else {return}
        
        time -= 10
        label.text = "남은 시간: \(Int(time))"
        
        sender.isEnabled = false
        
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
        
        /* 자유 채팅 순서일때만 이동*/
        if currentOrder == players.count && chattings.count > 0 {
            
            table.scrollToRow(at: IndexPath(row: chattings.count-1, section: currentOrder), at: .bottom, animated: true)
            
        }
    }
    
    
    // MARK: - CollectionView Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playerCellIdentifier, for: indexPath) as! PlayerCell
        
        let order = process.playerOrder[indexPath.row]
        
        let player = players[order]
        
        cell.playerImage?.image = player.image
        cell.nicknameLabel?.text = player.nickname
        //        cell.isSelected = true
        
        if myProfile.userID == player.userID {
            self.myPlayerCell = cell
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == players.count {
            return chattings.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section < players.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: hintCellIdentifier, for: indexPath) as!  HintCell
            
            let hint = sections[indexPath.section]
            
            cell.chatting?.text = hint
            
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: chatCellIdentifier, for: indexPath) as! ChatCell
            
            cell.nickname?.text = chattings[indexPath.row].nickname
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
            title.text = section < players.count ? " \(players[process.playerOrder[section]].nickname)" : "자유채팅"
            
            title.translatesAutoresizingMaskIntoConstraints = false
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            title.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            return view
        }()
        
        return view
        
    }
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let chatView = self.chatView else { return false }
        
        guard let text = textField.text else { return false }
        
        if isMyTurn() {
            
            if sections.count < currentOrder + 1 {
                
                sections.append(text)
                
                chatView.insertSections(IndexSet(integer: currentOrder), with: .fade)
                
                chatView.scrollToRow(at: IndexPath(row: 0, section: currentOrder), at: .bottom, animated: true)
                
            }
            else {
                
                let cell = chatView.cellForRow(at: IndexPath(row: 0, section: currentOrder)) as! HintCell
                
                cell.chatting?.text = text
                
                sections[currentOrder] = text
                
                UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .curveEaseInOut, .allowUserInteraction]) {
                    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                } completion: { _ in
                    cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
            
        }
        
        else {
            
            let newChat = Chat(nickname: myProfile.nickname, message: text)
            
            let index = IndexPath(row: chattings.count, section: currentOrder)
            
            chattings.append(newChat)
            
            chatView.insertRows(at: [index], with: .bottom)
            
            chatView.scrollToRow(at: IndexPath(row: index.row, section: currentOrder), at: .bottom, animated: true)
            
            
        }
        
        textField.text = nil
        
        return true
        
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        
        self.gestureRecognizer.addTarget(self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(self.gestureRecognizer)
        
        self.addAnnouncemnetLabel()
        self.addChatView()
        self.addChatTextField()
        self.addPlayerCollection()
        self.addTimerView()
        
        readyGame()
        
    }
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        /* 스토리보드를 사용할 때만 코드 입력*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    
}

