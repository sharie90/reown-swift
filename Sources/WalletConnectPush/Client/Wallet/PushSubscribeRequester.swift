
import Foundation

class PushSubscribeRequester {

    enum Errors: Error {
        case didDocDoesNotContainKeyAgreement
        case noVerificationMethodForKey
        case unsupportedCurve
    }

    private let keyserverURL: URL
    private let identityClient: IdentityClient
    private let networkingInteractor: NetworkInteracting
    private let kms: KeyManagementService
    private let logger: ConsoleLogging
    private let webDidResolver: WebDidResolver
    private let subscriptionsStore: CodableStore<PushSubscription>
    // Keychain shared with UNNotificationServiceExtension in order to decrypt PNs
    private let groupKeychainStorage: KeychainStorageProtocol

    init(keyserverURL: URL,
         networkingInteractor: NetworkInteracting,
         identityClient: IdentityClient,
         logger: ConsoleLogging,
         kms: KeyManagementService,
         groupKeychainStorage: KeychainStorageProtocol,
         subscriptionsStore: CodableStore<PushSubscription>,
         webDidResolver: WebDidResolver
    ) {
        self.keyserverURL = keyserverURL
        self.identityClient = identityClient
        self.networkingInteractor = networkingInteractor
        self.logger = logger
        self.kms = kms
        self.groupKeychainStorage = groupKeychainStorage
        self.subscriptionsStore = subscriptionsStore
        self.webDidResolver = webDidResolver
    }

    func subscribe(dappUrl: String, account: Account, onSign: @escaping SigningCallback) async throws {


        logger.debug("Subscribing for Push")

        let peerPublicKey = try await resolvePublicKey(dappUrl: dappUrl)
        let subscribeTopic = peerPublicKey.rawRepresentation.sha256().toHexString()


        let keys = try generateAgreementKeys(peerPublicKey: peerPublicKey)
//        let pushTopic = keys.derivedTopic()

        _ = try await identityClient.register(account: account, onSign: onSign)


        try kms.setAgreementSecret(keys, topic: subscribeTopic)


        let request = try createJWTRequest(subscriptionAccount: account, dappUrl: dappUrl)

        let protocolMethod = PushSubscribeProtocolMethod()

        try await networkingInteractor.subscribe(topic: subscribeTopic)

        try await networkingInteractor.request(request, topic: subscribeTopic, protocolMethod: protocolMethod)

//        logger.debug("PushSubscribeRequester: subscribing to push on topic: \(subscribeTopic)")
//
//        try kms.setAgreementSecret(keys, topic: pushTopic)
//
//        try groupKeychainStorage.add(keys, forKey: pushTopic)

//        logger.debug("Subscribing to push topic: \(pushTopic)")

//        try await networkingInteractor.subscribe(topic: pushTopic)


    }

    private func resolvePublicKey(dappUrl: String) async throws -> AgreementPublicKey {
        let didDoc = webDidResolver.resolveDidDoc(url: dappUrl)
        guard let keyAgreement = didDoc.keyAgreement.first else { throw Errors.didDocDoesNotContainKeyAgreement }
        guard let verificationMethod = didDoc.verificationMethod.first(where: { verificationMethod in verificationMethod.id == keyAgreement }) else { throw Errors.noVerificationMethodForKey }
        guard verificationMethod.publicKeyJwk.crv == .X25519 else { throw Errors.unsupportedCurve}
        let pubKeyBase64Url = verificationMethod.publicKeyJwk.x
        return try AgreementPublicKey(base64url: pubKeyBase64Url)
    }


    private func generateAgreementKeys(peerPublicKey: AgreementPublicKey) throws -> AgreementKeys {
        let selfPubKey = try kms.createX25519KeyPair()
        let keys = try kms.performKeyAgreement(selfPublicKey: selfPubKey, peerPublicKey: peerPublicKey.hexRepresentation)
        return keys
    }

    private func createJWTRequest(subscriptionAccount: Account, dappUrl: String) throws -> RPCRequest {
        let protocolMethod = PushSubscribeProtocolMethod().method
        let jwtPayload = CreateSubscriptionJWTPayload(keyserver: keyserverURL, subscriptionAccount: subscriptionAccount, dappUrl: dappUrl)
        let wrapper = try identityClient.signAndCreateWrapper(
            payload: jwtPayload,
            account: subscriptionAccount
        )
        return RPCRequest(method: protocolMethod, params: wrapper)
    }
}
