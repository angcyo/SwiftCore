# 2021-08-31

任意控件添加进度

```
https://github.com/mapierce/Loadable
```

```
let viewToShowLoading: UIView = UIView()
let progress = Progress(totalUnitCount: 100)

viewToShowLoading.monitoredProgress = progress 

// everything from here on is optional configuration. The lines above will setup everything

viewToShowLoading.animateProgrss = true
viewToShowLoading.progressColor = .blue
viewToShowLoading.showPercentage = true
viewToShowLoading.progressPercentageFontSize = 12.0
viewToShowLoading.progressPercentageFontColor = .red
viewToShowLoading.clearOnComplete = false
```