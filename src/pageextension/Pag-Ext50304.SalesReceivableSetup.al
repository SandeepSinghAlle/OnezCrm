pageextension 50304 "SalesReceivable Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Dulicate Type"; "Dulicate Type")
            {
                ApplicationArea = All;
            }
            field("Dulicate Vendor Action User ID"; "Dulicate Vendor Action User ID")
            {
                ApplicationArea = All;
            }
            field("Grantee GST Prod Posting Group"; "Grantee GST Prod Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }

}