//
//  ProfileViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/17.
//

import UIKit

class LobbyProfileViewController: UIViewController {
    
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
//    var kickButton: UIButton?
    var backButton: UIButton?
    var friendButton: UIButton?
    
    
    let profile: Profile
//    var roomId: String
//    var userId: Int
//    var myUserId: Int
//    var hostId: Int
    
    
    
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
        
        
        // buttonStackView Setting
        
        let stack = UIStackView(arrangedSubviews: [back])
        
        content.addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
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
        
        self.profileImage.image = UIImage(systemName: "ic_user_loading")
        self.nicknameLabel.text = "\(profile.nickName)"
        self.victoryRateLabel.text = "11"
        self.winCountLabel.text = "\(profile.winCount)"
        self.loseCountLabel.text = "\(profile.loseCount)"
        self.scoreLabel.text = "\(profile.score)"
        
        
    }
    

    
    // MARK: - Action
    
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
        fatalError("error")
    }
    
    init(profile: Profile){
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("ProfileView Deinit")
    }

}
