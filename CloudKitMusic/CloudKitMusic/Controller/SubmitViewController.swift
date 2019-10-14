import CloudKit
import UIKit

class SubmitViewController: UIViewController {
    
    var genre: String!
    var comments: String!

    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "You're all set!"
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Zero -> CloudKit
    //comeca o processo de enviar dados para cloudkit
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        doSubmission()
    }

    func doSubmission(){
       
        //CKRecord = é um tipo de dicionário que pega qualquer valor válido
        //criando as chaves para subir as informacoes do genero e comentarios do usuário
        let whistleRecord = CKRecord(recordType: "Whistles")
        whistleRecord["genre"] = genre as CKRecordValue
        whistleRecord["comments"] = comments as CKRecordValue
        
        //CKAsset = armazena valores de blobs binários
        //depois é so anexar ao CKRecorder como um valor válido
        //criando a chave para subir o audio gravado pelo usuario
        let audioURL = RecordWhistleViewController.getWhistleUrl()
        let whistleAsset = CKAsset(fileURL: audioURL)
        whistleRecord["audio"] = whistleAsset
        
        //CKContainer é onde fica os bancos de daods, que pode ser privado ou público que são os CKDatebase
        //mandei para outra thread o processo de salvar os arquivos no CloudKit
        CKContainer.init(identifier: "iCloud.CloudKitMusic").publicCloudDatabase.save(whistleRecord) { [unowned self] record, error in
        DispatchQueue.main.async {
            if let error = error{
                self.status.text = "Error: \(error.localizedDescription)"
                self.spinner.stopAnimating()
            } else {
                self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                
                self.status.text = "Done"
                self.spinner.stopAnimating()
                
                ViewController.isDirty = true
        }
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
            }
        }
    }
    
    @objc func doneTapped() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .gray
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont.preferredFont(forTextStyle: .title1)
        status.textColor = .white
        status.numberOfLines = 0
        status.textAlignment = .center
        
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
    }
}
