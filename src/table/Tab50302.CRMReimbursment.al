table 50302 "CRM Reimbursment"
{
    // Dynamics CRM Version: 9.1.0.6820

    Caption = 'Reimbursement';
    Description = 'Reimbursement';
    ExternalName = 'new_reimbursement';
    TableType = CRM;

    fields
    {
        field(1; New_reimbursementId; Guid)
        {
            Caption = 'Reimbursement';
            Description = 'Unique identifier for entity instances';
            ExternalAccess = Insert;
            ExternalName = 'new_reimbursementid';
            ExternalType = 'Uniqueidentifier';
        }
        field(2; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Description = 'Date and time when the record was created.';
            ExternalAccess = Read;
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
        }
        field(3; ModifiedOn; DateTime)
        {
            Caption = 'Modified On';
            Description = 'Date and time when the record was modified.';
            ExternalAccess = Read;
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
        }
        field(4; statecode; Option)
        {
            Caption = 'Status';
            Description = 'Status of the Reimbursement';
            ExternalName = 'statecode';
            ExternalType = 'State';
            InitValue = " ";
            OptionCaption = ' ,Active,Inactive';
            OptionOrdinalValues = -1, 0, 1;
            OptionMembers = " ",Active,Inactive;
        }
        field(5; statuscode; Option)
        {
            Caption = 'Status Reason';
            Description = 'Reason for the status of the Reimbursement';
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            InitValue = " ";
            OptionCaption = ' ,Active/Open,Paid';
            OptionOrdinalValues = -1, 1, 2;
            OptionMembers = " ","Active/Open",Paid;
        }
        field(6; VersionNumber; BigInteger)
        {
            Caption = 'Version Number';
            Description = 'Version Number';
            ExternalAccess = Read;
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
        }
        field(7; ImportSequenceNumber; Integer)
        {
            Caption = 'Import Sequence Number';
            Description = 'Sequence number of the import that created this record.';
            ExternalAccess = Insert;
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
        }
        field(8; OverriddenCreatedOn; DateTime)
        {
            Caption = 'Record Created On';
            Description = 'Date and time that the record was migrated.';
            ExternalAccess = Insert;
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
        }
        field(9; TimeZoneRuleVersionNumber; Integer)
        {
            Caption = 'Time Zone Rule Version Number';
            Description = 'For internal use only.';
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(10; UTCConversionTimeZoneCode; Integer)
        {
            Caption = 'UTC Conversion Time Zone Code';
            Description = 'Time zone code that was in use when the record was created.';
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(11; New_name; Text[100])
        {
            Caption = 'Name';
            Description = 'The name of the custom entity.';
            ExternalName = 'new_name';
            ExternalType = 'String';
        }
        field(12; dynamics_integrationkey; Text[250])
        {
            Caption = 'Integration Key';
            Description = 'An integration key for the Dynamics Product line';
            ExternalName = 'dynamics_integrationkey';
            ExternalType = 'String';
        }
        field(13; New_FMSRecordID; Text[100])
        {
            Caption = 'FMS Record ID';
            Description = 'FMS Record ID';
            ExternalName = 'new_fmsrecordid';
            ExternalType = 'String';
        }
        field(14; New_ReimbursementAmount; Decimal)
        {
            Caption = 'Reimbursement Amount';
            Description = '';
            ExternalName = 'new_reimbursementamount';
            ExternalType = 'Money';
        }
        field(15; ExchangeRate; Decimal)
        {
            Caption = 'Exchange Rate';
            Description = 'Exchange rate for the currency associated with the entity with respect to the base currency.';
            ExternalAccess = Read;
            ExternalName = 'exchangerate';
            ExternalType = 'Decimal';
        }
        field(16; new_reimbursementamount_Base; Decimal)
        {
            Caption = 'Reimbursement Amount (Base)';
            Description = 'Value of the Reimbursement Amount in base currency.';
            ExternalAccess = Read;
            ExternalName = 'new_reimbursementamount_base';
            ExternalType = 'Money';
        }
        field(17; New_ReimbursementDate; DateTime)
        {
            Caption = 'Reimbursement Date';
            Description = '';
            ExternalName = 'new_reimbursementdate';
            ExternalType = 'DateTime';
        }
        field(18; New_ReimbursementNote; Text[250])
        {
            Caption = 'Reimbursement Note';
            Description = '';
            ExternalName = 'new_reimbursementnote';
            ExternalType = 'String';
        }
        field(19; New_ReimbursementType; Option)
        {
            Caption = 'Reimbursement Type';
            Description = '';
            ExternalName = 'new_reimbursementtype';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' ,Credit Memo,Invoive';
            OptionOrdinalValues = -1, 2, 809060001;
            OptionMembers = " ",CreditMemo,Invoive;
        }
        field(20; new_RefundReceived; Boolean)
        {
            Caption = 'Refund Received';
            Description = '';
            ExternalName = 'new_refundreceived';
            ExternalType = 'Boolean';
        }
        field(21; new_CheckNumber; Text[100])
        {
            Caption = 'Check Number';
            Description = '';
            ExternalName = 'new_checknumber';
            ExternalType = 'String';
        }
        field(22; new_RefundAmount; Decimal)
        {
            Caption = 'Refund Amount';
            Description = '';
            ExternalName = 'new_refundamount';
            ExternalType = 'Money';
        }
        field(23; new_refundamount_Base; Decimal)
        {
            Caption = 'Refund Amount (Base)';
            Description = 'Value of the Refund Amount in base currency.';
            ExternalAccess = Read;
            ExternalName = 'new_refundamount_base';
            ExternalType = 'Money';
        }
        field(50001; CreatedBy; Guid)
        {
            Caption = 'Created By';
            Description = 'Shows who created the record.';
            ExternalAccess = Read;
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(50002; ModifiedBy; Guid)
        {
            Caption = 'Modified By';
            Description = 'Shows who last updated the record.';
            ExternalAccess = Read;
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(50003; alletec_granteeid; Text[100])
        {
            Caption = 'Grantee ID';
            Description = 'Grantee ID';
            ExternalName = 'alletec_granteeid';
            ExternalType = 'String';
        }
        field(50004; alletec_actualpaymentdate; DateTime)
        {
            Caption = 'Actual payment date';
            Description = 'Actual payment date';
            ExternalName = 'alletec_actualpaymentdate';
            ExternalType = 'DateTime';
        }
        field(50005; new_GranteeRegion; Text[100])
        {
            Caption = 'Grantee Region';
            Description = '';
            ExternalName = 'new_granteeregion';
            ExternalType = 'String';
        }
        field(50006; alletec_gstapplicable; Boolean)
        {
            Caption = 'GST Applicable';
            Description = 'GST Applicable';
            ExternalName = 'alletec_gstapplicable';
            ExternalType = 'Boolean';
        }
        field(50007; alletec_appnumber; Text[100])
        {
            Caption = 'App Number';
            Description = 'App Number';
            ExternalName = 'alletec_appnumber';
            ExternalType = 'String';
        }
        field(50008; alletec_grantapplicationname; Text[100])
        {
            Caption = 'Grant Application Name';
            Description = 'Grant Application Name';
            ExternalName = 'alletec_grantapplicationname';
            ExternalType = 'String';
        }
        field(50009; alletec_pushedtobc; Boolean)
        {
            Caption = 'Pushed to BC';
            Description = '';
            ExternalName = 'alletec_pushedtobc';
            ExternalType = 'Boolean';
        }
        field(50011; alletec_npcapprovedamount; Decimal)
        {
            Caption = 'NPC Approved Amount';
            Description = '';
            ExternalName = 'alletec_npcapprovedamount';
            ExternalType = 'Money';
        }
        field(50012; alletec_granteeacceptedamount; Decimal)
        {
            Caption = 'Grantee Accepted Amount';
            Description = '';
            ExternalName = 'alletec_granteeacceptedamount';
            ExternalType = 'Money';
        }
        field(50013; alletec_refundpending; Decimal)
        {
            Caption = 'Refund Pending';
            Description = '';
            ExternalName = 'alletec_refundpending';
            ExternalType = 'Money';
        }
        field(50014; alletec_granteename; Text[100])
        {
            Caption = 'Grantee Name';
            Description = '';
            ExternalName = 'alletec_granteename';
            ExternalType = 'String';
        }
        field(50015; alletec_totalrefundamount; Decimal)
        {
            Caption = 'Total Refund Amount';
            Description = '';
            ExternalName = 'alletec_totalrefundamount';
            ExternalType = 'Money';
        }
        field(50016; alletec_bctransactionnumber; text[100])
        {
            Caption = 'BC Transaction Number';
            Description = '';
            ExternalName = 'alletec_bctransactionnumber';
            ExternalType = 'String';
        }

    }

    keys
    {
        key(Key1; New_reimbursementId)
        {
        }
        key(Key2; New_name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; New_name)
        {
        }
    }
}
