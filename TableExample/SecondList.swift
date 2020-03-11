
import UIKit

class TableMusik: UITableViewController  {
    var array = [Substring]()
    var counter=0
    var counter2=0
    var searchLied=[Substring]()
    var searching=false
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var searchBar1: UISearchBar!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        tblView.dataSource=self
        searchBar1.delegate=self
        searchLied=array
    }

    
    func extractFile(filename:String)->String{
        var text=""
        if let path = Bundle.main.path(forResource: filename, ofType: "txt") {
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
             let myStrings = data.components(separatedBy: .newlines)
            text = myStrings.joined(separator: ",")
        } catch {
            print(error)
        }
    }
        return text
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchLied.count
        }
        else{
        if(counter2==0){
        let result=extractFile(filename:"MusiknotenRO")
        let fertiges_Array=result.split(separator: "," )
        for String in fertiges_Array{
        array.append(String)
        }
            counter2+=1
            array=array.sorted(by: <)
            searchLied=array
        }
    
        return searchLied.count  //Anzahl der Einträge
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            let fruitName = searchLied[indexPath.row]
            cell.textLabel?.text = "\(fruitName)"
        var indexOfFruitname=array.firstIndex(of: fruitName)
        indexOfFruitname!+=1
        cell.detailTextLabel?.text="Stueck Nummer (\(indexOfFruitname ?? 0))"
        return cell
        }
}
    extension TableMusik: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchLied = searchText.isEmpty ? array : array.filter { (item: Substring) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            tblView.reloadData()
    }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                searchBar1.showsCancelButton = true
        }
        
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                searchBar.showsCancelButton = false
                 searchBar1.text = ""
                 searchBar.resignFirstResponder()
                 searchLied=array
                 tableView.reloadData()
        }
}


