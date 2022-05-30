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
    
    var scoreLabel: UILabel?
    var score: UILabel?
    
    var gameruleButton: UIButton?
    
    var userTableView: UITableView?
    let userCellIdentifier = "userCell"
    
    var settingButton: UIButton?
    var logoutButton: UIButton?
    
    var lobbyUserList: [User]
    
    
    // MARK: - Method
    
    func addpicture() {
        
        let scoreLabel: UILabel = {
            let ascoreLabel = UILabel()
            ascoreLabel.text = "점수"
            ascoreLabel.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
            ascoreLabel.clipsToBounds = true
            ascoreLabel.textAlignment = .left
            ascoreLabel.numberOfLines = 1
            ascoreLabel.textColor = .white
            ascoreLabel.translatesAutoresizingMaskIntoConstraints = false
            return ascoreLabel
        }()
        
        view.addSubview(scoreLabel)
        self.scoreLabel = scoreLabel
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        let score: UILabel = {
            let ascore = UILabel()
            ascore.text = "20437점"
            ascore.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
            ascore.clipsToBounds = true
            ascore.textAlignment = .left
            ascore.numberOfLines = 1
            ascore.textColor = .white
            ascore.translatesAutoresizingMaskIntoConstraints = false
            return ascore
        }()
        
        view.addSubview(score)
        self.score = score
        
        score.translatesAutoresizingMaskIntoConstraints = false
        score.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        score.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 20).isActive = true
        score.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        score.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
    }
    
    func addgamerule(){
        guard let score = self.score else { return }
        let gamerule: UIButton = {
            let agamerule = UIButton()
            agamerule.setTitle("게임 설명 버튼", for: .normal)
            agamerule.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            agamerule.addTarget(self, action: #selector(self.explainButton(_:)),for: .touchUpInside)
            agamerule.setTitleColor(.systemBlue, for: .normal)
            return agamerule
        }()
        
        view.addSubview(gamerule)
        self.gameruleButton = gamerule
        gamerule.translatesAutoresizingMaskIntoConstraints = false
        gamerule.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gamerule.topAnchor.constraint(equalTo: score.bottomAnchor,constant: 20).isActive = true
        gamerule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        gamerule.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        
    }
    
    
    func addUserListTableView(){
        
        let table = UITableView(frame: .zero, style: .plain)
        
        table.register(UserCell.self, forCellReuseIdentifier: userCellIdentifier)
        table.delegate = self
        table.dataSource = self
        
        table.backgroundColor = .green
        
        self.view.addSubview(table)
        
        
        let layoutGuide = self.view.safeAreaLayoutGuide
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: layoutGuide.topAnchor,constant: 20).isActive = true
        table.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10).isActive = true
        table.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10).isActive = true
        table.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -layoutGuide.layoutFrame.height/3).isActive = true
        
        self.userTableView = table
        
    }
    
    
    func addButton(){
        guard let friendTableView = userTableView else { return }
        
        let setting: UIButton = {
            let asetting = UIButton()
            asetting.setTitle("Setting", for: .normal)
            asetting.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            asetting.addTarget(self, action: #selector(self.settingButton(_:)),for: .touchUpInside)
            asetting.setTitleColor(.systemBlue, for: .normal)
            return asetting
        }()
        
        view.addSubview(setting)
        self.settingButton = setting
        setting.translatesAutoresizingMaskIntoConstraints = false
        setting.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setting.topAnchor.constraint(equalTo: friendTableView.bottomAnchor,constant: 20).isActive = true
        setting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        setting.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        let logout: UIButton = {
            let alogout = UIButton()
            alogout.setTitle("뒤로가기", for: .normal)
            alogout.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            alogout.addTarget(self, action: #selector(self.logoutButton(_:)),for: .touchUpInside)
            alogout.setTitleColor(.systemBlue, for: .normal)
            return alogout
        }()
        
        view.addSubview(logout)
        self.logoutButton = logout
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logout.topAnchor.constraint(equalTo: setting.bottomAnchor,constant: 20).isActive = true
        logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        logout.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        
        
    }
    
    // MARK:  Action Mehotd
    
    @objc func explainButton(_ sender: UIButton) {
        
        /*
         let explainButtonView = ExplainButtonController()
         explainButtonView.modalTransitionStyle = .crossDissolve
         explainButtonView.modalPresentationStyle = .overCurrentContext
         
         present(explainButtonView,animated: true, completion: nil)
         */
        
    }
    
    @objc func settingButton(_ sender: UIButton){
        //아직미완
    }
    
    @objc func logoutButton(_ sender: UIButton){
        //self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
        self.view.window!.rootViewController?.dismiss(animated: false,completion: nil)
        
        
        
    }
    
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
//        addpicture()
//        addgamerule()
//        addButton()
        
        
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
        
        AF.request("http://52.78.47.148:8080/profile/8/mypage").validate().response { response in
            
            print(response.description)
            
            
        }
        
    }
    
    
    
}
