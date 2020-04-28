codeunit 50304 "Get Duplicate Vendor In BC"
{
    trigger OnRun()
    begin
        GetDuplicateVendor;
        if FoundDuplicate then begin
            CreateUserTask();
            Sendmail();
        end;

    end;

    local procedure GetDuplicateVendor()
    var
        Vendor: Record Vendor;
        SalesRecSetup: Record "Sales & Receivables Setup";
        VendorBankAccount: Record "Vendor Bank Account";
        DuplicateVendor: Record Vendor;
        Text001: TextConst ENU = 'Bank account duplicate';
        Text002: TextConst ENU = 'Vendor Name duplicate';
        Text003: TextConst ENU = 'Vendor Name and Bank Account duplicate';
    begin
        Vendor.Reset;
        Vendor.SetRange(Duplicate, true);
        if Vendor.FindFirst then
            repeat
                Vendor.Duplicate := false;
                Vendor."Duplicate Reason" := '';
                Vendor."Duplicate With" := '';
                Vendor.Modify;
            until Vendor.Next = 0;

        SalesRecSetup.get;
        Vendor.Reset;
        Vendor.SetRange("CRM Vendor", true);
        if vendor.FindSet then
            repeat
                //check duplicate on basis bank account no.
                if (SalesRecSetup."Dulicate Type" = SalesRecSetup."Dulicate Type"::"Bank Account No.") and (Vendor."Bank Account No." <> '') then begin
                    VendorBankAccount.Reset;
                    VendorBankAccount.SetFilter("Vendor No.", '<>%1', Vendor."No.");
                    VendorBankAccount.SetRange("Bank Account No.", Vendor."Bank Account No.");
                    if VendorBankAccount.FindFirst then
                        repeat
                            if (DuplicateVendor.get(VendorBankAccount."Vendor No.")) and (DuplicateVendor."Vendor Posting Group" = 'GRANTEES') then begin
                                DuplicateVendor.Duplicate := true;
                                DuplicateVendor."Duplicate With" := Vendor."No.";
                                DuplicateVendor."Duplicate Reason" := Text001;
                                DuplicateVendor.Modify;
                                FoundDuplicate := true;
                            end;
                        until VendorBankAccount.Next = 0;
                end;
                //check duplicate on basis vendor name
                if (SalesRecSetup."Dulicate Type" = SalesRecSetup."Dulicate Type"::"Vendor Name") and (Vendor.Name <> '') then begin
                    DuplicateVendor.Reset;
                    DuplicateVendor.SetFilter("No.", '<>%1', Vendor."No.");
                    DuplicateVendor.SetRange(Name, Vendor.Name);
                    DuplicateVendor.SetRange("Vendor Posting Group", 'GRANTEES');
                    if DuplicateVendor.FindFirst then
                        repeat
                            DuplicateVendor.Duplicate := true;
                            DuplicateVendor."Duplicate With" := Vendor."No.";
                            DuplicateVendor."Duplicate Reason" := Text002;
                            DuplicateVendor.Modify;
                            FoundDuplicate := true;
                        until DuplicateVendor.Next = 0;
                end;
                //check duplicate on basis both
                if SalesRecSetup."Dulicate Type" = SalesRecSetup."Dulicate Type"::Both then begin
                    DuplicateVendor.Reset;
                    DuplicateVendor.SetFilter("No.", '<>%1', Vendor."No.");
                    DuplicateVendor.SetRange("Vendor Posting Group", 'GRANTEES');
                    DuplicateVendor.SetRange(Name, Vendor.Name);
                    if DuplicateVendor.FindFirst then
                        repeat
                            VendorBankAccount.Reset;
                            VendorBankAccount.SetRange("Vendor No.", DuplicateVendor."No.");
                            VendorBankAccount.SetRange("Bank Account No.", Vendor."Bank Account No.");
                            if VendorBankAccount.FindFirst then
                                repeat
                                    DuplicateVendor.Duplicate := true;
                                    DuplicateVendor."Duplicate With" := Vendor."No.";
                                    DuplicateVendor."Duplicate Reason" := Text003;
                                    DuplicateVendor.Modify;
                                    FoundDuplicate := true;
                                until VendorBankAccount.Next = 0;
                        until DuplicateVendor.Next = 0;
                end;
            until Vendor.Next = 0;
    end;

    local procedure CreateUserTask()
    var
        UserTask: Record "User Task";
        User: Record User;
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        SalesRecSetup.Get;
        User.Reset();
        User.SetRange("User Name", SalesRecSetup."Dulicate Vendor Action User ID");
        if User.FindFirst then begin
            UserTask.Init;
            UserTask.Title := 'Duplicate Vendors';
            UserTask."Assigned To" := user."User Security ID";
            UserTask."Percent Complete" := 0;
            UserTask.Priority := UserTask.Priority::Normal;
            UserTask."Object Type" := UserTask."Object Type"::Page;
            UserTask."Object ID" := 27;
            UserTask.Insert(true);
        end;
    end;

    local procedure Sendmail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Vendor: Record Vendor;
        SalesRecSetup: record "Sales & Receivables Setup";
        User: Record User;
        RecipientList: List of [Text];
        CCList: List of [Text];
    begin
        SMTPMailSetup.GET;
        SalesRecSetup.Get;
        User.Reset();
        User.SetRange("User Name", SalesRecSetup."Dulicate Vendor Action User ID");
        if User.FindFirst then
            RecipientList.Add(User."Contact Email");

        SMTPMail.CreateMessage('Dynamics 365 Business Central', SMTPMailSetup."User ID",
                                RecipientList, 'Duplicate Vendors found in Business Central', '');
        //SMTPMail.AddCC('sansingh@alletec.com'); //remove in live deployment.
        CCList.Add('sansingh@alletec.com');
        CCList.Add('billy@onenz.nz');
        //CCList.Add('harpreetsingh@alletec.com');
        SMTPMail.AddBCC(CCList);
        SMTPMail.AppendBody('Dear Sir / Madam,');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Please take action on below duplicate records found in vendor master.');
        SMTPMail.AppendBody('<br><Br>');
        SMTPMail.AppendBody('<table border="1">');

        SMTPMail.AppendBody('<tr>');
        SMTPMail.AppendBody('<th>Vendor No._Existing(BC)</th>');
        SMTPMail.AppendBody('<th>Vendor Name</th>');
        SMTPMail.AppendBody('<th>Vendor No._New(D365)</th>');
        SMTPMail.AppendBody('<th>Reason of duplicate</th>');
        SMTPMail.AppendBody('</tr>');

        Vendor.reset;
        Vendor.SetRange(Duplicate, true);
        IF Vendor.FINDSET THEN BEGIN
            REPEAT
                SMTPMail.AppendBody('<tr>');
                SMTPMail.AppendBody('<td>' + FORMAT(Vendor."No.") + '</td>');
                SMTPMail.AppendBody('<td>' + FORMAT(Vendor.Name) + '</td>');
                SMTPMail.AppendBody('<td>' + FORMAT(Vendor."Duplicate With") + '</td>');
                SMTPMail.AppendBody('<td>' + FORMAT(Vendor."Duplicate Reason") + '</td>');
                SMTPMail.AppendBody('</tr>');
            UNTIL Vendor.NEXT = 0;
        END;
        SMTPMail.AppendBody('</table>');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody('This is a system generated mail. Please do not reply to this email ID.');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.Send;

    end;

    var
        FoundDuplicate: Boolean;
}