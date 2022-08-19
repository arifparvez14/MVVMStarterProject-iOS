//
//  ViewController.swift
//  Movie List
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var noItemView: UIView!
    
    private var searchController = UISearchController()
    private var spinner = UIActivityIndicatorView()
    private var viewModel = MovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.info("viewDidLoad [+]")
        self.title = viewTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.setUpTableView()
        self.setUpSearchController()
        self.bindViewModelData()
        self.spinner = self.showLoader(view: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.searchMovie(withQueryString: nil)
        }
    }

    private func setUpTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: tableViewCellName, bundle: nil), forCellReuseIdentifier: tableViewCellName)
    }

    private func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar.delegate = self
    }

    private func bindViewModelData() {
        viewModel.movieListFetchStatus.bindAndFire { [weak self] success in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                if success {
                    self.showTableView(flag: self.viewModel.movieList.value.count > 0)
                    self.movieTableView.reloadData()
                    self.searchController.searchBar.text = nil
                    self.searchController.searchBar.showsCancelButton = false
                }
                self.spinner.dismissLoader(view: self.view)
            }
        }
    }

    private func showTableView(flag: Bool) {
        self.movieTableView.isHidden = !flag
        self.noItemView.isHidden = flag
    }

    func showLoader(view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        spinner.backgroundColor = .black.withAlphaComponent(0.5)
        spinner.layer.cornerRadius = 5.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = .large
        spinner.color = .white
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        view.isUserInteractionEnabled = false
        return spinner
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.movieList.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.movieList.value[indexPath.row].cellHeight ?? defaultCellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellObject = tableView.dequeueReusableCell(withIdentifier: tableViewCellName, for: indexPath)
        guard let cell = cellObject as? MovieTableViewCell else {
            return UITableViewCell()
        }

        cell.configCell(
            title: viewModel.movieList.value[indexPath.row].title,
            overview: viewModel.movieList.value[indexPath.row].overview,
            posterUrl: viewModel.movieList.value[indexPath.row].posterUrl)

        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.spinner = self.showLoader(view: self.view)
        viewModel.searchMovie(withQueryString: searchBar.text)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}
