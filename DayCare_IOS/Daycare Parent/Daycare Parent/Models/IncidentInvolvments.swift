

import Foundation

public class IncidentInvolvments:NSObject {
	public var id : Int?
	public var agencyID : Int?
	public var studentID : Int?
	public var studentName : String?
	public var classesID : Int?
	public var className : String?
	public var incidentID : Int?
	public var stringId : Int?
	public var isActive : Bool?
	public var isDeleted : Bool?
	public var deletedBy : Int?
	public var deletedDate : String?
	public var createdBy : Int?
	public var createdDate : String?
	public var updatedDate : String?
	public var updatedBy : Int?

    public override init() {
        super.init()
    }
   
    
    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [IncidentInvolvments]
    {
        var models:[IncidentInvolvments] = []
        for item in array
        {
            models.append(IncidentInvolvments(dictionary: item)!)
        }
        return models
    }


	required public init?(dictionary: Dictionary<String,Any>) {

		id = dictionary["id"] as? Int ?? 0
		agencyID = dictionary["agencyID"] as? Int ?? 0
		studentID = dictionary["studentID"] as? Int ?? 0
		studentName = dictionary["studentName"] as? String ?? ""
		classesID = dictionary["classesID"] as? Int ?? 0
		className = dictionary["className"] as? String ?? ""
		incidentID = dictionary["incidentID"] as? Int ?? 0
		stringId = dictionary["stringId"] as? Int ?? 0
		isActive = dictionary["isActive"] as? Bool ?? false
		isDeleted = dictionary["isDeleted"] as? Bool ?? false
		deletedBy = dictionary["deletedBy"] as? Int ?? 0
		deletedDate = dictionary["deletedDate"] as? String ?? ""
		createdBy = dictionary["createdBy"] as? Int ?? 0
		createdDate = dictionary["createdDate"] as? String ?? ""
		updatedDate = dictionary["updatedDate"] as? String ?? ""
		updatedBy = dictionary["updatedBy"] as? Int ?? 0
	}


	public func dictionaryRepresentation() -> Dictionary<String,Any> {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.agencyID, forKey: "agencyID")
		dictionary.setValue(self.studentID, forKey: "studentID")
		dictionary.setValue(self.studentName, forKey: "studentName")
		dictionary.setValue(self.classesID, forKey: "classesID")
		dictionary.setValue(self.className, forKey: "className")
		dictionary.setValue(self.incidentID, forKey: "incidentID")
		dictionary.setValue(self.stringId, forKey: "stringId")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isDeleted, forKey: "isDeleted")
		dictionary.setValue(self.deletedBy, forKey: "deletedBy")
		dictionary.setValue(self.deletedDate, forKey: "deletedDate")
		dictionary.setValue(self.createdBy, forKey: "createdBy")
		dictionary.setValue(self.createdDate, forKey: "createdDate")
		dictionary.setValue(self.updatedDate, forKey: "updatedDate")
		dictionary.setValue(self.updatedBy, forKey: "updatedBy")

		return dictionary as! Dictionary<String,Any>
	}

}
