//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Evgenii Rtischev on 25.04.2022.
//

import UIKit

final class MainViewController: UITableViewController {

    private let weatherProvider: WeatherProviderProtocol = ServiceLocator.shared.weatherProvider
    private let locationProvider: LocationProviderProtocol = ServiceLocator.shared.locationProvider

    private var weathers = [WeatherPresentation]()
    private var offline = true
    
    override func loadView() {
        super.loadView()
        let refresh = UIRefreshControl()
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(update), for: .valueChanged)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move this to interactor
        weatherProvider.getLast { [unowned self] cachedWeather in
            DispatchQueue.global(qos: .userInitiated).async {
                let presentations = cachedWeather.enumerated().map { WeatherPresentation(from: $0.element, dayFromToday: $0.offset) }
                DispatchQueue.main.async {
                    self.weathers = presentations
                    self.tableView.reloadData()
                }
            }
        }
        update()
    }

    @objc private func update() {
        tableView.refreshControl?.beginRefreshing()

        // Move this to interactor
        locationProvider.get { [unowned self] result in
            switch result {
            case .success(let location):
                self.weatherProvider.get(for: location) { [unowned self] weatherResult in
                    switch weatherResult {
                    case .success(let weather):
                        let presentations = weather.enumerated().map { WeatherPresentation(from: $0.element, dayFromToday: $0.offset) }
                        DispatchQueue.main.async {
                            self.weathers = presentations
                            self.offline = false
                            self.tableView.reloadData()
                            self.tableView.refreshControl?.endRefreshing()
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.showMessage(error.localizedDescription)
                            self.tableView.refreshControl?.endRefreshing()
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showMessage(error.localizedDescription)
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weathers.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MainViewCell {
            cell.update(with: weathers[indexPath.row], grayed: offline)
            return cell
        }
        return UITableViewCell()
    }
}

private extension MainViewController {

    func showMessage(_ text: String) {
        print(text)
        // TODO: - implement UI for showing errors
    }
}
