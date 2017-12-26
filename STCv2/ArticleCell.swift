//
//  ArticleCell.swift
//  STCv2
//
//  Created by Abdullah Alhazmi on 25/12/2017.
//  Copyright © 2017 Abdullah Alhazmi. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImg: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleContent: UILabel!

    func configureCell(article: Article) {
        
        if let title = article.title {
            //char spacing
            let attTitle = NSAttributedString(string: title.uppercased(), attributes: [NSAttributedStringKey.kern: 0.5])
            articleTitle.attributedText = attTitle
        }
        if let content = article.content {
            //char spacing
            let attContent = NSAttributedString(string: content, attributes: [NSAttributedStringKey.kern: 0.5])
            articleContent.attributedText = attContent
        }
        
        if let image_url = article.image {
            let url = URL(string: image_url)!
            let globalQueue = DispatchQueue.global(qos: .default)
            globalQueue.async {

                self.articleImg.downloadedFrom(url: url)
                
            }
            
        }
        
    }
        
}
