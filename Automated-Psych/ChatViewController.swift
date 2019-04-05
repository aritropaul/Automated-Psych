//
//  ChatViewController.swift
//  Automated-Psych
//
//  Created by Aritro Paul on 05/04/19.
//  Copyright © 2019 Aritropaul. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class ChatViewController: MessagesViewController {
    
    var messages: [Message] = []
    var atQuestion = 0
    var responseArray = [Question]()
    var answerArray: [String] = []
    let QuestionArray = ["Do you suffer from Anxiety and Tension ?",
                         "Do you suffer from Restlessness ?",
                         "Do you suffer from Nervousness ?",
                         "Do you suffer from Lonliness ?",
                         "Do you suffer from Hopelessness ?",
                         "Do you suffer from Anger ?",
                         "Do you suffer from Headache ?",
                         "Do you suffer from Tiredness ?",
                         "Do you suffer from Disturbed Sleep ?",
                         "Do you suffer from Indigestion ?",
                         "Do you suffer from Acidity ?",
                         ]
    var firstAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        setup()
    }
    
    func newMessage(text: String){
        self.messages.append(Message(messageSender: "Psych", text: text, messageId: UUID().uuidString))
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
    
    func setup(){
        newMessage(text: "Hello, welcome to Psych")
        newMessage(text: "Please answer in terms of Always, Often, at times, or Rarely.")
        newMessage(text: "Shall we begin ?")
    }
    
    func checkForAnswer(){
        if atQuestion == 0{
            let answer = answerArray[atQuestion].lowercased()
            if answer == "yes"{
                newMessage(text: QuestionArray[atQuestion])
                atQuestion = atQuestion + 1
            }
            else{
                newMessage(text:"Maybe sometime later then.")
            }
        }
        else{
            if atQuestion < QuestionArray.count{
                newMessage(text: QuestionArray[atQuestion])
                atQuestion = atQuestion + 1
            }
            else{
                answerArray.remove(at: 0)
                newMessage(text:"Thank you for your response")
                for item in 0...atQuestion-1{
                    responseArray.append(Question(question:QuestionArray[item], answer: answerArray[item]))
                    print(QuestionArray[item] + "\n" + answerArray[item])
                }
                self.performSegue(withIdentifier: "ResponseTable", sender: Any?.self)
            }
        }
        self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResponseTable" {
            if let viewController = segue.destination as? ResponsesViewController {
                viewController.responses = responseArray
            }
        }
    }

}

extension ChatViewController: MessagesDataSource{
    func currentSender() -> Sender {
        return Sender(id: "You", displayName: "You")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if messages[indexPath.section].sender.id == "You"{
            return .bubbleTail(.bottomRight, .pointedEdge)
        }
        else{
            return .bubbleTail(.bottomLeft, .pointedEdge)
        }
    }
    
}

extension ChatViewController: MessagesLayoutDelegate{
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

extension ChatViewController: MessageInputBarDelegate{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let newMessage: Message = Message(messageSender: "You", text: text, messageId: UUID().uuidString)
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        answerArray.append(text)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.checkForAnswer()
        })
    }
}

extension ChatViewController: MessagesDisplayDelegate{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.backgroundColor = .lightGray
        if messages[indexPath.section].sender.id == "You"{
            avatarView.initials = "Y"
        }
        else{
            avatarView.initials = "P"
        }
    }
}
