//
//  ViewController.swift
//  Combination
//
//  Created by Zhao on 2025/8/23.
//

import UIKit

class CombinationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置视图背景色
        view.backgroundColor = UIColor.black
        
        // 添加背景图片
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "combinationBack")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        
        // 添加应用标题
        let titleLabel = UILabel()
        titleLabel.text = "Mahjong Combination"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.alpha = 0.0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        // 启动动画
        UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseInOut, animations: {
            titleLabel.alpha = 1.0
        }) { _ in
            // 动画完成后延迟1秒跳转到主菜单
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigateToMainMenu()
            }
        }
    }
    
    private func navigateToMainMenu() {
        let mainMenuVC = MainMenuVC()
        let navigationController = UINavigationController(rootViewController: mainMenuVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        // 使用淡入淡出转场
        navigationController.modalTransitionStyle = .crossDissolve
        
        present(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
