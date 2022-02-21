//
//  ProfileViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/17.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
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
    var forcedToLeaveButton: UIButton?
    var backButton: UIButton?
    var requestFriendButton: UIButton?
    
    
    // MARK: - Method
    
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
        
        
        // profileImage Setting
        
        let image = self.profileImage
        
        content.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: 120).isActive = true
        image.heightAnchor.constraint(equalToConstant: 120).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        
        // labelStackView Setting
        
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
        
    }
    
    func addButtons(){
        
        guard let content = self.contentView else {return}
        
        
        // backButton Setting
        
        let back = UIButton(type: .system)
        back.setTitle("뒤로", for: .normal)
        back.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        back.addTarget(self, action: #selector(self.touchCancleButton(_:)), for: .touchUpInside)
        
        
        // requsetFriendButton Setting
        
        let friend = UIButton(type: .system)
        friend.setTitle("친구 요청", for: .normal)
        friend.addTarget(self, action: #selector(self.touchRequestFriendButton(_:)), for: .touchUpInside)
        friend.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        
        // forcedToLeaveButton Setting
        
        let forcedToleave = UIButton(type: .system)
        forcedToleave.setTitle("강퇴", for: .normal)
        forcedToleave.setTitleColor(.systemRed, for: .normal)
        forcedToleave.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        
        // buttonStackView Setting
        
        let stack = UIStackView(arrangedSubviews: [back, friend, forcedToleave])
        
        content.addSubview(stack)
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .bottom
        
        stack.translatesAutoresizingMaskIntoConstraints  = false
        stack.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 10).isActive = true
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -10).isActive = true
        stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -10).isActive = true
        
        self.buttonStackView = stack
        
    }
    
    
    // MARK: - Action
    
    @objc func touchRequestFriendButton(_ sender: UIButton) {
        
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

    }
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
