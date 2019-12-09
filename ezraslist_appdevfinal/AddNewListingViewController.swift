//
//  AddNewListingViewController.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

import UIKit

class AddNewListingViewController: UIViewController {

        var questionLabel: UILabel!
        var titleField: UITextField!
        var userField: UITextField!
        var categoryField: UITextField!
        var descriptionField: UITextField!
    var priceField: UITextField!

        var cancelButton: UIButton!
        var saveButton: UIButton!
        
        
        let labelHeight: CGFloat = 16
        let padding: CGFloat = 8
        
        var Listings: [Listing]!
        var delegate: addNewListingDelegate?

        

        
        init(Listings: [Listing]){
            self.Listings = Listings
            super.init(nibName: nil, bundle: nil)
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white

            questionLabel = UILabel()
            questionLabel.text = "Enter New Listing Details"
            
            questionLabel.translatesAutoresizingMaskIntoConstraints = false
            questionLabel.textColor = .black
            view.addSubview(questionLabel)
            
            titleField = UITextField()
            titleField.text = "Listing Title"
            titleField.clearsOnBeginEditing = true
            titleField.borderStyle = .roundedRect
            titleField.backgroundColor = .white
            titleField.translatesAutoresizingMaskIntoConstraints = false
            titleField.textColor = .black
            view.addSubview(titleField)
            
            userField = UITextField()
            userField.text = "User"
            userField.clearsOnBeginEditing = true
            userField.borderStyle = .roundedRect
            userField.backgroundColor = .white
            userField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(userField)
            
            categoryField = UITextField()
            categoryField.text = "Category"
            categoryField.clearsOnBeginEditing = true
            categoryField.borderStyle = .roundedRect
            categoryField.backgroundColor = .white
            categoryField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(categoryField)
            
            descriptionField = UITextField()
            descriptionField.text = "Description"
            descriptionField.clearsOnBeginEditing = true
            descriptionField.borderStyle = .roundedRect
            descriptionField.backgroundColor = .white
            descriptionField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionField)
            
            priceField = UITextField()
            priceField.text = "Price (leave out $)"
                     priceField.clearsOnBeginEditing = true
                     priceField.borderStyle = .roundedRect
                     priceField.backgroundColor = .white
                     priceField.translatesAutoresizingMaskIntoConstraints = false
                     view.addSubview(priceField)
            
            
            
            
            cancelButton = UIButton()
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.backgroundColor = .yellow
            cancelButton.setTitleColor(.black, for: .normal)
            cancelButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            view.addSubview(cancelButton)
            
            saveButton = UIButton()
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            saveButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            saveButton.setTitle("Add Listing", for: .normal)
            saveButton.backgroundColor = .yellow
            saveButton.setTitleColor(.black, for: .normal)
            saveButton.addTarget(self, action: #selector(dismissViewControllerAndSaveText), for: .touchUpInside)
            view.addSubview(saveButton)
            
            
            setUpConstraints()
            
        }
        
        func setUpConstraints(){
            
            NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            questionLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: padding+30),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            titleField.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            NSLayoutConstraint.activate([
            userField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: padding),
            userField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userField.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            NSLayoutConstraint.activate([
            categoryField.topAnchor.constraint(equalTo: userField.bottomAnchor, constant: padding),
            categoryField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            categoryField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            categoryField.heightAnchor.constraint(equalToConstant: 24)
            ])
            
            NSLayoutConstraint.activate([
            descriptionField.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: padding),
            descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            descriptionField.heightAnchor.constraint(equalToConstant: 24)
            ])
            NSLayoutConstraint.activate([
            priceField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: padding),
            priceField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            priceField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            priceField.heightAnchor.constraint(equalToConstant: 24)
            ])
            
                
             
            // button constraints
           
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 200),
                cancelButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -150),
                cancelButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: 150),
                cancelButton.heightAnchor.constraint(equalToConstant: 48)
                ])
            
            NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 200),
            saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
            ])

           
            
        }
        @objc func dismissViewController() {
                      dismiss(animated: true, completion: nil)
        }
        @objc func dismissViewControllerAndSaveText() {
            if let title = titleField.text, let user = userField.text, let category = categoryField.text, let description = descriptionField.text, let price = priceField.text{
                if(title != "" && user != "" && category != ""){
                    
                  
                   let jsonObject: [String: Any] = [
                       "name": title,
                       "description": description,
                       "category": category,
                       "price": price,
                       "user": user
                   ]

                    
                    
                    NetworkManager.addListing(parameters:jsonObject) {
                        DispatchQueue.main.async{}
                        
                    }
                    
                }
            }
           

            dismiss(animated: true, completion: nil)
            
        }
        

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

}


