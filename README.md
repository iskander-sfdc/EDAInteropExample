# Example interop managed package for EDA

This package contains example Callable classes that can be used to test EDA Interoperability.
Namespace: edainteropdemo
It depends on EDA managed package. Please install EDA first into your scratch or demo org.

# Installation

Install the latest version of EDA package first
Install the `EDA Interoperability Demo` package. Current installation url: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1U000007PmwXQAS
Create a new record in `Product Registry` custom metadata type:

-   Label: `Demo Release Gate`
-   Name: `Demo_Release_Gate`
-   Namespace: `edainteropdemo`
-   Action: `Release Gating`
-   Class Name: `DemoReleaseGateCallableImpl`
-   API Version: `52.00`
-   Enabled: Checked

# Installation url

Get the installation url of the latest version of this package using the following command

```bash
sfdx force:package:version:list --verbose -v PersonalDevHub -p "EDA Interoperability Demo"
```

`PersonalDevHub` is a dev hub org alias with the linked namespace org

# Development

Create a dev hub with alias `PersonalDevHub`
Register `edainteropdemo` namespace in your dev hub, [namespace org credentials](https://salesforce.quip.com/e8cVAGRBaTNL#NbAACA7NcIu)
Create a scratch org:

```bash
sfdx force:org:create -f config/project-scratch-def.json -v PersonalDevHub
```

Install EDA package first into your scratch org
Push the source code

# Create a new package version

```bash
sfdx force:package:version:create --package "EDA Interoperability Demo" -v PersonalDevHub --wait 10 --installationkeybypass
```
