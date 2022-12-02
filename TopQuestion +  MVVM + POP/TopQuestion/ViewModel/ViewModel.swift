//
//  ViewModel.swift
//  TopQuestion
//
//  Created by Muhammad Ariful Islam on 30/11/22.
//

import Foundation

class ViewModel {
    private var questions: [Question] = []
    private var isLoading = false

    private var request: APIRequest<QuestionsResource>?
    private var imageRequest: ImageRequest?

    func fetchQuestionData() {
        guard !isLoading else { return }
        isLoading = true
        let resource = QuestionsResource()
        let request = APIRequest(resource: resource)
        self.request = request
        request.execute{[weak self] questions in
            self?.questions = questions ?? []
            self?.loadOwnerAvatar(question: questions![0])
        }
    }
}

private extension ViewModel {
    func loadOwnerAvatar(question: Question) {
        guard let url = question.owner?.profileImageURL else { return }
        let imageRequest = ImageRequest(url: url)
        self.imageRequest = imageRequest
        imageRequest.execute { [weak self] image in
            print(image?.size)
            self?.isLoading = false
        }
    }
}

