//
//  MainViewCell.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import UIKit

final class MainViewCell: UITableViewCell {
    @IBOutlet private weak var morningIcon: UIImageView!
    @IBOutlet private weak var morningTemp: UILabel!
    @IBOutlet private weak var dayIcon: UIImageView!
    @IBOutlet private weak var dayTemp: UILabel!
    @IBOutlet private weak var nightIcon: UIImageView!
    @IBOutlet private weak var nightTemp: UILabel!

    func update(with weather: WeatherPresentation, grayed: Bool) {
        morningTemp.text = weather.morningTemp
        dayTemp.text = weather.dayTemp
        nightTemp.text = weather.nightTemp

        [morningIcon, dayIcon, nightIcon].forEach {
            $0?.tintColor = grayed ? .lightGray : .black
        }
        [textLabel, morningTemp, dayTemp, nightTemp].forEach {
            $0?.textColor = grayed ? .lightGray : .black
        }

        textLabel?.text = weather.day
    }
}
