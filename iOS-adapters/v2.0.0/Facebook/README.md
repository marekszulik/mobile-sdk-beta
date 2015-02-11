# Facebook Audience Network - adapter info

***<font color='red'>This is recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Facebook | 2.0.1 | 3.23 | 7.0.0 + |

**Important:** *The Facebook SDK for iOS versions 3.17+ supports iOS 6.x and higher. Support for iOS 5.x was dropped in version 3.17 of the SDK. We currently support iOS 7.x+ because there are some problems with Facebook SDK 3.20+ on iOS 6.x.*

## Example parameters

* **name**: `FacebookAudienceNetwork`
* **settings**:
	* **SPFacebookInterstitialPlacementId**
	* **SPFacebookTestDevices**

**Important:** *To add your test device's **hash id** to the `SPFacebookTestDevices` list, run the test application and copy your **hash id** from the log similar to: `FBAudienceNetworkLog: Test mode device hash: #hash_id#`.*
	
## Required frameworks

* `AdSupport.framework`
* `StoreKit.framework`
* `CoreMotion.framework`

## Required linker flags

_none_