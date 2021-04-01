param(
	[String]$configPath = "C:\ProgramData\OpConxps\SMAResourceMonitor"       #Path to the Resource Monitor config directory
    ,[String]$msginPath = "C:\ProgramData\OpConxps\MSLSAM\MSGIN"             #Path to the MSGIN directory
    ,[String]$rulesPath = "C:\ProgramData\OpConxps\SMAResourceMonitor\Rules" #Path to Rules file directory
    ,[String]$psPath = "C:\Program Files\PowerShell\7\pwsh.exe"              #Path to PowerShell on the server
    ,[String]$opconURL = "https://<opcon server>/api"                        #OpCon API url
    ,[String]$email = "youremail@domain.com"                                 #Email address for notifications
    ,[String]$externalUser = "encrypted user"                                #External User
    ,[String]$externalPassword = "encrypted password"                        #External Password/Token
    ,[String]$option                                                         #Option (action,config,rules,both,all)
)


if($option -eq "actions" -or $option -eq "all" -or $option -eq "both")
{
    #Remove previous action files
    Remove-Item ($rulesPath + "\*.Actn")

    #Write Out the actions file/s
    #---------------------------------------------------------------------------------------------
    '
    <Action Type="Event">
    <Version>0.0.0.3</Version>
    <Documentation>Example for roundtable</Documentation>
    <Text Active="1">$PROPERTY:SET,ROUNDTABLE_RM,[[@DATE]] -File:[[@FullFileName]] -Criteria:[[@FileCriteria]]</Text>
    </Action>
    ' | Out-File ($rulesPath + "\Track_String1.Actn") -Encoding ASCII -Force

    '<Action Type="Event">
    <Version>0.0.0.3</Version>
    <Documentation>Roundtable example for service</Documentation>
    <Text Active="1">$NOTIFY:EMAIL,' + $email + ',,,[[@SERVICENAME]] [[@CURRENTSTATUS]] on [[@MACHINENAME]],Taking corrective actions,</Text>
    </Action>
    ' | Out-File ($rulesPath + "\Email_Service.Actn") -Encoding ASCII -Force

    '<Action Type="Event">
    <Version>0.0.0.3</Version>
    <Documentation>Roundtable email example</Documentation>
    <Text Active="1">$NOTIFY:EMAIL,' + $email + ',,,[[@COUNTERNAME]] monitor triggered on [[@MACHINENAME]],[[@COUNTERNAME]] is at [[@CURRENTVALUE]],</Text>
    </Action>
    ' | Out-File ($rulesPath + "\Email_Counter.Actn") -Encoding ASCII -Force

    '<Action Type="Event">
    <Version>0.0.0.3</Version>
    <Documentation>Roundtable example</Documentation>
    <Text Active="1">$RUN:SCRIPT,' + $psPath + ',-command start-service -displayname &apos;[[@SERVICENAME]]&apos;</Text>
    </Action>
    ' | Out-File ($rulesPath + "\Start_Service.Actn") -Encoding ASCII -Force

    #---------------------------------------------------------------------------------------------
}

if($option -eq "rules" -or $option -eq "all" -or $option -eq "both")
{
    #Remove previous action files
    Remove-Item ($rulesPath + "\*.Rule")

    #Write Out the rule file/s
    #---------------------------------------------------------------------------------------------
    '<Monitor Type="File" Active="0">
	    <Version>0.0.0.3</Version>
	    <Documentation>Monitors an example for a roundtable</Documentation>
	    <FromTime>00:00:00</FromTime>
	    <ToTime>23:59:59</ToTime>
	    <ScanString>Lumos Maximus</ScanString>
	    <MaxConcurrentFiles>0</MaxConcurrentFiles>
	    <MaxConcurrentFilesProcessingDelay>0</MaxConcurrentFilesProcessingDelay>
	    <Samples></Samples>
	    <Frequency>0</Frequency>
	    <State>ScanString</State>
	    <WaitVerify>1</WaitVerify>
	    <NonWindowsShare>0</NonWindowsShare>
	    <NonWindowsPollInterval>30</NonWindowsPollInterval>
	    <ProcessOfflineChanges>1</ProcessOfflineChanges>
	    <TrackScanString>1</TrackScanString>
	    <DisableTriggeredMax>0</DisableTriggeredMax>
	    <DisableTriggeredMin>0</DisableTriggeredMin>
	    <DisableTriggeredAvg>0</DisableTriggeredAvg>
	    <AutoReenableMax>0</AutoReenableMax>
	    <AutoReenableMin>0</AutoReenableMin>
	    <AutoReenableAvg>0</AutoReenableAvg>
	    <AutoReenableMinutes>0</AutoReenableMinutes>
	    <Desc>
		    <Name>C:\ProgramData\OpConxps\SAM\Log\SAM.log</Name>
		    <CreateTimeStamp>1753/01/01 00:00:00</CreateTimeStamp>
		    <Size>1</Size>
		    <FileSizeUnit>Bytes</FileSizeUnit>
		    <High></High>
		    <Low></Low>
		    <Mean></Mean>
	    </Desc>
	    <Actions>
		    <Action Condition="ScanString">
			    <File>Track_String1.Actn</File>
		    </Action>
	    </Actions>
    </Monitor>    
    ' | Out-File ($rulesPath + "\Search_String1.Rule") -Encoding ASCII -Force

    '<Monitor Type="LogicalDisk" Active="1">
	<Version>0.0.0.3</Version>
	<Documentation>Roundtable example for disk</Documentation>
	<FromTime>00:00:00</FromTime>
	<ToTime>23:59:59</ToTime>
	<ScanString></ScanString>
	<MaxConcurrentFiles></MaxConcurrentFiles>
	<MaxConcurrentFilesProcessingDelay>0</MaxConcurrentFilesProcessingDelay>
	<Samples>1</Samples>
	<Frequency>5</Frequency>
	<State>C:</State>
	<WaitVerify></WaitVerify>
	<DisableTriggeredMax>0</DisableTriggeredMax>
	<DisableTriggeredMin>1</DisableTriggeredMin>
	<DisableTriggeredAvg>0</DisableTriggeredAvg>
	<AutoReenableMax>0</AutoReenableMax>
	<AutoReenableMin>0</AutoReenableMin>
	<AutoReenableAvg>0</AutoReenableAvg>
	<AutoReenableMinutes>60</AutoReenableMinutes>
	<Desc>
		<Name>% Free Space</Name>
		<CreateTimeStamp></CreateTimeStamp>
		<Size></Size>
		<FileSizeUnit></FileSizeUnit>
		<High>0</High>
		<Low>10</Low>
		<Mean>0</Mean>
		<AboveBelow>Above</AboveBelow>
	</Desc>
	<Actions>
		<Action Condition="Low">
			<File>Email_Counter.Actn</File>
		</Action>
	</Actions>
    </Monitor>
    ' | Out-File ($rulesPath + "\Disk.Rule") -Encoding ASCII -Force

    '<Monitor Type="Service" Active="1">
	<Version>0.0.0.3</Version>
	<Documentation>Monitors the JORS service</Documentation>
	<FromTime>00:00:00</FromTime>
	<ToTime>23:59:59</ToTime>
	<State>Stopped</State>
	<DisableTriggered>1</DisableTriggered>
	<Frequency>5</Frequency>
	<AutoReenable>Started</AutoReenable>
	<AutoReenableMinutes>60</AutoReenableMinutes>
	<Desc>
		<Name>SMA OpCon JORS for Microsoft</Name>
		<High></High>
		<Low></Low>
		<Mean></Mean>
	</Desc>
	<Actions>
		<Action Condition="Stopped">
			<File>Start_Service.Actn</File>
		</Action>
		<Action Condition="Stopped">
			<File>Email_Service.Actn</File>
		</Action>
	</Actions>
    </Monitor>
    ' | Out-File ($rulesPath + "\JORS_Service.Rule") -Encoding ASCII -Force

    '<Monitor Type="Memory" Active="1">
	<Version>0.0.0.3</Version>
	<Documentation>Roundtable example for RAM</Documentation>
	<FromTime>00:00:00</FromTime>
	<ToTime>23:59:59</ToTime>
	<ScanString></ScanString>
	<MaxConcurrentFiles></MaxConcurrentFiles>
	<MaxConcurrentFilesProcessingDelay>0</MaxConcurrentFilesProcessingDelay>
	<Samples>1</Samples>
	<Frequency>5</Frequency>
	<State></State>
	<WaitVerify></WaitVerify>
	<DisableTriggeredMax>0</DisableTriggeredMax>
	<DisableTriggeredMin>1</DisableTriggeredMin>
	<DisableTriggeredAvg>0</DisableTriggeredAvg>
	<AutoReenableMax>0</AutoReenableMax>
	<AutoReenableMin>0</AutoReenableMin>
	<AutoReenableAvg>0</AutoReenableAvg>
	<AutoReenableMinutes>60</AutoReenableMinutes>
	<Desc>
		<Name>Available MBytes</Name>
		<CreateTimeStamp></CreateTimeStamp>
		<Size></Size>
		<FileSizeUnit></FileSizeUnit>
		<High>0</High>
		<Low>5000</Low>
		<Mean>0</Mean>
		<AboveBelow>Above</AboveBelow>
	</Desc>
	<Actions>
		<Action Condition="Low">
			<File>Email.Actn</File>
		</Action>
	</Actions>
    </Monitor>
    ' | Out-File ($rulesPath + "\RAM.Rule") -Encoding ASCII -Force
    #---------------------------------------------------------------------------------------------
}

if($option -eq "config" -or $option -eq "all")
{
    #Remove previous config file
    Remove-Item "$configPath\SMAResourceMonitor.ini"

    #Stop the Resource Monitor Service
    Get-Service -Name "SMA_RESOURCE_MONITOR" | foreach-object{ sc.exe STOP $_ }

    $counter = 0
    While( (Get-Service -Name "SMA_RESOURCE_MONITOR").Status -ne "Stopped" -or $counter -ge 6 )
    {
        Start-Sleep -Seconds 5
        $counter++
    }

    if($counter -ge 6)
    {
        Write-Host "Resource Monitor service failed to stop!"
        Exit 5
    }

    '
    ############################################################################################
    #
    #Application Name:		SMA Resource Monitor
    #				(SMAResourceMonitor.exe)
    #Version of this configuration file:	3.00.0000
    ############################################################################################

    [General Settings]
    ShortServiceName=SMA_MSRESOURCE_MONITOR
    DisplayServiceName=SMA Microsoft Resource Monitor
    PathToRuleAndActionFiles = ' + $rulesPath + '
    MsginDirectory=' + $msginPath + '
    ExternalEventUser=' + $externalUser + '
    ExternalEventPassword=' + $externalPassword + '
    NetworkRetryTimer=30
    InitializationScript=
    TerminationScript=
    WebServicesUrl=' + $opconURL + '

    [Debug Options]
    ArchiveDaysToKeep=10
    MaximumLogFileSize=150000
    TraceLevel=0
    ' | Out-File "$configPath\SMAResourceMonitor.ini" -Encoding ASCII -Force

    #Start the Resouce Monitor service
    Get-Service -Name "SMA_RESOURCE_MONITOR" | foreach-object{ sc.exe START $_ }

    $counter = 0
    While( (Get-Service -Name "SMA_RESOURCE_MONITOR").Status -ne "Running" -or $counter -ge 6 )
    {
        Start-Sleep -Seconds 5
        $counter++
    }

    if($counter -ge 6)
    {
        Write-Host "Resource Monitor service failed to start!"
        Exit 4
    }
}
