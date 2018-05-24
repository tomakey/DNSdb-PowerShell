# DNSdb-PowerShell

DNSdb query in PowerShell

DNSdb PowerShell cousin of the Python version in https://github.com/dnsdb/dnsdb-query This project is not officially affiliated with Farsight Security.

You will need a working API key by ordering from Farsight Security: https://www.farsightsecurity.com/Order/

To use, simply import the module:

```powershell
Import-Module 'path-to\DNSdb.psm1'
```

All results are returned as PowerShell custom object which means you can further transform the data as needed.
