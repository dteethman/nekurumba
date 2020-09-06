import UIKit

public enum TapticProviderState {
    case notificationSuccess
    case notificationWarning
    case notoficationError
    case touchLight
    case touchMedium
    case touchHeavy
    case seletionChanged
    
}

public class TapticProvider2 {
    static public let entry = TapticProvider2()
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let impactLightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let impactMediumGenerator = UIImpactFeedbackGenerator(style: .light)
    private let impactHeavyGenerator = UIImpactFeedbackGenerator(style: .light)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private func prepare() {
        notificationGenerator.prepare()
        impactLightGenerator.prepare()
        impactMediumGenerator.prepare()
        impactHeavyGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    init() {
        prepare()
    }
    
    public func provide(_ state: TapticProviderState) {
        if #available(iOS 10.0, *) {
            switch state {
            case .notificationSuccess:
                notificationGenerator.notificationOccurred(.success)
            case .notificationWarning:
                notificationGenerator.notificationOccurred(.warning)
            case .notoficationError:
                notificationGenerator.notificationOccurred(.error)
            case .touchLight:
                impactLightGenerator.impactOccurred()
            case .touchMedium:
                impactMediumGenerator.impactOccurred()
            case .touchHeavy:
                impactHeavyGenerator.impactOccurred()
            case .seletionChanged:
                selectionGenerator.selectionChanged()
            }
        }  else {
            // Fallback on earlier versions
        }
    }
}
