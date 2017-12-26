//
//  DetailViewController.swift
//  STCv2
//
//  Created by Abdullah Alhazmi on 25/12/2017.
//  Copyright © 2017 Abdullah Alhazmi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailContent: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let title = detailTitle {
                title.text = detail.title.uppercased()
            }
            if let content = detailContent {
                content.text = detail.content
            }
            if let image = detailImage {
                let url = URL(string: (detailItem?.image)!)!
                image.downloadedFrom(url: url)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Article? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

