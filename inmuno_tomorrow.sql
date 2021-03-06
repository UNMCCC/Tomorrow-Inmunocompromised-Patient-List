/* NEW QUERY for patients with alert types of IMMUNOCOMPROMISED - */
/* no restrictions on activities -- see comments in code for documentation  */
/* Pull early for today's actually -- originally written for run last night */
/* Debbie Healy, June 2020 */
SET NOCOUNT ON;
DECLARE @nextday DATETIME;
SET @nextday = DATEADD(DAY, CASE 
                            WHEN DATEDIFF(DAY,0,GETDATE())%7 > 3 
                            THEN 7-DATEDIFF(DAY,0,GETDATE())%7 
                            ELSE 1 
                            END,
                       GETDATE())
DECLARE @dayafter DATETIME;
SET @dayafter = DATEADD(DAY, 1, @nextday)

SELECT 
    Quotename(vwS.PAT_NAME,'"') as PAT_NAME,  
    vwS.IDA as MRN,
    convert(varchar,vwS.App_dtTm,20) as App_dtTm,
    vwS.Activity,
    vwS.Location as Sch_location,
    Quotename(MOSAIQ.dbo.fn_GetStaffName(vws.Attending_Md_Id, 'NAMELF'),'"') as attending_MD, 
    isNull(ART.Comments, ' ') as Alert_Staff_Comments	-- Free Text 
FROM MOSAIQ.dbo.vw_Schedule vwS
LEFT JOIN MOSAIQ.dbo.patAlert ART	on vwS.pat_id1 = ART.pat_id1 
LEFT JOIN MOSAIQ.dbo.ObsDef   obd	on ART.Alert_OBD_ID = obd.OBD_ID
WHERE 
  ART.version = 0		  -- Alert Tip Record
  AND  convert(char(8),vwS.app_DtTm,112)  >=  convert(char(8),@nextDay,112)   -- Scheduled Appointment from "today"
  AND  convert(char(8),vwS.app_DtTm,112)  <  convert(char(8),@dayAfter,112)   -- SHOULD BE +1, and "< convert"
  AND  ART.ART_Status_Enum = 1                                                                --Through Scheduled Appointment "tommorrow"
  AND (vwS.SysDefStatus is NULL OR vwS.SysDefStatus <> 'X')			-- Appointment has NOT been cancelled
  AND 
( --  There are two conditions to check
	( -- 1 -- Check Alert Type IMMUNOCOMPROMISED
	obd.Tbl = 10013			-- OBSDEF Table (Observation Definition) Table_id = 10013 provides the list of Alert Types containted in the PatAlert Table (Patient Alert)
	AND obd.obd_id = 25175		-- ObdDef.obdid = 25175 is the id for Alert Type = 'Immunocompromised' -- activated on 6/3/2020
 	) 
 
 OR 
	 ( -- 2 -- Check Alert Type ISOLATION
	 	obd.obd_id =  21601		-- ObdDef.obdid = 21601 is the id for Alert Type = ISOLATION
	 	AND art.comments = 'IMMUNOCOMPROMISED'  -- pre 6/3/2020 the combo of Type=ISOLATION and Comment=IMMUNOCOMPROMISED was used to id patients.  keep this criteria in case someone inadvertently uses it
  	)
)
order by PAT_NAME