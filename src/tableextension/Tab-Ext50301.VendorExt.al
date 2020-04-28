tableextension 50301 "VendorExt" extends Vendor
{
    fields
    {
        field(50001; "CRM Vendor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Bank Account No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Name on Account"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; Duplicate; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Duplicate With"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
        }
        field(50007; "Duplicate Reason"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

}