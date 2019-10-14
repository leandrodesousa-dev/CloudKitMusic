//
//  AddComentsViewController.swift
//  CloudKitMusic
//
//  Created by Leandro de Sousa Silva on 10/10/19.
//  Copyright © 2019 AcademyMistic. All rights reserved.
//

import UIKit

class AddComentsViewController: UIViewController, UITextViewDelegate {

    var genre: String!
    
    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identif"
    
    fileprivate func addCommentsSetup() {
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: nil, action: #selector(submitTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCommentsSetup()
    }
    
    @objc func submitTapped(){
        //faz toda a logica se o usuario quiser colocar algum comentário no audio gravado
        
        let submitController = SubmitViewController()
        submitController.genre = genre
        
        if comments.text == placeholder{
            submitController.genre = ""
        } else{
            submitController.comments = comments.text
        }
        
        navigationController?.pushViewController(submitController, animated: true)
    }
    
    //quando terminar de digitar, se tiver algo na caixa de texto será esvaziada
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == placeholder{
            textView.text = ""
        }
    }
    
    //construcao da tela da submit commits
    fileprivate func setupSubmitView() {
        view = UIView()
        view.backgroundColor = .white
        
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .title1)
        view.addSubview(comments)
        
        comments.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        comments.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func loadView() {
        
        setupSubmitView()
    }

}
