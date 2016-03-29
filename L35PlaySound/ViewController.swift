//
//  ViewController.swift
//  L35PlaySound
//
//  Created by GuanZhipeng on 16/3/26.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var aPlayer:AVAudioPlayer!
    var mP: Float!
    
    @IBOutlet weak var musicTime: UILabel!
    @IBOutlet weak var musicProgress: UISlider!
    @IBAction func playBtnClicked(sender: AnyObject) {
        aPlayer.play()
        refreshMP()
    }
    @IBAction func pauseBtnClicked(sender: AnyObject) {
        aPlayer.pause()
        setMP()
    }
    @IBAction func stopBtnClicked(sender: AnyObject) {
        aPlayer.stop()
        aPlayer.currentTime = 0
        setMP()
    }
    
    @IBAction func musicProgressChanged(sender: AnyObject) {
        mP = musicProgress.value
        aPlayer.currentTime = aPlayer.duration * Double(mP)
        setMP()
        if aPlayer.playing {
            aPlayer.play()
        }else{
            aPlayer.pause()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try aPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!)) //需要自己拖入一个音频文件
        }catch {
            print("Initialize aPlayer ERROR")
        }
        mP = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshMP() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while self.aPlayer.playing {
                self.mP = Float(self.aPlayer.currentTime/self.aPlayer.duration)
                dispatch_async(dispatch_get_main_queue(), {
                    self.setMP()
                })
                sleep(1)
            }
            })
        
    }
    
    func setMP() {
        self.musicProgress.setValue(self.mP, animated: true)
        self.musicTime.text = "\(self.convertTime(Float(self.aPlayer.currentTime)))/\(self.convertTime(Float(self.aPlayer.duration)))"
    }
    
    func convertTime(time:Float) -> String {
        let time = "\(Int(time/60)):\(Int(time%60))"
        return time
    }

}

