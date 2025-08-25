import UIKit

class RecordToComb: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let clearButton = UIButton(type: .system)
    
    private var gameRecords: [GameRecord] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadGameRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次显示页面时重新加载数据
        loadGameRecords()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 设置渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.1).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.backgroundColor = UIColor.systemBackground
        title = "Game Records"
        
        // 导航栏设置
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        // 标题标签 - 美化
        titleLabel.text = "🏆 Game Records"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.systemBlue
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 4
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 清除按钮 - 美化
        clearButton.setTitle("🗑️ Clear All", for: .normal)
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        clearButton.backgroundColor = UIColor.systemRed
        clearButton.layer.cornerRadius = 20
        clearButton.layer.shadowColor = UIColor.black.cgColor
        clearButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        clearButton.layer.shadowOpacity = 0.3
        clearButton.layer.shadowRadius = 4
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)
        
        // 表格视图 - 美化
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameRecordCell.self, forCellReuseIdentifier: "GameRecordCell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 标题标签
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 清除按钮
            clearButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 表格视图
            tableView.topAnchor.constraint(equalTo: clearButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Data Loading
    private func loadGameRecords() {
        print("🔄 Loading game records...")
        gameRecords = GameRecordManager.shared.getAllRecords()
        print("📊 Loaded \(gameRecords.count) game records")
        
        // 打印所有记录用于调试
        for (index, record) in gameRecords.enumerated() {
            print("   Record \(index + 1): Score=\(record.score), Mode=\(record.mode), Duration=\(record.duration)")
        }
        
        tableView.reloadData()
        
        if gameRecords.isEmpty {
            showEmptyState()
        }
    }
    
    private func showEmptyState() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No game records yet.\n\nTo get real game records:\n1. Play Comfort Mode or Advanced Mode\n2. Form consecutive sequences (3+ tiles)\n3. Complete rounds or games\n4. Return to main menu\n\nYour scores will be saved automatically!"
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = UIColor.systemGray
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func clearButtonTapped() {
        let alert = UIAlertController(
            title: "Clear All Records",
            message: "Are you sure you want to clear all game records? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear All", style: .destructive) { [weak self] _ in
            GameRecordManager.shared.clearAllRecords()
            self?.gameRecords.removeAll()
            self?.tableView.reloadData()
            self?.showEmptyState()
            print("🗑️ All game records cleared")
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RecordToComb: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameRecordCell", for: indexPath) as! GameRecordCell
        let record = gameRecords[indexPath.row]
        cell.configure(with: record)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RecordToComb: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Game Record Cell
class GameRecordCell: UITableViewCell {
    
    private let scoreLabel = UILabel()
    private let modeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 设置单元格背景
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowRadius = 4
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundView)
        
        // 分数标签 - 美化
        scoreLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        scoreLabel.textColor = UIColor.systemBlue
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(scoreLabel)
        
        // 游戏模式标签 - 美化
        modeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        modeLabel.textColor = UIColor.white
        modeLabel.backgroundColor = UIColor.systemPurple
        modeLabel.layer.cornerRadius = 12
        modeLabel.layer.masksToBounds = true
        modeLabel.textAlignment = .center
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(modeLabel)
        
        NSLayoutConstraint.activate([
            // 背景视图
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // 分数标签 - 居中显示
            scoreLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            
            // 游戏模式标签 - 右侧显示
            modeLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            modeLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            modeLabel.widthAnchor.constraint(equalToConstant: 140),
            modeLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with record: GameRecord) {
        // 分数 - 英文显示
        scoreLabel.text = "Score: \(record.score)"
        
        // 游戏模式 - 英文显示
        let modeText = record.mode == .comfort ? "Comfort Mode" : "Advanced Mode"
        modeLabel.text = modeText
        
        print("🎯 Configured cell - Score: \(record.score), Mode: \(modeText)")
    }
}
