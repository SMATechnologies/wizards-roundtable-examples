DECLARE @OATIMESTAMP float
DECLARE @TIMESTAMP datetime
DECLARE @OFFSETVAL varchar(4000)
DECLARE @OFFSET int
DECLARE @UTCTIMESTAMP datetime
DECLARE @TIMEDIFFERENCE int
DECLARE @UTCNOW datetime

SELECT @OATIMESTAMP = SAMSTAMP FROM dbo.SAMPULSE

IF @OATIMESTAMP IS NULL
BEGIN
    -- sam shuts down gracefully
    PRINT 'No SAM Timestamp.'
    PRINT 'SAM has shut down.'
    RAISERROR('SAM Shutdown', 12, 10)
END
ELSE
BEGIN
    SELECT @TIMESTAMP = CONVERT(DATETIME, @OATIMESTAMP - 2)
    SELECT @OFFSETVAL = INFO_VALUE FROM dbo.OPCON_INFO WHERE INFO_KEY = 'SAMZONEOFFSET'
    SELECT @OFFSET = CONVERT(INT, @OFFSETVAL)
    SELECT @UTCTIMESTAMP = DATEADD(hh, -1 * @OFFSETVAL, @TIMESTAMP)
    SELECT @UTCNOW = GETUTCDATE()
    SELECT @TIMEDIFFERENCE = DATEDIFF(mi, @UTCTIMESTAMP, @UTCNOW)

    PRINT 'SAM Timestamp: ' + CONVERT(VARCHAR, @TIMESTAMP)
    PRINT 'SAM UTC Offset: ' + CONVERT(VARCHAR, @OFFSET)
    PRINT 'SAM UTC Timestamp: ' + CONVERT(VARCHAR, @UTCTIMESTAMP)
    PRINT 'Current UTC Timestamp: ' + CONVERT(VARCHAR, @UTCNOW)
    PRINT 'SAM Timestamp Delay (minutes): ' + CONVERT(VARCHAR, @TIMEDIFFERENCE)

    IF @TIMEDIFFERENCE > 5
    BEGIN
        -- end task, sam didn't get to run shutdown routine
        PRINT ''
        PRINT ''
        PRINT 'SAM Timestamp is not current.'
        PRINT 'SAM has died.'
        RAISERROR('SAM Died', 12, 20)
    END
    ELSE
    BEGIN
        -- all is well in the world
        PRINT ''
        PRINT ''
        PRINT 'SAM is running OK.'
    END
END