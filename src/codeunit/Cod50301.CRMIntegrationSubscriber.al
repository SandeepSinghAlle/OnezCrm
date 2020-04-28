codeunit 50301 "CRM Integration Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, 5345, 'OnAfterInsertRecord', '', false, false)]
    local procedure OnInsertCRMVendor(IntegrationTableMapping: Record "Integration Table Mapping"; var SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        VendorBankAccount: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        RecRef: RecordRef;
        CRMAccount: Record CRMAccountExt;
        IntegrationManagement: Codeunit "Integration Management";

    begin
        IF (SourceRecordRef.NUMBER <> DATABASE::CRMAccountExt) OR (DestinationRecordRef.NUMBER <> DATABASE::Vendor) THEN
            EXIT;
        SourceRecordRef.SETTABLE(CRMAccount);
        DestinationRecordRef.SETTABLE(Vendor);

        IF NOT VendorBankAccount.GET(Vendor."No.", Vendor."Bank Account No.") THEN BEGIN
            VendorBankAccount.INIT;
            VendorBankAccount.VALIDATE("Vendor No.", Vendor."No.");
            VendorBankAccount.VALIDATE(Code, Vendor."Bank Account No.");
            VendorBankAccount.VALIDATE("Bank Account No.", Vendor."Bank Account No.");
            VendorBankAccount.INSERT(TRUE);

            Vendor."EFT Bank Account No." := Vendor."Bank Account No.";
            Vendor."Preferred Bank Account Code" := Vendor."Bank Account No.";
            Vendor.Modify(true);
        END ELSE begin
            VendorBankAccount.Validate("Bank Account No.", Vendor."Bank Account No.");
            VendorBankAccount.Modify;
        END;
        //RecRef.GETTABLE(Vendor);
        //IntegrationManagement.OnDatabaseModify(RecRef);
        //IntegrationManagement.InsertUpdateIntegrationRecord(RecRef, CurrentDateTime);
        //Vendor.Modify(true);
        UpdateVendorNoInCRM(Vendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5345, 'OnBeforeModifyRecord', '', false, false)]
    local procedure OnAfterModifyCRMVendor(IntegrationTableMapping: Record "Integration Table Mapping"; SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        VendorBankAccount: Record "Vendor Bank Account";
        Vendor: Record Vendor;
        RecRef: RecordRef;
        CRMAccount: Record CRMAccountExt;
    begin
        IF (SourceRecordRef.NUMBER <> DATABASE::CRMAccountExt) OR (DestinationRecordRef.NUMBER <> DATABASE::Vendor) THEN
            EXIT;
        SourceRecordRef.SETTABLE(CRMAccount);
        DestinationRecordRef.SETTABLE(Vendor);
        IF Vendor."CRM Vendor" THEN BEGIN
            IF NOT VendorBankAccount.GET(Vendor."No.", Vendor."Bank Account No.") THEN BEGIN
                VendorBankAccount.INIT;
                VendorBankAccount.VALIDATE("Vendor No.", Vendor."No.");
                VendorBankAccount.VALIDATE(Code, Vendor."Bank Account No.");
                VendorBankAccount.VALIDATE("Bank Account No.", Vendor."Bank Account No.");
                VendorBankAccount.INSERT(TRUE);

                Vendor."EFT Bank Account No." := Vendor."Bank Account No.";
                Vendor."Preferred Bank Account Code" := Vendor."Bank Account No.";
            END ELSE begin
                VendorBankAccount.Validate("Bank Account No.", Vendor."Bank Account No.");
                VendorBankAccount.Modify;
            END;
        END;
        DestinationRecordRef.GetTable(Vendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5345, 'OnBeforeInsertRecord', '', false, false)]
    local procedure OnBeforeInsertCRMGenLine(IntegrationTableMapping: Record "Integration Table Mapping"; SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        GenJournalLine: Record "Gen. Journal Line";
        CRMReimbursment: Record "CRM Reimbursment";
        LastLineNo: Integer;
        LastGenJournalLine: Record "Gen. Journal Line";
        DescriptionText: Text;
    begin
        IF (SourceRecordRef.NUMBER <> DATABASE::"CRM Reimbursment") OR (DestinationRecordRef.NUMBER <> DATABASE::"Gen. Journal Line") THEN
            EXIT;

        SourceRecordRef.SETTABLE(CRMReimbursment);
        DestinationRecordRef.SETTABLE(GenJournalLine);

        CLEAR(LastLineNo);
        LastGenJournalLine.RESET;
        LastGenJournalLine.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        LastGenJournalLine.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        IF LastGenJournalLine.FINDLAST THEN
            LastLineNo := LastGenJournalLine."Line No." + 10000
        ELSE
            LastLineNo := 10000;

        GenJournalLine."Line No." := LastLineNo;
        GenJournalLine.Validate("Document No.", CRMReimbursment.New_name);
        //GenJournalLine.Validate(Description, CRMReimbursment.alletec_grantapplicationname);
        Clear(DescriptionText);
        DescriptionText := CRMReimbursment.alletec_appnumber + '_' + CRMReimbursment.alletec_grantapplicationname;
        DescriptionText := CopyStr(DescriptionText, 1, 100);
        GenJournalLine.Validate(Description, DescriptionText);
        GenJournalLine.Validate("External Document No.", CRMReimbursment.New_name);
        GenJournalLine."CRM Grantee Name" := CRMReimbursment.alletec_granteename;
        //GenJournalLine.Validate("External Document No.", CRMReimbursment.alletec_appnumber);
        DestinationRecordRef.GETTABLE(GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5345, 'OnAfterInsertRecord', '', false, false)]
    local procedure OnAfterInsertCRMGenLine(IntegrationTableMapping: Record "Integration Table Mapping"; var SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        GenJournalLine: Record "Gen. Journal Line";
        CRMReimbursment: Record "CRM Reimbursment";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        ShortcutDim3: Code[20];
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        IF (SourceRecordRef.NUMBER <> DATABASE::"CRM Reimbursment") OR (DestinationRecordRef.NUMBER <> DATABASE::"Gen. Journal Line") THEN
            EXIT;

        SourceRecordRef.SETTABLE(CRMReimbursment);
        DestinationRecordRef.SETTABLE(GenJournalLine);

        SalesRecSetup.Get();
        IF CRMReimbursment.New_ReimbursementType = CRMReimbursment.New_ReimbursementType::Invoive THEN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
        ELSE
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

        GenJnlTemplate.GET(GenJournalLine."Journal Template Name");
        GenJnlBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");

        //GenJournalLine.Validate("Document No.", CRMReimbursment.New_name);
        //GenJournalLine.Validate(Description, CRMReimbursment.alletec_grantapplicationname);
        //GenJournalLine.Validate("External Document No.", CRMReimbursment.alletec_appnumber);
        GenJournalLine.VALIDATE("Posting Date", TODAY);
        GenJournalLine.VALIDATE("Document Date", TODAY);
        GenJournalLine.VALIDATE("Due Date", DT2DATE(CRMReimbursment.New_ReimbursementDate));

        IF GenJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            GenJournalLine."Document No." := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", GenJournalLine."Posting Date", TRUE);
        END;

        GenJournalLine."Source Code" := GenJnlTemplate."Source Code";
        GenJournalLine."Reason Code" := GenJnlBatch."Reason Code";
        GenJournalLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJournalLine."Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        GenJournalLine.VALIDATE("Bal. Account No.", GenJnlBatch."Bal. Account No.");
        //GenJournalLine."Journal Batch Id" := GenJnlBatch.Id;  //commented due to obslete
        GenJournalLine."Journal Batch Id" := GenJnlBatch.SystemId;

        GlobalDim1 := CRMReimbursment.new_GranteeRegion;
        GlobalDim2 := 'ALL';
        ShortcutDim3 := 'CORP';
        GenJournalLine.Validate("Shortcut Dimension 1 Code", GlobalDim1);
        GenJournalLine.Validate("Shortcut Dimension 2 Code", GlobalDim2);
        GenJournalLine.ValidateShortcutDimCode(1, GlobalDim1);
        GenJournalLine.ValidateShortcutDimCode(2, GlobalDim2);
        GenJournalLine.ValidateShortcutDimCode(3, ShortcutDim3);

        IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice THEN
            GenJournalLine.Amount := -1 * CRMReimbursment.New_ReimbursementAmount
        else
            if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then
                GenJournalLine.Amount := CRMReimbursment.new_RefundAmount;

        GenJournalLine.VALIDATE(Amount);
        if CRMReimbursment.alletec_gstapplicable then begin
            GenJournalLine.Validate("Bal. VAT Prod. Posting Group", SalesRecSetup."Grantee GST Prod Posting Group");
            GenJournalLine.Validate("Bal. Gen. Posting Type", GenJournalLine."Bal. Gen. Posting Type"::Purchase);
        END;

        GenJournalLine."CRM Grantee Name" := CRMReimbursment.alletec_granteename;
        GenJournalLine.MODIFY(TRUE);
        CRMReimbursment.alletec_pushedtobc := true;
        CRMReimbursment.Modify();
    end;

    procedure UpdateVendorNoInCRM(_Vendor: Record Vendor)
    var
        CRMAccount: Record CRMAccountExt;
        CRMConnectionSetup: Record "CRM Connection Setup";
        //IntegrationRecord: Record "Integration Record";
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin

        // IntegrationRecord.Reset;
        // IntegrationRecord.SetRange("Table ID", 23);
        // IntegrationRecord.SetRange("Record ID", _Vendor.RecordId);
        // if IntegrationRecord.FindFirst then begin
        CRMIntegrationRecord.Reset;
        CRMIntegrationRecord.SetRange("Table ID", 23);//Sandeep
        // CRMIntegrationRecord.SetRange("Integration ID", IntegrationRecord."Integration ID");
        CRMIntegrationRecord.SetRange("Integration ID", _Vendor.SystemId);
        if CRMIntegrationRecord.FindFirst then begin
            CRMConnectionSetup.GET;
            CRMConnectionSetup.RegisterConnection;
            CRMAccount.RESET;
            CRMAccount.SETRANGE(CRMAccount.AccountId, CRMIntegrationRecord."CRM ID");
            IF CRMAccount.FindFirst then begin
                CRMAccount.AccountNumber := _Vendor."No.";
                CRMAccount.Modify;
            end;
        end;
        // end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Vendor Card", 'OnBeforeActionEvent', 'MergeDuplicate', false, false)]
    local procedure BlockMerge(var Rec: Record Vendor)
    begin
        if not Rec."CRM Vendor" then begin
            Error('Incorrect grantee. Go to %1 to merge records.', Rec."Duplicate With");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5345, 'OnAfterModifyRecord', '', false, false)]
    local procedure OnAfterModifyCRMGenLine(IntegrationTableMapping: Record "Integration Table Mapping"; var SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        GenJournalLine: Record "Gen. Journal Line";
        CRMReimbursment: Record "CRM Reimbursment";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        ShortcutDim3: Code[20];
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        IF (SourceRecordRef.NUMBER <> DATABASE::"CRM Reimbursment") OR (DestinationRecordRef.NUMBER <> DATABASE::"Gen. Journal Line") THEN
            EXIT;

        SourceRecordRef.SETTABLE(CRMReimbursment);
        DestinationRecordRef.SETTABLE(GenJournalLine);

        SalesRecSetup.Get();
        IF CRMReimbursment.New_ReimbursementType = CRMReimbursment.New_ReimbursementType::Invoive THEN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice)
        ELSE
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::"Credit Memo");

        GenJnlTemplate.GET(GenJournalLine."Journal Template Name");
        GenJnlBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");

        GenJournalLine.VALIDATE("Posting Date", TODAY);
        GenJournalLine.VALIDATE("Document Date", TODAY);
        GenJournalLine.VALIDATE("Due Date", DT2DATE(CRMReimbursment.New_ReimbursementDate));

        GlobalDim1 := CRMReimbursment.new_GranteeRegion;
        GlobalDim2 := 'ALL';
        ShortcutDim3 := 'CORP';
        GenJournalLine.Validate("Shortcut Dimension 1 Code", GlobalDim1);
        GenJournalLine.Validate("Shortcut Dimension 2 Code", GlobalDim2);
        GenJournalLine.ValidateShortcutDimCode(1, GlobalDim1);
        GenJournalLine.ValidateShortcutDimCode(2, GlobalDim2);
        GenJournalLine.ValidateShortcutDimCode(3, ShortcutDim3);

        IF GenJournalLine."Document Type" = GenJournalLine."Document Type"::Invoice THEN
            GenJournalLine.Amount := -1 * CRMReimbursment.New_ReimbursementAmount
        else
            if GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo" then
                GenJournalLine.Amount := CRMReimbursment.new_RefundAmount;

        GenJournalLine.VALIDATE(Amount);
        if CRMReimbursment.alletec_gstapplicable then begin
            GenJournalLine.Validate("Bal. VAT Prod. Posting Group", SalesRecSetup."Grantee GST Prod Posting Group");
            GenJournalLine.Validate("Bal. Gen. Posting Type", GenJournalLine."Bal. Gen. Posting Type"::Purchase);
        END;
        GenJournalLine."CRM Grantee Name" := CRMReimbursment.alletec_granteename;
        GenJournalLine.MODIFY(TRUE);
    end;
}