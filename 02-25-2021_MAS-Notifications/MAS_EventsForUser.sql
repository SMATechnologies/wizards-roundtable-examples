/****** Replace #USERNAME#  ******/
SELECT * FROM [dbo].[SEVENTS] where USERID = 
(SELECT USERID FROM [dbo].[USERS_AUX] where UAVALUE like '%#USERNAME#%')