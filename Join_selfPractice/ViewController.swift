//
//  ViewController.swift
//  Join_selfPractice
//
//  Created by 다훈김 on 2021/02/23.
//

import UIKit
import Lottie
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    @IBOutlet weak var animationVIew: UIView!
    
    
    let aniView: AnimationView = {
       let animView = AnimationView(name: "4491-time-up")
        animView.frame = CGRect(x:0, y:0, width:400, height:400)
        animView.contentMode = .scaleAspectFill
        animView.loopMode = .loop
        return animView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationVIew.addSubview(aniView)
        aniView.center = animationVIew.center
        
        // 애니메이션 실행
        aniView.play()
         
    }

    //폰(시뮬레이터)에 앱이 안깔려 있을때 웹 브라우저를 통해 로그인
       @IBAction func onKakaoLoginByWebTouched(_ sender: Any) {
           AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
               if let error = error {
                   print(error)
               }
               else {
                   print("loginWithKakaoAccount() success.")
                   
                   //do something
                   _ = oauthToken
                   // 어세스토큰
                   let accessToken = oauthToken?.accessToken
                   
                   //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                   self.setUserInfo()
               }
           }
       }
    
    // 사용자 관리
    func setUserInfo() {
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    //do something
                    _ = user
                   
                    
                    if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                        let data = try? Data(contentsOf: url) {
                        
                    }
                }
            }
        }
   

    
    
}

