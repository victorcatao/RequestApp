//
//  ViewController.swift
//  RequestApp
//
//  Created by Victor Catão on 22/01/22.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Properties
    
    private(set) var movies: [Movie] = []
    private let service: MoviesServiceable

    // MARK: LifeCycle

    init(service: MoviesServiceable) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadTableView()
    }
    
    // MARK: Methods
    
    private func fetchData(completion: @escaping (Result<TopRated, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = try await service.getTopRated()
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.tableView.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showDetail(`for` movie: Movie) {
        Task(priority: .background) {
            let result = try await service.getMovieDetail(id: movie.id)
            switch result {
            case .success(let movieResponse):
                showModal(
                    title: movieResponse.originalTitle,
                    message: movieResponse.overview
                )
            case .failure(let error):
                showModal(title: "Error", message: error.customMessage)
            }
        }
    }
    
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView Methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = movies[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetail(for: movies[indexPath.row])
    }
}
