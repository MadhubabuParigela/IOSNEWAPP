//
//  ChatViewController.swift
//  Twilio Starter App
//
//  Created by Jeffrey Linwood, Kevin Whinnery on 11/29/16.
//  Copyright © 2016 Twilio, Inc. All rights reserved.
//

import UIKit

import TwilioChatClient


class ChatViewController: UIViewController,UITableViewDelegate {

    @IBOutlet weak var chatHeaderLbl: UILabel!
    @IBAction func chatBackBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    var chatMessagesArray = NSMutableArray()
    var chatReversedMessageArray = NSMutableArray()
    
    // Important - this identity would be assigned by your app, for
    // instance after a user logs in
    var identity = "1738495944"
    var chatNameStr = ""
    
//    var identity = ""

    // Convenience class to manage interactions with Twilio Chat
    var chatManager = QuickstartChatManager()

    // MARK: UI controls
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTxxtField: UITextField!
    @IBOutlet weak var chatTblView: UITableView!
    var sendDisable=Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatHeaderLbl.text = chatNameStr
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: chatTxxtField.frame.size.width - (90), y: 0, width: 90, height: chatTxxtField.frame.size.height)
        chatTxxtField.rightView = paddingView
        chatTxxtField.rightViewMode = UITextField.ViewMode.always
        
        let sendBtn = UIButton()
        sendBtn.frame = CGRect(x: 10, y: 0, width: 70, height: paddingView.frame.size.height)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.setTitleColor(UIColor.blue, for: .normal)
        paddingView.addSubview(sendBtn)
        sendBtn.titleLabel?.font = UIFont.init(name: kAppFontMedium, size: 13)
        sendBtn.setTitleColor(hexStringToUIColor(hex: "232c51"), for: UIControl.State.normal)
        
        if sendDisable==true
        {
            sendBtn.setTitleColor(UIColor.gray, for: .normal)
            sendBtn.isUserInteractionEnabled=false
        }
        else
        {
            sendBtn.setTitleColor(UIColor.blue, for: .normal)
            sendBtn.isUserInteractionEnabled=true
            sendBtn.addTarget(self, action: #selector(sendBtnTap), for: .touchUpInside)
        }
        
        chatTblView.delegate = self
        chatTblView.dataSource = self

        chatTblView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        chatTblView.register(UINib(nibName: "ReceiverChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverChatTableViewCell")

        chatManager.delegate = self

        // Listen for keyboard events and animate text field as necessary
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        // Set up UI controls
        self.chatTblView.rowHeight = UITableView.automaticDimension
        self.chatTblView.estimatedRowHeight = 66.0
        self.chatTblView.separatorStyle = .none
        self.chatTblView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromChatScreen=""
        animatingView()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let userDefaults = UserDefaults.standard
        let accountId = userDefaults.value(forKey: "accountId") as! String
        identity = accountId
        
        super.viewDidAppear(animated)
        login()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatManager.shutdown()
    }

    func animatingView(){
        
        self.view.addSubview(activity)
                      
        activity.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = activity.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = activity.widthAnchor.constraint(equalToConstant: 50)
        let heightConstraint = activity.heightAnchor.constraint(equalToConstant: 50)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    // MARK: Login

    func login() {
        
        activity.startAnimating()
        
        chatManager.login(self.identity) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.navigationItem.prompt = "Logged in as \"\(self.identity)\""
                    print("chat login success")
                    activity.stopAnimating()
                    
                } else {
                    self.navigationItem.prompt = "Unable to login"
                    let msg = "Unable to login - check the token URL in ChatConstants.swift"
                    print("chat login fail")
                   activity.stopAnimating()
                    self.displayErrorMessage(msg)

                }
            }
        }
    }

    // MARK: Keyboard Dodging Logic

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
//                self.bottomConstraint.constant = keyboardRect.height + 10
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardDidShow(notification: NSNotification) {
//        scrollToBottomMessage()
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
//            self.bottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        })
    }

    // MARK: UI Logic

    // Dismiss keyboard if container view is tapped
    @IBAction func viewTapped(_ sender: Any) {
        self.chatTxxtField.resignFirstResponder()
    }

    private func scrollToBottomMessage() {
        
        if chatManager.messages.count == 0 {
            return
        }
        
        if(chatManager.messages.count > 0){
            
            if(chatManager.messages.count == 1 || chatManager.messages.count == 2){
                
            }else{
                let bottomMessageIndex = IndexPath(row: chatManager.messages.count - 1,
                                                   section: 0)
                chatTblView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
            }
            
        }else{
//            let bottomMessageIndex = IndexPath(row: 0,
//                                               section: 0)
//
//
//            chatTblView.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)

        }
        
    }

    private func displayErrorMessage(_ errorMessage: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
   
    }
    
    // Alert controller
    func showAlertWith(title:String,message:String)
        {
            let alertController = UIAlertController(title: title, message:message , preferredStyle: .alert)
            //to change font of title and message.
            let titleFont = [NSAttributedString.Key.font: UIFont(name: kAppFontBold, size: 14.0)!]
            let messageFont = [NSAttributedString.Key.font: UIFont(name: kAppFont, size: 12.0)!]
            
            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
            alertController.setValue(titleAttrString, forKey: "attributedTitle")
            alertController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
               
            })
    //        let titlealertaction = NSMutableAttributedString(string: "OK", attributes: titleFont)
    //        alertController.setValue(titlealertaction, forKey: "attributedTitle")
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    @objc func sendBtnTap(){
        
        let myString = chatTxxtField.text ?? ""
        let trimmedString = myString.trimmingCharacters(in: .whitespacesAndNewlines)

        if(trimmedString == ""){
            showAlertWith(title: "Alert", message: "Enter text")
            return
        }

        chatManager.sendMessage(trimmedString, completion: { (result, _) in
            if result.isSuccessful() {
                self.chatTxxtField.text = ""
                print("Sent Successfully")
                self.chatTxxtField.resignFirstResponder()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat , xValue:Int,  yValue:Int) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
}
extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
// MARK: UITextField Delegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatManager.sendMessage(textField.text!, completion: { (result, _) in
            if result.isSuccessful() {
                textField.text = ""
                textField.resignFirstResponder()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
        return true
    }
}


// MARK: UITableViewDataSource Delegate
extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let messageDataDict = chatReversedMessageArray.object(at: indexPath.row) as? NSDictionary
        let messageStr = messageDataDict?.value(forKey: "messageText") as? String ?? ""
        
        var Qheight = heightForView(text: messageStr, font: UIFont(name: kAppFont, size: 18)!, width: tableView.frame.size.width - 120, xValue: 0, yValue: 0)
        
        if(Qheight < 40){
            Qheight = 40
            Qheight = Qheight + 25
        }
        else{
            Qheight = Qheight + 40
        }
        return Qheight
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Return number of rows in the table
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
//        return chatManager.messages.count
        return chatReversedMessageArray.count

    }

    // Create table view rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDataDict = chatReversedMessageArray.object(at: indexPath.row) as? NSMutableDictionary
        
        let  messageAuthor  = messageDataDict?.value(forKey: "author") as? String
        
        let userDefaults = UserDefaults.standard
        let accountId = userDefaults.value(forKey: "accountId") as! String
        
        
//            let message = chatManager.messages[indexPath.row]
            // Set table cell values
//            cell.detailTextLabel?.text = message.author
//            cell.textLabel?.text = message.body
//            cell.selectionStyle = .none
        
//        cell.chatTxtLbl.text = message.body
        

        if(messageAuthor == accountId){
            
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            
            let messageStr = messageDataDict?.value(forKey: "messageText") as? String ?? ""
            
            var Qheight = heightForView(text: messageStr, font: UIFont(name: kAppFont, size: 18)!, width: cell.contentView.frame.size.width - 120, xValue: 0, yValue: 0)
            
            if(Qheight < 40){
                Qheight = 40
                Qheight = Qheight + 25
            }
            else{
                Qheight = Qheight + 40
            }
            
            
            cell.labelHeight.constant = Qheight
//            cell.labelWidth.constant = width
            
            let chatView = UIView()
            chatView.frame = CGRect(x: 50, y: 0, width: cell.contentView.frame.size.width  - 50, height:Qheight + 15)
//            chatView.backgroundColor = .orange
//            cell.contentView.addSubview(chatView)
            cell.chatTxtLbl.text = messageDataDict?.value(forKey: "messageText") as? String
            
            let profileImgView = UIImageView()
            profileImgView.frame = CGRect(x: chatView.frame.size.width - 35, y: 5, width: 30, height: 30)
            profileImgView.backgroundColor = .lightGray
            chatView.addSubview(profileImgView)
            
            let chatSecondView = UIView()
            chatSecondView.frame = CGRect(x: 10, y: 0, width: chatView.frame.size.width  - 60, height:chatView.frame.size.height-15)
//            chatSecondView.backgroundColor = .green
            chatSecondView.backgroundColor = hexStringToUIColor(hex: "007afe")
            chatView.addSubview(chatSecondView)

            let chatTxtLbl = UILabel()
            chatTxtLbl.frame = CGRect(x: 5, y: 0, width: chatSecondView.frame.size.width - 10, height: chatSecondView.frame.size.height - 5)
            chatTxtLbl.text = messageDataDict?.value(forKey: "messageText") as? String
            chatTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
            chatTxtLbl.numberOfLines = 0
            chatSecondView.addSubview(chatTxtLbl)
            chatTxtLbl.textAlignment = .right
            chatTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 13)
            
//            cell.chatProfileImg.backgroundColor = .orange
//            cell.chatTxtLbl.text = messageDataDict?.value(forKey: "messageText") as? String

            print(chatManager.messages)
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            let userDefaults = UserDefaults.standard
            let userID = userDefaults.value(forKey: "userID") as! String
            print(userID)
            

            let imageStr = MyAccImgUrl + userID

            if !imageStr.isEmpty {

                let imgUrl:String = imageStr

                let trimStr = imgUrl.replacingOccurrences(of: " ", with: "%20")

                let imggg = MyAccImgUrl + userID

                let url = URL.init(string: imggg)
                
//                profileImgView.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
                cell.chatProfileImg.sd_setImage(with: url, placeholderImage:UIImage(named: "no_image"), options: .refreshCached)
//                profileImgView.contentMode = UIView.ContentMode.scaleAspectFill
                cell.chatProfileImg.contentMode = UIView.ContentMode.scaleAspectFill

            }
            else {
//                profileImgView.image = UIImage(named: "no_image")
                cell.chatProfileImg.image = UIImage(named: "no_image")
                
            }
            cell.dateLabel.text=convertDateTimeFormatter1(date: messageDataDict?.value(forKey: "dateCreated") as? String ?? "")
            return cell

        }else{
            
            let cell = chatTblView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
            
            let messageStr = messageDataDict?.value(forKey: "messageText") as? String ?? ""
            
            print("strrr: \(messageStr)")
            
            var Qheight = heightForView(text: messageStr, font: UIFont(name: kAppFont, size: 18)!, width: cell.contentView.frame.size.width - 120, xValue: 0, yValue: 0)
            
            if(Qheight < 40){
                Qheight = 40
                Qheight = Qheight + 25
            }
            else{
                Qheight = Qheight + 40
            }
            
            
            cell.labelHeight.constant = Qheight
            cell.chatProfileImg.image = UIImage(named: "no_image")
            cell.chatMsgLbl.text = messageStr
            
            
            
//            let profileImgView = UIImageView()
//            profileImgView.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
//            profileImgView.backgroundColor = .lightGray
//            chatView.addSubview(profileImgView)
//
//            let chatSecondView = UIView()
//            chatSecondView.frame = CGRect(x: profileImgView.frame.origin.x+profileImgView.frame.size.width+10, y: 0, width: chatView.frame.size.width  - 60, height:chatView.frame.size.height-15)
////            chatSecondView.backgroundColor = .green
//            chatSecondView.backgroundColor = hexStringToUIColor(hex: "007afe")
//            chatView.addSubview(chatSecondView)

//            let chatTxtLbl = UILabel()
//            chatTxtLbl.frame = CGRect(x: 5, y: 0, width: chatSecondView.frame.size.width - 10, height: chatSecondView.frame.size.height - 5)
//            chatTxtLbl.text = messageDataDict?.value(forKey: "messageText") as? String
//            chatTxtLbl.textColor = hexStringToUIColor(hex: "232c51")
//            chatTxtLbl.numberOfLines = 0
//            chatSecondView.addSubview(chatTxtLbl)
//            chatTxtLbl.textAlignment = .left
//            chatTxtLbl.font = UIFont.init(name: kAppFontMedium, size: 13)

//            print(chatManager.messages)
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.dateLabel.text=convertDateTimeFormatter1(date: messageDataDict?.value(forKey: "dateCreated") as? String ?? "")
                
            return cell

        }
    }
}

// MARK: QuickstartChatManagerDelegate
extension ChatViewController: QuickstartChatManagerDelegate {
    func sendAllOldMessages(messages: [TCHMessage]) {
        
        print(messages)
        
        for message in messages{
            
            let messageBody = message.body!
            let messageAuthor = message.author!
            let messageSId = message.sid!
            let messageDateCreated = message.dateCreated!
            
            let messageDataDict = NSMutableDictionary()
            messageDataDict.setValue(messageBody, forKey: "messageText")
            messageDataDict.setValue(messageAuthor, forKey: "author")
            messageDataDict.setValue(messageSId, forKey: "Sid")
            messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")

            chatMessagesArray.add(messageDataDict)
        }
        
        chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        print(chatMessagesArray)
        self.chatTblView.reloadData()
        activity.stopAnimating()

    }
    
    func sendNewMessage(message:TCHMessage)  {
        
        let messageBody = message.body!
        let messageAuthor = message.author!
        let messageSId = message.sid!
        let messageDateCreated = message.dateCreated!
        
        let messageDataDict = NSMutableDictionary()
        messageDataDict.setValue(messageBody, forKey: "messageText")
        messageDataDict.setValue(messageAuthor, forKey: "author")
        messageDataDict.setValue(messageSId, forKey: "Sid")
        messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")
        
        print("Before Chat is \(chatMessagesArray)")

        chatMessagesArray.add(messageDataDict)
        
        chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        
        self.chatTblView.reloadData()

        
        print("Reverse Arr is \(chatReversedMessageArray)")
        
        print(messageDataDict)
    }
    
    func reloadMessages() {
        self.chatTblView.reloadData()
    }

    // Scroll to bottom of table view for messages
    func receivedNewMessage(message:TCHMessage) {
        
        print(message)
            
            let messageBody = message.body!
            let messageAuthor = message.author!
            let messageSId = message.sid!
            let messageDateCreated = message.dateCreated!
            
            let messageDataDict = NSMutableDictionary()
            messageDataDict.setValue(messageBody, forKey: "messageText")
            messageDataDict.setValue(messageAuthor, forKey: "author")
            messageDataDict.setValue(messageSId, forKey: "Sid")
            messageDataDict.setValue(messageDateCreated, forKey: "dateCreated")

            chatMessagesArray.add(messageDataDict)
        
        
        chatReversedMessageArray =  NSMutableArray(array: chatMessagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        print(chatMessagesArray)
        self.chatTblView.reloadData()

    }
}


