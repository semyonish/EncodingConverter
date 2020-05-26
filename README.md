# EncodingConverter
MacOS application with GUI for changing text file encodings.

#### Сurrently available encodings:
- UTF8
- UTF8 with BOM
- US-ASCII
- Windows 1251

![](AppScreens/Screenshot_gui.png)

## Third-party libraries
- [UniversalDetector](https://cocoapods.org/pods/UniversalDetector)

## CI
2 jobs:
- unit_tests
- build_app (saves built app in job artifacts)

## Guide
#### - Click "Open ..."
![](AppScreens/Screenshot_open.png)
#### - Select folder in menu
![](AppScreens/Screenshot_folder.png)
#### - Select files in list
![](AppScreens/Screenshot_select.png)
#### - Select required encoding in Toolbar item "Target Encoding" and click "Convert"
![](AppScreens/Screenshot_result.png)
