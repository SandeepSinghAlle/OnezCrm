tableextension 50305 "GenJournalLineCRMExt" extends "Gen. Journal Line"
{
    fields
    {
        field(50100; "Grant Application Number"; Text[100])
        {
            Caption = 'Grant Application Number';
            Description = 'Grant Application Number';
            DataClassification = ToBeClassified;
        }
        field(50101; "NPC Approved Amount"; Decimal)
        {
            Caption = 'NPC Approved Amount';
            Description = 'NPC Approved Amount';
            DataClassification = ToBeClassified;
        }
        field(50102; "Grantee Accepted Amount"; Decimal)
        {
            Caption = 'Grantee Accepted Amount';
            Description = 'Grantee Accepted Amount';
            DataClassification = ToBeClassified;
        }
        field(50103; "CRM Grantee Name"; Text[100])
        {
            Caption = 'CRM Grantee Name';
            DataClassification = ToBeClassified;
            Description = 'CRM Grantee Name';
        }
        // Add changes to table fields here
    }
    keys
    {
        key(GrantApplicationKey; "Grant Application Number")
        {

        }
    }

    var
        myInt: Integer;
}