//
//  Messages.swift
//  Automated-Psych
//
//  Created by Aritro Paul on 05/04/19.
//  Copyright © 2019 Aritropaul. All rights reserved.
//

import Foundation
import MessageKit
import UIKit

struct Message{
    let messageSender: String
    let text: String
    let messageId: String
}

struct Question{
    let question: String
    let answer: String
}

extension Message: MessageType{
    var sender: Sender {
        return Sender(id: messageSender, displayName: messageSender)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
