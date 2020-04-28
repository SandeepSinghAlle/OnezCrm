pageextension 50301 "JobQueueEntryExt" extends "Job Queue Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Navigation)
        {
            action(AddRecordID)
            {
                ApplicationArea = All;
                RunObject = report "Update Job Queue With Integ.";
                trigger OnAction()
                begin

                end;
            }
        }
    }


}