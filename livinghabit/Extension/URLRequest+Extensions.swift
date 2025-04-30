//
//  URLRequest+Extensions.swift
//  livinghabit
//
//  Created by najak on 4/30/25.
//

import Foundation

struct Resource<T> {
    let url: URL
}

//간단한 에러 정의
enum NetworkError: Error {
    case domainError
    case urlError
    case decodingError
}

extension URLRequest {
    static func load<T : Decodable> (resource: Resource<T>,
                                     completion: @escaping (Result<T, NetworkError>) -> Void)  {
        //1. URLSession 정의
        let urlSession = URLSession(configuration: .default)
        //2. URSSession 의 dataTask에 url을 전달하고 응답에 대한 completion 핸들러 등록
        // 람다로 전달된 completion 핸들러는 dataTask에서 완료시 호출됨
        urlSession.dataTask(with: resource.url) { (data , response, error) in
            //데이터가 nil 이고, error 값이 있는 경우 실패로 해당 결과 전달
            guard let data = data, error == nil else {
                //UI에 대한 변경은 main 스레드에서만 가능하므로 해당 결과로 뷰를 수정하는 경우를
                //대비해 main 큐에서 실행되도록 등록
                DispatchQueue.main.async {
                    completion(.failure(.urlError))
                }
                return
            }
            // 정상적으로 데이터를 수신하는 경우. JSONDecoder를 통해 T 타입의 구조체 생성
            //여기서는 WeatherData 가 생성됨
            if let result = try? JSONDecoder().decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume() //3.URLSession에 dataTask 수행
    }
}
