FROM microsoft/windowsservercore:1803

RUN mkdir c:\downloads

RUN powershell -Command \
    Invoke-WebRequest -Uri https://www.7-zip.org/a/7z1900-x64.exe -OutFile C:\downloads\7zip_install.exe; \
    Start-Process C:\downloads\7zip_install.exe -ArgumentList '/S' -Wait

RUN setx path "%path%;C:\Program Files\7-Zip\"

RUN powershell -Command \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri "https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe" -OutFile C:\downloads\redist.exe ; \
	Start-Process C:\downloads\redist.exe -ArgumentList '/quiet' -Wait ; \
	Remove-Item C:\downloads\redist.exe -Force
RUN powershell -Command \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Uri https://github.com/silentbaws/XLMultiplayer/releases/download/v0.10.3/Server.rar -OutFile C:\downloads\server.rar

WORKDIR C:\\downloads
RUN 7z e server.rar

RUN XLMultiplayerServerConsoleApp.exe