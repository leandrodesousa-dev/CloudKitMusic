import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {

        //stack view que fica os buttons
        var stackView: UIStackView!
        //botão de gravação
        var recordButton: UIButton!

        //ativa e rastrear a gravaçao de som como um todo
        var recordingSession: AVAudioSession!
        //rastrea uma gravação individual
        var whistleRecorder: AVAudioRecorder! = nil

        //esse métoda criar e carrega alguma apresentação e atribui a view principal
        //posso gerenciar as exibições
        //aqui fica a base, e se eu quiser acrescentar algum detlhe, coloco no viewDidLoad
        override func loadView() {
            
            //instanciando a view propriedade(principal)
            view = UIView()
            view.backgroundColor = UIColor.gray
            
            stackView = UIStackView()
            //espaçamento entre os elementos
            stackView.spacing = 30
            //não autorizo o auto ajuste do layout
            stackView.translatesAutoresizingMaskIntoConstraints = false
            //a forma como deve ser distribuida na stack view
            stackView.distribution = UIStackView.Distribution.fillEqually
            //o aliamento da stack
            stackView.alignment = .center
            //e o formato de stack
            stackView.axis = .vertical
            
            view.addSubview(stackView)
            
            //auto-layout
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }

        //se caso seja um sucesso a permissao, será gravado
        fileprivate func loadRecordingUI(){
            recordButton = UIButton()
            recordButton.translatesAutoresizingMaskIntoConstraints = false
            recordButton.setTitle("Tap of Record", for: .normal)
            /* esse metodo faz com o texto se adapte a fonte padrao do iphone
            nao precisamos nos preocupar em dimensionar, fará automaticamente*/
            recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
            
            //MARK: Insight StackView
            //Nunca add diretamente o subview em uma stack view por causa do auto-layout, usa-se existe o método específico para isso, já add e faz auto ajuste.
            stackView.addArrangedSubview(recordButton)
           }
       
        //caso não seja permitido, dá erro
       fileprivate func loadFailUI(){
            let failLabel = UILabel()
        /*esse metodo faz com o texto se adapte a fonte padrao do iphone
        nao precisamos nos preocupar em dimensionar, fará automaticamente */
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "Recording failed: please ensure the app has access to your microphone"
        failLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(failLabel)
       }
    
    fileprivate func backButton() {
        //criacao do botao para voltar a tela de gravacao
        title = "Record yout whistle"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
    }
    
    class func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
       
        return documentsDirectory
    }
    
    class func getWhistleUrl() -> URL{
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    func startRecoding(){
        //colocando o fundo vermelho para dizer que esta sendo gravado
        view.backgroundColor = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1)
        
        //muda o titulo do botao para toque para parar
        recordButton.setTitle("Tap to stop", for: .normal)
        
        //buscar onde foi salvo a gravacao
        let audioURL = RecordWhistleViewController.getWhistleUrl()
        print(audioURL.absoluteURL)
        
        //criar dicionario para as configuracoes do audio
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 1200,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        /*Criei um objeto AVAudioRecorder para direcionar o URL da gravação
        coloquei esse objeto como delegado
         chamei o record desse objeto
         */
        
        do{
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            print("aqui: \(whistleRecorder)")
            //Tem que coloca o protocolo delegate desse método
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
          finishRecording(success: false)
        }
    }
    
    fileprivate func finishRecording(success: Bool){
        
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to re-record", for: .normal)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Next", style: .plain , target: self, action: #selector(nextTapped))
        } else {
            recordButton.setTitle("Tap to record", for: .normal)
            
            let errorAlert = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
        }
        
    }
    
    @objc func nextTapped(){
        
    }
    
    @objc func recordTapped(){
        if whistleRecorder == nil{
            startRecoding()
        } else {
            finishRecording(success: true)
        }
    }

    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        backButton()
            
            //retorna a instancia do audio gravado
            recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                /*preciso ir no info para solicitar também
                retorna a respota do usuário se podemos gravar ou nao*/
                recordingSession.requestRecordPermission { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed{
                            self.loadRecordingUI()
                        } else {
                            self.loadFailUI()
                        }
                    }
                }
            } catch {
                self.loadFailUI()
            }
        }
    
    }
