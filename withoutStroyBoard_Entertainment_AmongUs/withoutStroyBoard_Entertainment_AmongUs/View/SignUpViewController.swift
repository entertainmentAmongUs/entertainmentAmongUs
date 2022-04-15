//
//  SignUpViewController.swift
//  EntertainAmongUs_code_version
//
//  Created by 남궁광 on 2022/03/02.
//

import UIKit
import Toast_Swift
import Alamofire

//스택을 일일이 함수로 나눌 필요가 없다고 생각함.
class SignUpViewController: UIViewController {
    var signUpLabel: UILabel?
    var essential: UILabel?
    
    var nickname: UILabel?
    var nicknameTextField: UITextField?
    var check_nicknameButton: UIButton?
    
    var password: UILabel?
    var passwordTextField: UITextField?
    
    var confirm_Password: UILabel?
    var confirm_PasswordTextField: UITextField?

    var name: UILabel?
    var nameTextField: UITextField?
    
    var phone_num: UILabel?
    var phone_numTextField : UITextField?
    
    var email: UILabel?
    var emailTextField: UITextField?
    var check_emailButton: UIButton?
    
    var cancelButton: UIButton?
    var completeButton: UIButton?
    
    func addpicture(){
        let signUpLabel: UILabel = {
            let asignUpLabel = UILabel()
            asignUpLabel.text = "회원가입"
            asignUpLabel.textColor = .black
            asignUpLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            asignUpLabel.clipsToBounds = true
            asignUpLabel.textAlignment = .center
            asignUpLabel.numberOfLines = 1
            asignUpLabel.translatesAutoresizingMaskIntoConstraints = false
            return asignUpLabel
        }()
        
        view.addSubview(signUpLabel)
        
        let essential: UILabel = {
            let aessential = UILabel()
            aessential.text = "필수사항"
            aessential.textColor = .black
            aessential.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            aessential.clipsToBounds = true
            aessential.textAlignment = .left
            aessential.numberOfLines = 1
            aessential.translatesAutoresizingMaskIntoConstraints = false
            return aessential
        }()
        
        view.addSubview(essential)
        
        //1번째 스택(아이디, 아이디 텍스트필드)
        let nickname: UILabel = {
            let anickname = UILabel()
            anickname.text = "닉네임"
            anickname.textColor = .black
            anickname.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            anickname.clipsToBounds = true
            anickname.textAlignment = .left
            anickname.numberOfLines = 1
            anickname.translatesAutoresizingMaskIntoConstraints = false
            return anickname
        }()
        
        view.addSubview(nickname)
        
        let nicknametextField: UITextField = {
            let anicknametextField = UITextField()
            anicknametextField.backgroundColor = .white
            anicknametextField.borderStyle = .roundedRect
            anicknametextField.autocapitalizationType = .none
            return anicknametextField
        }()
        view.addSubview(nicknametextField)
        nicknametextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        nicknametextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -80).isActive = true
        
        
        self.nicknameTextField = nicknametextField
        
        //닉네임 중복버튼 추가
        let check_nicknameButton: UIButton = {
            let acheck_nicknameButton = UIButton()
            acheck_nicknameButton.setTitle("중복확인", for: .normal)
            acheck_nicknameButton.titleLabel?.font = UIFont.systemFont(ofSize: 12,weight: .semibold)
            acheck_nicknameButton.addTarget(self, action: #selector(self.check_nickname(_:)), for: .touchUpInside)
            acheck_nicknameButton.setTitleColor(.systemBlue, for: .normal)
            return acheck_nicknameButton
        }()
        
        view.addSubview(check_nicknameButton)
        self.check_nicknameButton = check_nicknameButton
        
        let substackView: UIStackView = {
            let asubstackView = UIStackView()
            asubstackView.translatesAutoresizingMaskIntoConstraints = false
            asubstackView.axis = .horizontal
            asubstackView.alignment = .fill
            asubstackView.distribution = .fill
            asubstackView.spacing = 10
            return asubstackView
        }()
        view.addSubview(substackView)
        substackView.addArrangedSubview(nicknametextField)
        substackView.addArrangedSubview(check_nicknameButton)
        
        
        let stackView: UIStackView = {
            let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nickname)
        stackView.addArrangedSubview(substackView)
        
        //2번째 스택(비밀번호, 비밀번호 텍스트필드)
        let password: UILabel = {
            let apassword = UILabel()
            apassword.text = "비밀번호"
            apassword.textColor = .black
            apassword.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            apassword.clipsToBounds = true
            apassword.textAlignment = .left
            apassword.numberOfLines = 1
            apassword.translatesAutoresizingMaskIntoConstraints = false
            return apassword
        }()
        
        view.addSubview(password)
        
        let passwordtextField: UITextField = {
            let apasswordtextField = UITextField()
            apasswordtextField.backgroundColor = .white
            apasswordtextField.borderStyle = .roundedRect
            apasswordtextField.autocapitalizationType = .none
            apasswordtextField.isSecureTextEntry = true
            return apasswordtextField
        }()
        
        view.addSubview(passwordtextField)
        
        self.passwordTextField = passwordtextField
        
        let stackView_2: UIStackView = {
            let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_2)
        
        stackView_2.addArrangedSubview(password)
        stackView_2.addArrangedSubview(passwordtextField)
        
        
        //3번째 스택(비밀번호 확인,비밀번호 확인 텍스트필드)
        let confirm_Password: UILabel = {
            let aconfirm_Password = UILabel()
            aconfirm_Password.text = "비밀번호 확인"
            aconfirm_Password.textColor = .black
            aconfirm_Password.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            aconfirm_Password.clipsToBounds = true
            aconfirm_Password.textAlignment = .left
            aconfirm_Password.numberOfLines = 1
            aconfirm_Password.translatesAutoresizingMaskIntoConstraints = false
            return aconfirm_Password
        }()
        
        view.addSubview(confirm_Password)
        
        
        let confirm_PasswordtextField: UITextField = {
            let aconfirm_PasswordtextField = UITextField()
            aconfirm_PasswordtextField.backgroundColor = .white
            aconfirm_PasswordtextField.borderStyle = .roundedRect
            aconfirm_PasswordtextField.autocapitalizationType = .none
            aconfirm_PasswordtextField.isSecureTextEntry = true
            return aconfirm_PasswordtextField
        }()
        
        view.addSubview(confirm_PasswordtextField)
        
        self.confirm_PasswordTextField = confirm_PasswordtextField
        
        let stackView_3: UIStackView = {
            let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        
        view.addSubview(stackView_3)
        
        stackView_3.addArrangedSubview(confirm_Password)
        stackView_3.addArrangedSubview(confirm_PasswordtextField)
        
        //4번째 스택(이름, 이름 텍스트 필드)
        let name: UILabel = {
            let aname = UILabel()
            aname.text = "이름"
            aname.textColor = .black
            aname.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            aname.clipsToBounds = true
            aname.textAlignment = .left
            aname.numberOfLines = 1
            aname.translatesAutoresizingMaskIntoConstraints = false
            return aname
        }()
        
        view.addSubview(name)
        
        let nametextField: UITextField = {
            let anametextField = UITextField()
            anametextField.backgroundColor = .white
            anametextField.borderStyle = .roundedRect
            anametextField.autocapitalizationType = .none
            anametextField.autocorrectionType = .no
            return anametextField
        }()
        
        view.addSubview(nametextField)
        
        self.nameTextField = nametextField
        
        let stackView_4: UIStackView = {
            let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_4)
        
        stackView_4.addArrangedSubview(name)
        stackView_4.addArrangedSubview(nametextField)
        
        
        /*
        //5번째 스택(휴대폰 번호, 휴대폰번호 텍스트 필드)
        let phoneNum: UILabel = {
            let aphoneNum = UILabel()
            aphoneNum.text = "휴대전화 번호"
            aphoneNum.textColor = .white
            aphoneNum.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            aphoneNum.clipsToBounds = true
            aphoneNum.textAlignment = .left
            aphoneNum.numberOfLines = 1
            aphoneNum.translatesAutoresizingMaskIntoConstraints = false
            return aphoneNum
        }()
        
        view.addSubview(phoneNum)
        
        let phoneNumtextField: UITextField = {
            let aphoneNumtextField = UITextField()
            aphoneNumtextField.backgroundColor = .white
            aphoneNumtextField.autocapitalizationType = .none
            aphoneNumtextField.borderStyle = .roundedRect
            return aphoneNumtextField
        }()
        
        view.addSubview(phoneNumtextField)
        
        self.phone_numTextField = phoneNumtextField
        
        let stackView_5: UIStackView = {
            let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        
        view.addSubview(stackView_5)
        
        stackView_5.addArrangedSubview(phoneNum)
        stackView_5.addArrangedSubview(phoneNumtextField)
         */
        
        //6번째 스택(이메일, 이메일 텍스트 필드)
        let email: UILabel = {
            let aemail = UILabel()
            aemail.text = "이메일"
            aemail.textColor = .black
            aemail.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            aemail.clipsToBounds = true
            aemail.textAlignment = .left
            aemail.numberOfLines = 1
            aemail.translatesAutoresizingMaskIntoConstraints = false
            return aemail
        }()
        
        view.addSubview(email)
        
        let emailtextField: UITextField = {
            let aemailtextField = UITextField()
            aemailtextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
            aemailtextField.backgroundColor = .white
            aemailtextField.borderStyle = .roundedRect
            aemailtextField.autocapitalizationType = .none
            return aemailtextField
        }()
        
        view.addSubview(emailtextField)
        emailtextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        emailtextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -80).isActive = true
        
        
        self.emailTextField = emailtextField
        
        //버튼 추가(이메일 중복)
        let check_emailButton: UIButton = {
            let acheck_emailButton = UIButton()
            acheck_emailButton.setTitle("중복확인", for: .normal)
            acheck_emailButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 , weight: .semibold)
            acheck_emailButton.addTarget(self, action: #selector(self.check_email(_:)), for: .touchUpInside)
            acheck_emailButton.setTitleColor(.systemBlue, for: .normal)
            return acheck_emailButton
        }()
        
        view.addSubview(check_emailButton)
        self.check_emailButton = check_emailButton
        
        let substackView_2: UIStackView = {
            let asubstackView_2 = UIStackView()
            asubstackView_2.translatesAutoresizingMaskIntoConstraints = false
            asubstackView_2.axis = .horizontal
            asubstackView_2.alignment = .fill
            asubstackView_2.distribution = .fill
            asubstackView_2.spacing = 10
            return asubstackView_2
        }()
        
        view.addSubview(substackView_2)
        substackView_2.addArrangedSubview(emailtextField)
        substackView_2.addArrangedSubview(check_emailButton)
        
        
        let stackView_6: UIStackView = {
            let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        
        view.addSubview(stackView_6)
        
        stackView_6.addArrangedSubview(email)
        stackView_6.addArrangedSubview(substackView_2)
        
        
        //스택들 모아둔 총 스택
        let totalStack: UIStackView = {
            let atotalstackView = UIStackView()
            atotalstackView.translatesAutoresizingMaskIntoConstraints = false
            atotalstackView.axis = .vertical
            atotalstackView.alignment = .fill
            atotalstackView.distribution = .fill
            atotalstackView.spacing = 15
            return atotalstackView
        }()
        
        view.addSubview(totalStack)
        
        totalStack.addArrangedSubview(signUpLabel)
        totalStack.addArrangedSubview(essential)
        totalStack.addArrangedSubview(stackView)
        totalStack.addArrangedSubview(stackView_2)
        totalStack.addArrangedSubview(stackView_3)
        totalStack.addArrangedSubview(stackView_4)
        //totalStack.addArrangedSubview(stackView_5)
        totalStack.addArrangedSubview(stackView_6)
        
        
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        totalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalStack.topAnchor.constraint(equalTo: view.topAnchor,constant: 120).isActive = true
        totalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        totalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        totalStack.spacing = 5
        
        
        //7번째 스택 (취소버튼, 완료 버튼)
        let cancelButton: UIButton = {
            let acancelButton = UIButton()
            acancelButton.setTitle("취소", for: .normal)
            acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
            acancelButton.setTitleColor(.systemBlue, for: .normal)
            return acancelButton
        }()
        view.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        
        let completeButton: UIButton = {
            let acompleteButton = UIButton()
            acompleteButton.setTitle("완료", for: .normal)
            acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
            acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
            acompleteButton.setTitleColor(.systemBlue, for: .normal)
            return acompleteButton
        }()
        
        view.addSubview(completeButton)
        self.completeButton = completeButton
        let stackView_7: UIStackView = {
            let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .horizontal
            astackView.alignment = .fill
            astackView.distribution = .fillEqually
            astackView.spacing = 30
            return astackView
        }()
        
        view.addSubview(stackView_7)
        
        stackView_7.addArrangedSubview(cancelButton)
        stackView_7.addArrangedSubview(completeButton)
        stackView_7.translatesAutoresizingMaskIntoConstraints = false
        stackView_7.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView_7.topAnchor.constraint(equalTo: totalStack.bottomAnchor,constant: 24).isActive = true
        stackView_7.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        stackView_7.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        stackView_7.spacing = 30
    }
    

    
    func completeAction(){
        let email = emailTextField?.text
        let nickname = nicknameTextField?.text
        let password = passwordTextField?.text
        let confirmpassword = confirm_PasswordTextField?.text
        let name = nameTextField?.text
         
        if !isValidEmail(email!){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        
        if !isVaildPass(password!){
            //비밀번호 형식 실패
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        
        if password != confirmpassword{
            self.view.makeToast("비밀번호와 비밀번호 확인이 다릅니다.", duration: 1.0, position: .bottom)
            return
        }

        let URL = "http://3.37.123.140:8080/users/new-user"
        
        let param: Parameters = [
            "email" : email!,
            "nickname": nickname!,
            "password" : password!
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
                //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title: "다시시도 하세요!",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    //self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
            }
            
        }
    }
    

    
    
    func isValidEmail(_ email:String) ->Bool{
        //이메일 가능한지 확인
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHes %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    func isVaildPass(_ pass:String)->Bool{
        //비밀번호 가능한지 확인
        let passRefEx = "^[a-zA-Z0-9]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
        
    }
    
    //취소 버튼
    @objc func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)

    }
    
    //완료 버튼 -> 미완
    @objc func completeButton(_ sender: UIButton){
        completeAction()
    }
    
    @objc func check_email(_ sender: UIButton){
        //alamofire 이용하기(다시하기)
        
        let email = emailTextField?.text
        
        let param: Parameters = [
            "email" : email!
        ]
        
        if !isValidEmail(email!){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        let URL = "http://3.37.123.140:8080/users/checkEmail/\(String(email!))"
        
        

        
        let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "사용 가능한 이메일입니다!",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    //self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
                
            //통신실패
            case .failure(let error):
                    //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title:"이미 만들어진 계정이 있습니다.",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        //self.navigationController?.popViewController(animated: true)
                    })
                    
                    alert.addAction(confirm)
                    
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
                
         
        
    }
    
    @objc func check_nickname(_ sender: UIButton){
        //alamofire 이용하기(다시해야함.)
        let nickname = nicknameTextField?.text
        let param: Parameters = [
            "nickname" : nickname!
        ]
        
        
        let URL = "http://3.37.123.140:8080/users/checkNickname/\(String(nickname!))"

        
        
        let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
        //결과값으로 문자열을 받을 때 사용
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "사용가능한 닉네임입니다.!",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    //self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
                
            //통신실패
            case .failure(let error):
                //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title: "이미 존재하는 닉네임입니다.",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                    
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    //self.navigationController?.popViewController(animated: true)
                })
                    
                alert.addAction(confirm)
                    
                self.present(alert,animated: true,completion: nil)
            }
                
            }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "회원가입 Page"
        addpicture()
    }
    
}

