Function DNSdb {
	<#
	.SYNOPSIS
	DNSdb PowerShell cousin of the Python version in https://github.com/dnsdb/dnsdb-query
	
	.DESCRIPTION
	From: https://api.dnsdb.info/
	DNSDB is a database that stores and indexes both the passive DNS data available via 
	Farsight Security's Security Information Exchange as well as the authoritative DNS data 
	that various zone operators make available. DNSDB makes it easy to search for individual 
	DNS RRsets and provides additional metadata for search results such as first seen and 
	last seen timestamps as well as the DNS bailiwick associated with an RRset. 
	DNSDB also has the ability to perform inverse or rdata searches.
	
	.EXAMPLE
	All RRsets whose owner name is www.farsightsecurity.com
	
	DNSdb -Lookup rrset -Name www.farsightsecurity.com
	
	Count      : 5059
	time_first : 9/26/2013 4:02:10 AM
	time_last  : 4/1/2015 5:51:39 PM
	rrname     : www.farsightsecurity.com.
	rrtype     : A
	rdata      : 66.160.140.81
	
	*** All timestamps are in UTC ***
	---redacted result---total 6 results---
	
	.EXAMPLE
	Formatting the result from example above
	
	DNSdb -Lookup rrset -Name www.farsightsecurity.com | ft *
	
	Count time_first           time_last             rrname                    rrtype rdata
	----- ----------           ---------             ------                    ------ -----
	 5059 9/26/2013 4:02:10 AM 4/1/2015 5:51:39 PM   www.farsightsecurity.com. A      66.160.140.81
	47979 4/1/2015 9:07:24 PM  5/14/2018 9:53:46 PM  www.farsightsecurity.com. A      104.244.13.104
	  164 7/2/2013 1:37:26 AM  9/25/2013 1:14:08 AM  www.farsightsecurity.com. A      149.20.4.207
	  651 9/30/2013 9:06:34 AM 4/1/2015 3:40:14 AM   www.farsightsecurity.com. AAAA   2001:470:b0::81
	   46 7/2/2013 1:37:25 AM  9/20/2013 11:07:54 PM www.farsightsecurity.com. AAAA   2001:4f8:1:66::207
	17195 4/9/2015 9:31:11 PM  5/14/2018 8:34:36 PM  www.farsightsecurity.com. AAAA   2620:11c:f004::104

	Explanation:
	Pipe the original output to ft (Format-Table) function; in this case, ft * a.k.a. format all.
	
	.EXAMPLE
	All RRsets whose owner name ends in farsightsecurity.com, of type MX, in the farsightsecurity.com zone
	
	DNSdb -Lookup rrset -Name "*.farsightsecurity.com" -Type MX -Zone farsightsecurity.com | ft *
	
	Count time_first            time_last             rrname                        rrtype rdata
	----- ----------            ---------             ------                        ------ -----
	27758 7/18/2013 6:08:49 AM  6/1/2017 6:17:50 AM   farsightsecurity.com.         MX     10 hq.fsi.io.
		2 7/2/2013 3:52:09 AM   7/2/2013 3:52:09 AM   farsightsecurity.com.         MX     10 ss.vix.su.
	 8620 6/1/2017 2:17:50 PM   5/14/2018 10:03:28 PM farsightsecurity.com.         MX     10 mail.fsi.io.
		3 12/17/2016 7:04:19 AM 12/17/2016 7:05:38 AM mkt.farsightsecurity.com.     MX     10 hq.fsi.io.
	 2009 8/27/2013 4:10:43 AM  5/14/2018 4:00:05 PM  lists.farsightsecurity.com.   MX     10 lists.farsightsecurity.com.
	 9492 5/12/2015 7:28:44 AM  5/14/2018 10:03:20 PM support.farsightsecurity.com. MX     10 support.farsightsecurity.com.

	.EXAMPLE
	All resource records whose Rdata values are the IPv4 address 104.244.13.104
	
	DNSdb -Lookup rdata -IP 104.244.13.104 | ft *
	
	Count time_first            time_last             rrname                        rrtype rdata
	----- ----------            ---------             ------                        ------ -----
	66031 4/8/2015 3:04:25 AM   5/14/2018 5:55:37 PM  fsi.io.                       A      104.244.13.104
	 3426 6/7/2015 2:13:14 PM   5/14/2018 9:18:53 PM  www.fsi.io.                   A      104.244.13.104
	   68 6/9/2015 6:30:06 PM   4/22/2017 2:18:09 AM  olddocs.fsi.io.               A      104.244.13.104
	 2240 11/5/2016 12:04:00 AM 5/12/2018 2:31:07 AM  fastrpz.com.                  A      104.244.13.104
	
	.EXAMPLE
	All resource records whose Rdata values are addresses in the 104.244.13.104/29 network prefix
	
	DNSdb -Lookup rdata -IP 104.244.13.104 -Prefix 29 | ft *
	
	Count time_first            time_last             rrname                        rrtype rdata
	----- ----------            ---------             ------                        ------ -----
	66031 4/8/2015 3:04:25 AM   5/14/2018 5:55:37 PM  fsi.io.                       A      104.244.13.104
	 3426 6/7/2015 2:13:14 PM   5/14/2018 9:18:53 PM  www.fsi.io.                   A      104.244.13.104
	54051 4/1/2015 9:05:08 PM   5/14/2018 8:09:51 PM  dl.farsightsecurity.com.      A      104.244.13.105
	42224 4/21/2015 4:00:56 AM  5/14/2018 8:12:56 PM  dnsrpz.info.                  A      104.244.13.106
	  180 6/9/2015 6:30:06 PM   3/21/2018 8:14:34 AM  www.dnsrpz.info.              A      104.244.13.106
	24483 6/9/2015 6:07:25 AM   5/14/2018 9:17:35 PM  www-dyn.farsightsecurity.com. A      104.244.13.107
	 2932 6/9/2015 6:30:06 PM   5/14/2018 6:06:35 PM  web1.pao1.fsi.io.             A      104.244.13.108
	  190 7/26/2016 3:41:56 AM  5/4/2018 4:26:44 PM   dev-my-www-2.pao1.fsi.io.     A      104.244.13.109
	  196 7/26/2016 4:12:57 AM  5/4/2018 4:27:57 PM   dev-my-www-3.pao1.fsi.io.     A      104.244.13.110
	  327 7/27/2016 2:33:12 AM  4/16/2018 11:34:08 PM dev-my-www-1.pao1.fsi.io.     A      104.244.13.111
	
	.EXAMPLE
	All resource records whose Rdata values are the IPv6 address 2620:11c:f004::104
	
	DNSdb -Lookup rdata -IP 2620:11c:f004::104 | ft *
	
	Count time_first            time_last             rrname                        rrtype rdata
	----- ----------            ---------             ------                        ------ -----
	22822 4/8/2015 4:25:00 AM   5/14/2018 6:10:34 PM  fsi.io.                       AAAA   2620:11c:f004::104
	  227 6/9/2015 6:30:06 PM   5/5/2018 11:12:06 PM  www.fsi.io.                   AAAA   2620:11c:f004::104
	   12 6/9/2015 6:30:06 PM   4/20/2017 3:29:21 AM  olddocs.fsi.io.               AAAA   2620:11c:f004::104
	 1865 11/8/2016 5:00:24 AM  3/17/2018 5:17:44 PM  fastrpz.com.                  AAAA   2620:11c:f004::104
	   45 2/10/2017 10:20:16 PM 4/21/2018 8:16:53 AM  www.fastrpz.com.              AAAA   2620:11c:f004::104
	   39 6/9/2015 6:30:06 PM   9/22/2016 11:47:08 PM farsighsecurity.com.          AAAA   2620:11c:f004::104

	.EXAMPLE
	All domain names delegated to the nameserver ns5.dnsmadeeasy.com
	
	DNSdb -Lookup rdata -Name ns5.dnsmadeeasy.com -Limit_Result 5 | ft *

	Count time_first          time_last           rrname    rrtype rdata
	----- ----------          ---------           ------    ------ -----
	 1549 1/1/1970 8:00:00 AM 1/1/1970 8:00:00 AM 3dg.biz.  NS     ns5.dnsmadeeasy.com.
	  864 1/1/1970 8:00:00 AM 1/1/1970 8:00:00 AM chal.biz. NS     ns5.dnsmadeeasy.com.
	  568 1/1/1970 8:00:00 AM 1/1/1970 8:00:00 AM cpcl.biz. NS     ns5.dnsmadeeasy.com.
	 1999 1/1/1970 8:00:00 AM 1/1/1970 8:00:00 AM g3ms.biz. NS     ns5.dnsmadeeasy.com.
	 2690 1/1/1970 8:00:00 AM 1/1/1970 8:00:00 AM icti.biz. NS     ns5.dnsmadeeasy.com.
	
	Explanation:
	Lookup and limit result to just 5 results
	
	.EXAMPLE
	A wildcard search for RRsets whose owner name is farsightsecurity.com, rrtype is NS, bailiwick is farsightsecurity.com, seen after the date/time Feb 1, 2010 with a limit of 100 results.
	
	DNSdb -Lookup rrset -Name "*.farsightsecurity.com" -Type NS -Zone farsightsecurity.com -Limit_Result 5 -Since_Date 2/1/2010
	
	Count      : 51
	time_first : 7/1/2013 10:14:43 PM
	time_last  : 7/17/2013 9:17:44 AM
	rrname     : farsightsecurity.com.
	rrtype     : NS
	rdata      : {ns.lah1.vix.com., ns1.isc-sns.net., ns2.isc-sns.com., ns3.isc-sns.info.}

	Count      : 1358308
	time_first : 7/18/2013 5:26:20 AM
	time_last  : 5/14/2018 10:47:05 PM
	rrname     : farsightsecurity.com.
	rrtype     : NS
	rdata      : {ns5.dnsmadeeasy.com., ns6.dnsmadeeasy.com., ns7.dnsmadeeasy.com.}

	Explanation:
	Since_Date parameter limits results to changes after "time_last" records.
	
	.PARAMETER Lookup
	"rrset" lookup queries DNSDB's RRset index, which supports "forward" lookups based on the owner name of an RRset.
	"rdata" lookup queries DNSDB's Rdata index, which supports "inverse" lookups based on Rdata record values. In contrast to the rrset lookup method, rdata lookups return only individual resource records and not full resource record sets, and lack bailiwick metadata. An rrset lookup on the owner name reported via an rdata lookup must be performed to retrieve the full RRset and bailiwick.
	
	.PARAMETER IP
	IPv4 / IPv6 address is acceptable
	
	.PARAMETER Net_Prefix
	(@lias = Prefix) IP Address prefix (CIDR block)
	
	.PARAMETER Name
	Name of the resource to query
	
	.PARAMETER Record_Type
	(@lias = Type) One of the following: A AAAA CNAME MX NS PTR SOA SRV TXT
	
	.PARAMETER Search_zone
	(@lias = Zone) Zone owner
	
	.PARAMETER Limit_Result
	(@lias = Limit) Self-explanatory
	
	.PARAMETER Since_Date
	(@lias = Since) Load records since time_last
	
	.PARAMETER API_Rate_limit
	(@lias = API) Specifying this parameter toggles the DNSDB API rate limit information.
	
	API Rate Limit:                  1000
	API Rate Limit Remaining:        955
	API Rate Limit Will Reset On:    5/15/2018 8:00:00 AM
	
	#>
	
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true,Position=0,HelpMessage="Define lookup type")]
		[ValidateSet('rrset','rdata')]
		[string]$Lookup,
		
		[Parameter(Mandatory=$false)]
		[ValidateScript({$_ -match [IPAddress]$_ })]
		[string]$IP,
		
		[Parameter(Mandatory=$false,HelpMessage="Network Prefix")]
		[alias("Prefix")]
		[int]$Net_Prefix,
		
		[Parameter(Mandatory=$false,HelpMessage="Search name")]
		[string]$Name,
		
		[Parameter(Mandatory=$false,HelpMessage="RRSet Record Type")]
		[alias("Type")]
		[string]$Record_Type,
		
		[Parameter(Mandatory=$false,HelpMessage="RRSet Source Zone")]
		[alias("Zone")]
		[string]$Search_zone,
		
		[Parameter(Mandatory=$false,HelpMessage="Limit result to last x")]
		[alias("Limit")]
		[int]$Limit_Result,
		
		[Parameter(Mandatory=$false,HelpMessage="Show results since date")]
		[alias("Since")]
		[datetime]$Since_Date,
		
		[Parameter(Mandatory=$false,HelpMessage="API Limit Info")]
		[alias("API")]
		[switch]$API_Rate_limit
	)
	
	$APIkey = "Insert Key Here"
	$headers = @{"X-API-Key"=$APIkey; "Accept"="application/json"}

	Switch ($Lookup) {
		"rrset" {
			$baseURL = "https://api.dnsdb.info/lookup/rrset"
		}
		"rdata" {
			$baseURL = "https://api.dnsdb.info/lookup/rdata"
		}
	}

	If ($IP) {
		$constructor = $baseURL + "/ip/" + $IP
		If ($Net_Prefix) {
			$constructor += "," + $Net_Prefix
		}
	} Else {
		$constructor = $baseURL + "/name/" + $Name
	}	
	
	# rrset additional parameters
	If ($Search_zone -or $Record_Type) {
		If (($Lookup -eq "rrset") -and ($Name)) {
			$constructor += "/" + $Record_Type + "/" + $Search_zone
		}
	}
	
	$constructor += "?"
	
	# Optional parameter - result limit
	If ($Limit_Result) {
		$constructor += "limit=$Limit_Result&"
	}
	# Optional parameter - since date
	If ($Since_Date) {
		$constructor += "time_last_after=" + $(Get-Date -UFormat "%s" $Since_Date) + "&"
	}
	
	# Final constructed API URL query
	Write-Host $constructor
	
	Try {
		$result = Invoke-WebRequest -uri $constructor -headers $headers
		
		If ($result.StatusCode -eq 200) {
			If ($API_Rate_limit) {
				Write-Host "API Rate Limit: `t`t" $result.headers."X-RateLimit-Limit"
				Write-Host "API Rate Limit Remaining: `t" $result.headers."X-RateLimit-Remaining"
				Write-Host "API Rate Limit Will Reset On: `t" $((Get-Date "1970-01-01 00:00:00.000Z").AddSeconds($result.headers."X-RateLimit-Reset"))
			}
			Return $result.Content.split("`r`n") | ConvertFrom-Json | select @{n='Count';e={ $_.count }}, @{n='time_first';e={ ((Get-Date "1970-01-01 00:00:00.000Z").AddSeconds($_.time_first)) }}, @{n='time_last';e={ ((Get-Date "1970-01-01 00:00:00.000Z").AddSeconds($_.time_last)) }}, @{n='rrname';e={ $_.rrname }}, @{n='rrtype';e={ $_.rrtype }}, @{n='rdata';e={ $_.rdata }}
		} 
	} Catch {
		Write-Host -foregroundcolor red "*WARNING*" $_.exception.message
	}

}
