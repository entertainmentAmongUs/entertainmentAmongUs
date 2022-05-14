//
//  ProfileViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/17.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties(Views)
    
    var contentView: UIView?
    lazy var profileImage = UIImageView()
    
    /* MARK: Labels */
    lazy var labelStackView = UIStackView(arrangedSubviews: [nicknameLabel, scoreLabel, victoryRateLabel, winCountLabel, loseCountLabel])
    lazy var nicknameLabel = UILabel()
    lazy var victoryRateLabel = UILabel()
    lazy var winCountLabel = UILabel()
    lazy var loseCountLabel = UILabel()
    lazy var scoreLabel = UILabel()
    
    /* MARK: Buttons */
    var buttonStackView: UIStackView?
    var kickButton: UIButton?
    var backButton: UIButton?
    var friendButton: UIButton?
    
    var roomId: String
    var userId: Int
    var myUserId: Int
    var hostId: Int
    
    
    
    // MARK: - Method
    
    /* MARK: Create View Method */
    
    func addContentView() {
        
        let content = UIView()
        
        self.view.addSubview(content)
        
        content.backgroundColor = .white
        content.layer.cornerRadius = 30
        content.clipsToBounds = true
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.heightAnchor.constraint(equalToConstant: 300).isActive = true
        content.widthAnchor.constraint(equalToConstant: 300).isActive = true
        content.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.contentView = content
        
    }
    
    func addInfoLabel() {
        
        guard let content = self.contentView else { return }
        
        
        /* 프로필 사진 이미지 뷰 설정*/
        
        let image = self.profileImage
        
        content.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        
        /* 유저 정보 모아놓은 스택 뷰 설정*/
        
        let stack = self.labelStackView
        
        content.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 3
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15).isActive = true
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        stack.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
    }
    
    func addButtons(){
        
        guard let content = self.contentView else {return}
        
        // backButton Setting
        
        let back = UIButton(type: .system)
        back.backgroundColor = .white
        back.setTitle("뒤로", for: .normal)
        back.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        back.addTarget(self, action: #selector(self.touchCancleButton(_:)), for: .touchUpInside)
        
        self.backButton = back
        
        
        // requsetFriendButton Setting
        
        let friend = UIButton(type: .system)
        friend.backgroundColor = .white
        friend.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        friend.setTitle("친구 요청", for: .normal)
        friend.isEnabled = userId == myUserId ? false : true
        
        self.checkFriendRequestButton(friend)
        self.friendButton = friend
        
        
        // forcedToLeaveButton Setting
        
        let kick = UIButton(type: .system)
        kick.backgroundColor = .white
        kick.addTarget(self, action: #selector(self.touchKickButton(_:)), for: .touchUpInside)
        kick.setTitle("강퇴", for: .normal)
        kick.setTitleColor(.systemRed, for: .normal)
        kick.setTitleColor(.systemGray3, for: .disabled)
        kick.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        kick.isEnabled = (userId != myUserId && hostId == myUserId) ? true : false
        
        self.kickButton = kick
        
        
        // buttonStackView Setting
        
        let stack = UIStackView(arrangedSubviews: [back, friend, kick])
        
        content.addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .bottom
        stack.spacing = 2
        stack.backgroundColor = .systemGray5
//        stack.layer.cornerRadius = 20
//        stack.clipsToBounds = true
        
        stack.translatesAutoresizingMaskIntoConstraints  = false
        stack.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -10).isActive = true
        stack.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        self.buttonStackView = stack
        
    }
    
    /* MARK: Function Method */
    
    func settingUserInfo() {
        
        /* 레이블에 유저 프로필 정보 입력 */
        
        /*
        self.profileImage.image = userProfile.image
        self.nicknameLabel.text = "닉네임: \(userProfile.nickname)"
        self.victoryRateLabel.text = "승률: " + String(format: "%.2f", userProfile.victoryRate) + "%"
        self.winCountLabel.text = "이긴 횟수: \(userProfile.winCount)회"
        self.loseCountLabel.text = "진 횟수: \(userProfile.loseCount)회"
        self.scoreLabel.text = "점수: \(userProfile.score)"
        */
        
        self.profileImage.image = nil
        self.nicknameLabel.text = "닉네임: 미구현"
        self.victoryRateLabel.text = "승률: 100%"
        self.winCountLabel.text = "이긴 횟수: 0회"
        self.loseCountLabel.text = "진 횟수: 0)회"
        self.scoreLabel.text = "점수: 1000"
        
        
    }
    
    func checkFriendRequestButton(_ button: UIButton) {
        
        /*
        /* 해당 유저가 자기 자신인지 확인 */
        if userProfile.userID == myProfile.userID {
            button.isHidden = true
            return
        }
        
        
        /* 해당 유저에게 이미 친구 요청을 보낸 상태인지 확인 */
        for request in myFriendRequest {
            
            if userProfile.userID == request.responderID {
                
                button.isEnabled = false
                button.setTitle("요청 보냄", for: .disabled)
                
            }
            
        }
        
        
        /* 해당 유저가 친구 목록에 있는지 확인 */
        for friend in myFriends {
            
            if userProfile.userID == friend.friendID {
                
                button.setTitle("친구 삭제", for: .normal)
                button.setTitleColor(.darkGray, for: .normal)
                button.addTarget(self, action: #selector(touchRemoveFriendButton(_:)), for: .touchUpInside)
                return
                
            }
        }
        
        
        button.addTarget(self, action: #selector(touchRequestFriendButton(_:)), for: .touchUpInside)
         */
    }
    
    
    // MARK: - Action
    
    @objc func touchRequestFriendButton(_ sender: UIButton) {
        
        /*
        /* 친구 요청 객체 생성 */
        let request = FriendRequest(senderID: myProfile.userID, responderID: userProfile.userID, status: 0)
        
        myFriendRequest.append(request)
        
        sender.isEnabled = false
        sender.setTitle("요청 보냄", for: .disabled)
         */
        
        
    }
    
    @objc func touchRemoveFriendButton(_ sender: UIButton) {
        
        /*
        /* 친구 목록 리스트에서 친구 삭제 */
        for i in 0...myFriends.count-1 {
            
            if userProfile.userID == myFriends[i].friendID {
                myFriends.remove(at: i)
                break
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
         */
    }
    
    @objc func touchKickButton(_ sender: UIButton) {
        /*
        guard let waittingRoom = self.presentingViewController as? WaittingRoom else {return}
        guard let collection = waittingRoom.waitUserCollection else { return }
        
        /* 현재 보고있는 프로필의 유저 강퇴 */
        if let index = collection.indexPath(for: self.userCell) {
            if Myroom.users[index.row].userID == userProfile.userID {
                waittingRoom.exile(index.row)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        */
        
        SocketIOManager.shared.kick(roomId: roomId, userId: userId)
        
        self.dismiss(animated: true)
        
    }
    
    @objc func touchCancleButton(_ sender: UIButton){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - LifeCylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.addContentView()
        self.addInfoLabel()
        self.addButtons()
        self.settingUserInfo()

    }
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("어쩌구")
    }
    
    init(roomId: String, userId: Int, myUserId: Int, hostId: Int){
        self.roomId = roomId
        self.userId = userId
        self.myUserId = myUserId
        self.hostId = hostId
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
        
    }
    
    deinit {
        print("ProfileView Deinit")
    }

}
