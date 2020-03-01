//
//  CitySelectionViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import RxSwift

class CitySelectionViewModel {
    let disposeBag = DisposeBag()
    private var cities = [City]()
    private var selectedState = [Bool]()
    var lastSelectedRow: Int?
    
    init(lastSelectedCity: Int) {
        lastSelectedRow = findSelectedCityRow(id: lastSelectedCity)
    }
    
    func getCities(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        selectedState = []
        getCitiesApi()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let items = result.response?.items {
                    self.cities = items
                    for i in 0...items.count - 1 {
                        if let lastSelectedRow = self.lastSelectedRow, i == lastSelectedRow {
                            self.selectedState.append(true)
                        }else {
                            self.selectedState.append(false)
                        }
                    }
                }
                success()
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getCity(row: Int) -> City {
        return cities[row]
    }
    
    func getNumberOfRows() -> Int {
        return cities.count
    }
    
    func getSelectState(row: Int) -> Bool {
        return selectedState[row]
    }
    
    func selectCity(row: Int) {
        selectedState[row] = true
    }
    
    func deselectCity(row: Int) {
        selectedState[row] = false
    }
}

private extension CitySelectionViewModel {
    func getCitiesApi() -> Observable<VKCustomResult<[City]>> {
        return ApiClient.shared.request(VKCustomDatabaseRouter.getCities)
    }
    
    func findSelectedCityRow(id: Int) -> Int? {
        let row = cities.firstIndex { (city) -> Bool in
            city.id == id
        }
        
        return row
    }
}
