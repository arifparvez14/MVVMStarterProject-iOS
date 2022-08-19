//
//  MovieViewModel.swift
//  Movie List
//

import Foundation
import UIKit

protocol MovieViewModelProtocol {
    var movieList: Bindable<[MovieResult]> { get }
    var movieListFetchStatus: Bindable<Bool> { get }
    func searchMovie(withQueryString query: String?)
}

class MovieViewModel: NSObject, MovieViewModelProtocol {
    var movieListFetchStatus: Bindable<Bool> = Bindable(false)
    var movieList: Bindable<[MovieResult]> = Bindable([])
    private var clientService: ClientService

    override init() {
        self.clientService = ClientService()
        super.init()
    }

    func searchMovie(withQueryString query: String?) {
        Log.info("Search movie with query string - \(String(describing: query))")
        self.clientService.searchMovie(query: query) { [weak self] movieList in
            guard let `self` = self else { return }
            switch movieList {
            case .success(let list):
                self.movieList.value = list.results.map({ (movie) -> MovieResult in
                    var returnMovie = movie
                    returnMovie.cellHeight = self.calculateCellHeight(forItem: movie)
                    returnMovie.posterUrl = URL(string: baseImageUrl + (returnMovie.posterPath ?? "")) ?? nil
                    return returnMovie
                })
                self.movieListFetchStatus.value = true

            case .failure(let error):
                self.movieListFetchStatus.value = false
                Log.info(error.localizedDescription)
            }
        }
    }

    private func calculateCellHeight(forItem item: MovieResult) -> CGFloat {
        let labelWidth = UIScreen.main.bounds.width - posterImageWidth - 68     //68 = 3*16 (item gap) + 20 (safe area)
        let overViewLabelFont = UIFont.systemFont(ofSize: labelFontSize)
        let titleLabelFont = UIFont.boldSystemFont(ofSize: labelFontSize)
        let overViewLabelHeight = item.overview?.height(withConstrainedWidth: labelWidth, font: overViewLabelFont)
        let titleLabelHeight = item.title?.height(withConstrainedWidth: labelWidth, font: titleLabelFont)
        let totalHeight = titleLabelHeight! + overViewLabelHeight! + 40     //40 = 3*10 (item gap) + 10 padding
        return totalHeight > defaultCellHeight ? totalHeight : defaultCellHeight
    }
}
