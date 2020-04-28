codeunit 50303 "Couple Existing Grantee"
{

    trigger OnRun()
    begin
        //CoupleExistingVendorGrantees;
    end;

    var
        Vendor: Record "Vendor";
        //IntegrationRecord: Record "Integration Record";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMAccountExt: Record CRMAccountExt;
        CRMConnectionSetup: Record "CRM Connection Setup";

    /*procedure CoupleExistingVendorGrantees()
    begin
        Vendor.RESET;
        IF Vendor.FINDFIRST THEN
            REPEAT
                Vendor.MODIFY(TRUE);
            UNTIL Vendor.NEXT = 0;

        CRMConnectionSetup.GET;
        CRMConnectionSetup.RegisterConnection;

        CRMAccountExt.RESET;
        CRMAccountExt.SETFILTER(AccountNumber, '<>%1', '');
        IF CRMAccountExt.FINDFIRST THEN
            REPEAT
                IF Vendor.GET(CRMAccountExt.AccountNumber) THEN BEGIN
                    IntegrationRecord.RESET;
                    IntegrationRecord.SETCURRENTKEY("Table ID", "Record ID");
                    IntegrationRecord.SETRANGE("Table ID", 23);
                    IntegrationRecord.SETRANGE("Record ID", Vendor.RECORDID);
                    IF IntegrationRecord.FINDFIRST THEN BEGIN
                        IF NOT CRMIntegrationRecord.GET(CRMAccountExt.AccountId, IntegrationRecord."Integration ID") THEN BEGIN
                            CRMIntegrationRecord.INIT;
                            CRMIntegrationRecord."CRM ID" := CRMAccountExt.AccountId;
                            CRMIntegrationRecord."Integration ID" := IntegrationRecord."Integration ID";
                            CRMIntegrationRecord."Table ID" := 23;
                            CRMIntegrationRecord.INSERT;
                        END;
                    END;
                END;
            UNTIL CRMAccountExt.NEXT = 0;

        MESSAGE('All exist grantee coupled with Vendors.');
    end;*/

    // procedure CoupleExistingVendorGrantees()
    // begin

    //     CRMConnectionSetup.GET;
    //     CRMConnectionSetup.RegisterConnection;

    //     CRMAccountExt.RESET;
    //     CRMAccountExt.SETFILTER(AccountNumber, 'G-4137|G-4609|G-3178|G-3499|G-4402|G-5142|G-5498|G-4003|G-2899|G-3181|G-3302|G-4843|G-7016|G-4812|G-5265|G-4309|G-3045|G-3898|G-5350|G-3317|G-5496|G-5580|G-5813|G-3092');
    //     IF CRMAccountExt.FindSet THEN
    //         REPEAT

    //             CRMIntegrationRecord.Reset;
    //             CRMIntegrationRecord.SetRange("Table ID", 23);
    //             CRMIntegrationRecord.SetRange("CRM ID", CRMAccountExt.AccountId);
    //             if CRMIntegrationRecord.FindSet then
    //                 repeat
    //                     CRMIntegrationRecord.Delete;
    //                 until CRMIntegrationRecord.Next = 0;

    //             IF Vendor.GET(CRMAccountExt.AccountNumber) THEN BEGIN
    //                 IntegrationRecord.RESET;
    //                 IntegrationRecord.SETCURRENTKEY("Table ID", "Record ID");
    //                 IntegrationRecord.SETRANGE("Table ID", 23);
    //                 IntegrationRecord.SETRANGE("Record ID", Vendor.RECORDID);
    //                 IF IntegrationRecord.FINDFIRST THEN BEGIN
    //                     IF NOT CRMIntegrationRecord.GET(CRMAccountExt.AccountId, IntegrationRecord."Integration ID") THEN BEGIN
    //                         CRMIntegrationRecord.INIT;
    //                         CRMIntegrationRecord."CRM ID" := CRMAccountExt.AccountId;
    //                         CRMIntegrationRecord."Integration ID" := IntegrationRecord."Integration ID";
    //                         CRMIntegrationRecord."Table ID" := 23;
    //                         CRMIntegrationRecord.INSERT;
    //                     END;
    //                 END;
    //             END;
    //         UNTIL CRMAccountExt.NEXT = 0;

    //     MESSAGE('All exist grantee coupled with Vendors.');
    // end;

}

