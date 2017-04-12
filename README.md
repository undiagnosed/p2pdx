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

## Roadmap

The following is a tentative roadmap based on conservative estimates with just free time available to spend on the project. With enough support, more time can be spent on the project and the schedule can be accelerated.

### Summer 2017

* Basic data entry capabilities
  * Add/Edit/Delete lab results
* Basic lab result visualization
  * Reference range visualization, simple history plot

### Fall 2017

* Add support for other data types
  * Add/Edit/Delete symptoms, vitals, medications, visit history, demographics
* Basic lab trend visualization
  * Fit trend with statistical model
  * Report significant change in value using Reference Change Value method

### Winter 2017 and Beyond

* Support for including images with symptoms and imaging tests
* Basic search capability
* Utilities for reading dataset into R for research
* Automated reading of lab results from PDFs, images
* State of the art machine learning algorithms applied to diagnosis, anomaly detection, patient similarity, etc.
* Your feature requests

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
* Visit [p2pdx](http://127.0.0.1:43110/12UQXQ5jsvXUPUSuDY7SzjfFiGqTAeChpi)
* Login with your ZeroID user name
* Start sharing and browing medical data

## Anonymity
Privacy is always a concern when it comes to medical data. Users themselves will be entering medical data into the system and must therefore ensure that they are not including any personally identifying information. Information should be entered in accordance with HIPPA anonymous data specifications as listed [here](https://www.irb.cornell.edu/documents/HIPAA%20Identifiers.pdf). 

Because of decentralized nature of p2pdx, users may also wish to hide their IP address. Users can configure ZeroNet to use Tor in order to acheive this.

## Support
Support the project by becoming a patron at [Patreon](https://www.patreon.com/undiagnosed). You'll have the opportunity to access priority support, weekly status reports, and feature priority voting rights.



