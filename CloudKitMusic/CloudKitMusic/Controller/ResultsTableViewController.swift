import CloudKit
import AVFoundation
import UIKit

//vou crirar um table view com duas seções, uma para sugestao e outra para mostrar as sugestoes das gravacoes
class ResultsTableViewController: UITableViewController {
    
    let cellID = "cellID"
    //pega as propriedades das gravacoes
    var whistle: Whistle!
    //pegará as sugestões do whistle, não são registrados juntos com whistle
    var suggestion = [String]()
    //recebera o gravacao que será tocada
    var whistlePlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //criei o titulo para navigation bar e button para download
        title = "Genre: \(whistle.genre!)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadTapped))
        
        //registrando table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        //pegando a referencia e comparando com a anterior, ordenando as sugestoes
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        let predicate = NSPredicate(format: "owningWhistle == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: "Suggestions", predicate: predicate)
        query.sortDescriptors = [sort]
    }
    
    @objc func downloadTapped(){
        //mostra a animacao dizendo que esta carregando os dados do cloudkit
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.tintColor = UIColor.black
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        //faz o download do cloudkit, verifica se a busca foi um sucesso ou não, sempre levando para o thread principal por manipular a interface do usuário
        //se foi um sucesso, ele pega o endereco e executa
        CKContainer.init(identifier: "iCloud.CloudKitMusic").publicCloudDatabase.fetch(withRecordID: whistle.recordID) { [unowned self] (record, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(self.downloadTapped))
                }
            } else {
                if let record = record {
                    if let asset = record["audio"] as? CKAsset {
                        self.whistle.audio = asset.fileURL
                        
                        DispatchQueue.main.async {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listen", style: .plain, target: self, action: #selector(self.listenTapped))
                        }
                    }
                 }
            }
        }
    }
    
    //funcao de acao que faz a executao do audio
    @objc func listenTapped(){
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: whistle.audio)
            whistlePlayer.play()
        } catch {
            let errorAlert = UIAlertController(title: "PlayBack Failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorAlert.addAction(errorAction)
           present(errorAlert, animated: true, completion: nil)
        }
    }
    
    //funcao que analisa os resultados, atualizando a interface do usuário
    internal func parseResults(records: [CKRecord]){
        var newSuggestions = [String]()
        
        for record in records {
            newSuggestions.append(record["text"] as! String)
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.suggestion = newSuggestions
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //so na seção dois(1), lembrando que começa no 0, terá o título
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Suggested songs"
        }
        
        return nil
    }
    
    //terá apenas uma linha a seção 1 (0) e a 2 terá quais sugestões o usuário colocar mais 1 para ser o botão de add mais
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return suggestion.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.section == 0{
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            
            //faço a verificaçao se o campo de comentários está vazio, se nao, coloco os comentarios na seçao
            if whistle.comments.count == 0 {
                cell.textLabel?.text = "Comments: None"
            } else{
                cell.textLabel?.text = whistle.comments
            }
        } else {
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            
            //se o número de linhas for igual ao número de sugestoes, coloco o texto para add mais
            //se não for, ele escreverá todas as sugestoes nas linhas
            if indexPath.row == suggestion.count{
                cell.textLabel?.text = "Add suggestion"
                cell.selectionStyle = .gray
            } else {
                cell.textLabel?.text = suggestion[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //verifico se foi selecionado a seção correta e se não não está vazio
        guard indexPath.section == 1 && indexPath.row == suggestion.count else { return }
        
        //desmarco a linha selcionada
        tableView.deselectRow(at: indexPath, animated: true)
        
        //atraves do alert vou add outra sugestao e submeter ao cloudkit
        let errorAlert = UIAlertController(title: "Suggest a song...;", message: nil, preferredStyle: .alert)
        errorAlert.addTextField { (textField: UITextField!) in
            textField.placeholder = "Suggests"
        }
        let actionSubmit = UIAlertAction(title: "Submit", style: .default) { [unowned self,errorAlert] action in
            if let textField = errorAlert.textFields?[0] {
                if textField.text!.count > 0 {
                    self.add(suggestion: textField.text!)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        errorAlert.addAction(actionSubmit)
        errorAlert.addAction(cancelAction)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    //aqui eu add a sugestao e também deleto
    //.deleteSelf deleta tudo, se o pai for excluido irá deletar todos filhos vinculadas a ele
    func add(suggestion: String){
        let whistleRecord = CKRecord(recordType: "Suggestions")
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        //faço os anexos das sugestoes e da referencia para envio posteriormente
        whistleRecord["text"] = suggestion as CKRecordValue
        whistleRecord["owningWhistle"] = reference as CKRecordValue
        
        //recarrego a table view de sugestoes e envio as sugestoes para o cloudkit
        CKContainer.init(identifier: "iCloud.CloudKitMusic").publicCloudDatabase.save(whistleRecord) { [unowned self] (whistle, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.suggestion.append(suggestion)
                    self.tableView.reloadData()
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "There was a problem submitting your suggestion: \(error!.localizedDescription)", preferredStyle: .alert)
                    let errorAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    errorAlert.addAction(errorAction)
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
}
