//
//  DailySheetService.swift
//  Daycare
//
//  Created by amrut waghmare on 17/01/19.
//  Copyright © 2019 amrut waghmare. All rights reserved.
//

import UIKit

class DailySheetService: APIService {
    
    //MARK:---- Daily Sheet List API -----
    func getDailySheetList(with target:BaseViewController?, agencyID:Int,classID: Int,askedDate:String, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        // send asked Date in UTC and askeDateString in local timezone
        let UTCDate = TimeUtils.localToUTC(date: askedDate, format: DateFormats.YYYY_MM_DD_T_HH_MM_SS_SSSZ)
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kclassID : classID, Macros.ApiKeys.kaskedDate : UTCDate, Macros.ApiKeys.kaskedDateString : askedDate] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetDailySheetMobile, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Array<Dictionary<String,Any>>{
                        let dailySheets = DailySheet.modelsFromDictionaryArray(array: data)
                        complition(dailySheets)
                    }else {
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
    
    //MARK:---- SubActivity List API -----
    func getSubActivityList(with target:BaseViewController?, agencyID:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetAllSubActivityType, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Array<Dictionary<String,Any>>{
                        let subactivities = SubActivity.modelsFromDictionaryArray(array: data)
                        complition(subactivities)
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
    
    //MARK:---- Save Daily Sheet API -----
    func saveDailySheetData(with target:BaseViewController?, param : Dictionary<String,Any>, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   param
        super.startService(with: .POST, path: Macros.ServiceName.SaveStudentActivity, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["message"] as? String{
                        complition(data)
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
    
    //MARK:---- Get Nap Activity details API -----
    func getNapActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityNap, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let napActivity = AcitivityNap.init(dictionary: data)
                        complition(napActivity)
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
    
    //MARK:---- Get Other Activity details API -----
    func getOtherActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentOtherActivity, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let otherActivity = OtherActivity.init(dictionary: data)
                        complition(otherActivity)
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
    
    //MARK:---- Get Mood Activity details API -----
    func getMoodActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityMoods, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let moodActivity = ActivityMoods.init(dictionary: data)
                        complition(moodActivity)
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
    
    //MARK:---- Get Notes Activity details API -----
    func getNotesActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityNotes, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let notesActivity = ActivityNotes.init(dictionary: data)
                        complition(notesActivity)
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
    
    //MARK:---- Get Health Activity details API -----
    func getHealthActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityMedications, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let healthActivity = ActivityMedications.init(dictionary: data)
                        complition(healthActivity)
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
    
    //MARK:---- Get Meals Activity details API -----
    func getMealActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityMeals, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let mealActivity = ActivityMeals.init(dictionary: data)
                        complition(mealActivity)
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
    
    
    //MARK:---- Get Todays Meals Plan API -----
    func getTodaysMealPlan(with target:BaseViewController?, agencyID:Int, classId:Int, askedDate:String, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kclassID: classId, Macros.ApiKeys.kaskedDate: askedDate] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetTodayMealPlan, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Array<Dictionary<String,Any>>{
                        let arrForTodaysMealActivity = ActivityMeals.modelsFromDictionaryArray(array: data)
                        complition(arrForTodaysMealActivity)
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
    
    //MARK:---- Get Diaper Activity details API -----
    func getDiaperActivityDetails(with target:BaseViewController?, agencyID:Int, studentID:Int, studentAcitivityId:Int, complition:@escaping(Any?) -> Void){
        target?.showLoader()
        let param   =   [Macros.ApiKeys.kagencyID : agencyID, Macros.ApiKeys.kstudentID: studentID, Macros.ApiKeys.kstudentAcitivityId: studentAcitivityId] as [String : Any]
        super.startService(with: .POST, path: Macros.ServiceName.GetParticularStudentActivityDiaperChanges, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    if let data = (response as? Dictionary<String,Any>)?["data"] as? Dictionary<String,Any>{
                        let diaperActivity = ActivityDiper.init(dictionary: data)
                        complition(diaperActivity)
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


