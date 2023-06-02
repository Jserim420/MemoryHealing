import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!

    var messages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")

        // 테이블 뷰의 데이터 소스와 델리게이트를 설정합니다.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight = 1000 // 예상 셀 높이 값 설정 (원하는 크기로 변경 가능)
        
        


    }

    // 전송 버튼의 액션 메서드입니다.
    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = messageTextField.text, !message.isEmpty {
            messages.append(message)
            tableView.reloadData()
            messageTextField.text = ""
            tableView.layoutIfNeeded()
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
           cell.messageLabel.text = messages[indexPath.row]
           cell.messageLabel.numberOfLines = 0 // 여러 줄 표시를 위해 줄 수를 0으로 설정합니다.
           
           // UILabel의 크기를 동적으로 조정합니다.
           cell.messageLabel.sizeToFit()
           
           // UITableViewCell의 contentView 크기를 동적으로 조정합니다.
           cell.contentView.frame.size.height = cell.messageLabel.frame.size.height
        
        cell.messageLabel.textAlignment = .right
           
           return cell
       }
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row]
        cell.messageLabel.numberOfLines = 0 // 여러 줄 표시를 위해 줄 수를 0으로 설정합니다.
        
        // UILabel의 크기를 동적으로 조정합니다.
        cell.messageLabel.sizeToFit()
        
        // MessageCell의 messageView의 높이를 messageLabel의 높이에 맞게 설정합니다.
        let labelHeight = cell.messageLabel.frame.height
        cell.messageView.frame.size.height = labelHeight
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        
        // UILabel을 생성하여 메시지 내용을 설정합니다.
        let label = UILabel()
        label.text = message
        label.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정합니다.
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17) // 적절한 폰트 크기를 설정합니다.

        // UILabel의 사이즈를 계산합니다.
        let labelSize = label.sizeThatFits(CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        // 메시지 레이블과 여백 등을 고려하여 최종 셀 높이를 계산합니다.
        let finalHeight = labelSize.height + 16 // 예시로 16의 여백을 추가합니다.
        let minimumHeight: CGFloat = 10// 셀의 최소 높이
        
        return max(finalHeight, minimumHeight)
    }
    
}
