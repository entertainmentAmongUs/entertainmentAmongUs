//
//  SignUpViewController.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/05/30.
//

import UIKit
import Toast_Swift
import Alamofire
import SnapKit

final class SignUpViewContrller: UIViewController {
    var e_mail: String = ""
    var nick_name: String = ""
    var pass_word: String = ""
    var confirm_pass_word: String = ""
    var na_me: String = ""
    var URL: String = ""
    
    //회원가입 Label
    private lazy var signUpLabel: UILabel = {
        let asignUpLabel = UILabel()
        asignUpLabel.text = "회원가입"
        asignUpLabel.textColor = .black
        asignUpLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        asignUpLabel.clipsToBounds = true
        asignUpLabel.textAlignment = .center
        asignUpLabel.numberOfLines = 1
        return asignUpLabel
    }()
    private lazy var essential: UILabel = {
        let aessential = UILabel()
        aessential.text = "필수사항"
        aessential.textColor = .black
        aessential.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        aessential.clipsToBounds = true
        aessential.textAlignment = .left
        aessential.numberOfLines = 1
        return aessential
    }()
    
    // 닉네임 Label,textField,중복체크
    private lazy var nickname: UILabel = {
        let anickname = UILabel()
        anickname.text = "닉네임"
        anickname.textColor = .black
        anickname.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        anickname.clipsToBounds = true
        anickname.textAlignment = .left
        anickname.numberOfLines = 1
        return anickname
    }()
    private lazy var nicknameTextField: UITextField = {
        let anicknametextField = UITextField()
        anicknametextField.backgroundColor = .white
        anicknametextField.borderStyle = .roundedRect
        anicknametextField.autocapitalizationType = .none
        return anicknametextField
    }()
    private lazy var check_nicknameButton: UIButton = {
        let acheck_nicknameButton = UIButton()
        acheck_nicknameButton.setTitle("중복확인", for: .normal)
        acheck_nicknameButton.titleLabel?.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
        acheck_nicknameButton.addTarget(self, action: #selector(self.check_nickname(_:)), for: .touchUpInside)
        acheck_nicknameButton.setTitleColor(.systemBlue, for: .normal)
        return acheck_nicknameButton
    }()
    
    //substackview
    private lazy var substackView: UIStackView = {
        let asubstackView = UIStackView()
        asubstackView.axis = .horizontal
        asubstackView.alignment = .fill
        asubstackView.distribution = .fill
        asubstackView.spacing = 10
        return asubstackView
    }()
    
    
    //stackview
    private lazy var stackView: UIStackView = {
        let astackView = UIStackView()
        astackView.axis = .vertical
        astackView.alignment = .fill
        astackView.distribution = .fill
        astackView.spacing = 10
        return astackView
    }()
    
    //비밀번호
    private lazy var password: UILabel = {
        let apassword = UILabel()
        apassword.text = "비밀번호"
        apassword.textColor = .black
        apassword.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        apassword.clipsToBounds = true
        apassword.textAlignment = .left
        apassword.numberOfLines = 1
        return apassword
    }()
    
    private lazy var passwordTextField: UITextField = {
        let apasswordtextField = UITextField()
        apasswordtextField.backgroundColor = .white
        apasswordtextField.borderStyle = .roundedRect
        apasswordtextField.autocapitalizationType = .none
        apasswordtextField.isSecureTextEntry = true
        return apasswordtextField
    }()
    
    
    //stackView_2
    private lazy var stackView_2: UIStackView = {
        let astackView = UIStackView()
        astackView.axis = .vertical
        astackView.alignment = .fill
        astackView.distribution = .fill
        astackView.spacing = 10
        return astackView
    }()
    
    //비밀번호 확인
    private lazy var confirm_password: UILabel = {
        let aconfirm_Password = UILabel()
        aconfirm_Password.text = "비밀번호 확인"
        aconfirm_Password.textColor = .black
        aconfirm_Password.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        aconfirm_Password.clipsToBounds = true
        aconfirm_Password.textAlignment = .left
        aconfirm_Password.numberOfLines = 1
        return aconfirm_Password
    }()
    private lazy var confirm_passwordTextField: UITextField = {
        let aconfirm_PasswordtextField = UITextField()
        aconfirm_PasswordtextField.backgroundColor = .white
        aconfirm_PasswordtextField.borderStyle = .roundedRect
        aconfirm_PasswordtextField.autocapitalizationType = .none
        aconfirm_PasswordtextField.isSecureTextEntry = true
        return aconfirm_PasswordtextField
    }()
    
    private lazy var stackView_3: UIStackView = {
        let astackView = UIStackView()
        astackView.axis = .vertical
        astackView.alignment = .fill
        astackView.distribution = .fill
        astackView.spacing = 10
        return astackView
    }()
    
    private lazy var name: UILabel = {
        let aname = UILabel()
        aname.text = "이름"
        aname.textColor = .black
        aname.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        aname.clipsToBounds = true
        aname.textAlignment = .left
        aname.numberOfLines = 1
        return aname
    }()
    
    private lazy var nametextField: UITextField = {
        let anametextField = UITextField()
        anametextField.backgroundColor = .white
        anametextField.borderStyle = .roundedRect
        anametextField.autocapitalizationType = .none
        anametextField.autocorrectionType = .no
        return anametextField
    }()
    
    private lazy var stackView_4: UIStackView = {
        let astackView = UIStackView()
        astackView.axis = .vertical
        astackView.alignment = .fill
        astackView.distribution = .fill
        astackView.spacing = 10
        return astackView
    }()
    
    //이름
    private lazy var email: UILabel = {
        let aemail = UILabel()
        aemail.text = "이메일"
        aemail.textColor = .black
        aemail.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        aemail.clipsToBounds = true
        aemail.textAlignment = .left
        aemail.numberOfLines = 1
        return aemail
    }()
    private lazy var emailTextField: UITextField = {
        let aemailtextField = UITextField()
        aemailtextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        aemailtextField.backgroundColor = .white
        aemailtextField.borderStyle = .roundedRect
        aemailtextField.autocapitalizationType = .none
        return aemailtextField
    }()
    private lazy var check_emailButton: UIButton = {
        let acheck_emailButton = UIButton()
        acheck_emailButton.setTitle("중복확인", for: .normal)
        acheck_emailButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 , weight: .semibold)
        acheck_emailButton.addTarget(self, action: #selector(self.check_email(_:)), for: .touchUpInside)
        acheck_emailButton.setTitleColor(.systemBlue, for: .normal)
        return acheck_emailButton
    }()
    
    private lazy var substackView_2 : UIStackView = {
        let asubstackView_2 = UIStackView()
        asubstackView_2.axis = .horizontal
        asubstackView_2.alignment = .fill
        asubstackView_2.distribution = .fill
        asubstackView_2.spacing = 10
        return asubstackView_2
    }()
    
    private lazy var stackView_5: UIStackView = {
        let astackView = UIStackView()
        astackView.axis = .vertical
        astackView.alignment = .fill
        astackView.distribution = .fill
        astackView.spacing = 10
        return astackView
    }()
    
    private lazy var totalstackView: UIStackView = {
        let atotalstackView = UIStackView()
        atotalstackView.axis = .vertical
        atotalstackView.translatesAutoresizingMaskIntoConstraints = false
        atotalstackView.alignment = .fill
        atotalstackView.distribution = .fill
        atotalstackView.spacing = 15
        return atotalstackView
    }()
    
    //버튼
    private lazy var cancelButton: UIButton = {
        let acancelButton = UIButton()
        acancelButton.setTitle("취소", for: .normal)
        acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
        acancelButton.setTitleColor(.systemBlue, for: .normal)
        return acancelButton
    }()
    private lazy var completeButton: UIButton = {
        let acompleteButton = UIButton()
        acompleteButton.setTitle("완료", for: .normal)
        acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
        acompleteButton.setTitleColor(.systemBlue, for: .normal)
        return acompleteButton
    }()
    
    private lazy var stackView_6: UIStackView = {
        let astackView = UIStackView()
        astackView.translatesAutoresizingMaskIntoConstraints = false
        astackView.axis = .horizontal
        astackView.alignment = .fill
        astackView.distribution = .fillEqually
        astackView.spacing = 30
        return astackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
}

private extension SignUpViewContrller {
    //layout 정리
    func setupLayout(){
        [
            signUpLabel,
            essential,
            nickname,
            nicknameTextField,
            check_nicknameButton,
            substackView,
            stackView,
            password,
            passwordTextField,
            stackView_2,
            confirm_password,
            confirm_passwordTextField,
            stackView_3,
            name,
            nametextField,
            stackView_4,
            email,
            emailTextField,
            check_emailButton,
            substackView_2,
            stackView_5,
            totalstackView,
            cancelButton,
            completeButton,
            stackView_6
        ].forEach{view.addSubview($0)}
        //snapkit 이용하여 autolayout 정리
        nicknameTextField.snp.makeConstraints{
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-80)
        }
        
        [
            nicknameTextField,
            check_nicknameButton
        ].forEach{substackView.addArrangedSubview($0)}
        
        [
            nickname,
            substackView
        ].forEach{stackView.addArrangedSubview($0)}
        
        [
            password,
            passwordTextField
        ].forEach{ stackView_2.addArrangedSubview($0)}
        
        [
            confirm_password,
            confirm_passwordTextField
        ].forEach{ stackView_3.addArrangedSubview($0)}
        
        [
            name,
            nametextField
        ].forEach{ stackView_4.addArrangedSubview($0)}
        
        emailTextField.snp.makeConstraints{
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-80)
        }
        
        [
            emailTextField,
            check_emailButton
        ].forEach{ substackView_2.addArrangedSubview($0)}
        
        [
            email,
            substackView_2
        ].forEach{ stackView_5.addArrangedSubview($0)}
        
        [
            signUpLabel,
            essential,
            stackView,
            stackView_2,
            stackView_3,
            stackView_4,
            stackView_5
        ].forEach{ totalstackView.addArrangedSubview($0)}
        
        totalstackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(120)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        totalstackView.spacing = 5
        
        [
            cancelButton,
            completeButton
        ].forEach{ stackView_6.addArrangedSubview($0) }
        
        stackView_6.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(totalstackView.snp.bottom).offset(24)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        totalstackView.translatesAutoresizingMaskIntoConstraints = false
        stackView_6.translatesAutoresizingMaskIntoConstraints = false
        
        stackView_6.spacing = 30

        
        
    }
    
}

private extension SignUpViewContrller {
    func completeAction(){
        self.e_mail = emailTextField.text ?? ""
        self.nick_name = nicknameTextField.text ?? ""
        self.pass_word = passwordTextField.text ?? ""
        self.confirm_pass_word = confirm_passwordTextField.text ?? ""
        self.na_me = nametextField.text ?? ""
        
        if !isValidEmail(self.e_mail){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        if !isVaildPass(self.pass_word){
            //비밀번호 형식 실패
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        if pass_word != self.confirm_pass_word{
            self.view.makeToast("비밀번호와 비밀번호 확인이 다릅니다.", duration: 1.0, position: .bottom)
            return
        }
        self.URL = "http://52.78.47.148:8080/users/new-user"
        let param: Parameters = [
            "email" : e_mail,
            "nickname": nick_name,
            "password" : pass_word
        ]
        let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "회원가입을 축하드립니다!",message: "확인버튼을 누르시고 로그인을 하세요.",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
            //통신실패
            case .failure(let error):
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    //이메일 가능한지 확인
    func isValidEmail(_ email:String) ->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHes %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    //비밀번호 가능한지 확인(특수문자 안됨.)
    func isVaildPass(_ pass:String)->Bool{
        let passRefEx = "^[a-zA-Z0-9]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
    }
    
    
    //취소 버튼
    @objc func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //완료 버튼
    @objc func completeButton(_ sender: UIButton){
        completeAction()
    }
    @objc func check_email(_ sender: UIButton){
        //alamofire 이용하기(다시하기)
        self.e_mail = emailTextField.text ?? ""
        let param: Parameters = [
            "email" : self.e_mail
        ]
        if !isValidEmail(self.e_mail){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        self.URL = "http://52.78.47.148:8080/users/checkEmail/\(String(self.e_mail))"
        let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            //통신실패
            case .failure(let error):
                    //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title:"\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                    })
                    alert.addAction(confirm)
                    self.present(alert,animated: true,completion: nil)
                }
            }
    }
    
    @objc func check_nickname(_ sender: UIButton){
        //alamofire 이용하기(다시해야함.)
        self.nick_name = nicknameTextField.text ?? ""
        let param: Parameters = [
            "nickname" : self.nick_name
        ]
        self.URL = "http://52.78.47.148:8080/users/checkNickname/\(String(self.nick_name))"
        let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    //self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            //통신실패
            case .failure(let error):
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                    
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
}
