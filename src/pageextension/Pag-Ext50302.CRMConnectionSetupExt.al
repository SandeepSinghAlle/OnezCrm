pageextension 50302 "CRM Connection Setup Ext" extends "CRM Connection Setup"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Navigation)
        {
            action("Update Payment date IN CRM")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Visible = true;
                trigger OnAction()
                var
                    CoupleGranteeVendor: Codeunit "Couple Existing Grantee";
                    UpdatePaymentStatus: Codeunit "Update Payment Status IN CRM";
                begin
                    //CoupleGranteeVendor.CoupleExistingVendorGrantees();
                    UpdatePaymentStatus.Run();
                    Message('Payment status updated in CRM.');
                end;
            }
        }
    }

    var
        myInt: Integer;
}