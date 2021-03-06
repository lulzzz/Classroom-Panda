//
//  DailySheetsVC.swift
//  Daycare
//
//  Created by amrut waghmare on 24/12/18.
//  Copyright © 2018 amrut waghmare. All rights reserved.
//

import UIKit
import DropDown
import ActionSheetPicker_3_0
import SDWebImage

class DailySheetsVC: BaseViewController {
   
    @IBOutlet weak var btnForCalender: UIButton!
    @IBOutlet weak var lblForDay: UILabel!
    @IBOutlet weak var lblForMonthYear: UILabel!
    @IBOutlet weak var lblForDate: UILabel!
    @IBOutlet weak var btnForToddler: UIButton!
    @IBOutlet weak var imgForDropdownArrow: UIImageView!
    @IBOutlet weak var collectionViewForDailysheet: UICollectionView!
    @IBOutlet weak var btnForAdd: UIButton!
    @IBOutlet weak var btnForSelection: CustomLoginButton!
    
    var refreshControl = UIRefreshControl()
    let dropDownForClasses  =   DropDown()
    var arrForDailySheet    =   [DailySheet]()
    var arrForSelectedStudent : [DailySheet] = []
    var arrForClass         :   [Class]     = []
    var arrForOperationalClass : [Class]?
    var selectedClass       :   Class?
    var selectedDate        :   Date?
    var isFirstLoad:Bool = true
    
     //MARK:----- View functions -----
    override func viewDidLoad() {
        super.viewDidLoad()
         initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.apiForGetAllClasses()
        if AppInstance.shared.currentCheckInClass.classesID == 0 || AppInstance.shared.currentCheckInClass.classesID == nil {
            self.btnForSelection.isHidden = true
        } else {
            self.btnForSelection.isHidden = false
        }
         self.btnForSelection.isHidden = self.isPreviousDate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
    }
    
    //MARK:----- @IBActions -----
    @IBAction func actionForSelection(_ sender: UIButton) {
        if btnForSelection.title(for: .normal) == Macros.ControllerStrings.DailySheetVC.selectAll {
            btnForSelection.setTitle(Macros.ControllerStrings.DailySheetVC.deselectAll, for: .normal)
            self.arrForSelectedStudent.removeAll()
            for i in 0..<self.arrForDailySheet.count {
                self.arrForDailySheet[i].isSelected = true
                self.arrForSelectedStudent.append(self.arrForDailySheet[i])
                if let cell = collectionViewForDailysheet.cellForItem(at: IndexPath(item: i, section: 0)) as? DailySheetCollectionViewCell {
                    cell.btnForSelection.setImage(UIImage(named: "checked"), for: .normal)
                }
            }
        } else {
            self.arrForSelectedStudent.removeAll()
            for i in 0..<self.arrForDailySheet.count {
                self.arrForDailySheet[i].isSelected = false
                if let cell = collectionViewForDailysheet.cellForItem(at: IndexPath(item: i, section: 0)) as? DailySheetCollectionViewCell {
                    cell.btnForSelection.setImage(UIImage(named: "unchecked"), for: .normal)
                }
            }
            btnForSelection.setTitle(Macros.ControllerStrings.DailySheetVC.selectAll, for: .normal)
        }
        self.btnForAdd.isHidden = arrForSelectedStudent.count > 0 ? false : true
    }
    
    @IBAction func actionForClassSelection(_ sender: Any) {
        if !self.isPreviousDate() {
            if AppInstance.shared.currentCheckInClass.classesID == 0 || AppInstance.shared.currentCheckInClass.classesID == nil {
                self.showAlert(with: Macros.alertMessages.pleaseCheckedInClass)
            } else {
                imgForDropdownArrow.image = UIImage(named: "arrowUp")
                dropDownForClasses.show()
            }
        } else {
            imgForDropdownArrow.image = UIImage(named: "arrowUp")
            dropDownForClasses.show()
        }
    }
    
    @IBAction func actionForAddDailySheet(_ sender: Any) {
        let vc = self.getViewController(storyboardIdentifire: Macros.Identifiers.Storyboard.Other, vcIdentifire: Macros.Identifiers.Controller.AddDailySheetVC) as! AddDailySheetVC
        vc.arrForSelectedStudent = self.arrForSelectedStudent
        vc.selectedClass = self.selectedClass
        vc.selectedActivityDate = self.selectedDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionForDateSelection(_ sender: UIButton) {
        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: .date, selectedDate: self.selectedDate ?? Date(), doneBlock: {
            picker, value, index in
            let dateTime    = value as! Date
            self.lblForDay.text = CommonClassMethods.dayNameFromDate(date: dateTime)
            self.lblForMonthYear.text = CommonClassMethods.monthNameFromDate(date:dateTime) + " " + CommonClassMethods.yearFromDate(date: dateTime)
            self.lblForDate.text = CommonClassMethods.dateFromDate(date: dateTime)
            if CommonClassMethods.convertDateWithoutTime(date: self.selectedDate ?? Date()) != CommonClassMethods.convertDateWithoutTime(date: dateTime){
                self.selectedDate = dateTime
                if !self.isPreviousDate() {
                    
                    if (self.arrForOperationalClass?.count ?? 0) > 0 {
                        self.selectedClass = self.arrForOperationalClass?[0]
                        self.btnForSelection.isHidden = false
                    } else {
                        self.selectedClass = nil
                        self.btnForToddler.setTitle("Select", for: .normal)
                        self.btnForSelection.isHidden = true
                    }
                } else {
                    if self.selectedClass == nil || self.selectedClass?.className == "" ||
                        self.selectedClass?.className == nil {
                        if self.arrForClass.count > 0 {
                            self.selectedClass = self.arrForClass[0]
                            self.btnForSelection.isHidden = false
                        }
                    }
                }
                
                self.btnForSelection.isHidden = self.isPreviousDate()
                
                self.apiForGetDailySheet(classId: self.selectedClass?.classesID ?? 0, askedDate: CommonClassMethods.convertDateToServerReadableFormatGET(date: self.selectedDate ?? Date()))
            }
            return
        }, cancel: { ActionStringCancelBlock in return }, origin:sender)
        datePicker?.maximumDate = Date()
        datePicker?.show()
    }
    
    @objc func actionForDetail(_ sender: UIButton){
        let vc = self.getViewController(storyboardIdentifire: Macros.Identifiers.Storyboard.Other, vcIdentifire: Macros.Identifiers.Controller.DailySheetDetailVC) as! DailySheetDetailVC
        vc.dailySheetStudent = self.arrForDailySheet[sender.tag]
        vc.selectedDate = self.selectedDate
        vc.selectedClass = self.selectedClass
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func actionForRefresh(sender:AnyObject) {
        apiForGetDailySheet(classId: selectedClass?.classesID ?? 0, askedDate: CommonClassMethods.convertDateToServerReadableFormatGET(date: selectedDate ?? Date()))
    }
    
    //MARK:----- Functions -----
    
    func initialSetup(){
        self.navigationController?.navigationBar.layer.removeAllAnimations()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.setNavigationBar(title: Macros.NavigationTitle.DailySheet)
        self.selectedDate = Date()
        self.lblForDay.text = CommonClassMethods.dayNameFromDate(date: selectedDate ?? Date())
        self.lblForMonthYear.text = CommonClassMethods.monthNameFromDate(date:selectedDate ?? Date()) + " " + CommonClassMethods.yearFromDate(date: selectedDate ?? Date())
        self.lblForDate.text = CommonClassMethods.dateFromDate(date: selectedDate ?? Date())
        self.btnForAdd.isHidden = true
        refreshControl.attributedTitle = NSAttributedString(string: Macros.refresh)
        refreshControl.addTarget(self, action: #selector(actionForRefresh(sender:)), for: UIControl.Event.valueChanged)
        collectionViewForDailysheet.addSubview(refreshControl)
    }
    
    //Classes Dropdown list
    func setupClassesDropDown(){
        var arrForClassDropDown:[Class] = []
        if CommonClassMethods.convertDateWithoutTime(date: selectedDate ?? Date()) == CommonClassMethods.convertDateWithoutTime(date: Date()) {
            arrForClassDropDown = arrForOperationalClass ?? []
        } else {
            arrForClassDropDown = arrForClass
        }
        dropDownForClasses.anchorView = btnForToddler
        dropDownForClasses.bottomOffset = CGPoint(x: 0, y: btnForToddler.bounds.height)
        dropDownForClasses.dataSource = arrForClassDropDown.map{$0.className ?? ""}
        dropDownForClasses.selectionAction = { [weak self] (index, item) in
            self?.btnForToddler.setTitle(self?.dropDownForClasses.dataSource[index], for: .normal)
            if self?.selectedClass?.className != arrForClassDropDown[index].className {
                self?.selectedClass = arrForClassDropDown[index]
                self?.apiForGetDailySheet(classId: self?.selectedClass?.classesID ?? 0, askedDate: CommonClassMethods.convertDateToServerReadableFormatGET(date: self?.selectedDate ?? Date()))
            }
            self?.imgForDropdownArrow.image = UIImage(named: "arrowDown")
        }
        dropDownForClasses.cancelAction = { [unowned self] in
            self.imgForDropdownArrow.image = UIImage(named: "arrowDown")
        }
    }
    
    func isPreviousDate() -> Bool {
        return   (CommonClassMethods.convertDateWithoutTime(date: self.selectedDate ?? Date()) != CommonClassMethods.convertDateWithoutTime(date: Date()))
    }
    
    //MARK:----- API Calling Function -----
    func apiForGetAllClasses(){
        let service = AttendanceService()
        service.getAllClasses(with: self, agencyID: AppInstance.shared.user?.agencyID ?? 0) { (result) in
            if let arrForClasses = result as? [Class]{
                self.arrForClass = arrForClasses
                if AppInstance.shared.currentCheckInClass.classesID == 0 || AppInstance.shared.currentCheckInClass.classesID == nil {
                    self.isFirstLoad = false
                    self.collectionViewForDailysheet.reloadData()
                    if !self.isPreviousDate() {
                        self.showAlert(with: Macros.alertMessages.pleaseCheckedInClass)
                    }
                }else {
                    self.apiCallGetTeacherCurrentOperationalClass()
                }
            }
        }
    }
    
    func apiCallGetTeacherCurrentOperationalClass(){
        let service = DashboarService()
        service.getTeacherCurrentOperationalClass(with: self, agencyID: AppInstance.shared.user?.agencyID ?? 0, askingDate: CommonClassMethods.convertDateToServerReadableFormat(date: Date()), teacherID: AppInstance.shared.teacher?.id ?? 0, teacherDailyAttendanceID: AppInstance.shared.user?.teacherTodayAttendenceId ?? 0) { (result) in
            if result != nil {
                self.arrForOperationalClass = []
                let operationalClassArray:[OperationalClass] = result as? [OperationalClass] ?? []
                
                let arrClassesID = operationalClassArray.map{$0.value}
                self.arrForOperationalClass = self.arrForClass.filter{arrClassesID.contains($0.classesID)}
//                for classes in self.arrForClass {
//                    for operationalClass in operationalClassArray {
//                        if classes.classesID == operationalClass.value {
//                            self.arrForOperationalClass?.append(classes)
//                        }
//                    }
//                }
                if self.selectedClass == nil {
                    if (self.arrForOperationalClass?.count ?? 0) > 0 {
                        self.selectedClass = self.arrForOperationalClass?[0]
                    }
                }
                (self.selectedClass == nil || self.selectedClass?.className == "" || self.selectedClass?.className == nil) ? self.btnForToddler.setTitle("Select", for: .normal) : self.btnForToddler.setTitle(self.selectedClass?.className, for: .normal)
                self.apiForGetDailySheet(classId: self.selectedClass?.classesID ?? 0, askedDate: CommonClassMethods.convertDateToServerReadableFormatGET(date: self.selectedDate ?? Date()))
                self.setupClassesDropDown()
            }
        }
    }
    
    func apiForGetDailySheet(classId:Int,askedDate:String){
        self.setupClassesDropDown()
        self.btnForAdd.isHidden = true
        self.arrForSelectedStudent = []
        let service = DailySheetService()
        service.getDailySheetList(with: self, agencyID: AppInstance.shared.user?.agencyID ?? 0, classID: classId, askedDate: askedDate) { (result) in
            if result != nil {
                self.refreshControl.endRefreshing()
                self.isFirstLoad = false
                self.arrForDailySheet = result as? [DailySheet] ?? []
                self.btnForToddler.setTitle(self.selectedClass?.className, for: .normal)
                self.collectionViewForDailysheet.reloadData()
            } else {
                self.arrForDailySheet = []
                self.collectionViewForDailysheet.reloadData()
            }
        }
    }
}

//MARK:----- DailySheet CollectionView Datasource and Delegates -----
extension DailySheetsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFirstLoad ? 0 : (arrForDailySheet.count == 0) ? 1 : arrForDailySheet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrForDailySheet.count != 0 {
            return customDailySheetCell(_:collectionView,indexPath:indexPath)
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Macros.Identifiers.Cells.DailySheetNoRecordFound, for: indexPath) as? DailySheetNoRecordFound {
            return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (arrForDailySheet.count != 0) ? CGSize(width: self.view.bounds.width / 2.2, height: 210) : CGSize(width: self.view.bounds.width, height: 145)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isPreviousDate() {
            if arrForDailySheet.count != 0 {
                let cell = collectionView.cellForItem(at: indexPath) as? DailySheetCollectionViewCell
                if cell?.btnForSelection.image(for: .normal) == UIImage(named: "unchecked") {
                    cell?.btnForSelection.setImage(UIImage(named: "checked"), for: .normal)
                    self.arrForDailySheet[indexPath.item].isSelected = true
                    self.arrForSelectedStudent.append(arrForDailySheet[indexPath.item])
                    if self.arrForSelectedStudent.count == self.arrForDailySheet.count {
                        self.btnForSelection.setTitle(Macros.ControllerStrings.DailySheetVC.deselectAll, for: .normal)
                    }
                } else {
                    let selectedStudentID = self.arrForDailySheet[indexPath.item].studentID
                    self.arrForDailySheet[indexPath.item].isSelected = false
                    for i in 0..<(self.arrForSelectedStudent.count) {
                        if selectedStudentID == self.arrForSelectedStudent[i].studentID {
                            self.arrForSelectedStudent.remove(at: i)
                            break
                        }
                    }
                    cell?.btnForSelection.setImage(UIImage(named: "unchecked"), for: .normal)
                    self.btnForSelection.setTitle(Macros.ControllerStrings.DailySheetVC.selectAll, for: .normal)
                }
                self.btnForAdd.isHidden = arrForSelectedStudent.count > 0 ? false : true
            }
        }
    }
    
    func customDailySheetCell(_ collectionView:UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Macros.Identifiers.Cells.DailySheetCollectionViewCell, for: indexPath) as? DailySheetCollectionViewCell {
            cell.lblForName.text = arrForDailySheet[indexPath.item].studentName ?? ""
            cell.lblForClassName.text = arrForDailySheet[indexPath.item].className ?? ""
            cell.btnForMoreActivities.isHidden = ((arrForDailySheet[indexPath.item].totalActivityCount ?? 0) > 2) ? false : true
            cell.btnForDetail.tag = indexPath.item
            
            cell.btnForDetail.addTarget(self, action: #selector(actionForDetail(_:)), for: .touchUpInside)
            cell.btnForActivity1.isHidden = true
            cell.btnForActivity2.isHidden = true
            self.arrForDailySheet[indexPath.item].isSelected ?? false ? cell.btnForSelection.setImage(UIImage(named: "checked"), for: .normal) : cell.btnForSelection.setImage(UIImage(named: "unchecked"), for: .normal)
                cell.imgViewForProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray

//            cell.imgViewForProfile.sd_setShowActivityIndicatorView(true)
//            cell.imgViewForProfile.sd_setIndicatorStyle(.gray)
            cell.imgViewForProfile.sd_setImage(with: URL(string: arrForDailySheet[indexPath.row].imagePath ?? "")) { (image, error, type, url) in
                if (error != nil) {
                    cell.imgViewForProfile.image = UIImage(named: "placeholder")
                }
            }
            cell.viewForNoActivityFound.isHidden = (arrForDailySheet[indexPath.item].activityDetail?.count ?? 0) == 0 ? false : true
            cell.btnForDetail.isEnabled = (arrForDailySheet[indexPath.item].activityDetail?.count ?? 0) == 0 ? false : true
            for i in 0..<(arrForDailySheet[indexPath.item].activityDetail?.count ?? 0){
                let activity = arrForDailySheet[indexPath.item].activityDetail?[i]
                switch i {
                case 0:
                    self.setActivityButtonImage(activity: activity ?? ActivityDetail(), button: cell.btnForActivity1)
                case 1:
                    self.setActivityButtonImage(activity: activity ?? ActivityDetail(), button: cell.btnForActivity2)
                case 2:
                    cell.btnForMoreActivities.setTitle("+\((arrForDailySheet[indexPath.item].activityDetail?.count ?? 0) - 2)", for: .normal)
                default:
                    print("Invalid Case")
                }
            }
            cell.btnForSelection.isHidden = self.isPreviousDate()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func setActivityButtonImage(activity:ActivityDetail,button: UIButton){
        switch activity.activityTypeID {
        case ActivityTypeID.Health:
            button.isHidden = false
            button.setImage(UIImage.init(named: "healthL"), for: .normal)
        case ActivityTypeID.Notes:
            button.isHidden = false
            button.setImage(UIImage.init(named: "noteL"), for: .normal)
        case ActivityTypeID.Meal:
            button.isHidden = false
            button.setImage(UIImage.init(named: "mealL"), for: .normal)
        case ActivityTypeID.Mood:
            button.isHidden = false
            button.setImage(UIImage.init(named: "moodL"), for: .normal)
        case ActivityTypeID.Activity:
            button.isHidden = false
            button.setImage(UIImage.init(named: "activityL"), for: .normal)
        case ActivityTypeID.Nap:
            button.isHidden = false
            button.setImage(UIImage.init(named: "napL"), for: .normal)
        case ActivityTypeID.Diper:
            button.isHidden = false
            button.setImage(UIImage.init(named: "diperL"), for: .normal)
        default:
            print("Invalid Case")
        }
    }
}

//MARK:----- Daily sheet CollectionView Cell -----
class DailySheetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgViewForProfile: UIImageView!
    @IBOutlet weak var lblForName: UILabel!
    @IBOutlet weak var lblForClassName: UILabel!
    @IBOutlet weak var btnForSelection: UIButton!
    @IBOutlet weak var btnForActivity1: UIButton!
    @IBOutlet weak var btnForActivity2: UIButton!
    @IBOutlet weak var btnForMoreActivities: UIButton!
    @IBOutlet weak var btnForDetail: UIButton!
    @IBOutlet weak var viewForNoActivityFound: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewForProfile.cornerRadius = imgViewForProfile.bounds.height/2
        // Initialization code
    }
}

//MARK:----- Daily sheet Empty Cell -----
class DailySheetNoRecordFound: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
