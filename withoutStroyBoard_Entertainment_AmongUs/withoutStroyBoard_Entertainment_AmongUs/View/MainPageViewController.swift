//
//  MainPageViewController.swift
//  EntertainAmongUs_code_version
//
//  Created by 남궁광 on 2022/03/02.
//

import UIKit
import SideMenu


class MainPageViewController: UIViewController {
    var sideButton: UIButton?
    var explainLabel: UILabel?
    
    var roomListTableView: UITableView!
    var roomListTableViewHeightConstraint: NSLayoutConstraint?
    let roomIdentifier = "RoomCell"
    
    var roomCreateButton: UIButton?
    var roomSearchButton: UIButton?
    var buttonStack: UIStackView?
    
    var chatTextField: UITextField?
    var chatTableView: UITableView?
    let chatIdentifier = "chat"
    
    
    
    lazy var rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(title: "SideBtn", style: .plain, target: self, action: #selector(presentSideMenu(_:)))
            return button
        }()
    
    func addSideButton(){
        let sidebutton: UIButton = {
            let abutton = UIButton()
            abutton.setTitle("SideBtn", for: .normal)
            abutton.titleLabel?.font = UIFont.systemFont(ofSize: 15,weight: .semibold)
            abutton.addTarget(self, action: #selector(presentSideMenu(_:)), for: .touchUpInside)
            abutton.setTitleColor(.systemBlue, for: .normal)
            return abutton
        }()
     
        view.addSubview(sidebutton)
        self.sideButton = sidebutton
        
        sidebutton.translatesAutoresizingMaskIntoConstraints = false
        sidebutton.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true
        
        sidebutton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
    }
    func addRoom(){
        //guard let sideButton = sideButton else { return }

        let explainLabel: UILabel = {
            let aexplainLabel = UILabel()
            aexplainLabel.text = "타입 \t 제목 \t \t \t \t \t \t \t   인원수"
            aexplainLabel.textColor = .black
            aexplainLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
            aexplainLabel.clipsToBounds = true
            //aexplainLabel.textAlignment = .center
            aexplainLabel.numberOfLines = 1
            aexplainLabel.translatesAutoresizingMaskIntoConstraints = false
            return aexplainLabel
        }()
        self.view.addSubview(explainLabel)
        
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        explainLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 150).isActive = true
        //explainLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -3*self.view.safeAreaLayoutGuide.layoutFrame.size.height/5).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 24).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -24).isActive = true
        
        
        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
        table.register(RoomCell.self, forCellReuseIdentifier: self.roomIdentifier)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: explainLabel.safeAreaLayoutGuide.bottomAnchor,constant: 5).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -3*self.view.safeAreaLayoutGuide.layoutFrame.size.height/5).isActive = true
        table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 24).isActive = true
        table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -24).isActive = true
        
        self.roomListTableView = table
    }
    
    func addButton(){
        
        guard let roomListTableView = self.roomListTableView else { return }

        let searchRoomButton: UIButton = {
           let asearchRoomButton = UIButton()
            asearchRoomButton.setTitle("방 검색", for: .normal)
            asearchRoomButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            asearchRoomButton.addTarget(self, action: #selector(self.roomSearchButton(_:)), for: .touchUpInside)
            asearchRoomButton.setTitleColor(.systemBlue, for: .normal)
            return asearchRoomButton
        }()
        
        view.addSubview(searchRoomButton)
        
        let createRoomButton: UIButton = {
           let acreateRoomButton = UIButton()
            acreateRoomButton.setTitle("방 생성", for: .normal)
            acreateRoomButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            acreateRoomButton.addTarget(self, action: #selector(self.roomCreateButton(_:)), for: .touchUpInside)
            acreateRoomButton.setTitleColor(.systemBlue, for: .normal)
            return acreateRoomButton
        }()
        
        view.addSubview(createRoomButton)
        
        let stackView: UIStackView = {
           let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 10
            return stackView
        }()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(searchRoomButton)
        stackView.addArrangedSubview(createRoomButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: roomListTableView.bottomAnchor,constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        
        self.buttonStack = stackView
    }
    
    func addChat(){
        guard let buttonStack = self.buttonStack else { return }

        let textField = UITextField()
        
        self.view.addSubview(textField)
        
        textField.placeholder = "채팅을 입력하세요"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant:  -24).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.chatTextField = textField
        
        
        // ChattingTableView Setting
        let table_2 = UITableView(frame: .zero, style: .plain) 
        
        self.view.addSubview(table_2)
        
        
         table_2.delegate = self
         table_2.dataSource = self
         table_2.register(ChatCell.self, forCellReuseIdentifier: self.chatIdentifier)
        
         table_2.layer.cornerRadius = 3
         table_2.clipsToBounds = true
         table_2.backgroundColor = .systemGray5
         table_2.separatorStyle = .none
         table_2.allowsSelection = false
        
        
        table_2.translatesAutoresizingMaskIntoConstraints = false
        table_2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        table_2.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 10).isActive = true
        table_2.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        table_2.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        table_2.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5 ).isActive = true
        
        self.chatTableView = table_2
    }
    
    @objc func presentSideMenu(_ sender: UIButton) {
        /* 그냥 처음에 대충 넣은 것.
        let sideBar = SideMenuViewController()
        self.navigationController?.pushViewController(SideBar, animated: true)
        
        이번엔 present이용해서 사용.
        present(sideBar, animated: true, completion: nil)
         */
        
        let SideMenuViewController = SideMenuViewController()
        let CustomSideMenuNavi = CustomSideMenuNavigation(rootViewController: SideMenuViewController)

        
        present(CustomSideMenuNavi,animated: true,completion: nil)
    }
    
    @objc func roomCreateButton(_ sender: UIButton){
        let roomCreateButtonView = RoomCreateButtonController()
        roomCreateButtonView.modalTransitionStyle = .crossDissolve
        roomCreateButtonView.modalPresentationStyle = .overCurrentContext
        //present로 화면 전환 해보는 것 응용함.
        present(roomCreateButtonView,animated: true, completion: nil)
    }
    
    @objc func roomSearchButton(_ sender: UIButton){
        //let SignUpView = SignUpViewController()
        //self.navigationController?.pushViewController(SignUpView, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "메인 Page"
        self.navigationItem.rightBarButtonItem = self.rightButton
        //addSideButton()
        addRoom()
        addButton()
        addChat()
    }
    
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == roomListTableView
        {
            return roomList.count
        }
        else
        {
            return chattings.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //3번
        if tableView == roomListTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.roomIdentifier, for: indexPath) as! RoomCell
            let info = roomList[indexPath.row]
            //RoomCell 변수 = model 변수
            cell.gameType?.text = info.gametype
            
            cell.roomName?.text = info.roomname
            
            if info.password == "" {
                cell.keyImage?.image = UIImage(systemName: "")
            }
            else{
                cell.keyImage?.image = UIImage(systemName: "key")
            }
            
            cell.roomPersonNum?.text = info.roompersonNum
            
            return cell
            
        }
        else{
            let cell_2 = tableView.dequeueReusableCell(withIdentifier: self.chatIdentifier, for: indexPath) as! ChatCell
            let info_2 = chattings[indexPath.row]
            //RoomCell 변수 = model 변수
            cell_2.nickname?.text = info_2.nickname
            cell_2.chatting?.text = info_2.message
            return cell_2
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//textField누르면 화면 전환 일어난다.
extension MainPageViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let chatRoom = ChattingRoom()
        self.present(chatRoom, animated: true, completion: nil)
        return false
    }
}







