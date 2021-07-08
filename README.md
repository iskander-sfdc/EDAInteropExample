# Example interop managed package for EDA

This package contains example Callable classes that can be used to test EDA Interoperability.
Namespace: edainteropdemo

# Installation
Get the installation url of the latest version using the following command
```bash
sfdx force:package:version:list --verbose -v PersonalDevHub -p "EDA Interoperability Demo"
```
`PersonalDevHub` is a dev hub org alias with the linked namespace org

# Create a new package version

```bash
sfdx force:package:version:create --package "EDA Interoperability Demo" -v PersonalDevHub --wait 10 --installationkeybypass
```
