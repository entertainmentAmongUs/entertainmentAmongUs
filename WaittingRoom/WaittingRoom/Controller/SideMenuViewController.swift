//
//  SideMenuViewController.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/04.
//

import UIKit
import SideMenu
import Alamofire

class SideMenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var userTableView: UITableView?
    var contentView: UIView?
    
    var labelStackView: UIStackView?
    var profileImage = UIImageView()
    var nicknameLabel = UILabel()
    var victoryRateLabel = UILabel()
    var winCountLabel = UILabel()
    var loseCountLabel = UILabel()
    var scoreLabel = UILabel()
    let userCellIdentifier = "userCell"
    
    var lobbyUserList: [User]
    
    
    // MARK: - Method
    
    func addUserListTableView(){
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.register(UserCell.self, forCellReuseIdentifier: userCellIdentifier)
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = .systemGray6
        table.sectionHeaderTopPadding = 0
        
        self.view.addSubview(table)
        
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: layoutGuide.topAnchor,constant: 20).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10).isActive = true
        table.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -layoutGuide.layoutFrame.height/2).isActive = true
        
        self.userTableView = table
        
    }
    
    func addProfileView() {
        
        guard let userTableView = userTableView else { return }

        
        let content = UIView()
        
        self.view.addSubview(content)
        
        content.backgroundColor = .systemGray6
        content.layer.cornerRadius = 30
        content.clipsToBounds = true
        
        content.translatesAutoresizingMaskIntoConstraints = false
        let layoutGuide = self.view.safeAreaLayoutGuide
        content.topAnchor.constraint(equalTo: userTableView.bottomAnchor, constant: 20).isActive = true
        content.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10).isActive = true
        content.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10).isActive = true
        content.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -layoutGuide.layoutFrame.height/4).isActive = true
        
        self.contentView = content
        
        
    }
    
    func addInfoLabel() {
        
        guard let content = self.contentView else { return }
        let layout = self.view.safeAreaLayoutGuide
        let length = layout.layoutFrame.height/10
        
        /* 프로필 사진 이미지 뷰 설정*/
        
        let image = self.profileImage
        
        image.layer.cornerRadius = length/2
        image.backgroundColor = .white
        image.clipsToBounds = true
        
        content.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: content.topAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: length).isActive = true
        image.heightAnchor.constraint(equalToConstant: length).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        
        /* 유저 정보 모아놓은 스택 뷰 설정*/
        
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, scoreLabel, victoryRateLabel, winCountLabel, loseCountLabel])
        
        content.addSubview(stack)
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 3
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive = true
        stack.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -5).isActive = true
        
    }
    
    func settingUserInfo(profile: Profile) {
        
        /* 레이블에 유저 프로필 정보 입력 */
        
        self.profileImage.image = UIImage(named: "ic_user_loading")
        self.nicknameLabel.text = "닉네임: \(profile.nickName)"
        self.victoryRateLabel.text = "승률: \(Int(profile.victoryRate))%"
        self.winCountLabel.text = "이긴 횟수: \(profile.winCount)회"
        self.loseCountLabel.text = "진 횟수: \(profile.loseCount)회"
        self.scoreLabel.text = "점수: \(profile.score)점"
        
        
    }
    
    
    
    // MARK:  Action Mehotd
    
    @objc func getLobbyUserList(noti:Notification) {
        
        let userList = noti.object as! [User]
        
        self.lobbyUserList = userList
        
        userTableView?.reloadData()
        
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addUserListTableView()
        addProfileView()
        addInfoLabel()
        
        
    }
    
    // MARK: - Initialize
    
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    
    init(userList: [User]) {
        self.lobbyUserList = userList
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getLobbyUserList(noti:)), name: NSNotification.Name(rawValue: "getLobbyUserListNotification"), object: nil)
    }
    
    
}

// MARK: - Extension

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lobbyUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier, for: indexPath) as! UserCell
        
        cell.nickname?.text = lobbyUserList[indexPath.row].nickName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // baseURL 쓰면 500코드 오류 남
        AF.request("http://52.78.47.148:8080/profile/\(lobbyUserList[indexPath.row].userId)/mypage").validate().response { [weak self] response in
            
            guard let data = response.data else { return }
            
            guard let profile = try? JSONDecoder().decode(Profile.self, from: data) else { return }
            
            self?.settingUserInfo(profile: profile)
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "접속중인 유저"
    }
    
    
    
}
