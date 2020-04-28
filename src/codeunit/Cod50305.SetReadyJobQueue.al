codeunit 50305 "Ready CRM Job Queue"
{
    trigger OnRun()
    begin
        JobQueueEntries.Reset();
        JobQueueEntries.SetRange("Object Type to Run", JobQueueEntries."Object Type to Run"::Codeunit);
        JobQueueEntries.SetFilter("Object ID to Run", '5339|50302');
        if JobQueueEntries.FindFirst() then
            repeat
                if JobQueueEntries.Status = JobQueueEntries.Status::Error then
                    JobQueueEntries.Restart()
                else begin
                    jobQueueLogEntries.Reset();
                    jobQueueLogEntries.SetRange(ID, JobQueueEntries.ID);
                    jobQueueLogEntries.setrange(status, jobQueueLogEntries.Status::Success);
                    if jobQueueLogEntries.findlast then begin

                    end;
                end;
            until JobQueueEntries.Next = 0;

    end;

    var
        JobQueueEntries: Record "Job Queue Entry";
        jobQueueLogEntries: Record "Job Queue Log Entry";
        LastRunDuraation: Time;
}