## CarouselView 

A smooth, swipeable image carousel made with SwiftUI.

features:
* Smooth drag gesture — tiles move naturally with your finger.
* Auto-centers on the nearest card when you lift your finger.
* Middle image zooms slightly for focus.
* No gaps between cards.
* Auto-shrinks when views are added above or below to fit available space

<div align="center">
  <img src="https://github.com/imsonalbajaj/urVisa/blob/main/urVisa/Images/ss1.png" alt="Image 1" width="300" style="margin: 20px"/>
  <img src="https://github.com/imsonalbajaj/urVisa/blob/main/urVisa/Images/ss2.png" alt="Image 2" width="300" style="margin: 20px"/>
  <img src="https://github.com/imsonalbajaj/urVisa/blob/main/urVisa/Images/ss3.png" alt="Image 3" width="300" style="margin: 20px"/>
</div>


Usage:
```
let items = [
    CarouselItem(imageName: "paris", contryName: "France"),
    CarouselItem(imageName: "rome", contryName: "Italy"),
    CarouselItem(imageName: "tokyo", contryName: "Japan")
]

CarouselView(items: items)
    .frame(height: 250)
```
