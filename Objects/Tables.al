table 90000 "Sacco Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member Application Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "Member Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Loan Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(5; "Loan Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Receipt Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "FD Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Collateral Application Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Loan Repayment Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Maintenance Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Member Editing Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Payment Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "JV Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Calculator Nos"; code[20])
        {
            TableRelation = "No. Series";
        }

        field(15; "Cheque Deposit Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(16; "Standing Order Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "FOSA Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(18; "Teller Transaction Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(19; "Checkoff Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; "Guarantor Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(21; "ATM Application Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(22; "Member Exit Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(23; "Dividend Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Member Reactivation Nos"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Cash Deposit Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(26; "Cash Withdrawal Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(27; "Interest Accrual Type"; Option)
        {
            OptionMembers = "Accrual Basis","Cash Basis";
        }
        field(28; "Loan Batch Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "Member Exits Control"; Code[20])
        {
            TableRelation = Vendor where("Account Type" = const("Supplier"));
        }
        field(30; "Defaulter Notice Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(31; "Loan Recovery Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(32; "Cheque Book App. Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33; "Cheque Book Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(34; "Inter Acc. Trans. Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(35; "Acc. Opening Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(36; "Guarantor Notice Charge"; Decimal)
        {
            TableRelation = "No. Series";
        }
        field(37; "Guarantor Notice Inc. Acc."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(38; "Bulk SMS Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(39; "Checkoff Variation Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(40; "Mobile Application Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(41; "Online Loan Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(42; "Minimum Deposit Cont."; Decimal) { }
        field(43; "Block SMS"; Boolean) { }
        field(44; "Guarantor Multiplier"; Decimal) { }
        field(45; "Defaulter Loan Product"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Loan Account"));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90001 "Product Factory"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Product Factory";
    LookupPageId = "Product Factory";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Product Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Savings Account","Loan Account","Investment Account","Transacting Account";
        }
        field(3; "Name"; Text[50])
        {

        }
        field(4; Prefix; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "New","Active";
            trigger OnValidate()
            begin
                TestField(Prefix);
            end;
        }
        field(6; "Earns Dividend"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "ATM Use Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Mobile Banking Allowed"; Boolean) { }
        field(9; "Posting Group"; Code[10])
        {
            TableRelation = if ("Product Type" = const("Investment Account")) "Customer Posting Group"
            else
            "Vendor Posting Group";
        }
        field(10; "Interest Due Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true), "Income/Balance" = filter("Balance Sheet"));
            trigger OnValidate()
            begin
                TestField("Product Type", "Product Type"::"Loan Account");
            end;
        }
        field(11; "Interest Paid Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true), "Income/Balance" = filter("Income Statement"));
            trigger OnValidate()
            begin
                TestField("Product Type", "Product Type"::"Loan Account");
            end;
        }
        field(12; "Interest Rate"; Decimal) { }
        field(13; "Interest Repayment Method"; Option)
        {
            OptionMembers = "Straight Line","Reducing Balance","Amortised";
        }
        field(14; "Grace Period"; DateFormula) { }
        field(15; "Fixed Deposit"; Boolean) { }
        field(16; "Biilling Account"; code[20])
        {
            TableRelation = "Product Factory";
        }
        field(17; "Penalty Due Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        field(18; "Penalty Paid Account"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        field(19; "Penalty Grace Period"; DateFormula) { }
        field(20; "Interest Bands"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Product Interest Bands" where("Product Code" = field(Code), Active = const(true)));
        }
        field(21; "Penalty Rate"; Decimal) { }
        field(22; "Account Class"; option)
        {
            OptionMembers = General,NWD,Collections,"Fixed Deposit",Loan;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                Vendor.Reset();
                Vendor.SetRange("Account Code", Code);
                if Vendor.FindSet() then begin
                    repeat
                        Vendor."Account Class" := "Account Class";
                        Vendor.Modify();
                    until Vendor.Next() = 0;
                end;
            end;
        }
        field(23; "Rate Type"; Option)
        {
            OptionMembers = "Per-Annum","Per Month","Fixed";
        }
        field(24; "E-Loan"; Boolean) { }
        field(25; "Loan Multiplier"; decimal) { }

        field(26; "Ordinary Default Intallments"; integer) { }
        field(27; "Minimum Balance"; Decimal) { }
        field(28; "Minimum Contribution"; Decimal)
        {
        }
        Field(29; "Grace Period - Interest"; DateFormula) { }
        field(30; "Minimum Guarantors"; Integer) { }
        Field(31; "Minimum Loan Amount"; Decimal) { }
        field(32; "Maximum Loan Amount"; Decimal) { }
        field(33; "Loan Span"; Option)
        {
            OptionMembers = "Short Term","Loang Term";
        }
        field(34; "Repay Mode"; Option)
        {
            OptionMembers = Checkoff,"Standing Order","Direct Debit";
        }
        field(35; "Minimum Deposit Balance"; Decimal) { }
        Field(36; "Minimum Deposit Contribution"; Decimal) { }
        Field(37; "Discounting %"; Decimal)
        {
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(38; "Charge UpFront Interest"; boolean)
        {
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(39; "Allow Mobile Applications"; Boolean)
        {
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(40; "Allow Self Guarantee"; Boolean)
        {
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(41; "Max. Member Age"; Integer) { }
        field(42; "Net Salary Multiplier %"; Decimal) { }
        field(43; "View Online"; Boolean)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(44; "Requires Salary Processig"; Boolean) { }
        Field(45; "Mobile Loan"; Boolean) { }
        field(46; "Check Off Codes"; Code[20]) { }
        field(47; "Exclude Billing & Interest"; Boolean)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(48; "Loan Recovery Commission %"; Decimal)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(49; "Commission Account"; code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(50; Suffix; Code[20]) { }
        field(51; "Insurance Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(52; "Insurance Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;

        }
        field(53; "Insurance Account"; code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;

        }
        field(54; "Insurance Income %"; Decimal)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(55; "Insurance Income Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }

        field(56; "Guarantor Multiplier"; Decimal)
        {

        }
        field(57; "Disbursal Method"; Option)
        {
            OptionMembers = FOSA,"Bank Transfer(Direct)","Bank Transfer(Indirect)";

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(58; "Disbursement Account"; Code[20])
        {
            TableRelation = if ("Disbursal Method" = const("Bank Transfer(Direct)")) "Bank Account"."No." WHERE("Account Type" = const(main))
            else
            if ("Disbursal Method" = const("Bank Transfer(Indirect)")) Vendor."No." where("Member No." = filter(''));

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(59; "Boost Deposits"; Boolean)
        {

            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(60; "Appraise with 0 Deposits"; Boolean)
        {
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(61; "Loan Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
            trigger OnValidate()
            begin
                rec.TestField("Account Class", Rec."Account Class"::Loan);
            end;
        }
        field(62; "NWD Account"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Account Class" IN ["Account Class"::Loan, "Account Class"::"Fixed Deposit"] then
                    Error('Please Select the correct account class');
                TestField("Share Capital", false);
            end;
        }
        field(63; "Share Capital"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Account Class" IN ["Account Class"::Loan, "Account Class"::"Fixed Deposit"] then
                    Error('Please Select the correct account class');
                TestField("NWD Account", false);
            end;
        }
        field(64; "Cheque Book Allowed"; Boolean)
        {
            trigger OnValidate()
            var
                Window: Dialog;
                Vendor: Record Vendor;
            begin
                if "Account Class" <> "Account Class"::Collections then
                    Error('Cheque Books cannot be linked to %1 accounts', "Account Class");
                Vendor.Reset();
                Vendor.SetRange("Account Code", Code);
                if Vendor.FindSet() then begin
                    Window.Open('Endforcing Changes \#1###');
                    repeat
                        Window.Update(1, Vendor."Search Name");
                        Vendor."Cheque Book Allowed" := "Cheque Book Allowed";
                        Vendor.Modify();
                    until Vendor.Next() = 0;
                    Window.Close();
                end;
            end;
        }
        field(65; "Juniour Account"; Boolean) { }
        field(66; "No. Series"; code[20])
        {
            TableRelation = "No. Series";
        }
        field(67; "Mobile Appraisal Type"; Option)
        {
            OptionMembers = "Deposit Multiplier","Percent Of Lowest Salary","Dividend Percentage","Percent of Net Salary";
        }
        field(68; "Mobile Appraisal Calculator"; Decimal) { }
        field(69; "Minimum Installments"; Integer) { }
        field(70; "Maximum Installments"; Integer) { }
        field(71; "Cash Deposit Allowed"; Boolean) { }
        field(72; "Cash Withdrawal Allowed"; Boolean) { }
        field(73; "Search Code"; Code[20]) { }
        field(74; "Max. NWD Boost"; Decimal) { }
        field(75; "Max. NWD Boost %"; Decimal) { }
        field(76; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
            trigger OnValidate()
            begin
                case "Member Posting Type" of
                    "Member Posting Type"::"Share Capital":
                        "Share Capital" := true;
                    "Member Posting Type"::"Non Withrawable Deposit":
                        "NWD Account" := true;
                    "Member Posting Type"::Loans:
                        "Account Class" := "Account Class"::Loan;
                end;
            end;
        }
        field(77; "Salary Based"; Boolean) { }
        field(78; "Min. Salary Count"; Integer) { }
        field(79; "Salary %"; Decimal)
        {
            MaxValue = 100;
        }
        field(80; "Salary Appraisal Type"; Option)
        {
            OptionMembers = "Average Net","Lowest Net";
        }
        field(81; "Special Loan Multiplier"; Boolean) { }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        LoansManagement: Codeunit "Loans Management";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestField(Status, Status::New);
    end;

    trigger OnRename()
    begin

    end;

}

table 90002 "Member Categories"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50])
        {

        }
        field(3; "Is Group"; Boolean) { }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90003 "Category Default Accounts"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Category Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Product Factory" where("Product Type" = filter(<> "Loan Account"));
            trigger OnValidate()
            begin
                if ProductFactory.get("Product Code") then
                    "Product Description" := ProductFactory.Name;
            end;
        }
        field(3; "Product Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Category Code", "Product Code")
        {
            Clustered = true;
        }
    }

    var
        ProductFactory: Record "Product Factory";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90004 "Member Application"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Member Applications";
    DrillDownPageId = "Member Applications";
    fields
    {
        field(1; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(3; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(4; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(5; "Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                "First Name" := UpperCase("First Name");
                "Middle Name" := UpperCase("Middle Name");
                "Last Name" := UpperCase("Last Name");
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }
        field(6; "Mobile Phone No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Alt. Phone No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Male","Female","Other";
        }
        field(9; "National ID No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if CalcDate('-18Y', Today) < "Date of Birth" then
                    Error('The Member has not attained the minimum age of 18years');
            end;
        }
        field(11; "Payroll No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(12; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "New","Pending Approval","Approved";
            Editable = false;
        }
        field(15; Address; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; County; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Counties;
        }
        field(18; "Sub County"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Counties" where("County Code" = field(County));
        }
        field(19; "Member Category"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Member Categories";
            trigger onvalidate()
            Var
                MemberCategory: Record "Member Categories";
            begin
                if MemberCategory.Get("Member Category") then
                    "Is Group" := MemberCategory."Is Group";
            end;
        }
        field(20; "E-Mail Address"; Text[250])
        {
            ExtendedDatatype = EMail;
        }
        field(21; "Employer Code"; code[20])
        {
            TableRelation = "Employer Codes";
        }
        field(22; Processed; Boolean) { }
        field(23; "Member Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(24; "Front ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(25; "Back ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(26; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Widowed,Divorced,Withheld;
        }
        field(27; "KRA PIN"; Code[20])
        {

        }
        field(28; Occupation; Text[100]) { }
        field(29; "Type of Residence"; Option)
        {
            OptionMembers = Rented,Owned;
        }
        field(30; "Member No."; code[20]) { }
        field(31; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(32; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(33; "Spouse Name"; Code[150]) { }
        field(34; "Spouse ID No"; Code[150]) { }
        field(35; "Spouse Phone No"; Code[150]) { }
        field(36; "Town of Residence"; code[50]) { }
        field(37; "Estate of Residence"; code[50]) { }
        field(38; "Station Code"; Code[20])
        {
            TableRelation = "Employer Stations"."Station Code" where("Employer Code" = field("Employer Code"));
        }
        field(39; Designation; Text[50]) { }
        field(40; Nationality; Option)
        {
            OptionMembers = Kenyan,Diaspora;
        }
        field(41; "Sales Person"; Code[20])
        {
            TableRelation = if ("Recruited By" = const("Sales person")) "Salesperson/Purchaser" else
            if ("Recruited By" = const(Member)) Members."Member No.";
        }
        field(42; Mobile; Boolean) { }
        field(43; ATM; Boolean) { }
        field(44; Portal; Boolean) { }
        field(45; "Certificate of Incoop"; code[20])
        {
        }
        field(46; "Group No"; Code[20]) { }
        field(47; "Group Name"; Text[150]) { }
        field(48; "Is Group"; Boolean) { }
        field(49; "Date of Registration"; Date) { }
        field(50; "Certificate Expiry"; Date) { }
        field(51; "PIN No"; Code[20]) { }
        field(52; "Mobile Transacting No"; Code[30]) { }
        field(53; "Recruited By"; Option)
        {
            OptionMembers = "Sales person",Member;
        }
        field(54; "Member Signature"; blob)
        {
            Subtype = Bitmap;
        }
        field(55; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted,Processing;
        }
        field(56; "Rejection Comments"; text[150]) { }
        field(57; "FOSA"; Boolean) { }
        field(58; "Marketing Texts"; Boolean) { }
        field(59; "Subscription Start Date"; Date) { }
        field(60; "Protected Account"; Boolean) { }
        field(61; "Account Owner"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(62; "Source Type"; Option)
        {
            OptionMembers = Member,Staff,"Social Media";
        }

        field(63; "Source No"; Text[100])
        {
        }
    }

    keys
    {
        key(PK; "Application No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        MemberApplication: Record "Member Application";
        MemberMgt: Codeunit "Member Management";

    trigger OnInsert()
    begin
        if CurrentClientType = ClientType::Windows then begin
            MemberApplication.Reset();
            MemberApplication.SetRange("Created By", UserId);
            MemberApplication.SetRange(Processed, false);
            if MemberApplication.FindSet() then begin
                if MemberApplication.Count > 2 then
                    Error('You are only allowed for 2 open records');
            end;
        end;
        SaccoSetup.get;
        SaccoSetup.TestField("Member Application Nos.");
        if "Application No." = '' then
            "Application No." := NoSeries.GetNextNo(SaccoSetup."Member Application Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        MemberMgt.PopulateSubscriptions(Rec);
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90005 "Employer Codes"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = Employers;
    LookupPageId = employers;
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[50]) { }
        field(3; Address; Text[50]) { }
        field(4; "Phone No"; Code[50]) { }
        field(5; "Email Address"; Code[20]) { }
        field(6; "Checkoff Account"; Code[20])
        {
            TableRelation = Customer;
        }
        field(7; "Salary Account"; Code[20])
        {
            TableRelation = Customer;
        }
        field(8; "Suspense Account"; Code[20])
        {
            TableRelation = Customer;
        }
        field(9; SelfEmployement; boolean)
        {
           //TableRelation=Customer;

        }
    }


    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
        key(Key2; Name, "Email Address", "Phone No") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Name, "Phone No", "Email Address")
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90006 "Nexts of Kin"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Source Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Kin Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Child","Spouse","Parent","Nephew","Niece","Uncle","Aunt","Cousin","Other";
        }
        field(3; "KIN ID"; code[20]) { }
        field(4; "Date of Birth"; date)
        {
            trigger onvalidate()
            var
                MemberMgt: Codeunit "Member Management";
            begin
                if "Kin Type" IN ["Kin Type"::Aunt, "Kin Type"::Parent, "Kin Type"::Spouse] then
                    MemberMgt.Check18("Date of Birth");
            end;
        }
        field(5; "Phone No."; code[20]) { }
        field(6; "Allocation"; decimal)
        {
            trigger OnValidate()
            begin
                if Allocation > 100 then
                    Error('Allocation cannot be more than 100');
            end;
        }
        field(7; Name; Text[150]) { }

    }

    keys
    {
        key(PK; "Source Code", "Kin Type", "KIN ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90007 "Member Subscriptions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Source Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = filter(<> "Loan Account"));
            trigger OnValidate()
            begin
                if ProductFactory.get("Account Type") then
                    "Account Name" := ProductFactory.Name;
            end;
        }
        field(3; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(4; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if rec.Amount < rec."Minmum Contribution" then
                    Error('You Cannot subscribe less than the minimum contribution of %1', "Minmum Contribution");
            end;
        }
        field(5; "Start Date"; date) { }
        field(6; "Minmum Contribution"; Decimal)
        {
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Source Code", "Account Type")
        {
            Clustered = true;
        }
    }

    var
        ProductFactory: Record "Product Factory";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90008 "Members"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(3; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(4; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(5; "Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }
        field(6; "Mobile Phone No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Alt. Phone No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Male","Female","Other";
        }
        field(9; "National ID No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Payroll No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(12; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "New","Pending Approval","Approved";
            Editable = false;
        }
        field(15; Address; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; County; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Counties;
        }
        field(18; "Sub County"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Counties" where("County Code" = field(County));
        }
        field(19; "Member Category"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Member Categories";
        }
        field(20; "E-Mail Address"; Text[250])
        {
            ExtendedDatatype = EMail;
        }
        field(21; "Employer Code"; code[20])
        {
            TableRelation = "Employer Codes";
        }
        field(22; "Total Deposits"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Member No." = field("Member No."), "Posting Date" = field("Date Filter"), "Member Posting Type" = const("Non Withrawable Deposit")));

        }
        field(23; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(24; "Total Shares"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = - sum("Detailed Vendor Ledg. Entry".Amount where("Member No." = field("Member No."), "Posting Date" = field("Date Filter"), "Member Posting Type" = const("Share Capital")));

        }
        field(25; "Running Loans"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where(Posted = const(true), "Member No." = field("Member No.")));
            Editable = false;
        }
        field(26; "Held Collateral"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Collateral Register".Guarantee where("Member No" = field("Member No."), Status = filter(<> Collected)));
            Editable = false;
        }
        field(27; "Outstanding Loans"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Member No." = field("Member No."), "Posting Date" = field("Date Filter"), "Member Posting Type" = const(loans)));

        }
        field(28; "Member Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(29; "Front ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(30; "Back ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(31; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Widowed,Divorced,Withheld;
        }
        field(32; "KRA PIN"; Code[20])
        {

        }
        field(33; Occupation; Text[100]) { }
        field(34; "Type of Residence"; Option) { OptionMembers = Rented,Owned; }
        field(35; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(36; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(37; "Spouse Name"; Code[150]) { }
        field(38; "Spouse ID No"; Code[150]) { }
        field(39; "Spouse Phone No"; Code[150]) { }
        field(40; "Estate of Residence"; code[50]) { }
        field(41; "Town of Residence"; Code[50]) { }
        field(42; "Station Code"; Code[20]) { }
        field(43; Designation; text[50]) { }
        field(44; "Payroll No"; code[20]) { }
        field(45; Nationality; Option)
        {
            OptionMembers = Kenyan,Diaspora;
        }

        field(46; "Sales Person"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(47; Mobile; Boolean) { }
        field(48; ATM; Boolean) { }
        field(49; Portal; Boolean) { }
        field(50; "Certificate of Incoop"; code[20])
        {

        }
        field(51; "Group No"; Code[20]) { }
        field(52; "Group Name"; Text[150]) { }
        field(53; "Certificate Expiry"; Date) { }
        field(54; "Date of Registration"; Date) { }
        field(55; "Mobile Transacting No"; Code[30]) { }
        field(56; "Is Group"; Boolean) { }
        field(57; "Self Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Guarantees"."Guaranteed Amount" where("Member No" = field("Member No."), Self = const(true)));
            Editable = false;
        }
        field(58; "Non-Self Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Guarantees"."Guaranteed Amount" where("Member No" = field("Member No."), Self = const(false)));
            Editable = false;
        }
        field(59; "Uncleared Effect"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Uncleared Effects".Amount where("Member No" = field("Member No.")));
            Editable = false;
        }
        field(60; "Member Status"; Option)
        {
            OptionMembers = Active,Defaulter,"Withdrawal-Pending",Withdrawn,Desceased;
            Editable = false;
        }
        field(61; "Account Filter"; Code[20])
        {
            TableRelation = Vendor where("Member No." = field("Member No."));
            FieldClass = FlowFilter;
        }
        field(62; "Loan Filter"; code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Loan Application" where("Member No." = field("Member No."));
        }
        field(63; "Account Type Filter"; Code[20])
        {
            TableRelation = "Product Factory";
            FieldClass = FlowFilter;
        }
        field(65; "Member Signature"; blob)
        {
            Subtype = Bitmap;
        }
        field(66; "FOSA"; Boolean) { }
        field(67; "Marketing Texts"; Boolean) { }
        field(68; "Subscription Start Date"; Date) { }
        field(69; "Protected Account"; Boolean) { }
        field(70; "Account Owner"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(71; "Portal Signed Up"; Boolean) { }
        field(72; "Mobile Loan Blocked"; Boolean) { }
        field(73; "Fosa Account Activated"; Boolean) { }
        field(74; "FOSA Account Activator"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(75; "Can Guarantee"; Boolean) { }

    }

    keys
    {
        key(PK; "Member No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Member No.", "National ID No", "Full Name", "Mobile Phone No.") { }
    }
    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90009 "Bankers Cheque Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50]) { }
        field(3; "Account Type"; Option)
        {
            OptionMembers = "Member Account","G/L Account",Vendor,"Bank Account";
        }
        field(4; "Maximum Amount"; Decimal) { }
        field(5; "Walkin Allowed"; Boolean) { }
        field(6; "Transaction Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Leaf Nos."; code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Clearing Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(9; "Clearing Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90010 "Bankers Cheque"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Bankers Cheques Lookup";
    fields
    {
        field(1; "Cheque Type"; code[20])
        {
            TableRelation = "Bankers Cheque Types";
            trigger OnValidate()
            var
                ChequeTypes: record "Bankers Cheque Types";
            begin
                if ChequeTypes.get("Cheque Type") then begin
                    Description := ChequeTypes.Description;
                    "Walkin Allowed" := ChequeTypes."Walkin Allowed";
                    if not "Walkin Allowed" then "Source Type" := "Source Type"::Member;
                    "Max. Amount" := ChequeTypes."Maximum Amount";
                    "No. Series" := ChequeTypes."Transaction Nos.";
                    "Leaf Nos." := ChequeTypes."Leaf Nos.";
                end
            end;

        }
        field(2; "Document No."; code[20]) { Editable = false; }
        field(3; Description; Text[50]) { Editable = false; }
        field(4; "Max. Amount"; Decimal) { Editable = false; }
        field(5; "Walkin Allowed"; boolean) { Editable = false; }
        field(6; "Source Type"; Option)
        {
            OptionMembers = Member,Walkin;
            Editable = false;
            trigger OnValidate()
            begin
                if "Source Type" = "Source Type"::Walkin then
                    TestField("Walkin Allowed");
            end;
        }
        field(7; "Member No."; Code[20])
        {
            TableRelation = if ("Source Type" = const(Member)) Members;
            trigger OnValidate()
            begin
                if Members.Get("Member No.") then
                    "Account Name" := Members."Full Name";
            end;
        }
        field(8; "Account Type"; Code[20])
        {
            TableRelation = if ("Source Type" = const(Member)) Vendor."No." where("Member No." = field("Member No."))
            else
            if ("Source Type" = const(Walkin)) "Bank Account";
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if "Source Type" = "Source Type"::Walkin then begin
                    if BankAccount.get("Account Type") then begin
                        "Account Name" := BankAccount.Name;
                        BankAccount.CalcFields(Balance);
                        "Book Balance" := BankAccount.Balance;
                    end;
                end else begin
                    if Vendor.get("Account Type") then begin
                        Vendor.CalcFields(Balance);
                        "Book Balance" := Vendor.Balance;
                    end;
                end;
            end;
        }
        field(9; "Account Name"; Text[50]) { Editable = false; }
        field(10; "Leaf No."; code[20]) { }
        field(11; "Book Balance"; Decimal) { Editable = false; }
        field(12; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if Amount > "Max. Amount" then
                    Error('You Cannot Sell Bankers Cheques More than %1', "Max. Amount");
                if "Source Type" = "Source Type"::Member then begin
                    if Amount > "Book Balance" then
                        Error('You Cannot Sell Bankers Cheques More than %1', "Book Balance");
                end;
                if Amount < 0 then
                    Error('Please fill in the amount');
            end;
        }
        field(13; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(14; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(15; "Posting Date"; Date) { }
        field(16; Posted; Boolean) { Editable = false; }
        field(17; "Payee Details"; Text[250]) { }
        field(18; "No. Series"; code[20]) { Editable = false; }
        field(19; "Leaf Nos."; Code[20]) { Editable = false; }
        field(20; "Approval Status"; option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
    }

    keys
    {
        key(Key1; "Cheque Type", "Document No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        Members: Record Members;
        BankAccount: record "Bank Account";

    trigger OnInsert()
    begin
        "Document No." := NoSeries.GetNextNo("No. Series", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := WorkDate();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90011 "Cheque Deposits"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No"; code[20])
        {
            TableRelation = members;
            trigger onvalidate()
            var
                Members: Record Members;
            begin
                if members.get("Member No") then
                    "Member Name" := members."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Account No."; code[20])
        {
            TableRelation = Vendor where("Member No." = field("Member No"));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if vendor.get("Account No.") then begin
                    "Account Name" := vendor.name;
                end
            end;
        }
        field(5; "Account Name"; Text[150])
        {
            Editable = false;
        }
        field(6; "Cheque No"; Code[30]) { }
        field(7; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Total Clearing Charges");
            end;
        }
        field(8; "Drawer Account Name"; text[150]) { }
        field(9; "Drawer Bank"; code[50]) { }
        field(10; "Drawer Account No."; code[30]) { }
        field(11; "Drawer Branch"; Code[20]) { }
        field(12; "Clearing Account No."; code[20])
        {
            TableRelation = "Bank Account";
        }
        field(13; "Deposit Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("Marturity Date");
            end;
        }
        field(14; "Marturity Period"; DateFormula)
        {
            trigger OnValidate()
            begin
                Validate("Marturity Date");
            end;
        }
        field(15; "Marturity Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                "Marturity Date" := CalcDate("Marturity Period", "Deposit Date");
            end;
        }
        field(16; "Created By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(17; "Created On"; Datetime)
        {
            editable = false;
        }
        field(18; "Document Status"; Option)
        {
            editable = false;
            optionmembers = New,Received,Bounced,Cleared,Archived;
        }
        field(19; "Clearing Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
            trigger OnValidate()
            begin
                Validate("Total Clearing Charges");
            end;
        }
        field(20; "Bouncing Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(21; "Express Clearing Charges"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(22; "Cheque Type"; Code[20])
        {
            TableRelation = "Cheque Types";
            trigger OnValidate()
            var
                ChequeTypes: Record "Cheque Types";
            begin
                ChequeTypes.Get("Cheque Type");
                "Clearing Account No." := ChequeTypes."Clearing Account";
                "Clearing Charges" := ChequeTypes."Clearing Charge Code";
                "Bouncing Charges" := ChequeTypes."Bouncing Charge Code";
                "Express Clearing Charges" := ChequeTypes."Express Clearing Charge Code";
            end;
        }
        field(23; "Total Clearing Charges"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                JournalManagement: Codeunit "Journal Management";
            begin
                "Total Clearing Charges" := JournalManagement.GetTransactionCharges("Clearing Charges", Amount);
            end;
        }
        field(24; "Instructions Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cheque Instructions".Amount where("Document No" = field("Document No")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Cheque Deposit Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Cheque Deposit Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Deposit Date" := Today;
        Evaluate("Marturity Period", '2D');
        "Marturity Date" := CalcDate("Marturity Period", "Deposit Date");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90012 "Receipt Posting Types"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Receipt Posting Types";
    DrillDownPageId = "Receipt Posting Types";
    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50]) { }
        field(3; "Posting Type"; Option)
        {
            OptionMembers = "Customer Receipt","Member Receipt","Loan Receipt","Vendor Receipt","Service Receipt","Inter Bank";
        }
        field(4; "Transaction Type"; Option)
        {
            OptionMembers = "General","Cash Deposit","Cash Withdrawal","Loan Disbursal","Principle Repayment","Interest Due"
            ,"Interest Paid","Penalty Due","Penalty Paid","Recovery","Fixed Deposit","Loan Charge";
        }
        field(5; "Account Type"; Code[20])
        {
            TableRelation = if ("Posting Type" = const("Member Receipt")) "Product Factory" where("Product Type" = filter(<> "Loan Account"))
            else
            if ("Posting Type" = const("Service Receipt")) "G/L Account" where("Direct Posting" = const(true));
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90013 "Receipt Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Receipts Lookup";
    DrillDownPageId = "Receipts Lookup";
    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Receiving Account Type"; Option)
        {
            OptionMembers = "Bank Account","G/L Account","Customer","Vendor";
        }
        field(3; "Receiving Account No."; Code[20])
        {
            TableRelation = if ("Receiving Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Receiving Account Type" = const(Customer)) Customer
            else
            if ("Receiving Account Type" = const(Vendor)) Vendor
            else
            if ("Receiving Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true));
            trigger OnValidate()
            begin
                case "Receiving Account Type" of
                    "Receiving Account Type"::"Bank Account":
                        begin
                            if Bank.get("Receiving Account No.") then
                                "Receiving Account Name" := Bank.Name;
                        end;
                    "Receiving Account Type"::Customer:
                        begin
                            if Customer.get("Receiving Account No.") then
                                "Receiving Account Name" := Customer.Name;
                        end;
                    "Receiving Account Type"::Vendor:
                        begin
                            if Vendor.get("Receiving Account No.") then
                                "Receiving Account Name" := Vendor.Name;
                        end;
                    "Receiving Account Type"::"G/L Account":
                        begin
                            if GLAccount.get("Receiving Account No.") then
                                "Receiving Account Name" := GLAccount.Name;
                        end;
                end;
            end;
        }
        field(4; "Receiving Account Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "External Document No."; code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Payment Method Code"; code[20])
        {
            TableRelation = "Payment Method";
        }
        field(7; "Posting Date"; Date) { }
        field(8; "Posting Description"; Text[50]) { }
        field(9; Amount; Decimal) { }
        field(10; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(11; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "Allocated Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Receipt Lines".Amount where("Receipt No." = field("Receipt No.")));
            Editable = false;
        }
        field(14; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(15; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(16; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Receipt No.")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        Bank: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Receipt Nos.");
        "Receipt No." := NoSeries.GetNextNo(SaccoSetup."Receipt Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90014 "Receipt Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Receipt Type"; Code[20])
        {
            TableRelation = "Receipt Posting Types";
            trigger OnValidate()
            begin
                if ReceiptPostingTypes.get("Receipt Type") then begin
                    Description := ReceiptPostingTypes.Description;
                    "Transaction Type" := ReceiptPostingTypes."Transaction Type";
                    "Posting Type" := ReceiptPostingTypes."Posting Type";
                    "Account Type" := ReceiptPostingTypes."Account Type";
                    validate("Bal. Account No.");
                end;
            end;
        }

        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(5; "Posting Type"; Option)
        {
            OptionMembers = "Customer Receipt","Member Receipt","Loan Receipt","Vendor Receipt","Service Receipt","Inter Bank";
            Editable = false;
        }
        field(6; "Transaction Type"; Option)
        {
            OptionMembers = "General","Cash Deposit","Cash Withdrawal","Loan Disbursal","Principle Repayment","Interest Due"
            ,"Interest Paid","Penalty Due","Penalty Paid","Recovery","Fixed Deposit","Loan Charge";
            Editable = false;
        }
        field(7; "Account Type"; Code[20])
        {
            TableRelation = if ("Posting Type" = const("Member Receipt")) "Product Factory" where("Product Type" = filter(<> "Loan Account"))
            else
            if ("Posting Type" = const("Loan Receipt")) "Product Factory" where("Product Type" = const("Loan Account"))
            else
            if ("Posting Type" = const("Customer Receipt")) Customer
            else
            if ("Posting Type" = const("Inter Bank")) "Bank Account" where(Blocked = const(false))
            else
            if ("Posting Type" = const("Vendor Receipt")) Vendor where("Account Type" = const(0))
            else
            if ("Posting Type" = const("Service Receipt")) "G/L Account" where("Direct Posting" = const(true));
            trigger OnValidate()
            begin
                validate("Bal. Account No.");
            end;
        }
        field(8; "Bal. Account No."; Code[20])
        {
            Editable = false;
            trigger OnValidate()
            begin
                if "Posting Type" IN ["Posting Type"::"Customer Receipt", "Posting Type"::"Inter Bank", "Posting Type"::"Service Receipt", "Posting Type"::"Vendor Receipt"] then begin
                    "Bal. Account No." := "Account Type";
                end else begin
                    if "Posting Type" = "Posting Type"::"Member Receipt" then begin
                        if ProductFactory.get("Account Type") then begin
                            Vendor.Reset();
                            Vendor.SetRange(Blocked, 0);
                            Vendor.SetRange("Member No.", "Member No.");
                            Vendor.SetRange("Account Code", ProductFactory.Code);
                            if Vendor.FindFirst() then
                                "Bal. Account No." := Vendor."No.";
                        end;
                    end else
                        if "Posting Type" = "Posting Type"::"Loan Receipt" then begin
                            if ProductFactory.get("Account Type") then begin
                                IF Vendor.get(ProductFactory.Prefix + "Member No.") THEN
                                    "Bal. Account No." := Vendor."No.";
                            end;
                        end;
                end;
            end;
        }
        field(9; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application" where("Member No." = field("Member No."));
            trigger OnValidate()
            var
                LoansMgt: Codeunit "Loans Management";
                Receipt: Record "Receipt Header";
                LoanApplication: Record "Loan Application";
            begin
                Receipt.Get("Receipt No.");
                LoanApplication.Get("Loan No.");
                LoanApplication.CalcFields("Loan Balance");
                "Loan Balance" := LoanApplication."Loan Balance";
                "Prorated Interest" := LoansMgt.GetProratedInterest("Loan No.", Receipt."Posting Date");
            end;
        }
        field(10; Amount; Decimal) { }
        field(11; "Member No."; Code[20])
        {
            TableRelation = IF ("Posting Type" = filter("Loan Receipt" | "Member Receipt")) Members;
            trigger OnValidate()
            begin
                Validate("Bal. Account No.");
            end;
        }
        field(12; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(13; "Prorated Interest"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Receipt No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        ReceiptPostingTypes: record "Receipt Posting Types";
        Vendor: Record Vendor;
        ProductFactory: Record "Product Factory";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;



}
table 90015 "Loan Application"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Application No", "Member Name", "Product Description", "Approved Amount", "Approval Status";
    LookupPageId = "Loans Lookup";
    DrillDownPageId = "Loans Lookup";
    fields
    {
        field(1; "Application No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                if Members.get("Member No.") then begin
                    "Member Name" := Members."Full Name";
                    "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                end;
                "Qualified Salarywise" := LoansManagement.AppraiseFosaSalary("Member No.", "Product Code", "Application No");
                LoansManagement.PopulateAppraisalParameters(Rec);
                "Share Capital" := LoansManagement.GetMemberShares("Member No.");
                Deposits := LoansManagement.GetMemberDeposits("Member No.");
                "Total Loans" := LoansManagement.GetMemberLoans("Member No.");
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Product Code"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Loan Account"), Status = const(Active));
            trigger OnValidate()
            var
                MemberDeposits: Decimal;
                Member: Record Members;
                LoansManagement: Codeunit "Loans Management";
            begin
                ProductSetup.Get("Product Code");
                Rec.TestField("Member No.");
                Member.Get(Rec."Member No.");
                MemberDeposits := LoansManagement.GetMemberDeposits(Member."Member No.");
                if ProductSetup."Appraise with 0 Deposits" = false then begin
                    if MemberDeposits <= 0 then
                        Error('You Cannot Appraise %1 With %2 Deposits', ProductSetup.Name, MemberDeposits);
                end;
                if ProductSetup."Salary Based" then begin
                    "Qualified Salarywise" := LoansManagement.AppraiseFosaSalary(Member."Member No.", "Product Code", "Application No");
                end;
                if MemberDeposits < ProductSetup."Minimum Deposit Balance" then
                    Error('You Cannot Appraise %1 With %2 Deposits', ProductSetup.Name, MemberDeposits);
                Rec."Product Description" := ProductSetup.Name;
                Rec."Interest Rate" := ProductSetup."Interest Rate";
                Rec."Interest Repayment Method" := ProductSetup."Interest Repayment Method";
                Rec."Grace Period" := ProductSetup."Grace Period";
                Rec."Posting Date" := Rec."Application Date";
                Rec."Rate Type" := ProductSetup."Rate Type";
                Rec.Installments := ProductSetup."Ordinary Default Intallments";
                Rec."Mode of Disbursement" := Rec."Mode of Disbursement"::FOSA;
                Rec."Disbursement Account" := LoansManagement.GetFOSAAccount(Rec."Member No.");
                Rec."Interest Repayment Method" := ProductSetup."Interest Repayment Method";
                Rec.Validate(Installments);
                "Maximum Repayment Period" := ProductSetup."Maximum Installments";
                LoansManagement.PopulateAppraisalParameters(Rec);
            end;
        }
        field(5; "Product Description"; Text[50])
        {
            Editable = false;
        }
        field(6; "Applied Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                LoansManagement.ValidateAppraisal(Rec);
                Validate("Insurance Amount");
            end;
        }
        field(7; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate("Insurance Amount");
            end;
        }
        field(8; "Interest Rate"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 5;
        }
        field(9; "Interest Repayment Method"; Option)
        {
            OptionMembers = "Straight Line","Reducing Balance","Amortised";

        }
        field(10; Installments; Integer)
        {
            trigger OnValidate()
            var
                InterestBands: Record "Product Interest Bands";
            begin
                InterestBands.Reset();
                InterestBands.SetRange(Active, true);
                InterestBands.SetRange("Product Code", "Product Code");
                InterestBands.SetFilter("Min Installments", '<=%1', Installments);
                InterestBands.SetFilter("Max Installments", '>=%1', Installments);
                if InterestBands.FindFirst() then
                    "Interest Rate" := InterestBands."Interest Rate"
                else
                    Error('The Interest band for %1 %2 does not exist!', "Product Description", Installments);
            end;
        }
        field(11; "Repayment Frequency"; Option)
        {
            OptionMembers = "Monthly","Quarterly","Semi-Annualy","Annualy";
        }
        field(12; "Application Date"; Date) { }
        field(13; "Repayment Start Date"; Date)
        {
            Editable = false;
        }
        field(14; "Repayment End Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                LoansManagement: codeunit "Loans Management";
            begin
                "Repayment Start Date" := LoansManagement.GetRepaymentStartDate(Rec);
                "Repayment End Date" := CalcDate(Format(Installments) + 'M', "Repayment Start Date");
            end;
        }
        field(15; "Approval Status"; Option)
        {
            OptionMembers = "New","Approval Pending","Approved";
        }
        field(16; "Mode of Disbursement"; Option)
        {
            OptionMembers = "FOSA","Bank";
        }
        field(17; "Disbursement Account"; Code[20])
        {
            TableRelation = if ("Mode of Disbursement" = const(FOSA)) Vendor where("Member No." = field("Member No."), "Account Type" = const("Sacco"))
            else
            if ("Mode of Disbursement" = const(Bank)) "Bank Account";
        }
        field(18; "Posting Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                EndDate: Date;
            begin
                if "Posting Date" <> 0D then begin
                    EndDate := CalcDate('CM', "Posting Date");
                    Validate("Repayment End Date");
                    "Prorated Days" := EndDate - "Posting Date";
                end;
            end;
        }
        field(19; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(20; "Created On"; DateTime) { Editable = false; }
        field(21; Posted; Boolean) { Editable = false; }
        field(22; "Grace Period"; DateFormula)
        {
            Editable = false;
        }
        field(23; "Principle Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Principle Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(24; "Interest Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Interest Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(25; "Total Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Monthly Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(26; "Loan Account"; code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(27; "Billing Account"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(28; Charges; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Charges".Rate where("Loan No." = field("Application No")));
        }
        field(29; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(30; "Total Securities"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Guarantees"."Guaranteed Amount" where("Loan No" = field("Application No")));
        }
        field(31; "Accrued Interest"; decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Interest Accrual".Amount where("Loan No." = field("Application No"), "Entry Type" = const("Interest Accrual")));
        }
        field(32; "Sales Person"; code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                if SalesPerson.get("Sales Person") then
                    "Sales Person Name" := SalesPerson.Name;
            end;
        }
        field(33; "Sales Person Name"; Text[150])
        {
            Editable = false;
        }
        field(34; "Loan Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
        }
        field(35; "Principle Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Loan Disbursal" | "Principle Paid")));
        }
        field(36; "Interest Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Interest Due" | "Interest Paid")));
        }
        field(37; "Penalty Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Penalty Paid" | "Penalty Due")));
        }
        field(38; "Rate Type"; Option)
        {
            OptionMembers = "Per-Annum","Per Month","Fixed";
            Editable = false;
        }
        field(39; "Loan Classification"; Option)
        {
            OptionMembers = Performing,Watch,Substandard,Doubtfull,Loss;
            Editable = false;
        }
        field(40; "Defaulted Days"; Integer)
        {
            Editable = false;
        }
        field(41; "Principle Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Principle Paid")));
        }
        field(42; "Interest Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Interest Paid")));
        }
        field(43; "Penalty Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Penalty Paid")));
        }
        field(44; Closed; Boolean)
        {
            Editable = false;
        }
        field(45; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Editable = false;
        }
        field(46; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }
        field(47; "Total Interest Due"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Interest Due")));
        }
        field(48; "Total Penalty Due"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Penalty Due")));
        }
        field(49; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50; "Cheque No."; code[30]) { }
        field(51; "Freeze Penalty"; Boolean) { }
        field(52; "Freeze Interest"; Boolean) { }
        field(53; Disbursed; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Detailed Vendor Ledg. Entry" where("Document No." = field("Application No"), "Vendor No." = field("Loan Account"), "Transaction Type" = const("Loan Disbursal")));
        }
        field(54; "Monthly Inistallment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Loan Schedule"."Monthly Repayment" where("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(55; Status; Option)
        {
            Editable = false;
            OptionMembers = Application,Appraisal,Disbursed,Rejected,Reversed;
        }
        field(56; "Share Capital"; Decimal) { Editable = false; }
        Field(57; Deposits; Decimal) { Editable = false; }
        field(58; "Total Loans"; Decimal) { Editable = false; }
        field(59; "Sector Code"; Code[20])
        {
            TableRelation = "Economic Sectors";
        }
        field(60; "Sub Sector Code"; Code[20])
        {
            TableRelation = "Economic Subsectors"."Sub Sector Code" where("Sector Code" = field("Sector Code"));
        }
        field(61; "Sub-Susector Code"; Code[20])
        {
            TableRelation = "Economic Sub-subsector"."Sub-Subsector Code" where("Sector Code" = field("Sector Code"), "Sub Sector Code" = field("Sub Sector Code"));
        }
        field(62; Witness; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                LoansManagement.CheckOkToWitness(Witness, "Application No");
            end;
        }
        field(63; "Loan Batch No."; Code[20]) { }
        field(64; "Prorated Days"; Integer) { }
        field(65; "Prorated Interest"; Decimal) { }
        field(66; "Insurance Amount"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                LoanProduct: Record "Product Factory";
            begin
                if LoanProduct.Get("Product Code") then begin
                    if "Approved Amount" = 0 then begin
                        if "Applied Amount" > LoanProduct."Insurance Factor" then
                            "Insurance Amount" := ("Applied Amount" - LoanProduct."Insurance Factor") * LoanProduct."Insurance Rate" * 0.01
                        else
                            "Insurance Amount" := 0;
                    end else begin
                        if "Approved Amount" > LoanProduct."Insurance Factor" then
                            "Insurance Amount" := ("Approved Amount" - LoanProduct."Insurance Factor") * LoanProduct."Insurance Rate" * 0.01
                        else
                            "Insurance Amount" := 0;
                    end;
                end ELSE
                    "Insurance Amount" := 0;
            end;

        }
        field(67; "Recovery Mode"; Option)
        {
            OptionMembers = Checkoff,"Interna STO","External STO";
        }
        field(68; "Recommended Amount"; Decimal)
        {
            Editable = false;
        }
        field(69; "New Monthly Installment"; Decimal)
        {
            trigger OnValidate()
            begin
                "New Monthly Installment" := LoansManagement.PopulateMinimumContribution("Application No");
            end;
        }
        field(70; "Pay to Bank Code"; Code[20])
        {
            TableRelation = "External Banks";
        }
        field(71; "Pay to Branch Code"; Code[20])
        {
            TableRelation = "External Bank Branches"."Branch Code" where("Bank Code" = field("Pay to Bank Code"));
        }
        field(72; "Pay to Account No"; Code[50]) { }
        field(73; "Pay to Account Name"; Text[100]) { }
        field(75; "Appraisal Commited"; Boolean)
        {
            Editable = false;
        }
        field(76; Approvals; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Table ID" = const(90015), "Document No." = field("Application No")));
            trigger OnLookup()
            var
                ApprovalEntry: Record "Approval Entry";
                ApprovalEntryPage: Page "Approval Entries";
            begin
                Clear(ApprovalEntryPage);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", 90015);
                ApprovalEntry.SetRange("Document No.", "Application No");
                if ApprovalEntry.FindSet() then begin
                    ApprovalEntryPage.SetTableView(ApprovalEntry);
                    ApprovalEntryPage.RunModal();
                end;
            end;
        }
        field(77; "Net Change-Principal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("Loan Account"),
            "Transaction Type" = filter("Loan Disbursal" | "Principle Paid"),
            "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(78; "Total Arrears"; Decimal)
        {
            Editable = false;
        }
        field(79; "Principle Arrears"; Decimal)
        {
            Editable = false;
        }
        field(80; "Interest Arrears"; Decimal)
        {
            Editable = false;
        }
        field(81; "Defaulted Installments"; Integer) { Editable = false; }
        field(82; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted,Processing;
        }
        field(83; "Source Type"; Option)
        {
            OptionMembers = CoreBanking,Channels;
        }
        field(84; "Rejection Remarks"; Text[250]) { }
        field(85; "Total Collateral"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Securities".Guarantee where("Loan No" = field("Application No")));
            Editable = false;
        }
        field(86; "Self Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Guarantees"."Guaranteed Amount" where("Loan No" = field("Application No"), "Member No" = field("Member No.")));
        }
        field(87; "Monthly Principle"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = max("Loan Schedule"."Principle Repayment" where("Loan No." = field("Application No")));
            Editable = false;
        }
        field(88; Rescheduled; Boolean) { }
        field(89; "Rescheduled Installment"; Decimal) { }
        field(90; "Maximum Repayment Period"; Integer)
        {
            Editable = false;
        }
        field(91; "Last Interest Charge"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = max("Detailed Vendor Ledg. Entry"."Posting Date" WHERE("Vendor No." = field("Loan Account"), "Transaction Type" = const("Interest Due"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(92; "Total Recoveries"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recoveries".Amount where("Loan No" = field("Application No")));
            Editable = false;
        }
        field(94; "Disbursements"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = field("Loan Account"), "Transaction Type" = const("Loan Disbursal"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(95; "Qualified Salarywise"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Application No")
        {
            Clustered = true;
        }
        key(Key2; "Product Code", "Member No.", "Member Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application No", "Member No.", "Member Name", "Product Code", "Product Description") { }
    }
    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        Members: Record Members;
        ProductSetup: Record "Product Factory";
        ProductCharges: Record "Product Charges";
        LoanCharges: Record "Loan Charges";
        LoansManagement: Codeunit "Loans Management";

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Loan Application Nos.");
        if "Application No" = '' then begin
            "Application No" := NoSeries.GetNextNo(SaccoSetup."Loan Application Nos.", Today, true);
            "Application Date" := Today;
            "Posting Date" := "Application Date";
        end;
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        if CurrentClientType = CurrentClientType::SOAP then begin
            "Source Type" := "Source Type"::Channels;
            "Sales Person" := 'PORTAL';
            "Sales Person Name" := 'PORTAL';
        end;
        Validate("Posting Date");
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90016 "Loan Schedule"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Loan Schedule";
    LookupPageId = "Loan Schedule";
    fields
    {

        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Expected Date"; Date) { }
        field(4; Description; Text[50]) { }
        field(5; "Principle Repayment"; Decimal) { }
        field(6; "Interest Repayment"; Decimal) { }
        field(7; "Monthly Repayment"; Decimal) { }
        field(8; "Running Balance"; Decimal) { }
        field(9; "Loan No."; Code[20]) { }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90017 "Repayment Schedule"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Expected Date"; Date) { }
        field(4; Description; Text[50]) { }
        field(5; "Principle Repayment"; Decimal) { }
        field(6; "Interest Repayment"; Decimal) { }
        field(7; "Monthly Repayment"; Decimal) { }
        field(8; "Running Balance"; Decimal) { }
        field(9; "Loan No."; Code[20]) { }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90018 "Appraisal Parameters"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {

        }
        field(2; Description; Text[50]) { }
        field(3; Type; Option)
        {
            OptionMembers = Earnig,Deduction;
        }
        field(4; Taxable; Boolean) { }
        field(5; Class; Option)
        {
            OptionMembers = "Basic Pay","House Allowance","Other Incomes","Other Deductions";
        }
        field(6; "Cleared Effect"; Boolean) { }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90019 "Fixed Deposit Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50]) { }
        field(3; "Min. Interest Rate"; Decimal) { }
        field(4; "Max. Interest Rate"; Decimal) { }
        field(5; "Interest Calculation Type"; Option)
        {
            OptionMembers = "Flat Rate","Reducing Balance";
        }
        field(6; "Interest Provision Account"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Interest Payable Account"; code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "External Payments Account"; code[20])
        {
            TableRelation = Vendor where("Member No." = filter(= ''));
        }
        field(9; "Linking Account Type"; Code[20])
        {
            TableRelation = "Product Factory" where(Status = const(Active), "Fixed Deposit" = const(true));
        }
        field(10; "Withholding Tax Rate"; Decimal) { }
        field(11; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90020 "Fixed Deposit Register"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Fixed Deposits Lookp";
    DrillDownPageId = "Fixed Deposits Lookp";
    fields
    {
        field(1; "FD No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No."; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Member: Record Members;
            begin
                if Member.get("Member No.") then
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "FD Type"; code[20])
        {
            TableRelation = "Fixed Deposit Types";
            trigger OnValidate()
            var
                FDTypes: Record "Fixed Deposit Types";
            begin
                if FDTypes.get("FD Type") then
                    "FD Description" := FDTypes.Description;
            end;
        }
        field(5; "FD Description"; Text[50])
        {
            Editable = False;
        }
        field(6; Amount; Decimal) { }
        field(7; "Funds Source"; Option)
        {
            OptionMembers = "Member Account","External";
        }
        field(8; "Source Account"; Code[20])
        {
            TableRelation = if ("Funds Source" = const("Member Account")) Vendor where("Member No." = field("Member No."))
            else
            "Bank Account";
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if "Funds Source" = "Funds Source"::"Member Account" then begin
                    if Vendor.get("Source Account") then begin
                        Vendor.CalcFields(Balance);
                        "Source Balance" := Vendor.Balance;
                    end;
                end;
            end;
        }
        field(9; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("End Date");
            end;
        }
        field(10; Period; DateFormula)
        {
            trigger OnValidate()
            begin
                Validate("End Date");
            end;
        }
        field(11; "End Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                "End Date" := CalcDate(Period, "Start Date");
            end;
        }
        field(12; "Total Interest Payable"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Fixed Deposit Schedule".Amount where("FD No" = field("FD No.")));
        }
        field(13; "Total Interest Accrued"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Fixed Deposit Schedule".Amount where("FD No" = field("FD No."), Transferred = const(true)));
        }
        field(14; "Total Interest Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Fixed Deposit Schedule".Amount where("FD No" = field("FD No."), Transferred = const(false)));
        }
        field(15; Rate; Decimal) { }
        field(16; "Marturity Instructions"; Option)
        {
            OptionMembers = "Roll Over Principle","Roll Over Net","Liquidate";
        }
        field(17; Posted; Boolean)
        {
            Editable = false;
        }
        field(18; "Posted By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(19; "Posting Date"; Date) { }
        field(20; "Control Account"; code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(21; Terminated; Boolean)
        {
            Editable = false;
        }
        field(22; "Approval Status"; option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(23; "Source Balance"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "FD No.")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("FD Nos.");
        "FD No." := NoSeries.GetNextNo(SaccoSetup."FD Nos.", Today, true);
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90021 "Fixed Deposit Schedule"
{
    DataClassification = ToBeClassified;
    LookupPageId = "FD Schedule";
    DrillDownPageId = "FD Schedule";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "FD No"; Code[20]) { }
        field(3; "Posting Date"; Date) { }
        field(4; Description; Text[50]) { }
        field(5; Amount; Decimal) { }
        field(6; Transferred; Boolean) { }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin
        TestField(Transferred, false);
    end;

    trigger OnRename()
    begin

    end;

}
table 90023 "Standing Order"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Standing Orders Lookup";
    LookupPageId = "Standing Orders Lookup";
    fields
    {
        field(1; "Document No"; code[20]) { Editable = false; }
        field(2; "Standing Order Class"; Option)
        {
            OptionMembers = "Internal","External","Loan-Principle","Loan-Interest","Loan Principle+Interest";
        }
        field(3; "Amount Type"; Option)
        {
            OptionMembers = "Fixed","Sweep";
        }
        field(4; "Member No"; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                LoansMgt: Codeunit "Loans Management";
            begin
                if Members.Get("Member No") then
                    "Member Name" := Members."Full Name";
                "Account No" := LoansMgt.GetFOSAAccount("Member No");
                Validate("Account No");
            end;
        }
        field(5; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(6; "Account No"; code[20])
        {
            TableRelation = Vendor where("Member No." = field("Member No"));
        }
        field(7; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if "Amount Type" = "Amount Type"::Sweep then
                    Amount := 0;
            end;
        }
        field(8; "Posting Description"; Text[50]) { }
        field(9; "Destination Member No"; code[20])
        {
            TableRelation = if ("Standing Order Class" = const(Internal)) Members;
            trigger OnValidate()
            begin
                Validate("Destination Name");
            end;
        }
        field(10; "Destination Account"; code[20])
        {
            TableRelation = if ("Standing Order Class" = const(External)) Vendor where("Account Type" = const(eft))
            else
            if ("Standing Order Class" = filter("Loan Principle+Interest" | "Loan-Interest" | "Loan-Principle")) "Loan Application" where("Loan Balance" = filter(> 0), "Member No." = field("Destination Member No"))
            else
            Vendor where("Member No." = field("Destination Member No"), "Account Class" = filter(<> Loan));
            trigger OnValidate()
            begin
                Validate("Destination Name");
            end;
        }
        field(11; "Destination Name"; Text[150])
        {
            Editable = false;
            trigger OnValidate()
            begin
                if Vendor.get("Destination Account") then
                    "Destination Name" := Vendor.Name;
            end;
        }
        field(12; "Run From Day"; Integer)
        {
            trigger OnValidate()
            begin
                TestField("Salary Based", false);
                TestField("Amount Type", "Amount Type"::Fixed);
            end;
        }
        field(13; "EFT Account Name"; Text[150]) { }
        field(14; "EFT Bank Name"; Text[150]) { }
        field(15; "EFT Brannch Code"; Code[20]) { }
        field(16; "EFT Swift Code"; Code[20]) { }
        field(17; "EFT Transfer Account No"; Code[20]) { }
        field(18; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(19; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(20; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(23; "Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(24; Running; Boolean)
        {
            Editable = false;
        }
        field(25; "Salary Based"; Boolean) { }
        field(26; Terminated; Boolean)
        {
            Editable = false;
        }
        field(27; "STO Type"; Code[20])
        {
            TableRelation = "STO Types";
        }
        field(28; "Start Date"; Date)
        {
            trigger OnValidate()
            begin
                Validate("End Date");
            end;
        }
        field(29; Period; DateFormula)
        {
            trigger OnValidate()
            begin
                Validate("End Date");
            end;
        }
        field(30; "End Date"; Date)
        {
            trigger OnValidate()
            begin
                "End Date" := CalcDate(Period, "Start Date");
            end;
        }
        field(31; "Policy No."; Code[50]) { }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        GenSetup: Record "Sacco Setup";
        Members: Record Members;
        Vendor: Record Vendor;

    trigger OnInsert()
    begin
        GenSetup.Get();
        GenSetup.TestField("Standing Order Nos");
        "Document No" := NoSeries.GetNextNo(GenSetup."Standing Order Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90024 Charges
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[50]) { }
        field(3; "Post to Account Type"; Option)
        {
            OptionMembers = "G/L Account","Liability Account";
        }
        field(4; "Post-to Account No."; Code[20])
        {
            TableRelation = if ("Post to Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true))
            else
            Vendor where("Account Type" = filter(<> sacco));
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90025 "Product Charges"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Charge Code"; Code[20])
        {
            TableRelation = Charges;
            trigger OnValidate()
            begin
                if Charges.get("Charge Code") then begin
                    "Charge Description" := Charges.Description;
                    "Post to Account Type" := Charges."Post to Account Type";
                    "Post-to Account No." := Charges."Post-to Account No.";
                end;
            end;
        }
        field(3; "Charge Description"; Text[59])
        {
            Editable = false;
        }
        field(4; Rate; Decimal) { }
        field(5; "Rate Type"; Option)
        {
            OptionMembers = "Flat Rate","Percentage of Principle";
        }
        field(6; "Post to Account Type"; Option)
        {
            OptionMembers = "G/L Account","Liability Account";
            Editable = false;
        }
        field(7; "Post-to Account No."; Code[20])
        {
            Editable = false;
            TableRelation = if ("Post to Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true))
            else
            Vendor where("Account Type" = filter(<> sacco));
        }
    }

    keys
    {
        key(PK; "Product Code", "Charge Code")
        {
            Clustered = true;
        }
    }

    var
        Charges: Record Charges;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90026 "Loan Charges"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "loan Charges";
    LookupPageId = "loan Charges";
    fields
    {
        field(1; "Loan No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Charge Code"; Code[20])
        {
            TableRelation = Charges;
            trigger OnValidate()
            begin
                if Charges.get("Charge Code") then begin
                    "Charge Description" := Charges.Description;
                    "Post to Account Type" := Charges."Post to Account Type";
                    "Post-to Account No." := Charges."Post-to Account No.";
                end;
            end;
        }
        field(3; "Charge Description"; Text[59])
        {
            Editable = false;
        }
        field(4; Rate; Decimal) { }
        field(5; "Rate Type"; Option)
        {
            OptionMembers = "Flat Rate","Percentage of Principle";
        }
        field(6; "Post to Account Type"; Option)
        {
            OptionMembers = "G/L Account","Liability Account";
            Editable = false;
        }
        field(7; "Post-to Account No."; Code[20])
        {
            Editable = false;
            TableRelation = if ("Post to Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true))
            else
            Vendor where("Account Type" = filter(<> sacco));
        }
    }

    keys
    {
        key(PK; "Loan No.", "Charge Code")
        {
            Clustered = true;
        }
    }

    var
        Charges: Record Charges;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90027 "Collateral Types"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Collateral Types";
    DrillDownPageId = "Collateral Types";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50]) { }
        Field(3; "Value Multiplier"; Decimal) { }
        field(4; Active; Boolean)
        {
            trigger OnValidate()
            begin
                TestField("Value Multiplier");
            end;
        }
        field(5; "Security Type"; Option)
        {
            OptionMembers = Collateral,Guarantor;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90028 "Collateral Application"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Collateral Applications";
    DrillDownPageId = "Collateral Applications";

    fields
    {
        field(1; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger onValidate()
            var
                Members: Record Members;
            begin
                if members.get("Member No") then begin
                    "Member Name" := members."Full Name";
                    "National ID No" := Members."National ID No";
                    "KRA PIN No." := Members."KRA PIN";
                end;
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Collateral Type"; Code[20])
        {
            TableRelation = "Collateral Types";
            trigger OnValidate()
            var
                CollateralType: Record "Collateral Types";
            begin
                if CollateralType.get("Collateral Type") then begin
                    "Security Type" := CollateralType."Security Type";
                    Multiplier := CollateralType."Value Multiplier";
                    "Collateral Description" := CollateralType.Description;
                end;
            end;
        }
        field(5; "Collateral Description"; Text[150])
        {
            Editable = false;
        }
        field(6; Multiplier; Decimal)
        {
            Editable = false;
        }
        field(7; "Collateral Value"; Decimal)
        {
            trigger OnValidate()
            begin
                Guarantee := "Collateral Value" * Multiplier * 0.01;
            end;
        }
        field(8; Guarantee; Decimal)
        {
            Editable = false;
        }
        field(9; "Last Valuation Date"; Date) { }
        field(10; "Joint Ownership"; boolean) { }
        field(11; "National ID No"; Code[20]) { Editable = false; }
        field(12; "KRA PIN No."; code[20]) { Editable = false; }
        field(13; "Approval Status"; Option)
        {
            OptionMembers = "New","Approaval Pending","Approved";
            Editable = false;
        }
        field(14; Posted; Boolean) { }
        field(15; "Collateral Image"; Blob)
        {
            Subtype = Bitmap;
        }
        field(16; "Serial No"; code[20])
        {
            trigger OnValidate()
            var
                CollateralRegister: Record "Collateral Register";
            begin
                if not "Multi-Linking" then begin
                    CollateralRegister.Reset();
                    CollateralRegister.SetRange("Serial No", "Serial No");
                    if CollateralRegister.FindSet() then begin
                        if CollateralRegister.Status <> CollateralRegister.Status::"Linked to Loan" then
                            Error('Collatral Is already Received in the system under Document No %1 for Member %2', CollateralRegister."Document No", CollateralRegister."Member Name");
                    end;
                end;
            end;
        }

        field(17; "Registration No"; code[20])
        {
            trigger OnValidate()
            var
                CollateralRegister: Record "Collateral Register";
            begin
                if not "Multi-Linking" then begin
                    CollateralRegister.Reset();
                    CollateralRegister.SetRange("Serial No", "Serial No");
                    if CollateralRegister.FindSet() then begin
                        if CollateralRegister.Status <> CollateralRegister.Status::"Linked to Loan" then
                            Error('Collatral Is already Received in the system under Document No %1 for Member %2', CollateralRegister."Document No", CollateralRegister."Member Name");
                    end;
                end;
            end;
        }
        field(18; "Posting Date"; Date) { }
        field(19; "Security Type"; Option)
        {
            Editable = false;
            OptionMembers = Collateral,Guarantor;
        }
        field(20; "Owner Name"; Code[150]) { }
        field(21; "Owner Phone No."; Code[20]) { }
        field(22; "Owner ID No"; Code[20]) { }
        field(23; "Multi-Linking"; Boolean) { }
        field(24; "Collateral Image 1"; Blob)
        {
            Subtype = Bitmap;
        }
        field(25; "Collateral Image 2"; Blob)
        {
            Subtype = Bitmap;
        }
        field(26; "Collateral Image 3"; Blob)
        {
            Subtype = Bitmap;
        }
        field(27; "Collateral Image 4"; Blob)
        {
            Subtype = Bitmap;
        }
        field(28; "Cheque No."; Code[30]) { }
        field(29; "Insurance Expiry Date"; Date) { }
        field(30; "Linking Date"; Date) { }
        field(36; "Car Track Due Date"; Date) { }
    }

    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Collateral Application Nos.");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Collateral Application Nos.", Today, true);
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90029 "Collateral Register"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Collateral Register";
    LookupPageId = "Collateral Register";
    fields
    {
        field(1; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; code[20]) { }
        field(3; "Member Name"; Text[150]) { }
        field(4; "Collateral Type"; code[20]) { }
        field(5; "Collateral Description"; text[150]) { }
        field(6; "Caollateral Value"; Decimal) { }
        field(7; Guarantee; Decimal) { }
        field(8; Status; Option)
        {
            OptionMembers = Available,"Awaiting Loan Disbursal","Linked to Loan","Collected";
        }
        field(9; "Loan No."; code[20]) { }
        field(10; "Serial No"; code[20])
        {
            trigger OnValidate()
            var
                CollateralRegister: Record "Collateral Register";
            begin
            end;
        }
        field(11; "Registration No"; code[20])
        {
            trigger OnValidate()
            var
                CollateralRegister: Record "Collateral Register";
            begin
            end;
        }
        field(12; "Posting Date"; Date) { }
        field(13; "Security Type"; Option)
        {
            Editable = false;
            OptionMembers = Collateral,Guarantor;
        }
        field(14; "Owner Name"; Code[150]) { }
        field(15; "Owner Phone No."; Code[20]) { }
        field(16; "Owner ID No"; Code[20]) { }
        field(17; "Insurance Expiry Date"; Date) { }
        field(18; "Linking Date"; Date) { }
        field(19; "Car Track Due Date"; Date) { }
    }

    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
        key(CollateralInfo; "Member No", "Member Name", "Collateral Type", "Collateral Description")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Member No", "Member Name", "Collateral Type", "Collateral Description") { }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90030 "Loan Securities"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Loan Securities";
    LookupPageId = "Loan Securities";

    fields
    {
        field(1; "Loan No"; code[20])
        {
            DataClassification = ToBeClassified;
            trigger onvalidate()
            begin
                if LoanApplication.get("Loan No") then
                    "Member No." := LoanApplication."Member No.";
            end;
        }
        field(2; "Security Type"; option)
        {
            OptionMembers = Guarantor,Collateral;
            trigger onvalidate()
            begin
                if LoanApplication.get("Loan No") then
                    "Member No." := LoanApplication."Member No.";
            end;
        }
        field(3; "Security Code"; code[20])
        {
            trigger OnValidate()
            begin
                if CollateralRegister.get("Security Code") then begin
                    Description := CollateralRegister."Collateral Description";
                    "Security Value" := CollateralRegister.Guarantee;
                    Guarantee := CollateralRegister.Guarantee;
                    "Outstanding Value" := "Security Value";
                end;
            end;

            trigger OnLookup()
            begin
                if LoanApplication.Get("Loan No") then begin
                    CollateralRegister.Reset();
                    CollateralRegister.SetRange("Member No", LoanApplication."Member No.");
                    IF PAGE.RUNMODAL(0, CollateralRegister) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Security Code", CollateralRegister."Document No");
                    end;
                end;
            end;
        }
        field(4; Description; Text[150])
        {
            Editable = false;
        }
        field(5; "Security Value"; decimal)
        {
            Editable = false;
        }
        field(6; Guarantee; decimal)
        {
            trigger onvalidate()
            begin
                if Guarantee > "Security Value" then
                    Error('The security can only guarantee upto %1', "Security Value");
            end;
        }
        field(7; "Member No."; code[20])
        {
            Editable = false;
        }
        field(8; "Outstanding Value"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Loan No", "Security Type", "Security Code")
        {
            Clustered = true;
        }
    }

    var
        CollateralRegister: Record "Collateral Register";
        LoanApplication: Record "Loan Application";

    trigger OnInsert()
    begin
        if LoanApplication.get("Loan No") then
            "Member No." := LoanApplication."Member No.";
    end;

    trigger OnModify()
    begin
        if LoanApplication.get("Loan No") then
            "Member No." := LoanApplication."Member No.";
    end;

    trigger OnDelete()
    begin
        if CollateralRegister.get("Security Code") then begin
            CollateralRegister.Status := CollateralRegister.Status::Available;
            CollateralRegister."Loan No." := '';
            CollateralRegister.Modify();
        end;
    end;

    trigger OnRename()
    begin
        if CollateralRegister.get("Security Code") then begin
            CollateralRegister.Status := CollateralRegister.Status::Available;
            CollateralRegister."Loan No." := '';
            CollateralRegister.Modify();
        end;

    end;

}
table 90031 "Loan Interest Accrual"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Interest Accruals";
    LookupPageId = "Interest Accruals";
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Loan No."; code[20]) { }
        field(3; "Entry Date"; Date) { }
        field(4; "Entry Type"; Option)
        {
            OptionMembers = "Interest Accrual","Penalty Accrual";
        }
        field(5; Description; Text[50]) { }
        field(6; "Member No."; Code[20]) { }
        field(7; "Member Name"; Text[150]) { }
        field(8; "Created By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(9; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(10; Open; Boolean) { }
        field(11; Amount; Decimal) { }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90032 "Product Interest Bands"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Loan Interest Bands";
    DrillDownPageId = "Loan Interest Bands";
    fields
    {
        field(1; "Product Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Min Installments"; Integer) { }
        field(4; "Max Installments"; Integer) { }
        field(5; "Interest Rate"; Decimal)
        {
            DecimalPlaces = 5;
        }
        field(6; Active; Boolean)
        {
            trigger OnValidate()
            begin
                TestField("Interest Rate");
                if "Max Installments" < "Min Installments" then
                    Error('Maximum Installments Cannot be greater than Minimum Installments');
            end;
        }
    }

    keys
    {
        key(PK; "Product Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90033 "Member Application Referees"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Full Names"; Text[150]) { }
        field(4; "Phone No."; code[20]) { }
        field(5; "Relationship"; code[20]) { }
    }

    keys
    {
        key(PK; "Application No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90034 "Collateral Release"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Collateral Releases";
    fields
    {
        field(1; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No"; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                if Member.get("Member No") then
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; Collateral; code[20])
        {
            TableRelation = "Collateral Register" where("Member No" = field("Member No"));
            trigger OnValidate()
            var
                CollRegister: Record "Collateral Register";
            begin
                if CollateralRegister.get(Collateral) then begin
                    "Collateral Description" := CollateralRegister."Collateral Description";
                    CollRegister.Reset();
                    CollRegister.SetRange("Registration No", CollateralRegister."Registration No");
                    CollRegister.SetRange("Serial No", CollateralRegister."Serial No");
                    CollRegister.SetFilter("Loan No.", '<>%1', '');
                    if CollRegister.FindSet() then begin
                        LinkedLoans.Reset();
                        LinkedLoans.SetRange("Document No", "Document No");
                        if LinkedLoans.FindSet() then
                            LinkedLoans.DeleteAll();
                        repeat
                            if LoanApplication.get(CollRegister."Loan No.") then begin
                                LoanApplication.CalcFields("Loan Balance");
                                LinkedLoans.Init();
                                LinkedLoans."Document No" := "Document No";
                                LinkedLoans."Loan No." := LoanApplication."Application No";
                                LinkedLoans."Product Code" := LoanApplication."Product Code";
                                LinkedLoans."Product Details" := LoanApplication."Product Description";
                                LinkedLoans."Current Balance" := LoanApplication."Loan Balance";
                                LinkedLoans."Member No" := LoanApplication."Member No.";
                                LinkedLoans."Member Name" := LoanApplication."Member Name";
                                LinkedLoans.Insert();
                            end;
                        until CollRegister.Next() = 0;
                    end;
                    if LoanApplication.Get(CollateralRegister."Loan No.") then begin
                        LoanApplication.CalcFields("Loan Balance");
                        "Linked Loan Balance" := LoanApplication."Loan Balance";
                        "Linked to Loan No" := LoanApplication."Application No";
                    end;
                end;
            end;
        }
        field(5; "Collateral Description"; Text[150])
        {
            Editable = false;
        }
        field(6; "Linked to Loan No"; Code[20])
        {
            Editable = false;
        }
        field(7; "Linked Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(8; "Created By"; code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(9; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(10; Posted; Boolean)
        {
            Editable = false;
        }
        field(11; Remarks; Text[250]) { }
        field(12; Comments; Text[250]) { }
        field(13; "Collected By"; Text[150]) { }
        field(14; "Collected By ID No"; code[50]) { }
        field(15; "Phone No"; code[50]) { }
        field(16; "Collection Date"; Date) { }
        field(17; "Approval Status"; Option)
        {
            OptionMembers = "New","Approaval Pending","Approved";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
    }

    var
        Noseries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        CollateralRegister: Record "Collateral Register";
        LoanApplication: Record "Loan Application";
        LinkedLoans: Record "Collateral Discharge Details";
        Member: Record Members;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        "Document No" := Noseries.GetNextNo(SaccoSetup."Collateral Application Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90035 "Notice Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;
        }
        field(2; "Notice Date"; Date) { }
        field(3; Processed; Boolean)
        {
            Editable = false;
        }
        field(4; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(5; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(6; "First Notice Sent On"; DateTime)
        {
            Editable = false;
        }
        field(7; "Second Notice Sent On"; DateTime)
        {
            Editable = false;
        }
        field(8; "Third Notice Sent On"; DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Defaulter Notice Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Defaulter Notice Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Notice Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90036 "Notice Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;
        }
        field(2; "Loan No"; Code[20])
        {
            Editable = false;
        }
        field(3; "Member No"; Code[20])
        {
            Editable = false;
        }
        field(4; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Product Code"; Code[20])
        {
            Editable = false;
        }
        field(6; "Product Description"; Text[100])
        {
            Editable = false;
        }
        field(7; "Total Arrears"; Decimal)
        {
            Editable = false;
        }
        field(8; "Defaulted Days"; Integer)
        {
            Editable = false;
        }
        field(9; "Defaulted Installments"; Integer)
        {
            Editable = false;
        }
        field(10; "Notice Type"; Option)
        {
            OptionMembers = "1st","2nd","3rd";
        }
        field(11; Notified; Boolean)
        {
            Editable = false;
        }
        field(12; "E-Mail"; Text[100])
        {
            Editable = false;
        }
        field(13; "Self Guarantee"; Boolean)
        {
            Editable = false;
        }
        field(14; "Skip Reason"; Text[100])
        {
            trigger OnValidate()
            begin
                if "Skip Reason" <> '' then
                    Skip := true
                else
                    Skip := false;
            end;
        }
        field(15; Skip; Boolean)
        {
            Editable = false;
        }
        field(16; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No", "Loan No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90037 "Member Editing"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Member Editings";
    LookupPageId = "Member Editings";
    fields
    {
        field(1; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
            trigger OnValidate()
            var
                MemberKins, MemberKins1 : Record "Nexts of Kin";
            begin
                Member.Get("Member No.");
                Member.CalcFields("Member Image", "Front ID Image", "Back ID Image");
                "First Name" := Member."First Name";
                "Middle Name" := Member."Middle Name";
                "Last Name" := Member."Last Name";
                "Mobile Phone No." := Member."Mobile Phone No.";
                "Alt. Phone No" := Member."Alt. Phone No";
                Gender := Member.Gender;
                "National ID No" := Member."National ID No";
                "Date of Birth" := Member."Date of Birth";
                "Payroll No." := Member."Payroll No.";
                Address := Member.Address;
                City := Member.City;
                County := Member.County;
                "Sub County" := Member."Sub County";
                "Marital Status" := Member."Marital Status";
                Occupation := Member.Occupation;
                "Type of Residence" := Member."Type of Residence";
                "Member Image" := Member."Member Image";
                "Front ID Image" := Member."Front ID Image";
                "Back ID Image" := Member."Back ID Image";
                "Marital Status" := Member."Marital Status";
                "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Member."Global Dimension 2 Code";
                "Spouse ID No" := Member."Spouse ID No";
                "Spouse Name" := Member."Spouse Name";
                "Spouse Phone No" := Member."Spouse Phone No";
                "Town of Residence" := Member."Town of Residence";
                "Estate of Residence" := Member."Estate of Residence";
                "Station Code" := Member."Station Code";
                Designation := Member.Designation;
                "Employer Code" := Member."Employer Code";
                "E-Mail Address" := Member."E-Mail Address";
                Designation := Member.Designation;
                "Station Code" := Member."Station Code";
                "KRA PIN" := Member."KRA PIN";
                "Group Name" := Member."Group Name";
                "Group No" := Member."Group No";
                "Date of Registration" := Member."Date of Registration";
                "Certificate of Incoop" := Member."Certificate of Incoop";
                "Is Group" := Member."Is Group";
                "Member Signature" := Member."Member Signature";
                "Protected Account" := Member."Protected Account";
                "Account Owner" := Member."Account Owner";
                "Mobile Transacting No" := Member."Mobile Transacting No";
                Validate("Full Name");
            end;
        }
        field(3; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(4; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(5; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Validate("Full Name");
            end;
        }
        field(6; "Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            end;
        }
        field(7; "Mobile Phone No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Alt. Phone No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Male","Female","Other";
        }
        field(10; "National ID No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Payroll No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(13; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "New","Pending Approval","Approved";
            Editable = false;
        }
        field(16; Address; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; County; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Counties;
        }
        field(19; "Sub County"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Counties" where("County Code" = field(County));
        }
        field(20; "E-Mail Address"; Text[250])
        {
            ExtendedDatatype = EMail;
        }
        field(21; "Employer Code"; code[20])
        {
            TableRelation = "Employer Codes";
        }

        field(22; "Member Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(23; "Front ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(24; "Back ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(25; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Widowed,Divorced,Withheld;
        }
        field(26; "KRA PIN"; Code[20])
        {

        }
        field(27; Occupation; Text[100]) { }
        field(28; "Type of Residence"; Option) { OptionMembers = Rented,Owned; }
        field(29; Processed; Boolean)
        {
            Editable = false;
        }
        field(30; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(32; "Spouse Name"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(33; "Spouse ID No"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(34; "Spouse Phone No"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(35; "Town of Residence"; code[50]) { }
        field(36; "Estate of Residence"; code[50]) { }
        field(37; "Station Code"; code[20])
        {
            TableRelation = "Employer Stations"."Station Code" where("Employer Code" = field("Employer Code"));
        }
        field(38; Nationality; Option)
        {
            OptionMembers = Kenyan,Diaspora;
        }

        field(39; Designation; Code[50]) { }
        field(40; "Certificate Expiry"; Date) { }
        field(41; "Group No"; Code[20]) { }
        field(42; "Group Name"; Text[100]) { }
        field(43; "Certificate of Incoop"; Code[30]) { }
        field(44; "Date of Registration"; Date) { }
        field(45; "Is Group"; Boolean) { }

        field(46; "Update KINS"; Boolean)
        {
            trigger OnValidate()
            var
                MemberKins, MemberKins1 : record "Nexts of Kin";
            begin
                MemberKins.Reset();
                MemberKins.SetRange("Source Code", "Member No.");
                if MemberKins.FindSet() then begin
                    repeat
                        MemberKins1.Init();
                        MemberKins1.TransferFields(MemberKins, false);
                        MemberKins1."Source Code" := "Document No.";
                        MemberKins1."Kin Type" := MemberKins."Kin Type";
                        MemberKins1."KIN ID" := MemberKins."KIN ID";
                        MemberKins1.Insert();
                    until MemberKins.Next() = 0;
                end;
            end;
        }

        field(47; Approvals; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Document No." = field("Document No."), "Table ID" = const(90037)));
        }
        field(48; "Member Signature"; blob)
        {
            Subtype = Bitmap;
        }
        field(49; "Marketing Texts"; Boolean) { }
        field(50; "Protected Account"; Boolean) { }
        field(51; "Account Owner"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(52; "Mobile Transacting No"; Code[20]) { }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        Member: Record Members;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Member Editing Nos");
        "Document No." := NoSeries.GetNextNo(SaccoSetup."Member Editing Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90038 "Member Versions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
            end;
        }
        field(3; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "First Name" := UpperCase("First Name");
                Validate("Full Name");
            end;
        }
        field(4; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Middle Name" := UpperCase("Middle Name");
                Validate("Full Name");
            end;
        }
        field(5; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Last Name" := UpperCase("Last Name");
                Validate("Full Name");
            end;
        }
        field(6; "Full Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
                "Full Name" := UpperCase("Full Name");
            end;
        }
        field(7; "Mobile Phone No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Alt. Phone No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Male","Female","Other";
        }
        field(10; "National ID No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Payroll No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(13; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "New","Pending Approval","Approved";
            Editable = false;
        }
        field(16; Address; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; City; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; County; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Counties;
        }
        field(19; "Sub County"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Counties" where("County Code" = field(County));
        }
        field(20; "E-Mail Address"; Text[250])
        {
            ExtendedDatatype = EMail;
        }
        field(21; "Employer Code"; code[20])
        {
            TableRelation = "Employer Codes";
        }

        field(22; "Member Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(23; "Front ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(24; "Back ID Image"; blob)
        {
            Subtype = Bitmap;
        }
        field(25; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Widowed,Divorced,Withheld;
        }
        field(26; "KRA PIN"; Code[20])
        {

        }
        field(27; Occupation; Text[100]) { }
        field(28; "Type of Residence"; Option) { OptionMembers = Rented,Owned; }
        field(30; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value" WHERE("Global Dimension No." = CONST(1));
        }
        field(31; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value" WHERE("Global Dimension No." = CONST(2));
        }
        field(32; "Spouse Name"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(33; "Spouse ID No"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(34; "Spouse Phone No"; Code[150])
        {
            trigger OnValidate()
            begin
                TestField("Marital Status", "Marital Status"::Married);
            end;
        }
        field(35; "Town of Residence"; code[50]) { }
        field(36; "Estate of Residence"; code[50]) { }
        field(37; "Empployer Code"; Code[20]) { }
        field(38; "Payroll No"; code[20]) { }
        field(39; "Station Code"; Code[20]) { }
        field(40; "Designation"; Code[20]) { }
        field(41; Nationality; Option)
        {
            OptionMembers = Kenyan,Diaspora;
        }
        field(42; "Mobile Transacting No"; Code[20]) { }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        Member: Record Members;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90039 Counties
{
    DataClassification = ToBeClassified;
    DrillDownPageId = Counties;
    LookupPageId = Counties;
    fields
    {
        field(1; "County Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Name; Text[50]) { }
        field(3; "Sub Counties"; Integer)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Sub Counties" WHERE("County Code" = field("County Code")));
        }
    }

    keys
    {
        key(PK; "County Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90040 "Sub Counties"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Sub Counties";
    LookupPageId = "Sub Counties";
    fields
    {
        field(1; "County Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        Field(2; "Sub County Code"; Code[20]) { }
        field(3; "Sub County Name"; Text[50]) { }
    }

    keys
    {
        key(PK; "County Code", "Sub County Code")
        {
            Clustered = true;
        }

    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sub County Code", "Sub County Name") { }
    }
    var

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}


table 90041 "Payments Header"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Payment Vouchers";
    LookupPageId = "Payment Vouchers";
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Posting Date"; date) { }
        field(3; "Paying Account Type"; Option)
        {
            OptionMembers = "Bank Account","G/L Account";
        }
        field(4; "Paying Account No."; Code[20])
        {
            TableRelation = if ("Paying Account type" = const("Bank Account")) "Bank Account"
            else
            "G/L Account" where("Direct Posting" = const(true));
            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
                GLAccount: Record "G/L Account";
            begin
                if "Paying Account Type" = "Paying Account Type"::"Bank Account" then begin
                    if BankAccount.get("Paying Account No.") then
                        "Paying Account Name" := BankAccount.Name;
                end else begin
                    if GLAccount.get("Paying Account No.") then
                        "Paying Account Name" := GLAccount.Name;
                end;
            end;
        }
        field(5; "Paying Account Name"; Text[100])
        {
            Editable = false;
        }
        field(6; "Posting Description"; Text[50]) { }
        field(7; "Cheque No"; code[30]) { }
        field(8; "Payee Account Type"; Option)
        {
            OptionMembers = "Supplier",Customer,Service;
        }
        field(9; "Payee Account No"; Code[20])
        {
            TableRelation = if ("Payee Account Type" = const(Service)) "G/L Account" where("Direct Posting" = const(True))
            else
            if ("Payee Account Type" = const(Supplier)) Vendor where("Account Type" = const("Supplier"))
            else
            if ("Payee Account Type" = const(Customer)) Customer;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
                GLAccount: Record "G/L Account";
                Customer: Record Customer;
            begin
                if "Payee Account Type" = "Payee Account Type"::Customer then begin
                    if Customer.get("Payee Account No") then
                        "Payee Account Name" := Customer.Name;
                end;
                if "Payee Account Type" = "Payee Account Type"::Service then begin
                    if GLAccount.get("Payee Account No") then
                        "Payee Account Name" := GLAccount.Name;
                end;
                if "Payee Account Type" = "Payee Account Type"::Supplier then begin
                    if Vendor.get("Payee Account No") then
                        "Payee Account Name" := Vendor.Name;
                end
            end;
        }
        field(10; "Payee Account Name"; Text[150])
        {
            Editable = false;
        }
        Field(11; "payment Amount"; Decimal) { }
        field(12; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(13; Posted; Boolean)
        {
            Editable = false;
        }
        field(14; "Created By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(15; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(16; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(17; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }


    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Payment Nos");
        "Document No." := NoSeries.GetNextNo(SaccoSetup."Payment Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90042 "Loan Calculator"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; code[20])
        {
            Editable = false;
        }
        field(2; "Loan Product"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Loan Account"));
            trigger OnValidate()
            var
                Products: Record "Product Factory";
            begin
                If Products.Get("Loan Product") then begin
                    "Product Description" := Products.Name;
                    "Rate Type" := Products."Interest Repayment Method";
                end;
            end;
        }
        field(3; "Product Description"; Text[50])
        {
            Editable = false;
        }
        field(4; "Principal Amount"; Decimal) { }
        field(5; "Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(6; "Rate Type"; Option)
        {
            OptionMembers = "Straight Line","Reducing Balance",Amortised;
        }
        field(7; "Repayment Start Date"; Date) { }
        field(8; "Installments (Months)"; Integer)
        {
            trigger OnValidate()
            var
                Tparty: Codeunit ThirdPartyIntegrations;
            begin
                "Interest Rate" := Tparty.GetInterestRate("Loan Product");
                "Repayment Start Date" := Today;
            end;
        }
        field(9; "Created By"; code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(10; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(11; "Basic Pay"; Decimal)
        {
            trigger OnValidate()
            begin
                "OneThird Basic" := "Basic Pay" * (1 / 3);
                Validate("Adjusted Net Income");
            end;
        }
        field(12; "Other Allowances"; Decimal)
        {
            trigger OnValidate()
            Begin
                validate("Adjusted Net Income");
            End;
        }
        field(13; "Overtime Allowances"; Decimal)
        {
            trigger OnValidate()
            Begin
                validate("Adjusted Net Income");
            End;
        }
        field(14; "Sacco Dividend"; Decimal)
        {
            trigger OnValidate()
            Begin
                validate("Adjusted Net Income");
            End;
        }
        field(15; "Cleared Effects"; Decimal)
        {
            trigger OnValidate()
            Begin
                validate("Adjusted Net Income");
            End;
        }
        field(16; "Total Deductions"; Decimal)
        {
            trigger OnValidate()
            Begin
                validate("Adjusted Net Income");
            End;
        }
        field(17; "Adjusted Net Income"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                NetIncome: Decimal;
            begin
                NetIncome := "Basic Pay" + "Other Allowances" + "Overtime Allowances" + "Sacco Dividend" + "Cleared Effects" - "Total Deductions" - "OneThird Basic";
                "Adjusted Net Income" := ("Basic Pay" + "Other Allowances" - "Total Deductions") + "Cleared Effects" + (("Overtime Allowances") * 30 / 100);
            end;
        }
        field(18; "OneThird Basic"; Decimal)
        {
            Editable = false;
        }
        field(19; "Amount Available"; Decimal)
        {
            Editable = false;
        }
        field(20; "Current Deposits"; Decimal)
        {
            Editable = false;
        }
        field(21; "Current DepositsX4"; Decimal)
        {
            Editable = false;
        }
        field(22; "Ouststanding Loans"; Decimal)
        {
            Editable = false;
        }
        field(23; "Deposit Appraisal"; Decimal)
        {
            Editable = false;
        }
        field(24; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Member: Record Members;
            begin
                Member.Get("Member No");
                Member.CalcFields("Total Deposits", "Outstanding Loans");
                "Current Deposits" := Member."Total Deposits";
                "Current DepositsX4" := "Current Deposits" * 4;
                "Ouststanding Loans" := Member."Outstanding Loans";
                "Deposit Appraisal" := "Current DepositsX4" - "Ouststanding Loans";
            end;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        GenSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        GenSetup.Get();
        GenSetup.TestField("Calculator Nos");
        "Document No" := NoSeries.GetNextNo(GenSetup."Calculator Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90043 "Loan Calculator Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Calculator No"; Code[20]) { }
        field(3; "Installment No"; Code[20]) { }
        field(4; "Expected Date"; Date) { }
        field(5; "Principal Amount"; Decimal) { }
        field(6; "Interest Amount"; Decimal) { }
        field(7; "Installment Amount"; Decimal) { }
        field(8; "Running Balance"; Decimal) { }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90044 "Collateral Discharge Details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Loan No."; Code[20]) { }
        field(3; "Product Code"; Code[20]) { }
        field(4; "Product Details"; text[150]) { }
        Field(5; "Current Balance"; Decimal) { }
        Field(6; "Member No"; Code[20]) { }
        field(7; "Member Name"; Text[150]) { }
    }

    keys
    {
        key(PK; "Document No", "Loan No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90045 "JV Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Posting Description"; Text[50]) { }
        field(3; "External Document No."; Code[30]) { }
        field(4; "Posting Date"; Date) { }
        field(5; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(7; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(8; Posted; Boolean) { }
        Field(9; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(10; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(11; "Total Credit"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("JV Lines"."Credit Amount" where("Document No." = field("Document No.")));
        }
        field(12; "Total Debit"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("JV Lines"."Debit Amount" where("Document No." = field("Document No.")));
        }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("JV Nos");
        "Document No." := NoSeries.GetNextNo(SaccoSetup."JV Nos", Today, true);
        "Posting Date" := Today;
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90046 "JV Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Account Type"; Option)
        {
            OptionMembers = "G/L Account","Bank Account","Customer Account","Vendor Account","Fixed Asset","Member Account","Loan Account";
        }
        field(4; "Member No."; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                if JVHeader.Get("Document No.") then begin
                    "Global Dimension 1 Code" := JVHeader."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := JVHeader."Global Dimension 2 Code";
                    "Posting Description" := JVHeader."Posting Description";
                end;
            end;
        }
        field(5; "Account No."; code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true))
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Customer Account")) Customer
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("Member Account")) "Product Factory" where("Product Type" = filter(<> "Loan Account"))
            else
            if ("Account Type" = const("Loan Account")) "Loan Application" where("Member No." = field("Member No."));
            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
                BankAccount: Record "Bank Account";
                GLAccount: Record "G/L Account";
                FixedAsset: Record "Fixed Asset";
                Vendor: Record Vendor;
                LoanApplication: Record "Loan Application";
                Customer: Record Customer;
            begin
                case "Account Type" of
                    "Account Type"::"G/L Account":
                        begin
                            if GLAccount.get("Account No.") then begin
                                "Account Name" := GLAccount.Name;
                                "Post to Account" := GLAccount."No.";
                            end;
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            if BankAccount.get("Account No.") then begin
                                "Account Name" := BankAccount.Name;
                                "Post to Account" := BankAccount."No.";
                            end;
                        end;
                    "Account Type"::"Customer Account":
                        begin
                            if Customer.get("Account No.") then begin
                                "Account Name" := Customer.Name;
                                "Post to Account" := Customer."No.";
                            end;
                        end;
                    "Account Type"::"Vendor Account":
                        begin
                            if Vendor.get("Account No.") then begin
                                "Account Name" := Vendor.Name;
                                "Post to Account" := Vendor."No.";
                            end;
                        end;
                    "Account Type"::"Fixed Asset":
                        begin
                            if FixedAsset.get("Account No.") then begin
                                "Account Name" := FixedAsset.Description;
                                "Post to Account" := FixedAsset."No.";
                            end;
                        end;
                    "Account Type"::"Loan Account":
                        begin
                            if LoanApplication.get("Account No.") then begin
                                "Account Name" := LoanApplication."Product Description";
                                "Post to Account" := LoanApplication."Loan Account";
                            end;
                        end;
                    "Account Type"::"Member Account":
                        begin
                            if ProductFactory.Get("Account No.") then begin
                                if Vendor.get(ProductFactory.Prefix + "Member No.") then begin
                                    "Account Name" := ProductFactory.Name;
                                    "Post to Account" := Vendor."No.";
                                end else
                                    Error('The Member does not have a %1 Account', ProductFactory.Name);
                            end;
                        end;
                end;
                if JVHeader.Get("Document No.") then begin
                    "Global Dimension 1 Code" := JVHeader."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := JVHeader."Global Dimension 2 Code";
                    "Posting Description" := JVHeader."Posting Description";
                end;
            end;
        }
        field(6; "Account Name"; Text[50]) { Editable = false; }
        Field(7; "Posting Description"; Text[50]) { }
        field(8; "Debit Amount"; Decimal) { }
        field(9; "Credit Amount"; Decimal) { }
        field(10; Amount; Decimal) { }
        field(11; "Transaction Type"; Option)
        {

            OptionMembers = "General","Cash Deposit","Cash Withdrawal","Loan Disbursal","Principle Repayment","Interest Due"
            ,"Interest Paid","Penalty Due","Penalty Paid","Recovery","Fixed Deposit","Loan Charge";
        }
        field(12; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Post to Account"; code[20])
        {
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Document No.", "Line No")
        {
            Clustered = true;
        }
    }

    var
        JVHeader: Record "JV Header";

    trigger OnInsert()
    begin
        if JVHeader.Get("Document No.") then begin
            "Global Dimension 1 Code" := JVHeader."Global Dimension 1 Code";
            "Global Dimension 2 Code" := JVHeader."Global Dimension 2 Code";
            "Posting Description" := JVHeader."Posting Description";
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90047 "MPESA Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Receipt No."; Code[20]) { }
        field(2; "Completion Time"; DateTime) { }
        field(3; "Detaills "; Text[250]) { }
        field(4; "Status"; Option) { OptionMembers = ,Completed,Incomplete; }
        field(5; "Withdrawn"; Decimal) { }
        field(6; "Paid In"; Decimal) { }
        field(7; "Balance"; Decimal) { }
        field(8; "Balance Confirmed"; Option) { OptionMembers = ,Yes,No; }
        field(9; "Deposit Type"; Text[100]) { }
        field(10; "Other Party Info "; Text[200]) { }
        field(11; "A/C No."; Text[200]) { }
        field(12; "Processed "; Boolean) { }
        field(13; "Initiation Time"; DateTime) { }
        field(14; "Paybil Number"; Code[50]) { }
        field(15; "Phone "; Code[50]) { }
        field(16; "Name"; Text[100]) { }
        field(17; "Transaction Date"; Date) { }
        field(18; "Posting Date/Time"; DateTime) { }
        field(19; "Time"; Time) { }
        field(20; "Comments"; Text[250]) { }
        field(21; "Keyword"; Code[30]) { }
        field(22; "ID No"; Code[30]) { }
        field(23; "Transaction Type"; Text[30]) { }
        field(24; "Loan No"; Code[30]) { }
        field(25; "Modified by"; Code[50]) { }
        field(26; "MerchantRequestID"; Code[30]) { }
        field(27; "CheckoutRequestID "; Code[30]) { }
        field(28; "ResponseCode"; Integer) { }
        field(29; "ResponseDescription"; Text[250]) { }
        field(30; "Received"; Boolean) { }
        field(31; "Customer No "; Code[20]) { }
        field(32; "Our Document No "; Code[20]) { }
        field(33; "Customer Details"; Text[250]) { }
    }

    keys
    {
        key(PK; "Receipt No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90048 "Teller Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(2; "Setup Type"; Option)
        {
            OptionMembers = Teller,Treasury;
        }
        field(3; "Account Code"; Code[20])
        {
            TableRelation = if ("Setup Type" = const(Teller)) "Bank Account" where("Account Type" = const(Till)) else
            if ("Setup Type" = const(Treasury)) "Bank Account" where("Account Type" = const(Treasury));
        }
        field(4; "Maximum Capacity"; Decimal) { }
        field(5; "Minimum Capacity"; Decimal) { }
        field(6; "Journal Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Journal Bacth"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template"));
        }
        field(8; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "User ID", "Setup Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90049 Coinage
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Denomination Code"; Code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[50]) { }
        field(3; "Denomination Value"; Decimal) { }
    }

    keys
    {
        key(Key1; "Denomination Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90050 "FOSA Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            OptionMembers = "Receive From Bank","Request From Treasury","Return To Treasury","Send to Bank","Inter Teller Transfer";
            Editable = false;
        }
        field(2; "Document No"; Code[20])
        {
            Editable = false;
        }
        field(3; "Source No"; Code[20])
        {
            TableRelation = if ("Transaction Type" = const("Inter Teller Transfer")) "Bank Account" where("Account Type" = const(Till), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Receive From Bank")) "Bank Account" where("Account Type" = const(Main))
            else
            if ("Transaction Type" = const("Request From Treasury")) "Bank Account" where("Account Type" = const(Till), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Return To Treasury")) "Bank Account" where("Account Type" = const(Till), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Send to Bank")) "Bank Account" where("Account Type" = const(Treasury), "Global Dimension 2 Code" = field("Global Dimension 2 Code"));
            trigger OnValidate()
            var
                Bank: Record "Bank Account";
            begin
                Bank.get("Source No");
                "Source Name" := Bank.Name;
            end;

        }
        field(4; "Source Name"; Text[100])
        {
            Editable = false;
        }
        field(5; Amount; Decimal) { }
        field(6; "Destination No"; Code[20])
        {
            TableRelation = if ("Transaction Type" = const("Inter Teller Transfer")) "Bank Account" where("Account Type" = const(Till), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Receive From Bank")) "Bank Account" where("Account Type" = const(Treasury), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Request From Treasury")) "Bank Account" where("Account Type" = const(Treasury), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Return To Treasury")) "Bank Account" where("Account Type" = const(Treasury), "Global Dimension 2 Code" = field("Global Dimension 2 Code"))
            else
            if ("Transaction Type" = const("Send to Bank")) "Bank Account" where("Account Type" = const(Main));
            trigger OnValidate()
            var
                Bank: Record "Bank Account";
            begin
                Bank.get("Destination No");
                "Destination Name" := Bank.Name;
            end;
        }
        field(7; "Destination Name"; Text[100])
        {
            Editable = false;
        }
        field(8; "Payment Refrence No"; Code[20])
        {

        }
        field(9; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(10; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(11; "Created By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; Status; Option)
        {
            Editable = false;
            OptionMembers = Inbound,Transit,Outbound;
        }
        field(14; "Posting Date"; Date) { }
        field(15; "Global Dimension 1 Code"; code[20])
        {
            Editable = false;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(16; Coinage; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("FOSA Transaction Coinage"."Total Value" where("Document No" = field("Document No")));
            Editable = false;
        }
        field(17; "Global Dimension 2 Code"; code[20])
        {
            Editable = false;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(18; "Source Balance"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document No")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90051 "FOSA Transaction Coinage"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Type"; Option)
        {
            OptionMembers = "Receive From Bank","Request From Treasury","Return To Treasury","Send to Bank","Inter Teller Transfer";
            Editable = false;
        }
        field(2; "Document No"; code[20])
        {
            Editable = false;
        }
        field(3; "Coinage Code"; code[20])
        {
            Editable = false;
        }
        field(4; "Coinage Description"; Text[150])
        {
            Editable = false;
        }
        Field(5; Quantity; Integer)
        {
            trigger OnValidate()
            begin
                Validate("Total Value");
            end;
        }
        field(6; "Coinage Value"; Decimal)
        {
            Editable = false;

        }
        field(7; "Total Value"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
                "Total Value" := Quantity * "Coinage Value";
            end;
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Document No", "Coinage Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90052 "Teller Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(2; "Transaction Type"; Option)
        {
            OptionMembers = "Cash Deposit","Cash Withdrawal";
            trigger OnValidate()
            begin
                SaccoSetup.Get();
                if "Transaction Type" = "Transaction Type"::"Cash Deposit" then
                    "Charge Code" := SaccoSetup."Cash Deposit Charges"
                else
                    "Charge Code" := SaccoSetup."Cash Withdrawal Charges";
            end;
        }
        field(3; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                Member.get("Member No");
                "Member Name" := Member."Full Name";
                "Account No" := '';
                "Account Name" := '';
            end;
        }
        field(4; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Account No"; Code[20])
        {
            trigger OnValidate()
            begin
                Vendor.get("Account No");
                Vendor.CalcFields(Balance, "Uncleared Effects");
                "Account Name" := Vendor.Name;
                "Available Balance" := Vendor.Balance;
                "Book Balance" := "Available Balance" + Vendor."Uncleared Effects";
            end;

            trigger OnLookup()
            var
                Vendor: Record Vendor;
            begin
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No");
                /*if "Transaction Type" = "Transaction Type"::"Cash Withdrawal" then
                    Vendor.SetRange("Cash Withdrawal Allowed", true)
                else
                    Vendor.SetRange("Cash Deposit Allowed", true);*/
                Vendor.SetFilter("Account Class", '<>%1', Vendor."Account Class"::Loan);
                IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Account No", Vendor."No.");

                END;

            end;
        }
        field(6; "Account Name"; Text[150])
        {
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                if "Transaction Type" = "Transaction Type"::"Cash Withdrawal" then begin
                    if Amount > "Available Balance" then
                        Error('You Can only transacto upto %1', "Available Balance");
                end;
            end;
        }
        field(8; Teller; Code[20])
        {
            Editable = false;
            TableRelation = "Teller Setup";
        }
        field(9; Till; Code[20])
        {
            Editable = false;
            TableRelation = "Bank Account";
        }
        field(10; "Approval Required"; Boolean)
        {
            Editable = false;
        }
        field(11; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        Field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "Created On"; Datetime)
        {
            Editable = false;
        }
        field(14; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(15; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(16; "Posted By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(17; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(18; "Available Balance"; Decimal)
        {
            Editable = false;
        }
        field(19; "Transacted By Name"; Text[50]) { }
        field(20; "Transacted By ID No"; code[20]) { }
        field(21; "Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(22; Coinage; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("FOSA Transaction Coinage"."Total Value" where("Document No" = field("Document No")));
            Editable = false;
        }
        field(23; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(24; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(25; "Book Balance"; Decimal)
        {
            Editable = false;
        }
    }


    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        TellerSetup: Record "Teller Setup";
        Member: Record Members;
        Vendor: Record Vendor;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Teller Transaction Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Teller Transaction Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        TellerSetup.get(UserId, TellerSetup."Setup Type"::Teller);
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        Till := TellerSetup."Account Code";
        Teller := UserId;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin
        TestField(Posted, false);
    end;

    trigger OnDelete()
    begin
        TestField(Posted, false);
    end;

    trigger OnRename()
    begin
        TestField(Posted, false);
    end;

}
table 90053 "Loan Appraisal Parameters"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Appraisal Code"; Code[20]) { }
        field(3; "Parameter Description"; Text[150])
        {
            Editable = false;
        }
        field(4; "Parameter Value"; Decimal) { }
        field(5; Type; Option)
        {
            OptionMembers = Earnig,Deduction;
        }
        field(6; Taxable; Boolean) { }
        field(7; Class; Option)
        {
            OptionMembers = "Basic Pay",Allowance,"Other Incomes","Other Deductions";
        }
    }

    keys
    {
        key(Key1; "Loan No", "Appraisal Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90054 "Appraisal Accounts"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Account Type"; Option)
        {
            OptionMembers = "Member Account",Multiplier,Loan;
        }
        field(3; "Account No"; Code[20]) { }
        field(4; "Account Description"; Text[150]) { Editable = false; }
        field(5; Balance; Decimal) { }
        field(6; "Mulltipled Value"; Decimal) { }
    }

    keys
    {
        key(Key1; "Loan No", "Account Type", "Account No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90055 "Loan Guarantees"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Loan Securities";
    LookupPageId = "Loan Securities";
    fields
    {
        field(1; "Loan No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; code[20])
        {
            TableRelation = members;
            trigger OnValidate()
            begin
                LoansManagement.CheckOkToGuarantee("Member No", "Loan No");
                if Member.get("Member No") then
                    "Member Name" := Member."Full Name";
                "Member Deposits" := LoansManagement.GetMemberDeposits("Member No");
                "Multiplied Deposits" := 4 * LoansManagement.GetMemberDeposits("Member No");
                if isSelf() then
                    "Available Guarantee" := LoansManagement.GetSelfGuaranteeEligibility("Member No")
                else
                    "Available Guarantee" := LoansManagement.GetNonSelfGuaranteeEligibility("Member No");
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Member Deposits"; Decimal)
        {
            Editable = false;
        }
        field(5; "Multiplied Deposits"; Decimal)
        {
            Editable = false;
        }
        field(6; "Guaranteed Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if isSelf then begin
                    if "Guaranteed Amount" > (LoansManagement.GetSelfGuaranteeEligibility("Member No")) then
                        Error('You can only guarantee upto %1', "Multiplied Deposits");
                end;
                self := isSelf();
                if "Guaranteed Amount" > "Member Deposits" then
                    Error('You can only guarantee upto %1', "Multiplied Deposits");
            end;
        }
        field(7; "Outstanding Guarantees"; Decimal)
        {
            Editable = false;
        }
        field(8; "Available Guarantee"; Decimal)
        {
            Editable = false;
        }
        field(9; "Self Guarantee"; Decimal)
        {
            Editable = false;
        }
        field(10; Self; Boolean)
        {
            Editable = false;
        }
        field(11; Substituted; Boolean)
        {
            Editable = false;
        }
        field(12; "Substituted By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(13; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(14; "Loan Owner"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Loan Application"."Member No." where("Application No" = field("Loan No")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Member No", "Loan No")
        {
            Clustered = true;
        }
    }
    var
        Member: Record Members;
        LoansManagement: Codeunit "Loans Management";

    local procedure isSelf() Success: boolean
    Var
        LoanApplication: Record "Loan Application";
    begin
        if LoanApplication.Get("Loan No") then begin
            if "Member No" = LoanApplication."Member No." then
                exit(true)
            else
                exit(false);
        end;
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90056 "External Recoveries Setup"
{
    DataClassification = ToBeClassified;
    LookupPageId = "External Recoveries Setup";
    DrillDownPageId = "External Recoveries Setup";
    fields
    {
        field(1; "Recovery Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Recovery Description"; Text[50]) { }
        field(3; "Post To Account Type"; Option)
        {
            OptionMembers = "G/L Account","Payable Account";
        }
        Field(4; "Post To Account No"; Code[20])
        {

            TableRelation = if ("Post To Account Type" = const("G/L Account")) "G/L Account" Where("Direct Posting" = const(true))
            else
            vendor where("Member No." = const(''));
        }
        field(5; Commission; Decimal) { }
        field(6; "Commission Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Recovery Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90057 "Loan Recoveries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Recovery Type"; Option)
        {
            OptionMembers = Loan,Account,External;
        }
        field(3; "Recovery Code"; Code[20])
        {
            trigger OnLookup()
            var
                LoanApplication, LoanApplication1 : Record "Loan Application";
                Vendor: Record Vendor;
                ProductFactory: Record "Product Factory";
                ExternalSetup: Record "External Recoveries Setup";
                LoansMgt: Codeunit "Loans Management";
            begin
                LoanApplication.Get("Loan No");
                Case "Recovery Type" of
                    rec."Recovery Type"::Account:
                        begin
                            Vendor.Reset();
                            Vendor.SetRange("Member No.", LoanApplication."Member No.");
                            Vendor.SetRange("Account Type", Vendor."Account Type"::Sacco);
                            IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                                VALIDATE("Recovery Code", Vendor."No.");
                                Vendor.CalcFields(Balance);
                                "Recovery Description" := Vendor.Name;
                                ProductFactory.Get(Vendor."Account Code");
                                "Commission %" := ProductFactory."Loan Recovery Commission %";
                                "Commission Account" := ProductFactory."Commission Account";
                                "Current Balance" := Vendor.Balance;
                            END;
                        end;
                    rec."Recovery Type"::Loan:
                        begin
                            LoanApplication1.Reset();
                            LoanApplication1.SetFilter("Application No", '<>%1', LoanApplication."Application No");
                            LoanApplication1.SetRange("Member No.", LoanApplication."Member No.");
                            LoanApplication1.SetFilter("Loan Balance", '>0');
                            IF PAGE.RUNMODAL(0, LoanApplication1) = ACTION::LookupOK THEN BEGIN
                                ProductFactory.Get(LoanApplication1."Product Code");
                                "Recovery Code" := LoanApplication1."Application No";
                                "Recovery Description" := ProductFactory.Name;
                                "Commission %" := ProductFactory."Discounting %";
                                "Commission Account" := ProductFactory."Commission Account";
                                LoanApplication1.CalcFields("Loan Balance");
                                "Current Balance" := LoanApplication1."Loan Balance";
                                "Prorated Interest" := LoansMgt.GetProratedInterest(LoanApplication1."Application No", LoanApplication."Application Date");
                                Validate(Amount, ("Current Balance" + "Prorated Interest"));
                            end;
                        end;
                    Rec."Recovery Type"::External:
                        begin
                            ExternalSetup.Reset();
                            IF PAGE.RUNMODAL(0, ExternalSetup) = ACTION::LookupOK THEN BEGIN
                                "Recovery Code" := ExternalSetup."Recovery Code";
                                "Recovery Description" := ExternalSetup."Recovery Description";
                                "Commission %" := ExternalSetup.Commission;
                                "Commission Account" := ExternalSetup."Commission Account";
                            end;
                        end;
                End
            end;
        }
        field(4; "Recovery Description"; Text[150])
        {
            Editable = False;
        }
        field(5; Amount; Decimal)
        {
            trigger OnValidate()
            var
                LProductFactory: Record "Product Factory";
                LoanApplication: Record "Loan Application";
                DepAportionment: Decimal;
            begin
                "Commission Amount" := Amount * "Commission %" * 0.01;
                if "Recovery Type" = "Recovery Type"::Account then begin
                    if LoanApplication.Get("Loan No") then begin
                        LoanApplication.TestField("Product Code");
                        LProductFactory.Get(LoanApplication."Product Code");
                        if ((LProductFactory."Max. NWD Boost" <> 0) AND (LProductFactory."Max. NWD Boost" < Amount)) then
                            Message('Product %1 Allows a Maximum Deposit Boost of %2', LProductFactory.Name, LProductFactory."Max. NWD Boost");
                        if (LProductFactory."Max. NWD Boost %" <> 0) then begin
                            DepAportionment := 0;
                            DepAportionment := "Current Balance" * LProductFactory."Max. NWD Boost %" * 0.01;
                            if Amount > DepAportionment then
                                Error('You can only boost upto %1 percent of your deposits', LProductFactory."Max. NWD Boost %");
                        end;
                    end;
                end;
            end;
        }
        field(6; "Commission %"; decimal)
        {
            Editable = false;
        }
        field(7; "Commission Amount"; decimal) { Editable = false; }
        field(8; "Commission Account"; Code[20]) { Editable = false; }
        field(9; "Current Balance"; Decimal)
        {
            Editable = false;
        }
        field(10; "Prorated Interest"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Loan No", "Recovery Type", "Recovery Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90058 "ATM Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        Field(1; "ATM Type"; Code[20]) { }
        Field(2; "Description"; Text[200]) { }
        Field(3; "Max Daily Withdrawal"; Decimal) { }
        Field(4; "Withdrawal T. Code (Coop)"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(5; "Activation T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(6; "Deposits T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(7; "Blocking T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(8; "Unblocking T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(9; "Pin Change T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(10; "Holding Account"; Code[20])
        {
            tablerelation = "G/L Account";
        }
        Field(11; "Replacement T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(12; "ATM Settlment Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        Field(13; "Withdrawal T. Code (VISA)"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(14; "Utility Payments T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(15; "MPesa Withdrawal T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(16; "Airtime Purchase T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(17; "POS School Payment T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(18; "POS Purchase T. Code (CBack)"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(19; "POS Cash Deposit T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(20; "POS Benefit CW T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(21; "POS Card Deposit T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(22; "POS M Banking T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(23; "POS Cash Withdrawal T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(24; "POS Balance Enquiry T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(25; "POS Ministatement T. Code"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(26; "POS Purchase T. Code (Normal)"; Code[20])
        {
            tablerelation = "SACCO Transaction Types";
        }
        Field(27; "ATM Cards"; Integer) { }
    }

    keys
    {
        key(Key1; "ATM Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90059 "ATM Cards"
{
    DataClassification = ToBeClassified;

    fields
    {
        Field(1; "Card No."; Code[40]) { }
        Field(2; "ATM Type"; Code[20]) { }
        Field(3; "ATM Type Description"; Text[50])
        {
            Editable = false;
        }
        Field(4; "Expiry Date"; Date) { }
        Field(5; "Status"; Option)
        {
            OptionMembers = New,Transacting,Blocked,Expired;
            Editable = false;
        }
        Field(6; "Assigned To Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Members;
        }
        Field(7; "Assigned to Account No"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        Field(8; "Account No"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        Field(9; "PIN Received"; Boolean) { Editable = false; }
        Field(10; "Added By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        Field(11; "Added On"; DateTime) { Editable = false; }
        Field(12; "Assigned On"; DateTime) { Editable = false; }
        Field(13; "Assigned By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Card No.", "ATM Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Added By" := UserId;
        "Added On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90060 "ATM Application"
{
    DataClassification = ToBeClassified;
    LookupPageId = "ATM Applications Lookup";
    fields
    {
        Field(1; "Application No"; Code[20])
        {
            Editable = false;
        }
        Field(2; "Application Date"; Date) { }
        Field(3; "Member No"; Code[100])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Member: Record Members;
            begin
                if Member.get("Member No") then begin
                    "Member Name" := Member."Full Name";
                    "Member ID" := Member."National ID No";
                end;
            end;
        }
        Field(4; "Member Name"; Text[150])
        {
            Editable = false;
        }
        Field(5; "Created On"; Date)
        {
            Editable = false;
        }
        Field(6; "Created By"; Code[100])
        {
            Editable = false;
        }
        Field(7; "Last Updated On"; Date)
        {
            Editable = false;
        }
        Field(8; "Last Updated By"; Code[100])
        {
            Editable = false;
        }
        Field(9; "Application Type"; Option)
        {
            OptionMembers = New,Reactivation,Delinking;
        }
        Field(10; "Account No."; Code[20])
        {
            TableRelation = Vendor Where("Member No." = field("Member No"));
            trigger OnValidate()
            var
                vendor: Record Vendor;
            begin
                vendor.get("Account No.");
                vendor.CalcFields(Balance);
                "Account Name" := vendor.Name;
                "Current Balance" := vendor.Balance;
            end;
        }
        Field(11; "Account Name"; Text[100])
        {
            Editable = false;
        }
        Field(12; "ATM Type"; Code[20])
        {
            TableRelation = "ATM Types";
        }
        Field(13; "ATM Type Name"; Text[50])
        {
            Editable = false;
        }
        Field(14; "Card No."; Code[20])
        {
            trigger OnValidate()
            var
                ATMCards: Record "ATM Cards";
            begin
                if ATMCards.Get("ATM Type", "Card No.") then begin
                    Error('The Card Already Exists and is linked');
                end;
            end;
        }
        Field(15; "Card Expiry Date"; Date) { }
        Field(16; "Processed By"; Code[100])
        {
            editable = false;
        }
        Field(17; "Processed On"; Date)
        {
            editable = false;
        }
        Field(18; "Processed At"; Time)
        {
            editable = false;
        }
        Field(19; "Processed"; Boolean)
        {
            editable = false;
        }
        Field(20; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            editable = false;
        }
        Field(21; "Action ID"; Code[100])
        {
            Editable = false;
        }
        Field(22; "Total Approval"; Integer)
        {
            Editable = false;
        }
        Field(23; "ATM Collected By"; Text[100]) { }
        Field(24; "ATM Collected By ID No."; Code[50]) { }
        Field(25; "Current Balance"; Decimal) { }
        Field(26; "Member ID"; Code[20])
        {
            Editable = false;
        }
        Field(27; "Transaction Code"; Code[20]) { tablerelation = "SACCO Transaction Types"; }
    }

    keys
    {
        key(Key1; "Application No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin

        SaccoSetup.get;
        SaccoSetup.TestField("Member Exit Nos");
        "Application No" := NoSeries.GetNextNo(SaccoSetup."Member Exit Nos", Today, true);
        "Application Date" := Today;
        "Created By" := UserId;
        "Last Updated By" := UserId;
        "Created On" := Today;
        "Last Updated On" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90061 "ATM Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        Field(1; "Entry No."; Integer) { }
        Field(2; "Posting Date"; Date) { }
        Field(3; "Account No"; Code[20]) { }
        Field(4; "Description"; Text[200]) { }
        Field(5; "Amount"; Decimal) { }
        Field(6; "Posting S"; Text[50]) { }
        Field(7; "Posted"; Boolean) { }
        Field(8; "Unit ID"; Code[10]) { }
        Field(9; "Transaction Type"; Text[30]) { }
        Field(10; "Trans Time"; Text[50]) { }
        Field(11; "Transaction Time"; Time) { }
        Field(12; "Transaction Date"; Date) { }
        Field(13; "Source"; Option)
        {
            OptionMembers = "COOP","M-PESA","ATM","TIETO";
        }
        Field(14; "Reversed"; Boolean) { }
        Field(16; "Reversed Posted"; Boolean) { }
        Field(17; "Reversal Trace ID"; Code[20]) { }
        Field(18; "Transaction Description"; Text[100]) { }
        Field(19; "Withdrawal Location"; Text[150]) { }

        Field(20; "Trace ID"; Code[20]) { }
        Field(22; "Transaction Type Charges"; Option)
        {
            OptionMembers = "Balance Enquiry","Mini Statement","Cash Withdrawal - Coop ATM","Cash Withdrawal - VISA ATM","Reversal","Utility Payment","POS - Normal Purchase","M-PESA Withdrawal","Airtime Purchase","POS - School Payment","POS - Purchase With Cash Back","POS - Cash Deposit","POS - Benefit Cash Withdrawal","POS - Cash Deposit to Card","POS - M Banking","POS - Cash Withdrawal","POS - Balance Enquiry","POS - Mini Statement";
        }
        Field(23; "Card Acceptor Terminal ID	"; Code[20]) { }
        Field(24; "ATM Card No"; Code[20]) { }
        Field(25; "Customer Names"; Text[250]) { }
        Field(26; "Process Code"; Code[20]) { }
        Field(27; "Reference No"; Text[250]) { }
        Field(28; "Is Coop Bank"; Boolean) { }
        Field(29; "POS Vendor"; Option)
        {
            optionMembers = "ATM Lobby","Agent Banking","Coop Branch","Sacco POS";
        }
        field(30; "Card Acceptor Terminal ID"; Code[50]) { }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90062 "Member Exit Header"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Member Exits Lookup";
    LookupPageId = "Member Exits Lookup";
    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            editable = false;
        }
        field(2; "Member No"; Code[20])
        {
            tableRelation = Members;
            trigger OnValidate()
            var
                Member: Record Members;
            begin
                if Member.get("Member No") then
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Withdrawal Type"; Option)
        {
            OptionMembers = General,Retiree,Desceased;
        }
        field(5; "Balance Option"; Option)
        {
            OptionMembers = "FOSA Withdrawal","Bank Transfer";
        }
        Field(6; Instant; Boolean) { }
        Field(7; "Holding Account"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor Where("Account Type" = CONST("Supplier"));
        }
        Field(8; "Total Assets"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Member Exit Lines"."Amount (Base)" where("Document No" = field("Document No"), "Entry Type" = const(Asset)));
            Editable = false;
        }
        field(9; Guarantees; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Member Exit Lines"."Amount (Base)" where("Document No" = field("Document No"), "Entry Type" = const(Guarantee)));
            Editable = false;
        }
        field(10; Liabilities; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Member Exit Lines"."Amount (Base)" where("Document No" = field("Document No"), "Entry Type" = const(Liability)));
            Editable = false;
        }
        field(11; "Charge Code"; Code[20]) { tablerelation = "SACCO Transaction Types"; }
        field(12; "Posting Date"; Date)
        {
            trigger OnValidate()
            begin
                "Due Date" := CalcDate('CM+2M', "Posting Date");
            end;
        }
        field(13; "Marturity Date"; Date) { }
        field(14; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = False;
        }
        field(15; Posted; Boolean)
        {
            Editable = false;
        }
        field(16; "Withdrawal Reason"; Text[100]) { }
        field(17; "Due Date"; Date)
        {
            Editable = false;
        }
        field(18; "Net Amount"; Decimal)
        {
            Editable = false;
        }
        field(19; "Accrued Interest"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Member Exit Lines"."Accrued Interest" where("Document No" = field("Document No"), "Entry Type" = const(Liability)));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Member Exit Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Member Exit Nos", Today, true);
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90063 "Member Exit Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            TableRelation = "Member Exit header";

        }
        field(2; "Entry No"; Integer) { }
        field(3; "Entry Type"; Option)
        {
            OptionMembers = Asset,Liability,Guarantee;
        }
        field(4; "Account No"; Code[20]) { }
        field(5; "Account Name"; Text[100]) { }
        field(6; "Balance"; Decimal) { }
        field(7; "Amount (Base)"; Decimal) { }
        field(8; "Accrued Interest"; Decimal) { }
    }

    keys
    {
        key(Key1; "Document No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90064 "Loan Recovery Header"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Loan Recovery Lookup";
    LookupPageId = "Loan Recovery Lookup";
    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
                LoansMgt: Codeunit "Loans Management";
            begin
                Members.Get("Member No");
                "Member Name" := Members."Full Name";
                "Member Deposits" := LoansMgt.GetMemberDeposits("Member No");
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Loan No"; code[20])
        {
            TableRelation = "Loan Application" where("Member No." = field("Member No"), "Loan Balance" = filter('>0'));
            trigger OnValidate()
            var
                RecoveryLines: Record "Loan Recovery Lines";
                Guarantees: Record "Loan Guarantees";
                LoanApplication: Record "Loan Application";
                LoansMgt: Codeunit "Loans Management";
                MemberMgt: Codeunit "Member Management";
                AccruedInterest: Decimal;
                Days: Integer;
                Vendor: Record Vendor;
                LoanRecoveryAccounts: Record "Loan Recovey Accounts";
                Products: Record "Product Factory";
            begin
                LoanRecoveryAccounts.Reset();
                LoanRecoveryAccounts.SetRange("Document No", "Document No");
                if LoanRecoveryAccounts.FindSet() then
                    LoanRecoveryAccounts.DeleteAll();
                RecoveryLines.Reset();
                RecoveryLines.SetRange("Document No", Rec."Document No");
                if RecoveryLines.FindSet() then
                    RecoveryLines.DeleteAll();
                LoanApplication.Get("Loan No");
                LoanApplication.CalcFields("Loan Balance", "Principle Balance");
                "Product Description" := LoanApplication."Product Description";
                "Product Code" := LoanApplication."Product Code";
                "Loan Balance" := LoanApplication."Loan Balance";
                AccruedInterest := 0;
                AccruedInterest := LoansMgt.GetAccruedInterest("Loan No", "Posting Date");
                "Accrued Interest" := AccruedInterest;
                "Total Recoverable" := "Accrued Interest" + "Loan Balance";
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No");
                Vendor.SetFilter(Balance, '>0');
                Vendor.SetRange(Blocked, 0);
                if Vendor.FindSet() then begin
                    repeat
                        if Products.Get(Vendor."Account Code") then begin
                            if Products."Member Posting Type" in [Products."Member Posting Type"::Holiday, Products."Member Posting Type"::Investments,
                            Products."Member Posting Type"::"Non Withrawable Deposit", Products."Member Posting Type"::"Withdrawable Deposit"] then begin
                                Vendor.CalcFields(Balance);
                                LoanRecoveryAccounts.Init();
                                LoanRecoveryAccounts."Document No" := "Document No";
                                LoanRecoveryAccounts."Account No" := Vendor."No.";
                                LoanRecoveryAccounts."Account Name" := Vendor.Name;
                                LoanRecoveryAccounts."Current Balance" := Vendor.Balance;
                                LoanRecoveryAccounts.Insert();
                            end;
                        end;
                    until Vendor.Next() = 0;
                end;
                Guarantees.Reset();
                Guarantees.SetRange(Substituted, false);
                Guarantees.SetRange("Loan No", "Loan No");
                if Guarantees.FindSet() then begin
                    repeat
                        RecoveryLines.Init();
                        RecoveryLines."Document No" := "Document No";
                        RecoveryLines."Member No" := Guarantees."Member No";
                        RecoveryLines."Member Name" := Guarantees."Member Name";
                        RecoveryLines."Member Deposits" := LoansMgt.GetMemberDeposits(RecoveryLines."Member No");
                        RecoveryLines."Outstanding Guarantee" := MemberMgt.GetOutstandingGuarantee("Loan No", Guarantees."Member No");
                        RecoveryLines.Insert();
                    until Guarantees.Next() = 0;
                end;
            end;
        }
        field(5; "Product Code"; Code[20])
        {
            Editable = false;
        }
        field(6; "Product Description"; Text[100])
        {
            Editable = false;
        }
        field(7; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(8; "Posting Date"; Date) { }
        field(9; "Accrued Interest"; Decimal)
        {
            Editable = false;
        }
        field(10; "Total Recoverable"; Decimal)
        {
            Editable = false;
        }
        field(11; "Self Recovery Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recovey Accounts"."Recovery Amount" where("Document No" = field("Document No")));
        }
        field(12; "Member Deposits"; Decimal)
        {
            Editable = false;
        }
        field(13; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(14; "Created By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(15; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(16; Processed; Boolean)
        {
            Editable = false;
        }
        field(17; "Guarantor Deposit Recovery"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recovery Lines"."Recovery Amount" where("Document No" = field("Document No"), "Recovery Type" = const(Deposits)));
        }
        field(18; "Guarantor Liability Recovery"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recovery Lines"."Recovery Amount" where("Document No" = field("Document No"), "Recovery Type" = const("Guarantor Liability Loan")));
        }
        field(19; "Member Balances"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recovey Accounts"."Current Balance" where("Document No" = field("Document No")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Loan Recovery Nos");
        "Document No" := Noseries.GetNextNo(SaccoSetup."Loan Recovery Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90065 "Guarantor Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Line No"; Integer) { }
        field(3; "Member No"; Code[20]) { }
        field(4; "Member Name"; Text[100]) { }
        field(5; "Loan No."; code[20]) { }
        field(6; "Product Code"; Code[20]) { }
        field(7; "Product Description"; Text[100]) { }
        field(8; "Loan Principle"; Decimal) { }
        field(9; "Loan Balance"; Decimal) { }
        field(11; "Guaranteed Amount"; Decimal) { }
        field(12; "Outstanding Guarantee"; Decimal) { }
        field(13; Release; Boolean) { }
        field(14; Substitution; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Guarantor Mgt. Det. Lines" where("Document No" = field("Document No"), "Line No" = field("Line No")));
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90066 "Guarantor Mgt. Det. Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Line No"; Integer)
        {
        }
        field(3; "Member No"; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Member: Record Members;
                LoansMgt: Codeunit "Loans Management";
                GuarantorLines: Record "Guarantor Lines";
                LoanProduct: Record "Product Factory";
            begin
                Member.Get("Member No");
                "Member Name" := Member."Full Name";
                "Qualified Guarantee" := 0;
                if GuarantorLines.Get("Document No", "Line No") then begin
                    LoanProduct.Get(GuarantorLines."Product Code");
                    if "Member No" = GuarantorLines."Member No" then begin
                        if LoanProduct."Allow Self Guarantee" = false then
                            Error('The product does not allow self guarantee');
                        "Qualified Guarantee" := LoansMgt.GetSelfGuaranteeEligibility("Member No");
                        "Self Guarantee" := true;
                    end else begin
                        "Qualified Guarantee" := LoansMgt.GetNonSelfGuaranteeEligibility("Member No");
                        "Self Guarantee" := false;
                    end;
                end;
            end;
        }
        field(4; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Qualified Guarantee"; Decimal)
        {
            Editable = false;
        }
        field(6; "Self Guarantee"; Boolean)
        {
            Editable = false;
        }
        field(7; "Guarantee Amount"; Decimal) { }
        field(8; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90067 "Checkoff Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Checkoff Lookup";
    DrillDownPageId = "Checkoff Lookup";
    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Document Date"; Date) { }
        field(3; "Posting Date"; Date) { }
        field(4; "Posting Description"; Text[50]) { }
        field(5; "Balancing Account Type"; Option)
        {
            OptionMembers = Receivable,"Bank Account";
        }
        field(6; "Balancing Account No"; Code[20])
        {
            TableRelation = Customer;
        }
        field(7; "Charge Code"; Code[20]) { tablerelation = "SACCO Transaction Types"; }
        field(8; "Created By"; Code[100])
        {
            tableRelation = "User Setup";
        }
        field(9; "Created On"; DateTime)
        {
            Editable = false;
        }
        Field(10; Posted; Boolean)
        {
            Editable = false;
        }
        Field(11; "Suspense Account"; code[20])
        {
            TableRelation = Customer;
        }
        field(12; "Upload Type"; Option)
        {
            OptionMembers = Salary,Checkoff,Allowances;
        }
        field(13; "Uploaded Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Checkoff Upload".Amount where("Document No" = field("Document No")));
            Editable = false;
        }
        field(14; "Employer Code"; code[20])
        {
            TableRelation = "Employer Codes";
        }
        field(15; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(16; Amount; Decimal) { }
        field(17; Variance; Decimal)
        {
            Editable = false;
        }
        field(18; "Total Members"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Checkoff Lines" where("Document No" = field("Document No")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Checkoff Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Checkoff Nos", Today, true);
        "Document Date" := Today;
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90068 "Checkoff Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20]) { }
        field(3; "Check No"; Code[20]) { }
        field(4; "Member Name"; Text[100]) { }
        field(5; "Collections Account"; Code[20]) { }
        field(6; "Mobile Phone No"; Code[30]) { }
        field(7; Posted; Boolean) { }
        field(8; "Suspense Account"; Boolean) { }
        field(9; "Amount Earned"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Checkoff Calculation"."Amount (Base)" where("Document No" = field("Document No"), "Check No" = field("Check No"), "Member No" = field("Member No"), "Entry Type" = filter(= "Net Amount")));
        }
        field(10; "Recoveries"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Checkoff Calculation"."Amount (Base)" where("Document No" = field("Document No"), "Check No" = field("Check No"), "Member No" = field("Member No"), "Entry Type" = filter(<> "Net Amount")));
        }
        field(11; "Net Amount"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Checkoff Calculation"."Amount (Base)" where("Document No" = field("Document No"), "Check No" = field("Check No"), "Member No" = field("Member No")));
        }
        field(12; "Running Loans"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Loan Application" where("Member No." = field("Member No"), "Loan Balance" = filter(> 0)));
            Editable = false;
        }
        field(13; "Upload Type"; Option)
        {
            OptionMembers = Salary,Checkoff,Allowances;
            FieldClass = FlowField;
            CalcFormula = lookup("Checkoff Header"."Upload Type" where("Document No" = field("Document No")));
        }
        field(14; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Checkoff Header"."Posting Date" where("Document No" = field("Document No")));
        }
    }

    keys
    {
        key(Key1; "Document No", "Member No", "Check No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90069 "Checkoff Upload"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Checkoff Upload Entries";
    LookupPageId = "Checkoff Upload Entries";
    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Check No"; Code[20]) { }
        field(3; "Member Name"; Text[100]) { }
        field(4; Amount; Decimal) { }
        field(5; Remarks; Code[20]) { }
        field(6; Refrence; Code[30]) { }
    }

    keys
    {
        key(Key1; "Document No", "Check No", Remarks, Refrence)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90070 "Checkoff Calculation"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Checkoff Calculations";
    LookupPageId = "Checkoff Calculations";
    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Member No"; Code[20]) { }
        field(3; "Check No"; Code[20]) { }
        field(4; "Entry No"; Integer) { }
        field(5; "Entry Type"; Option)
        {
            OptionMembers = "Net Amount","Loan Recovery","Standing Order","Internal Deposit",Commission;
        }
        field(6; "Account No"; Code[20]) { }
        field(7; Amount; Decimal) { }
        Field(8; "Loan No"; Code[20]) { }
        field(9; "Account Name"; Text[100]) { }
        field(10; "Amount (Base)"; Decimal) { }
    }

    keys
    {
        key(Key1; "Document No", "Member No", "Check No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90071 "Sacco Transaction Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Transaction Description"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90072 "Transaction Charges"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Charge Code"; Code[20])
        {
            TableRelation = Charges;
            trigger OnValidate()
            begin
                ChargeSetup.get("Charge Code");
                "Charge Description" := ChargeSetup.Description;
                "Post to Account" := ChargeSetup."Post-to Account No.";
                "Post To Account Type" := ChargeSetup."Post to Account Type";
            end;
        }
        field(3; "Charge Description"; Text[100])
        {
            Editable = false;
        }
        field(4; "Post to Account"; code[20]) { Editable = false; }
        field(5; "Post To Account Type"; Option)
        {
            OptionMembers = "G/L Account","Liability Account";
            Editable = false;
        }
        Field(6; "Calculation Type"; Option)
        {
            OptionMembers = "Calculation Scheme","Percentage of Charge";
        }
        field(7; "Source Code"; Code[20])
        {
            TableRelation = "Transaction Charges"."Charge Code" where("Transaction Code" = field("Transaction Code"));
        }
    }

    keys
    {
        key(Key1; "Transaction Code", "Charge Code")
        {
            Clustered = true;
        }
    }

    var
        ChargeSetup: Record Charges;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90073 "Transaction Calc. Scheme"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Charge Code"; Code[20]) { }
        field(3; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Lower Limit"; Decimal) { }
        field(5; "Upper Limit"; Decimal) { }
        field(6; "Rate Type"; Option)
        {
            OptionMembers = "Flat Rate","Percentage";
        }
        field(7; Rate; Decimal) { }
    }

    keys
    {
        key(Key1; "Transaction Code", "Charge Code", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90074 "Transaction Recoveries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Recovery Type"; Option)
        {
            OptionMembers = Loan,"Standing Order";
        }
        field(3; "Recovery Code"; code[20])
        {
            TableRelation = if ("Recovery Type" = const(Loan)) "Product Factory" where("Account Class" = const(Loan))
            else
            "STO Types";
            trigger OnValidate()
            var
                STOTypes: Record "STO Types";
                ProductCode: Record "Product Factory";
            begin
                if "Recovery Type" = "Recovery Type"::Loan then begin
                    if ProductCode.Get("Recovery Code") then
                        "Recovery Descrition" := ProductCode.Name;
                end;
                if "Recovery Type" = "Recovery Type"::"Standing Order" then begin
                    if STOTypes.Get("Recovery Code") then
                        "Recovery Descrition" := STOTypes.Description;
                end;
            end;
        }
        field(4; "Recovery Descrition"; Text[100]) { }
        field(5; "Prioirity"; Integer) { }
        field(6; "Recovery Amount"; Option)
        {
            OptionMembers = "Monthly Installment","Loan Arrears";
        }
        field(7; "Minimum Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Transaction Code", "Recovery Type", "Recovery Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;
}
table 90075 "Online Guarantor Requests"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan No") THEN
                    AppliedAmount := LoanApplication."Applied Amount";
                ApplicantName := LoanApplication."Member Name";
                Applicant := LoanApplication."Member No.";
                "Application Date" := LoanApplication."Application Date";
                "Product Name" := LoanApplication."Product Description";
                "Loan Type" := LoanApplication."Product Code";
            end;
        }
        field(2; "ID No"; Code[20])
        {
            trigger OnValidate()
            var
                OnlineGuarantorReq: Record "Online Guarantor Requests";
            begin
                IF Member.GET("ID No") THEN
                    "Member Name" := Member."Full Name"
                else begin
                    Member.Reset();
                    Member.SetRange("National ID No", "ID No");
                    if Member.FindFirst() then
                        "Member Name" := Member."Full Name"
                    else
                        Error('The Member No/ID No Does Not Exist');
                end;
                "Member No" := Member."Member No.";
                PhoneNo := Member."Mobile Phone No.";
                OnlineGuarantorReq.Reset();
                if "Request Type" = "Request Type"::Guarantor then
                    OnlineGuarantorReq.SetRange("Request Type", OnlineGuarantorReq."Request Type"::Witness);
                if "Request Type" = "Request Type"::Witness then
                    OnlineGuarantorReq.SetRange("Request Type", OnlineGuarantorReq."Request Type"::Guarantor);
                OnlineGuarantorReq.SetRange("ID No", "ID No");
                OnlineGuarantorReq.SetRange("Loan No", "Loan No");
                if OnlineGuarantorReq.FindSet() then
                    Error('You cannot use the same member as a guarantor and a witness');
                if LoanApplication.Get("Loan No") then begin
                    if "Request Type" = "Request Type"::Witness then begin
                        if Member.get(LoanApplication."Member No.") then begin
                            if Member."National ID No" = "ID No" then
                                Error('You Cannot be your own witness');
                        end;
                    end;
                end;
                //     LoansManagement.ValidateOnlineMemberGuarantee(Rec);
                //     "Guarantor Value" := LoansManagement.GetGuarantorValue("Member No");
            end;
        }
        field(3; "Member Name"; Text[200])
        {
            Editable = false;
        }
        field(4; "Loan Principal"; Decimal)
        {
        }
        field(5; Status; Option)
        {
            OptionMembers = New,Accepted,Rejected;
            OptionCaption = 'New,Accepted,Rejected';
            Editable = false;
        }
        field(6; "Loan Submitted"; Boolean)
        {

        }
        field(7; "PhoneNo"; Code[30])
        {

        }
        field(8; "AppliedAmount"; Integer)
        {

        }
        field(9; Applicant; Code[60])
        {

        }
        field(10; ApplicantName; Code[200])
        {

        }
        field(11; "Rejection Reason"; Text[300])
        {

        }
        field(12; "Guarantor Value"; Decimal)
        {

        }
        field(13; "Amount Accepted"; Decimal) { }
        field(14; "Request Type"; Option)
        {
            OptionMembers = Guarantor,Witness,Substitution;
        }
        field(15; "Requested Amount"; Decimal) { }
        field(16; "Member No"; Code[20]) { }
        field(17; "Application Date"; Date) { }
        field(18; "Loan Type"; Code[20]) { }
        field(19; "Product Name"; Text[100]) { }
        field(20; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(21; "Responded On"; DateTime)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Loan No", "ID No", "Request Type")
        {
            Clustered = true;
        }
    }

    var
        Member: Record Members;
        LoanApplication: Record "Online Loan Application";
        LoansManagement: Codeunit "Loans Management";

    trigger OnInsert()
    var
        OnlineGuarantorReq: Record "Online Guarantor Requests";
    begin
        OnlineGuarantorReq.Reset();
        if "Request Type" = "Request Type"::Guarantor then
            OnlineGuarantorReq.SetRange("Request Type", OnlineGuarantorReq."Request Type"::Witness);
        if "Request Type" = "Request Type"::Witness then
            OnlineGuarantorReq.SetRange("Request Type", OnlineGuarantorReq."Request Type"::Guarantor);
        OnlineGuarantorReq.SetRange("ID No", "ID No");
        OnlineGuarantorReq.SetRange("Loan No", "Loan No");
        if OnlineGuarantorReq.FindSet() then
            Error('You cannot use the same member as a guarantor and a witness');
        if LoanApplication.Get("Loan No") then begin
            if "Request Type" = "Request Type"::Witness then begin
                if Member.get(LoanApplication."Member No.") then begin
                    if Member."National ID No" = "ID No" then
                        Error('You Cannot be your own witness');
                end;
            end;
        end;
        "Created On" := CurrentDateTime;
        LoansManagement.SendGuarantorRequestCommunication(Rec);
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90076 "Dividend Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;

        }
        field(2; "Posting Type"; Option)
        {
            OptionMembers = Payout,Provision;
        }
        field(3; "Posting Date"; Date)
        {

        }
        field(4; "Posting Description"; Text[50]) { }
        field(5; "Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(6; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(7; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(9; Posted; Boolean)
        {
            Editable = false;
        }
        field(10; "Start Date"; Date) { }
        field(11; "End  Date"; Date) { }
        field(12; "Mobile Payments Control"; code[20])
        {
            TableRelation = Vendor."No." where("Account Class" = const(0));
        }
        field(13; "Bank Transfers Control"; Code[20])
        {
            TableRelation = Vendor."No." where("Account Class" = const(0));
        }
        field(14; "Allocation Expiry Date"; Date) { }
        field(15; "Debit Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
        field(16; "Credit Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }

    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Dividend Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Dividend Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90077 "Dividend Parameters"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Savings Account"));
            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
            begin
                if ProductFactory.get("Account Type") then
                    "Account Description" := ProductFactory.Name;
            end;
        }
        field(4; "Account Description"; Text[100])
        {
            Editable = false;
        }
        field(5; Rate; Decimal) { }
        field(6; "Rate Type"; Option)
        {
            OptionMembers = "Straight Line","Pro-rated";
        }
        field(7; "Debit Account"; Code[20])
        {
            TableRelation = "G/L Account" where("Direct Posting" = const(true));
        }
    }

    keys
    {
        key(Key1; "Document No", "Account Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90078 "Dividend Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20]) { }
        field(3; "Account No"; Code[20]) { }
        field(4; "Member Name"; Text[100]) { }
        field(5; "Account Name"; Text[100]) { }
        field(6; "Amount Earned"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Dividend Progression"."Amount Earned" where("Document No" = field("Document No"), "Member No" = field("Member No"), "Account No" = field("Account No")));
            Editable = false;
        }
        field(7; "Recoveries"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Dividend Det. Lines"."Amount (Base)" where("Document No" = field("Document No"), "Member No" = field("Member No"), "Account No" = field("Account No"), "Entry Type" = const(Recovery)));
            Editable = false;
        }
        field(8; "Net Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Dividend Det. Lines"."Amount (Base)" where("Document No" = field("Document No"), "Member No" = field("Member No"), "Account No" = field("Account No")));
            Editable = false;
        }
        field(9; Posted; Boolean) { Editable = false; }
        field(10; "Account Type"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Document No", "Member No", "Account No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90079 "Dividend Det. Lines"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Dividend Detail Lines";
    DrillDownPageId = "Dividend Detail Lines";
    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Entry No"; Integer) { }
        field(3; "Entry Type"; Option)
        {
            OptionMembers = Earning,Recovery;
        }
        field(4; "Transaction Code"; Code[20]) { }
        field(5; "Transaction Description"; Text[100])
        {
            Editable = false;
        }
        field(6; Amount; Decimal) { }
        field(7; "Amount (Base)"; Decimal) { }
        field(8; "Member No"; Code[20]) { }
        field(9; "Account No"; Code[20]) { }
        field(10; "Post To Account"; Code[20]) { }
        field(11; "Post to Account Type"; Option)
        {
            OptionMembers = "G/L Account",Loan,"Member Account";
        }
    }

    keys
    {
        key(Key1; "Document No", "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90080 "Member Activations"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Member Reactivations";
    DrillDownPageId = "Member Reactivations";
    fields
    {
        field(1; "Document No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No."; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
            begin
                Members.Get("Member No.");
                "Member Name" := Members."Full Name";
            end;
        }
        field(3; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Document Date"; Date) { }
        field(5; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(6; Posted; Boolean)
        {
            Editable = false;
        }
        field(7; "Posted By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(8; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(9; "Reactivation Fee"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
            trigger OnValidate()
            var
                JournalMgt: Codeunit "Journal Management";
            begin
                "Reactivation Fee Amount" := JournalMgt.GetTransactionCharges("Reactivation Fee", 9999999);
            end;
        }
        field(10; "Reactivation Fee Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Payment Refrence"; code[20]) { }
        field(12; "Pay From Account Type"; Option)
        {
            OptionMembers = "Cash Book","Member Account";
        }
        field(13; "Pay From Account"; Code[20])
        {
            trigger OnLookup()
            var
                Vendor: Record Vendor;
                Bank: Record "Bank Account";
            begin
                if "Pay From Account Type" = "Pay From Account Type"::"Cash Book" then begin
                    Bank.Reset();
                    Bank.SetRange(Blocked, false);
                    IF PAGE.RUNMODAL(0, Bank) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Pay From Account", Bank."No.");
                    END;
                end else begin
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", Rec."Member No.");
                    Vendor.SetRange("Account Class", Vendor."Account Class"::Collections);
                    IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Pay From Account", Vendor."No.");
                    END;
                end;
            end;
        }
        field(14; "Posting Date"; Date) { }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        Member: Record Members;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Member Reactivation Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Member Reactivation Nos", Today, true);
        "Document Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90081 "Cheque Instructions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Account Type"; Option)
        {
            OptionMembers = Account,Loan;
        }
        field(4; "Account No"; Code[20])
        {
            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::Account then begin
                    if Vendor.get("Account No") then begin
                        Vendor.CalcFields(Balance);
                        "Account Name" := Vendor.Name;
                        "Loan Balance" := Vendor.Balance;
                    end;
                end else begin
                    if Loan.get("Account No") then begin
                        Loan.CalcFields("Loan Balance");
                        "Loan Balance" := Loan."Loan Balance";
                        "Account Name" := Loan."Product Description";
                    end;
                end;
            end;

            trigger OnLookup()
            var
                ChequeDeposit: Record "Cheque Deposits";
            begin
                ChequeDeposit.get("Document No");
                if "Account Type" = "Account Type"::Account then begin
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", ChequeDeposit."Member No");
                    Vendor.SetFilter("Account Type", '<>%1', Vendor."Account Type"::Loan);
                    IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Account No", Vendor."No.");
                    END;
                end else begin
                    Loan.Reset();
                    Loan.SetRange("Member No.", ChequeDeposit."Member No");
                    Loan.SetFilter("Loan Balance", '>0');
                    IF PAGE.RUNMODAL(0, Loan) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Account No", Loan."Application No");
                    END;
                end;
            end;
        }
        field(5; "Account Name"; Text[100]) { Editable = false; }
        field(6; Amount; decimal) { }
        field(7; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    var
        Vendor: Record Vendor;
        Loan: Record "Loan Application";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90082 "Cheque Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cheque Type"; Code[20]) { }
        field(2; "Description"; Text[150]) { }
        field(3; "Clearing Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(4; "Clearing Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(5; "Express Clearing Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(6; "Bouncing Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
    }

    keys
    {
        key(Key1; "Cheque Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90083 "STO Types"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "STO Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[100]) { }
        field(3; "Default Account"; Code[20])
        {
            TableRelation = Vendor where("Account Type" = const(EFT));
        }
        field(4; "Charge Code"; Code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }

    }

    keys
    {
        key(Key1; "STO Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90084 "Mobile Transsactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer) { }
        field(2; "Transaction Type"; Code[10]) { }
        field(4; "Document No"; Code[20]) { }
        field(5; "Cr_Member No"; Code[20]) { }
        field(6; "Dr_Member No"; Code[20]) { }
        field(7; "Cr_Account No"; Code[20]) { }
        field(8; "Dr_Account No"; Code[20]) { }
        field(9; Amount; Decimal) { }
        field(10; "Created On"; DateTime) { }
        field(11; "Created By"; Code[100]) { }
        field(12; Posted; Boolean) { }
        field(13; Narration; Text[100]) { }
        field(14; "Utility Code"; Code[20]) { }
        field(15; "Posted On"; DateTime) { }
    }
    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90085 "Economic Sectors"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sector Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Sector Name"; Text[100])
        {

        }
        field(3; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(4; "Created On"; DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Sector Code")
        {
            Clustered = true;
        }
        key(key2; "Sector Name") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sector Code", "Sector Name") { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90086 "Economic Subsectors"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sector Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Sub Sector Code"; Code[20]) { }
        field(3; "Sub Sector Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Sector Code", "Sub Sector Code")
        {
            Clustered = true;
        }
        key(key2; "Sub Sector Name") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sub Sector Code", "Sub Sector Name") { }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90087 "Economic Sub-subsector"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sector Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Sub Sector Code"; Code[20]) { }
        field(3; "Sub-Subsector Code"; Code[20]) { }
        field(4; "Sub-Subsector Description"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Sector Code", "Sub Sector Code", "Sub-Subsector Code")
        {
            Clustered = true;
        }
        key(key2; "Sub-Subsector Description") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Sub-Subsector Code", "Sub-Subsector Description") { }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90088 "Mobile Transaction Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Transaction Code"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[100]) { }
        field(3; "Charge Code"; code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(4; "Balancing Account No"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(5; "Minimum Amount"; Decimal) { }
        field(6; "Maximum Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Transaction Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90089 "Employer Stations"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employer Code"; Code[20]) { }
        field(2; "Station Code"; Code[20]) { }
        field(3; "Station Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Employer Code", "Station Code")
        {
            Clustered = true;
        }
        key(key2; "Station Code", "Station Name") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Station Code", "Station Name") { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90090 CreditCueTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Integer)
        {

            DataClassification = ToBeClassified;
        }
        field(2; "Gross Disbursals"; decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Application"."Approved Amount");

        }
        field(3; "Placements Portfolio"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Fixed Deposit Register".Amount where(Terminated = const(false)));
        }
        field(4; "Collateral in Store"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Collateral Register"."Caollateral Value" where(Status = filter(<> Collected)));
        }
        field(5; "User ID"; code[100]) { }
        field(6; "Requests to Approve"; Integer)
        {
            FieldClass = flowfield;
            CalcFormula = count("Approval Entry" where(Status = const(Created), "Approver ID" = field("User ID")));
            Editable = false;
        }
        field(7; "Running Standing Orders"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Standing Order" where(Running = const(true)));
        }
        field(8; "Total Members"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count(Members);
        }
        field(9; "Pending Member Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Member Application" where(Processed = const(false)));
        }
        field(10; "Mobile Transactions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Mobile Transsactions".Amount);
        }
        field(11; "ATM Transactions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("ATM Transactions".Amount);
        }
        field(12; "ATM Applications"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("ATM Application");
        }
        field(13; "Treasury Transactions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("FOSA Transactions" where(Posted = const(false)));
        }
    }

    keys
    {
        key(PK; PrimaryKey, "User ID")
        {
            Clustered = true;
        }
    }
}

table 90091 "Loan Batch Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Loan Batches Lookup";
    DrillDownPageId = "Loan Batches Lookup";
    fields
    {
        field(1; "Document No"; code[20])
        {
            editable = false;

        }
        field(2; "Posting Date"; Date) { }
        field(3; "Description"; Text[50]) { }
        field(4; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(5; Posted; Boolean) { Editable = false; }
        field(6; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(7; "Posted By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(8; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(9; "Created On"; DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Loan Batch Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Loan Batch Nos", Today, true);
        "Posting Date" := Today;
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        Description := 'Loan Posting batch ' + "Document No";
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90092 "Loan Batch Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Batch No"; Code[20]) { }
        field(2; "Loan No"; Code[20]) { }
        field(3; "Product Description"; text[50]) { }
        field(4; "Principle Amount"; Decimal) { }
        field(5; "Applied Amount"; Decimal) { }
        field(6; "Total Recoveries"; Decimal) { }
        field(7; "Net Amount"; Decimal) { }
        field(8; "Insurance Amount"; Decimal) { }
        field(9; Posted; Boolean) { }
    }

    keys
    {
        key(Key1; "Batch No", "Loan No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        LoanApplication: record "Loan Application";
    begin
        if LoanApplication.get("Loan No") then begin
            LoanApplication."Loan Batch No." := '';
            LoanApplication.Modify();
        end;
    end;

    trigger OnRename()
    begin

    end;

}
table 90093 "External Banks"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "External Banks";
    LookupPageId = "External Banks";
    fields
    {
        field(1; "Bank Code"; Code[20]) { }
        field(2; "Bank Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Bank Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90094 "External Bank Branches"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Bank Code"; Code[20]) { }
        field(2; "Branch Code"; Code[20]) { }
        field(3; "Branch Name"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Bank Code", "Branch Code")
        {
            Clustered = true;
        }
        key(Key2; "Branch Code", "Branch Name") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Branch Code", "Branch Name") { }
    }
    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90095 "Uncleared Effects"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Held Amounts";
    DrillDownPageId = "Held Amounts";
    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20]) { }
        field(3; "Member Name"; text[100]) { }
        field(4; "Document No"; Code[20]) { }
        field(5; "Amount"; decimal) { }
        field(6; "Created By"; Code[100]) { }
        field(7; "Created On"; DateTime) { }
        field(8; "Account No"; Code[20]) { }
        field(9; Cleared; Boolean) { }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90096 "Dividend Progression"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Dividend Progression";
    LookupPageId = "Dividend Progression";
    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Entry No"; Integer) { }
        field(3; "Member No"; Code[20]) { }
        field(4; "Account No"; Code[20]) { }
        field(5; "Start Date"; Date) { }
        field(6; "Closing Date"; Date) { }
        field(7; "Net Change"; Decimal)
        {
            trigger OnValidate()
            var
                DetVendorLedger: Record "Detailed Vendor Ledg. Entry";
                DividendHeader: Record "Dividend Header";
            begin
                DividendHeader.Get("Document No");
                if "Rate Type" = "Rate Type"::"Pro-rated" then begin
                    DetVendorLedger.Reset();
                    DetVendorLedger.SetRange("Vendor No.", "Account No");
                    DetVendorLedger.SetRange("Posting Date", "Start Date", "Closing Date");
                    if DetVendorLedger.FindSet() then begin
                        DetVendorLedger.CalcSums(Amount);
                        "Net Change" := -1 * DetVendorLedger.Amount;
                    end;
                    case Date2DMY(NormalDate("Closing Date"), 2) of
                        12:
                            begin
                                if Date2DMY(NormalDate("Closing Date"), 3) < Date2DMY(DividendHeader."Start Date", 3) then
                                    Ratio := 1
                                else
                                    Ratio := 0;
                            end;
                        1:
                            Ratio := (11 / 12);
                        2:
                            Ratio := (10 / 12);
                        3:
                            Ratio := (9 / 12);
                        4:
                            Ratio := (8 / 12);
                        5:
                            Ratio := (7 / 12);
                        6:
                            Ratio := (6 / 12);
                        7:
                            Ratio := (5 / 12);
                        8:
                            Ratio := (4 / 12);
                        9:
                            Ratio := (3 / 12);
                        10:
                            Ratio := (2 / 12);
                        11:
                            Ratio := (1 / 12);
                    end;
                end else begin
                    DetVendorLedger.Reset();
                    DetVendorLedger.SetRange("Vendor No.", "Account No");
                    DetVendorLedger.SetFilter("Posting Date", '..%1', "Closing Date");
                    if DetVendorLedger.FindSet() then begin
                        DetVendorLedger.CalcSums(Amount);
                        "Net Change" := -1 * DetVendorLedger.Amount;
                    end;
                    Ratio := 1;
                end;
                "Amount Earned" := Rate * Ratio * "Net Change" * 0.01;
            end;
        }
        field(8; Ratio; Decimal) { }
        field(9; "Amount Earned"; Decimal) { }
        field(10; Rate; Decimal) { }
        field(11; "Rate Type"; Option)
        {
            OptionMembers = "Straight Line","Pro-rated";
        }
    }

    keys
    {
        key(Key1; "Document No", "Entry No")
        {
            Clustered = true;
        }
        key(Key2; "Account No", "Member No") { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90097 "Guarantor Header"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Guarantor Mgt. Lookup";
    DrillDownPageId = "Guarantor Mgt. Lookup";
    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;
        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
            begin
                Members.get("Member No");
                "Member Name" := Members."Full Name";
            end;
        }
        field(3; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(6; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(7; Processed; Boolean)
        {
            Editable = false;
        }
        field(8; "Loan No"; Code[20])
        {
            TableRelation = "Loan Application" where("Member No." = field("Member No"));
        }
        field(9; "Posting Date"; Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Guarantor Nos");
        "Document No" := NoSeries.GetNextNo(SaccoSetup."Guarantor Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90098 "Loan Recovery Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Member No"; code[20]) { }
        field(3; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Member Deposits"; Decimal)
        {
            Editable = false;
        }
        field(5; "Outstanding Guarantee"; Decimal)
        {
            Editable = false;
        }
        field(6; "Recovery Amount"; Decimal) { }
        field(7; "Recovery Type"; Option)
        {
            OptionMembers = " ",Deposits,"Guarantor Liability Loan";
        }
        field(8; "Product Code"; code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Loan Account"));
        }
    }

    keys
    {
        key(Key1; "Document No", "Member No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90099 "Dividend Allocations"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Dividend Code"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; code[20]) { }
        field(3; "Account No"; Code[20]) { }
        field(4; "Start Date"; Date) { }
        field(5; "End Date"; Date) { }
        field(6; "Gross Amount"; Decimal) { }
        field(7; Charges; Decimal) { }
        field(8; "Net Amount"; Decimal) { }
        field(9; "Allocation Type"; Option)
        {
            OptionMembers = FOSA,"Bank Transfer","Mobile Money",Capitalize,"Loan Repayment";
        }
        field(10; "Capitalize to Account"; Code[20])
        {
            TableRelation = Vendor."No." where("Member No." = field("Member No"));
            trigger OnValidate()
            begin
                Rec.TestField("Allocation Type", rec."Allocation Type"::Capitalize);
            end;
        }
        field(11; "Bank Code"; Code[20])
        {
            TableRelation = "External Banks";
            trigger OnValidate()
            begin
                Rec.TestField("Allocation Type", Rec."Allocation Type"::"Bank Transfer");
            end;
        }
        field(12; "Bank Name"; Text[250])
        {
            Editable = false;
        }
        field(13; "Branch Code"; Code[20])
        {
            TableRelation = "External Bank Branches"."Branch Code" where("Bank Code" = field("Bank Code"));
        }
        field(14; "Branch Name"; Text[100])
        {
            Editable = false;
        }
        field(15; "Bank Account No"; Code[100])
        {
            trigger OnValidate()
            begin
                Rec.TestField("Bank Code");
                Rec.TestField("Branch Code");
            end;
        }
        field(16; Published; Boolean)
        {
            Editable = false;
        }
        field(17; "Pubished On"; DateTime) { Editable = false; }
        field(18; "Expiry Date"; Date) { Editable = false; }
        field(19; "Allocation Date"; DateTime) { }
        field(20; "Mobile Phone No"; code[30])
        {
            trigger OnValidate()
            begin
                Rec.TestField("Allocation Type", Rec."Allocation Type"::"Mobile Money");
                "Bank Code" := '';
                "Bank Name" := '';
                "Branch Code" := '';
                "Branch Name" := '';
                "Bank Account No" := '';
            end;
        }
        field(21; "Member Allocated"; Boolean) { }
        field(22; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(23; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(24; "Allocated By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(25; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(26; "Created By"; code[100])
        {
            Editable = false;
        }
        field(27; "Loan No"; Code[20])
        {
            TableRelation = "Loan Application" where("Member No." = field("Member No"), "Loan Balance" = filter('>0'));
        }
        field(28; Submitted; Boolean)
        {
            Editable = false;
        }
        field(29; Posted; Boolean) { }
        field(30; "Posted On"; datetime) { }
    }

    keys
    {
        key(Key1; "Dividend Code", "Member No", "Account No")
        {
            Clustered = true;
        }
        key(Key2; "Allocation Type", "Allocation Date") { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90100 "Document Uploads"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Parent Type"; Option)
        {
            OptionMembers = "Member Application","Loan Application";
        }
        field(3; "Parent No"; Code[20]) { }
        field(4; "Document Type"; Code[100]) { }
        field(5; "Document No"; Code[100]) { }
        field(6; "URL"; Text[250])
        {
            ExtendedDatatype = URL;
        }
        field(7; "Added On"; DateTime) { }
        field(8; "Added By"; code[100])
        {

        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Added By" := UserId;
        "Added On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90101 "Online Guarantor Sub."
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Guarantor No"; code[20]) { }
        field(3; "Replace With"; Code[20])
        {
            trigger OnValidate()
            begin
                //send sms
            end;
        }
        field(4; "Replace With Name"; Code[100]) { }
        field(5; "Amount"; Decimal) { }
        field(6; "Loan Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Guarantor Lines"."Loan Balance" where("Member No" = field("Guarantor No"), "Document No" = field("Document No")));
            Editable = false;
        }
        field(7; Status; Option)
        {
            OptionMembers = New,Accepted,Rejected;
            OptionCaption = 'New,Accepted,Rejected';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No", "Guarantor No", "Replace With")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90102 "Cheque Book Types"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Cheque Book Types";
    LookupPageId = "Cheque Book Types";
    fields
    {
        field(1; "Cheque Book Type"; Code[10]) { }
        field(2; "Description"; Text[30]) { }
        field(3; "Clearing Charge Code"; Code[10])
        {
            TableRelation = "Sacco Transaction Types";
        }
        field(4; "Clearing Bank Code"; Code[10])
        {
            TableRelation = "Bank Account" where("Account Type" = const(main));
        }
        field(5; "Cheque Books"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Cheque Books" where("Cheque Book Type" = field("Cheque Book Type")));
        }
        field(6; "Leaf Charge"; code[20])
        {
            TableRelation = "Sacco Transaction Types";
        }
    }

    keys
    {
        key(Key1; "Cheque Book Type")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90103 "Cheque Books"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cheque Book Type"; Code[20]) { }
        field(2; "Serial No"; Code[20]) { }
        field(3; "Member No"; Code[20]) { }
        field(4; "Member Name"; Text[100]) { }
        field(5; "Account No"; Code[20]) { }
        field(6; "Account Name"; Text[100]) { }
        field(7; "Status"; Option)
        {
            OptionMembers = asa,asaa;
        }
        field(8; "Applied On"; DateTime) { }
        field(9; "Collected On"; DateTime) { }
        field(10; "Drawn"; Integer) { }
    }

    keys
    {
        key(Key1; "Cheque Book Type", "Serial No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90104 "Cheque Book Applications"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Application No"; Code[20])
        {
        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
            begin
                "Account Name" := '';
                "Account No" := '';
                Members.Get("Member No");
                "Member Name" := Members."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Application Date"; Date) { }
        field(5; "Cheque Book Type"; Code[20])
        {
            TableRelation = "Cheque Book Types";
            trigger OnValidate()
            var
                ChequeBookType: Record "Cheque Book Types";
            begin
                ChequeBookType.get("Cheque Book Type");
                Validate("Charge Code", ChequeBookType."Leaf Charge");
                Validate("No. of Leafs", 20);
            end;
        }
        field(6; "Serial No"; Code[20]) { }
        field(7; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(8; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(9; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(10; "Processed"; Boolean)
        {
            Editable = false;
        }
        field(11; "Processed On"; DateTime)
        {
            Editable = false;
        }
        field(12; "Account No"; Code[20])
        {
            TableRelation = Vendor where("Member No." = field("Member No"), "Cheque Book Allowed" = const(true));
        }
        field(13; "Account Name"; Text[150])
        {
            Editable = false;
        }
        field(14; "Collected By Name"; Text[150]) { }
        field(15; "Collected By ID No"; Code[20]) { }
        field(16; "Collected By Phone No"; Code[20]) { }
        field(17; "Collected On"; Date) { }
        field(18; "Collected At"; Time) { }
        field(19; "No. of Leafs"; Integer)
        {
            trigger OnValidate()
            var
                JournalMgt: Codeunit "Journal Management";
            begin
                "Charge Amount" := "No. of Leafs" * JournalMgt.GetTransactionCharges("Charge Code", 9999999);
            end;
        }
        field(20; "Charge Code"; Code[20])
        {
            Editable = false;
        }
        field(21; "Charge Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
            Clustered = true;
        }
    }

    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Cheque Book App. Nos");
        "Application No" := NoSeries.GetNextNo(SaccoSetup."Cheque Book App. Nos", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90105 "Cheque Book Transactions"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20]) { }
        field(2; "Serial No"; Code[20]) { }
        field(3; "Cheque Type"; Code[20]) { }
        field(4; "Member No"; Code[20]) { }
        field(5; "Member Name"; Text[100]) { }
        field(6; "Account No"; Code[20]) { }
        field(7; "Account Name"; Text[100]) { }
        field(8; "Cheque No"; Code[20]) { }
        field(9; "Amount"; Decimal) { }
        field(10; "Posting Date"; Date) { }
        field(11; "Created On"; DateTime) { }
        field(12; "Created By"; Code[100]) { }
        field(13; "Posted"; Boolean) { }
        field(14; "Posted On"; DateTime) { }
        field(15; "Current Balance"; Decimal) { }
        field(16; "Charge Code"; Code[20]) { }
        field(17; "Charge Amount"; Decimal) { }
        field(18; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90106 "Group & Company Members"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Source Code"; Code[20]) { }
        field(2; "National ID No"; Code[20]) { }
        field(3; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Type"; Option)
        {
            OptionMembers = Signatory,Directors;
        }
        field(5; "Designation"; text[100]) { }
        field(6; "Full Name"; Text[250]) { }
        field(7; "Phone No"; Code[20]) { }
        field(8; "Passport Image"; Blob)
        {
            Subtype = Bitmap;
        }
        field(9; "Signature"; Blob)
        {
            Subtype = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Source Code", "Entry No.", Type)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90107 "Inter Account Transfer"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Inter Acc. Transfers";
    DrillDownPageId = "Inter Acc. Transfers";
    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;

        }
        field(2; "Posting Date"; Date) { }
        field(3; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                Member.Get("Member No");
                "Source Name" := Member."Full Name";
                "Transfer From" := '';
            end;
        }
        field(4; "Transfer From"; Code[20])
        {
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                Vendor.get("Transfer From");
                Vendor.CalcFields(Balance, "Uncleared Effects");
                "Source Balance" := Vendor.Balance - Vendor."Uncleared Effects";
            end;

            trigger OnLookup()
            var
                Vendor: Record Vendor;
            begin
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No");
                Vendor.SetFilter("Account Class", '%1|%2', Vendor."Account Class"::Collections, Vendor."Account Class"::NWD);
                Vendor.SetRange("Fixed Deposit Account", false);
                IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Transfer From", Vendor."No.");
                END;
            end;
        }
        field(5; "Source Balance"; Decimal)
        {
            Editable = false;
        }
        field(6; "Charge Code"; code[20])
        {
            TableRelation = "Sacco Transaction Types";
            trigger OnValidate()
            var
                Integrations: Codeunit "Journal Management";
            begin
                "Charge Amount" := Integrations.GetTransactionCharges("Charge Code", Amount);
            end;
        }
        field(7; Amount; Decimal)
        {
            trigger OnValidate()
            begin
                Validate("Charge Code");
            end;
        }
        field(8; "Charge Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Destination Member"; code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                Member.Get("Destination Member");
                "Destination Name" := Member."Full Name";
                "Destination Account" := '';
            end;
        }
        field(10; "Destination Account"; Code[20])
        {
            trigger OnLookup()
            var
                Vendor: Record Vendor;
            begin
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Destination Member");
                Vendor.SetFilter("Account Class", '%1|%2', Vendor."Account Class"::Collections, Vendor."Account Class"::NWD);
                IF PAGE.RUNMODAL(0, Vendor) = ACTION::LookupOK THEN BEGIN
                    VALIDATE("Destination Account", Vendor."No.");
                END;
            end;
        }
        field(11; "Posting Description"; Text[50]) { }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "Created By"; code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(14; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(15; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(16; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(17; "Posted By"; code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(18; "Source Name"; Text[150])
        {
            Editable = false;
        }
        field(19; "Destination Name"; Text[150])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        Member: Record Members;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Inter Acc. Trans. Nos.");
        if "Document No" = '' then
            "Document No" := NoSeries.GetNextNo(SaccoSetup."Inter Acc. Trans. Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        "Posting Date" := Today;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90108 "Account Openning"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; code[20])
        {
            Editable = false;

        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                if Member.get("Member No") then
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Product Type"; code[20])
        {
            TableRelation = "Product Factory" where("Account Class" = filter(Collections | NWD));
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                ProductSetup.Get("Product Type");
                "Product Name" := ProductSetup.Name;
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No");
                Vendor.SetRange("Account Code", "Product Type");
                if Vendor.FindFirst() then
                    "Old Account No" := Vendor."No.";
                "Juniour Account" := ProductSetup."Juniour Account";
            end;
        }
        field(5; "Product Name"; Text[150])
        {
            Editable = false;
        }
        field(6; "Juniour Account"; Boolean)
        {
            Editable = false;
        }
        field(7; "Full Name"; Text[150]) { }
        field(8; "Date of Birth"; Date) { }
        field(9; "Birth Certificate No"; Code[20]) { }
        field(10; "Birth Notification No"; Code[100]) { }
        field(11; "Child Image"; Blob)
        {
            Subtype = Bitmap;
        }
        field(13; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(14; "Approval Status"; Option)
        {
            Editable = false;
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(15; Processed; Boolean)
        {
            Editable = false;
        }
        field(16; "Old Account No"; Code[20])
        {
            Editable = false;
        }
        field(17; "New Account No"; Code[20])
        {
            Editable = false;
        }
        field(18; "Created On"; DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";
        ProductSetup: Record "Product Factory";
        Member: Record Members;

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Acc. Opening Nos.");
        if "Document No" = '' then
            "Document No" := NoSeries.GetNextNo(SaccoSetup."Acc. Opening Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90109 "Bulk SMS Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;

        }
        field(2; "SMS Message"; Text[1000]) { }
        field(3; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(4; Sent; Boolean)
        {
            Editable = false;
        }
        field(5; "Created On"; DateTime)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Bulk SMS Nos.");
        if "Document No" = '' then
            "Document No" := NoSeries.GetNextNo(SaccoSetup."Bulk SMS Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90110 "Bulk SMS Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Full Name"; Text[100]) { }
        field(4; "Phone No"; Text[100]) { }
        field(5; Sent; Boolean) { }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90111 "Checkoff Variation Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
            begin
                if Members.Get("Member No") then
                    "Member Name" := Members."Full Name";
                PopulateCurrentSubscriptions();
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Effective Date"; Date)
        {

        }
        field(5; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(6; "Created By"; Code[100])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(7; Processed; Boolean)
        {
            Editable = false;
        }
        field(8; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    local procedure PopulateCurrentSubscriptions()
    var
        Products: Record "Product Factory";
        Subscriptions: Record "Member Subscriptions";
        CheckoffVariationLines: Record "Checkoff Variation Lines";
        Vendor: Record Vendor;
        LoanApplication: Record "Loan Application";
    begin
        CheckoffVariationLines.Reset();
        CheckoffVariationLines.SetRange("Document No", "Document No");
        if CheckoffVariationLines.FindSet() then
            CheckoffVariationLines.DeleteAll();
        LoanApplication.Reset();
        LoanApplication.SetFilter("Loan Balance", '>0');
        LoanApplication.SetRange("Member No.", "Member No");
        if LoanApplication.FindSet() then begin
            repeat
                CheckoffVariationLines.Init();
                CheckoffVariationLines."Document No" := "Document No";
                CheckoffVariationLines."Acount Code" := LoanApplication."Product Code";
                CheckoffVariationLines.Description := LoanApplication."Product Description";
                LoanApplication.CalcFields("Monthly Inistallment", "Monthly Principle");
                if LoanApplication."Rescheduled Installment" <> 0 then
                    CheckoffVariationLines."Current Contribution" := LoanApplication."Rescheduled Installment"
                else
                    if LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::Amortised then
                        CheckoffVariationLines."Current Contribution" := LoanApplication."Monthly Inistallment"
                    else
                        CheckoffVariationLines."Current Contribution" := LoanApplication."Monthly Principle";
                CheckoffVariationLines.Insert();
            until LoanApplication.Next() = 0;
        end;
        Subscriptions.Reset();
        Subscriptions.SetRange("Source Code", "Member No");
        if Subscriptions.FindSet() then begin
            repeat
                CheckoffVariationLines.Init();
                CheckoffVariationLines."Document No" := "Document No";
                CheckoffVariationLines."Acount Code" := Subscriptions."Account Type";
                CheckoffVariationLines.Description := Subscriptions."Account Name";
                CheckoffVariationLines."Current Contribution" := Subscriptions.Amount;
                Vendor.Reset();
                Vendor.SetRange("Member No.", "Member No");
                Vendor.SetRange("Account Code", Subscriptions."Account Type");
                if Vendor.FindSet() then begin
                    Vendor.CalcFields(Balance);
                    CheckoffVariationLines."Account Balance" := Vendor.Balance;
                end;
                CheckoffVariationLines.Insert();
            until Subscriptions.Next() = 0;
        end;
        Products.Reset();
        Products.SetFilter("Account Class", '%1|%2', Products."Account Class"::Collections, Products."Account Class"::NWD);
        if Products.FindSet() then begin
            repeat
                if CheckoffVariationLines.Get("Document No", Products.Code) = false then begin
                    CheckoffVariationLines.Init();
                    CheckoffVariationLines."Document No" := "Document No";
                    CheckoffVariationLines."Acount Code" := Products.Code;
                    CheckoffVariationLines.Description := Products.Name;
                    CheckoffVariationLines."Current Contribution" := 0;
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", "Member No");
                    Vendor.SetRange("Account Code", Subscriptions."Account Type");
                    if Vendor.FindSet() then begin
                        Vendor.CalcFields(Balance);
                        CheckoffVariationLines."Account Balance" := Vendor.Balance;
                    end;
                    CheckoffVariationLines.Insert();
                end;
            until Products.Next() = 0;
        end;
    end;

    var
        NoSeries: Codeunit NoSeriesManagement;
        SACCOSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SACCOSetup.Get();
        SACCOSetup.TestField("Checkoff Variation Nos.");
        if "Document No" = '' then
            "Document No" := NoSeries.GetNextNo(SACCOSetup."Checkoff Nos", Today, true);
        if GuiAllowed then
            "Portal Status" := "Portal Status"::Submitted;
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90112 "Checkoff Variation Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Acount Code"; Code[20]) { }
        field(3; Description; Text[100])
        {
            Editable = false;
        }
        field(4; "Current Contribution"; Decimal)
        {
            Editable = false;
        }
        field(5; "New Contribution"; Decimal)
        {
            trigger OnValidate()
            var
                ProductFactory: Record "Product Factory";
            begin
                if ProductFactory.Get("Acount Code") then begin
                    if ProductFactory."Product Type" = ProductFactory."Product Type"::"Loan Account" then begin
                        if "Current Contribution" > "New Contribution" then
                            Error('You Cannot Reduce the current contribution');
                    end;
                end;
            end;
        }
        field(6; "Account Balance"; Decimal) { }
        field(7; Modified; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No", "Acount Code")
        {
            Clustered = true;
        }
    }

    var

    trigger oninsert()
    var
        myInt: Integer;
    begin

    end;

    trigger OnModify()
    begin
        Modified := true;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90113 "Checkoff Advice"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Member No"; Code[20]) { }
        field(3; "Account No"; Code[20]) { }
        field(4; "Amount On"; Decimal) { }
        field(5; "Amount Off"; Decimal) { }
        field(6; "Current Balance"; Decimal) { }
        field(7; "Loan No"; Code[20]) { }
        field(8; "Product Type"; Code[20]) { }
        field(9; "Product Name"; Text[100]) { }
        field(10; "Advice Type"; Option)
        {
            OptionMembers = Adjustment,"New Loan","New Member",RMF,Stoppage;
        }
        field(11; "Advice Date"; Date) { }
        field(12; "Employer Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Members."Employer Code" where("Member No." = field("Member No")));
            TableRelation = "Employer Codes";
        }
        field(13; "Member Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Members."Full Name" where("Member No." = field("Member No")));
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90114 "Mobile Applications"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Editable = false;

        }
        field(2; "Member No"; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            var
                Members: Record Members;
                MobileMembers: Record "Mobile Members";
            begin
                if MobileMembers.Get("Member No") then begin
                    if MobileMembers."Member Status" = MobileMembers."Member Status"::Active then
                        Error('The Member is already registered and is active. Please Block the member on the Mobile Member list')
                    else
                        Reactivation := true;
                end;
                Members.Get("Member No");
                "Full Name" := Members."Full Name";
                "Phone No" := Members."Mobile Phone No.";
                "ID No" := Members."National ID No";
            end;
        }
        field(3; "Full Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Phone No"; Code[11])
        {
            Editable = false;
        }
        field(5; "FOSA Account"; Code[20])
        {
            TableRelation = Vendor where("Member No." = field("Member No"), "Account Class" = const(Collections));
        }
        field(6; "Approval Status"; Option)
        {
            OptionMembers = New,"Approval Pending",Approved;
            Editable = false;
        }
        field(8; Processed; Boolean)
        {
            Editable = false;
        }
        field(9; "Created By"; Code[100])
        {
            Editable = false;
            tablerelation = "User Setup";
        }
        field(10; "Created On"; DateTime)
        {
            Editable = false;
        }
        field(11; "Processed On"; DateTime)
        {
            Editable = false;
        }
        field(12; "Processed By"; Code[100])
        {
            Editable = false;
        }
        field(13; "ID No"; Code[20])
        {
            Editable = false;
        }
        field(14; Reactivation; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No")
        {
            Clustered = true;
        }
    }

    var
        NoSeries: Codeunit NoSeriesManagement;
        SaccoSetup: Record "Sacco Setup";

    trigger OnInsert()
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Mobile Application Nos.");
        if "Document No" = '' then
            "Document No" := NoSeries.GetNextNo(SaccoSetup."Mobile Application Nos.", Today, true);
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        TestField(Processed, false);
        TestField("Approval Status", "Approval Status"::New);
    end;

    trigger OnDelete()
    begin
        TestField(Processed, false);
        TestField("Approval Status", "Approval Status"::New);
    end;

    trigger OnRename()
    begin
        TestField(Processed, false);
        TestField("Approval Status", "Approval Status"::New);
    end;

}
table 90115 "Mobile Members"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Member No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Full Name"; Text[250]) { }
        field(4; "FOSA Account"; Code[20]) { }
        field(5; "Phone No"; Code[20]) { }
        field(6; "ID No"; Code[20]) { }
        field(7; "Activated On"; DateTime) { }
        field(8; "Activated By"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(9; "Last Reactivation Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = max("Mobile Member Ledger"."Posting Date" where("Member No" = field("Member No"), "Document Type" = const(Reactivation)));
            Editable = false;
        }
        field(10; "Member Status"; Option)
        {
            OptionMembers = Active,Blocked,Held;
        }
        field(11; "Mobile Ledger"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Mobile Member Ledger" where("Member No" = field("Member No")));
        }
    }

    keys
    {
        key(Key1; "Member No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90116 "Mobile Member Ledger"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Mobile Ledger";
    LookupPageId = "Mobile Ledger";
    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Document No"; Code[20]) { }
        field(3; "Posting Date"; Date) { }
        field(4; "Member No"; Code[20]) { }
        field(5; "Document Type"; Option)
        {
            OptionMembers = Activation,Blocking,Reactivation;
        }
        field(6; "User ID"; Code[100]) { }
        field(7; "Posting Time"; Time) { }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
        key(key2; "Document No", "Member No", "Document Type") { }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90117 "Customer Feedback"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Category Code"; Code[20]) { }
        field(3; Subject; Text[250]) { }
        field(4; Details; Text[250]) { }
        field(5; "Created On"; DateTime) { }
        field(6; Status; Option)
        {
            OptionMembers = New,Submited,Resolved;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90118 "Batch Delete"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Batch No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; "Batch No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90119 "Online Loan Application"
{
    DataClassification = ToBeClassified;
    DataCaptionFields = "Application No", "Member Name", "Product Description", "Approved Amount", "Approval Status";
    LookupPageId = "Loans Lookup";
    DrillDownPageId = "Loans Lookup";
    fields
    {
        field(1; "Application No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                if Members.get("Member No.") then begin
                    "Member Name" := Members."Full Name";
                    "Global Dimension 1 Code" := Members."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Members."Global Dimension 2 Code";
                end;
                LoansManagement.PopulateOnlineAppraisalParameters(Rec);
                "Share Capital" := LoansManagement.GetMemberShares("Member No.");
                Deposits := LoansManagement.GetMemberDeposits("Member No.");
                "Total Loans" := LoansManagement.GetMemberLoans("Member No.");
                Validate("New Monthly Installment");
            end;
        }
        field(3; "Member Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Product Code"; Code[20])
        {
            TableRelation = "Product Factory" where("Product Type" = const("Loan Account"), Status = const(Active));
            trigger OnValidate()
            var
                MemberDeposits: Decimal;
                Member: Record Members;
                LoansManagement: Codeunit "Loans Management";
            begin
                Validate("New Monthly Installment");
                ProductSetup.Get("Product Code");
                Rec.TestField("Member No.");
                Member.Get(Rec."Member No.");
                MemberDeposits := LoansManagement.GetMemberDeposits(Member."Member No.");
                if ProductSetup."Appraise with 0 Deposits" = false then begin
                    if MemberDeposits <= 0 then
                        Error('You Cannot Appraise %1 With %2 Deposits', ProductSetup.Name, MemberDeposits);
                end;
                if MemberDeposits < ProductSetup."Minimum Deposit Balance" then
                    Error('You Cannot Appraise %1 With %2 Deposits', ProductSetup.Name, MemberDeposits);
                Rec."Product Description" := ProductSetup.Name;
                Rec."Interest Rate" := ProductSetup."Interest Rate";
                Rec."Interest Repayment Method" := ProductSetup."Interest Repayment Method";
                Rec."Grace Period" := ProductSetup."Grace Period";
                Rec."Posting Date" := Rec."Application Date";
                Rec."Rate Type" := ProductSetup."Rate Type";
                Rec.Installments := ProductSetup."Ordinary Default Intallments";
                Rec."Mode of Disbursement" := Rec."Mode of Disbursement"::FOSA;
                Rec."Disbursement Account" := LoansManagement.GetFOSAAccount(Rec."Member No.");
                Rec."Interest Repayment Method" := ProductSetup."Interest Repayment Method";
                Rec.Validate(Installments);
                "Maximum Repayment Period" := ProductSetup."Maximum Installments";
                LoansManagement.PopulateOnlineAppraisalParameters(Rec);
            end;
        }
        field(5; "Product Description"; Text[50])
        {
            Editable = false;
        }
        field(6; "Applied Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                LoansManagement.ValidateOnlineAppraisal(Rec);
                Validate("Insurance Amount");
                Validate("New Monthly Installment");
            end;
        }
        field(7; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate("Insurance Amount");
            end;
        }
        field(8; "Interest Rate"; Decimal)
        {
            Editable = false;
            DecimalPlaces = 5;
        }
        field(9; "Interest Repayment Method"; Option)
        {
            OptionMembers = "Straight Line","Reducing Balance","Amortised";

        }
        field(10; Installments; Integer)
        {
            trigger OnValidate()
            var
                InterestBands: Record "Product Interest Bands";
            begin
                InterestBands.Reset();
                InterestBands.SetRange(Active, true);
                InterestBands.SetRange("Product Code", "Product Code");
                InterestBands.SetFilter("Min Installments", '<=%1', Installments);
                InterestBands.SetFilter("Max Installments", '>=%1', Installments);
                if InterestBands.FindFirst() then
                    "Interest Rate" := InterestBands."Interest Rate"
                else
                    Error('The Interest band for %1 %2 does not exist!', "Product Description", Installments);
            end;
        }
        field(11; "Repayment Frequency"; Option)
        {
            OptionMembers = "Monthly","Quarterly","Semi-Annualy","Annualy";
        }
        field(12; "Application Date"; Date) { }
        field(13; "Repayment Start Date"; Date)
        {
            Editable = false;
        }
        field(14; "Repayment End Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                LoansManagement: codeunit "Loans Management";
            begin
                "Repayment Start Date" := LoansManagement.GetRepaymentOnlineStartDate(Rec);
                "Repayment End Date" := CalcDate(Format(Installments) + 'M', "Repayment Start Date");
            end;
        }
        field(15; "Approval Status"; Option)
        {
            OptionMembers = "New","Approval Pending","Approved";
        }
        field(16; "Mode of Disbursement"; Option)
        {
            OptionMembers = "FOSA","Bank";
        }
        field(17; "Disbursement Account"; Code[20])
        {
            TableRelation = if ("Mode of Disbursement" = const(FOSA)) Vendor where("Member No." = field("Member No."), "Account Type" = const("Sacco"))
            else
            if ("Mode of Disbursement" = const(Bank)) "Bank Account";
        }
        field(18; "Posting Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            var
                EndDate: Date;
            begin
                if "Posting Date" <> 0D then
                    EndDate := CalcDate('CM', "Posting Date");
                Validate("Repayment End Date");
                "Prorated Days" := EndDate - "Posting Date";
            end;
        }
        field(19; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(20; "Created On"; DateTime) { Editable = false; }
        field(21; Posted; Boolean) { Editable = false; }
        field(22; "Grace Period"; DateFormula)
        {
            Editable = false;
        }
        field(23; "Principle Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Principle Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(24; "Interest Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Interest Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(25; "Total Repayment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Schedule"."Monthly Repayment" WHERE("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(26; "Loan Account"; code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(27; "Billing Account"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(28; Charges; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Charges".Rate where("Loan No." = field("Application No")));
        }
        field(29; "Posted On"; DateTime)
        {
            Editable = false;
        }
        field(30; "Total Securities"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Online Guarantor Requests"."Amount Accepted" where("Loan No" = field("Application No"), Status = const(Accepted)));
        }
        field(31; "Accrued Interest"; decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Loan Interest Accrual".Amount where("Loan No." = field("Application No"), "Entry Type" = const("Interest Accrual")));
        }
        field(32; "Sales Person"; code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            trigger OnValidate()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                if SalesPerson.get("Sales Person") then
                    "Sales Person Name" := SalesPerson.Name;
            end;
        }
        field(33; "Sales Person Name"; Text[150])
        {
            Editable = false;
        }
        field(34; "Loan Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
        }
        field(35; "Principle Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Loan Disbursal" | "Principle Paid")));
        }
        field(36; "Interest Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Interest Due" | "Interest Paid")));
        }
        field(37; "Penalty Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Penalty Paid" | "Penalty Due")));
        }
        field(38; "Rate Type"; Option)
        {
            OptionMembers = "Per-Annum","Per Month","Fixed";
            Editable = false;
        }
        field(39; "Loan Classification"; Option)
        {
            OptionMembers = Performing,Watch,Substandard,Doubtfull,Loss;
            Editable = false;
        }
        field(40; "Defaulted Days"; Integer)
        {
            Editable = false;
        }
        field(41; "Principle Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Principle Paid")));
        }
        field(42; "Interest Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Interest Paid")));
        }
        field(43; "Penalty Paid"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = CONST("Penalty Paid")));
        }
        field(44; Closed; Boolean)
        {
            Editable = false;
        }
        field(45; "Global Dimension 1 Code"; code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Editable = false;
        }
        field(46; "Global Dimension 2 Code"; code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Editable = false;
        }
        field(47; "Total Interest Due"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Interest Due")));
        }
        field(48; "Total Penalty Due"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Posting Date" = field("Date Filter"), "Vendor No." = field("Loan Account"), "Loan No." = field("Application No"), "Transaction Type" = filter("Penalty Due")));
        }
        field(49; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50; "Cheque No."; code[30]) { }
        field(51; "Freeze Penalty"; Boolean) { }
        field(52; "Freeze Interest"; Boolean) { }
        field(53; Disbursed; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Detailed Vendor Ledg. Entry" where("Document No." = field("Application No"), "Vendor No." = field("Loan Account"), "Transaction Type" = const("Loan Disbursal")));
        }
        field(54; "Monthly Inistallment"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = max("Loan Schedule"."Monthly Repayment" where("Loan No." = field("Application No"), "Expected Date" = field("Date Filter")));
        }
        field(55; Status; Option)
        {
            Editable = false;
            OptionMembers = Application,Appraisal,Disbursed,Rejected,Reversed;
        }
        field(56; "Share Capital"; Decimal) { Editable = false; }
        Field(57; Deposits; Decimal) { Editable = false; }
        field(58; "Total Loans"; Decimal) { Editable = false; }
        field(59; "Sector Code"; Code[20])
        {
            TableRelation = "Economic Sectors";
        }
        field(60; "Sub Sector Code"; Code[20])
        {
            TableRelation = "Economic Subsectors"."Sub Sector Code" where("Sector Code" = field("Sector Code"));
        }
        field(61; "Sub-Susector Code"; Code[20])
        {
            TableRelation = "Economic Sub-subsector"."Sub-Subsector Code" where("Sector Code" = field("Sector Code"), "Sub Sector Code" = field("Sub Sector Code"));
        }
        field(62; Witness; Code[20])
        {
            TableRelation = Members;
            trigger OnValidate()
            begin
                LoansManagement.CheckOkToWitness(Witness, "Application No");
            end;
        }
        field(63; "Loan Batch No."; Code[20]) { }
        field(64; "Prorated Days"; Integer) { }
        field(65; "Prorated Interest"; Decimal) { }
        field(66; "Insurance Amount"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            var
                LoanProduct: Record "Product Factory";
            begin
                if LoanProduct.Get("Product Code") then begin
                    if "Approved Amount" = 0 then begin
                        if "Applied Amount" > LoanProduct."Insurance Factor" then
                            "Insurance Amount" := ("Applied Amount" - LoanProduct."Insurance Factor") * LoanProduct."Insurance Rate" * 0.01
                        else
                            "Insurance Amount" := 0;
                    end else begin
                        if "Approved Amount" > LoanProduct."Insurance Factor" then
                            "Insurance Amount" := ("Approved Amount" - LoanProduct."Insurance Factor") * LoanProduct."Insurance Rate" * 0.01
                        else
                            "Insurance Amount" := 0;
                    end;
                end ELSE
                    "Insurance Amount" := 0;
            end;

        }
        field(67; "Recovery Mode"; Option)
        {
            OptionMembers = Checkoff,"Interna STO","External STO";
        }
        field(68; "Recommended Amount"; Decimal)
        {
            Editable = false;
        }
        field(69; "New Monthly Installment"; Decimal)
        {

            trigger OnValidate()
            begin
                if xrec."New Monthly Installment" < LoansManagement.PopulateMinimumContribution("Application No") then
                    "New Monthly Installment" := LoansManagement.PopulateMinimumContribution("Application No");
            end;
        }
        field(70; "Pay to Bank Code"; Code[20])
        {
            TableRelation = "External Banks";
        }
        field(71; "Pay to Branch Code"; Code[20])
        {
            TableRelation = "External Bank Branches"."Branch Code" where("Bank Code" = field("Pay to Bank Code"));
        }
        field(72; "Pay to Account No"; Code[50]) { }
        field(73; "Pay to Account Name"; Text[100]) { }
        field(75; "Appraisal Commited"; Boolean)
        {
            Editable = false;
        }
        field(76; Approvals; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Approval Entry" where("Table ID" = const(90015), "Document No." = field("Application No")));
            trigger OnLookup()
            var
                ApprovalEntry: Record "Approval Entry";
                ApprovalEntryPage: Page "Approval Entries";
            begin
                Clear(ApprovalEntryPage);
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", 90015);
                ApprovalEntry.SetRange("Document No.", "Application No");
                if ApprovalEntry.FindSet() then begin
                    ApprovalEntryPage.SetTableView(ApprovalEntry);
                    ApprovalEntryPage.RunModal();
                end;
            end;
        }
        field(77; "Net Change-Principal"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount where("Vendor No." = field("Loan Account"),
            "Transaction Type" = filter("Loan Disbursal" | "Principle Paid"),
            "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(78; "Total Arrears"; Decimal)
        {
            Editable = false;
        }
        field(79; "Principle Arrears"; Decimal)
        {
            Editable = false;
        }
        field(80; "Interest Arrears"; Decimal)
        {
            Editable = false;
        }
        field(81; "Defaulted Installments"; Integer) { Editable = false; }
        field(82; "Portal Status"; Option)
        {
            OptionMembers = New,Submitted,Processing;
        }
        field(83; "Source Type"; Option)
        {
            OptionMembers = CoreBanking,Channels;
        }
        field(84; "Rejection Remarks"; Text[250]) { }
        field(85; "Total Collateral"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Securities".Guarantee where("Loan No" = field("Application No")));
            Editable = false;
        }
        field(86; "Self Guarantee"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Guarantees"."Guaranteed Amount" where("Loan No" = field("Application No"), "Member No" = field("Member No.")));
        }
        field(87; "Monthly Principle"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = max("Loan Schedule"."Principle Repayment" where("Loan No." = field("Application No")));
            Editable = false;
        }
        field(88; Rescheduled; Boolean) { }
        field(89; "Rescheduled Installment"; Decimal) { }
        field(90; "Maximum Repayment Period"; Integer)
        {
            Editable = false;
        }
        field(91; "Last Interest Charge"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = max("Detailed Vendor Ledg. Entry"."Posting Date" WHERE("Vendor No." = field("Loan Account"), "Transaction Type" = const("Interest Due"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
        field(92; "Total Recoveries"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Recoveries".Amount where("Loan No" = field("Application No")));
            Editable = false;
        }
        field(93; "Submitted On"; DateTime) { }
        field(94; "Disbursements"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = field("Loan Account"), "Transaction Type" = const("Loan Disbursal"), "Loan No." = field("Application No"), "Posting Date" = field("Date Filter")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Application No")
        {
            Clustered = true;
        }
        key(Key2; "Product Code", "Member No.", "Member Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application No", "Member No.", "Member Name", "Product Code", "Product Description") { }
    }
    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        Members: Record Members;
        ProductSetup: Record "Product Factory";
        ProductCharges: Record "Product Charges";
        LoanCharges: Record "Loan Charges";
        LoansManagement: Codeunit "Loans Management";

    trigger OnInsert()
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("Loan Application Nos.");
        if "Application No" = '' then begin
            "Application No" := NoSeries.GetNextNo(SaccoSetup."Online Loan Nos.", Today, true);
            "Application Date" := Today;
            "Posting Date" := "Application Date";
        end;
        Validate("Posting Date");
        "Created By" := UserId;
        "Created On" := CurrentDateTime;
        if CurrentClientType = CurrentClientType::SOAP then begin
            "Source Type" := "Source Type"::Channels;
            "Sales Person" := 'PORTAL';
            "Sales Person Name" := 'PORTAL';
        end;
    end;

    trigger OnModify()
    begin
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}
table 90120 "Loan FOSA Salaries"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Document No"; Code[20]) { }
        field(3; "Amount Earned"; Decimal) { }
        field(4; "Recoveries"; Decimal) { }
        field(5; "Net Salary"; Decimal) { }
        field(6; "Posting Date"; Date) { }
    }

    keys
    {
        key(Key1; "Loan No", "Document No")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}

table 90121 "Loan Recovey Accounts"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Loan Recovery Accounts";
    DrillDownPageId = "Loan Recovery Accounts";
    fields
    {
        field(1; "Document No"; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Account No"; Code[20])
        {
            Editable = false;
        }
        field(3; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Current Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; "Recovery Amount"; Decimal) { }
    }

    keys
    {
        key(Key1; "Document No", "Account No")
        {
            Clustered = true;
        }
    }

    var
        LoanRecovery: Record "Loan Recovery Header";

    trigger OnInsert()
    begin
        if LoanRecovery.Get("Document No") then begin
            LoanRecovery.CalcFields("Guarantor Deposit Recovery", "Guarantor Liability Recovery");
            if LoanRecovery."Guarantor Deposit Recovery" + LoanRecovery."Guarantor Liability Recovery" > 0 then
                Error('You Cannot combine Member Recovery and Guarantor Recovery');
        end;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}