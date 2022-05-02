//
//  ViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/14.
//

import UIKit

class WaittingRoom: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
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
    
    
    // MARK: - Method
    
    
    /* MARK: Create View Method */
    func addWaittingUserView() {
        
        let view = UIView()
        
        self.view.addSubview(view)
        
        view.backgroundColor = .systemGray3
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        let height = view.heightAnchor.constraint(equalToConstant: 2*self.view.safeAreaLayoutGuide.layoutFrame.size.height/3)
        height.isActive = true
        
        self.waitUserViewHeightConstraint = height
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
        setting.isEnabled = Bool(myProfile.userID == Myroom.masterUserID)
        
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
        
        self.view.addSubview(textField)
        
        textField.placeholder = "채팅을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  -20).isActive = true
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
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
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
        
        guard let collection = self.waitUserCollection else { return }
        
        let new = Profile(userID: nil, image: nil, nickname: "", score: 0, winCount: 0, loseCount: 0)
        
        Myroom.users.insert(new, at: 8)
        collection.insertItems(at: [IndexPath(row: 8, section: 0)])
        
        Myroom.users.remove(at: index)
        collection.deleteItems(at: [IndexPath(row: index, section: 0)])
        
    }

    
    
    // MARK: - Action Method
    
    @objc func touchReadyButton(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        self.myProfileCell?.isReady.toggle()
        
    }
    
    @objc func touchExitButton(_ sender: UIButton) {
        
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
        
    }
    
    
    @objc func touchSettingButton(_ sender: UIButton){
        
        guard let constraint = waitUserViewHeightConstraint else {
            return
        }


        
        let view = RoomSetting(constraint.constant)
        
        self.present(view, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - CollectionView DataSoruce
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Myroom.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.profileIdentifier, for: indexPath) as! ProfileCell
        
        cell.isReady = false
        cell.isRoomMaster = false
        
        let info = Myroom.users[indexPath.row]
        
        /* 내 프로필이 담긴 셀 저장 */
        if info.userID == myProfile.userID {
            self.myProfileCell = cell
        }
        
        /* 방장 셀의 속성 변경 */
        if info.userID == Myroom.masterUserID {
            cell.isRoomMaster = true
        }
        
        cell.nickname?.text = info.nickname
        cell.image?.image = info.image
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize()}
        
        /* 2x4 크기의 셀 사이즈 설정 */
        let size = CGSize(width: (collectionView.bounds.width - layout.minimumInteritemSpacing)/2, height: (collectionView.bounds.height - 3*layout.minimumLineSpacing)/4)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let info = Myroom.users[indexPath.row]
        
        
        if info.userID == nil {
            return false
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileCell else { return false }
        
        let view = ProfileViewController(info, cell)
        
        self.present(view, animated: true, completion: nil)
        
        return false
        
    }
    
    
    // MARK: - TableView DataSource
    
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let chatRoom = ChattingRoom()
        
        self.present(chatRoom, animated: true, completion: nil)
        return false
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.addWaittingUserView()
        self.addButtons()
        self.addWaitUserCollectionView()
        self.addChatView()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.updateWaitUserViewConstraint()
        
    }
    
}

