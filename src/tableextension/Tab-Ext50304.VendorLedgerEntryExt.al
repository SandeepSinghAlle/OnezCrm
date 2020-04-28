tableextension 50304 "VendorLedgerEntryExt" extends "Vendor Ledger Entry"
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
        // Add changes to table fields here
    }

    var
        myInt: Integer;
}