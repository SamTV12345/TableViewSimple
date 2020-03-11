
import UIKit

class FruitsTableViewController: UITableViewController {
    var array = [Substring]()
    var counter=0
    var loaded=false
    var searchLied=[Substring]()

    @IBOutlet weak var SearchBar1: UISearchBar!
    @IBOutlet var tblView: UITableView!
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource=self
        SearchBar1.delegate=self
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
         if(!loaded){
        let result=extractFile(filename:"MusiknotenSWO")
        let fertiges_Array=result.split(separator: "," )
        for String in fertiges_Array{
        array.append(String)
            }
            loaded=true
            array=array.sorted(by: <)
            searchLied=array
        }
    
        return searchLied.count  //Anzahl der Einträge
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
    extension FruitsTableViewController: UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchLied = searchText.isEmpty ? array : array.filter { (item: Substring) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            tableView.reloadData()
    }
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
                self.SearchBar1.showsCancelButton = true
        }
        
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                searchBar.showsCancelButton = false
                SearchBar1.text = ""
                searchBar.resignFirstResponder()
                searchLied=array
                tableView.reloadData()
        }
}


