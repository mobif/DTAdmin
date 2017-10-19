import UIKit

class LoginViewController: UIViewController {



    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topTitleLabel.text = "DTAdmin"
        self.loginTextField.placeholder = "login"
        self.passwordTextField.placeholder = "password"
        self.passwordTextField.isSecureTextEntry = true
        self.loginButton.setTitle("Login", for: .normal)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func tapSignIn() {
        let loginNameText = "admin"
        let passwordText = "dtapi_admin"
        let login = RequestManager<UserStructure>()
        login.getLoginData(for: loginNameText, password: passwordText, returnResults: {
            (user, cookie, error) in
            if error != nil {
                print(error)
                return
            }
            guard let studentViewController = UIStoryboard(name: "Student", bundle: nil).instantiateViewController(withIdentifier: "StudentViewController") as? StudentViewController else {
                print("ViewController with id: students not found")
                    return
            }
            let navigationController = UINavigationController(rootViewController: studentViewController)
            self.present(navigationController, animated: true, completion: nil)
        })
    }
}
