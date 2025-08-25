//
//  CombinationModel.swift
//  Combination
//
//  Created by Zhao on 2025/8/23.
//

import Foundation
import UIKit

// 麻将牌模型
struct MahjongCard {
    let imageName: String
    let suit: MahjongSuit
    let number: Int
    let displayName: String
}

// 麻将花色枚举
enum MahjongSuit: String, CaseIterable {
    case wan = "Wan"      // 万子
    case tiao = "Tiao"    // 条子
    case tong = "Tong"    // 筒子
    
    var displayName: String {
        switch self {
        case .wan: return "Wan"
        case .tiao: return "Tiao"
        case .tong: return "Tong"
        }
    }
}

// 游戏模式
enum GameMode: Codable {
    case comfort    // 舒适模式
    case advanced  // 进阶模式
}

// 游戏记录
struct GameRecord: Codable {
    let date: Date
    let score: Int
    let mode: GameMode
    let duration: TimeInterval
}

// 麻将牌数据
class MahjongDataManager {
    static let shared = MahjongDataManager()
    
    // 所有可用的麻将牌
    var allCards: [MahjongCard] = []
    
    private init() {
        setupCards()
    }
    
    private func setupCards() {
        allCards = []
        
        // 万子 1-9
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_53_m", suit: .wan, number: 1, displayName: "1 Wan"),
            MahjongCard(imageName: "uu7_55_m", suit: .wan, number: 2, displayName: "2 Wan"),
            MahjongCard(imageName: "uu7_57_m", suit: .wan, number: 3, displayName: "3 Wan"),
            MahjongCard(imageName: "uu7_59_m", suit: .wan, number: 4, displayName: "4 Wan"),
            MahjongCard(imageName: "uu7_83_m", suit: .wan, number: 5, displayName: "5 Wan"),
            MahjongCard(imageName: "uu7_85_m", suit: .wan, number: 6, displayName: "6 Wan"),
            MahjongCard(imageName: "uu7_87_m", suit: .wan, number: 7, displayName: "7 Wan"),
            MahjongCard(imageName: "uu7_89_m", suit: .wan, number: 8, displayName: "8 Wan"),
            MahjongCard(imageName: "uu7_113_m", suit: .wan, number: 9, displayName: "9 Wan")
        ])
        
        // 为高级模式添加额外的万子牌（重复使用相同图片）
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_53_m", suit: .wan, number: 1, displayName: "1 Wan (2)"),
            MahjongCard(imageName: "uu7_55_m", suit: .wan, number: 2, displayName: "2 Wan (2)"),
            MahjongCard(imageName: "uu7_57_m", suit: .wan, number: 3, displayName: "3 Wan (2)"),
            MahjongCard(imageName: "uu7_59_m", suit: .wan, number: 4, displayName: "4 Wan (2)"),
            MahjongCard(imageName: "uu7_83_m", suit: .wan, number: 5, displayName: "5 Wan (2)"),
            MahjongCard(imageName: "uu7_85_m", suit: .wan, number: 6, displayName: "6 Wan (2)"),
            MahjongCard(imageName: "uu7_87_m", suit: .wan, number: 7, displayName: "7 Wan (2)"),
            MahjongCard(imageName: "uu7_89_m", suit: .wan, number: 8, displayName: "8 Wan (2)"),
            MahjongCard(imageName: "uu7_113_m", suit: .wan, number: 9, displayName: "9 Wan (2)")
        ])
        
        // 条子 1,3-9 (跳过2) - 为高级模式添加重复牌
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_81_m", suit: .tiao, number: 1, displayName: "1 Tiao"),
            MahjongCard(imageName: "uu7_107_m", suit: .tiao, number: 3, displayName: "3 Tiao"),
            MahjongCard(imageName: "uu7_109_m", suit: .tiao, number: 4, displayName: "4 Tiao"),
            MahjongCard(imageName: "uu7_111_m", suit: .tiao, number: 5, displayName: "5 Tiao"),
            MahjongCard(imageName: "uu7_137_m", suit: .tiao, number: 6, displayName: "6 Tiao"),
            MahjongCard(imageName: "uu7_139_m", suit: .tiao, number: 7, displayName: "7 Tiao"),
            MahjongCard(imageName: "uu7_141_m", suit: .tiao, number: 8, displayName: "8 Tiao"),
            MahjongCard(imageName: "uu7_115_m", suit: .tiao, number: 9, displayName: "9 Tiao")
        ])
        
        // 为高级模式添加额外的条子牌（重复使用相同图片）
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_81_m", suit: .tiao, number: 1, displayName: "1 Tiao (2)"),
            MahjongCard(imageName: "uu7_107_m", suit: .tiao, number: 3, displayName: "3 Tiao (2)"),
            MahjongCard(imageName: "uu7_109_m", suit: .tiao, number: 4, displayName: "4 Tiao (2)"),
            MahjongCard(imageName: "uu7_111_m", suit: .tiao, number: 5, displayName: "5 Tiao (2)"),
            MahjongCard(imageName: "uu7_137_m", suit: .tiao, number: 6, displayName: "6 Tiao (2)"),
            MahjongCard(imageName: "uu7_139_m", suit: .tiao, number: 7, displayName: "7 Tiao (2)"),
            MahjongCard(imageName: "uu7_141_m", suit: .tiao, number: 8, displayName: "8 Tiao (2)"),
            MahjongCard(imageName: "uu7_115_m", suit: .tiao, number: 9, displayName: "9 Tiao (2)")
        ])
        
        // 筒子 1,3-9 (跳过2)
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_17_m", suit: .tong, number: 1, displayName: "1 Tong"),
            MahjongCard(imageName: "uu7_19_m", suit: .tong, number: 3, displayName: "3 Tong"),
            MahjongCard(imageName: "uu7_21_m", suit: .tong, number: 4, displayName: "4 Tong"),
            MahjongCard(imageName: "uu7_47_m", suit: .tong, number: 5, displayName: "5 Tong"),
            MahjongCard(imageName: "uu7_49_m", suit: .tong, number: 6, displayName: "6 Tong"),
            MahjongCard(imageName: "uu7_51_m", suit: .tong, number: 7, displayName: "7 Tong"),
            MahjongCard(imageName: "uu7_77_m", suit: .tong, number: 8, displayName: "8 Tong"),
            MahjongCard(imageName: "uu7_79_m", suit: .tong, number: 9, displayName: "9 Tong")
        ])
        
        // 为高级模式添加额外的筒子牌（重复使用相同图片）
        allCards.append(contentsOf: [
            MahjongCard(imageName: "uu7_17_m", suit: .tong, number: 1, displayName: "1 Tong (2)"),
            MahjongCard(imageName: "uu7_19_m", suit: .tong, number: 3, displayName: "3 Tong (2)"),
            MahjongCard(imageName: "uu7_21_m", suit: .tong, number: 4, displayName: "4 Tong (2)"),
            MahjongCard(imageName: "uu7_47_m", suit: .tong, number: 5, displayName: "5 Tong (2)"),
            MahjongCard(imageName: "uu7_49_m", suit: .tong, number: 6, displayName: "6 Tong (2)"),
            MahjongCard(imageName: "uu7_51_m", suit: .tong, number: 7, displayName: "7 Tong (2)"),
            MahjongCard(imageName: "uu7_77_m", suit: .tong, number: 8, displayName: "8 Tong (2)"),
            MahjongCard(imageName: "uu7_79_m", suit: .tong, number: 9, displayName: "9 Tong (2)")
        ])
        
        print("🎴 MahjongDataManager initialized with \(allCards.count) cards")
    }
    
    // 获取随机麻将牌
    func getRandomCard() -> MahjongCard? {
        return allCards.randomElement()
    }
    
    // 检查是否形成顺子
    func checkStraight(_ cards: [MahjongCard]) -> Bool {
        guard cards.count == 3 else { return false }
        
        let sortedCards = cards.sorted { $0.number < $1.number }
        let firstCard = sortedCards[0]
        
        // 检查是否同花色且连续
        return sortedCards.allSatisfy { $0.suit == firstCard.suit } &&
               sortedCards[1].number == firstCard.number + 1 &&
               sortedCards[2].number == firstCard.number + 2
    }
    
    // 计算顺子分数
    func calculateScore(for cards: [MahjongCard]) -> Int {
        if checkStraight(cards) {
            return cards.count * 10
        }
        return 0
    }
    
    // 检查是否存在可能的顺子组合
    func hasValidCombinations(_ cards: [MahjongCard]) -> Bool {
        guard cards.count >= 3 else { return false }
        
        // 检查所有可能的3张牌组合
        for i in 0..<cards.count-2 {
            for j in i+1..<cards.count-1 {
                for k in j+1..<cards.count {
                    let threeCards = [cards[i], cards[j], cards[k]]
                    if checkStraight(threeCards) {
                        return true
                    }
                }
            }
        }
        return false
    }
}

// MARK: - Game Record Manager
class GameRecordManager {
    static let shared = GameRecordManager()
    
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "GameRecords"
    
    private init() {}
    
    // 保存游戏记录
    func saveRecord(_ record: GameRecord) {
        var records = getAllRecords()
        records.append(record)
        
        // 只保留最近50条记录
        if records.count > 50 {
            records = Array(records.suffix(50))
        }
        
        if let data = try? JSONEncoder().encode(records) {
            userDefaults.set(data, forKey: recordsKey)
        }
    }
    
    // 获取所有游戏记录
    func getAllRecords() -> [GameRecord] {
        guard let data = userDefaults.data(forKey: recordsKey),
              let records = try? JSONDecoder().decode([GameRecord].self, from: data) else {
            return []
        }
        return records.sorted { $0.date > $1.date } // 按日期降序排列
    }
    
    // 清除所有记录
    func clearAllRecords() {
        userDefaults.removeObject(forKey: recordsKey)
    }
}



