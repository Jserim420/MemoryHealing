import Foundation

struct ChatGPTResponse: Codable {
    let choices: [ChatGPTChoice]
}

struct ChatGPTChoice: Codable {
    let message: ChatGPTMessage
    let finish_reason: String
    let index: Int
}

struct ChatGPTMessage: Codable {
    let role: String
    let content: String
}

class ChatBot {
    let apiKey = "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" // 여기에 OpenAI API 키를 넣어주세요
    let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!

    var messages: [[String: String]]?

    init() {
        self.messages = [
            ["role": "system", "content": "너는 내 고민을 들어주고 공감해주는 내 친한 친구야. 친구처럼 친근하게 내 고민을 들어줘."],
            ["role": "user", "content": "나 고민이 있어..."],
            ["role": "assistant", "content": "무슨 일인데? 이야기 해보면서 마음의 부담을 덜어보는 건 어때요? 전 언제든지 들어줄게요."],
            ["role": "user", "content": "반말로 친한 친구처럼 이야기하자.."],
            ["role": "assistant", "content": "네, 그래! 무슨 일이 있나 이야기 해봐! 함께 해결해보자."],
            ["role": "user", "content": "반말로 이야기 해줘"],
            ["role": "assistant", "content": "안녕? 고민이 뭐야?"],
            ["role": "user", "content": "안녕?"],
            ["role": "assistant", "content": "안녕? 고민이 뭐야? 나한테 언제든지 이야기 해봐. 난 언제나 너의 편이야"],
            
        ]
    }

    // 응답 생성
    // param: String question, completion: @escaping (String?) -> Void
    func makeRequest(question: String, completion: @escaping (String?) -> Void) {
        print("Bot.makeRequest(); 응답생성")
        
        guard var messages = self.messages else {
            print("메시지가 설정되지 않았습니다.")
            completion(nil)
            return
        }
        
        
        let requestData: [String: Any] = [
            "messages": messages,
            "max_tokens": 1000,
            "model": "gpt-3.5-turbo"
        ]
        
        sendRequest(requestData: requestData) { reply in
            completion(reply)
        }
    }


    // 응답을 보내서 정상적인 응답이 받아지면 completion handler를 호출하여 응답을 전달
    // param: [String: Any] requestData, completion: @escaping (String?) -> Void
    private func sendRequest(requestData: [String: Any], completion: @escaping (String?) -> Void) {
        print("Bot.sendRequest(); json 파싱")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData)

            var request = URLRequest(url: baseURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("오류: \(error)")
                    completion(nil)
                } else if let data = data {
                    do {
                        print("응답 데이터: \(String(data: data, encoding: .utf8) ?? "")")

                        let decoder = JSONDecoder()
                        let responseJSON = try decoder.decode(ChatGPTResponse.self, from: data)
                        if let reply = responseJSON.choices.first?.message.content {
                            print("응답: \(reply)")
                            completion(reply)
                        } else {
                            print("잘못된 응답 형식")
                            completion("잘못된 응답 형식")
                        }
                    } catch {
                        print("응답 데이터 구문 분석 실패")
                        completion("응답 데이터 구문 분석 실패")
                    }
                }
            }
            task.resume()
        } catch {
            print("JSON 데이터 생성 실패")
            completion("JSON 데이터 생성 실패")
        }
    }


    // 다른 메서드 등
}
