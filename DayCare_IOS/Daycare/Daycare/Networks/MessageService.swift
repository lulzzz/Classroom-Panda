//
//  MessageService.swift
//  Daycare
//
//  Created by amrut waghmare on 08/05/19.
//  Copyright © 2019 amrut waghmare. All rights reserved.
//

import UIKit

class MessageService: APIService {
    
    //MARK:---- Parent List API -----
    func getAllParents(with target:BaseViewController?, agencyID:Int, teacherID:Int, roleID: Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kteacherID : teacherID, Macros.ApiKeys.kroleID: roleID] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetListForChat, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Array<Dictionary<String,Any>>{
                        let parents = MessageUser.modelsFromDictionaryArray(array: data)
                        complition(parents)
                    } else {
                        complition(nil)
                    }
                case .Error(let error):
                    target?.hideLoader()
                    target?.showAlert(with: error)
                    complition(nil)
                }
            }
        }
    }
    
    //MARK:---- Message List API -----
    func getAllMessages(with target:BaseViewController?, senderID:Int, receiverID:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.ksenderUserID : senderID, Macros.ApiKeys.kreceiverUserID : receiverID] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetMessageByID, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Array<Dictionary<String,Any>>{
                        let messages = Message.modelsFromDictionaryArray(array: data)
                        complition(messages)
                    } else {
                        complition(nil)
                    }
                case .Error(let error):
                    target?.hideLoader()
                    target?.showAlert(with: error)
                    complition(nil)
                }
            }
        }
    }
}
