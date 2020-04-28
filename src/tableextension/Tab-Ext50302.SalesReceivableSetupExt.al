tableextension 50302 "SalesReceivable Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "Dulicate Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Vendor Name,Bank Account No.,Both';
            OptionMembers = " ","Vendor Name","Bank Account No.",Both;
        }
        field(50002; "Dulicate Vendor Action User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(50003; "Grantee GST Prod Posting Group"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
            ValidateTableRelation = true;
        }
    }

}