# swift-photos-10
# Photo App

## Step-1
### 작업 내용
- 스토리보드 ViewController에 CollectionView를 추가하고 Safe 영역에 가득 채우도록 frame을 설정
- CollectionView Cell 크기를 80 x 80 로 지정
> 초기에 스토리보드에서 Cell의 크기를 변경할 때, **Estimate Size**를 **Automatic**으로 설정함.    
> 잘못된 방법임을 알아채고 이를 **Custom**으로 변경하여 정상적으로 크기가 변경도록 수정

- UICollectionViewDataSource 프로토콜을 채택하고 40개 cell을 랜덤한 색상으로 채우도록 구현
- 랜덤한 색상을 구현하기 위해 CGFloat과 UIColor에 extension을 추가하여 `random()`을 구현

```swift
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

```
UIColor(red: green: blue: alpha:)에서 인자 값이 0~1 사이임을 확인하여 이 사이의 값만 반환해주는    
`random()`을 만들고, UIColor에 이 메소드가 들어간 랜덤 컬러 인스턴스를 반환하게 함

<p align="center">
<img width="400" alt="PHObject" src="https://user-images.githubusercontent.com/45817559/112587593-35b4ec80-8e41-11eb-89c8-d21be34a7aa6.png">
</p>

## Step-2
### 작업 내용
- UINavigationController를 Embed시키고, 타이틀을 'Photos'로 지정
- PHAsset 프레임워크를 사용해서 사진보관함에 있는 사진 Asset 가져오기
```swift
var allPhotos: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: nil)
```
위의 `fetching`메소드를 사용하면 PhotoLibrary에 있는 이미지 메타데이터를 `PHFetchResult`타입으로 가져온다.    
- 앱이 사진 보관함에 접근하기 위해 접근 권한 요청
> 사용자에게 사진 앨범에 접근함을 확인시키기 위해 Privacy - Photo Library Usage Description 설정

<p align="center">
<img width="400" alt="PHObject2" src="https://user-images.githubusercontent.com/45817559/112588005-0652af80-8e42-11eb-9380-811555339fb1.png">
</p>

- CollectionView Cell 크기를 100 x 100 로 변경
- Cell을 가득 채우도록 UIImageView를 추가
- PHCachingImageManager 클래스를 활용해서 썸네일 이미지를 100 x 100 크기로 생성해서 Cell에 표시
> 이미지의 메타데이터를 가져온 객체의 타입이 PHFetchResult<PHAsset>이므로 이를 ImageManager를 사용해서   
> 실제 이미지로 바꿔주어야 한다.
```swift
    func requestImage(cell: CustomCell, indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.row)
        imageManager.requestImage(for: asset, targetSize: cell.intrinsicContentSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            cell.cellImageView.image = image
        })
    }
```
ImageManager의 `request`를 통해 바꾸고자 하는 Asset과 여러 옵션(사이즈, contentMode 등)을 같이 보내서 요청하면     
이에 맞는 이미지가 핸들러로 반환됨.

<p align="center">
<img width="400" alt="PHObject3" src="https://user-images.githubusercontent.com/45817559/112588013-08b50980-8e42-11eb-903e-7a368a7779c2.png">
</p>

- PHPhotoLibrary 클래스에 사진보관함이 변경되는지 여부를 옵저버로 등록하기 위해   
  `PHPhotoLibraryChangeObserver`채택 및 옵저버 register.
- 사진 보관함이 변경되면 CollectionView를 다시 `Reload`해서 화면을 업데이트

```swift
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.photoAlbum.allPhotos) {
                self.photoAlbum.updateFetchResult(updateResult: changes.fetchResultAfterChanges)
                self.photoCollectionView.reloadData()
            }
        }
    }
```
사진 보관함이 변경되면 위 메소드를 통해 `PHChange` 객체가 전달된다.     
이 객체의 `changeDetails`메소드에 변경되지 않은(원래 가지고 있던) `PHFetchResult`객체를 넣어주면        
이와 비교하여 변경된 정보가 `PHFetchResultChangeDetails`타입으로 반환이 된다.    
이 타입의 메소드를 통해 변경된 후(fetchResultAfterChanges)의 정보도 알 수 있고, 변경되기 전의 정보도 알 수 있다.       
따라서 변경된 후의 결과를 update해주고, 콜렉션 뷰를 리로드 해주어 화면을 갱신한다.

## Step.3

### 작업내용
- NavigationBar에 좌측 바버튼을 +버튼을 추가
- Bundle에서 doodle.json 파일을 읽어와서 스위프트 데이터 구조로 변환
- GCD 큐를 활용해서 동시에 최대한 효율적으로 여러 이미지를 다운로드 받아서 표시
- +(add) 버튼을 누르면 Modal로 CollectionViewController에서 상속받은 새로운 DoodleViewController를 표시한다.
    - 코드로 NavigationController를 embed 한 상태로 present
- DataSource 프로토콜에서 모델 객체에 개수와 indexPath에 맞는 데이터 객체를 받아와서 image항목에 있는 이미지를 셀에 표시
- 이미지를 전부 다운로드할 때까지 기다리지않고, 버튼을 누르는 즉시 ViewController 화면 출력
- 다운로드를 받은 이미지는 해당 셀에 표시
- DoodleViewController 에서 특정 셀을 롱클릭하면 실행화면처럼 Save 액션을 하는 UIMenuItem을 표시한
- Save 액션을 선택한 경우는 해당 이미지를 사진보관함에 저장
- 창이 사라지고 사진보관함에서 저장한 이미지가 바로 업데이트 되도록 수정

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
- save메뉴를 누르면 PhotoAlbum에 해당 이미지 저장

### 실행화면
<img src="https://user-images.githubusercontent.com/74946802/112590684-95fa5d00-8e46-11eb-864a-668d07f808a6.gif" width="300" height="600">
