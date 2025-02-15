import Foundation

struct InputConfig {
    static var projectId: String {
        guard let projectId = config(for: "PROJECT_ID"), !projectId.isEmpty else {
            fatalError("PROJECT_ID is either not defined or empty in Configuration.xcconfig")
        }
        
        return projectId
    }

    static var sentryDsn: String? {
        return config(for: "WALLETAPP_SENTRY_DSN")
    }

    static var mixpanelToken: String? {
        return config(for: "MIXPANEL_TOKEN")
    }

    static var pimlicoApiKey: String? {
        return config(for: "PIMLICO_API_KEY")
    }

    private static func config(for key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }

}
