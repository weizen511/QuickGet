//
//  IntentHandler.swift
//  LockScreenIntentsExtension
//
//  Created by HeonJin Ha on 2022/10/05.
//

import Intents



// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INSendMessageRecipientResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INSendMessageRecipientResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        } else {
            completion([INSendMessageRecipientResolutionResult.needsValue()])
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}



//MARK: - ViewIcon Intent Handling

extension IntentHandler: DeepLinkAppIntentHandling {

    
    // func provideAppOptionsCollection(for intent: DeepLinkAppIntent) async throws -> INObjectCollection<AppDefinition> {
    //     
    // }
    

    
    /// 위젯 데이터를 가져오고 배열로 만듭니다.

    func provideAppOptionsCollection(for intent: DeepLinkAppIntent, with completion: @escaping (INObjectCollection<AppDefinition>?, Error?) -> Void) {

    // MARK: 데이터의 흐름
    // AppInfo : 딥링크 할 앱의 데이터
    // WidgetModel : AppInfo의 Array
    // AppDefinition(Type, intentDefinition)
    // AppInfo -> AppDefinition으로 데이터를 전달한다.
    // 데이터의 전달은 DeepLinkAppIntentHandling 프로토콜의 provideAppOptionsCollection 메소드를 통해 전달한다.
        
    let avaliableApps = CoreData.shared.getStoredDataForDeepLink()!
    
        /// AppInfo Data를 AppDefinition에 mapping 하여 만든 배열
        let apps: [AppDefinition] = avaliableApps.map { deepLink in
            
            /// 위젯에 필수적으로 전달해야할 데이터이다.
            /// UUID와 위젯편집 시 리스트에 표현될 이름으로 구성된다.
            let item = AppDefinition(
                identifier: deepLink.id?.uuidString, // 고유 식별자 지정
                display: deepLink.name ?? "no Data" // 위젯 편집창에서 표현할 이름
            )
            // 아래는 위젯에 추가로 전달할 데이터이다.

            item.url = deepLink.url // 딥링크 주소
            
            return item
        }
        
        /// 위 apps 배열을 INObjectCollection의 아이템으로 정의해준다.
        let collection = INObjectCollection<AppDefinition>(items: apps)
        
        /// 위에서 정의한 위젯 INObjectCollection 컬렉션을 completion 으로 전달한다.
        completion(collection, nil)
    }

    
}
