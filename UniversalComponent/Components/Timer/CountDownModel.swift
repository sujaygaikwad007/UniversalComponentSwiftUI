import Foundation
import Combine

class CountDownModel: ObservableObject {
    @Published var timerExpired = false
    @Published var timeStr = ""
    @Published var timeRemaining = 60
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {
        self.startTimer()
    }

    func startTimer() {
        timerExpired = false
        timeRemaining = 60
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.updateTimeString()
    }
    
    func stopTimer() {
        timerExpired = true
        self.timer.upstream.connect().cancel()
    }
    
    func updateTimeString() {
        timeStr = String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }
    
    func countDown() {
        guard timeRemaining > 0 else {
            self.stopTimer()
            timeStr = "00:00"
            timerExpired = true
            return
        }
        
        timeRemaining -= 1
        updateTimeString()
    }
}
