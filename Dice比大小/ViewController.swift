//
//  ViewController.swift
//  Dice比大小
//
//  Created by ROSE on 2021/5/1.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    
    @IBOutlet var diceImages: [UIImageView]!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var dicesumText: UILabel!
    @IBOutlet weak var statusText: UITextView!
    @IBOutlet weak var moneyText: UILabel!
    @IBOutlet weak var gambleSelecter: UISegmentedControl!
    @IBOutlet weak var gambleMoney: UILabel!
    @IBOutlet weak var gamblemoneyStepper: UIStepper!

    let imageNames = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    var player: AVAudioPlayer?
    var money = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusText.layoutManager.allowsNonContiguousLayout = false
        }

    //賭了！按鈕壓下
    @IBAction func buttonPressed(_ sender: Any) {
        
        //優先判斷賭金是否足夠支付下注金額
        if Int(gamblemoneyStepper.value) > money {
            self.statusText.text = String("賭金不足！\n") + self.statusText.text
        }else{
            //通過判斷賭金後，為了禁止連續點擊，停用按鈕一段時間
            self.startButton.isEnabled = false
            //每次按下按鈕時都先把總合歸零，並開始跑骰子聲
            var diceSum = 0
            self.playSound(name: "dice_shake")
            //時間間隔起算
            let diceTime:TimeInterval = 1.42
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + diceTime)
            {
        
            //跑隨機骰子及計算總和
            for i in 0...5 {
            let diceNum = Int.random(in: 1...6)
            diceSum += diceNum
            self.diceImages[i].image = UIImage(named: self.imageNames[diceNum-1])
            }
            //將總和顯示在畫面上
            self.dicesumText.text = String(diceSum) + "點"
            //開始判斷大小21點情形
            switch diceSum
            {
            case 6...20:
                if self.gambleSelecter.selectedSegmentIndex == 0 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            case 22...36:
                if self.gambleSelecter.selectedSegmentIndex == 2 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            default:
                if self.gambleSelecter.selectedSegmentIndex == 1 {
                    self.win(Odds: 10)
                }else{
                    self.lose()
                }
            }
            self.startButton.isEnabled = true
            }
        }
    }
    
    @IBAction func addmoneyPressed(_ sender: Any) {
        money += 1000
        moneyUpdate()
        playSound(name: "cash")
        self.statusText.text += String("\n您加值了1000美金")
        showtextBottom()
    }
    
    @IBAction func moneystepperPressed(_ sender: Any) {
        gamblemoneyUpdate()
    }
    
    func showtextBottom(){
        statusText.scrollRangeToVisible(NSRange(location: .max, length: 0))
    }
    
    func gamblemoneyUpdate(){
        gambleMoney.text = "此次下注：" + String(format: "%.f", gamblemoneyStepper.value) + "美金"
    }
    
    func moneyUpdate(){
        moneyText.text = "總賭金：" + String(money) + "美金"
    }
    
    func playSound(name: String){
        //播放各種音效
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
        self.player = try? AVAudioPlayer(contentsOf: url)
        self.player?.play()
        }
    }

    func win(Odds: Double){
        self.playSound(name: "win")
        let gamoney = Int(Odds * self.gamblemoneyStepper.value)
        self.money += gamoney
        self.moneyUpdate()
        self.statusText.text += String("\n恭喜您贏了\(gamoney)美金，總賭金\(self.money)美金")
        showtextBottom()
    }
    
    func lose(){
        self.playSound(name: "lose")
        let gamoney = Int(self.gamblemoneyStepper.value)
        self.money -= gamoney
        self.moneyUpdate()
        self.statusText.text += String("\n您輸了\(gamoney)美金，總賭金\(self.money)美金")
        showtextBottom()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        //優先判斷賭金是否足夠支付下注金額
        if Int(gamblemoneyStepper.value) > money {
            self.statusText.text = String("賭金不足！\n") + self.statusText.text
        }else{
            //通過判斷賭金後，為了禁止連續點擊，停用按鈕一段時間
            self.startButton.isEnabled = false
            //每次按下按鈕時都先把總合歸零，並開始跑骰子聲
            var diceSum = 0
            self.playSound(name: "dice_shake")
            //時間間隔起算
            let diceTime:TimeInterval = 1.42
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + diceTime)
            {
        
            //跑隨機骰子及計算總和
            for i in 0...5 {
            let diceNum = Int.random(in: 1...6)
            diceSum += diceNum
            self.diceImages[i].image = UIImage(named: self.imageNames[diceNum-1])
            }
            //將總和顯示在畫面上
            self.dicesumText.text = String(diceSum) + "點"
            //開始判斷大小21點情形
            switch diceSum
            {
            case 6...20:
                if self.gambleSelecter.selectedSegmentIndex == 0 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            case 22...36:
                if self.gambleSelecter.selectedSegmentIndex == 2 {
                    self.win(Odds: 2)
                }else{
                    self.lose()
                }
            default:
                if self.gambleSelecter.selectedSegmentIndex == 1 {
                    self.win(Odds: 10)
                }else{
                    self.lose()
                }
            }
            self.startButton.isEnabled = true
            }
        }
    }
}
