//
//  ChatService.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 5/2/23.
//

import Foundation
import MessageKit
import FirebaseFirestore

class ChatService{
    
    static let sharedInstance = ChatService()
    
    var messages: [MessageType]
    
    init(){
        messages = []
    }
    
    func currentSender() -> SenderType{
        return Sender(senderId: UserService.sharedInstance.getUserId(), displayName: "sample")
    }
    
    func numberOfMessages() -> Int{
        messages.count
    }
    
    func messageAt(index: Int) -> MessageType{
        return messages[index]
    }
    
    func uploadMessages(otherUserId: String) async throws{
        do{
            let chatId = try await getChatId(otherUserId: otherUserId)
            getMessages(chatId: chatId)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func getChatId(otherUserId: String) async throws -> String {
        let userId = UserService.sharedInstance.getUserId()
        let chatsCollection = Firestore.firestore().collection("chats")
        
        do{
            let chatData = try await  chatsCollection.whereField("usersArray", arrayContainsAny: [userId, otherUserId]).getDocuments()
            let chatId = chatData.documents.first?.data()["chatId"] as! String
            return chatId
        }
        catch{
            print(error.localizedDescription)
        }
        
        return "how did it miss the catch block"
    }
    
    func getMessages(chatId: String){
        let messagesCollection = Firestore.firestore().collection("messages")
        
        messagesCollection.whereField("chatId", isEqualTo: chatId).getDocuments{
            (snapshot, error) in
            if let error = error{
                print("Could not get messages")
                print(error.localizedDescription)
            }
            else{
                for document in snapshot!.documents{
                    let content = document.data()["content"] as! String
                    let messageId = document.data()["messageId"] as! String
                    let userId = document.data()["userId"] as! String
                    let timestamp = document.data()["timestamp"] as! Timestamp
                    let date = timestamp.dateValue()
                    let sender = Sender(senderId: userId, displayName: "sample")
                    let newMessage = Message(sender: sender, messageId: messageId, sentDate: date, kind: .text(content))
                    self.messages.append(newMessage)
                }
            }
        }
    }
}
