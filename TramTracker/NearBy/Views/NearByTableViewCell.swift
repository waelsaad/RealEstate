//
//  NearByTableViewCell.swift
//  TramTracker
//
//  Created by r00tdvd on 16/7/19 Copyright © 2019. All rights reserved.
//

import UIKit

class NearByTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    
    // MARK: - Methods - Overridden
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Cell Configuration Method
    func configCell(tram: Tram){
        destinationLabel.text = tram.destination
        arrivalTimeLabel.text = tram.currentTimeDifference
    }
}
