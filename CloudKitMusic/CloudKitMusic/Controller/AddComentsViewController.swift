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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: nil, action: #selector(submitTapped))
        
    }
    
    @objc func submitTapped(){
        let submitController = SubmitViewController()
        submitController.genre = genre
        
        if comments.text == placeholder{
            submitController.genre = ""
        } else{
            submitController.comments = comments.text
        }
        
        navigationController?.pushViewController(submitController, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == placeholder{
            textView.text = ""
        }
    }
    
    override func loadView() {
        
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

}
