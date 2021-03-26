# swift-photos-10
# Photo App

## Step.3

### Json Data Parsing
```swift
private func decodeJasonData() {
    let path = Bundle.main.path(forResource: "doodle", ofType: "json")
    if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
        decodedData = json
}
```
- Bundle에 있는 "doodle.json" 파일을 읽어서 path에 저장
- String.utf8로 읽어온 후에 [[String:Any]] Dictionary에 저장

### GCD (Grand Central Dispatch)
```
Serial Queue vs Concurrent Queue
```
- 흔히 디스패치 큐(Dispatch Queue)라고 부르고 사용하는 기능
- 일단은 큐이기 때문에 First In First Out구조로 작업
- serial 큐는 하나의 작업이 끝나야 다음 작업을 진행하는 구조
- concurrent 큐는 동시에 여러작업을 진행하는 구조(단, 큐이기 때문에 순서대로!)

### Main vs Global

#### Main
```swift
class var main: DispatchQueue
```
- Main은 앱의 main 쓰레드에서 task를 실행하는 전역적으로 사용가능한 serial queue
- 이 큐는 앱의 실행루프와 함께 작동하여 큐에 있는 task의 실행을 실행루프에 연결된 다른 이벤트 소스의 실행과 연결
- main 쓰레드에서 실행되기 때문에 main queue는 종종 앱의 주요 동기화 지점으로 사용
- 반드시 UI와 관련된 task는 main queue에 넣어야 함 [왜?](https://zeddios.tistory.com/519)

#### Global
```swift
class func global(qos: DispatchQos.QosClass)
```
- Global은 Concurrent Queue의 일종
- 동시의 하나 이상의 task를 실행하지만 task는 큐에 추가된 순서대로 시작
- 타입프로퍼티인 main과 달리 global은 사실 파라미터를 요구(단 아래코드와 같이 default값이 존재하여 생략가능)
```swift
class func global(qos: DispatchQos.QosClass = default) -> DispatchQueue
```
- qos(Quality Of Service)
- 작동시킬 Qos를 지정함으로써 중요도를 설정하고, 시스템은 중요도에 따라 스케쥴링
- [자세한 Qos정보](https://zeddios.tistory.com/521)

#### main().sync && global().sync
```swift
DispatchQueue.global().sync {
    for i in 1...5 {
        print("global sync\(i)")
    }
}

for i in 6...10 {
    print(i)
}
```
```
실행결과
global sync1
global sync2
global sync3
global sync4
global sync5
6
7
8
9
10
```
- main.sync나 global().sync나 결과는 같음
- sync이기 때문에 큐의 작업이 끝나야 다음으로 넘어감

#### global().async
```swift
DispatchQueue.global().async {
    for i in 1...5 {
        print("global sync1:\(i)")
    }
}

DispatchQueue.global().async {
    for i in 10...15 {
        print("global sync2:\(i)")
    }
}

for i in 20...25 {
    print(i)
}
```
```

20
global sync1:1
global sync2:10
21
global sync1:2
global sync2:11
22
global sync1:3
global sync2:12
23
global sync1:4
24
global sync2:13
global sync1:5
25
global sync2:14
global sync2:15실행결과
```
- 실행결과는 매번 차이가 있겠지만 기본적으로 앞의 큐 작업이 끝나지 않아도 다음 작업이 실행됨

#### main.async
```swift
import Foundation

DispatchQueue.main.async {
    for i in 1...5 {
        print("main sync1:\(i)")
    }
}

DispatchQueue.main.async {
    for i in 10...15 {
        print("main sync2:\(i)")
    }
}

for i in 20...25 {
    print(i)
}
```
```
20
21
22
23
24
25
main async1:1
main async1:2
main async1:3
main async1:4
main async1:5
main async2:10
main async2:11
main async2:12
main async2:13
main async2:14
main async2:15
```
- 무조건 asnyc1이 끝난 뒤에 async2가 실행
- 이유는 main은 serial queue이기 때문

### GCD활용하여 데이터 파싱하고 이미지 그리기
```swift
DispatchQueue.global().async {
    guard let url = URL(string: self.image.urlToImage(from: indexPath.row)), let data = try? Data(contentsOf: url) else 
    { return }
                DispatchQueue.main.async {
                    cell.cellImageView.image = UIImage(data: data)
                }
}
```
- url로 만들어서 data로 받아오는 부분은 global.async로 넘기고
- cell의 이미지로 그리는 부분은 main.async에서 작업

### UIMenuController
```swift
let longTouchGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouched(gesture:)))
longTouchGesture.minimumPressDuration = 0.3
collectionView.addGestureRecognizer(longTouchGesture)
```
- 화면을 길게터치하는 것을 인식시키기 위해 longPressGesture등록
- minimunPressDuration은 최소 터치 시간

```swift
let savedMenuItem = UIMenuItem(title: "Save", action: #selector(saveImage))
UIMenuController.shared.menuItems = [savedMenuItem]
UIMenuController.shared.showMenu(from: collectionView, rect: cell.frame)
```
- 사진의 저장 기능 구현을 위하여 "save"메뉴만 구현

```swift
@objc func saveImage(){
    if let image = clickedCell.cellImageView.image {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.dismiss(animated: true, completion: nil)
    }
}
```
- save메뉴를 누르면 PhotoAlbum에 해당 

### 실행화면
<img src="https://user-images.githubusercontent.com/74946802/112590684-95fa5d00-8e46-11eb-864a-668d07f808a6.gif" width="300" height="600">
