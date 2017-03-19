# p2pdx - Decentralized medical data sharing

![p2pdx](http://i.imgur.com/K2hAGUW.png)

## Purpose
In the United States, the frequency of medical diagnostics errors in outpatient settings is estimated to be more than 5%. In the cases of rare diseases, the outlook is much worse. All too often, patients are told that their physical illness is psychological and are brushed aside, left to fend for themselves. Patients need to take action to help themselves and others.

One of the most important ways patients can help themselves and each other is to collect and share medical data. In an ideal world, everyone would have access to a doctor that would not make diagnostic errors. However, the reality is that many people don't have access to or can't find an appropriate doctor in a reasonable time frame. This is especially problematic for chronic illnesses that progress over time. The first step to empowerment is for the patient to own all their medical records. This serves a few important purposes. First, it allows the patient to double check results and make sure there is no oversight by the doctor. Additionally, it allows the patient to take a complete record with them to new providers. Often, doctors will fax fragments with information lost in the process and possibly conflicting with the patient's assessment of the situation. By controlling the information given to the provider, the patient can better represent themselves and shape the discussion.

In order for patients to help each other, access to structured medical data is needed. By sharing such information, researchers can applying techniques such as machine learning algorithms to help make a diagnosis for difficult cases. Such data is currently very limited. While there are websites such as PatientsLikeMe that allows users to share data, the data itself is not freely available to researchers. The government also collects data, but approval through an accepted study must be given. P2pdx allows anyone to access the data without any approval, it is public domain. This will allow both hobbyists and professionals alike the opportunity to help improve diagnostics.

## Features
 * Track medical data including:
   * Lab test results
   * Symptoms
   * Vitals
   * Visit history
   * Medications
   * Demographics
 * Data is shared reducing duplication when entering information
 * Visualize results with graphing capabilities
 * Search data with basic filtering capabilities
 * Perform research on dataset with R or Python with SQLite reading helper scripts

## Getting Started
### Download ZeroNet
* Download ZeroBundle package:
  * [Microsoft Windows](https://github.com/HelloZeroNet/ZeroBundle/raw/master/dist/ZeroBundle-win.zip)
  * [Apple OS X](https://github.com/HelloZeroNet/ZeroBundle/raw/master/dist/ZeroBundle-mac-osx.zip)
  * [Linux 64bit](https://github.com/HelloZeroNet/ZeroBundle/raw/master/dist/ZeroBundle-linux64.tar.gz)
  * [Linux 32bit](https://github.com/HelloZeroNet/ZeroBundle/raw/master/dist/ZeroBundle-linux32.tar.gz)
* Unpack anywhere
* Run `ZeroNet.cmd` (win), `ZeroNet(.app)` (osx), `ZeroNet.sh` (linux)

If you get "classic environment no longer supported" error on OS X: Open a Terminal window and drop ZeroNet.app on it
It downloads the latest version of ZeroNet then starts it automatically.

### Create ZeroID
* Visit [ZeroID site](http://127.0.0.1:43110/zeroid.bit)
* Create user name

### Visit p2pdx
* Visit [p2pdx](http://127.0.0.1:43110/1NGuD84kVgh3iBTQegdX8z7DbsGLZjHkvz)
* Login with your ZeroID user name
* Start sharing and browing medical data

## Anonymity
Privacy is always a concern when it comes to medical data. Users themselves will be entering medical data into the system and must therefore ensure that they are not including any personally identifying information. Information should be entered in accordance with HIPPA anonymous data specifications as listed [here](https://www.irb.cornell.edu/documents/HIPAA%20Identifiers.pdf). 

Because of decentralized nature of p2pdx, users may also wish to hide their IP address. Users can configure ZeroNet to use Tor in order to acheive this.

## Support
Support the project by becoming a patron at [Patreon](https://www.patreon.com/undiagnosed). You'll have the opportunity to access priority support, weekly status reports, and feature priority voting rights.



