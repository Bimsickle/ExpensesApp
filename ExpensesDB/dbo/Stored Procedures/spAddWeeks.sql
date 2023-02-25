CREATE PROCEDURE [dbo].[spAddWeeks]
	@StartDate date
AS
	
begin
	set nocount on;
	INSERT INTO [dbo].[WeekDates]
    ([StartWeek], [EndWeek])
    VALUES
    (@StartDate, DATEADD(day,6,@StartDate)),
    (DATEADD(day,7,@StartDate), DATEADD(day,6,@StartDate)),
    (DATEADD(day,14,@StartDate), DATEADD(day,20,@StartDate)),
    (DATEADD(day,21,@StartDate), DATEADD(day,27,@StartDate)),
    (DATEADD(day,28,@StartDate), DATEADD(day,34,@StartDate)),
    (DATEADD(day,35,@StartDate), DATEADD(day,41,@StartDate)),
    (DATEADD(day,42,@StartDate), DATEADD(day,48,@StartDate)),
    (DATEADD(day,49,@StartDate), DATEADD(day,55,@StartDate)),
    (DATEADD(day,56,@StartDate), DATEADD(day,62,@StartDate)),
    (DATEADD(day,63,@StartDate), DATEADD(day,69,@StartDate)),
    (DATEADD(day,70,@StartDate), DATEADD(day,76,@StartDate)),
    (DATEADD(day,77,@StartDate), DATEADD(day,83,@StartDate)),
    (DATEADD(day,84,@StartDate), DATEADD(day,90,@StartDate)),
    (DATEADD(day,91,@StartDate), DATEADD(day,97,@StartDate)),
    (DATEADD(day,98,@StartDate), DATEADD(day,104,@StartDate));
end