#로그인 페이지 만들기

## 목표 
1.카카오톡으로 로그인하기 
2. 로그인 페이지 꾸미기 위한 로티애니메이셔 사용
 - 준비물 
   - 로티애니메이션 API
   - 카카오 로그인 API
    
  1. cocoaPod 셋팅
   - 터미널에서 프로젝트파일 위치로 이동 
   - 프로젝트 파일 위치에서 pod init 입력 podFile생성 확인
   - sudo vi podFile 입력
   - 비번 입력 후 podFile에 필요한 팟 추가 
   - pod install로 API 설치
   - 설치 완료 후 xcode 종료 후 워크스페이스 파일로 다시 열기
   
   &nbsp;&nbsp;&nbsp;&nbsp;
   
  2. 로티 애니메이션 구현 
    - ViewController
      - import Lottie  로티 임포트
      - 애니메이션을 추가 할 뷰 추가 
      
      ```
       @IBOutlet weak var animationVIew: UIView!
      ```
      - 애니메이션이 출력 되는 뷰 
     ```
        let aniView: AnimationView = {
       
       // 로티애니메이션 JSON파일 추가 후 이름을 입력
       let animView = AnimationView(name: "4491-time-up")
       
       // 로티애니메이션 크기
        animView.frame = CGRect(x:0, y:0, width:400, height:400)
        
        // 로티애니메이션 콘텐츠 크기 
        animView.contentMode = .scaleAspectFill
        
        // 로티애니메이션 무한 반복
        animView.loopMode = .loop
        
        
        return animView
    }()
        ```
        - 애니메이션 실행을 위해 viewDidLoad method에 실행 코드 입력
        ```
        // 뷰가 생성 될 때 
         override func viewDidLoad() {
          super.viewDidLoad()
          // 아울렛으 연결해준 뷰에 애니메이션 뷰 추가
          animationVIew.addSubview(aniView)

          // 추가 한 뷰의 센터에 넣겠다
          aniView.center = animationVIew.center

          // 애니메이션 실행
          aniView.play()
      }
        ```
---
  3. 카카오톡 로그인 
    - info.Plist설정
    - app 설정에서 info -> URL Type 설정 
    
    - AppDelegate 임포트
     ```
     import KakaoSDKCommon
     import KakaoSDKAuth
      ```
    
    - 로그인할때 ios버전 컨트롤을 위한 코드 입력
    ```
     // ios13 버전 이하
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
          return AuthController.handleOpenUrl(url: url)
        }
       return false
       }
    // ios13 버전 이상
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          if let url = URLContexts.first?.url {
              if (AuthApi.isKakaoTalkLoginUrl(url)) {
                  _ = AuthController.handleOpenUrl(url: url)
              }
          }
      }
    ```
    - didFinishLaunchingWithOptions 안에 카카오톡 네이티브코드 입력
       ```
       KakaoSDKCommon.initSDK(appKey: "네이티브앱 코드")
       ```
    - 뷰 컨트롤러에 똑같이 임포트 해준다
    - 로그인 버튼 액션 연결 
    ```
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
    ```
   
   
   - 사용자 저장 관리를 위한 함수 작성
    ```
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
    
    ```
  
  
  ---  
   ### 전체 코드 
   
   ```
   
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
   ```

 
  
