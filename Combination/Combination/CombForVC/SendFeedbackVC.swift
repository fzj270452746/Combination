import UIKit

class SendFeedbackVC: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let feedbackTextView = UITextView()
    private let submitButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 设置渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemTeal.withAlphaComponent(0.1).cgColor,
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.backgroundColor = UIColor.systemBackground
        
        // 标题标签 - 美化
        titleLabel.text = "💬 Feedback"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.systemTeal
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 4
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 反馈文本输入框 - 美化
        feedbackTextView.font = UIFont.systemFont(ofSize: 16)
        feedbackTextView.layer.borderWidth = 2
        feedbackTextView.layer.borderColor = UIColor.systemTeal.cgColor
        feedbackTextView.layer.cornerRadius = 12
        feedbackTextView.backgroundColor = UIColor.systemBackground
        feedbackTextView.layer.shadowColor = UIColor.black.cgColor
        feedbackTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        feedbackTextView.layer.shadowOpacity = 0.1
        feedbackTextView.layer.shadowRadius = 4
        feedbackTextView.text = "Please enter your feedback here..."
        feedbackTextView.textColor = UIColor.systemGray
        feedbackTextView.delegate = self
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(feedbackTextView)
        
        // 提交按钮 - 美化
        submitButton.setTitle("📤 Submit Feedback", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = UIColor.systemTeal
        submitButton.layer.cornerRadius = 25
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        submitButton.layer.shadowOpacity = 0.3
        submitButton.layer.shadowRadius = 8
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        // 取消按钮 - 美化
        cancelButton.setTitle("❌ Cancel", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        cancelButton.backgroundColor = UIColor.systemGray6
        cancelButton.layer.cornerRadius = 20
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 标题标签
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 反馈文本输入框
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            // 提交按钮
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 取消按钮
            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 100),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Actions
    @objc private func submitButtonTapped() {
        let feedback = feedbackTextView.text ?? ""
        
        if feedback.isEmpty || feedback == "Please enter your feedback here..." {
            showAlert(title: "Error", message: "Please enter your feedback before submitting.")
            return
        }
        
        // 这里可以发送反馈到服务器或保存到本地
        print("Feedback submitted: \(feedback)")
        
        showAlert(title: "Success", message: "Thank you for your feedback!") { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension SendFeedbackVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter your feedback here..."
            textView.textColor = UIColor.systemGray
        }
    }
}
