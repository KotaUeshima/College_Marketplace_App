//
//  ChatViewController.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/25/23.
//

import Foundation
import MessageKit
import UIKit

struct Sender: SenderType {
    let senderId: String
    let displayName: String
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    let sharedChat = ChatService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegates for messagesCollectionView
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messagesCollectionView.reloadData()
    }

    // delegatee methods for messageCollectionView
    var currentSender: SenderType {
        return sharedChat.currentSender()
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return sharedChat.numberOfMessages()
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return sharedChat.messageAt(index: indexPath.section)
    }
    
}
