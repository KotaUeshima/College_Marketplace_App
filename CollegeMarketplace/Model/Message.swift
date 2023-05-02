//
//  Message.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/25/23.
//

import Foundation
import MessageKit

struct Message: MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
