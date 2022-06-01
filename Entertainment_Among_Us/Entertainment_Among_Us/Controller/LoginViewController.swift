//
//  ViewController.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/05/30.
//

import UIKit
import Toast_Swift
import Alamofire
import SystemConfiguration
import SnapKit
import GoogleSignIn
struct Info_Token:Codable{
    let Token: String
    let profileId: String
    let userId: String
    let nickname: String
}

class LoginViewController: UIViewController{
    var e_mail: String = ""
    var pass_word: String = ""
    var mainPage = Lobby(id: 22, nickName: "김낙현")
    var URL: String = ""
    //var real_token: String = ""
    //Image, Game name
    private lazy var imageView: UIImageView = {
        let aimageView = UIImageView()
        aimageView.backgroundColor = .systemYellow
        aimageView.image = UIImage(systemName: "signature")
        aimageView.tintColor = .white
        //snapkit
        aimageView.snp.makeConstraints{(make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        return aimageView
    }()
    private lazy var game_name: UILabel = {
        let agame_name = UILabel()
        agame_name.text = "우리끼리 예능"
        agame_name.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        agame_name.clipsToBounds = true
        agame_name.textAlignment = .center
        agame_name.numberOfLines = 1
        agame_name.textColor = .black
        return agame_name
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    //email,password Label, email,password TextField
    private lazy var email: UILabel = {
        let aemail = UILabel()
         aemail.text = "이메일"
         aemail.textColor = .black
         aemail.font = UIFont.systemFont(ofSize: 18, weight: .bold)
         return aemail
    }()
    private lazy var emailTextField: UITextField = {
        let aemailtextField = UITextField()
        aemailtextField.backgroundColor = .white
        aemailtextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        aemailtextField.autocapitalizationType = .none
        aemailtextField.borderStyle = .roundedRect
        aemailtextField.placeholder = "이메일을 입력하세요"
        return aemailtextField
    }()
    private lazy var password: UILabel = {
        let apassword = UILabel()
        apassword.text = "비밀번호"
        apassword.textColor = .black
        apassword.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return apassword
    }()
    private lazy var passwordTextField: UITextField = {
        let apasswordtextField = UITextField()
        apasswordtextField.backgroundColor = .white
        apasswordtextField.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        apasswordtextField.borderStyle = .roundedRect
        apasswordtextField.autocapitalizationType = .none
        apasswordtextField.placeholder = "비밀번호를 입력하세요."
        apasswordtextField.isSecureTextEntry = true
        return apasswordtextField
    }()
    private lazy var stackView_2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    //SignInButton, SignUpButton
    private lazy var signInButton: UIButton = {
        let asignInButton = UIButton()
        asignInButton.setTitle("로그인", for: .normal)
        asignInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
        asignInButton.addTarget(self, action: #selector(self.signInButton(_:)), for: .touchUpInside)
        asignInButton.setTitleColor(.systemBlue, for: .normal)
        return asignInButton
    }()
    private lazy var signUpButton: UIButton = {
        let asignUpButton = UIButton()
        asignUpButton.setTitle("회원가입", for: .normal)
        asignUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        asignUpButton.addTarget(self, action: #selector(self.signUpButton(_:)), for: .touchUpInside)
        asignUpButton.setTitleColor(.systemBlue, for: .normal)
        return asignUpButton
    }()
    private lazy var stackView_3: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.alignment = .fill
         stackView.distribution = .fillEqually
         stackView.spacing = 30
         return stackView
    }()
    
    //Google Button
    private lazy var googleButton: UIButton = {
        let aGoogleButton = UIButton()
        aGoogleButton.setTitle("Google로 계속하기", for: .normal)
        aGoogleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        aGoogleButton.setImage(UIImage(named: "logo_google"), for: .normal)
        aGoogleButton.setTitleColor(.black, for: .normal)
        aGoogleButton.addTarget(self, action: #selector(self.touchGoogleButton(_:)), for: .touchUpInside)
        return aGoogleButton
    }()
    private lazy var appleButton: UIButton = {
        let aAppleButton = UIButton()
        aAppleButton.setTitle("Apple로 계속하기", for: .normal)
        aAppleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        aAppleButton.setImage(UIImage(named: "logo_apple"), for: .normal)
        aAppleButton.setTitleColor(.black, for: .normal)
        //aSignUpButton.addTarget(self, action: #selector(self.touchSignUpButton(_:)), for: .touchUpInside)
        return aAppleButton
    }()
    private lazy var stackView_4: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .vertical
         stackView.alignment = .center
         stackView.distribution = .fillEqually
         stackView.spacing = 30
         return stackView
    }()
    
    //forgetpassword
    private lazy var forgetpassword: UIButton = {
        let aforgetPassword = UIButton()
         aforgetPassword.setTitle("아이디 또는 비밀번호를 잊으셨나요?", for: .normal)
         aforgetPassword.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
         aforgetPassword.addTarget(self, action: #selector(self.forgetPasswordButton(_:)), for: .touchUpInside)
         aforgetPassword.setTitleColor(.systemRed, for: .normal)
         return aforgetPassword
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "회원가입 Page"
        setupLayout()
    }


}


//layout 정리
private extension LoginViewController{
    func setupLayout() {
        [
            imageView,
            game_name,
            stackView,
            email,
            emailTextField,
            password,
            passwordTextField,
            stackView_2,
            signInButton,
            signUpButton,
            stackView_3,
            googleButton,
            appleButton,
            stackView_4,
            forgetpassword
        ].forEach { view.addSubview($0) }
        
        //stack_1
        [
            imageView,
            game_name
        ].forEach {stackView.addArrangedSubview($0)}
        //stack_2
        [
            email,
            emailTextField,
            password,
            passwordTextField
        ].forEach {stackView_2.addArrangedSubview($0)}
        //stack_3
        [
            signInButton,
            signUpButton
        ].forEach {stackView_3.addArrangedSubview($0)}
        //stack_4
        [
            googleButton,
            appleButton
        ].forEach {stackView_4.addArrangedSubview($0)}
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView_2.translatesAutoresizingMaskIntoConstraints = false
        stackView_3.translatesAutoresizingMaskIntoConstraints = false
        stackView_4.translatesAutoresizingMaskIntoConstraints = false
        forgetpassword.translatesAutoresizingMaskIntoConstraints = false
        //snapkit 이용하여 autolayout 정리
        stackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(100)
        }
        
        stackView_2.snp.makeConstraints{
            $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        stackView_3.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView_2.snp.bottom).offset(10)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        stackView_4.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stackView_3.snp.bottom).offset(40)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        forgetpassword.snp.makeConstraints{
            $0.top.equalTo(stackView_4.snp.bottom).offset(30)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
    }
}


extension LoginViewController:GIDSignInDelegate{
    func signInAction(){
        self.e_mail = emailTextField.text ?? ""
        self.pass_word = passwordTextField.text ?? ""
        //self.mainPage = Lobby(id: 22, nickName: "김낙현")
        
        
        if !isValidEmail(self.e_mail){
            //email 형식 실패
            self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        if !isVaildPass(self.pass_word){
            //비밀번호 형식 실패(특수문자 안됨)
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        self.URL = "http://52.78.47.148:8080/users/login"
        
        let param: Parameters = [
            "email":self.e_mail,
            "password":self.pass_word
        ]
        let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode:200..<300)
        alamo.responseJSON() { response in
            switch response.result
            {
            //통신성공
            case .success(let token):
                //토큰 지속시간 30분
                let json = token as! [String:String]
                self.tokencheck(json["Token"]!)
                //토큰,프로필아이디,유저아이디,닉네임 파싱하기
                
                
                
            case .failure(let error):
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message:"\(String(describing: error.errorDescription))" ,preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler:nil)
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    
    
    func tokencheck(_ token: String){
        self.e_mail = emailTextField.text ?? ""
        
        
        self.URL = "http://52.78.47.148:8080/users/auth"
        /*
        var header = HTTPHeaders()
        header.add(name: "Authorization", value:token)
        */
        let param: Parameters = [
            "email": self.e_mail,
            "token": token
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode:200..<300)

        alamo.responseJSON() { response in
            switch response.result
            {
            //통신성공
            case .success(let info):
                let alert = UIAlertController(title: "로그인 성공!",message: "확인버튼을 누르시면 로그인됩니다!",preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    let json = info as! [String:String]
                    self.mainPage = Lobby(id: Int(json["userId"]!) ?? 0, nickName: json["nickname"]!)
                    self.navigationController?.pushViewController(self.mainPage, animated: true)
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
                print("success")
            case .failure(let error):
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message:"\(String(describing: error.errorDescription))" ,preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler:nil)
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
    
    //비밀번호 가능한지 확인
    func isVaildPass(_ pass:String)->Bool{
        let passRefEx = "^[a-zA-Z0-9._%+-]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
    }

    func sign(_ signIn:GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!){
        //error == nil -> 오류 없다는 뜻
        if error != nil{
            print(user.userID!)
        }else {
            //여기서 낙현이 한테 이메일 보내주면 낙현이가 ID만들겠다.
            self.google(user.profile.email!,user.profile.name!)
            
        }
    }
    
    func google(_ email:String,_ name:String)
    {
        self.URL = "http://52.78.47.148:8080/users/googleLogin"
        
        let param: Parameters = [
            "email":email,
            "nickname":name
        ]
        let alamo = AF.request(URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode:200..<300)
        alamo.responseJSON() { response in
            switch response.result
            {
            //통신성공
            case .success(let info):
                let alert = UIAlertController(title: "로그인 입니다!!!",message: "확인버튼을 누르시고 로그인을 하세요.",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    let json = info as! [String:String]
                    self.mainPage = Lobby(id: Int(json["userId"]!) ?? 0, nickName: json["nickname"]!)
                    self.navigationController?.pushViewController(self.mainPage, animated: true)
                })
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
                
                
                
            case .failure(let error):
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message:"\(String(describing: error.errorDescription))" ,preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler:nil)
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    //로그인 할 때 발생되는 것 -> objc은 오브젝트c와 연동하기위함이다.
    @objc func signInButton(_ sender: UIButton) {
        signInAction()
    }
    
    @objc func touchGoogleButton(_ sender: UIButton){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //회원가입 버튼
    @objc func signUpButton(_ sender: UIButton){
        let signUpView = SignUpViewContrller()
        self.navigationController?.pushViewController(signUpView, animated: true)
    }
    //비밀번호 찾기 버튼
    @objc func forgetPasswordButton(_ sender: UIButton){
        let forgetPasswordView = FindpasswordViewController()
        self.navigationController?.pushViewController(forgetPasswordView, animated: true)
    }
    
    
    
    
}
