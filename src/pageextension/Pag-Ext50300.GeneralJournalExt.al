pageextension 50300 "GeneralJournalExt" extends "General Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("Grant Application Number"; "Grant Application Number")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("NPC Approved Amount"; "NPC Approved Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Grantee Accepted Amount"; "Grantee Accepted Amount")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("CRM Grantee Name"; "CRM Grantee Name")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}