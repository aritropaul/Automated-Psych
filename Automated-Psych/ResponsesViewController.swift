//
//  ResponsesViewController.swift
//  
//
//  Created by Aritro Paul on 05/04/19.
//

import UIKit

class ResponsesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var responses = [Question]()
    var score = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.textLabel?.text = responses[indexPath.row].question
        cell?.detailTextLabel?.text = responses[indexPath.row].answer
        return cell!
    }
    

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var responsesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        responsesTable.delegate = self
        responsesTable.dataSource = self
        calculateScore()
        // Do any additional setup after loading the view.
    }
    
    func calculateScore(){
        for response in responses{
            if response.answer.lowercased() == "always"{
                score+=4
            }
            if response.answer.lowercased() == "often"{
                score+=3
            }
            if response.answer.lowercased() == "at times"{
                score+=2
            }
            if response.answer.lowercased() == "rarely"{
                score+=1
            }
            print(score)
        }
        scoreLabel.text = "\(score)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
