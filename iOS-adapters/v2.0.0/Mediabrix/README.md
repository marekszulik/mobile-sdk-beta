# MediaBrix - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| MediaBrix  | 2.0.0 | 1.6.1 | 7.0.3 + |

**Important:**

* *<span style="color: #b94a48">The MediaBrix SDK requires deployment target of 6.0 or higher.</span>*
* *<span style="color: #b94a48">You need to fix your app orietation: the current Mediabrix iOS SDK (1.6.1) does not support orientation changes. If you do not fix the orientation of your app the end user user experience may be heavily affected.</span>*
* *<span style="color: #b94a48">Currently the MediaBrix SDK doesn't support 64-bit architecture.</span>*
* *<span style="color: #b94a48">The MediaBrix SDK supports iOS 6 or higher.</span>*

## Example parameters

* **name**: `Mediabrix`
* **settings**:

| Name | MediaBrix | Required | Type | Default value |
|:----------:|:-------------:|:-----------------------:|:------------:|:------------:|
| `SPMediabrixAppId`  | Your MediaBrix App Id | required | string | - |
| `SPMediabrixBaseURL`  | Your MediaBrix Base Url | required | string | - |
| `SPMediabrixProperty`  | Your MediaBrix Property | required | string | - |
| `SPMediabrixRescueZone`  | Your MediaBrix Rescue Zone | required | string | - |
| `SPMediabrixOptInMessageEnabled`  | `useMBbutton` | optional | boolean | `NO` |
| `SPMediabrixUID`  | `uid` | optional | string | _IDFA_ |
| `SPMediabrixRewardText`  | `rewardText` | optional | string | `Coins` |
| `SPMediabrixRewardIconURL`  | `rewardIcon` | optional | string | [`http://mediabrix.vo.llnwd.net/o38/rewards/mobile/images/reward_item.png`](http://mediabrix.vo.llnwd.net/o38/rewards/mobile/images/reward_item.png) |
| `SPMediabrixOptInButtonText`  | `optinbuttonText` | optional | string | `Tap for your free coins` |
| `SPMediabrixEnticeText`  | `enticeText` | optional | string | `Watch a short video and` |
| `SPMediabrixRescueTitle`  | `rescueTitle` | optional | string | `Need more coins?` |
| `SPMediabrixRescueText`  | `rescueText` | optional | string | `is here to help` |
| `SPMediabrixFacebookAppId`  | `facebookAppId` | optional | string | - |
| `SPMediabrixGeoEnabled`  | `allowGeo` | optional | boolean | `YES` |
| `SPMediabrixCalendarEnabled`  | `allowCalendar` | optional | boolean | `YES` |
| `SPMediabrixCameraEnabled`  | `allowCamera` | optional | boolean | `YES` |
	
## Required frameworks

* `Accounts.framework`
* `AdSupport.framework`
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CoreGraphics.framework`
* `CoreLocation.framework`
* `CoreTelephony.framework`
* `EventKit.framework`
* `libsqlite3.dylib`
* `MediaPlayer.framework`
* `MobileCoreServices.framework`
* `Social.framework`
* `StoreKit.framework`
* `QuartzCore.framework`

If your project uses the `-ObjC` linker flag, you need to also add two dynamically loaded libraries (.dylib) to your project:

* `libxml2.dylib`
* `libz.dylib`

If your project uses the `-all_load` linker flag, you need to add one more dynamically loaded library (.dylib) to your project:

* `libiconv.dylib`

## Required linker flags

_none_