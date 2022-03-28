//
//  QuickstartChatManager.swift
//  ChatQuickstart
//
//  Created by Jeffrey Linwood on 3/11/20.
//  Copyright © 2020 Twilio, Inc. All rights reserved.
//

import UIKit

import TwilioChatClient

protocol QuickstartChatManagerDelegate: AnyObject {
    func reloadMessages()
    func receivedNewMessage(message:TCHMessage)
    func sendAllOldMessages(messages:[TCHMessage])
    func sendNewMessage(message:TCHMessage)
    
}

class QuickstartChatManager: NSObject, TwilioChatClientDelegate {

    // the unique name of the channel you create
    private let uniqueChannelName = "general"
    private let friendlyChannelName = "General Channel"

    // For the quickstart, this will be the view controller
    weak var delegate: QuickstartChatManagerDelegate?

    // MARK: Chat variables
    private var client: TwilioChatClient?
    private var channel: TCHChannel?
    private(set) var messages: [TCHMessage] = []
    private var identity: String?
    

    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        guard status == .completed else {
            return
        }
        checkChannelCreation { (_, channel) in
            if let channel = channel {
                self.joinChannel(channel)
            } else {
                
                client.channelsList()
                print(client.channelsList())
                
                var channelIDArr = NSArray()
                
                client.channelsList()!.publicChannelDescriptors(completion: { (result, paginator) in
                  if (result.isSuccessful()) {

//                    let userDefaults = UserDefaults.standard
//                    let userID = userDefaults.value(forKey: "userID") as! String

                    for channel in paginator!.items() {

                        let userDefaults = UserDefaults.standard
//                        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
//                        let giveAwayID = userDefaults.value(forKey: "giveAwayID") as? String ?? ""
//                        let chatUSerId = userDefaults.value(forKey: "chatUserID") as? String ?? ""

//                        userDefaults.set(giveAwayID, forKey: "giveAwayID")
//                        userDefaults.set(chatUserID, forKey: "chatUserID")

//                        let finalSuerID = giveAwayID + " \(chatUSerId)" + " \(userID)"
                        
                        let finalSuerID = userDefaults.value(forKey: "finalChatUserId") as? String ?? ""

                        let channelNameStr = channel.uniqueName ?? ""
                        print("Channel: \(channelNameStr)")

                        if(finalSuerID == channelNameStr){
                            print("User ID and Unique Name are Same")
                            print("Final User ID is \(finalSuerID)")
                            channel.channel(completion:{ (result, channel) in
                              if result.isSuccessful() {
                                print("Channel Status: \(String(describing: channel?.status))")
                                self.joinChannel(channel!)
                              }
                          })
                          
                       }
                    }
                    
                    
                  }
              })
                
                
                self.createChannel { (success, channel) in
                    if success, let channel = channel {
                        self.joinChannel(channel)
                        
                    }
                }
            }
        }
    }

    // Called whenever a channel we've joined receives a new message
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel,
                    messageAdded message: TCHMessage) {
        let userDefaults = UserDefaults.standard
        let accountId = userDefaults.value(forKey: "accountId") as! String
        if message.author==accountId
        {
        
        }
        else
        {
        messages.append(message)
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                
                delegate.reloadMessages()
                if self.messages.count > 0 {
                    delegate.receivedNewMessage(message: message)
                }
            }
        }
        }
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        print("Chat Client Token will expire.")
        // the chat token is about to expire, so refresh it
        refreshAccessToken()
    }
    
    private func refreshAccessToken() {
        guard let identity = identity else {
            return
        }
        let urlString = "\(TOKEN_URL)?identity=\(identity)"

        TokenUtils.retrieveToken(url: urlString) { (token, _, error) in
            guard let token = token else {
               print("Error retrieving token: \(error.debugDescription)")
               return
           }
            self.client?.updateToken(token, completion: { (result) in
                if (result.isSuccessful()) {
                    print("Access token refreshed\(token)")
                } else {
                    print("Unable to refresh access token")
                }
            })
        }
    }

    

    func sendMessage(_ messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        if let messages = self.channel?.messages {
            
            channel?.messages?.lastConsumedMessageIndex
            let messageOptions = TCHMessageOptions().withBody(messageText)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
                self.delegate?.sendNewMessage(message: message ?? TCHMessage())
                print(message)
            })
        }
    }

    func login(_ identity: String, completion: @escaping (Bool) -> Void) {
        // Fetch Access Token from the server and initialize Chat Client - this assumes you are
        // calling a Twilio function, as described in the Quickstart docs
        let urlString = "\(TOKEN_URL)?identity=\(identity)"
        self.identity = identity

        TokenUtils.retrieveToken(url: urlString) { (token, _, error) in
            guard let token = token else {
                print("Error retrieving token: \(error.debugDescription)")
                completion(false)
                return
            }
            // Set up Twilio Chat client
            TwilioChatClient.chatClient(withToken: token, properties: nil,
                                        delegate: self) { (result, chatClient) in
                self.client = chatClient
                completion(result.isSuccessful())
            }
        }
    }

    func shutdown() {
        
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }

    private func createChannel(_ completion: @escaping (Bool, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            return
        }
        
        let userDefaults = UserDefaults.standard
//        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
//        let giveAwayID = userDefaults.value(forKey: "giveAwayID") as? String ?? ""
//        let chatUSerId = userDefaults.value(forKey: "chatUserID") as? String ?? ""
//
//        let finalSuerID = giveAwayID + " \(chatUSerId)" + " \(userID)"
        
        let finalSuerID = userDefaults.value(forKey: "finalChatUserId") as? String ?? ""

        
        // Create the channel if it hasn't been created yet
        let options: [String: Any] = [
            TCHChannelOptionUniqueName: finalSuerID,
            TCHChannelOptionFriendlyName: friendlyChannelName,
            TCHChannelOptionType: TCHChannelType.public.rawValue
            ]
        channelsList.createChannel(options: options, completion: { channelResult, channel in
            if channelResult.isSuccessful() {
                print("Channel created.")
                
            } else {
                
                print("Channel NOT created.")
                print(channelResult.error)
                if channelResult.resultText=="Channel with provided unique name already exists"
                {
                }
                else
                {
                client.channelsList()!.publicChannelDescriptors(completion: { (result, paginator) in
                  if (result.isSuccessful()) {

//                    let userDefaults = UserDefaults.standard
//                    let userID = userDefaults.value(forKey: "userID") as! String

                    for channel in paginator!.items() {

                        let userDefaults = UserDefaults.standard
//                        let userID = userDefaults.value(forKey: "userID") as? String ?? ""
//                        let giveAwayID = userDefaults.value(forKey: "giveAwayID") as? String ?? ""
//                        let chatUSerId = userDefaults.value(forKey: "chatUserID") as? String ?? ""

//                        userDefaults.set(giveAwayID, forKey: "giveAwayID")
//                        userDefaults.set(chatUserID, forKey: "chatUserID")
                        
//                        finalChatUserId
                        
                        let finalSuerID = userDefaults.value(forKey: "finalChatUserId") as? String ?? ""

//                        let finalSuerID = giveAwayID + " \(chatUSerId)" + " \(userID)"

                        let channelNameStr = channel.uniqueName ?? ""
                        print("Channel: \(channelNameStr)")

                        if(finalSuerID == channelNameStr){
                            print("User ID and Unique Name are Same")
                            print("Final User ID is \(finalSuerID)")
                            
                            channel.channel(completion:{ (result, channel) in
                              if result.isSuccessful() {
                                print("Channel Status: \(String(describing: channel?.status))")
                                self.joinChannel(channel!)
                              }
                            })
                            
                            let tchCchannel = TCHChannel()
                            self.joinChannel(tchCchannel)
                            
                            return

                       }
                    }
                  }
                })
                }
             }
            completion(channelResult.isSuccessful(), channel)
        })
    }

    private func checkChannelCreation(_ completion: @escaping(TCHResult?, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            return
        }
        let userDefaults = UserDefaults.standard
        let finalSuerID = userDefaults.value(forKey: "finalChatUserId") as? String ?? ""
        channelsList.channel(withSidOrUniqueName: finalSuerID, completion: { (result, channel) in
            completion(result, channel)
        })
    }

    private func joinChannel(_ channel: TCHChannel) {
        self.channel = channel
        if channel.status == .joined {
            if fromChatScreen=="giveAway"
            {
            print("Current user already exists in channel")
            channel.messages?.getLastWithCount(5, completion: { messageresult, TCHMessage in
                print(TCHMessage)
//                self.delegate?.reloadMessages()
                
//                for message in self.messages {
//                  print("Message body: \(message.body)")
//                }

                self.delegate?.sendAllOldMessages(messages: TCHMessage!)
                
            })
            }
            else
            {
            print("Current user already exists in channel")
            channel.messages?.getLastWithCount(100, completion: { messageresult, TCHMessage in
                print(TCHMessage)
//                self.delegate?.reloadMessages()
                
//                for message in self.messages {
//                  print("Message body: \(message.body)")
//                }

                self.delegate?.sendAllOldMessages(messages: TCHMessage!)
                
            })
            }
        } else {
            channel.join(completion: { result in
                print("Result of channel join: \(result.resultText ?? "No Result")")
            })
        }
    }
}

