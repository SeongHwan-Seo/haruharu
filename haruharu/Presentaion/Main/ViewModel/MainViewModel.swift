//
//  MainViewModel.swift
//  haruharu
//
//  Created by SHSEO on 2023/02/14.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class MainViewModel {
    let db = DatabaseManager.shared
    
    let habits = BehaviorSubject<[Habit]>(value:[])
    let user = BehaviorSubject(value: User())
    let disposeBag = DisposeBag()
    let versionUrl = "http://itunes.apple.com/kr/lookup?bundleId=com.shseo.haruharu"
    let storeUrl = "itms-apps://itunes.apple.com/app/id6446077663"
    let isUpdate = BehaviorRelay(value: false)
    
    init() {
        print("MainViewModel init -")
        checkForUpdate()
        fetchHabits()
        fetchUser()
    }
    
    /// 앱스토어 이동
    func goToStore() {
        if let storeUrl = URL(string: storeUrl) {
            UIApplication.shared.open(storeUrl)
        }
    }
    
    func checkForUpdate() {
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                // 현재 앱 버전을 가져올 수 없는 경우 처리 로직
                return
            }
        
            guard let url = URL(string: versionUrl) else {
                // URL 형식이 잘못된 경우 처리 로직
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // 데이터를 가져올 수 없는 경우 처리 로직
                    return
                }
                
                guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let results = result["results"] as? [[String: Any]],
                    let latestVersion = results.first?["version"] as? String else {
                        // 최신 버전을 가져올 수 없는 경우 처리 로직
                        return
                }
                
                // 최신 버전이 현재 버전보다 높은 경우 업데이트 알림을 띄움
                if latestVersion > currentVersion {
                    self.isUpdate.accept(true)
                }
            }.resume()
        }
    
    func fetchHabits() {
        let habit = db.fetchHabits()
        
        Observable.changeset(from: habit)
            .subscribe(onNext: { [weak self] array, changes in
                guard let self = self else { return }
                self.habits.onNext(array.toArray())
            })
            .disposed(by: disposeBag)
    }
    
    func fetchUser() {
        let user = db.fetchUser()
        
        Observable.changeset(from: user)
            .subscribe(onNext: { [weak self] array, changes in
                guard let self = self else { return }
                self.user.onNext(array.toArray()[0])
            })
            .disposed(by: disposeBag)
        
    }
    
    
    
}
