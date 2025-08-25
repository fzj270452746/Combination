import UIKit

class ZhuMenuVC: UIViewController {
    
    // MARK: - Properties
    private let backgroundImageView = UIImageView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let comfortModeButton = UIButton()
    private let advancedModeButton = UIButton()
    private let howToPlayButton = UIButton()
    private let recordsButton = UIButton()
    private let feedbackButton = UIButton()
    private let rateButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        // 背景图片
        backgroundImageView.image = UIImage(named: "combinationBack")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // 蒙层
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.layer.cornerRadius = 25
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        // 标题
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(titleLabel)
        
        // 舒适模式按钮
        comfortModeButton.setTitle("Comfort Mode", for: .normal)
        comfortModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        comfortModeButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        comfortModeButton.layer.cornerRadius = 15
        comfortModeButton.layer.borderWidth = 3
        comfortModeButton.layer.borderColor = UIColor.white.cgColor
        comfortModeButton.addTarget(self, action: #selector(comfortModeTapped), for: .touchUpInside)
        comfortModeButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(comfortModeButton)
        
        // 进阶模式按钮
        advancedModeButton.setTitle("Advanced Mode", for: .normal)
        advancedModeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        advancedModeButton.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        advancedModeButton.layer.cornerRadius = 15
        advancedModeButton.layer.borderWidth = 3
        advancedModeButton.layer.borderColor = UIColor.white.cgColor
        advancedModeButton.addTarget(self, action: #selector(advancedModeTapped), for: .touchUpInside)
        advancedModeButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(advancedModeButton)
        
        // 游戏说明按钮
        howToPlayButton.setTitle("Introduce", for: .normal)
        howToPlayButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        howToPlayButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.8)
        howToPlayButton.layer.cornerRadius = 12
        howToPlayButton.layer.borderWidth = 2
        howToPlayButton.layer.borderColor = UIColor.white.cgColor
        howToPlayButton.addTarget(self, action: #selector(howToPlayTapped), for: .touchUpInside)
        howToPlayButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(howToPlayButton)
        
        // 游戏记录按钮
        recordsButton.setTitle("Game Records", for: .normal)
        recordsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        recordsButton.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        recordsButton.layer.cornerRadius = 12
        recordsButton.layer.borderWidth = 2
        recordsButton.layer.borderColor = UIColor.white.cgColor
        recordsButton.addTarget(self, action: #selector(recordsTapped), for: .touchUpInside)
        recordsButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(recordsButton)
        
        // 用户反馈按钮
        feedbackButton.setTitle("Feedback", for: .normal)
        feedbackButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        feedbackButton.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.8)
        feedbackButton.layer.cornerRadius = 12
        feedbackButton.layer.borderWidth = 2
        feedbackButton.layer.borderColor = UIColor.white.cgColor
        feedbackButton.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
        feedbackButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(feedbackButton)
        
        // 应用评分按钮
        rateButton.setTitle("Rate App", for: .normal)
        rateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        rateButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
        rateButton.layer.cornerRadius = 12
        rateButton.layer.borderWidth = 2
        rateButton.layer.borderColor = UIColor.white.cgColor
        rateButton.addTarget(self, action: #selector(rateTapped), for: .touchUpInside)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(rateButton)
        
        setupConstraints()
        setupButtonAnimations()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 背景图片
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 蒙层
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            
            // 标题
            titleLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            
            // 舒适模式按钮
            comfortModeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            comfortModeButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            comfortModeButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.7),
            comfortModeButton.heightAnchor.constraint(equalToConstant: 60),
            
            // 进阶模式按钮
            advancedModeButton.topAnchor.constraint(equalTo: comfortModeButton.bottomAnchor, constant: 30),
            advancedModeButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            advancedModeButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.7),
            advancedModeButton.heightAnchor.constraint(equalToConstant: 60),
            
            // 游戏说明按钮
            howToPlayButton.topAnchor.constraint(equalTo: advancedModeButton.bottomAnchor, constant: 40),
            howToPlayButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 30),
            howToPlayButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.4),
            howToPlayButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 游戏记录按钮
            recordsButton.topAnchor.constraint(equalTo: advancedModeButton.bottomAnchor, constant: 40),
            recordsButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -30),
            recordsButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.4),
            recordsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 用户反馈按钮
            feedbackButton.topAnchor.constraint(equalTo: howToPlayButton.bottomAnchor, constant: 20),
            feedbackButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 30),
            feedbackButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.4),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 应用评分按钮
            rateButton.topAnchor.constraint(equalTo: recordsButton.bottomAnchor, constant: 20),
            rateButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -30),
            rateButton.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.4),
            rateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButtonAnimations() {
        // 添加按钮悬停效果
        [comfortModeButton, advancedModeButton, howToPlayButton, recordsButton, feedbackButton, rateButton].forEach { button in
            button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
    }
    
    // MARK: - Button Actions
    @objc private func comfortModeTapped() {
        navigateToGame(mode: .comfort)
    }
    
    @objc private func advancedModeTapped() {
        navigateToGame(mode: .advanced)
    }
    
    @objc private func howToPlayTapped() {
        showHowToPlay()
    }
    
    @objc private func recordsTapped() {
        showGameRecords()
    }
    
    @objc private func feedbackTapped() {
        showFeedback()
    }
    
    @objc private func rateTapped() {
        showRateApp()
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    // MARK: - Navigation
    private func navigateToGame(mode: GameMode) {
        
        guard let navigationController = navigationController else {
            return
        }
        
        let gameVC = ZhuYouxiVC()
        gameVC.setGameMode(mode)
        
        // 使用标准的导航转场，避免应用卡住
        navigationController.pushViewController(gameVC, animated: true)
        
    }
    
    // MARK: - Modal Presentations
    private func showHowToPlay() {
        let alert = UIAlertController(title: "How to Play", message: """
            Game Objective:
            Select 3 or more consecutive Mahjong tiles of the same suit to score points!
            
            Gameplay:
            • Tap tiles from the top area to select them
            • Selected tiles appear in the bottom area
            • Form consecutive sequences (e.g., 1-2-3 Wan)
            • Longer sequences = higher scores!
            
            Scoring:
            • 3 tiles: 30 points
            • 4 tiles: 40 points
            • 5 tiles: 50 points
            
            Modes:
            • Comfort: Relaxed gameplay
            • Advanced: Faster pace, more challenge
            """, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Got it!", style: .default))
        present(alert, animated: true)
    }
    
    private func showGameRecords() {
        let recordsVC = RecordToComb()
        let navController = UINavigationController(rootViewController: recordsVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(navController, animated: true)
    }
    
    private func showFeedback() {
        let feedbackVC = SendFeedbackVC()
        feedbackVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(feedbackVC, animated: true)
    }
    
    private func showRateApp() {
        let ratingVC = RatingToCombVC()
        ratingVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(ratingVC, animated: true)
    }
}
