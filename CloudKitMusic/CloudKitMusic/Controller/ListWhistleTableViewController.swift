import UIKit
import CloudKit

//eu fui no inspetor de atributo da table view e coloquei 0(zero) no Prototype Cells, porque vou criar programaticamente 
class ListWhistleTableViewController: UITableViewController {

    static var isDirty = true
    var whistles = [Whistle]()
    internal let cellID = "CellID"
    
    //metódo que chama outra tela de gravacao
    @objc func addWhistle() {
           let recordController = RecordWhistleViewController()
           navigationController?.pushViewController(recordController, animated: true)
       }
    
    @objc func selectGenre(){
        let genreController = MyGenresTableViewController()
        navigationController?.pushViewController(genreController, animated: true)
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        buttonBackWistle()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Genres", style: .plain, target: self, action: #selector(selectGenre))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //limpará a exibição de tela da table view
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        //se for necessário chamará o método que carrega as informações do CloudKit
        if ListWhistleTableViewController.isDirty {
            loadWhistles()
        }
    }
    
    //método que faz a parte de pegar as informações do CloudKit
    internal func loadWhistles(){
       
        //é um filtro que usarei para ver quais resultados desejo obter
        let predicate = NSPredicate(value: true)
        //informará ao cloudkit qual campo que quero e se quero subir ou descer
        //let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        //vai retornar o id do whistles
        let query = CKQuery(recordType: "whistles", predicate: predicate)
        
        //faz o trabalho bruto nos dados do cloudkit, fazendo consultas e retornando resultados
        //traz dois fechamentos
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comments"]
        operation.resultsLimit = 50
        
        var newWhistles = [Whistle]()
        //primeiro fechamento traz os dados a mediaa que são baixados
        operation.recordFetchedBlock = {
            record in
            let whistle = Whistle()
            whistle.recordID = record.recordID
            whistle.genre = record["genre"]
            whistle.comments = record["comments"]
            newWhistles.append(whistle)
        }
        
        //segundo fechamento é chamado quando todos os registros são baixados
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            DispatchQueue.main.async {
                if error == nil {
                    ListWhistleTableViewController.isDirty = false
                    self.whistles = newWhistles
                    self.tableView.reloadData()
                } else {
                    let alertError = UIAlertController(title: "Fetch Failed", message: "There was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    let actionError = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertError.addAction(actionError)
                    self.present(alertError, animated: true, completion: nil)
                }
            }
        }
        //é preciso pedir ao cloudkit para excecutar o download dos dados
        CKContainer.init(identifier: "iCloud.CloudKitMusic").publicCloudDatabase.add(operation)
    }
    
    //método formata a string recebida de forma ordenada e correta
    internal func makeAttributedString(title: String, subtitle: String) -> NSAttributedString{
    
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        if subtitle.count > 0 {
            let subtitleString = NSAttributedString(string: "-\(subtitle)", attributes: subtitleAttributes)
            titleString.append(subtitleString)
        }
        
       return titleString
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let contentWhistles = whistles[indexPath.row]
        let labelCell = makeAttributedString(title: contentWhistles.genre, subtitle: contentWhistles.comments)
        
        //configuro o titulo do whistles e comentarios na cell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.attributedText = labelCell
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.whistles.count
    }
    
    //quando selecionar uma linha irá mandar a controller que cuida de análise de resultado
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resultsController = ResultsTableViewController()
        resultsController.whistle = whistles[indexPath.row]
        navigationController?.pushViewController(resultsController, animated: true)
    }
    
}

