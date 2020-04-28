report 50305 "Update Job Queue With Integ."
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(JobQueueId; JobQueueId)
                {
                    ApplicationArea = ALL;
                    Caption = 'Job Queue Id';
                    TableRelation = "Job Queue Entry";
                }
                field(TableMappingId; TableMappingId)
                {
                    ApplicationArea = ALL;
                    Caption = 'Table Mapping Name';
                    TableRelation = "Integration Table Mapping";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        JobQueueEntry.RESET;
        JobQueueEntry.SETRANGE(ID, JobQueueId);
        IF JobQueueEntry.FINDFIRST THEN BEGIN
            IntegrationTableMapping.RESET;
            IntegrationTableMapping.SETRANGE(Name, TableMappingId);
            IF IntegrationTableMapping.FINDFIRST THEN BEGIN
                JobQueueEntry."Record ID to Process" := IntegrationTableMapping.RECORDID;
                JobQueueEntry.MODIFY;
            END;
        END;
    end;

    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueId: Guid;
        TableMappingId: Code[20];
        IntegrationTableMapping: Record "Integration Table Mapping";
}

