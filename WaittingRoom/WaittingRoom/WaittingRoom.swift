//
//  ViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/14.
//

import UIKit

class WaittingRoom: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    // MARK: - Properties
    
    // View
    var exitButton: UIButton?
    var readyButton: UIButton?
    var waitUserCollection: UICollectionView?
    var waitUserView: UIView?
    var chatTextfield: UITextField?
    var chatTableView: UITableView?
    
    // Other
    var waitUserViewHeightConstraint: NSLayoutConstraint?
    let profileIdentifier = "profile"
    let chatIdentifier = "chat"
    
    // Model
    var myProfileCell: ProfileCell?
    var profiles: [Profile] = dummy
    
    
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
        
        self.view.addSubview(ready)
        
        ready.addTarget(self, action: #selector(self.touchReadyButton(_:)), for: .touchUpInside)
        ready.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        ready.setTitle("준비", for: .normal)
        ready.setTitle("준비 완료!", for: .selected)
        
        ready.translatesAutoresizingMaskIntoConstraints = false
        ready.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        ready.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        
        self.readyButton = ready
        
        
        // exitButton Setting
        
        let exit = UIButton(type: .system)
        
        self.view.addSubview(exit)
        
        exit.addTarget(self, action: #selector(self.touchExitButton(_:)), for: .touchUpInside)
        exit.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        exit.setTitle("나가기", for: .normal)
        
        exit.translatesAutoresizingMaskIntoConstraints = false
        exit.centerYAnchor.constraint(equalTo: ready.centerYAnchor).isActive = true
        exit.centerXAnchor.constraint(equalTo: ready.centerXAnchor, constant: -110).isActive = true
        
        self.exitButton = exit
        
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
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.waitUserCollection = collection
        
    }
    
    
    func addChatView() {
        
        guard let ready = self.readyButton else { return }

        
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
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.chatTextfield = textField
        
        
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
        
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: ready.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        table.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5 ).isActive = true
        
        self.chatTableView = table
        
        
    }
    
    /* MARK: Function Method */
    
    func setUserProfileView(info profile: Profile) -> ProfileViewController {
        
        let view = ProfileViewController()
        
        view.profileImage.image = profile.image
        view.nicknameLabel.text = "닉네임: \(profile.nickname)"
        view.victoryRateLabel.text = "승률: " + String(format: "%.2f", profile.victoryRate) + "%"
        view.winCountLabel.text = "이긴 횟수: \(profile.winCount)회"
        view.loseCountLabel.text = "진 횟수: \(profile.loseCount)회"
        view.scoreLabel.text = "점수: \(profile.score)"
        
        return view
        
    }
    
    func updateWaitUserViewConstraint() {
        
        guard let constraint = self.waitUserViewHeightConstraint else {return}
        
        let height = 2*(self.view.safeAreaLayoutGuide.layoutFrame.height)/3
        
        constraint.constant = height
        
    }
    
    
    // MARK: - Action Method
    
    @objc func touchReadyButton(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        self.myProfileCell?.isReady.toggle()
//        self.myProfileCell?.blink()
        
    }
    
    @objc func touchExitButton(_ sender: UIButton) {
        
        guard let collection = self.waitUserCollection else { return }
        
        /*
        guard let cell = self.myProfileCell else { return }
        guard let index = collection.indexPath(for: cell) else { return }
        */
        
        let new = Profile(id: nil, image: nil, nickname: "", score: 0, winCount: 0, loseCount: 0)
        
        self.profiles.insert(new, at: 8)
        collection.insertItems(at: [IndexPath(row: 8, section: 0)])
        
        self.profiles.remove(at: 0)
        collection.deleteItems(at: [IndexPath(row: 0, section: 0)])
        
    }
    
    
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.profileIdentifier, for: indexPath) as! ProfileCell
        
        // 나의 프로필 셀 지정
        if indexPath.row == 2 {
            self.myProfileCell = cell
        }
        
        let info = self.profiles[indexPath.row]
        cell.nickname?.text = info.nickname
        cell.image?.image = info.image
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {return CGSize()}
        
        let size = CGSize(width: (collectionView.bounds.width - layout.minimumInteritemSpacing)/2, height: (collectionView.bounds.height - 3*layout.minimumLineSpacing)/4)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let info = self.profiles[indexPath.row]
        
        if info.id == nil {
            return false
        }
        
        let view = setUserProfileView(info: info)
        
        self.present(view, animated: true, completion: nil)
        
        return false
        
    }
        
    
    // MARK: - TableView Delegate
    
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
        
        self.addWaittingUserView()
        self.addButtons()
        self.addWaitUserCollectionView()
        self.addChatView()
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.updateWaitUserViewConstraint()
        
    }

}

