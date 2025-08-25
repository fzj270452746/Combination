import UIKit

class ZhuYouxiVC: UIViewController {
    
    // MARK: - Properties
    private let backgroundImageView = UIImageView()
    private let overlayView = UIView()
    private let topContainerView = UIView()
    private let bottomContainerView = UIView()
    private let scoreLabel = UILabel()
    private let timerLabel = UILabel()
    private let gameModeLabel = UILabel()
    private let backButton = UIButton(type: .custom)
    
    // 动态高度约束
    private var topContainerHeightConstraint: NSLayoutConstraint!
    
    private var mahjongCards: [MahjongCard] = []
    private var selectedCards: [MahjongCard] = []
    private var currentScore = 0
    private var gameTimer: Timer?
    private var gameTime: TimeInterval = 0
    private var gameMode: GameMode = .comfort
    private var gameRecordSaved: Bool = false  // 防止重复保存
    
    private var cardSize: CGFloat {
        // 根据设备类型动态调整基础卡片尺寸
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        return isIPad ? 60 : 50  // iPad上使用更大的卡片
    }
    
    private var cardSpacing: CGFloat {
        // 根据设备类型动态调整间距
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        return isIPad ? 8 : 6  // iPad上使用更大的间距
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 隐藏导航栏的返回按钮
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 在布局完成后设置游戏，确保约束已经生效
        if mahjongCards.isEmpty {
            setupGame()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // 处理设备旋转或尺寸变化
        coordinator.animate(alongsideTransition: { _ in
            // 在转换过程中更新布局
        }) { _ in
            // 转换完成后重新布局卡片
            if !self.mahjongCards.isEmpty {
                // 清除现有卡片视图
                self.topContainerView.subviews.forEach { $0.removeFromSuperview() }
                // 重新显示卡片
                self.displayMahjongCards()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGame()
        
        // 保存游戏记录（如果游戏时间大于5秒且还未保存）
        if gameTime > 5 && !gameRecordSaved {
            print("🚪 Leaving game, saving record...")
            saveGameRecord()
        }
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
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.layer.cornerRadius = 20
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        // 自定义返回按钮
        setupBackButton()
        
        // 顶部容器 - 麻将图片区域
        topContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        topContainerView.layer.cornerRadius = 15
        topContainerView.layer.borderWidth = 4
        topContainerView.layer.borderColor = UIColor.systemBlue.cgColor
        topContainerView.layer.shadowColor = UIColor.black.cgColor
        topContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        topContainerView.layer.shadowOpacity = 0.3
        topContainerView.layer.shadowRadius = 8
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(topContainerView)
        
        // 底部容器
        bottomContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        bottomContainerView.layer.cornerRadius = 15
        bottomContainerView.layer.borderWidth = 3
        bottomContainerView.layer.borderColor = UIColor.systemGreen.cgColor
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(bottomContainerView)
        
        // 分数标签
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        scoreLabel.layer.cornerRadius = 10
        scoreLabel.layer.masksToBounds = true
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(scoreLabel)
        
        // 计时器标签
        timerLabel.text = "Time: 0:00"
        timerLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.8)
        timerLabel.layer.cornerRadius = 10
        timerLabel.layer.masksToBounds = true
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(timerLabel)
        
        // 游戏模式标签
        gameModeLabel.text = "Comfort Mode"
        gameModeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        gameModeLabel.textColor = .white
        gameModeLabel.textAlignment = .center
        gameModeLabel.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.8)
        gameModeLabel.layer.cornerRadius = 10
        gameModeLabel.layer.masksToBounds = true
        gameModeLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(gameModeLabel)
        
        // 功能按钮
        setupFunctionButtons()
        
        setupConstraints()
    }
    
    private func setupBackButton() {
        // 设置返回按钮样式
        backButton.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        backButton.layer.cornerRadius = 25
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.white.cgColor
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backButton.layer.shadowOpacity = 0.3
        backButton.layer.shadowRadius = 4
        
        // 添加点击事件
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 设置按钮大小
        backButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(backButton)
        
        // 添加按钮约束
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupFunctionButtons() {
        // 游戏记录按钮
        let recordsButton = createFunctionButton(title: "Game Records", action: #selector(recordsButtonTapped))
        bottomContainerView.addSubview(recordsButton)
        
        // 反馈按钮
        let feedbackButton = createFunctionButton(title: "Feedback", action: #selector(feedbackButtonTapped))
        bottomContainerView.addSubview(feedbackButton)
        
        // 评价按钮
        let ratingButton = createFunctionButton(title: "Rate App", action: #selector(ratingButtonTapped))
        bottomContainerView.addSubview(ratingButton)
        
        // 设置按钮约束
        NSLayoutConstraint.activate([
            // 游戏记录按钮 - 左侧
            recordsButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            recordsButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            recordsButton.widthAnchor.constraint(equalToConstant: 120),
            recordsButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 反馈按钮 - 中间
            feedbackButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            feedbackButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            feedbackButton.widthAnchor.constraint(equalToConstant: 120),
            feedbackButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 评价按钮 - 右侧
            ratingButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),
            ratingButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            ratingButton.widthAnchor.constraint(equalToConstant: 120),
            ratingButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func createFunctionButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func recordsButtonTapped() {
        showGameRecords()
    }
    
    @objc private func feedbackButtonTapped() {
        showFeedbackView()
    }
    
    @objc private func ratingButtonTapped() {
        showRatingView()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 背景图片
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 蒙层
            overlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            overlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // 分数标签
            scoreLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 100),
            scoreLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -20),
            scoreLabel.widthAnchor.constraint(equalToConstant: 120),
            scoreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // 计时器标签
            timerLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 100),
            timerLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 20),
            timerLabel.widthAnchor.constraint(equalToConstant: 120),
            timerLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // 游戏模式标签 - 左侧
            gameModeLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 20),
           // gameModeLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            gameModeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameModeLabel.widthAnchor.constraint(equalToConstant: 150),
            gameModeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // 顶部容器 - 麻将图片区域
            topContainerView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 70),
            topContainerView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            topContainerView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
        ])
        
        // 创建动态高度约束
        topContainerHeightConstraint = topContainerView.heightAnchor.constraint(equalToConstant: 140)
        topContainerHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            bottomContainerView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -20),
            bottomContainerView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 20),
            bottomContainerView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -20),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // MARK: - Container Height Management
    private func updateContainerHeight(_ height: CGFloat) {
        let minHeight: CGFloat = 140  // 舒适模式的最小高度
        let maxHeight: CGFloat = 210  // 减小高级模式的最大高度，避免与手牌容器重叠
        let finalHeight = max(minHeight, min(maxHeight, height))
        
        topContainerHeightConstraint.constant = finalHeight
        
        // 动画更新布局
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Game Setup
    private func setupGame() {
        generateNewRound()
        updateGameModeLabel()
    }
    
    private func generateNewRound() {
        
        // 清除之前的麻将牌
        topContainerView.subviews.forEach { $0.removeFromSuperview() }
        bottomContainerView.subviews.forEach { $0.removeFromSuperview() }
        selectedCards.removeAll()
        
        mahjongCards = generateRandomCards()
    
        displayMahjongCards()
    }
    
    private func generateRandomCards() -> [MahjongCard] {

        var cards: [MahjongCard] = []
        let cardManager = MahjongDataManager.shared
        
        // 根据游戏模式确定牌数
        let targetCardCount = gameMode == .advanced ? 32 : 16
        
        // 确保有足够的连续牌组合
        let suits = MahjongSuit.allCases
        let numberOfStraights = gameMode == .advanced ? 4 : 2  // 高级模式生成更多顺子
        
        for _ in 0..<numberOfStraights {
            let selectedSuit = suits.randomElement()!
            let startNumber = Int.random(in: 1...7)
            
            for i in 0..<3 {
                if let card = cardManager.allCards.first(where: { $0.suit == selectedSuit && $0.number == startNumber + i }) {
                    if !cards.contains(where: { $0.imageName == card.imageName }) {
                        cards.append(card)
                    }
                }
            }
        }
        
        // 添加其他随机牌，确保达到目标数量
        var attempts = 0
        var usedCards: [String] = cards.map { $0.displayName }  // 使用displayName来避免重复
        
        while cards.count < targetCardCount && attempts < 200 {
            attempts += 1
            if let randomCard = cardManager.getRandomCard() {
                // 高级模式允许重复图片，但避免完全相同的displayName
                if gameMode == .advanced || !usedCards.contains(randomCard.displayName) {
                    cards.append(randomCard)
                    usedCards.append(randomCard.displayName)
                }
            }
        }
        
        if attempts >= 200 {
        }
        
        let shuffledCards = cards.shuffled()
        return shuffledCards
    }
    
    private func displayMahjongCards() {
        // 确保容器视图已经布局完成
        guard topContainerView.bounds.width > 0 else {
            // 延迟执行，等待布局完成
            DispatchQueue.main.async { [weak self] in
                self?.displayMahjongCards()
            }
            return
        }
        
        // 检测设备类型和兼容模式
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        let screenScale = UIScreen.main.scale
        let screenSize = UIScreen.main.bounds.size
        
        
        // 根据游戏模式和牌数动态计算布局
        let cardsPerRow = 8
        let expectedRows = gameMode == .advanced ? 4 : 2
        let rowSpacing: CGFloat = gameMode == .advanced ? 6 : 10  // 减小高级模式的行间距
        
        // 首先根据游戏模式动态调整容器高度
        let requiredHeight = CGFloat(expectedRows) * cardSize + CGFloat(expectedRows - 1) * rowSpacing + 30 // 减小额外的padding
        updateContainerHeight(requiredHeight)
        
        // 强制布局更新以获取新的容器尺寸
        view.layoutIfNeeded()
        
        // 计算可用宽度和高度（使用更新后的容器尺寸）
        let availableWidth = topContainerView.bounds.width - 30 // 左右各留15点边距，减小边距
        let availableHeight = topContainerView.bounds.height - 20 // 上下各留10点边距，减小边距
        
        // 动态计算卡片尺寸以适应不同模式和设备
        let maxCardWidth = (availableWidth - CGFloat(cardsPerRow - 1) * cardSpacing) / CGFloat(cardsPerRow)
        let maxCardHeight = (availableHeight - CGFloat(expectedRows - 1) * rowSpacing) / CGFloat(expectedRows)
        
        // 针对iPad兼容模式进行特殊处理
        var dynamicCardSize: CGFloat
        var adjustedSpacing: CGFloat
        
        if isIPad {
            // iPad上运行时，适当增大卡片尺寸以更好利用空间
            dynamicCardSize = min(maxCardWidth, maxCardHeight, cardSize * 1.2)
            adjustedSpacing = gameMode == .advanced ? max(4, cardSpacing) : cardSpacing * 1.2
        } else {
            // iPhone上保持原有逻辑
            dynamicCardSize = min(maxCardWidth, maxCardHeight, cardSize)
            adjustedSpacing = gameMode == .advanced ? max(2, cardSpacing - 2) : cardSpacing
        }
        
        
        // 最终调整以确保适应容器
        var finalCardSize = dynamicCardSize
        var finalSpacing = adjustedSpacing
        
        let totalRowWidth = CGFloat(cardsPerRow) * finalCardSize + CGFloat(cardsPerRow - 1) * finalSpacing
        if totalRowWidth > availableWidth {
            let excessWidth = totalRowWidth - availableWidth
            let totalSpacing = CGFloat(cardsPerRow - 1)
            let spacingReduction = excessWidth / totalSpacing
            finalSpacing = max(1, finalSpacing - spacingReduction)
            
            if finalSpacing <= 1 {
                let cardReduction = (excessWidth - (adjustedSpacing - 1) * totalSpacing) / CGFloat(cardsPerRow)
                finalCardSize = max(30, finalCardSize - cardReduction)
                finalSpacing = 1
            }
        }
        
        for (index, card) in mahjongCards.enumerated() {
            let cardView = createCardView(for: card)
            cardView.tag = index
            
            // 计算行和列位置
            let row = index / cardsPerRow
            let col = index % cardsPerRow
            
            // 使用最终调整后的尺寸和间距计算位置
            let finalRowWidth = CGFloat(cardsPerRow) * finalCardSize + CGFloat(cardsPerRow - 1) * finalSpacing
            let startX = (topContainerView.bounds.width - finalRowWidth) / 2
            let x = startX + CGFloat(col) * (finalCardSize + finalSpacing)
            
            // 计算垂直居中位置
            let totalHeight = CGFloat(expectedRows) * finalCardSize + CGFloat(expectedRows - 1) * rowSpacing
            let startY = (topContainerView.bounds.height - totalHeight) / 2
            let y = startY + CGFloat(row) * (finalCardSize + rowSpacing)
            
            cardView.frame = CGRect(
                x: x,
                y: y,
                width: finalCardSize,
                height: finalCardSize
            )
            topContainerView.addSubview(cardView)
        }
        
        print("✅ \(mahjongCards.count) cards displayed in \(gameMode) mode with size: \(finalCardSize), spacing: \(finalSpacing)")
    }
    
    private func createCardView(for card: MahjongCard) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.systemBlue.cgColor
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.shadowRadius = 4
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: card.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(imageView)
        
        // 如果图片加载失败，显示调试信息
        if imageView.image == nil {
            print("⚠️ Warning: Image '\(card.imageName)' not found for card: \(card.displayName)")
            
            // 添加文本标签作为回退显示
            let fallbackLabel = UILabel()
            fallbackLabel.text = card.displayName
            fallbackLabel.textAlignment = .center
            fallbackLabel.font = UIFont.systemFont(ofSize: 8, weight: .bold)
            fallbackLabel.textColor = .systemRed
            fallbackLabel.numberOfLines = 2
            fallbackLabel.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview(fallbackLabel)
            
            NSLayoutConstraint.activate([
                fallbackLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                fallbackLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
                fallbackLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: 2),
                fallbackLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -2)
            ])
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -4)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
        
        return cardView
    }
    
    // MARK: - Game Logic
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view else { return }
        let index = cardView.tag
        let card = mahjongCards[index]
        
        if let selectedIndex = selectedCards.firstIndex(where: { $0.imageName == card.imageName }) {
            // 取消选择
            selectedCards.remove(at: selectedIndex)
            cardView.layer.borderColor = UIColor.systemBlue.cgColor
            cardView.transform = .identity
            
            // 从底部容器中移除
            removeCardFromBottomContainer(card)
        } else {
            // 选择麻将牌
            selectedCards.append(card)
            cardView.layer.borderColor = UIColor.systemGreen.cgColor
            cardView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            // 添加到底部容器
            addCardToBottomContainer(card)
            
            // 根据游戏模式检查游戏结束条件
            let maxSelectedCards = gameMode == .advanced ? 8 : 5  // 高级模式允许更多选择
            if selectedCards.count > maxSelectedCards {
                gameOver()
                return
            }
            
            // 检查是否形成顺子
            if selectedCards.count >= 3 {
                checkForStraight()
            }
        }
        
        // 添加动画效果
        UIView.animate(withDuration: 0.2) {
            cardView.layoutIfNeeded()
        }
        
        // 延迟检查游戏状态，避免在顺子处理过程中重复检查
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let maxSelectedCards = self.gameMode == .advanced ? 8 : 5
            if self.selectedCards.count <= maxSelectedCards {
                self.checkForDeadlock()
            }
        }
    }
    
    // 检查是否出现死锁（仅在玩家操作后检查）
    private func checkForDeadlock() {
        // 只有在没有选中牌或选中牌无法形成顺子时才检查死锁
        if selectedCards.isEmpty || selectedCards.count < 3 {
            let cardManager = MahjongDataManager.shared
            if mahjongCards.count >= 3 && !cardManager.hasValidCombinations(mahjongCards) {
                print("🚫 Deadlock detected during gameplay, auto-refreshing...")
                autoRefreshCards()
            }
        }
    }
    
    private func addCardToBottomContainer(_ card: MahjongCard) {
        let cardView = createCardView(for: card)
        cardView.layer.borderColor = UIColor.systemGreen.cgColor
        
        let cardCount = bottomContainerView.subviews.count
        let x = CGFloat(cardCount) * (cardSize + cardSpacing) + 20
        let y = (bottomContainerView.bounds.height - cardSize) / 2
        
        cardView.frame = CGRect(x: x, y: y, width: cardSize, height: cardSize)
        bottomContainerView.addSubview(cardView)
        
        // 添加出现动画
        cardView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            cardView.transform = .identity
        })
    }
    
    private func removeCardFromBottomContainer(_ card: MahjongCard) {
        if let cardView = bottomContainerView.subviews.first(where: { $0.tag == mahjongCards.firstIndex(where: { $0.imageName == card.imageName }) }) {
            UIView.animate(withDuration: 0.2, animations: {
                cardView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                cardView.alpha = 0
            }) { _ in
                cardView.removeFromSuperview()
                self.rearrangeBottomContainerCards()
            }
        }
    }
    
    private func rearrangeBottomContainerCards() {
        let cardViews = bottomContainerView.subviews
        for (index, cardView) in cardViews.enumerated() {
            let x = CGFloat(index) * (cardSize + cardSpacing) + 20
            let y = (bottomContainerView.bounds.height - cardSize) / 2
            
            UIView.animate(withDuration: 0.3) {
                cardView.frame = CGRect(x: x, y: y, width: self.cardSize, height: self.cardSize)
            }
        }
    }
    
    private func checkForStraight() {
        let cardManager = MahjongDataManager.shared
        
        // 检查所有可能的连续组合
        for i in 0..<selectedCards.count-2 {
            for j in i+1..<selectedCards.count-1 {
                for k in j+1..<selectedCards.count {
                    let threeCards = [selectedCards[i], selectedCards[j], selectedCards[k]]
                    if cardManager.checkStraight(threeCards) {
                        handleStraight(threeCards)
                        return
                    }
                }
            }
        }
    }
    
    private func handleStraight(_ cards: [MahjongCard]) {
        let score = MahjongDataManager.shared.calculateScore(for: cards)
        currentScore += score
        
        // 更新分数显示
        scoreLabel.text = "Score: \(currentScore)"
        
        // 添加分数动画
        let scoreAnimationLabel = UILabel()
        scoreAnimationLabel.text = "+\(score)"
        scoreAnimationLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        scoreAnimationLabel.textColor = .systemGreen
        scoreAnimationLabel.textAlignment = .center
        scoreAnimationLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(scoreAnimationLabel)
        
        scoreAnimationLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        scoreAnimationLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        
        // 分数动画
        UIView.animate(withDuration: 1.0, animations: {
            scoreAnimationLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            scoreAnimationLabel.alpha = 0
        }) { _ in
            scoreAnimationLabel.removeFromSuperview()
        }
        
        // 移除选中的麻将牌
        for card in cards {
            if let index = selectedCards.firstIndex(where: { $0.imageName == card.imageName }) {
                selectedCards.remove(at: index)
            }
            if let mahjongIndex = mahjongCards.firstIndex(where: { $0.imageName == card.imageName }) {
                mahjongCards.remove(at: mahjongIndex)
            }
        }
        
        // 清除底部容器
        bottomContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        // 重新排列顶部麻将牌
        topContainerView.subviews.forEach { $0.removeFromSuperview() }
        displayMahjongCards()
        
        // 检查游戏状态
        checkGameState()
    }
    
    // 检查游戏状态：死锁检测和自动刷新
    private func checkGameState() {
        print("🔍 Checking game state...")
        print("   Remaining cards: \(mahjongCards.count)")
        print("   Selected cards: \(selectedCards.count)")
        
        // 如果剩余牌数少于3张，结束回合
        if mahjongCards.count < 3 {
            print("📋 Not enough cards left, ending round...")
            endRound()
            return
        }
        
        // 检查是否存在可能的顺子组合
        let cardManager = MahjongDataManager.shared
        if !cardManager.hasValidCombinations(mahjongCards) {
            print("🚫 No valid combinations possible, auto-refreshing cards...")
            autoRefreshCards()
        } else {
            print("✅ Valid combinations still possible, continuing game...")
        }
    }
    
    // 自动刷新牌组
    private func autoRefreshCards() {
        print("🔄 Auto-refreshing card deck...")
        
        // 显示提示信息
        showAutoRefreshAlert {
            // 清除当前选择
            self.selectedCards.removeAll()
            self.bottomContainerView.subviews.forEach { $0.removeFromSuperview() }
            
            // 生成新的牌组
            self.generateNewRound()
            
            print("✅ Card deck auto-refreshed successfully")
        }
    }
    
    // 显示自动刷新提示
    private func showAutoRefreshAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "🔄 Auto Refresh", 
            message: "No more valid combinations possible!\nGenerating new cards to continue the game...", 
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default) { _ in
            completion()
        })
        
        present(alert, animated: true)
    }
    
    private func endRound() {
        // 保存游戏记录
        saveGameRecord()
        
        // 显示回合结束对话框
        let alert = UIAlertController(title: "Round Complete!", message: "Your score: \(currentScore)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next Round", style: .default) { _ in
            // 重置保存标志，开始新一轮
            self.gameRecordSaved = false
            self.generateNewRound()
        })
        alert.addAction(UIAlertAction(title: "Main Menu", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func gameOver() {
        // 停止游戏
        stopGame()
        
        // 保存游戏记录
        saveGameRecord()
        
        // 显示游戏结束对话框
        let alert = UIAlertController(
            title: "Game Over", 
            message: "You have selected more than 5 mahjong tiles, the game is over!\nFinal score: \(currentScore)", 
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
            // 重置游戏状态
            self.currentScore = 0
            self.gameTime = 0
            self.selectedCards.removeAll()
            self.gameRecordSaved = false  // 重置保存标志
            self.updateTimerDisplay()
            self.scoreLabel.text = "Score: 0"
            
            // 开始新的一轮
            self.generateNewRound()
            self.startGame()
        })
        
        alert.addAction(UIAlertAction(title: "Back to Main Menu", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Game Control
    private func startGame() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.gameTime += 1
            self.updateTimerDisplay()
        }
    }
    
    private func stopGame() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func updateTimerDisplay() {
        let minutes = Int(gameTime) / 60
        let seconds = Int(gameTime) % 60
        timerLabel.text = String(format: "Time: %d:%02d", minutes, seconds)
    }
    
    private func updateGameModeLabel() {
        switch gameMode {
        case .comfort:
            gameModeLabel.text = "Comfort Mode"
        case .advanced:
            gameModeLabel.text = "Advanced Mode"
        }
    }
    
    // MARK: - Game Record
    private func saveGameRecord() {
        // 防止重复保存
        guard !gameRecordSaved else { 
            print("⚠️ Game record already saved, skipping...")
            return 
        }
        
        print("💾 Saving game record...")
        print("   Score: \(currentScore)")
        print("   Mode: \(gameMode)")
        print("   Duration: \(gameTime)")
        
        let record = GameRecord(
            date: Date(),
            score: currentScore,
            mode: gameMode,
            duration: gameTime
        )
        
        // 保存到本地存储
        GameRecordManager.shared.saveRecord(record)
        gameRecordSaved = true
        print("✅ Game record saved successfully: \(record)")
        
        // 验证保存是否成功
        let allRecords = GameRecordManager.shared.getAllRecords()
        print("📊 Total records after save: \(allRecords.count)")
    }
    
    // MARK: - Feedback & Rating
    private func showFeedbackView() {
        let feedbackVC = SendFeedbackVC()
        feedbackVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(feedbackVC, animated: true)
    }
    
    private func showRatingView() {
        let ratingVC = RatingToCombVC()
        ratingVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(ratingVC, animated: true)
    }
    
    private func showGameRecords() {
        let recordsVC = RecordToComb()
        let navController = UINavigationController(rootViewController: recordsVC)
        navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(navController, animated: true)
    }
    
    // MARK: - Public Methods
    func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
        updateGameModeLabel()
    }
}

