
import UIKit

extension RecordWhistleViewController {
    
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
     internal func loadRecordingUI(){
         recordButton = UIButton()
         recordButton.translatesAutoresizingMaskIntoConstraints = false
         recordButton.setTitle("Tap of Record", for: .normal)
         /* esse metodo faz com o texto se adapte a fonte padrao do iphone
         nao precisamos nos preocupar em dimensionar, fará automaticamente*/
         recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
         recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
        playButtonSetup()
        
         //MARK: Insight StackView
         //Nunca add diretamente o subview em uma stack view por causa do auto-layout, usa-se existe o método específico para isso, já add e faz auto ajuste.
         stackView.addArrangedSubview(recordButton)
        }
    
     //caso não seja permitido, dá erro
     internal func loadFailUI(){
         let failLabel = UILabel()
     /*esse metodo faz com o texto se adapte a fonte padrao do iphone
     nao precisamos nos preocupar em dimensionar, fará automaticamente */
     failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
     failLabel.text = "Recording failed: please ensure the app has access to your microphone"
     failLabel.numberOfLines = 0
     
     stackView.addArrangedSubview(failLabel)
    }
    
}
