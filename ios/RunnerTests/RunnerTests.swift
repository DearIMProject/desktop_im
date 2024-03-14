import Flutter
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  func testExample() {
      if let url = URL(string: "https://172.16.92.73:8888/user/login") {
          // 创建URLSession配置
          let config = URLSessionConfiguration.default
          let session = URLSession(configuration: config)
          
          // 创建请求任务
          let task = session.dataTask(with: url) { (responseData, response, responseError) in
              // 处理错误
              if let error = responseError {
                  print("Error: \(error)")
              } else if let jsonData = responseData {
                  // 尝试解析JSON数据
                  do {
                      // 尝试将JSON数据转换为字典
                      if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                          print("Response JSON: \(json)")
                      }
                  } catch {
                      print("Error: \(error.localizedDescription)")
                  }
              }
          }
          
          // 启动任务
          task.resume()
      }
      
  }

    
    
}
