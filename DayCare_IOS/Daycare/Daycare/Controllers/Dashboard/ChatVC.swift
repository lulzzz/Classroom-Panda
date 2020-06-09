//
//  ChatVC.swift
//  Daycare Parent
//
//  Created by amrut waghmare on 01/04/19.
//  Copyright © 2019 amrut waghmare. All rights reserved.
//

import UIKit
import SwiftSignalRClient
import IQKeyboardManagerSwift

class ChatVC: BaseViewController {
    @IBOutlet weak var tblViewForChat: UITableView!
    @IBOutlet weak var txtViewForMessageView: SBMessageInputView!
    @IBOutlet weak var btnForMessageSend: UIButton!
    @IBOutlet weak var bottomConstraintForView: NSLayoutConstraint!

    private let dispatchQueue = DispatchQueue(label: "hubsamplephone.queue.dispatcheueuq")
    var parentUser:MessageUser?
    var arrForMessages:[Message] = []
    var signalRConnection : SignalRConnection?
    

    override func viewDidLoad() {
        super.viewDidLoad()
      signalRConnection = SignalRConnection.sharedInstance
        IQKeyboardManager.shared.enable = false
        self.setNavigationBarWithBackButton(title: Macros.NavigationTitle.chat)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.apiForGetAllMessages()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
//        signalRConnection?.closeConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
//        self.signalRConnection = SignalRConnection()
//      self.signalRConnection?.startConnection(currentUser: AppInstance.shared.user ?? User())
        self.signalRConnection?.delegate = self
    }
  
  @IBAction func actionForMessageSend(_ sender: Any) {
        let message = Message()
        message.agencyID = AppInstance.shared.user?.agencyID ?? 0
        message.SenderUserID = AppInstance.shared.user?.loginUserID ?? 0
        message.ReceiverUserID = parentUser?.listUserId ?? 0
        message.message = txtViewForMessageView.textView.text?.trimSpaces()
        if message.message != "" && message.message != nil {
            print(message.getStringFromParam())
            self.signalRConnection?.sendMessage(message: message)
            self.txtViewForMessageView.textView.text = ""
        }
    }
    
    //MARK:------ Keyboard Handler -----
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //            self.view.frame.origin.y -= keyboardSize.height
            self.bottomConstraintForView.constant = (keyboardSize.height + 45)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //         self.view.frame.origin.y = 0
        self.bottomConstraintForView.constant = 0
    }
    
    func toggleUI(isEnabled: Bool) {
        btnForMessageSend.isEnabled = isEnabled
//        txtViewForMessageView.textView.isEnabled = isEnabled
    }
    
    private func appendMessage(message: Message) {
        self.dispatchQueue.sync {
            self.arrForMessages.append(message)
        }
        self.tblViewForChat.beginUpdates()
        self.tblViewForChat.insertRows(at: [IndexPath(row: arrForMessages.count - 1, section: 0)], with: .automatic)
        self.tblViewForChat.endUpdates()
        self.tblViewForChat.scrollToRow(at: IndexPath(item: arrForMessages.count-1, section: 0), at: .bottom, animated: true)
    }
    
    
    func setupChildListMenu(){
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        let teacherImageView = UIImageView(frame: CGRect(x: navView.bounds.minX, y: navView.bounds.minY, width: 30, height: 30))
        teacherImageView.cornerRadius = teacherImageView.bounds.width/2
        teacherImageView.clipsToBounds = true
        teacherImageView.sd_setImage(with: URL(string: self.parentUser?.imagePath ?? "")) { (image, error, type, url) in
            if (error != nil) {
                teacherImageView.image = UIImage(named: "placeholder")
            }
        }
        let nameLabel = UILabel(frame: CGRect(x: navView.bounds.minX+40, y: navView.bounds.minY, width: 150, height: 30))
        nameLabel.text = parentUser?.listUserName
        nameLabel.textColor = .white
        navView.addSubview(teacherImageView)
        navView.addSubview(nameLabel)
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(actionForBackButton), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backButton)
        let item2 = UIBarButtonItem(customView: navView)
        self.navigationItem.setLeftBarButtonItems([item1,item2], animated: true)
    }
    
     func getMessageFromString(string: String) -> Message? {
        let data = string.data(using: .utf8)
        do {
            if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options : .allowFragments) as? Dictionary<String,Any>
            {
                return Message.init(dictionary: json)
            } else {
                print("bad json")
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    //MARK:----- API Calling Functions -----
    
    func apiForGetAllMessages(){
        let service = MessageService()
        self.showLoader()
        service.getAllMessages(with: nil, senderID: AppInstance.shared.user?.loginUserID ?? 0, receiverID: parentUser?.listUserId ?? 0, complition: {(result) in
          self.hideLoader()
            if result != nil {
                self.arrForMessages = result as? [Message] ?? []
//                self.signalRConnection = SignalRConnection()
//                self.signalRConnection?.delegate = self
//                self.signalRConnection?.startConnection(currentUser:AppInstance.shared.user ?? User())
                self.tblViewForChat.reloadData()
                if self.arrForMessages.count > 0 {
                    self.tblViewForChat.scrollToRow(at: IndexPath(item: self.arrForMessages.count-1, section: 0), at: .bottom, animated: true)
                }
            }
        })
    }}

//MARK:----- UITableView Delegate and Datasources ------
extension ChatVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = -1
        dispatchQueue.sync {
            count = self.arrForMessages.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if arrForMessages.count > row {
            let message = arrForMessages[row]
            if (message.SenderUserID == AppInstance.shared.user?.loginUserID ?? 0) {
                return  customSenderMessageTableViewCell(tableView: tableView, indexPath: indexPath)
            } else {
                return customReceiverMessageTableViewCell(tableView:tableView ,indexPath:indexPath)
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func customSenderMessageTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Macros.Identifiers.Cells.MessageSenderCell) as? MessageSenderCell {
            cell.txtViewForMessage.text = self.arrForMessages[indexPath.row].message
            cell.lblForDate.text = CommonClassMethods.dateFromDateStringWithoutUTC(date: self.arrForMessages[indexPath.row].CreatedDateTime ?? "")
            let fixedWidth = self.view.frame.width - 80
            let newSize = cell.txtViewForMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            cell.txtViewForMessage.frame.size = CGSize(width: min(newSize.width, fixedWidth - 30), height: newSize.height)
            
            cell.txtViewForMessage.translatesAutoresizingMaskIntoConstraints = true
            cell.txtViewForMessage.sizeToFit()
            cell.viewForMessage.frame = CGRect(x: self.view.frame.width - (cell.txtViewForMessage.frame.width + 30), y: cell.viewForMessage.frame.minY, width:  cell.txtViewForMessage.frame.width + 20, height: cell.txtViewForMessage.frame.height + 20)
            let path = UIBezierPath(roundedRect: cell.viewForMessage.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            cell.viewForMessage.layer.mask = mask
            return cell
        }
        return UITableViewCell()
    }
    
    func customReceiverMessageTableViewCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Macros.Identifiers.Cells.MessageReceiverCell) as? MessageReceiverCell {
            cell.txtViewForMessage.text = self.arrForMessages[indexPath.row].message
            cell.lblForDate.text = CommonClassMethods.dateFromDateStringWithoutUTC(date: self.arrForMessages[indexPath.row].CreatedDateTime ?? "")
            let fixedWidth = self.view.frame.width - 100
            let newSize = cell.txtViewForMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            cell.txtViewForMessage.frame.size = CGSize(width: min(newSize.width, fixedWidth - 50), height: newSize.height)
            cell.txtViewForMessage.translatesAutoresizingMaskIntoConstraints = true
            cell.txtViewForMessage.sizeToFit()
            cell.viewForMessage.frame = CGRect(x: cell.lblForName.frame.minX, y: cell.viewForMessage.frame.minY, width:  cell.txtViewForMessage.frame.width+20, height: cell.txtViewForMessage.frame.height + 20)
            cell.lblForName.text = parentUser?.listUserName
            cell.imgViewForReceiver.sd_setImage(with: URL(string: self.parentUser?.imagePath ?? "")) { (image, error, type, url) in
                if (error != nil) {
                    cell.imgViewForReceiver.image = UIImage(named: "placeholder")
                }
            }
            let path = UIBezierPath(roundedRect: cell.viewForMessage.bounds, byRoundingCorners: [.topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 30, height: 30))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            cell.viewForMessage.layer.mask = mask
            return cell
        }
        return UITableViewCell()
    }
}


//MARK:----- Signal R Delegate ----
extension ChatVC: SignalRConnectionDelegate{
    func signalRConnection(didDisconnected disconnected: Bool) {
        self.hideLoader()
        toggleUI(isEnabled: disconnected)
    }
    func signalRConnection(didConnected connected: Bool) {
        self.hideLoader()
        toggleUI(isEnabled: connected)
    }
    func signalRConnection(messageSent message:Message){
        if message.SenderUserID == self.parentUser?.listUserId || message.ReceiverUserID == self.parentUser?.listUserId {
            message.CreatedDateTime = CommonClassMethods.dateToStringSignalR(date: Date())
            appendMessage(message: message)
        }
    }
    func signalRConnection(receiveMessage message:Message){
        if message.SenderUserID == self.parentUser?.listUserId || message.ReceiverUserID == self.parentUser?.listUserId {
            message.CreatedDateTime = CommonClassMethods.dateToStringSignalR(date: Date())
            appendMessage(message: message)
        }
    }
    func signalRConnection(errorInConnection errorMessage: String) {
        self.hideLoader()
        self.signalRConnection?.startConnection(currentUser:AppInstance.shared.user ?? User())
    }
    func signalRConnection(error errorMessage: String) {
        self.hideLoader()
        self.showAlert(with: errorMessage)
    }
}

//MARK:----- UITableView Cell ------
class MessageSenderCell: UITableViewCell{
    @IBOutlet weak var txtViewForMessage: UITextView!
    @IBOutlet weak var viewForMessage: UIView!
    @IBOutlet weak var lblForDate: UILabel!
//    @IBOutlet weak var leadingConstraintForMsgView: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtViewForMessage.translatesAutoresizingMaskIntoConstraints = true
        txtViewForMessage.isScrollEnabled = false
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class MessageReceiverCell: UITableViewCell{
    @IBOutlet weak var txtViewForMessage: UITextView!
    @IBOutlet weak var viewForMessage: UIView!
    @IBOutlet weak var imgViewForReceiver: UIImageView!
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtViewForMessage.translatesAutoresizingMaskIntoConstraints = true
        txtViewForMessage.isScrollEnabled = false
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

