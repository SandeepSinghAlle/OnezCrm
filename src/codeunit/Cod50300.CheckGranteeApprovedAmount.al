codeunit 50300 "Check Grantee Approved Amount"
{
    [EventSubscriber(ObjectType::Codeunit, 13, 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure CheckGranteeApprovedAmt(VAR GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; VAR Posted: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine1: Record "Gen. Journal Line";
        GrantAcceptecAmt: Decimal;
        NPCApprovedAmt: Decimal;
        GrantAppNo: Code[30];
        Text50000: TextConst ENU = 'The Invoice amount for Grant No %1 does not match with the Grantee Accepted amount.\Please verify and correct lines before posting.';
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetCurrentKey("Grant Application Number");
        GenJnlLine.SetRange("Journal Template Name", 'General');
        GenJnlLine.SetRange("Journal Batch Name", 'GRANTSINV');
        GenJnlLine.SetRange("Document Type", GenJnlLine."Document Type"::Invoice); //SS
        GenJnlLine.SetRange("Grant Application Number", GenJournalLine."Grant Application Number");
        IF GenJnlLine.FindSet() then begin
            repeat
                NPCApprovedAmt := 0;
                if GrantAppNo <> GenJnlLine."Grant Application Number" then begin
                    GenJnlLine1.Reset();
                    GenJnlLine1.SetRange("Journal Template Name", 'General');
                    GenJnlLine1.SetRange("Journal Batch Name", 'GRANTSINV');
                    GenJnlLine1.SetRange("Document Type", GenJnlLine1."Document Type"::Invoice);
                    GenJnlLine1.SetRange("Grant Application Number", GenJnlLine."Grant Application Number");
                    if GenJnlLine1.FindSet() then begin
                        GrantAcceptecAmt := GenJnlLine1."Grantee Accepted Amount";
                        repeat
                            NPCApprovedAmt += ABS(GenJnlLine1.Amount);
                        until GenJnlLine1.Next() = 0;
                    end;
                    if NPCApprovedAmt <> GrantAcceptecAmt then
                        Error(Text50000, GenJnlLine1."Grant Application Number");
                end;
                GrantAppNo := GenJnlLine."Grant Application Number";
            until GenJnlLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure TransferGenJournalLineToVLE(VAR VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Grant Application Number" := GenJournalLine."Grant Application Number";
        VendorLedgerEntry."NPC Approved Amount" := GenJournalLine."NPC Approved Amount";
        VendorLedgerEntry."Grantee Accepted Amount" := GenJournalLine."Grantee Accepted Amount";
    end;
}