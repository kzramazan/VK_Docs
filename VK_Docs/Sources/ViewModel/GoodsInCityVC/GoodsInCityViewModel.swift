//
//  GoodsInCityViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/29/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import RxSwift

class GoodsInCityViewModel {
    let disposeBag = DisposeBag()
    
    private var marketList = [MarketGroup]()
    var selectedCity: City? = City(id: 1, title: "Санкт-Петербург")
    func getMarketList(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        getMarketListApi(cityID: selectedCity?.id ?? 1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let response = result.response {
                    self.marketList = response.items
                }
                success()
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getNumberOfRows() -> Int {
        return marketList.count
    }
    
    func getMarket(row: Int) -> MarketGroup {
        return marketList[row]
    }
    
    func getMarketList() -> [MarketGroup] {
        return marketList
    }
}

private extension GoodsInCityViewModel {
    func getMarketListApi(cityID: Int) -> Observable<VKCustomResult<[MarketGroup]>> {
        ApiClient.shared.request(VKCustomGroupsRouter.searchShops(cityID.description))
    }
}


class GoodsInGroupsViewModel {
    let disposeBag = DisposeBag()
    private let groupID: Int
    let groupName: String?
    
    private var goodsList = [GoodInGroup]()
    
    init(groupID: Int, groupName: String?) {
        self.groupID = groupID
        self.groupName = groupName
    }
    
    func fetchGoods(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        fetchGoodsApi(groupID: groupID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let items = result.response?.items {
                    self.goodsList = items
                }
                success()
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getNumberOfRows() -> Int {
        return goodsList.count
    }
    
    func getGood(row: Int) -> GoodInGroup {
        return goodsList[row]
    }
}

private extension GoodsInGroupsViewModel {
    func fetchGoodsApi(groupID: Int) -> Observable<VKCustomResult<[GoodInGroup]>> {
        return ApiClient.shared.request(VKCustomMarketRouter.get(groupID.description))
    }
}
