-- This script searches OpCon jobs for the entered "keyword"
-- and displays the results with the schedule/job/job value
-- where it was found.

-- A good use case would be a Self Service button with an input
-- text search, that emails or creates an output file of the 
-- results.

-- To use the script, replace <DB> with the name of your OpCon
-- database.

-- Also replace <keyword> with a keyword that you want to find in
-- an OpCon job. 
------------------------------------------------------------------

USE <DB>

SELECT 
SNAME.SKDNAME AS [SCHEDULE]
,JMASTER_AUX.JOBNAME AS [JOB]
,JMASTER_AUX.JAVALUE AS [JOB VALUE]   
FROM JMASTER_AUX,SNAME   
WHERE JAVALUE like '%<keyword>%'  AND 
JMASTER_AUX.SKDID=SNAME.SKDID
