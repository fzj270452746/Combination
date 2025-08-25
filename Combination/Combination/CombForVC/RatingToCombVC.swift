import UIKit

class RatingToCombVC: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let starStackView = UIStackView()
    private let submitButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    private var selectedRating: Int = 0
    private var starButtons: [UIButton] = []
    
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
            UIColor.systemYellow.withAlphaComponent(0.1).cgColor,
            UIColor.systemOrange.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.backgroundColor = UIColor.systemBackground
        
        // 标题标签 - 美化
        titleLabel.text = "⭐ Rate Our App"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.systemOrange
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 4
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 星星评分视图 - 美化
        starStackView.axis = .horizontal
        starStackView.distribution = .fillEqually
        starStackView.spacing = 20
        starStackView.backgroundColor = UIColor.systemBackground
        starStackView.layer.cornerRadius = 15
        starStackView.layer.shadowColor = UIColor.black.cgColor
        starStackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        starStackView.layer.shadowOpacity = 0.1
        starStackView.layer.shadowRadius = 8
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starStackView)
        
        // 创建5个星星按钮
        for i in 1...5 {
            let starButton = createStarButton(tag: i)
            starButtons.append(starButton)
            starStackView.addArrangedSubview(starButton)
        }
        
        // 提交按钮 - 美化
        submitButton.setTitle("🚀 Submit Rating", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        submitButton.backgroundColor = UIColor.systemOrange
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
    
    private func createStarButton(tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor.systemGray3
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置按钮大小
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 标题标签
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 星星评分视图
            starStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            starStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 提交按钮
            submitButton.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 40),
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
    @objc private func starButtonTapped(_ sender: UIButton) {
        let rating = sender.tag
        selectedRating = rating
        
        // 更新星星显示
        updateStarDisplay(rating: rating)
    }
    
    private func updateStarDisplay(rating: Int) {
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                button.tintColor = UIColor.systemYellow
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
                button.tintColor = UIColor.systemGray3
            }
        }
    }
    
    @objc private func submitButtonTapped() {
        if selectedRating == 0 {
            showAlert(title: "Error", message: "Please select a rating before submitting.")
            return
        }
        
        showAlert(title: "Thank You!", message: "Your rating has been submitted successfully!") { [weak self] in
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
