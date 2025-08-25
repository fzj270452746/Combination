import UIKit

class YonghuFankuiVC: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let feedbackTextView = UITextView()
    private let submitButton = UIButton()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        backgroundImageView.image = UIImage(named: "combinationBack")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.layer.cornerRadius = 20
        overlayView.layer.borderWidth = 2
        overlayView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        titleLabel.text = "User Feedback"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(titleLabel)
        
        feedbackTextView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        feedbackTextView.textColor = .white
        feedbackTextView.font = UIFont.systemFont(ofSize: 16)
        feedbackTextView.layer.cornerRadius = 10
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        feedbackTextView.text = "Please share your thoughts about the game..."
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(feedbackTextView)
        
        submitButton.setTitle("Submit Feedback", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        submitButton.backgroundColor = UIColor.systemGreen
        submitButton.layer.cornerRadius = 15
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(submitButton)
        
        backButton.setTitle("Back to Menu", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        backButton.backgroundColor = UIColor.systemBlue
        backButton.layer.cornerRadius = 15
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(backButton)
        
        addGradientEffects()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.8),
            
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            feedbackTextView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.6),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            backButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            backButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.6),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addGradientEffects() {
        overlayView.layer.shadowColor = UIColor.black.cgColor
        overlayView.layer.shadowOffset = CGSize(width: 0, height: 4)
        overlayView.layer.shadowOpacity = 0.3
        overlayView.layer.shadowRadius = 8
        
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        submitButton.layer.shadowOpacity = 0.3
        submitButton.layer.shadowRadius = 4
        
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 0.3
        backButton.layer.shadowRadius = 4
    }
    
    @objc private func submitButtonTapped() {
        guard let feedback = feedbackTextView.text, !feedback.isEmpty else {
            showAlert(message: "Please enter your feedback before submitting.")
            return
        }
        
        // 这里应该发送反馈到服务器
        showAlert(message: "Thank you for your feedback! We appreciate your input.")
        feedbackTextView.text = "Please share your thoughts about the game..."
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            overlayView.frame.origin.y -= keyboardSize.height / 2
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        overlayView.frame.origin.y = 0
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Feedback", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
