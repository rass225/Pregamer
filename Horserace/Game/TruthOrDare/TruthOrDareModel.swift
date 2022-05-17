import Foundation
import SwiftUI

class TruthOrDareModel: ObservableObject {
    
    enum GameStatus {
        case notStarted
        case truthOrDare
        case activity
    }
    
    enum TruthOrDare {
        case truth
        case dare
    }
    
    let players: [String]
    
    @Published var status: GameStatus = .notStarted
    @Published var truthOrDare: TruthOrDare = .truth
    @Published var currentPlayer: Int = 10
    @Published var label: String = ""
    @Published var title: String = ""
    
    private var currentTruthIndex: Int = 0
    private var currentDareIndex: Int = 0
    private var testTruth: [String] = [
        "Do you like basketball?",
        "Do you like cheese?",
        "Do you like milk?",
        "Have you peed your pants?"
    ]
    private var testDare: [String] = [
        "Fart in the fan",
        "Drink water",
        "Eat eggs",
        "Stand up on your arms and chug a beer upside down",
        "Slap someone in the face"
    ]
    
    
    init(players: [String]) {
        self.players = players
        titleHandler()
    }
    
    func restart() {
        currentPlayer = 10
        status = .notStarted
        self.testDare.shuffle()
        self.testTruth.shuffle()
    }
    
    func incrementPlayer() {
        if currentPlayer == 10 {
            currentPlayer = 0
            return
        }
        if currentPlayer == players.count - 1 {
            currentPlayer = 0
        } else {
            currentPlayer += 1
        }
    }
    
    func truthHandler() {
        status = .activity
        truthOrDare = .truth
        
        if currentTruthIndex == testTruth.count - 1 {
            currentTruthIndex = 0
        } else {
            currentTruthIndex += 1
        }
        label = testTruth[currentTruthIndex]
    }
    
    func dareHandler() {
        status = .activity
        truthOrDare = .dare
        if currentDareIndex == testDare.count - 1 {
            currentDareIndex = 0
        } else {
            currentDareIndex += 1
        }
        label = testDare[currentDareIndex]
    }
    
    func titleHandler() {
        switch status {
        case .notStarted:
            title = "Are you ready?"
        case .truthOrDare:
            title = "Choose"
        case .activity:
            switch truthOrDare {
            case .truth:
                title = "Truth"
            case .dare:
                title = "Dare"
            }
            
        }
    }
}
