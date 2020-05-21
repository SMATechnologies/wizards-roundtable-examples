# Sets the location to look for dockerfile and OpCon installs
#Set-Location "C:\DOCKER_AGENT"

# Builds the local container using DockerFile
#docker build -t "local:opcon19-1" .

# Keeps an interactive terminal session
#docker run -p 3100:3100 -p 3110:3110 --name opconAgent -d -v C:\DOCKER_AGENT\Logs:C:/ProgramData/OpConxps/MSLSAM/Log local:opcon19-1

# Sets the services to Automatic rather than Automatic (Delayed)
#powershell set-service -Name "SMA_MSJORSNET" -StartupType Automatic
#powershell set-service -Name "SMA_MSLSAMNET" -StartupType Automatic
#powershell set-service -Name "SMA_SQLAGENTNET" -StartupType Automatic # SQL Agent if applicable

# Stops the container
#docker stop -t 30 opconAgent

# Starts the container
#docker start opconAgent

# Removes LSAM logs
#remove-item "C:\DOCKER_AGENT\Logs\*" -Force

