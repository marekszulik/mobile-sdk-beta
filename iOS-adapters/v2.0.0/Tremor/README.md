# Tremor - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Tremor | 2.0.0 | 3.9 | 7.0.3 + |

**Important:** *Tremor SDK supports iOS 6 or higher.*

## Example parameters

* **name**: `Tremor`
* **settings**:
	* **SPTremorInterstitialAppId**: `test`
    * **SPTremorRewardedVideoAppId**: `test`
	
## Required frameworks

* `Accounts.framework`  (Mark as Optional to support < iOS 6.0)
* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AssetsLibrary.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework ` (Mark as Optional to support < iOS 6.0)
* `CoreGraphics.framework `
* `CoreLocation.framework `
* `CoreMedia.framework ` (Mark as Optional to support < iOS 6.0)
* `CoreTelephony.framework ` (Mark as Optional to support < iOS 6.0)
* `libz.dylib`
* `libSystem.dylib ` (Mark as Optional to support < iOS 6.0)
* `MapKit.framework `(Mark as Optional to support < iOS 6.0)
* `MediaPlayer.framework `
* `MessageUI.framework `(Mark as Optional to support < iOS 6.0)
* `QuartzCore.framework `
* `SystemConfiguration.framework `
* `Twitter.framework` (Mark as Optional to support < iOS 6.0)

## Required linker flags

_none_