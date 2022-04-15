//
//  RoomCreateButtonController.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/11.
//

import UIKit

class RoomCreateButtonController: UIViewController{
    
    var contentView: UIView?
    
    var gameTypeLabel: UILabel?
    var gameType: UIPickerView?
    var gameTypeTextField: UITextField!
    var type: String?
    
    var roomNameLabel: UILabel?
    var roomNameTextField: UITextField?
    
    var passwordLabel: UILabel?
    var passwordTextField: UITextField?
    
    var keyLabel: UILabel?
    var keyImage: UIImage?
    
    var roomPersonNumLabel: UILabel?
    var roomPersonNum: UIPickerView?
    var roomPersonNumTextField: UITextField!
    var num: String?
    
    var cancelButton: UIButton?
    var completeButton: UIButton?
    var stackview: UIStackView?
    
    let roomIdentifier = "RoomCell"
    
    let gameTypeList = ["라이어 게임","이미지 게임"]
    let personNumList = ["3명", "4명", "5명", "6명", "7명", "8명"]
    
    //roomName: textField 사용.
    //keyImage <-버튼 눌리면 비밀번호 텍스트 필드 활성화 하고, 비밀번호 넣어주기 아니면 nil
    //roomPerson: pickerview 사용.
    
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
    
    
    func addgameType(){
        guard let content = self.contentView else { return }

        
        let gameTypeLabel = UILabel()
        content.addSubview(gameTypeLabel)

        gameTypeLabel.text = "게임 종류"
        gameTypeLabel.backgroundColor = .white
        gameTypeLabel.font = UIFont.systemFont(ofSize: 12,weight: .heavy)
        gameTypeLabel.clipsToBounds = true
        gameTypeLabel.textAlignment = .left
        gameTypeLabel.numberOfLines = 1
        
        gameTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        gameTypeLabel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        gameTypeLabel.topAnchor.constraint(equalTo: content.topAnchor,constant: 10).isActive = true
        gameTypeLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        gameTypeLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.gameTypeLabel = gameTypeLabel
        
        
        
        let gameTypeTxt = UITextField()
        content.addSubview(gameTypeTxt)

        //gameTypeTxt.placeholder = "click gameType"
        gameTypeTxt.borderStyle = .roundedRect
        
        
        gameTypeTxt.translatesAutoresizingMaskIntoConstraints = false
        gameTypeTxt.backgroundColor = .white
        gameTypeTxt.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gameTypeTxt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gameTypeTxt.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        gameTypeTxt.topAnchor.constraint(equalTo: gameTypeLabel.bottomAnchor,constant: 10).isActive = true
        gameTypeTxt.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        gameTypeTxt.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.gameTypeTextField = gameTypeTxt
        
        
        
        let gametype = UIPickerView()
        view.addSubview(gametype)
        
        
        //gametype.delegate = self
        gametype.translatesAutoresizingMaskIntoConstraints = false
        gametype.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gametype.heightAnchor.constraint(equalToConstant: 45).isActive = true
        gametype.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gametype.topAnchor.constraint(equalTo: gameTypeLabel.topAnchor,constant: 15).isActive = true
        gametype.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        gametype.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
            
    
        gametype.delegate = self
        gametype.dataSource = self
        //중요하다.!! 텍스트 필드에 pickerview를 사용하는 방법.
        gameTypeTextField.inputView = gametype
        
        self.gameType = gametype
    }
    
    
    func addroomName(){
        guard let content = self.contentView else { return }

        
        let roomNameLabel = UILabel()
        content.addSubview(roomNameLabel)

        roomNameLabel.text = "방 제목"
        roomNameLabel.backgroundColor = .white
        roomNameLabel.font = UIFont.systemFont(ofSize: 12,weight: .heavy)
        roomNameLabel.clipsToBounds = true
        roomNameLabel.textAlignment = .left
        roomNameLabel.numberOfLines = 1
        
        roomNameLabel.translatesAutoresizingMaskIntoConstraints = false
        roomNameLabel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        roomNameLabel.topAnchor.constraint(equalTo: gameTypeTextField.bottomAnchor,constant: 10).isActive = true
        roomNameLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        roomNameLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.roomNameLabel = roomNameLabel
        
        
        
        let roomNameTxt = UITextField()
        view.addSubview(roomNameTxt)
        
        roomNameTxt.placeholder = "방 제목을 입력해주세요."
        roomNameTxt.borderStyle = .roundedRect
        
        roomNameTxt.translatesAutoresizingMaskIntoConstraints = false
        roomNameTxt.backgroundColor = .white
        roomNameTxt.widthAnchor.constraint(equalToConstant: 300).isActive = true
        roomNameTxt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        roomNameTxt.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        roomNameTxt.topAnchor.constraint(equalTo: roomNameLabel.bottomAnchor,constant: 10).isActive = true
        roomNameTxt.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        roomNameTxt.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.roomNameTextField = roomNameTxt
        
    }
    
    func addpassword(){
        guard let roomName = roomNameTextField else { return }
        guard let content = self.contentView else { return }

        let passwordLabel = UILabel()
        view.addSubview(passwordLabel)
        
        passwordLabel.text = "비밀번호 설정"
        passwordLabel.backgroundColor = .white
        passwordLabel.font = UIFont.systemFont(ofSize: 12,weight: .heavy)
        passwordLabel.clipsToBounds = true
        passwordLabel.textAlignment = .left
        passwordLabel.numberOfLines = 1
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: roomName.bottomAnchor,constant: 10).isActive = true
        passwordLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        passwordLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.passwordLabel = passwordLabel
        
        
        let passwordTxt = UITextField()
        view.addSubview(passwordTxt)
        
        passwordTxt.placeholder = "비밀번호 입력해주세요."
        passwordTxt.borderStyle = .roundedRect
        passwordTxt.backgroundColor = .white
        
        
        passwordTxt.translatesAutoresizingMaskIntoConstraints = false
        passwordTxt.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordTxt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        passwordTxt.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        passwordTxt.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor,constant: 10).isActive = true
        passwordTxt.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        passwordTxt.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.passwordTextField = passwordTxt
    }
    
    func addpersonNum(){
        guard let password = passwordTextField else { return }

        guard let content = self.contentView else { return }

        let roomPersonNumLabel = UILabel()
        view.addSubview(roomPersonNumLabel)
        
        roomPersonNumLabel.text = "인원 설정"
        roomPersonNumLabel.font = UIFont.systemFont(ofSize: 12,weight: .heavy)
        roomPersonNumLabel.clipsToBounds = true
        roomPersonNumLabel.textAlignment = .left
        roomPersonNumLabel.numberOfLines = 1
        roomPersonNumLabel.backgroundColor = .white
        
        roomPersonNumLabel.translatesAutoresizingMaskIntoConstraints = false
        roomPersonNumLabel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        roomPersonNumLabel.topAnchor.constraint(equalTo: password.bottomAnchor,constant: 10).isActive = true
        roomPersonNumLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        roomPersonNumLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.roomPersonNumLabel = roomPersonNumLabel
        
        
        let roompersonNumTxt = UITextField()
        view.addSubview(roompersonNumTxt)
        
        roompersonNumTxt.borderStyle = .roundedRect
        roompersonNumTxt.backgroundColor = .white
        
        roompersonNumTxt.translatesAutoresizingMaskIntoConstraints = false
        roompersonNumTxt.widthAnchor.constraint(equalToConstant: 300).isActive = true
        roompersonNumTxt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        roompersonNumTxt.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        roompersonNumTxt.topAnchor.constraint(equalTo: roomPersonNumLabel.bottomAnchor,constant: 10).isActive = true
        roompersonNumTxt.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        roompersonNumTxt.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        self.roomPersonNumTextField = roompersonNumTxt
        
        
        let roompersonNum = UIPickerView()
        view.addSubview(roompersonNum)
        
        roompersonNum.translatesAutoresizingMaskIntoConstraints = false
        roompersonNum.widthAnchor.constraint(equalToConstant: 300).isActive = true
        roompersonNum.heightAnchor.constraint(equalToConstant: 45).isActive = true
        roompersonNum.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        roompersonNum.topAnchor.constraint(equalTo: roomPersonNumLabel.topAnchor,constant: 15).isActive = true
        roompersonNum.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        roompersonNum.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
        roompersonNum.delegate = self
        roompersonNum.dataSource = self
        
        roomPersonNumTextField.inputView = roompersonNum
        
        self.roomPersonNum = roompersonNum
        
    }
    
    func addButton(){
        guard let content = self.contentView else { return }

        guard let roompersonNumTxt = self.roomPersonNumTextField else { return }
        let cancelButton: UIButton = {
            let acancelButton = UIButton()
            acancelButton.setTitle("취소", for: .normal)
            acancelButton.backgroundColor = .white
            acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
            acancelButton.setTitleColor(.systemBlue, for: .normal)
            return acancelButton
        }()
        content.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        
        
        
        let completeButton: UIButton = {
            let acompleteButton = UIButton()
            acompleteButton.setTitle("완료", for: .normal)
            acompleteButton.backgroundColor = .white
            acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12,weight: .bold)
            acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
            acompleteButton.setTitleColor(.systemBlue, for: .normal)
            //비활성화 생각하느라!
            //acompleteButton.isEnabled = false
            return acompleteButton
        }()
        
        content.addSubview(completeButton)
        self.completeButton = completeButton
        
        let stackview: UIStackView = {
            let astackview = UIStackView()
            
            astackview.translatesAutoresizingMaskIntoConstraints = false
            astackview.backgroundColor = .white
            astackview.axis = .horizontal
            astackview.alignment = .fill
            astackview.distribution = .fillEqually
            astackview.spacing = 30
            return astackview
        }()
        
        content.addSubview(stackview)
        
        stackview.addArrangedSubview(cancelButton)
        stackview.addArrangedSubview(completeButton)
        
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        stackview.topAnchor.constraint(equalTo: roompersonNumTxt.topAnchor,constant: 35).isActive = true

        stackview.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        stackview.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        stackview.spacing = 30
        
    }
    //완료 버튼시 실행되는 것. -> 메인페이지 텍스트 필드에 추가 될 놈이다. -> 방 제목이 적히지 않으면 비 활성화 시켜야할 듯.
    func reloadRoom(_ index: IndexPath){
        guard let navi = self.presentingViewController as? UINavigationController else { return }
        
        guard let mainPage = navi.topViewController as? MainPageViewController else { return }
        
        mainPage.roomListTableView?.reloadData()
        mainPage.roomListTableView?.scrollToRow(at: index, at: .bottom, animated: false)
    }
    
    func completeAction(){
        guard let type = self.type else { return }
        guard let name = roomNameTextField?.text else { return }
        guard let pass = passwordTextField?.text else { return }
        guard let num = self.num else { return }
        
        let count = roomList.count
        
        let newroom = Room(gametype: type, roomname: name, password: pass, roompersonNum: num)
        
        let index = IndexPath(row:count,section: 0)
        
        roomList.append(newroom)
        
        self.reloadRoom(index)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //취소 버튼
    @objc func cancelButton(_ sender: UIButton) {
        //present이용했을 때, 취소하는 방법이다.
        self.dismiss(animated: true, completion: nil)
    }
    
    //완료 버튼 -> 미완
    @objc func completeButton(_ sender: UIButton){
        completeAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //투명도 설정 때문에 납뒀음. 그러나 팝업창 형식으로 구현하기위해 보류
        //self.view.backgroundColor = UIColor.systemRed.withAlphaComponent(1)
        view.backgroundColor = .white.withAlphaComponent(0.55)
        addContentView()
        addgameType()
        addroomName()
        addpassword()
        addpersonNum()
        addButton()
    }
}


extension RoomCreateButtonController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == gameType{
            return gameTypeList.count
        }
        else{
            return personNumList.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == gameType{
            self.type = gameTypeList[row]
            return gameTypeList[row]
        }
        else{
            self.num = personNumList[row]
            return personNumList[row]
        }
    }
    
    /*
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == gameType{
            print(gameTypeList[row])
        }
        else{
            print(personNumList[row])
        }
    }
     */
    
}
