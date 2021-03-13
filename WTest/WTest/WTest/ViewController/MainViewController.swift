//
//  ViewController.swift
//  WTest
//
//  Created by Rafael Costa Santos on 10/03/2021.
//

import UIKit
import CoreData


class MainViewController: UIViewController, URLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var bottomAnchorTableView: NSLayoutConstraint!
    
    var delegate: Protocol?
    var csvArray = [[String]]()
    var csvFile = [String]()
    var searchData: [PostalCode] = []
    var postalCodeArray: [PostalCode] = []
    var postalCodeStructArray: [PostalCodeStruct] = []
    var countOfCoreData: Int = 0
    
    let context = CoreDataManager.shared.persistentContainer.viewContext
    let postalCodeURL: String = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadLabel.text = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        checkContent()
    }
    
    // MARK: - Functions
    func checkContent() {
        postalCodeArray = try! context.fetch(PostalCode.fetchRequest())
        print(" postalCodeArray count: \(postalCodeArray.count)")
        
        if postalCodeArray.count != 0 && postalCodeArray.count > 326000 {
            DispatchQueue.main.async {
                self.downloadLabel.text = "\(self.postalCodeArray.count) Códigos Postais"
                self.tableView.reloadData()
            }
        } else {
            countOfCoreData = postalCodeArray.count
            downloadView.isHidden = false
            downloadCSVFile()
        }
    }

    func completeCoreData() {
        self.postalCodeArray = try! context.fetch(PostalCode.fetchRequest())
        
        DispatchQueue.main.async {
            self.downloadLabel.text = "\(self.postalCodeArray.count) Códigos Postais"
            self.tableView.reloadData()
        }
    }

    func showCurrentArray() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - SearchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            
            if self.postalCodeArray.count < 326000 {
                self.searchBar.endEditing(true)
            }
            
            self.searchData = []
            let newStr = searchText.lowercased()
            
            if newStr.contains("-") {
                let splitArr = searchText.split{$0 == "-"}.map(String.init)
                if splitArr.count < 2 {
                    self.searchData = self.postalCodeArray.filter { item in
                        return item.num_cod_postal!.lowercased().contains(splitArr[0])
                    }
                } else {
                    self.searchData = self.postalCodeArray.filter { item in
                        return item.num_cod_postal!.lowercased().contains(splitArr[0]) && item.ext_cod_postal!.lowercased().contains(splitArr[1])
                    }
                }
            } else if newStr.contains(" ") {
                let decimalCharacters = CharacterSet.decimalDigits
                let decimalRange = newStr.rangeOfCharacter(from: decimalCharacters)

                if decimalRange == nil {
                    let split = newStr.split{$0 == " "}.map(String.init)

                    if split.count < 2 {
                        self.searchData = self.postalCodeArray.filter { item in
                            return item.desig_postal!.lowercased().contains(split[0].lowercased())
                        }
                    } else {
                        self.searchData = self.postalCodeArray.filter { item in
                            return item.desig_postal!.lowercased().contains(newStr.lowercased())
                        }
                    }
                }
            } else {
                self.searchData = self.postalCodeArray.filter { item in
                    return item.num_cod_postal!.lowercased().contains(newStr.lowercased()) ||
                        item.ext_cod_postal!.lowercased().contains(newStr.lowercased()) ||
                        item.desig_postal!.lowercased().contains(newStr.lowercased())
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchData = []
        self.bottomAnchorTableView.constant = 0
        self.view.updateConstraintsIfNeeded()
        self.tableView.reloadData()
        self.searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    
        if self.postalCodeArray.count < 326000 {
            let alert = UIAlertController(title: "Aguarde até concluir o download.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
            return false
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.bottomAnchorTableView.constant = keyboardHeight
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchData.count != 0 ? self.searchData.count : self.postalCodeArray.count != 0 ? self.postalCodeArray.count : self.postalCodeStructArray.count

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = self.searchData.count != 0 ? searchData : self.postalCodeArray.count != 0 ? self.postalCodeArray : []
        
        if data.count != 0 {
            let postalCode = "\(data[indexPath.row].num_cod_postal!)-\(data[indexPath.row].ext_cod_postal!)"
            cell.textLabel?.text = "\(postalCode) \(data[indexPath.row].desig_postal!)"
        } else {
            let postalCode = "\(self.postalCodeStructArray[indexPath.row].num_cod_postal)-\(self.postalCodeStructArray[indexPath.row].ext_cod_postal)"
            cell.textLabel?.text = "\(postalCode) \(self.postalCodeStructArray[indexPath.row].desig_postal)"
        }
        
        return cell
    }
    
    // MARK: - URL Session
    func downloadCSVFile() {
        guard let url = URL(string: self.postalCodeURL ) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)

        try? FileManager.default.removeItem(at: destinationPath)

        do {
            try FileManager.default.copyItem(at: location, to: destinationPath)
            let pathURL = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            self.csvFile = try FileManager.default.contentsOfDirectory(atPath: pathURL)
            self.getCSVData( url: pathURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)");
        }
    }
    
    func getCSVData(url: String) {
        DispatchQueue.main.async {
            do {
                let fileURL = "\(url)/\(self.csvFile[0])"
                let content = try String(contentsOfFile: fileURL)
                let parsedCSV: [String] = content.components(separatedBy: "\n")
                
                for i in (1 ..< parsedCSV.count - 1) {
                    let newArr = parsedCSV[i].components(separatedBy: ",")
                    let postal = PostalCodeStruct(num_cod_postal: newArr[14], ext_cod_postal: newArr[15], desig_postal: newArr[16].capitalized)
                    self.postalCodeStructArray.append(postal);
                }

                self.showCurrentArray()
                self.setPostalCode()
            }
            catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    func setPostalCode() {
        DispatchQueue.global(qos: .userInteractive).async {
            for i in self.countOfCoreData ..< self.postalCodeStructArray.count {
                do {
                    let context = CoreDataManager.shared.persistentContainer.viewContext
                    let postCod = PostalCode(context: context)
                    postCod.desig_postal = self.postalCodeStructArray[i].desig_postal
                    postCod.num_cod_postal = self.postalCodeStructArray[i].num_cod_postal
                    postCod.ext_cod_postal = self.postalCodeStructArray[i].ext_cod_postal
                    try! context.save()
                }
                self.updateDownloadLabel(position: i, count:  self.postalCodeStructArray.count)
            }
            self.completeCoreData()
        }
    }
    
    func updateDownloadLabel(position: Int, count: Int){
        DispatchQueue.main.async {
            self.downloadView.isHidden = false
            self.downloadLabel.text = "Downloading \(position) of \(count)"
        }
    }
}
