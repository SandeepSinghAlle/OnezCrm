codeunit 50302 "Update Payment Status IN CRM"
{

    trigger OnRun()
    begin
        CRMConnectionSetup.GET;
        CRMConnectionSetup.RegisterConnection;

        CRMReimbursment.RESET;
        //CRMReimbursment.SetRange(New_reimbursementId, '{81673147-8C28-EA11-A810-000D3A79722D}');
        //CRMReimbursment.SetRange(New_name, 'REM-1009-2020');
        CRMReimbursment.SETRANGE(alletec_actualpaymentdate, DefaultDT);
        IF CRMReimbursment.FINDSET THEN
            REPEAT
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETRANGE("External Document No.", CRMReimbursment.New_name);
                VendorLedgerEntry.SetRange(Reversed, false);
                VendorLedgerEntry.SetFilter("Document Type", '%1|%2', VendorLedgerEntry."Document Type"::Invoice, VendorLedgerEntry."Document Type"::"Credit Memo");
                //if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then
                if CRMReimbursment.New_ReimbursementType = CRMReimbursment.New_ReimbursementType::Invoive then
                    VendorLedgerEntry.SETRANGE(Open, FALSE);
                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                    DetailedVendorLedgEntry.RESET;
                    DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                    DetailedVendorLedgEntry.SETRANGE("Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);
                    if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::Invoice then
                        DetailedVendorLedgEntry.SetRange("Document Type", DetailedVendorLedgEntry."Document Type"::Payment)
                    else
                        if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then
                            DetailedVendorLedgEntry.SetFilter("Document Type", '%1|%2|%3', DetailedVendorLedgEntry."Document Type"::Payment,
                                                                DetailedVendorLedgEntry."Document Type"::Refund, DetailedVendorLedgEntry."Document Type"::"Credit Memo");
                    IF DetailedVendorLedgEntry.FINDLAST THEN BEGIN
                        CRMReimbursment.alletec_actualpaymentdate := CREATEDATETIME(DetailedVendorLedgEntry."Posting Date", 0T);

                        FindApplnEntriesDtldtLedgEntry(VendorLedgerEntry);
                        if AppliedDocNo <> '' then
                            CRMReimbursment.alletec_bctransactionnumber := AppliedDocNo
                        else
                            CRMReimbursment.alletec_bctransactionnumber := DetailedVendorLedgEntry."Document No.";

                        VendorLedgerEntry.CalcFields("Remaining Amount");
                        if VendorLedgerEntry."Document Type" = VendorLedgerEntry."Document Type"::"Credit Memo" then
                            CRMReimbursment.alletec_refundpending := VendorLedgerEntry."Remaining Amount";
                        CRMReimbursment.MODIFY;
                    END;
                END;
            UNTIL CRMReimbursment.NEXT = 0;
    end;

    local procedure FindApplnEntriesDtldtLedgEntry(Rec1: Record "Vendor Ledger Entry")
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        Clear(AppliedDocNo);

        DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.", Rec1."Entry No.");
        DtldVendLedgEntry1.SETRANGE(Unapplied, FALSE);
        IF DtldVendLedgEntry1.FIND('-') THEN
            REPEAT
                IF DtldVendLedgEntry1."Vendor Ledger Entry No." =
                   DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
                THEN BEGIN
                    DtldVendLedgEntry2.INIT;
                    DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SETRANGE(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SETRANGE(Unapplied, FALSE);
                    IF DtldVendLedgEntry2.FIND('-') THEN
                        REPEAT
                            IF DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                               DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                            THEN BEGIN
                                Rec1.SETCURRENTKEY("Entry No.");
                                Rec1.SETRANGE("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                IF Rec1.FINDLAST THEN
                                    AppliedDocNo := Rec1."Document No."
                            END;
                        UNTIL DtldVendLedgEntry2.NEXT = 0;
                END ELSE BEGIN
                    Rec1.SETCURRENTKEY("Entry No.");
                    Rec1.SETRANGE("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    IF Rec1.FINDLAST THEN
                        AppliedDocNo := Rec1."Document No."
                END;
            UNTIL DtldVendLedgEntry1.NEXT = 0;
    end;

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CRMReimbursment: Record "CRM Reimbursment";
        Vendor: Record Vendor;
        DefaultDT: DateTime;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        CRMConnectionSetup: Record "CRM Connection Setup";
        AppliedDocNo: Code[20];

}
