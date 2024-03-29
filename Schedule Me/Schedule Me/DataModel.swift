import Foundation
import CoreData

class CoreDataModel: DataManagerDelegate {

    var activities: [ActivityMO]!
    var dayThisWeek: [DayMO]!
    
    
    static let sharedInstance = CoreDataModel()
    let dataManager = DataManager.sharedInstance
    
    private init(){
    }
    
    var xcDataModelName: String = "Schedule Me"
    internal func createDatabase() {
    }
    
    
    
    
    func addActivity(name: String, category: String, isFixed: Bool, isConsistent: Bool, isAdded: Bool, activityValue: Int16, choiceSlot: [daySchedule]){
            let activityMO = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: dataManager.managedObjectContext) as! ActivityMO
        activityMO.name = name
        activityMO.category = category
        activityMO.fixed = isFixed
        activityMO.consistent = isConsistent
        activityMO.activityValue = activityValue
        //activityMO.choiceSlotDay = [daySchedule]
        dataManager.saveContext()
    }
}





//
//func fillWithExamples() -> [Activity]{
//    let exampleSchedule: [Activity] = [class1,class2,class3,class4,health1,health2,work1,rec1,chore1]
//    return exampleSchedule
//}
//
//
//
//// Academic**
//let class1 = Activity(name: "Biology Class", category: "Academic", isFixed: true, isConsistent: true, isAdded: false, activityValue: 8)
//let class2 = Activity(name: "Computer Vision", category: "Academic", isFixed: true, isConsistent: true, isAdded: false, activityValue: 10)
//let class3 = Activity(name: "BBH 109", category: "Academic", isFixed: true, isConsistent: true, isAdded: false, activityValue: 3)
//let class4 = Activity(name: "EDSGN100", category: "Academic", isFixed: true, isConsistent: true, isAdded: false, activityValue: 6)
//
////  Health**
//let health1 = Activity(name: "Weight Lifting", category: "Health", isFixed: false, isConsistent: true, isAdded: false, activityValue: 7)
//let health2 = Activity(name: "Running", category: "Health", isFixed: false, isConsistent: true, isAdded: false, activityValue: 7)
//
//// Extra-Curricular**
//let work1 = Activity(name: "Tutoring", category: "Extra-Curricular", isFixed: true, isConsistent: true, isAdded: false, activityValue: 10)
//
//// Recreational**
//let rec1 = Activity(name: "Play Games", category: "Chores", isFixed: false, isConsistent: false, isAdded: false, activityValue: 1)
//
//// Chores**
//let chore1 = Activity(name: "Clean Room", category: "Chores", isFixed: false, isConsistent: true, isAdded: false, activityValue: 4)
//
//
//
