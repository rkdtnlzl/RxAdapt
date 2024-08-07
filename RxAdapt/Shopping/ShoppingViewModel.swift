//
//  ShoppingViewModel.swift
//  RxAdapt
//
//  Created by 강석호 on 8/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    
    struct Input {
        let addItemTrigger: Observable<String>
        let deleteItemTrigger: Observable<IndexPath>
        let selectItemTrigger: Observable<ShoppingItem>
        let toggleCheckmarkTrigger: Observable<Int>
        let collectionItemSelected: Observable<String>
    }
    
    struct Output {
        let items: Driver<[ShoppingItem]>
        let showEditItem: Observable<(Int, ShoppingItem)>
        let collectionItemAdded: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    let itemsRelay = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(title: "그립톡 구매하기", isChecked: false),
        ShoppingItem(title: "사이다 구매", isChecked: false),
        ShoppingItem(title: "아이패드 최저가 알아보기", isChecked: false),
        ShoppingItem(title: "양말 구매하기", isChecked: false)
    ])
    
    func transform(input: Input) -> Output {
        
        input.addItemTrigger
            .map { ShoppingItem(title: $0, isChecked: false) }
            .withLatestFrom(itemsRelay) { newItem, currentItems in
                return currentItems + [newItem]
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
        
        input.deleteItemTrigger
            .withLatestFrom(itemsRelay) { indexPath, currentItems in
                var newItems = currentItems
                newItems.remove(at: indexPath.row)
                return newItems
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
        
        input.toggleCheckmarkTrigger
            .withLatestFrom(itemsRelay) { index, currentItems in
                var newItems = currentItems
                newItems[index].isChecked.toggle()
                return newItems
            }
            .bind(to: itemsRelay)
            .disposed(by: disposeBag)
        
        let showEditItem = input.selectItemTrigger
            .withLatestFrom(itemsRelay) { selectedItem, currentItems -> (Int, ShoppingItem)? in
                guard let index = currentItems.firstIndex(where: { $0.title == selectedItem.title }) else { return nil }
                return (index, selectedItem)
            }
            .compactMap { $0 }
        
        let collectionItemAdded = input.collectionItemSelected
        
        return Output(
            items: itemsRelay.asDriver(),
            showEditItem: showEditItem,
            collectionItemAdded: collectionItemAdded
        )
    }
}
