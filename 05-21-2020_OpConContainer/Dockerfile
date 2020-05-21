# Dockerfile for Windows Server with OpCon Agent
# v 1.0
#-------------------------------------------------
FROM mcr.microsoft.com/dotnet/framework/runtime
COPY SMA_OpCon_Windows_19_1.msi C:/
COPY SilentInstall.cmd C:/
RUN ["C:\\SilentInstall.cmd"]

