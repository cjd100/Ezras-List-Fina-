//
//  ListingTableViewCell.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var userLabel: UILabel!
    var categoryLabel: UILabel!
    var descriptionLabel: UILabel!
    var priceLabel: UILabel!
    
    let padding: CGFloat = 8
    let labelWidth: CGFloat = 120
    let labelHeight: CGFloat = 25
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        
        titleLabel = UILabel()
        //titleLabel.text = "hello"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        userLabel = UILabel()
        userLabel.font = UIFont.systemFont(ofSize: 12)
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(userLabel)
        
        categoryLabel = UILabel()
        categoryLabel.font = UIFont.systemFont(ofSize: 12)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        

        setupConstraints()
           
       }
    
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: labelWidth),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            ])
        
        NSLayoutConstraint.activate([
            userLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: labelWidth),
            userLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: labelWidth*2),
            categoryLabel.topAnchor.constraint(equalTo: userLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: labelWidth*3),
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor)
               ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor)
        ])
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
