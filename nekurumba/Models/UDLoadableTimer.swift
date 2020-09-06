import UIKit
import DTBunchOfExt

class UDLoadableTimer {
    public var defaultsKey: String = ""
    public var interval: Box<TimeInterval> = Box(7200)
    public var currentTime: Box<TimeInterval> = Box(0)
    private var timer = Timer()
    private var isActive: Bool = false
    
    private func launchTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            self.currentTime.value += 1
            
            if self.currentTime.value >= self.interval.value {
                self.pause()
                if self.currentTime.value > self.interval.value { self.currentTime.value = self.interval.value }
            }
        })
    }
    
    private func resetTimer() {
        currentTime.value = 0
        timer.invalidate()
    }
    
    func start() {
        isActive = true
        resetTimer()
        launchTimer()
    }
    
    func pause() {
        isActive = false
        timer.invalidate()
    }
    
    func resume() {
        if currentTime.value < interval.value {
            pause()
            isActive = true
            launchTimer()
        }
    }
    
    func stop() {
        isActive = false
        resetTimer()
        timer.invalidate()
    }
    
    func saveToDefaults() {
        let defaults = UserDefaults.standard
        let resignDate = Double(NSDate().timeIntervalSince1970)
        
        defaults.set(resignDate, forKey: "resignTime_\(defaultsKey)")
        defaults.set(currentTime.value, forKey: "resignValue_\(defaultsKey)")
        defaults.set(isActive, forKey: "isActive_\(defaultsKey)")
    }
    
    func loadFromDefaults() {
        let defaults = UserDefaults.standard
        
        let resignDate = defaults.double(forKey: "resignTime_\(defaultsKey)")
        let resignValue = defaults.double(forKey: "resignValue_\(defaultsKey)")
        isActive = defaults.bool(forKey: "isActive_\(defaultsKey)")
        
        let curentDate = Double(NSDate().timeIntervalSince1970)
        
        if resignDate == 0  && resignValue == 0 {
            currentTime.value = interval.value
            pause()
            saveToDefaults()
        } else {
            if isActive {
                currentTime.value = resignValue
                let deltaTime = Double(Int(curentDate - resignDate))
                if currentTime.value + deltaTime >= interval.value {
                    currentTime.value = interval.value
                    pause()
                    saveToDefaults()
                } else {
                    currentTime.value += deltaTime
                    resume()
                    saveToDefaults()
                }
            } else {
                currentTime.value = interval.value
                pause()
                saveToDefaults()
            }
        }
        
    }
    
}
