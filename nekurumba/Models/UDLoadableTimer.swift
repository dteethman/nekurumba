import UIKit

class UDLoadableTimer {
    public var defaultsKey: String = ""
    public var interval: TimeInterval = 7200
    public var currentTime: Box<TimeInterval> = Box(0)
    private var timer = Timer()
    private var isActive: Bool = false
    
    fileprivate func launchTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            currentTime.value += 1
            
            if currentTime.value >= interval {
                pause()
                if currentTime.value > interval { currentTime.value = interval }
            }
        })
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
            currentTime.value = interval
            pause()
            saveToDefaults()
        } else {
            if isActive {
                let deltaTime = Double(Int(curentDate - resignDate))
                if currentTime.value + deltaTime >= interval {
                    print("loaded \(resignDate), interval < delta, delta: \(deltaTime)")
                    currentTime.value = interval
                    pause()
                    saveToDefaults()
                } else {
                    print("loaded \(resignDate), interval > delta, delta: \(deltaTime)")
                    currentTime.value += deltaTime
                    resume()
                    saveToDefaults()
                }
            } else {
                print("loaded inactie")
                currentTime.value = interval
                pause()
                saveToDefaults()
            }
        }
        
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
        if currentTime.value < interval {
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
    
}
