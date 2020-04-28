pageextension 50303 "Vendor List Ext" extends "Vendor List"
{
    layout
    {
        addlast(Control1)
        {
            field("CRM Vendor"; "CRM Vendor")
            {
                ApplicationArea = All;
            }
            field(Duplicate; Duplicate)
            {
                ApplicationArea = All;
            }
            field("Duplicate With"; "Duplicate With")
            {
                ApplicationArea = All;
            }
            field("Duplicate Reason"; "Duplicate Reason")
            {
                ApplicationArea = All;
            }
        }
    }
}