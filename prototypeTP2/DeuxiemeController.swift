
import UIKit
//--------------------------
class DeuxiemeController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //--------------------------les connections
    @IBOutlet weak var course_grade_tableview: UITableView!
    @IBOutlet weak var student_name_label: UILabel!
    @IBOutlet weak var course_field: UITextField!
    @IBOutlet weak var grade_field: UITextField!
    
    
    //--------------------------les types des pseudonymes creés
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    
     //--------------------------les tableaux qui vont être formés
    let userDefautsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    var ArrOfCourses: [course]!
    var arrOfGrades: [grade]!
    
    //--------------------------lorsque le document est prêt
    override func viewDidLoad() {
        super.viewDidLoad()
        student_name_label.text = userDefautsObj.getValue(theKey: "name") as? String
        loadUserDefaults()
        fillUpArray()
        average.text = Average(dictDeNotes: moyenne(), regleDe3:{ $0 * 100.0 / $1})     
    }
    
    //--------------------------cela va remplir les 3 label
    func fillUpArray() {
    let name = student_name_label.text
    let courses_and_grades = studentGrades[name!]
    ArrOfCourses = [course](courses_and_grades!.keys)
    arrOfGrades = [grade](courses_and_grades!.values)
    }
    
    
    //--------------------------cela va donner les paramètres de la tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrOfCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = course_grade_tableview.dequeueReusableCell(withIdentifier: "proto")!
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = ArrOfCourses[indexPath.row]
        }
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrOfGrades[indexPath.row])
        }
        
        
        return cell
    }
    
    
     //-------------------------------- pour supprimer le row dans le tableview
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == UITableViewCellEditingStyle.delete {
        let name = student_name_label.text
        var courses_and_grades = studentGrades[name!]!
        let note = [course](courses_and_grades.keys)[indexPath.row]
        courses_and_grades[note] = nil
        studentGrades[name!] = courses_and_grades
        userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
        fillUpArray()
        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        average.text = Average(dictDeNotes: moyenne(), regleDe3:{ $0 * 100.0 / $1})
     }
     }
  
    //--------------------------garder en mémoire studentGrades
    func loadUserDefaults(){
        if userDefautsObj.doesKeyExist(theKey: "grades"){
            studentGrades = userDefautsObj.getValue(theKey: "grades") as!
                [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
 //--------------------------le bouton qui quand touché va mettre les deux paramètre dans la rangée de la tableview et miser à jour le general average à chaque nouvelle note qui entre
    @IBAction func ssave_corse_and_grade(_ sender: UIButton) {
        let name = student_name_label.text!
        var student_courses = studentGrades[name]!
        student_courses[course_field.text!] = Double(grade_field.text!)
        studentGrades[name] = student_courses
        userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
        fillUpArray()
        course_grade_tableview.reloadData()
        average.text = Average(dictDeNotes: moyenne(), regleDe3:{ $0 * 100.0 / $1})
    }
    
   //--------------------------la fonction moyenne pour donner le resultat dans le champ Average avec un produit croisé
    @IBOutlet weak var average: UILabel!
    
    func Average(dictDeNotes: [Double: Double], regleDe3: (_ somme: Double, _ sur: Double) -> Double) -> String{
        
        let sommeNotes = [Double](dictDeNotes.keys).reduce(0, +)
        let sommesur = [Double](dictDeNotes.values).reduce(0, +)
        let conversion = regleDe3(sommeNotes, sommesur)
        return String(format: "General average = %0.1f/%0.1f or %0.1f%%/100%%", sommeNotes, sommesur, conversion)
        
    }
    
    func moyenne () ->  [Double: Double] {
        let average = arrOfGrades.reduce(0, +)
        let somme = arrOfGrades.count
        let moyenne = Double(average/Double(somme))
        let dictNotes = [moyenne: 10.0]
        return dictNotes
    }

}

