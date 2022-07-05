page 90000 "Sacco Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member Application Nos."; Rec."Member Application Nos.") { }
                field("Member Nos."; Rec."Member Nos.") { }
                field("Loan Application Nos."; Rec."Loan Application Nos.") { }
                field("Loan Nos."; Rec."Loan Nos.") { }
                field("Receipt Nos."; Rec."Receipt Nos.") { }
                field("FD Nos."; Rec."FD Nos.") { }
                field("Collateral Application Nos."; Rec."Collateral Application Nos.") { }
                field("Loan Repayment Nos."; Rec."Loan Repayment Nos.") { }
                field("Maintenance Nos"; Rec."Maintenance Nos") { }
                field("Member Editing Nos"; Rec."Member Editing Nos") { }
                field("Payment Nos"; Rec."Payment Nos") { }
                field("JV Nos"; Rec."JV Nos") { }
                field("Calculator Nos"; Rec."Calculator Nos") { }
                field("Cheque Deposit Nos"; Rec."Cheque Deposit Nos") { }
                field("Standing Order Nos"; Rec."Standing Order Nos") { }
                field("FOSA Nos"; rec."FOSA Nos") { }
                field("Teller Transaction Nos"; Rec."Teller Transaction Nos") { }
                field("Member Exit Nos"; Rec."Member Exit Nos") { }
                field("Guarantor Nos"; Rec."Guarantor Nos") { }
                field("Checkoff Nos"; Rec."Checkoff Nos") { }
                field("ATM Application Nos"; Rec."ATM Application Nos") { }
                field("Dividend Nos"; Rec."Dividend Nos") { }
                field("Member Reactivation Nos"; Rec."Member Reactivation Nos") { }
                field("Cash Deposit Charges"; Rec."Cash Deposit Charges") { }
                field("Cash Withdrawal Charges"; Rec."Cash Withdrawal Charges") { }
                field("Loan Batch Nos"; rec."Loan Batch Nos") { }
                field("Member Exits Control"; Rec."Member Exits Control") { }
                field("Defaulter Notice Nos"; Rec."Defaulter Notice Nos") { }
                field("Loan Recovery Nos"; rec."Loan Recovery Nos") { }
                field("Cheque Book App. Nos"; Rec."Cheque Book App. Nos") { }
                field("Cheque Book Nos."; Rec."Cheque Book Nos.") { }
                field("Inter Acc. Trans. Nos."; Rec."Inter Acc. Trans. Nos.") { }
                field("Acc. Opening Nos."; Rec."Acc. Opening Nos.") { }
                field("Guarantor Notice Charge"; Rec."Guarantor Notice Charge") { }
                field("Guarantor Notice Inc. Acc."; Rec."Guarantor Notice Inc. Acc.") { }
                field("Bulk SMS Nos."; Rec."Bulk SMS Nos.") { }
                field("Guarantor Multiplier"; "Guarantor Multiplier") { }
                field("Checkoff Variation Nos."; "Checkoff Variation Nos.") { }
                field("Mobile Application Nos."; "Mobile Application Nos.") { }
                field("Online Loan Nos."; "Online Loan Nos.") { }
                field("Minimum Deposit Cont."; "Minimum Deposit Cont.") { }
                field("Block SMS"; "Block SMS") { }
                field("Defaulter Loan Product"; "Defaulter Loan Product") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90001 "Member Categories"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Categories";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description) { }
                field("Is Group"; Rec."Is Group") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Default Accounts")
            {
                ApplicationArea = All;
                Image = AddContacts;
                RunObject = page "Category Default Accounts";
                RunPageLink = "Category Code" = field(Code);
            }
        }
    }
}
page 90002 "Product Factory"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Product Factory";
    CardPageId = "Product Card";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;

                }
                field("Product Type"; Rec."Product Type")
                {
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = StyleText;
                }
                field(Prefix; Rec.Prefix)
                {
                    StyleExpr = StyleText;
                }
                field(Suffix; Rec.Suffix)
                {
                    StyleExpr = StyleText;
                }
                field("Loan Charges"; Rec."Loan Charges")
                {
                    StyleExpr = StyleText;
                }
                field(Status; Status)
                {
                    StyleExpr = StyleText;
                }
                field("Search Code"; "Search Code")
                {
                    StyleExpr = StyleText;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Default Accounts")
            {
                ApplicationArea = All;
                Image = StepInto;
                RunObject = page "Category Default Accounts";
                RunPageLink = "Product Code" = field(Code);
                Promoted = true;
                PromotedCategory = Category10;
                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if "Account Class" = "Account Class"::Loan then
            StyleText := 'Strong'
        else
            StyleText := 'Favourable';
    end;

    var
        StyleText: Text;
}
page 90003 "Category Default Accounts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Category Default Accounts";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Product Code"; Rec."Product Code")
                {
                    ApplicationArea = All;

                }
                field("Product Description"; Rec."Product Description") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90004 "Product Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Product Factory";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field("Member Posting Type"; "Member Posting Type") { }
                field("Product Type"; Rec."Product Type") { }
                field(Name; Rec.Name) { }
                field("Posting Group"; Rec."Posting Group") { }
                field(Prefix; Rec.Prefix) { }
                field(Suffix; Rec.Suffix) { }
                field(Status; Rec.Status) { }
                field("Account Class"; Rec."Account Class") { }
                field("Loan Multiplier"; Rec."Loan Multiplier") { }
                field("Guarantor Multiplier"; Rec."Guarantor Multiplier") { }
            }
            group("Account Controls")
            {
                field("Mobile Banking Allowed"; Rec."Mobile Banking Allowed") { }
                field("ATM Use Allowed"; Rec."ATM Use Allowed") { }
                field("Fixed Deposit"; Rec."Fixed Deposit") { }
                field("Share Capital"; Rec."Share Capital") { }
                field("NWD Account"; Rec."NWD Account") { }
                field("Cheque Book Allowed"; Rec."Cheque Book Allowed") { }
                field("Juniour Account"; Rec."Juniour Account") { }
                field("No. Series"; Rec."No. Series") { }
                field("Minimum Balance"; Rec."Minimum Balance") { }
                field("Minimum Contribution"; Rec."Minimum Contribution") { }
                field("Cash Withdrawal Allowed"; "Cash Withdrawal Allowed") { }
                field("Cash Deposit Allowed"; "Cash Deposit Allowed") { }
            }
            group("Credit Controls")
            {

                Field("Minimum Loan Amount"; rec."Minimum Loan Amount") { }
                field("Maximum Loan Amount"; rec."Maximum Loan Amount") { }
                field("Loan Span"; rec."Loan Span") { }
                field("Repay Mode"; rec."Repay Mode") { }
                field("Max. NWD Boost"; "Max. NWD Boost") { }
                field("Minimum Deposit Balance"; rec."Minimum Deposit Balance") { }
                Field("Minimum Deposit Contribution"; rec."Minimum Deposit Contribution") { }
                field("Max. NWD Boost %"; "Max. NWD Boost %") { }
                field("Discounting %"; "Discounting %") { }
                field("Loan Recovery Commission %"; "Loan Recovery Commission %") { }
                field("Commission Account"; "Commission Account") { }
                field("Max. Member Age"; rec."Max. Member Age") { }
                field("Net Salary Multiplier %"; rec."Net Salary Multiplier %") { }
                field("View Online"; rec."View Online") { }
                field("Exclude Billing & Interest"; rec."Exclude Billing & Interest") { }

                field("Interest Due Account"; Rec."Interest Due Account") { }
                field("Interest Paid Account"; Rec."Interest Paid Account") { }
                field("Interest Bands"; Rec."Interest Bands") { }
                field("Interest Repayment Method"; Rec."Interest Repayment Method") { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Appraise with 0 Deposits"; Rec."Appraise with 0 Deposits") { }
                field("Boost Deposits"; Rec."Boost Deposits") { }
                field("Special Loan Multiplier"; "Special Loan Multiplier") { }
                group("FOSA Salary Appraisal")
                {
                    field("Salary Based"; "Salary Based") { }
                    field("Min. Salary Count"; "Min. Salary Count") { }
                    field("Salary %"; "Salary %") { }
                    field("Salary Appraisal Type"; "Salary Appraisal Type") { }
                    field("Charge UpFront Interest"; rec."Charge UpFront Interest") { }
                }
                group("Insurance Control")
                {
                    field("Insurance Rate"; Rec."Insurance Rate")
                    {
                        MaxValue = 100;
                    }
                    field("Insurance Account"; Rec."Insurance Account") { }
                    field("Insurance Factor"; Rec."Insurance Factor") { }
                    field("Insurance Income %"; Rec."Insurance Income %")
                    {
                        MaxValue = 100;
                    }
                    field("Insurance Income Account"; Rec."Insurance Income Account") { }
                }
                group(Disbursements)
                {
                    field("Disbursal Method"; Rec."Disbursal Method") { }
                    field("Disbursement Account"; Rec."Disbursement Account") { }
                }
                group(Installments)
                {
                    field("Minimum Installments"; "Minimum Installments") { }
                    field("Maximum Installments"; "Maximum Installments")
                    {
                        trigger OnValidate()
                        begin
                            "Ordinary Default Intallments" := "Maximum Installments";
                        end;
                    }
                    field("Ordinary Default Intallments"; "Ordinary Default Intallments") { }
                }
                group("Mobile Controls")
                {
                    field("Mobile Loan"; "Mobile Loan") { }
                    field("Mobile Appraisal Type"; "Mobile Appraisal Type") { }
                    field("Mobile Appraisal Calculator"; "Mobile Appraisal Calculator") { }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Product Charges")
            {
                ApplicationArea = All;
                RunObject = page "Product Charges";
                RunPageLink = "Product Code" = field(Code);
            }
            action(Update)
            {
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    MemberMgt.UpdateMemberAccounts(Code);
                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90005 "Member Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Application";
    CardPageId = "Member Application";
    SourceTableView = where(Processed = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No."; Rec."Application No.") { }
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Last Name"; Rec."Last Name") { }
                field("Member Category"; Rec."Member Category") { }
                field("Full Name"; Rec."Full Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("National ID No"; Rec."National ID No") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
                field("Member No."; "Member No.") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Bulk Create Members")
            {
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                    Members: record "Member Application";
                begin
                    Members.Reset();
                    CurrPage.SetSelectionFilter(Members);
                    if Members.FindSet() then begin
                        repeat
                            MemberMgt.CreateMember(Members);
                        until Members.Next() = 0;
                    end;
                end;
            }
            action("Nexts of KIN")
            {
                ApplicationArea = All;
                RunObject = page "Member Application Kins";
                RunPageLink = "Source Code" = field("Application No.");
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Subscriptions")
            {
                ApplicationArea = All;
                RunObject = page "Application Subscriptions";
                RunPageLink = "Source Code" = field("Application No.");
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    MemberManagement.OnBeforeSendMemberApplicationForApproval(Rec);
                    if ApprovalsMgmtExt.CheckMemberApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendMemberApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberApplicationForApproval(Rec);
                end;
            }
            action("Process")
            {
                ApplicationArea = all;
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.TestField(Processed, false);
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    MemberManagement.CreateMember(Rec);
                    CurrPage.Close();
                end;
            }
            action("Process Batch")
            {
                ApplicationArea = All;

                trigger OnAction();
                VAR
                    MemberApplication: REcord "Member Application";
                    Window: Dialog;
                begin
                    MemberApplication.Reset();
                    CurrPage.SetSelectionFilter(MemberApplication);
                    MemberApplication.SetRange("Approval Status", MemberApplication."Approval Status"::Approved);
                    if MemberApplication.FindSet() then begin
                        Window.open('Creating Members');
                        repeat
                            // if MemberApplication.Rec."Approval Status" = MemberApplication.Rec."Approval Status"::Approved then
                            MemberManagement.CreateMember(MemberApplication);
                        until MemberApplication.NEXT() = 0;
                        Window.close;
                    end;
                end;
            }
        }
    }
    var
        MemberManagement: codeunit "Member Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90006 "Member Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Application";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Application No."; Rec."Application No.") { Editable = false; }
                field("Member Category"; Rec."Member Category")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("National ID No"; Rec."National ID No") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Recruited By"; Rec."Recruited By") { }
                field("Sales Person"; Rec."Sales Person") { }
                field(Nationality; Rec.Nationality) { }
                field("Mobile Transacting No"; Rec."Mobile Transacting No") { }
                field("Protected Account"; Rec."Protected Account")
                {
                    trigger OnValidate()
                    begin
                        isProtected := Rec."Protected Account";
                        Rec."Account Owner" := '';
                        CurrPage.Update();
                    end;
                }
                field("Account Owner"; Rec."Account Owner")
                {
                    Visible = isProtected;
                }
                group(Activatons)
                {
                    field(ATM; Rec.ATM) { }
                    field(Mobile; Rec.Mobile) { }
                    field(Portal; Rec.Portal) { }
                    field(FOSA; Rec.FOSA) { }
                    field("Marketing Texts"; Rec."Marketing Texts") { }
                }
                group("Portal Remarks")
                {
                    field("Subscription Start Date"; Rec."Subscription Start Date") { }
                    field("Portal Status"; Rec."Portal Status") { }
                    field("Rejection Comments"; Rec."Rejection Comments") { }
                    field("Source Type"; "Source Type") { }
                    field("Source No"; "Source No") { }
                }

            }
            group("Basic Information")
            {
                Visible = NOT isGroupMember;
                Editable = isOpen;
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Las Name"; Rec."Last Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("KRA PIN"; Rec."KRA PIN") { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field(Occupation; Rec.Occupation) { }
                field("Type of Residence"; Rec."Type of Residence") { }
                field("Marital Status"; Rec."Marital Status") { }
                field(Gender; Rec.Gender) { }
                group("Employement Information")
                {
                    field("Employer Code"; Rec."Employer Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Station Code"; Rec."Station Code")
                    {
                        ShowMandatory = true;
                    }
                    field(Designation; Rec.Designation)
                    {
                        ShowMandatory = true;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ShowMandatory = true;
                    }
                }
            }
            group("Group Information")
            {
                Visible = isGroupMember;
                field("Group Name"; Rec."Group Name") { }
                field("Group No"; Rec."Group No") { }
                field("Certificate of Incoop"; Rec."Certificate of Incoop") { }
                field("Date of Registration"; Rec."Date of Registration") { }
                field("Certificate Expiry"; rec."Certificate Expiry") { }
                field("&KRA PIN"; Rec."KRA PIN") { }
                field("&E-Mail Address"; Rec."E-Mail Address") { }
                field("&Address"; Rec.Address) { }
                field("&County"; Rec.County) { }
                field("&Sub County"; Rec."Sub County") { }
            }
            group("Contacts and Addresses")
            {
                Editable = isOpen;
                field("Mobile Phone No."; Rec."Mobile Phone No.") { }
                field("Alt. Phone No"; Rec."Alt. Phone No") { }
                field("E-Mail Address"; Rec."E-Mail Address") { }
                field(Address; Rec.Address) { }
                field(County; Rec.County) { }
                field("Sub County"; Rec."Sub County") { }
                field("Town of Residence"; Rec."Town of Residence") { }
                field("Estate of Residence"; Rec."Estate of Residence") { }
            }

            group(Images)
            {
                Editable = isOpen;
                Visible = NOT isGroupMember;
                field("Member Image"; Rec."Member Image") { }
                field("Front ID Image"; Rec."Front ID Image") { }
                field("Back ID Image"; Rec."Back ID Image") { }
                field("Member Signature"; Rec."Member Signature") { }
            }
            group("Audit Trail")
            {
                Editable = false;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90004), "No." = field("Application No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Populate IPRS Data")
            {
                Image = Import;
                trigger OnAction()
                begin
                    MemberManagement.PopulateIPRSData("Application No.", "National ID No");
                end;
            }
            action("Portal Documents")
            {
                Image = LaunchWeb;
                RunObject = page "Document Uploads(RO)";
                RunPageLink = "Document No" = field("Application No.");
                Promoted = true;
                PromotedCategory = Process;
            }
            action(Signatories)
            {
                Image = VendorBill;
                Promoted = true;
                RunObject = page "Signatories & Directors";
                RunPageLink = "Source Code" = field("Application No."), Type = const(Signatory);
            }
            action(Directors)
            {
                Image = VendorBill;
                Promoted = true;
                RunObject = page "Signatories & Directors";
                RunPageLink = "Source Code" = field("Application No."), Type = const(Directors);
            }
            action(Print)
            {
                Image = Print;
                trigger OnAction()
                var
                    MemberApp: Record "Member Application";
                begin
                    MemberApp.Reset();
                    MemberApp.SetRange("Application No.", "Application No.");
                    if MemberApp.FindSet() then
                        Report.Run(Report::"Member Application", true, false, MemberApp);
                end;
            }
            action("Print Application Form")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    MemberApp: Record "Member Application";
                begin
                    MemberApp.Reset();
                    MemberApp.SetRange("Application No.", "Application No.");
                    if MemberApp.FindFirst() then
                        Report.Run(Report::"Membership Form", true, false, MemberApp);
                end;
            }
            action("Nexts of KIN")
            {
                ApplicationArea = All;
                RunObject = page "Member Application Kins";
                RunPageLink = "Source Code" = field("Application No.");
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Subscriptions")
            {
                ApplicationArea = All;
                RunObject = page "Application Subscriptions";
                RunPageLink = "Source Code" = field("Application No.");
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    MemberManagement.OnBeforeSendMemberApplicationForApproval(Rec);
                    if ApprovalsMgmtExt.CheckMemberApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendMemberApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelMemberApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

            action("Create Account")
            {
                ApplicationArea = all;
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    MNo: Code[20];
                begin
                    MemberManagement.OnBeforeSendMemberApplicationForApproval(Rec);
                    Rec.TestField(Processed, false);
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to Open Account') then begin
                        mno := MemberManagement.CreateMember(Rec);
                        Message('Member Created Successfully -> ' + mno);
                        CurrPage.Close();
                    end;
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
        isGroupMember := Rec."Is Group";
        isProtected := "Protected Account";
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
        isGroupMember := Rec."Is Group";
        isProtected := "Protected Account";
    end;

    var
        MemberManagement: Codeunit "Member Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen, isGroupMember, isProtected : boolean;
}
page 90007 "Member Application Kins"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Nexts of Kin";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Code"; Rec."Source Code") { }
                field("Kin Type"; Rec."Kin Type")
                {
                    ApplicationArea = All;

                }
                field("KIN ID"; Rec."KIN ID") { }
                field(Name; Rec.Name) { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field("Phone No."; Rec."Phone No.") { }
                field(Allocation; Rec.Allocation) { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90008 "Application Subscriptions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Subscriptions";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Code"; Rec."Source Code") { }
                field("Account Type"; Rec."Account Type") { }
                field("Account Name"; Rec."Account Name") { }
                field("Start Date"; Rec."Start Date") { }
                field(Amount; Rec.Amount) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90009 Members
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Members;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    CardPageId = Member;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No."; Rec."Member No.") { }
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Las Name"; Rec."Last Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("Mobile Phone No."; rec."Mobile Phone No.") { }
                field("Payroll No."; Rec."Payroll No.") { }
                field("Date of Birth"; Rec."Date of Birth") { }

                field("Member Status"; rec."Member Status") { }
                field("Employer Code"; Rec."Employer Code") { }
                field("Date of Registration"; "Date of Registration") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Member No")
            {
                Visible = false;
                trigger OnAction()
                VAR
                    Member: Record Members;
                    Vendor: Record Vendor;
                    CollApplication: Record "Collateral Application";
                    ColRegister: Record "Collateral Register";
                    Loan: Record "Loan Application";
                    VLedger: Record "Vendor Ledger Entry";
                    DetailedLedger: Record "Detailed Vendor Ledg. Entry";
                    NMNo: Code[20];
                    NoSeries: Codeunit NoSeriesManagement;
                    SSetup: Record "Sacco Setup";
                    GLEntry: Record "G/L Entry";
                begin
                    SSetup.get;
                    NMNo := NoSeries.GetNextNo(SSetup."Member Nos.", Today, true);
                    if Member.get(Rec."Member No.") then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("Member No.", Member."Member No.");
                        if GLEntry.FindSet() then begin
                            repeat
                                GLEntry."Member No." := NMNo;
                                GLEntry.Modify();
                            until GLEntry.Next() = 0;
                        end;
                        Loan.Reset();
                        Loan.SetRange("Member No.", Member."Member No.");
                        if Loan.FindSet() then begin
                            Loan."Member No." := NMNo;
                            Loan.Modify();
                        end;
                        CollApplication.Reset();
                        CollApplication.SetRange("Member No", Member."Member No.");
                        if CollApplication.FindSet() then begin
                            repeat
                                CollApplication."Member No" := NMNo;
                                CollApplication.Modify();
                                ColRegister.Reset();
                                ColRegister.SetRange("Document No", CollApplication."Document No");
                                if ColRegister.FindSet() then begin
                                    ColRegister."Member No" := NMNo;
                                    ColRegister.Modify();
                                end;
                            until CollApplication.Next() = 0;
                        end;
                        Vendor.Reset();
                        Vendor.SetRange("Member No.", Member."Member No.");
                        if Vendor.FindSet() then begin
                            repeat
                                DetailedLedger.Reset();
                                DetailedLedger.SetRange("Vendor No.", Vendor."No.");
                                if DetailedLedger.FindSet() then begin
                                    repeat
                                        DetailedLedger."Member No." := NMNo;
                                        DetailedLedger."Vendor No." := (Vendor."Vendor Posting Group" + '-' + NMNo);
                                        DetailedLedger.Modify();
                                    until DetailedLedger.Next() = 0;
                                end;

                                VLedger.Reset();
                                VLedger.SetRange("Vendor No.", Vendor."No.");
                                if VLedger.FindSet() then begin
                                    repeat
                                        VLedger."Member No." := NMNo;
                                        VLedger."Vendor No." := (Vendor."Vendor Posting Group" + '-' + NMNo);
                                        VLedger.Modify();
                                    until VLedger.Next() = 0;
                                end;
                                Vendor.Rename(Vendor."Vendor Posting Group" + '-' + NMNo);
                                Vendor."Member No." := NMNo;
                                Vendor.Modify();
                            until Vendor.Next() = 0;
                        end;
                        Member.Rename(NMNo);
                    end;
                end;
            }
            action("Apply Images")
            {
                trigger OnAction()
                var
                    Members: Record Members;
                    FPath: Text;
                    Window: Dialog;
                begin
                    Members.Reset();
                    if Members.FindSet() then begin
                        Window.Open('Applying #1##');
                        repeat
                            Window.Update(1, Members."Full Name");
                            FPath := 'C:\Passport\' + Members."Member No." + '.JPG';
                            if File.Exists(FPath) then
                                PortalMgt.SetMemberImage(Members."Member No.", FPath, 0);
                            FPath := 'C:\Signature\' + Members."Member No." + '.JPG';
                            if File.Exists(FPath) then
                                PortalMgt.SetMemberImage(Members."Member No.", FPath, 3);
                        until Members.Next() = 0;
                        Window.Close();
                        ;
                    end;
                    Message('Imported');
                end;
            }
            action("Print Statement")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction();
                var
                    Member: Record Members;
                begin
                    Member.Reset();
                    Member.SetRange("Member No.", Rec."Member No.");
                    if Member.FindSet() then
                        Report.RunModal(Report::"Member Statement", true, false, Member);
                end;
            }
            action("Print Statement - With Reversals")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction();
                var
                    Member: Record Members;
                begin
                    Member.Reset();
                    Member.SetRange("Member No.", Rec."Member No.");
                    if Member.FindSet() then
                        Report.RunModal(Report::"Member Statement2", true, false, Member);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if CurrentClientType IN [ClientType::Web, ClientType::Windows] then begin
            if not MemberMgt.ViewProtectedAccounts(UserId) then begin
                Rec.FilterGroup(2);
                SetFilter("Account Owner", '%1|%2', UserId, '');
                Rec.FilterGroup(0);
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        if "Date of Registration" = 0D then begin
            "Date of Registration" := DMY2Date(01, 01, 2022);
            "Created On" := CreateDateTime("Date of Registration", Time);
            Modify();
        end;
    end;

    var
        MemberMgt: Codeunit "Member Management";
        PortalMgt: Codeunit PortalIntegrations;
}
page 90010 Member
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Members;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Application No."; Rec."Member No.") { }
                field("Member Category"; Rec."Member Category") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field(Nationality; rec.Nationality) { }
                field("Sales Person"; Rec."Sales Person") { }
                field("Mobile Transacting No"; Rec."Mobile Transacting No") { }
                group(Ativations)
                {
                    field(ATM; Rec.ATM) { }
                    field(Mobile; Rec.Mobile) { }
                    field(Portal; Rec.Portal) { }
                }

            }
            group("Basic Information")
            {
                Visible = not isGroupAccount;
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Last Name"; Rec."Last Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field(Occupation; Rec.Occupation) { }
                field("Type of Residence"; Rec."Type of Residence") { }
                field("Marital Status"; Rec."Marital Status") { }
                field(Gender; Rec.Gender) { }
                group("Employement Information")
                {
                    field("Employer Code"; Rec."Employer Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Station Code"; Rec."Station Code")
                    {
                        ShowMandatory = true;
                    }
                    field(Designation; Rec.Designation)
                    {
                        ShowMandatory = true;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ShowMandatory = true;
                    }
                }
            }
            group("Group Information")
            {
                Visible = isGroupAccount;
                field("Group Name"; Rec."Group Name") { }
                field("Group No"; Rec."Group No") { }
                field("Certificate of Incoop"; Rec."Certificate of Incoop") { }
                field("Date of Registration"; Rec."Date of Registration") { }
                field("Certificate Expiry"; rec."Certificate Expiry") { }
                field("&KRA PIN"; Rec."KRA PIN") { }
                field("&E-Mail Address"; Rec."E-Mail Address") { }
                field("&Address"; Rec.Address) { }
                field("&County"; Rec.County) { }
                field("&Sub County"; Rec."Sub County") { }
            }
            group("Contacts and Addresses")
            {
                field("Mobile Phone No."; Rec."Mobile Phone No.") { }
                field("Alt. Phone No"; Rec."Alt. Phone No") { }
                field("E-Mail Address"; Rec."E-Mail Address") { }
                field(Address; Rec.Address) { }
                field(County; Rec.County) { }
                field("Sub County"; Rec."Sub County") { }
                field("Town of Residence"; Rec."Town of Residence") { }
                field("Estate of Residence"; Rec."Estate of Residence") { }
                field("KRA PIN"; Rec."KRA PIN") { }
            }
            group(Images)
            {
                field("Member Image"; Rec."Member Image") { }
                field("Front ID Image"; Rec."Front ID Image") { }
                field("Back ID Image"; Rec."Back ID Image") { }
            }
            part("Accounts"; "Member Accounts")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Additional Controls")
            {
                Image = LotInfo;
                RunObject = page "Member Controls";
                RunPageLink = "Member No." = field("Member No.");
                Promoted = true;
            }
            action("Nexts of KIN")
            {
                ApplicationArea = All;
                RunObject = page "Member Application Kins";
                RunPageLink = "Source Code" = field("Member No.");
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Subscriptions")
            {
                ApplicationArea = All;
                RunObject = page "Member Subscriptions";
                RunPageLink = "Source Code" = field("Member No.");
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Referees")
            {
                ApplicationArea = All;
                RunObject = page "Member Application Referee";
                RunPageLink = "Application No." = field("Member No.");
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Print Statement")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Statement: Report "Member Statement";
                    MemberList: Record Members;
                begin
                    MemberList.Reset();
                    MemberList.SetRange("Member No.", Rec."Member No.");
                    if MemberList.FindSet() then begin
                        Clear(Statement);
                        Report.RunModal(Report::"Member Statement", true, false, MemberList);
                    end
                end;
            }
            action("Print Statement - With Reversals")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction();
                var
                    Member: Record Members;
                begin
                    Member.Reset();
                    Member.SetRange("Member No.", Rec."Member No.");
                    if Member.FindSet() then
                        Report.RunModal(Report::"Member Statement2", true, false, Member);
                end;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        isGroupAccount := rec."Is Group";
    end;

    var
        myInt: Integer;
        isGroupAccount: Boolean;


}
page 90011 "Member Accounts"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Vendor;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where("Account Type" = filter(Sacco | loan));
    layout
    {
        area(Content)
        {

            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = StyleText;
                }
                field("Search Name"; Rec."Search Name")
                {
                    StyleExpr = StyleText;
                }
                field(Balance; Rec.Balance)
                {
                    StyleExpr = StyleText;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StyleText;
                }
                field("Account Class"; Rec."Account Class")
                {
                    StyleExpr = StyleText;
                }
                field("Account Code"; Rec."Account Code")
                {
                    StyleExpr = StyleText;
                }
                field("Card No"; MemberMgt.MaskCardNo(Rec."Card No"))
                {
                    StyleExpr = StyleText;
                }
                field("NWD Account"; "NWD Account") { }
                field("Share Capital Account"; "Share Capital Account") { }
                field("Juniour Account"; "Juniour Account") { }

            }
        }

    }

    var
        StyleText: Text[100];
        MemberMgt: Codeunit "Member Management";

    trigger OnAfterGetRecord()
    begin
        if rec."Account Class" = rec."Account Class"::Loan then
            StyleText := 'Ambiguous'
        else
            if rec."Account Class" = rec."Account Class"::"Fixed Deposit" then
                StyleText := 'StrongAccent'
            else
                StyleText := 'Favorable';
    end;

}

page 90012 "Receipt Posting Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Posting Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Posting Type"; Rec."Posting Type") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field("Account Type"; Rec."Account Type") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90013 Receipts
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New));
    CardPageId = Receipt;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.")
                {
                    StyleExpr = Approved;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Type"; Rec."Receiving Account Type")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account No."; Rec."Receiving Account No.")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Name"; Rec."Receiving Account Name")
                {
                    StyleExpr = Approved;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = Approved;
                }
                field("Created By"; Rec."Created By")
                {
                    StyleExpr = Approved;
                }
                field("Created On"; Rec."Created On")
                {
                    StyleExpr = Approved;
                }
                field("Approval Status"; "Approval Status")
                {
                    StyleExpr = Approved;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        case "Approval Status" of
            "Approval Status"::New:
                begin
                    Approved := 'Standard';
                end;
            "Approval Status"::"Approval Pending":
                begin
                    Approved := 'Attention';
                end;
            "Approval Status"::Approved:
                begin
                    Approved := 'StrongAccent';
                end;
        end
    end;

    var
        Approved: Text;
}
page 90014 Receipt
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Receipt Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Receipt No."; Rec."Receipt No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Receiving Account Type"; Rec."Receiving Account Type") { }
                field("Receiving Account No."; Rec."Receiving Account No.") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Receiving Account Name"; Rec."Receiving Account Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field(Amount; Rec.Amount) { }
                field("Allocated Amount"; Rec."Allocated Amount") { }
                field("Posting Description"; Rec."Posting Description")
                {
                    ShowMandatory = true;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ShowMandatory = true;
                }


            }
            part("Receipt Details"; "Receipt Lines")
            {
                SubPageLink = "Receipt No." = field("Receipt No.");
            }
            group("Audit Trail")
            {

                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckBosaReceiptApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendBosaReceiptForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelBosaReceiptForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                image = Post;
                trigger OnAction()
                begin
                    TestField("Approval Status", "Approval Status"::Approved);
                    if Confirm('Do you want to Post?') then begin
                        ReceiptManagement.PostReceipt(Rec);
                    end
                end;
            }
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }

    var
        ReceiptManagement: Codeunit "Receipt Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90015 "Receipt Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt Type"; Rec."Receipt Type") { }
                field("Member No."; Rec."Member No.") { }
                field("Account Type"; Rec."Account Type") { }
                field(Amount; Rec.Amount) { }
                field("Loan No."; Rec."Loan No.") { }
                field("Posting Type"; Rec."Posting Type") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field(decription; Rec.description) { }
                field("Bal. Account No."; Rec."Bal. Account No.") { }
                field("Loan Balance"; "Loan Balance") { }
                field("Prorated Interest"; "Prorated Interest") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90016 "Member Statistics Factbox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Members;

    layout
    {
        area(Content)
        {
            group("Member KYC")
            {
                field("Member No."; Rec."Member No.") { }
                field("Full Name"; Rec."Full Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("Mobile Phone No."; Rec."Mobile Phone No.") { }
            }
            group("Account Information")
            {
                field("Total Deposits"; Rec."Total Deposits") { }
                field("Total Shares"; Rec."Total Shares") { }
                field("Held Collateral"; Rec."Held Collateral") { }
                field("Running Loans"; Rec."Running Loans") { }
                field("Outstanding Loans"; Rec."Outstanding Loans") { }
                field("Uncleared Effect"; Rec."Uncleared Effect") { }
            }
            group(Guarantees)
            {
                field("Self Guarantee"; Rec."Self Guarantee") { }
                field("Non-Self Guarantee"; Rec."Non-Self Guarantee") { }
                field("Qualified Self Guarantee"; LoansManagement.GetSelfGuaranteeEligibility(Rec."Member No.")) { }
                field("Qualified Non Self Guarantee"; LoansManagement.GetNonSelfGuaranteeEligibility(Rec."Member No.")) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
    var
        LoansManagement: Codeunit "Loans Management";
}
page 90017 "Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    CardPageId = loan;
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                }
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90018 Loan
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Application";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Prorated Days"; Rec."Prorated Days") { editable = false; }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
            group("Member Details")
            {
                Editable = isOpen;
                field("Member No."; Rec."Member No.")
                {
                    ShowMandatory = true;
                }
                field(Witness; Rec.Witness)
                {
                    ShowMandatory = true;
                }
                field("Member Name"; Rec."Member Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
            group("Loan Details")
            {
                Editable = isOpen;
                field("Product Code"; Rec."Product Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Qualified Salarywise"; "Qualified Salarywise") { }
                field("Recommended Amount"; rec."Recommended Amount") { }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Editable = false;
                }
                field("Recovery Mode"; Rec."Recovery Mode") { }
                group("Economic Sector")
                {
                    field("Sector Code"; Rec."Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub Sector Code"; Rec."Sub Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub-Susector Code"; Rec."Sub-Susector Code")
                    {
                        ShowMandatory = true;
                    }
                }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field("Loan Period"; Rec.Installments)
                {
                    Caption = 'Loan Period';
                }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field("Interest Repayment Method"; rec."Interest Repayment Method")
                {
                }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Total Securities"; Rec."Total Securities") { }
                field("Total Collateral"; Rec."Total Collateral") { }
                field("Insurance Amount"; Rec."Insurance Amount") { }
                field("New Monthly Installment"; Rec."New Monthly Installment") { }
            }
            group("Repayment Details")
            {
                Editable = isOpen;
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Approval Status"; Rec."Approval Status") { Editable = false; }
            }
            group("Transfer Details")
            {
                field("Pay to Bank Code"; Rec."Pay to Bank Code") { }
                field("Pay to Branch Code"; Rec."Pay to Branch Code") { }
                field("Pay to Account No"; Rec."Pay to Account No") { }
                field("Pay to Account Name"; Rec."Pay to Account Name") { }
            }
            group("Portal Information")
            {
                field("Portal Status"; Rec."Portal Status") { }
                field("Rejection Remarks"; Rec."Rejection Remarks") { }
                field("Member Deposits"; LoansManagement.GetMemberDeposits(Rec."Member No.")) { }
                field("Expected Amount"; LoansManagement.GetNetAmount(Rec."Application No")) { }
                field("Maximum Repayment Period"; "Maximum Repayment Period") { }

            }
        }
        area(FactBoxes)
        {
            part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Test)
            {
                trigger OnAction()
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    //LoansMgt.GetReversalAmortizationAmount('');
                end;
            }
            action("FOSA Salary")
            {
                ApplicationArea = all;
                RunObject = page "Appraisal FOSA Salary";
                RunPageLink = "Loan No" = field("Application No");
                Image = StepOver;
            }
            action("Generate Schedule")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = ApplyEntries;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    LoansManagement.GenerateLoanRepaymentSchedule(Rec);
                end;
            }
            action(Guarantors)
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Loan Guarantors";
                RunPageLink = "Loan No" = field("Application No");
            }
            action(Securities)
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Loan Collateral";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action("Print Appraisal")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                    LProduct: Record "Product Factory";
                begin
                    if LoanApplication."Appraisal Commited" = false then begin
                        LoansManagement.ValidateAppraisal(Rec);
                        Rec.CalcFields("Monthly Inistallment");
                        if Rec."Monthly Inistallment" = 0 then
                            Error('Please Generate the loan schedule first');
                        LoansManagement.AppraiseZeroDeposits(Rec);
                    end;
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then begin
                        LProduct.Get(LoanApplication."Product Code");
                        if LProduct."Salary Based" then
                            Report.Run(Report::"FOSA Appraisal", true, false, LoanApplication)
                        else
                            Report.Run(Report::"Loan Appraisal", true, false, LoanApplication);
                    end;
                end;
            }
            action("Print Application")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    if LoanApplication."Appraisal Commited" = false then begin
                        LoansManagement.ValidateAppraisal(Rec);
                        Rec.CalcFields("Monthly Inistallment");
                        if Rec."Monthly Inistallment" = 0 then
                            Error('Please Generate the loan schedule first');
                        LoansManagement.AppraiseZeroDeposits(Rec);
                    end;
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Application", true, false, LoanApplication);
                end;
            }
            action("Post")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = PostBatch;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to disburse the loan?') then
                        LoansManagement.DisburseLoan(rec);
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    LoansManagement.OnBeforeSendLoanForApproval(Rec);
                    if ApprovalsMgmtExt.CheckLoanApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendLoanApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelLoanApplicationForApproval(Rec);
                end;
            }
            action(Recoveries)
            {
                Image = StepOut;
                RunObject = page "Loan Recoveries";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Member Balances")
            {
                Image = ActivateDiscounts;
                RunObject = page "Appraisal Account Balances";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Payslip Information")
            {
                Image = AccountingPeriods;
                RunObject = page "Loan Appraisal Parameters";
                RunPageLink = "Loan No" = field("Application No");
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        LoansManagement: Codeunit "Loans Management";

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: Boolean;
        Portal: Codeunit PortalIntegrations;
}
page 90019 "Loan Schedule"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Schedule";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Monthly Repayment"; Rec."Monthly Repayment") { }
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Expected Date"; Rec."Expected Date") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90020 "Appraisal Parameters"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Appraisal Parameters";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description) { }
                field("Cleared Effect"; Rec."Cleared Effect") { }
                field(Class; Rec.Class) { }
                field(Taxable; Rec.Taxable) { }
                field(Type; Rec.Type) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90021 "Fixed Deposit Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description) { }
                field("Interest Calculation Type"; Rec."Interest Calculation Type") { }
                field("Interest Provision Account"; Rec."Interest Provision Account") { }
                field("Interest Payable Account"; Rec."Interest Payable Account") { }
                field("Max. Interest Rate"; Rec."Max. Interest Rate") { }
                field("Linking Account Type"; Rec."Linking Account Type") { }
                field("Charge Code"; Rec."Charge Code") { }
                field("External Payments Account"; Rec."External Payments Account") { }
                field("No. Series"; Rec."No. Series") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90022 "Fixed Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Fixed Deposit";
    SourceTableView = where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90023 "Fixed Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No."; Rec."Member No.") { }

                field("Member Name"; Rec."Member Name") { }
            }
            group("FD Details")
            {
                field("Marturity Instructions"; Rec."Marturity Instructions") { }
                field(Rate; Rec.Rate) { }
                field("FD Type"; Rec."FD Type") { }
                field("FD Description"; Rec."FD Description") { }
                field("Funds Source"; Rec."Funds Source") { }
                field("Source Account"; Rec."Source Account") { }
                field("Source Balance"; Rec."Source Balance") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
            group(Computation)
            {
                field("Total Interest Payable"; Rec."Total Interest Payable") { }
                field("Total Interest Accrued"; Rec."Total Interest Accrued") { }
                field("Total Interest Balance"; Rec."Total Interest Balance") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(ReOpen)
            {
                Image = ReOpen;
                Promoted = true;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Reopen?') then
                        ApprovalsMgmtExt.OnCancelMemberFixedDepositForApproval(Rec);
                end;
            }
            action("Generate Schedule")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec."Source Balance" < Rec.Amount then
                        Error('You Can only fix upto %1', Rec."Source Balance");
                    if Confirm('Do you want to Generate the Schedule?') then
                        FDManagement.CreateFixedDepositSchedule(Rec);
                end;
            }
            action("Activate Schedule")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Rec.TestField(rec."Approval Status", Rec."Approval Status"::Approved);
                    if Rec."Source Balance" < Rec.Amount then
                        Error('You Can only fix upto %1', Rec."Source Balance");
                    if Confirm('Do you want to Activate the Schedule?') then
                        FDManagement.ActivateFD(Rec);
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Rec."Source Balance" < Rec.Amount then
                        Error('You Can only fix upto %1', Rec."Source Balance");
                    if Confirm('Do you want to Send Approval Request?') then
                        if ApprovalsMgmtExt.isMemberFixedDepositApprovalWorkflowEnabled(Rec) then
                            ApprovalsMgmtExt.OnSendMemberFixedDepositForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberFixedDepositApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberFixedDepositForApproval(Rec);
                end;
            }
        }
    }

    var
        FDManagement: codeunit "Fixed Deposit Mgt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90024 "FD Schedule"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Schedule";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90025 "Bankers Cheque Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Transaction Nos."; Rec."Transaction Nos.") { }
                field("Leaf Nos."; Rec."Leaf Nos.") { }
                field("Maximum Amount"; Rec."Maximum Amount") { }
                field("Clearing Account"; Rec."Clearing Account") { }
                field("Clearing Charges"; Rec."Clearing Charges") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90026 Charges
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Charges;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Post to Account Type"; Rec."Post to Account Type") { }
                field("Post-to Account No."; Rec."Post-to Account No.") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90027 "Product Charges"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Product Charges";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Description"; Rec."Charge Description") { }
                field(Rate; Rec.Rate) { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Post to Account Type"; Rec."Post to Account Type") { }
                field("Post-to Account No."; Rec."Post-to Account No.") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90028 "loan Charges"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Charges";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Description"; Rec."Charge Description") { }
                field(Rate; Rec.Rate) { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Post to Account Type"; Rec."Post to Account Type") { }
                field("Post-to Account No."; Rec."Post-to Account No.") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90029 "Collateral Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Collateral Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Description; Rec.Description) { }
                field("Value Multiplier"; Rec."Value Multiplier") { }
                field(Active; Rec.Active) { }
                field("Security Type"; Rec."Security Type") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90030 "Collateral Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Collateral Application";
    CardPageId = "Collateral Application";
    SourceTableView = where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Security Type"; Rec."Security Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Collateral Type"; Rec."Collateral Type") { }
                field("Collateral Description"; Rec."Collateral Description") { }
                field("Collateral Value"; Rec."Collateral Value") { }
            }
        }
        area(Factboxes)
        {
            /* part("Incoming Doc. Attach. FactBox"; "Incoming Doc. Attach. FactBox")
             {

             }*/

        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendCollateralApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelCollateralApplicationForApproval(Rec);
                end;
            }
        }
    }
    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90031 "Collateral Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Collateral Application";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;

                }
            }
            group(Ownership)
            {
                Editable = isOpen;
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("KRA PIN No."; Rec."KRA PIN No.") { }
                field("Joint Ownership"; Rec."Joint Ownership") { }
            }
            group("Collateral Details")
            {
                Editable = isOpen;
                field("Collateral Type"; Rec."Collateral Type") { }
                field("Collateral Description"; Rec."Collateral Description") { }
                field(Multiplier; Rec.Multiplier) { }
                field("Multi-Linking"; Rec."Multi-Linking") { }
                field("Collateral Value"; Rec."Collateral Value") { }
                field("Serial No"; Rec."Serial No")
                {
                    ShowMandatory = true;
                }
                field("Registration No"; Rec."Registration No")
                {
                    ShowMandatory = true;
                }
                field("Insurance Expiry Date"; Rec."Insurance Expiry Date") { ShowMandatory = true; }
                field("Car Track Due Date"; Rec."Car Track Due Date") { ShowMandatory = true; }
                field("Linking Date"; Rec."Linking Date") { ShowMandatory = true; }
                field("Cheque No."; Rec."Cheque No.") { }
                field(Guarantee; Rec.Guarantee) { }
                field("Last Valuation Date"; Rec."Last Valuation Date") { }
                field("Security Type"; Rec."Security Type") { }
                field("Owner Name"; Rec."Owner Name") { }
                field("Owner ID No"; Rec."Owner ID No") { }
                field("Owner Phone No."; Rec."Owner Phone No.") { }
            }
            group(Images)
            {
                Editable = isOpen;
                field("Collateral Image"; Rec."Collateral Image") { }
                field("Collateral Image 1"; Rec."Collateral Image 1") { }
                field("Collateral Image 2"; Rec."Collateral Image 2") { }
                field("Collateral Image 3"; Rec."Collateral Image 3") { }
                field("Collateral Image 4"; Rec."Collateral Image 4") { }
            }
        }
        area(FactBoxes)
        {
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90015), "No." = field("Document No");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reopen?') then begin
                        Rec."Approval Status" := Rec."Approval Status"::New;
                        Rec.Modify();
                        Message('Reopenned Successfully');
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    Rec.TestField("Posting Date");
                    if Rec."Serial No" = '' then
                        Rec.TestField("Registration No");
                    if Rec."Registration No" = '' then
                        Rec.TestField("Serial No");
                    Rec.TestField("Collateral Type");
                    Rec.TestField("Collateral Value");
                    Rec.TestField(Guarantee);
                    if ApprovalsMgmtExt.CheckCollateralApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendCollateralApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelCollateralApplicationForApproval(Rec);
                end;
            }
            action(Post)
            {
                Image = Add;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if not Confirm('Do you want to post?') then
                        exit;
                    LoansManagement.PostCollateralRegistration(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                trigger OnAction()
                var
                    CollateralApplication: Record "Collateral Application";
                begin
                    CollateralApplication.Reset();
                    CollateralApplication.SetRange("Document No", Rec."Document No");
                    if CollateralApplication.FindSet() then
                        Report.Run(Report::"Collateral Acceptance", true, false, CollateralApplication);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        LoansManagement: Codeunit "Loans Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: boolean;
}
page 90032 "Collateral Register"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Collateral Register";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Member No"; Rec."Member No")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Member Name"; Rec."Member Name")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Collateral Type"; Rec."Collateral Type")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Collateral Description"; Rec."Collateral Description")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Caollateral Value"; Rec."Caollateral Value")
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field("Outstanding Value"; OutstandingValue)
                {
                    Style = Strong;
                    StyleExpr = isOpen;
                }
                field(Guarantee; Rec.Guarantee) { }
                field("Serial No"; Rec."Serial No") { }
                field("Registration No"; Rec."Registration No") { }
                field(Status; Rec.Status) { }
                field("Loan No."; Rec."Loan No.") { }
                field("Security Type"; Rec."Security Type") { }
                field("Owner Name"; Rec."Owner Name") { }
                field("Owner ID No"; Rec."Owner ID No") { }
                field("Owner Phone No."; Rec."Owner Phone No.") { }

                field("Insurance Expiry Date"; Rec."Insurance Expiry Date") { ShowMandatory = true; }
                field("Car Track Due Date"; Rec."Car Track Due Date") { ShowMandatory = true; }
                field("Linking Date"; Rec."Linking Date") { ShowMandatory = true; }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
            Part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Loan No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("View Acceptance")
            {
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                trigger OnAction()
                var
                    CollateralApplication: Record "Collateral Application";
                begin
                    CollateralApplication.Reset();
                    CollateralApplication.SetRange("Document No", Rec."Document No");
                    if CollateralApplication.FindSet() then
                        Report.RunModal(Report::"Collateral Acceptance", true, false, CollateralApplication);
                end;
            }
            action("Reopen for Linkning")
            {
                Image = ReopenCancelled;
                trigger OnAction()
                var
                    loan: Record "Loan Application";
                begin
                    if loan.get(Rec."Loan No.") then begin
                        loan.CalcFields("Loan Balance");
                        if loan."Loan Balance" > 0 then
                            Error('You Cannot Reopen');
                    end;
                    Rec.Status := Rec.Status::Available;
                    Rec."Loan No." := '';
                    Rec.Modify();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec.Status = Rec.Status::Available);
        OutStandingValue := 0;
        OutStandingValue := LoansMgt.GetCollateralValue("Document No");
    end;

    var
        isOpen: boolean;
        LoansMgt: Codeunit "Loans Management";
        OutStandingValue: Decimal;

}

page 90033 "Loan Securities"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Guarantees";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No") { }
                field("Guaranteed Amount"; Rec."Guaranteed Amount") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member Deposits"; Rec."Member Deposits") { }
                field(Self; Rec.Self) { }
                field("Multiplied Deposits"; Rec."Multiplied Deposits") { }
                field("Outstanding Guarantees"; Rec."Outstanding Guarantees") { }
                field(Substituted; Rec.Substituted) { }
                field("Substituted By"; Rec."Substituted By") { }
                field("Loan Owner"; "Loan Owner") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
}

page 90034 "Interest Accruals"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Interest Accrual";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Loan No."; Rec."Loan No.") { }
                field("Entry Date"; Rec."Entry Date") { }
                field("Entry Type"; Rec."Entry Type") { }
                field(Description; Rec.Description) { }
                field(Amount; Rec.Amount) { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Open; Rec.Open) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90035 "Posted Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    CardPageId = "Posted Loan Card";
    SourceTableView = where(Posted = const(True), "Loan Balance" = filter(<> 0), closed = const(False));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; "Posting Date") { }
                field("Repayment Start Date"; "Repayment Start Date") { }
                field(Installments; Installments) { }
                field("Repayment End Date"; "Repayment End Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Interest Repayment Method"; "Interest Repayment Method") { }
                field("Principle Paid"; Rec."Principle Paid") { }
                field("Principle Balance"; Rec."Principle Balance") { }
                field("Interest Paid"; Rec."Interest Paid") { }
                field("Interest Balance"; Rec."Interest Balance") { }
                field("Defaulted Days"; Rec."Defaulted Days") { }
                field("Total Arrears"; Rec."Total Arrears") { }
                field("Principle Arrears"; Rec."Principle Arrears") { }
                field("Interest Arrears"; Rec."Interest Arrears")
                {
                    StyleExpr = StyleText;
                }
                field("Defaulted Installments"; Rec."Defaulted Installments")
                {
                    StyleExpr = StyleText;
                }
                field("Loan Classification"; "Loan Classification")
                {
                    StyleExpr = StyleText;
                }
                field("Net Change-Principal"; Rec."Net Change-Principal") { }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
                field("Principle Repayment"; "Principle Repayment") { }
                field("Loan Account"; "Loan Account") { }
                field("Interest Repayment"; "Interest Repayment") { }
                field(Disbursed; Rec.Disbursed) { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            Part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }


    actions
    {
        area(Processing)
        {
        }
    }
    var
        StyleText: Text;

    trigger OnAfterGetRecord()
    begin
        case "Loan Classification" of
            "Loan Classification"::Performing:
                StyleText := 'Favorable';
            "Loan Classification"::Watch:
                StyleText := 'AttentionAccent';
            "Loan Classification"::Doubtfull:
                StyleText := 'Attention';
            "Loan Classification"::Substandard:
                StyleText := 'StandardAccent';
            "Loan Classification"::Loss:
                StyleText := 'Unfavorable';
        end;
    end;
}
page 90036 "Posted Loan Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Application";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }

                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
            group("Member Details")
            {
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Recommended Amount"; rec."Recommended Amount") { }
            }
            group("Loan Details")
            {
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field(Installments; Rec.Installments) { }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field(Charges; Rec.Charges) { }
                field("Total Securities"; Rec."Total Securities") { }
            }
            group("Repayment Details")
            {
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Billing Account"; Rec."Billing Account") { }
                field("Accrued Interest"; Rec."Accrued Interest") { }
                field("Monthly Inistallment"; "Monthly Inistallment") { }
                field("Monthly Principle"; "Monthly Principle") { }

            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            Part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action(Crt)
            {
                trigger OnAction()
                begin
                    LoansManagement.CreateAdvice(Rec);
                end;
            }
            action("Print Appraisal")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                    LProduct: Record "Product Factory";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then begin
                        LProduct.Get(LoanApplication."Product Code");
                        if LProduct."Salary Based" then
                            Report.Run(Report::"FOSA Appraisal", true, false, LoanApplication)
                        else
                            Report.Run(Report::"Loan Appraisal", true, false, LoanApplication);
                    end;
                end;
            }
            action("Print Statement")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", Rec."Member No.");
                    if Vendor.FindSet() then
                        Report.RunModal(Report::"Member Statement", true, false, Vendor);
                end;

            }
            action("Print Statement - With Reversals")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction();
                var
                    Member: Record Members;
                begin
                    Member.Reset();
                    Member.SetRange("Member No.", Rec."Member No.");
                    if Member.FindSet() then
                        Report.RunModal(Report::"Member Statement2", true, false, Member);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        LoansManagement: Codeunit "Loans Management";
}

page 90037 "Loan Interest Bands"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Product Interest Bands";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Min Installments"; Rec."Min Installments") { }
                field("Max Installments"; Rec."Max Installments") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field(Active; Rec.Active) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90038 "Member Application Referee"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Application Referees";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Full Names"; Rec."Full Names") { }
                field("Phone No."; Rec."Phone No.") { }
                field(Relationship; Rec.Relationship) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90039 "Running Fixed Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Running Fixed Deposit";
    SourceTableView = where(Posted = const(true), Terminated = const(false));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90040 "Running Fixed Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No."; Rec."Member No.") { }

                field("Member Name"; Rec."Member Name") { }
            }
            group("FD Details")
            {
                field(Rate; Rec.Rate) { }
                field("FD Type"; Rec."FD Type") { }
                field("FD Description"; Rec."FD Description") { }
                field("Funds Source"; Rec."Funds Source") { }
                field("Source Account"; Rec."Source Account") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
                field("Marturity Instructions"; Rec."Marturity Instructions") { }
            }
            group(Computation)
            {
                field("Total Interest Payable"; Rec."Total Interest Payable") { }
                field("Total Interest Accrued"; Rec."Total Interest Accrued") { }
                field("Total Interest Balance"; Rec."Total Interest Balance") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Accrue Interest")
            {
                Image = Position;
                Promoted = true;
                trigger OnAction()
                var
                    FixedDepositMgt: Codeunit "Fixed Deposit Mgt.";
                begin
                    if Confirm('Do you want to Accrue Fixed Deposit Interests?') then
                        FixedDepositMgt.PostFDAccrual(Rec);
                    CurrPage.Close();
                end;
            }
            action("Mature Fixed Deposit")
            {
                Image = Position;
                Promoted = true;
                trigger OnAction()
                var
                    FixedDepositMgt: Codeunit "Fixed Deposit Mgt.";
                begin
                    if Confirm('Do you want to mature the fixed Deposit?') then
                        FixedDepositMgt.MatureFixedDeposit(Rec);
                    CurrPage.Close();
                end;
            }
            action("Terminate Fixed Deposit")
            {
                Image = Position;
                Promoted = true;
                trigger OnAction()
                var
                    FixedDepositMgt: Codeunit "Fixed Deposit Mgt.";
                begin
                    if Confirm('Do you want to Terminate the fixed Deposit?') then
                        FixedDepositMgt.CancelFixedDeposit(Rec);
                    CurrPage.Close();
                end;
            }

        }
    }

    var
        FDManagement: codeunit "Fixed Deposit Mgt.";
}

page 90041 "Terminated Fixed Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Terminated Fixed Deposit";
    SourceTableView = where(Posted = const(true), Terminated = const(True));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90042 "Terminated Fixed Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No."; Rec."Member No.") { }

                field("Member Name"; Rec."Member Name") { }
            }
            group("FD Details")
            {
                field(Rate; Rec.Rate) { }
                field("FD Type"; Rec."FD Type") { }
                field("FD Description"; Rec."FD Description") { }
                field("Funds Source"; Rec."Funds Source") { }
                field("Source Account"; Rec."Source Account") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
                field("Marturity Instructions"; Rec."Marturity Instructions") { }
            }
            group(Computation)
            {
                field("Total Interest Payable"; Rec."Total Interest Payable") { }
                field("Total Interest Accrued"; Rec."Total Interest Accrued") { }
                field("Total Interest Balance"; Rec."Total Interest Balance") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }

    var
        FDManagement: codeunit "Fixed Deposit Mgt.";
}

page 90043 "Loan Details Factbox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group("Loan Details")
            {
                field("Application No"; Rec."Application No") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Total Recoveries"; "Total Recoveries") { }
                group(Appraisal)
                {
                    field("Adjusted Net"; Portal.AdjustedNet("Application No"))
                    {
                        Style = Strong;
                    }
                    field("1/3 Basic"; Portal.OneThirdBasic("Application No"))
                    {
                        Style = Strong;
                    }
                    field("Available Recovery"; Portal.AvailableRecovery("Application No"))
                    {
                        Style = Strong;
                    }
                }
            }
            group(Balances)
            {
                field("Loan Balance"; Rec."Loan Balance") { }
                field("Principle Balance"; Rec."Principle Balance") { }
                group(Interest)
                {
                    field("Total Interest Due"; Rec."Total Interest Due") { }
                    field("Interest Paid"; Rec."Interest Paid") { }
                    field("Interest Balance"; Rec."Interest Balance") { }
                }
                group(Penalties)
                {
                    field("Total Penalty Due"; Rec."Total Penalty Due") { }
                    field("Penalty Paid"; Rec."Penalty Paid") { }
                    field("Penalty Balance"; Rec."Penalty Balance") { }
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        Portal: Codeunit PortalIntegrations;
}

page 90044 "Collateral Releases"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Collateral Release";
    CardPageId = "Collateral Release";
    SourceTableView = where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater("General")
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;

                }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Collateral; Rec.Collateral) { }
                field("Collateral Description"; Rec."Collateral Description") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralReleaseApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendCollateralReleaseForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralReleaseApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelCollateralReleaseForApproval(Rec);
                end;
            }
        }
    }
    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";

}

page 90045 "Collateral Release"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Collateral Release";

    layout
    {
        area(Content)
        {
            group("Collateral Details")
            {
                Editable = isOpen;
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;

                }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Collateral; Rec.Collateral) { }
                field("Collateral Description"; Rec."Collateral Description") { }
                field("Linked to Loan No"; Rec."Linked to Loan No") { }
                field("Linked Loan Balance"; Rec."Linked Loan Balance") { }
            }
            group("Collector Details")
            {
                Editable = isOpen;
                field("Collection Date"; Rec."Collection Date")
                {
                    ShowMandatory = true;
                }
                field("Collected By"; Rec."Collected By") { }
                field("Collected By ID No"; Rec."Collected By ID No") { }
                field("Phone No"; Rec."Phone No") { }
                field(Comments; Rec.Comments)
                {
                    MultiLine = true;
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
            }
            part("Linked Loans"; "Linked Loans")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                VAR
                    LinkedLoans: Record "Collateral Discharge Details";
                begin
                    if ApprovalsMgmtExt.CheckCollateralReleaseApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendCollateralReleaseForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckCollateralReleaseApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelCollateralReleaseForApproval(Rec);
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                trigger OnAction()
                begin
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if not Confirm('Do you want to release?') then
                        exit;
                    LoansManagement.PostCollateralCollection(Rec);
                end;
            }
            action(Print)
            {
                Image = Print;
                trigger OnAction()
                VAR
                    CollateralRelease: Record "Collateral Release";
                begin
                    CollateralRelease.Reset();
                    CollateralRelease.SetRange("Document No", Rec."Document No");
                    if CollateralRelease.FindSet() then
                        Report.run(Report::"Collateral Collection", true, false, CollateralRelease);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;


    var
        LoansManagement: Codeunit "Loans Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: boolean;
}
page 90046 "Loans Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    CardPageId = "Posted Loan Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; "Posting Date") { }
                field("Repayment Start Date"; "Repayment Start Date") { }
                field(Installments; Installments) { }
                field("Repayment End Date"; "Repayment End Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Interest Repayment Method"; "Interest Repayment Method") { }
                field("Principle Paid"; Rec."Principle Paid") { }
                field("Principle Balance"; Rec."Principle Balance") { }
                field("Interest Paid"; Rec."Interest Paid") { }
                field("Interest Balance"; Rec."Interest Balance") { }
                field("Defaulted Days"; Rec."Defaulted Days") { }
                field("Loan Classification"; Rec."Loan Classification") { }
                field("Total Arrears"; Rec."Total Arrears") { }
                field("Principle Arrears"; Rec."Principle Arrears") { }
                field("Interest Arrears"; Rec."Interest Arrears") { }
                field("Defaulted Installments"; Rec."Defaulted Installments") { }
                field("Net Change-Principal"; Rec."Net Change-Principal") { }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
                field("Principle Repayment"; "Principle Repayment") { }
                field("Loan Account"; "Loan Account") { }
                field("Interest Repayment"; "Interest Repayment") { }
                field(Disbursed; Rec.Disbursed) { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    /// <summary>
    /// SetParameters.
    /// </summary>
    /// <param name="DocumentType">option "Loan Batch".</param>
    /// <param name="DocumentNo">Code[20].</param>
    procedure SetParameters(DocumentType: option "Loan Batch"; DocumentNo: Code[20])
    var
    begin
        GlobalDocumentNo := DocumentNo;
        GlobalDocumentType := DocumentType;
    end;

    var
        GlobalDocumentNo: code[20];
        GlobalDocumentType: option "Loan Batch";
        LoanApplication: record "Loan Application";
        LoanBatchLines: record "Loan Batch Lines";

    trigger OnQueryClosePage(CloseAction: Action) Success: Boolean
    var
    begin
        if CloseAction in [Action::Ok, Action::LookupOK] then begin
            LoanApplication.LockTable();
            LoanApplication.Reset();
            CurrPage.SetSelectionFilter(LoanApplication);
            if LoanApplication.FindSet() then begin
                repeat
                    LoanApplication.CalcFields("Total Recoveries");
                    LoanBatchLines.init;
                    LoanBatchLines."Batch No" := GlobalDocumentNo;
                    LoanBatchLines."Loan No" := LoanApplication."Application No";
                    LoanBatchLines."Applied Amount" := LoanApplication."Applied Amount";
                    LoanBatchLines."Principle Amount" := LoanApplication."Approved Amount";
                    LoanBatchLines."Net Amount" := LoanApplication."Approved Amount";
                    LoanBatchLines."Product Description" := LoanApplication."Product Description";
                    LoanBatchLines."Insurance Amount" := LoanApplication."Insurance Amount";
                    LoanBatchLines."Total Recoveries" := LoanApplication."Total Recoveries";
                    LoanBatchLines.Insert();
                    LoanApplication."Loan Batch No." := GlobalDocumentNo;
                    loanapplication.modify;
                until LoanApplication.Next() = 0;
            end
        end
    end;
}

page 90047 "New Defaulter Notices"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Notice Header";
    SourceTableView = where(Processed = const(false));
    CardPageId = "Defaulter Notice";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Notice Date"; Rec."Notice Date") { }
                field("First Notice Sent On"; Rec."First Notice Sent On") { }
                field("Second Notice Sent On"; Rec."Second Notice Sent On") { }
                field("Third Notice Sent On"; Rec."Third Notice Sent On") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90048 "Processed Defaulter Notices"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Notice Header";
    SourceTableView = where(Processed = const(true));
    CardPageId = "Defaulter Notice(RO)";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = False;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Notice Date"; Rec."Notice Date") { }
                field("First Notice Sent On"; Rec."First Notice Sent On") { }
                field("Second Notice Sent On"; Rec."Second Notice Sent On") { }
                field("Third Notice Sent On"; Rec."Third Notice Sent On") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {

    }
    var
        LoansMgt: Codeunit "Loans Management";
}
page 90049 "Defaulter Notice"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Notice Header";
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Notice Date"; Rec."Notice Date") { }
                field("First Notice Sent On"; Rec."First Notice Sent On") { }
                field("Second Notice Sent On"; Rec."Second Notice Sent On") { }
                field("Third Notice Sent On"; Rec."Third Notice Sent On") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
            }
            part("Notice Lines"; "Notice Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Populate Defaulters")
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Confirm('Do you want to populate') then begin
                        LoansMgt.PopulateDefaulters("Document No");
                    end;
                end;
            }
            action("Send [1st] Notices")
            {
                ApplicationArea = All;
                Image = Stages;
                trigger OnAction();
                begin
                    if Confirm('Do you want to populate') then begin
                        LoansMgt.SendNotice(Rec."Document No", 0);
                    end;
                end;
            }
            action("Send [2nd] Notices")
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Confirm('Do you want to populate') then begin
                        LoansMgt.SendNotice(Rec."Document No", 1);
                    end;
                end;
            }
            action("Send [3rd] Notice")
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    if Confirm('Do you want to populate') then begin
                        LoansMgt.SendNotice(Rec."Document No", 2);
                    end;
                end;
            }
        }
    }

    var
        LoansMgt: Codeunit "Loans Management";
}
page 90050 "Notice Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Notice Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No"; Rec."Loan No")
                {
                    StyleExpr = StyleText;
                }
                field("Product Code"; Rec."Product Code")
                {
                    StyleExpr = StyleText;
                }
                field("Product Description"; Rec."Product Description")
                {
                    StyleExpr = StyleText;
                }
                field("Member No"; Rec."Member No")
                {
                    StyleExpr = StyleText;
                }
                field("Member Name"; Rec."Member Name")
                {
                    StyleExpr = StyleText;
                }
                field("Total Arrears"; Rec."Total Arrears")
                {
                    StyleExpr = StyleText;
                }
                field("Loan Balance"; "Loan Balance")
                {
                    StyleExpr = StyleText;
                }
                field("Defaulted Days"; Rec."Defaulted Days")
                {
                    StyleExpr = StyleText;
                }
                field("Skip Reason"; "Skip Reason") { }
                field(Skip; Skip) { }
                field("Defaulted Installments"; Rec."Defaulted Installments")
                {
                    StyleExpr = StyleText;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    StyleExpr = StyleText;
                }
                field("Notice Type"; Rec."Notice Type")
                {
                    StyleExpr = StyleText;
                }
                field(Notified; Rec.Notified)
                {
                    StyleExpr = StyleText;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Notice")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", "Loan No");
                    if LoanApplication.FindSet() then
                        REPORT.Run(Report::"Defaulter Notice", true, false, LoanApplication);
                end;
            }
        }
    }
    var
        StyleText: Text[100];

    trigger OnAfterGetRecord()
    begin
        case rec."Notice Type" of
            rec."Notice Type"::"1st":
                StyleText := 'StrongAccent';
            rec."Notice Type"::"2nd":
                StyleText := 'Ambiguous';
            rec."Notice Type"::"3rd":
                StyleText := 'Attention';
        end;
    end;
}
page 90051 "Member Editings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Editing";
    CardPageId = "Member Editing";
    SourceTableView = where(Processed = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Las Name"; Rec."Last Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Approvals; Rec.Approvals) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90052 "Member Editing"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Editing";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Protected Account"; Rec."Protected Account") { }
                field("Account Owner"; Rec."Account Owner") { }
            }
            group("Basic Information")
            {
                Editable = isOpen;
                Visible = NOT isGroupMember;
                field("Member No."; rec."Member No.")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Update KINS"; Rec."Update KINS") { }
                field("First Name"; Rec."First Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Last Name"; Rec."Last Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("Mobile Transacting No"; "Mobile Transacting No") { }
                field("National ID No"; Rec."National ID No") { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field(Occupation; Rec.Occupation) { }
                field("Type of Residence"; Rec."Type of Residence") { }
                field("Marital Status"; Rec."Marital Status") { }
                field(Gender; Rec.Gender) { }
                group("Employement Information")
                {

                    field("Employer Code"; Rec."Employer Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Station Code"; Rec."Station Code")
                    {
                        ShowMandatory = true;
                    }
                    field(Designation; Rec.Designation)
                    {
                        ShowMandatory = true;
                    }
                    field("Payroll No."; Rec."Payroll No.")
                    {
                        ShowMandatory = true;
                    }
                }
            }
            group("Group Information")
            {
                Editable = isOpen;
                Visible = isGroupMember;
                field("Group Name"; Rec."Group Name") { }
                field("Group No"; Rec."Group No") { }
                field("Certificate of Incoop"; Rec."Certificate of Incoop") { }
                field("Date of Registration"; Rec."Date of Registration") { }
                field("Certificate Expiry"; rec."Certificate Expiry") { }
                field("&KRA PIN"; Rec."KRA PIN") { }
                field("&E-Mail Address"; Rec."E-Mail Address") { }
                field("&Address"; Rec.Address) { }
                field("&County"; Rec.County) { }
                field("&Sub County"; Rec."Sub County") { }
            }
            group("Contacts and Addresses")
            {
                Editable = isOpen;
                field("Mobile Phone No."; Rec."Mobile Phone No.") { }
                field("Alt. Phone No"; Rec."Alt. Phone No") { }
                field("E-Mail Address"; Rec."E-Mail Address") { }
                field(Address; Rec.Address) { }
                field(County; Rec.County) { }
                field("Sub County"; Rec."Sub County") { }
                field("Town of Residence"; Rec."Town of Residence") { }
                field("Estate of Residence"; Rec."Estate of Residence") { }
                field("KRA PIN"; Rec."KRA PIN") { }
            }
            group(Images)
            {
                Editable = isOpen;
                field("Member Image"; Rec."Member Image") { }
                field("Front ID Image"; Rec."Front ID Image") { }
                field("Back ID Image"; Rec."Back ID Image") { }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberUpdateApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendMemberUpdateForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberUpdateApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberUpdateForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Promoted = true;
                Image = Post;
                trigger OnAction()
                begin
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if NOT Confirm('Do you want to update Member Details?') then
                        exit;
                    MemberManagement.ProcessmemberEditing(Rec);
                    CurrPage.Close();
                end;
            }
            action("Next of Kins")
            {
                RunObject = page "Member Application Kins";
                RunPageLink = "Source Code" = field("Document No.");
                Image = StepInto;
            }
        }
    }
    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
        isGroupMember := rec."Is Group";
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
        isGroupMember := rec."Is Group";
    end;

    var
        MemberManagement: Codeunit "Member Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen, isGroupMember : boolean;
}
page 90053 "Payment Vouchers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payments Header";
    CardPageId = "Payment Voucher";
    SourceTableView = where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Approval Status"; Rec."Approval Status") { }
                field("Payee Account Type"; Rec."Payee Account Type") { }
                field("Payee Account No"; Rec."Payee Account No") { }
                field("Payee Account Name"; Rec."Payee Account Name") { }
                field("payment Amount"; Rec."payment Amount") { }
                field("Paying Account Type"; Rec."Paying Account Type") { }
                field("Paying Account No."; Rec."Paying Account No.") { }
                field("Paying Account Name"; Rec."Paying Account Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
        }
        area(Factboxes)
        {
            part("Vendor Statistics"; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = field("Payee Account No");
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}

page 90054 "Payment Voucher"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payments Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Document No."; Rec."Document No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
            group("Payer Infomration")
            {
                Editable = isOpen;
                field("Paying Account Type"; Rec."Paying Account Type") { }
                field("Paying Account No."; Rec."Paying Account No.") { }
                field("Paying Account Name"; Rec."Paying Account Name") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Cheque No"; Rec."Cheque No")
                {
                    ShowMandatory = true;
                }
            }
            group("Payee Details")
            {
                Editable = isOpen;
                field("Payee Account Type"; Rec."Payee Account Type") { }
                field("Payee Account No"; Rec."Payee Account No") { }
                field("Payee Account Name"; Rec."Payee Account Name") { }
                field("payment Amount"; Rec."payment Amount") { }
            }
            group("Audit Trail")
            {
                Editable = isOpen;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(factboxes)
        {
            part("Vendor Statistics"; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = field("Payee Account No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                Promoted = true;
                Image = Print;
                trigger OnAction()
                var
                    PaymentVoucher: record "Payments Header";
                begin
                    PaymentVoucher.Reset();
                    PaymentVoucher.SetRange("Document No.", Rec."Document No.");
                    if PaymentVoucher.FindSet() then
                        Report.run(Report::"Payment Voucher", true, false, PaymentVoucher)
                end;
            }
            action(Post)
            {
                Promoted = true;
                Image = Post;
                trigger OnAction()
                begin
                    Rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if not confirm('Do you want to Post?') then
                        exit;
                    PaymentManagement.PostPaymentVoucher(rec);
                    currpage.Close();
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    Rec.TestField("payment Amount");
                    Rec.TestField("Payee Account No");
                    Rec.TestField("Paying Account No.");
                    Rec.TestField("Cheque No");
                    if ApprovalsMgmtExt.CheckPaymentVoucherApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendPaymentVoucherForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckPaymentVoucherApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelPaymentVoucherForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: boolean;
        PaymentManagement: Codeunit "Payments Management";
}
page 90055 "Journal Vouchers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JV Header";
    CardPageId = "Journal Voucher";
    SourceTableView = where(Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Approval Status"; Rec."Approval Status") { }
                field("Created By"; Rec."Created By") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90056 "Journal Voucher"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "JV Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                editable = isopen;
                field("Document No."; Rec."Document No.") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Approval Status"; Rec."Approval Status") { }
                field("Created By"; Rec."Created By") { }
                field("Total Credit"; Rec."Total Credit") { }
                field("Total Debit"; Rec."Total Debit") { }
            }
            part("Journal Voucher Lines"; "Journal Voucher Lines")
            {
                editable = isopen;
                SubPageLink = "Document No." = field("Document No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    Rec.CalcFields("Total Credit", Rec."Total Debit");
                    Rec.TestField("Total Credit", Rec."Total Debit");
                    Rec.TestField("Posting Description");
                    Rec.TestField("Posting Date");
                    if ApprovalsMgmtExt.CheckJournalVoucherApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendJournalVoucherForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckJournalVoucherApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelJournalVoucherForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;
                Promoted = true;
                trigger OnAction()
                var
                    JournalManagement: Codeunit "Journal Management";
                begin
                    Rec.testfield(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if not confirm('Do you want to Post?') then
                        exit;
                    JournalManagement.PostJournalVoucher(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: boolean;
        PaymentManagement: Codeunit "Payments Management";
}
page 90057 "Cleared Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    SourceTableView = where(Posted = const(True), "Loan Balance" = filter(= 0));
    CardPageId = "Cleared Loan Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Principle Paid"; Rec."Principle Paid") { }
                field("Principle Balance"; Rec."Principle Balance") { }
                field("Interest Paid"; Rec."Interest Paid") { }
                field("Interest Balance"; Rec."Interest Balance") { }
                field("Penalty Paid"; Rec."Penalty Paid") { }
                field("Penalty Balance"; Rec."Penalty Balance") { }
                field("Defaulted Days"; Rec."Defaulted Days") { }
                field(Disbursed; Rec.Disbursed) { }
                field("Loan Classification"; Rec."Loan Classification") { }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            Part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Disbursed);
        if not Rec.Disbursed then begin
            Rec.Posted := false;
            Rec.Modify();
        end;
    end;
}
page 90058 "Cleared Loan Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Application";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }

                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
            group("Member Details")
            {
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
            }
            group("Loan Details")
            {
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field(Installments; Rec.Installments) { }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field(Charges; Rec.Charges) { }
                field("Total Securities"; Rec."Total Securities") { }
            }
            group("Repayment Details")
            {
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Billing Account"; Rec."Billing Account") { }
                field("Accrued Interest"; Rec."Accrued Interest") { }

            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            Part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action("Print Appraisal")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                    LProduct: Record "Product Factory";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then begin
                        LProduct.Get(LoanApplication."Product Code");
                        if LProduct."Salary Based" then
                            Report.Run(Report::"FOSA Appraisal", true, false, LoanApplication)
                        else
                            Report.Run(Report::"Loan Appraisal", true, false, LoanApplication);
                    end;
                end;
            }
            action("Print Statement")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", Rec."Member No.");
                    if Vendor.FindSet() then
                        Report.RunModal(Report::"Member Statement", true, false, Vendor);
                end;

            }
            action("Print Statement - With Reversals")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction();
                var
                    Member: Record Members;
                begin
                    Member.Reset();
                    Member.SetRange("Member No.", Rec."Member No.");
                    if Member.FindSet() then
                        Report.RunModal(Report::"Member Statement2", true, false, Member);
                end;
            }
        }
    }

    var
        LoansManagement: Codeunit "Loans Management";
}
page 90059 "Journal Voucher Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "JV Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type") { }
                field("Member No."; Rec."Member No.") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Credit Amount"; Rec."Credit Amount") { }
                field("Debit Amount"; Rec."Debit Amount") { }
                field(Amount; Rec.Amount) { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Transaction Type"; Rec."Transaction Type") { }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90060 "Member Versions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Versions";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.") { }
                field("Member No."; Rec."Member No.") { }
                field("First Name"; Rec."First Name") { }
                field("Las Name"; Rec."Last Name") { }
                field("Middle Name"; Rec."Middle Name") { }
                field("Full Name"; Rec."Full Name") { }
                field("Spouse Name"; Rec."Spouse Name") { }
                field("Spouse ID No"; Rec."Spouse ID No") { }
                field("Spouse Phone No"; Rec."Spouse Phone No") { }
                field("Mobile Phone No."; Rec."Mobile Phone No.") { }
                field("Alt. Phone No"; Rec."Alt. Phone No") { }
                field("E-Mail Address"; Rec."E-Mail Address") { }
                field("Employer Code"; Rec."Employer Code")
                {
                    ShowMandatory = true;
                }
                field("Station Code"; Rec."Station Code")
                {
                    ShowMandatory = true;
                }
                field(Designation; Rec.Designation)
                {
                    ShowMandatory = true;
                }
                field("Payroll No."; Rec."Payroll No.")
                {
                    ShowMandatory = true;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90061 "Linked Loans"
{
    PageType = Listpart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Collateral Discharge Details";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No."; Rec."Loan No.") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Details"; Rec."Product Details") { }
                field("Current Balance"; Rec."Current Balance") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90062 "Loan Calculators"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Calculator";
    CardPageId = "Loan Calculator";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Loan Product"; Rec."Loan Product") { }
                field("Product Description"; Rec."Product Description") { }
                field("Principal Amount"; Rec."Principal Amount") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Installments (Months)"; Rec."Installments (Months)") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90063 "Loan Calculator"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Calculator";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Member No"; "Member No") { }
                field("Loan Product"; Rec."Loan Product") { }
                field("Product Description"; Rec."Product Description") { }
                field("Principal Amount"; Rec."Principal Amount") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Installments (Months)"; Rec."Installments (Months)") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
            }
            group("Appraisal Parameters")
            {
                field("Current Deposits"; "Current Deposits") { }
                field("Current DepositsX4"; "Current DepositsX4") { }
                field("Ouststanding Loans"; "Ouststanding Loans") { }
                field("Deposit Appraisal"; "Deposit Appraisal") { }

            }
            group("Payslip Details")
            {
                field("Basic Pay"; "Basic Pay") { }
                field("Other Allowances"; "Other Allowances") { }
                field("Overtime Allowances"; "Overtime Allowances") { }
                field("Sacco Dividend"; "Sacco Dividend") { }
                field("Total Deductions"; "Total Deductions") { }
                field("Cleared Effects"; "Cleared Effects") { }
                field("Adjusted Net Income"; "Adjusted Net Income") { }
                field("OneThird Basic"; "OneThird Basic") { }
                field("Amount Available"; "Amount Available") { }
            }
            part("Calculator Lines"; "Loan Calculator Lines")
            {
                SubPageLink = "Calculator No" = field("Document No");
            }
            group(Audit)
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calculate")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    LoansManagement: Codeunit "Loans Management";
                begin
                    LoansManagement.GenerateCalculatorSchedule(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90064 "Loan Calculator Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;
    SourceTable = "Loan Calculator Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Installment No"; Rec."Installment No") { }
                field("Expected Date"; Rec."Expected Date") { }
                field("Principal Amount"; Rec."Principal Amount") { }
                field("Interest Amount"; Rec."Interest Amount") { }
                field("Installment Amount"; Rec."Installment Amount") { }
                field("Running Balance"; Rec."Running Balance") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

}

page 90065 "Posted Payment Vouchers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Payments Header";
    CardPageId = "Posted Payment Voucher";
    SourceTableView = where(Posted = const(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("Approval Status"; Rec."Approval Status") { }
                field("Payee Account Type"; Rec."Payee Account Type") { }
                field("Payee Account No"; Rec."Payee Account No") { }
                field("Payee Account Name"; Rec."Payee Account Name") { }
                field("payment Amount"; Rec."payment Amount") { }
                field("Paying Account Type"; Rec."Paying Account Type") { }
                field("Paying Account No."; Rec."Paying Account No.") { }
                field("Paying Account Name"; Rec."Paying Account Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
        }
        area(Factboxes)
        {
            part("Vendor Statistics"; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = field("Payee Account No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
}

page 90066 "Posted Payment Voucher"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payments Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Document No."; Rec."Document No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
            group("Payer Infomration")
            {
                Editable = isOpen;
                field("Paying Account Type"; Rec."Paying Account Type") { }
                field("Paying Account No."; Rec."Paying Account No.") { }
                field("Paying Account Name"; Rec."Paying Account Name") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Cheque No"; Rec."Cheque No")
                {
                    ShowMandatory = true;
                }
            }
            group("Payee Details")
            {
                Editable = isOpen;
                field("Payee Account Type"; Rec."Payee Account Type") { }
                field("Payee Account No"; Rec."Payee Account No") { }
                field("Payee Account Name"; Rec."Payee Account Name") { }
                field("payment Amount"; Rec."payment Amount") { }
            }
            group("Audit Trail")
            {
                Editable = isOpen;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(factboxes)
        {
            part("Vendor Statistics"; "Vendor Statistics FactBox")
            {
                SubPageLink = "No." = field("Payee Account No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Print)
            {
                Promoted = true;
                Image = Print;
                trigger OnAction()
                var
                    PaymentVoucher: record "Payments Header";
                begin
                    PaymentVoucher.Reset();
                    PaymentVoucher.SetRange("Document No.", Rec."Document No.");
                    if PaymentVoucher.FindSet() then
                        Report.run(Report::"Payment Voucher", true, false, PaymentVoucher)
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: boolean;
        PaymentManagement: Codeunit "Payments Management";
}

page 90067 "New Bankers Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque";
    SourceTableView = where(posted = const(false), "Approval Status" = const(New));
    CardPageId = "New Bankers Cheque";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Source Type"; Rec."Source Type") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90068 "New Bankers Cheque"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bankers Cheque";
    layout
    {
        area(Content)
        {
            group("General Information")
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Walkin Allowed"; Rec."Walkin Allowed") { }
                field("Max. Amount"; Rec."Max. Amount") { }

            }
            group("Payment Details")
            {
                field("Source Type"; Rec."Source Type") { }
                field("Member No."; Rec."Member No.") { }
                field("Account Type"; Rec."Account Type") { }
                field("Account Name"; Rec."Account Name") { }
                field("Book Balance"; Rec."Book Balance") { }
                field("Payee Details"; Rec."Payee Details")
                {
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    rec.TestField(rec.Description);
                    rec.TestField(rec.Amount);
                    if ApprovalsMgmtExt.isBankersChequeApprovalWorkflowEnabled(Rec) then
                        ApprovalsMgmtExt.OnSendBankersChequeForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckBankersChequeApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelBankersChequeForApproval(Rec);
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90069 "New Cheque Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Deposits";
    CardPageId = "New Cheque Deposit";
    SourceTableView = where("Document Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Cheque No"; Rec."Cheque No") { }
                field("Created By"; Rec."Created By") { }
                field("Document Status"; Rec."Document Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90070 "New Cheque Deposit"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Deposits";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Marturity Period"; Rec."Marturity Period") { }
                field("Marturity Date"; Rec."Marturity Date") { }
            }
            group("Receiving Details")
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
            }
            group("Cheque Details")
            {
                field("Cheque No"; Rec."Cheque No") { }
                field(Amount; Rec.Amount) { }
                field("Clearing Account No."; Rec."Clearing Account No.") { }
                field("Drawer Account Name"; Rec."Drawer Account Name") { }
                field("Drawer Bank"; Rec."Drawer Bank") { }
                field("Drawer Account No."; Rec."Drawer Account No.") { }
                field("Drawer Branch"; Rec."Drawer Branch") { }
                field("Clearing Charges"; Rec."Clearing Charges") { }
                field("Bouncing Charges"; Rec."Bouncing Charges") { }
                field("Express Clearing Charges"; Rec."Express Clearing Charges") { Editable = false; }
                field("Total Clearing Charges"; Rec."Total Clearing Charges") { }
                field("Instructions Amount"; Rec."Instructions Amount") { }
            }

            part("Cheque Instructions"; "Cheque Instructions")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Submit)
            {
                ApplicationArea = All;
                Image = PostApplication;
                trigger OnAction()
                begin
                    rec.CalcFields("Instructions Amount");
                    if (Rec.Amount - Rec."Total Clearing Charges") < Rec."Instructions Amount" then
                        Error('The Instructions Amount is more than the amount received less processing charges');
                    if Confirm('Do you want to Submit?') then begin
                        Rec."Document Status" := Rec."Document Status"::Received;
                        Rec.Modify();
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90071 "New Standing Orders"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Standing Order";
    CardPageId = "New Standing Order";
    SourceTableView = where("Approval Status" = const(new), Running = const(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90072 "New Standing Order"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Standing Order";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                }
                field("STO Type"; Rec."STO Type") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Salary Based"; Rec."Salary Based") { }
            }
            group("Funds Source")
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Account No"; Rec."Account No") { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
            group("Funds Destination")
            {
                field("Destination Member No"; Rec."Destination Member No") { }
                field("Destination Account"; Rec."Destination Account") { }
                field("Destination Name"; Rec."Destination Name") { }
                group("External Transfer Details")
                {
                    Editable = (Rec."Standing Order Class" = Rec."Standing Order Class"::External);
                    field("EFT Account Name"; Rec."EFT Account Name") { }
                    field("EFT Bank Name"; Rec."EFT Bank Name") { }
                    field("EFT Brannch Code"; Rec."EFT Brannch Code") { }
                    field("EFT Swift Code"; Rec."EFT Swift Code") { }
                    field("EFT Transfer Account No"; Rec."EFT Transfer Account No") { }
                    field("Payment Refrence Code"; "Policy No.") { }
                }
            }
            group("Operating Parameters")
            {
                field("Posting Description"; Rec."Posting Description") { }
                field("Run From Day"; Rec."Run From Day") { maxvalue = 28; }
                field("Approval Status"; Rec."Approval Status") { }
                field(Running; Rec.Running) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                Image = ReOpen;
                trigger OnAction()
                begin
                    //rec.TestField(rec."Approval Status", rec."Approval Status"::"Approval Pending");
                    if Confirm('Do you want to reopen?') then begin
                        rec."Approval Status" := Rec."Approval Status"::New;
                        rec.Running := false;
                        rec.Modify();
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.isStandingOrderApprovalWorkflowEnabled(Rec) then
                        ApprovalsMgmtExt.OnSendStandingOrderForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckStandingOrderApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelStandingOrderForApproval(Rec);
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90073 "Posted Receipts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(true));
    CardPageId = "posted Receipt";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Receiving Account Type"; Rec."Receiving Account Type") { }
                field("Receiving Account No."; Rec."Receiving Account No.") { }
                field("Receiving Account Name"; Rec."Receiving Account Name") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }
}
page 90074 "Posted Receipt"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Receipt Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Receipt No."; Rec."Receipt No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Receiving Account Type"; Rec."Receiving Account Type") { }
                field("Receiving Account No."; Rec."Receiving Account No.") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Receiving Account Name"; Rec."Receiving Account Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field(Amount; Rec.Amount) { }
                field("Allocated Amount"; Rec."Allocated Amount") { }
                field("Posting Description"; Rec."Posting Description")
                {
                    ShowMandatory = true;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ShowMandatory = true;
                }


            }
            part("Receipt Details"; "Receipt Lines")
            {
                SubPageLink = "Receipt No." = field("Receipt No.");
            }
            group("Audit Trail")
            {

                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }

    var
        ReceiptManagement: Codeunit "Receipt Management";
}
page 90075 "Mpesa Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mpesa Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.") { }

                Field("Completion Time"; Rec."Completion Time") { }
                Field("Paid In"; Rec."Paid In") { }
                Field(Balance; Rec.Balance) { }
                Field("Phone "; Rec."Phone ") { }
                Field(Name; Rec.Name) { }
                Field("Transaction Date"; Rec."Transaction Date") { }
                Field(Status; Rec.Status) { }
                field("Customer No "; Rec."Customer No ") { }
                Field("Customer Details"; Rec."Customer Details") { }
                Field("Paybil Number"; Rec."Paybil Number") { }
                field("ID No"; Rec."ID No") { }
                Field(Received; Rec.Received) { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90076 "Teller - Treasury Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Setup Type"; Rec."Setup Type") { }
                field("User ID"; Rec."User ID") { }
                field("Account Code"; Rec."Account Code") { }
                field("Maximum Capacity"; Rec."Maximum Capacity") { }
                field("Minimum Capacity"; Rec."Minimum Capacity") { }
                //field("Journal Template"; Rec."Journal Template") { }
                //field("Journal Bacth"; Rec."Journal Bacth") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90077 "Coinage Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Coinage;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Denomination Code"; Rec."Denomination Code")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description) { }
                field("Denomination Value"; Rec."Denomination Value") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90078 "Receive From Bank"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Receive From Bank Card";
    SourceTableView = where("Transaction Type" = const("Receive From Bank"), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        tellerSetup: record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Treasury);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90079 "Receive From Bank Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }
                field("&Coinage"; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
            }
            group(Destination)
            {
                Editable = false;
                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
        FosaMGT: Codeunit "FOSA Management";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec."Transaction Type" := rec."Transaction Type"::"Receive From Bank";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        rec.Validate("Destination No", TellerSetup."Account Code");
        FosaMGT.ValidateTransactionCoinage(Rec);
    end;

    var
        myInt: Integer;
}
page 90080 "Send To Bank"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Send To Bank Card";
    SourceTableView = where("Transaction Type" = const("Send to Bank"), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Treasury);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90081 "Send To Bank Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
        FosaMGT: codeunit "FOSA Management";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Send to Bank";
        FosaMGT.ValidateTransactionCoinage(Rec);
    end;

    var
        myInt: Integer;
}

page 90082 "Request From Treasury"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Request From Treasury Card";
    SourceTableView = where("Transaction Type" = const("Request From Treasury"), Status = const(Outbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Teller);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90083 "Request From Treasury Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
        FosaMGT: COdeunit "FOSA Management";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Teller);
        rec."Transaction Type" := rec."Transaction Type"::"Request From Treasury";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        rec.Validate("Source No", TellerSetup."Account Code");
        Rec.Status := Rec.Status::Outbound;
        FosaMGT.ValidateTransactionCoinage(Rec);
    end;

    var
        myInt: Integer;
}

page 90084 "Issue to Teller"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Issue to Teller Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = where("Transaction Type" = const("Request From Treasury"), Status = const(Transit), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Treasury);
        Rec.FilterGroup(2);
        Rec.SetRange("Destination No", TellerSetup."Account Code");
        Rec.FilterGroup(0);
    end;
}
page 90085 "Issue To Teller Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {
                Editable = false;
                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }
                field("&Coinage"; rec.Coinage) { }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reject)
            {
                Image = CancelApprovalRequest;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reject?') then begin
                        "Transaction Type" := "Transaction Type"::"Request From Treasury";
                        Status := Status::Outbound;
                        Posted := False;
                        modify;
                    end;
                end;
            }
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Request From Treasury";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
    end;

    var
        myInt: Integer;
}
page 90086 "Receive From Treasury"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Receive From Treasury Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = where("Transaction Type" = const("Request From Treasury"), Status = const(Inbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Teller);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90087 "Receive From Treasury Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Request From Treasury";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
    end;

    var
        myInt: Integer;
}
page 90088 "Inter Teller Transfer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Inter Teller Transfer Card";
    SourceTableView = where("Transaction Type" = const("Inter Teller Transfer"), Status = const(Outbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Teller);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90089 "Inter Teller Transfer Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
        FosaMGT: Codeunit "FOSA Management";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Teller);
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Inter Teller Transfer";
        Rec.Status := Rec.Status::Outbound;
        FosaMGT.ValidateTransactionCoinage(Rec);
    end;

    var
        myInt: Integer;
}
page 90090 "Inter Teller Receiving"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Inter Teller Receiving Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = where("Transaction Type" = const("Inter Teller Transfer"), Status = const(Inbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Teller);
        Rec.FilterGroup(2);
        Rec.SetRange("Destination No", TellerSetup."Account Code");
        Rec.FilterGroup(0);
    end;
}
page 90091 "Inter Teller Receiving Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Request From Treasury";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
    end;

    var
        myInt: Integer;
}
page 90092 "Return To Treasury"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Return To Treasury Card";
    SourceTableView = where("Transaction Type" = const("Return To Treasury"), Status = const(Outbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Teller);
        Rec.FilterGroup(2);
        Rec.SetRange("Created By", UserId);
        Rec.FilterGroup(0);
    end;
}
page 90093 "Return To Treasury Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {
                field("Source Balance"; rec."Source Balance") { }
                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }

            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
        FosaMGT: Codeunit "FOSA Management";
        BankAccount: Record "Bank Account";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Teller);
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
        rec."Global Dimension 2 Code" := TellerSetup."Global Dimension 2 Code";
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Return To Treasury";
        BankAccount.get(Rec."Source No");
        BankAccount.CalcFields(Balance);
        Rec."Source Balance" := BankAccount.Balance;
        Rec.Status := Rec.Status::Outbound;
        FosaMGT.ValidateTransactionCoinage(Rec);
    end;

    var
        myInt: Integer;
}
page 90094 "Receive From Teller"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transactions";
    CardPageId = "Receive From Teller Card";
    InsertAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    SourceTableView = where("Transaction Type" = const("Return To Treasury"), Status = const(Inbound), Posted = const(false));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Source No"; Rec."Source No") { }
                field("Source Name"; Rec."Source Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Destination No"; Rec."Destination No") { }
                field("Destination Name"; Rec."Destination Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    var
        TellerSetup: Record "Teller Setup";
    begin
        tellerSetup.get(UserId, tellerSetup."Setup Type"::Treasury);
        Rec.FilterGroup(2);
        Rec.SetRange("Destination No", TellerSetup."Account Code");
        Rec.FilterGroup(0);
    end;
}
page 90095 "Receive From Teller Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "FOSA Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Transaction Type"; rec."Transaction Type") { }
                field("Document No"; rec."Document No") { }
            }
            group("Source")
            {
                Editable = false;
                field("Source No"; rec."Source No") { }
                field("Source Name"; rec."Source Name") { }

            }
            group(Destination)
            {

                field("Destination No"; rec."Destination No") { }
                field("Destination Name"; rec."Destination Name") { }
                field("Payment Refrence No"; rec."Payment Refrence No")
                {
                    ShowMandatory = true;
                }
                field(Amount; rec.Amount)
                {
                    ShowCaption = true;
                }

            }
            part(Coinage; "Transaction Coinage")
            {
                SubPageLink = "Transaction Type" = field("Transaction Type"), "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Promoted = true;
                Image = Post;
                PromotedIsBig = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FOSA: Codeunit "FOSA Management";
                begin
                    if not Confirm('Do You want to Post?') then begin
                        CurrPage.Close();
                    end;
                    FOSA.PostFOSATransaction(Rec);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SaccoSetup: Record "Sacco Setup";
        Noseries: Codeunit NoSeriesManagement;
        TellerSetup: Record "Teller Setup";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("FOSA Nos");
        Rec."Document No" := NoSeries.GetNextNo(SaccoSetup."FOSA Nos", Today, true);
        Rec."Created By" := UserId;
        Rec."Created On" := CurrentDateTime;
        Rec."posting Date" := Today;
        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
        rec.Validate("Source No", TellerSetup."Account Code");
        rec."Transaction Type" := rec."Transaction Type"::"Request From Treasury";
        rec."Global Dimension 1 Code" := TellerSetup."Global Dimension 1 Code";
    end;

    var
        myInt: Integer;
}

page 90096 "Transaction Coinage"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "FOSA Transaction Coinage";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Coinage Code"; Rec."Coinage Code") { }
                field("Coinage Description"; Rec."Coinage Description") { }
                field(Quantity; Rec.Quantity) { }
                field("Coinage Value"; Rec."Coinage Value") { }
                field("Total Value"; Rec."Total Value") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90097 "Member Images"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Members;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(Member)
            {
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;

                }
                field("Full Name"; Rec."Full Name") { }
            }
            group(Images)
            {
                field("Front ID Image"; Rec."Front ID Image") { }
                field("Back ID Image"; Rec."Back ID Image") { }
                field("Member Image"; Rec."Member Image") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90098 "Teller Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Transactions";
    SourceTableView = where(Posted = const(false));
    CardPageId = "Teller Transaction Card";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field(Amount; Rec.Amount)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Coinage; Rec.Coinage)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Teller; Rec.Teller) { }
                field(Till; Rec.Till) { }
                Field("Approval Required"; Rec."Approval Required") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part(Images; "Member Images Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90099 "Posted Teller Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Teller Transactions";
    SourceTableView = where(Posted = const(true));
    CardPageId = "Teller Transaction Card(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Teller; Rec.Teller) { }
                field(Till; Rec.Till) { }
                Field("Approval Required"; Rec."Approval Required") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part(Images; "Member Images Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90100 "Teller Transaction Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Teller Transactions";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                        isVisible := ("Transaction Type" = "Transaction Type"::"Cash Deposit");
                        CurrPage.Update();
                    end;
                }
                field("Member No"; Rec."Member No")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Account No"; Rec."Account No")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Transacted By Name"; Rec."Transacted By Name")
                {
                    Editable = isVisible;
                    ShowMandatory = True;
                }
                field("Transacted By ID No"; Rec."Transacted By ID No")
                {
                    Editable = isVisible;
                    ShowMandatory = True;
                }

                group("Document Dimensions")
                {
                    Editable = false;
                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                }
            }
            group("Static Information")
            {
                Editable = false;
                field("Book Balance"; "Book Balance") { }
                field("Available Balance"; rec."Available Balance") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account Name"; Rec."Account Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Required"; Rec."Approval Required") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Posted; Rec.Posted) { }
            }
        }
        area(FactBoxes)
        {
            part(Images; "Member Images Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {


            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction()
                var
                    FOSATrans: Codeunit "FOSA Management";
                begin
                    FOSATrans.PrecheckTellerTransasction(Rec);
                    if ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec) then
                        ApprovalsMgmtExt.OnSendTellerTransactionForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckTellerTransactionApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelTellerTransactionForApproval(Rec);
                end;
            }
            action("Veiw Member Image")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = StepInto;
                PromotedCategory = Process;
                RunObject = page "Member Images";
                RunPageLink = "Member No." = field("Member No");
                trigger OnAction()
                begin

                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    FOSATrans: Codeunit "FOSA Management";
                begin
                    /*if ApprovalsMgmtExt.CheckTellerTransactionApprovalsWorkflowEnable(Rec) then
                        rec.testfield("Approval Status", rec."Approval Status"::Approved);*/
                    FOSATrans.PrecheckTellerTransasction(Rec);
                    if not confirm('Do you want to Post?') then
                        currpage.Close();
                    FOSATrans.PostTellerTransaction(Rec);
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isVisible: Boolean;
}
page 90101 "Vendor Lookup Custom"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Vendor;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field("Search Name"; Rec."Search Name") { }
                field("Member No."; Rec."Member No.") { }
                field("Net Change"; Rec."Net Change") { }
                field(Balance; Rec.Balance) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90102 "Loan Appraisal Parameters"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Appraisal Parameters";
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No"; Rec."Loan No")
                {
                    Visible = isSOAP;
                }
                field("Appraisal Code"; Rec."Appraisal Code") { }
                field("Parameter Description"; Rec."Parameter Description") { }
                field("Parameter Value"; Rec."Parameter Value") { }
                field(Type; Rec.Type) { Editable = false; }
                field(Class; Rec.Class) { Editable = false; }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        isSOAP: Boolean;

    trigger OnOpenPage()
    begin
        if CurrentClientType <> ClientType::Windows then
            isSOAP := true;
    end;
}
page 90103 "Appraisal Account Balances"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Appraisal Accounts";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type") { }
                field("Account No"; Rec."Account No") { }
                field("Account Description"; Rec."Account Description") { }
                field(Balance; Rec.Balance) { }
                field("Mulltipled Value"; Rec."Mulltipled Value") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90104 "Loan Guarantors"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Guarantees";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No")
                {
                    trigger onvalidate()
                    begin
                    end;
                }
                field("Member Name"; Rec."Member Name")
                {
                    Editable = false;
                }
                field("Total Deposits"; Rec."Member Deposits")
                {
                    Editable = false;
                }
                field("Guarantor Value"; Rec."Multiplied Deposits")
                {
                    Editable = false;
                }
                field("Outstanding Guarantees"; Rec."Outstanding Guarantees") { }
                field("Available Guarantee"; Rec."Available Guarantee") { }
                field("Amount to Guarantee"; Rec."Guaranteed Amount") { }
                field("Self Guarantee"; Rec."Self Guarantee") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90105 "External Recoveries Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "External Recoveries Setup";

    layout
    {
        area(Content)
        {
            Repeater(General)
            {
                field("Recovery Code"; Rec."Recovery Code") { }
                field("Recovery Description"; Rec."Recovery Description") { }
                field("Post To Account Type"; Rec."Post To Account Type") { }
                field("Post To Account No"; Rec."Post To Account No") { }
                field(Commission; Rec.Commission) { }
                field("Commission Account"; Rec."Commission Account") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90106 "Loan Recoveries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recoveries";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No"; Rec."Loan No")
                {
                    Visible = isSOAP;
                }
                field("Recovery Type"; Rec."Recovery Type") { }
                field("Recovery Code"; Rec."Recovery Code") { }
                field("Recovery Description"; Rec."Recovery Description") { }
                field(Amount; Rec.Amount) { }
                field("Commission %"; Rec."Commission %") { }
                field("Commission Amount"; Rec."Commission Amount") { }
                field("Commission Account"; Rec."Commission Account") { }
                field("Current Balance"; Rec."Current Balance") { }
                field("Prorated Interest"; "Prorated Interest") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        isSOAP: Boolean;

    trigger OnOpenPage()
    begin
        isSOAP := (not GuiAllowed);
    end;
}

page 90107 "ATM Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Types";
    CardPageId = "ATM Types Card";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ATM Type"; Rec."ATM Type") { }
                field(Description; Rec.Description) { }
                field("ATM Settlment Account"; Rec."ATM Settlment Account") { }
                field("ATM Cards"; Rec."ATM Cards") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90108 "ATM Types Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Types";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("ATM Type"; Rec."ATM Type") { }
                field(Description; Rec.Description) { }
                field("ATM Cards"; Rec."ATM Cards") { }
                field("ATM Settlment Account"; Rec."ATM Settlment Account") { }
            }
            group("Charges Setup")
            {
                group("General Transactions Setup")
                {
                    field("Activation T. Code"; Rec."Activation T. Code") { }
                    field("Airtime Purchase T. Code"; Rec."Airtime Purchase T. Code") { }
                    field("Blocking T. Code"; Rec."Blocking T. Code") { }
                    field("Deposits T. Code"; Rec."Deposits T. Code") { }
                    field("MPesa Withdrawal T. Code"; Rec."MPesa Withdrawal T. Code") { }
                    field("Pin Change T. Code"; Rec."Pin Change T. Code") { }
                    field("Replacement T. Code"; Rec."Replacement T. Code") { }
                }
                group("POS Transaction Charges")
                {
                    field("POS Balance Enquiry T. Code"; Rec."POS Balance Enquiry T. Code") { }
                    field("POS Benefit CW T. Code"; Rec."POS Benefit CW T. Code") { }
                    field("POS Card Deposit T. Code"; Rec."POS Card Deposit T. Code") { }
                    field("POS Cash Deposit T. Code"; Rec."POS Cash Deposit T. Code") { }
                    field("POS Cash Withdrawal T. Code"; Rec."POS Cash Withdrawal T. Code") { }
                    field("POS M Banking T. Code"; Rec."POS M Banking T. Code") { }
                    field("POS Ministatement T. Code"; Rec."POS Ministatement T. Code") { }
                    field("POS Purchase T. Code (CBack)"; Rec."POS Purchase T. Code (CBack)") { }
                    field("POS Purchase T. Code (Normal)"; Rec."POS Purchase T. Code (Normal)") { }
                    field("POS School Payment T. Code"; Rec."POS School Payment T. Code") { }
                }
            }
            part(Cards; "ATM Cards")
            {
                SubPageLink = "ATM Type" = field("ATM Type");
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
        myInt: Integer;
}

page 90109 "ATM Cards"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ATM Cards";

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Card No."; MemberMgt.MaskCardNo(Rec."Card No.")) { }
                field(Status; Rec.Status) { }
                field("Added By"; Rec."Added By") { }
                field("Added On"; Rec."Added On") { }
                field("Assigned To Member No."; Rec."Assigned To Member No.") { }
                field("Assigned to Account No"; Rec."Assigned to Account No") { }
                field("Assigned By"; Rec."Assigned By") { }
                field("Assigned On"; Rec."Assigned On") { }
            }
        }
    }
    var
        MemberMgt: Codeunit "Member Management";

}

page 90110 "ATM Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    CardPageId = "ATM Application";
    SourceTableView = where("Approval Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90111 "ATM Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isEditable;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Application Type"; Rec."Application Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("ATM Type"; Rec."ATM Type") { }
                field("ATM Type Name"; Rec."ATM Type Name") { }
                field("Transaction Code"; "Transaction Code") { }
            }
            group("Card Details")
            {
                Editable = isApproved;
                field("Card No."; CardNo) { }
                field("ATM Collected By"; Rec."ATM Collected By") { }
                field("ATM Collected By ID No."; Rec."ATM Collected By ID No.") { }

            }
            group("Audit Trail")
            {
                Editable = isEditable;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendATMApplicationForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelATMApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
        isEditable, isApproved : Boolean;
        CardNo: Code[50];
        MemberMgt: Codeunit "Member Management";

    trigger OnAfterGetRecord()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
        if Processed then
            CardNo := MemberMgt.MaskCardNo("Card No.")
        else
            CardNo := "Card No.";
    end;

    trigger OnOpenPage()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;
}
page 90112 "ATM Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ATM Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    StyleExpr = StyleText;
                }
                field("ATM Card No"; Rec."ATM Card No")
                {
                    StyleExpr = StyleText;
                }
                field("Account No"; Rec."Account No")
                {
                    StyleExpr = StyleText;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = StyleText;
                }
                field("Card Acceptor Terminal ID	"; Rec."Card Acceptor Terminal ID	")
                {
                    StyleExpr = StyleText;
                }
                field("Customer Names"; Rec."Customer Names")
                {
                    StyleExpr = StyleText;
                }
                field(Description; Rec.Description)
                {
                    StyleExpr = StyleText;
                }
                field("Is Coop Bank"; Rec."Is Coop Bank")
                {
                    StyleExpr = StyleText;
                }
                field("POS Vendor"; Rec."POS Vendor")
                {
                    StyleExpr = StyleText;
                }
                field("Trace ID"; Rec."Trace ID")
                {
                    StyleExpr = StyleText;
                }
                field(Posted; Rec.Posted)
                {
                    StyleExpr = StyleText;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = StyleText;
                }
                field("Posting S"; Rec."Posting S")
                {
                    StyleExpr = StyleText;
                }
                field("Process Code"; Rec."Process Code")
                {
                    StyleExpr = StyleText;
                }
                field("Reference No"; Rec."Reference No")
                {
                    StyleExpr = StyleText;
                }
                field(Reversed; Rec.Reversed)
                {
                    StyleExpr = StyleText;
                }
                field("Reversed Posted"; Rec."Reversed Posted")
                {
                    StyleExpr = StyleText;
                }
                field(Source; Rec.Source)
                {
                    StyleExpr = StyleText;
                }
                field("Trans Time"; Rec."Trans Time")
                {
                    StyleExpr = StyleText;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    StyleExpr = StyleText;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    StyleExpr = StyleText;
                }
                field("Transaction Type Charges"; Rec."Transaction Type Charges")
                {
                    StyleExpr = StyleText;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        StyleText := '';
        if Rec.Posted = true then
            StyleText := 'Subordinate'
        else begin
            case rec."Transaction Type Charges" of
                rec."Transaction Type Charges"::"Cash Withdrawal - Coop ATM":
                    StyleText := 'Strong';
                rec."Transaction Type Charges"::"Cash Withdrawal - VISA ATM":
                    StyleText := 'Favourable';
                else
                    StyleText := 'Ambigous';
            end;
        end;
    end;

    var

        StyleText: Text[100];
}
page 90113 "Guarantor Mgt."
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Guarantor Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Loan No"; Rec."Loan No")
                {
                }
                field("Member Name"; Rec."Member Name") { }
            }
            part("Substitution Lines"; "Guarantor Mgt. Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action("Populate Guarantor Lines")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    if Confirm('Do you want to populate guaranteed loans?') then begin
                        LoansMgt.PopulateGuarantorSubLines(rec."Document No");
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckGuarantorMgtApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendGuarantorMgtForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckGuarantorMgtApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelGuarantorMgtForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }


    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90114 "Guarantor Mgt. (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Guarantor Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Loan No"; Rec."Loan No") { }
                field("Member Name"; Rec."Member Name") { }
            }
            part("Substitution Lines"; "Guarantor Mgt. Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }

        }
    }


    actions
    {
        area(Processing)
        {

            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckGuarantorMgtApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelGuarantorMgtForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Process)
            {
                ApplicationArea = all;
                Image = Post;
                Promoted = true;
                trigger OnAction();
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    IF NOT CONFIRM('Are you sure you want to Process the document?') THEN
                        EXIT;
                    LoansMgt.ProcessGuarantorSubstitution(rec."Document No");
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90115 "Guarantor Mgt. Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Loan Principle"; Rec."Loan Principle") { }
                field("Loan Balance"; Rec."Loan Balance") { }
                field("Outstanding Guarantee"; Rec."Outstanding Guarantee") { }
                field(Substitution; Rec.Substitution) { }
                field(Release; Rec.Release) { }
                field("Document No"; "Document No") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Replacements)
            {
                action("Replace With")
                {
                    ApplicationArea = All;
                    RunObject = page "Guarantor Mgt. Det. Line";
                    RunPageLink = "Document No" = field("Document No"), "Line No" = field("Line No");
                }
            }
        }
    }
}
page 90116 "Guarantor Mgt. Det. Line"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Mgt. Det. Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Qualified Guarantee"; Rec."Qualified Guarantee") { }
                field("Self Guarantee"; Rec."Self Guarantee") { }
                field("Guarantee Amount"; Rec."Guarantee Amount") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90117 "New Member Exits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    CardPageId = "Member Exit Header";
    SourceTableView = where("Approval Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Posted; Rec.Posted) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90118 "Member Exit Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Exit Lines";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    StyleExpr = StyleText;
                }
                field("Account No"; Rec."Account No")
                {
                    StyleExpr = StyleText;
                }
                field("Account Name"; Rec."Account Name")
                {
                    StyleExpr = StyleText;
                }
                field(Balance; Rec.Balance)
                {
                    StyleExpr = StyleText;
                }
                field("Amount (Base)"; Rec."Amount (Base)")
                {
                    StyleExpr = StyleText;
                }
                field("Accrued Interest"; Rec."Accrued Interest") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        StyleText: Text[20];

    trigger OnAfterGetRecord()
    begin
        case Rec."Entry Type" of
            Rec."Entry Type"::Asset:
                StyleText := 'StrongAccent';
            Rec."Entry Type"::Liability:
                StyleText := 'Unfavorable';
            else
                StyleText := 'StandardAccent';
        end;
    end;
}

page 90119 "Member Exit Header"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; rec."Posting Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Instant; Rec.Instant) { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Withdrawal Type"; Rec."Withdrawal Type") { }
                field("Withdrawal Reason"; Rec."Withdrawal Reason") { }
                group(Analysis)
                {
                    field("Total Assets"; Rec."Total Assets") { }
                    field(Liabilities; Rec.Liabilities) { }
                    field(Guarantees; Rec.Guarantees) { }
                    field("Accrued Interest"; rec."Accrued Interest") { }
                    field("Net Amount"; Rec."Net Amount") { }
                }
            }
            part("Exit Lines"; "Member Exit Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Validate Assets & Liabilities")
            {
                ApplicationArea = All;
                Image = ApplyTemplate;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    if Confirm('Do you want to validate?') then begin
                        MemberMgt.PopulateMemberAssetsLiabilities(Rec."Document No");
                    end;
                end;
            }

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    rec.CalcFields(Guarantees, "Total Assets", Liabilities);
                    if Rec.Guarantees <> 0 then
                        Error('Please substitute the guarantors before processing member withdrawal');
                    if (((Rec."Total Assets" + Rec.Liabilities) < 0) AND (Rec."Withdrawal Type" <> Rec."Withdrawal Type"::Desceased)) then
                        Error('The Liabilities are higher than the assets. The member withdrawal cannot be processed');
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckMemberExitApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendMemberExitForApproval(Rec);
                        CurrPage.Close();
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberExitApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberExitForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90120 "Checkoffs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    CardPageId = "Checkoff Card";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90121 "Checkoff Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { Editable = false; }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Employer Code"; Rec."Employer Code") { }
                field(Amount; Rec.Amount) { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Upload Type"; Rec."Upload Type") { }
                field("Balancing Account Type"; Rec."Balancing Account Type") { }
                field("Balancing Account No"; Rec."Balancing Account No") { }
                field("Suspense Account"; Rec."Suspense Account") { }
                field("Charge Code"; Rec."Charge Code") { }
                group(Computations)
                {
                    field("Uploaded Amount"; Rec."Uploaded Amount") { }
                    field(Variance; rec.Variance) { }
                    field("Total Members"; rec."Total Members") { }
                }
            }
            part("Checkoff Lines"; "Checkoff Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CheckOffUpload: Record "Checkoff Upload";
                begin
                    CheckOffUpload.Reset();
                    CheckOffUpload.SetRange("Document No", rec."Document No");
                    if CheckOffUpload.FindSet() then
                        CheckOffUpload.DeleteAll();
                    Commit();
                    Clear(Import);
                    Import.SetCheckoffNo(Rec."Document No");
                    Import.Run();
                    ;
                end;
            }
            action(Calculate)
            {
                Image = Calculate;
                Promoted = true;
                trigger OnAction()
                var
                    CheckOff: Codeunit "Checkoff Management";
                begin
                    CheckOff.CalculateCheckoff(Rec."Document No");
                    CheckOff.CalculateCheckoffRecoveries(rec."Document No");
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    Rec.CalcFields("Uploaded Amount", "Total Members");
                    Rec.TestField(Amount, rec."Uploaded Amount");
                    rec.TestField("Posting Date");
                    Rec.TestField("Posting Description");
                    Rec.TestField(Rec."Total Members");
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckCheckOffApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendCheckOffForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelCheckOffForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                Image = PostApplication;
                Promoted = true;
                trigger OnAction()
                var
                    CheckOff: Codeunit "Checkoff Management";
                begin
                    rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to Post?') then begin
                        CheckOff.PostCheckoff(rec."Document No");
                    end;
                end;
            }
        }
    }

    var
        Import: XmlPort "Import Checkoff";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90122 "Checkoff Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checkoff Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Suspense Account"; rec."Suspense Account")
                {
                    StyleExpr = StyleText;
                }
                field("Member No"; Rec."Member No")
                {
                    StyleExpr = StyleText;
                }
                field("Check No"; Rec."Check No")
                {
                    StyleExpr = StyleText;
                }
                field("Member Name"; Rec."Member Name")
                {
                    StyleExpr = StyleText;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    StyleExpr = StyleText;
                }
                field("Collections Account"; Rec."Collections Account")
                {
                    StyleExpr = StyleText;
                }
                field("Amount Earned"; Rec."Amount Earned")
                {
                    StyleExpr = StyleText;
                }
                field(Recoveries; Rec.Recoveries)
                {
                    StyleExpr = StyleText;
                }
                field("Net Amount"; Rec."Net Amount") { }
                field("Running Loans"; "Running Loans")
                {
                    StyleExpr = StyleText;
                }
                field(Posted; Rec.Posted) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    var
        StyleText: Text[20];

    trigger OnAfterGetrecord()
    begin
        if Rec."Suspense Account" then
            StyleText := 'Unfavorable'
        else
            StyleText := 'StandardAccent';
    end;
}

page 90123 "Sacco Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sacco Transaction Types";
    CardPageId = "Transaction Type Setup";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Transaction Code"; Rec."Transaction Code") { }
                field("Transaction Description"; Rec."Transaction Description") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90124 "Transaction Type Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sacco Transaction Types";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Transaction Code"; Rec."Transaction Code") { }
                field("Transaction Description"; Rec."Transaction Description") { }
            }
            part("Charges"; "Transaction Charges")
            {
                SubPageLink = "Transaction Code" = field("Transaction Code");
            }
            part("Recoveries"; "Transaction Recoveries")
            {
                SubPageLink = "Transaction Code" = field("Transaction Code");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90125 "Transaction Charges"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Charges";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Description"; Rec."Charge Description") { }
                field("Post To Account Type"; Rec."Post To Account Type") { }
                field("Post to Account"; Rec."Post to Account") { }
                field("Calculation Type"; Rec."Calculation Type") { }
                field("Source Code"; Rec."Source Code") { }
            }
        }

    }

    actions
    {

        area(Processing)
        {
            group("Calculation Scheme")
            {
                action("Rates")
                {
                    ApplicationArea = All;
                    Image = StepInto;
                    RunObject = page "Transaction Calc. Scheme";
                    RunPageLink = "Transaction Code" = field("Transaction Code"), "Charge Code" = field("Charge Code");
                    trigger OnAction();
                    begin

                    end;
                }
            }
        }
    }
}
page 90126 "Transaction Calc. Scheme"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Calc. Scheme";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Lower Limit"; Rec."Lower Limit") { }
                field("Upper Limit"; Rec."Upper Limit") { }
                field("Rate Type"; Rec."Rate Type") { }
                field(Rate; Rec.Rate) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90127 "Transaction Recoveries"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Transaction Recoveries";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Recovery Type"; Rec."Recovery Type") { }
                field("Recovery Code"; Rec."Recovery Code") { }
                field("Recovery Descrition"; Rec."Recovery Descrition") { }
                field("Recovery Amount"; Rec."Recovery Amount") { }
                field(Prioirity; Rec.Prioirity) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90128 "Online Guarantor Requests"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Online Guarantor Requests";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;
                }
                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("ID No"; "ID No")
                {

                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Member No"; "Member No") { }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(PhoneNo; Rec.PhoneNo)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Loan Principal"; Rec."Loan Principal")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Loan Submitted"; Rec."Loan Submitted")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(AppliedAmount; Rec.AppliedAmount)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(Applicant; Rec.Applicant)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(ApplicantName; Rec.ApplicantName)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Amount Accepted"; Rec."Amount Accepted")
                {
                    Editable = isWindowsClient;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Editable = isWindowsClient;
                }
                field("Application Date"; "Application Date")
                {
                    Editable = isWindowsClient;
                }
                field("Loan Type"; "Loan Type")
                {
                    Editable = isWindowsClient;
                }
                field("Product Name"; "Product Name")
                {
                    Editable = isWindowsClient;
                }
                field("Created On"; "Created On")
                {
                    Editable = isWindowsClient;
                }
                field("Responded On"; "Responded On")
                {
                    Editable = isWindowsClient;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {


        }
    }
    var
        isWindowsClient: Boolean;

    trigger OnOpenPage()
    begin
        if CurrentClientType <> ClientType::Windows then
            isWindowsClient := true;
    end;
}
page 90129 "Dividend List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dividend Header";
    CardPageID = "Dividend Card";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Type"; Rec."Posting Type") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Posted; Rec.Posted) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90130 "Dividend Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dividend Header";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Type"; Rec."Posting Type")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Posting Description"; Rec."Posting Description") { }
                field("Charge Code"; rec."Charge Code") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Posted; Rec.Posted) { }
                group(Period)
                {
                    field("Start Date"; Rec."Start Date") { }
                    field("End  Date"; Rec."End  Date") { }
                }
                Group("Provisioning Information")
                {
                    field("Debit Account"; Rec."Debit Account")
                    {
                        Editable = isProvision;
                    }
                    field("Credit Account"; Rec."Credit Account")
                    {
                        Editable = isProvision;
                    }
                }
                group(Payments)
                {
                    field("Mobile Payments Control"; Rec."Mobile Payments Control") { }
                    field("Bank Transfers Control"; Rec."Bank Transfers Control") { }
                    field("Allocation Expiry Date"; Rec."Allocation Expiry Date") { }
                }
            }
            part("Dividend Parameters"; "Dividend Parameters")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            part("Dividend Lines"; "Dividend Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(Calculate)
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    DividendMgt: Codeunit "Dividend Management";
                begin
                    if Confirm('Do you want to calculate?') then begin
                        DividendMgt.CalculateDividend(Rec."Document No");
                    end;
                end;
            }
            action("Publish Allocations")
            {
                Image = PutawayLines;
                Promoted = true;
                trigger OnAction()
                var
                    DividendMgt: Codeunit "Dividend Management";
                begin
                    if Confirm('Do you want to publish allocations to the members portal?') then begin
                        DividendMgt.PublishAllocations(rec."Document No");
                    end;
                end;
            }
            action("Post Dividend")
            {
                Image = PostDocument;
                Promoted = true;
                trigger OnAction()
                var
                    DividendMgt: Codeunit "Dividend Management";
                begin
                    if Confirm('Do you want to Post?') then begin
                        DividendMgt.PostDividend(rec."Document No");
                    end;
                end;
            }
        }
    }

    var
        isProvision: Boolean;

    trigger OnAfterGetRecord()
    begin
        isProvision := (Rec."Posting Type" = rec."Posting Type"::Provision);
    end;

    trigger OnOpenPage()
    begin
        isProvision := (Rec."Posting Type" = rec."Posting Type"::Provision);
    end;

}
page 90131 "Dividend Parameters"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Parameters";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type") { }
                field("Account Description"; Rec."Account Description") { }
                field(Rate; Rec.Rate) { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Debit Account"; Rec."Debit Account")
                {
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90132 "Dividend Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No") { }
                field("Account No"; Rec."Account No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account Name"; Rec."Account Name") { }
                field("Account Type"; Rec."Account Type") { }
                field("Net Amount"; Rec."Net Amount")
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Amount Earned"; Rec."Amount Earned")
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Recoveries; Rec.Recoveries)
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Posted; Rec.Posted) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90133 "Dividend Detail Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Det. Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No") { }
                field("Entry Type"; Rec."Entry Type") { }
                field("Transaction Code"; Rec."Transaction Code") { }
                field("Transaction Description"; Rec."Transaction Description") { }
                field(Amount; Rec.Amount) { }
                field("Amount (Base)"; Rec."Amount (Base)") { }
                field("Post to Account Type"; Rec."Post to Account Type") { }
                field("Post To Account"; Rec."Post To Account") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90134 "New Member Reactivations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Activations";
    CardPageId = "Member Reactivation Card";
    SourceTableView = where("Approval Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90135 "Member Reactivation Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Activations";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                group(charges)
                {
                    field("Reactivation Fee"; Rec."Reactivation Fee")
                    {
                        ShowMandatory = true;
                    }
                    field("Reactivation Fee Amount"; Rec."Reactivation Fee Amount")
                    {
                        ShowMandatory = true;
                    }
                    field("Pay From Account Type"; Rec."Pay From Account Type")
                    {
                        ShowMandatory = true;
                    }
                    field("Pay From Account"; Rec."Pay From Account")
                    {
                        ShowMandatory = true;
                    }
                    field("Payment Refrence"; Rec."Payment Refrence")
                    {
                        ShowMandatory = true;
                    }
                }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckMemberActivationApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendMemberActivationForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberActivationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberActivationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90136 "Cheque Instructions"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Instructions";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Account Type"; Rec."Account Type") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field(Amount; Rec.Amount) { }
                field("Loan Balance"; Rec."Loan Balance") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90137 "Cheque Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field(Description; Rec.Description) { }
                field("Clearing Account"; Rec."Clearing Account") { }
                field("Clearing Charge Code"; Rec."Clearing Charge Code") { }
                field("Bouncing Charge Code"; Rec."Bouncing Charge Code") { }
                field("Express Clearing Charge Code"; Rec."Express Clearing Charge Code") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90138 "Cheques On Hand"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Deposits";
    CardPageId = "Cheque Deposit (RO)";
    SourceTableView = where("Document Status" = const(Received));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Cheque No"; Rec."Cheque No") { }
                field("Created By"; Rec."Created By") { }
                field("Document Status"; Rec."Document Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90139 "Cheque Deposit (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Deposits";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Marturity Period"; Rec."Marturity Period") { }
                field("Marturity Date"; Rec."Marturity Date") { }
            }
            group("Receiving Details")
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
            }
            part("Cheque Instructions"; "Cheque Instructions")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Cheque Details")
            {
                field("Cheque No"; Rec."Cheque No") { }
                field(Amount; Rec.Amount) { }
                field("Clearing Account No."; Rec."Clearing Account No.") { }
                field("Drawer Account Name"; Rec."Drawer Account Name") { }
                field("Drawer Bank"; Rec."Drawer Bank") { }
                field("Drawer Account No."; Rec."Drawer Account No.") { }
                field("Drawer Branch"; Rec."Drawer Branch") { }
                field("Clearing Charges"; Rec."Clearing Charges") { }
                field("Bouncing Charges"; Rec."Bouncing Charges") { }
                field("Express Clearing Charges"; Rec."Express Clearing Charges") { Editable = false; }
                field("Total Clearing Charges"; Rec."Total Clearing Charges") { }
                field("Instructions Amount"; Rec."Instructions Amount") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Clear Cheque")
            {
                Promoted = true;
                PromotedCategory = Category10;
                Image = Post;
                trigger OnAction()
                begin
                    IF confirm('Do you want to post?') then begin
                        FosaManagement.PostCheque(Rec."Document No", 0);
                    end;
                end;
            }
            action("Express Clear")
            {
                Promoted = true;
                PromotedCategory = Category10;
                Image = ApplyTemplate;
                trigger OnAction()
                begin
                    IF confirm('Do you want to post?') then begin
                        FosaManagement.PostCheque(Rec."Document No", 1);
                    end;
                end;
            }
            action(Reopen)
            {
                Promoted = true;
                PromotedCategory = Category10;
                Image = ReOpen;
                trigger OnAction()
                begin
                    IF confirm('Do you want to post?') then begin
                        FosaManagement.PostCheque(Rec."Document No", 3);
                    end;
                end;
            }
            action(Bounce)
            {
                Promoted = true;
                PromotedCategory = Category10;
                Image = CancelAllLines;
                trigger OnAction()
                begin
                    IF confirm('Do you want to post?') then begin
                        FosaManagement.PostCheque(Rec."Document No", 2);
                    end;
                end;
            }
            action(Archive)
            {
                Promoted = true;
                PromotedCategory = Category10;
                Image = VoidAllChecks;
                trigger OnAction()
                begin
                    IF confirm('Do you want to post?') then begin
                        FosaManagement.PostCheque(Rec."Document No", 4);
                    end;
                end;
            }
        }
    }

    var
        FosaManagement: Codeunit "FOSA Management";
}
page 90140 "Cleared Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Deposits";
    CardPageId = "Cheque Deposit (RO)";
    SourceTableView = where("Document Status" = filter(Cleared | Archived));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Cheque No"; Rec."Cheque No") { }
                field("Created By"; Rec."Created By") { }
                field("Document Status"; Rec."Document Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90141 "Bounced Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Deposits";
    CardPageId = "Cheque Deposit (RO)";
    SourceTableView = where("Document Status" = const(Bounced));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Deposit Date"; Rec."Deposit Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Cheque No"; Rec."Cheque No") { }
                field("Created By"; Rec."Created By") { }
                field("Document Status"; Rec."Document Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90142 "Running Standing Orders"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Standing Order";
    CardPageId = "Standing Order Card (RO)";
    SourceTableView = where("Approval Status" = const(Approved), Running = const(true), Terminated = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    Schdl: Codeunit "Scheduled Activities";
                    STOReg: Record "Standing Order";
                begin
                    /*STOReg.Reset();
                    if STOReg.FindSet() then begin
                        repeat
                            STOReg."Approval Status" := STOReg."Approval Status"::Approved;
                            STOReg.Running := true;
                            STOReg."Start Date" := DMY2Date(01, 01, 2022);
                            STOReg.Modify();
                        until STOReg.Next() = 0;
                    end;*/
                    Schdl.updateGLEntry();
                end;
            }
        }
    }
}
page 90143 "Standing Order Card (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Standing Order";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("STO Type"; Rec."STO Type") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Salary Based"; Rec."Salary Based") { }
            }
            group("Funds Source")
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Account No"; Rec."Account No") { }
                field("Start Date"; Rec."Start Date") { }
                field("End Date"; Rec."End Date") { }
                field(Period; Rec.Period) { }
            }
            group("Funds Destination")
            {
                field("Destination Member No"; Rec."Destination Member No") { }
                field("Destination Account"; Rec."Destination Account") { }
                field("Destination Name"; Rec."Destination Name") { }
                group("External Transfer Details")
                {
                    Editable = (Rec."Standing Order Class" = Rec."Standing Order Class"::External);
                    field("EFT Account Name"; Rec."EFT Account Name") { }
                    field("EFT Bank Name"; Rec."EFT Bank Name") { }
                    field("EFT Brannch Code"; Rec."EFT Brannch Code") { }
                    field("EFT Swift Code"; Rec."EFT Swift Code") { }
                    field("EFT Transfer Account No"; Rec."EFT Transfer Account No") { }
                    field("Payment Refrence Code"; "Policy No.") { }
                }
            }
            group("Operating Parameters")
            {
                field("Posting Description"; Rec."Posting Description") { }
                field("Run From Day"; Rec."Run From Day") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Running; Rec.Running) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Terminate)
            {
                ApplicationArea = All;
                Image = CancelAllLines;
                trigger OnAction()
                begin
                    rec.TestField(Rec.Running, true);
                    if Confirm('Do you want to Cancel?') then begin
                        Rec.Terminated := true;
                        Rec.Running := false;
                        Rec.modify;
                        CurrPage.Close();
                    end;
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                trigger OnAction()
                begin
                    //rec.TestField(rec."Approval Status", rec."Approval Status"::"Approval Pending");
                    if Confirm('Do you want to reopen?') then begin
                        rec."Approval Status" := Rec."Approval Status"::New;
                        rec.Running := false;
                        rec.Modify();
                    end;
                end;
            }

            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90144 "Terminated Standing Orders"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Standing Order";
    CardPageId = "Standing Order Card (RO)";
    SourceTableView = where("Approval Status" = const(Approved), Running = const(false), Terminated = const(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90145 "Pending Standing Orders"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Standing Order";
    CardPageId = "Standing Order Card (RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90146 "Standing Order Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "STO Types";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("STO Code"; Rec."STO Code") { }
                field(Description; Rec.Description) { }
                field("Charge Code"; "Charge Code") { }
                field("Default Account"; "Default Account") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90147 "Pending Fixed Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Fixed Deposit (RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90148 "Approved Fixed Deposits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Fixed Deposit (RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(Approved));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90149 "Fixed Deposit (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No."; Rec."Member No.") { }

                field("Member Name"; Rec."Member Name") { }
            }
            group("FD Details")
            {
                field("Marturity Instructions"; Rec."Marturity Instructions") { }
                field(Rate; Rec.Rate) { }
                field("FD Type"; Rec."FD Type") { }
                field("FD Description"; Rec."FD Description") { }
                field("Funds Source"; Rec."Funds Source") { }
                field("Source Account"; Rec."Source Account") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
            group(Computation)
            {
                field("Total Interest Payable"; Rec."Total Interest Payable") { }
                field("Total Interest Accrued"; Rec."Total Interest Accrued") { }
                field("Total Interest Balance"; Rec."Total Interest Balance") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Generate Schedule")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    FDManagement.CreateFixedDepositSchedule(Rec);
                end;
            }
            action("Activate Schedule")
            {
                ApplicationArea = all;
                trigger OnAction()
                begin
                    FDManagement.ActivateFD(Rec);
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.isMemberFixedDepositApprovalWorkflowEnabled(Rec) then
                        ApprovalsMgmtExt.OnSendMemberFixedDepositForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberFixedDepositApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberFixedDepositForApproval(Rec);
                end;
            }
        }
    }

    var
        FDManagement: codeunit "Fixed Deposit Mgt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90150 "Pending Bankers Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque";
    SourceTableView = where("Approval Status" = const("Approval Pending"), Posted = const(false));
    CardPageId = "Bankers Cheque (RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Source Type"; Rec."Source Type") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90151 "Approved Bankers Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque";
    SourceTableView = where("Approval Status" = const(Approved), Posted = const(false));
    CardPageId = "Bankers Cheque (RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Source Type"; Rec."Source Type") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90152 "Posted Bankers Cheques"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque";
    SourceTableView = where(Posted = const(true));
    CardPageId = "Bankers Cheque (RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Source Type"; Rec."Source Type") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90153 "Bankers Cheque (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bankers Cheque";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group("General Information")
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Walkin Allowed"; Rec."Walkin Allowed") { }
                field("Max. Amount"; Rec."Max. Amount") { }

            }
            group("Payment Details")
            {
                field("Source Type"; Rec."Source Type") { }
                field("Member No."; Rec."Member No.") { }
                field("Account Type"; Rec."Account Type") { }
                field("Account Name"; Rec."Account Name") { }
                field("Book Balance"; Rec."Book Balance") { }
                field("Payee Details"; Rec."Payee Details")
                {
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    rec.TestField("Approval Status", rec."Approval Status"::New);
                    if ApprovalsMgmtExt.isBankersChequeApprovalWorkflowEnabled(Rec) then
                        ApprovalsMgmtExt.OnSendBankersChequeForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    rec.TestField("Approval Status", Rec."Approval Status"::"Approval Pending");
                    if ApprovalsMgmtExt.CheckBankersChequeApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelBankersChequeForApproval(Rec);
                end;
            }
            action(Post)
            {
                Image = Post;
                trigger OnAction()
                begin
                    rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    Rec.TestField(Posted, false);
                    if Confirm('Do you want to Post?') then begin
                        FOSAManagement.PostBankersCheque(rec."Document No.");
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        FOSAManagement: Codeunit "FOSA Management";
}
page 90154 "Approved Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    CardPageId = "Approved Loan Card";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(Approved), Status = filter(<> Disbursed));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90155 "Approved Loan Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
                field(Approvals; Rec.Approvals) { }
            }
            group("Member Details")
            {
                Editable = isOpen;
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
            }
            group("Loan Details")
            {
                Editable = isOpen;
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field("Loan Period"; Rec.Installments)
                {
                    Caption = 'Loan Period';
                }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Rate Type"; Rec."Rate Type") { }
                field(Charges; Rec.Charges) { }
                field("Total Securities"; Rec."Total Securities") { }
            }
            group("&Approved Amount")
            {
                field("Recommended Amount"; Rec."Recommended Amount")
                {
                    Editable = false;
                }
                field("Approved Amount"; Rec."Approved Amount") { }
            }
            group("Repayment Details")
            {
                Editable = isOpen;
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Billing Account"; Rec."Billing Account") { }
                field("Approval Status"; Rec."Approval Status") { Editable = false; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                Image = ReopenCancelled;
                Promoted = true;
                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approval Mgmt. Ext";
                begin
                    IF Confirm('Do you want to reopen?') then begin
                        Rec."Approval Status" := Rec."Approval Status"::New;
                        Rec."Appraisal Commited" := false;
                        Rec.Modify();
                        Message('Reopenned Successfully');
                    end;
                    CurrPage.Close();
                end;
            }
            action(Guarantors)
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Loan Guarantors";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action("Print Appraisal")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                    LProduct: Record "Product Factory";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then begin
                        LProduct.Get(LoanApplication."Product Code");
                        if LProduct."Salary Based" then
                            Report.Run(Report::"FOSA Appraisal", true, false, LoanApplication)
                        else
                            Report.Run(Report::"Loan Appraisal", true, false, LoanApplication);
                    end;
                end;
            }
        }
        area(Creation)
        {
            action(Recoveries)
            {
                Image = StepOut;
                RunObject = page "Loan Recoveries";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Member Balances")
            {
                RunObject = page "Appraisal Account Balances";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Appraisal Parameters")
            {
                RunObject = page "Loan Appraisal Parameters";
                RunPageLink = "Loan No" = field("Application No");
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        LoansManagement: Codeunit "Loans Management";

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: Boolean;
}
page 90156 "Pending Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Application";
    CardPageId = "Approved Loan Card";
    SourceTableView = where(Posted = const(false), "Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Approvals; Rec.Approvals) { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90157 "Mobile Transactions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Transsactions";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No") { }
                field("Document No"; Rec."Document No") { }
                field("Transaction Type"; rec."Transaction Type") { }
                field("Cr_Member No"; Rec."Cr_Member No") { }
                field("Cr_Account No"; Rec."Cr_Account No") { }
                field("Dr_Member No"; Rec."Dr_Member No") { }
                field("Dr_Account No"; Rec."Dr_Account No") { }
                field(Amount; Rec.Amount) { }
                field(Narration; rec.Narration) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Posted; Rec.Posted) { }
                field("Posted On"; "Posted On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90158 "Economic Sectors"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Economic Sectors";
    CardPageId = "Economic Sector";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sector Code"; rEC."Sector Code") { }
                field("Sector Name"; rEC."Sector Name") { }
                field("Created By"; rEC."Created By") { }
                field("Created On"; rEC."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90159 "Economic Sector"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Economic Sectors";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Sector Code"; rEC."Sector Code") { }
                field("Sector Name"; rEC."Sector Name") { }
                field("Created By"; rEC."Created By") { }
                field("Created On"; rEC."Created On") { }
                part("Subsectors"; "Economic Subsectors")
                {
                    SubPageLink = "Sector Code" = field("Sector Code");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90160 "Economic Subsectors"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Economic Subsectors";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sub Sector Code"; Rec."Sub Sector Code") { }
                field("Sub Sector Name"; Rec."Sub Sector Name") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Sub Subsectors")
            {
                ApplicationArea = All;
                Image = StepInto;
                RunObject = page "Economic Sub-Subsectors";
                RunPageLink = "Sector Code" = field("Sector Code"), "Sub Sector Code" = field("Sub Sector Code");
            }
        }
    }
}
page 90161 "Economic Sub-Subsectors"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Economic Sub-subsector";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Sub-Subsector Code"; Rec."Sub-Subsector Code") { }
                field("Sub-Subsector Description"; Rec."Sub-Subsector Description") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90162 "Mobile Transaction Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Transaction Setup";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Transaction Code"; Rec."Transaction Code") { }
                field(Description; Rec.Description) { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Balancing Account No"; Rec."Balancing Account No") { }
                field("Minimum Amount"; "Minimum Amount") { }
                field("Maximum Amount"; "Maximum Amount") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90163 "Employers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employer Codes";
    CardPageId = Employer;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code) { }
                field(Name; Rec.Name) { }
                field("Phone No"; Rec."Phone No") { }
                field("Email Address"; Rec."Email Address") { }
                field("Checkoff Account"; Rec."Checkoff Account") { }
                field("Salary Account"; Rec."Salary Account") { }
                field("Suspense Account"; Rec."Suspense Account") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90164 Employer
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Employer Codes";

    layout
    {
        area(Content)
        {
            group(General)
            {

                field(Code; Rec.Code) { }
                field(Name; Rec.Name) { }
                field("Phone No"; Rec."Phone No") { }
                field("Email Address"; Rec."Email Address") { }
                field("Checkoff Account"; Rec."Checkoff Account") { }
                field("Salary Account"; Rec."Salary Account") { }
                field("Suspense Account"; Rec."Suspense Account") { }
            }
            part("Employer Stations"; "Employer Stations")
            {
                SubPageLink = "Employer Code" = field(Code);
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90165 "Employer Stations"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Employer Stations";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Station Code"; Rec."Station Code") { }
                field("Station Name"; Rec."Station Name") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90166 Counties
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Counties;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("County Code"; rec."County Code") { }
                field(Name; rec.Name) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90167 "Bankers Cheques Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bankers Cheque";
    CardPageId = "Bankers Cheque LookupCr";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Source Type"; Rec."Source Type") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90168 "Bankers Cheque LookupCr"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bankers Cheque";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group("General Information")
            {
                field("Cheque Type"; Rec."Cheque Type") { }
                field("Document No."; Rec."Document No.") { }
                field(Description; Rec.Description) { }
                field("Walkin Allowed"; Rec."Walkin Allowed") { }
                field("Max. Amount"; Rec."Max. Amount") { }

            }
            group("Payment Details")
            {
                field("Source Type"; Rec."Source Type") { }
                field("Member No."; Rec."Member No.") { }
                field("Account Type"; Rec."Account Type") { }
                field("Account Name"; Rec."Account Name") { }
                field("Book Balance"; Rec."Book Balance") { }
                field("Payee Details"; Rec."Payee Details")
                {
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field("Posting Date"; Rec."Posting Date") { }
                field(Amount; Rec.Amount) { }
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90169 "Fixed Deposits Lookp"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    CardPageId = "Fixed Deposit Lookup";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;

                }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90170 "Fixed Deposit Lookup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Fixed Deposit Register";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("FD No."; Rec."FD No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Posting Date"; Rec."Posting Date") { }
                field("Member No."; Rec."Member No.") { }

                field("Member Name"; Rec."Member Name") { }
            }
            group("FD Details")
            {
                field(Rate; Rec.Rate) { }
                field("FD Type"; Rec."FD Type") { }
                field("FD Description"; Rec."FD Description") { }
                field("Funds Source"; Rec."Funds Source") { }
                field("Source Account"; Rec."Source Account") { }
                field(Amount; Rec.Amount) { }
                field("Start Date"; Rec."Start Date") { }
                field(Period; Rec.Period) { }
                field("End Date"; Rec."End Date") { }
                field("Marturity Instructions"; Rec."Marturity Instructions") { }
            }
            group(Computation)
            {
                field("Total Interest Payable"; Rec."Total Interest Payable") { }
                field("Total Interest Accrued"; Rec."Total Interest Accrued") { }
                field("Total Interest Balance"; Rec."Total Interest Balance") { }
            }
        }
        area(FactBoxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
            part("Document Attachment Factbox"; "Document Attachment Factbox")
            {
                SubPageLink = "Table ID" = const(90020), "No." = field("FD No.");
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action("Accrue Interest")
            {
                Image = Position;
                Promoted = true;
                trigger OnAction()
                var
                    FixedDepositMgt: Codeunit "Fixed Deposit Mgt.";
                begin
                    if Confirm('Do you want to Accrue Fixed Deposit Interests?') then
                        FixedDepositMgt.PostFDAccrual(Rec);
                    CurrPage.Close();
                end;
            }
            action("Mature Fixed Deposit")
            {
                Image = Position;
                Promoted = true;
                trigger OnAction()
                var
                    FixedDepositMgt: Codeunit "Fixed Deposit Mgt.";
                begin
                    if Confirm('Do you want to mature the fixed Deposit?') then
                        FixedDepositMgt.MatureFixedDeposit(Rec);
                    CurrPage.Close();
                end;
            }
        }
    }

    var
        FDManagement: codeunit "Fixed Deposit Mgt.";
}
page 90171 "Pending ATM Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isEditable;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Application Type"; Rec."Application Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("ATM Type"; Rec."ATM Type") { }
                field("ATM Type Name"; Rec."ATM Type Name") { }
                field("Transaction Code"; "Transaction Code") { }
            }
            group("Card Details")
            {
                Editable = isApproved;
                field("Card No."; Rec."Card No.") { }
                field("ATM Collected By"; Rec."ATM Collected By") { }
                field("ATM Collected By ID No."; Rec."ATM Collected By ID No.") { }

            }
            group("Audit Trail")
            {
                Editable = isEditable;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reopen?') then
                        ApprovalsMgmtExt.OnCancelATMApplicationForApproval(Rec);
                end;
            }

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendATMApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelATMApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
        isEditable, isApproved : Boolean;

    trigger OnAfterGetRecord()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;

    trigger OnOpenPage()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;
}
page 90172 "Approved ATM Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Application Type"; Rec."Application Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account Name"; Rec."Account Name") { }
                field("ATM Type"; Rec."ATM Type") { }
                field("ATM Type Name"; Rec."ATM Type Name") { }
            }
            group("Card Details")
            {
                Editable = isApproved;
                field("Account No."; Rec."Account No.") { }
                field("Card No."; Rec."Card No.") { }
                field("ATM Collected By"; Rec."ATM Collected By") { }
                field("ATM Collected By ID No."; Rec."ATM Collected By ID No.") { }

            }
            group("Audit Trail")
            {
                Editable = false;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action("Post Linking")
            {
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    Rec.TestField("Card No.");
                    if Confirm('Do you want to Post') then
                        MemberMgt.PostATMLinking("Application No");
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
        isEditable, isApproved : Boolean;

    trigger OnAfterGetRecord()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;

    trigger OnOpenPage()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;
}

page 90173 "Processed ATM Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isEditable;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Application Type"; Rec."Application Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("ATM Type"; Rec."ATM Type") { }
                field("ATM Type Name"; Rec."ATM Type Name") { }
            }
            group("Card Details")
            {
                Editable = isApproved;
                field("Card No."; Rec."Card No.") { }
                field("ATM Collected By"; Rec."ATM Collected By") { }
                field("ATM Collected By ID No."; Rec."ATM Collected By ID No.") { }

            }
            group("Audit Trail")
            {
                Editable = isEditable;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendATMApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelATMApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
        isEditable, isApproved : Boolean;

    trigger OnAfterGetRecord()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;

    trigger OnOpenPage()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;
}
page 90174 "ATM Application (RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";

    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isEditable;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Application Type"; Rec."Application Type") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("ATM Type"; Rec."ATM Type") { }
                field("ATM Type Name"; Rec."ATM Type Name") { }
            }
            group("Card Details")
            {
                Editable = isApproved;
                field("Card No."; Rec."Card No.") { }
                field("ATM Collected By"; Rec."ATM Collected By") { }
                field("ATM Collected By ID No."; Rec."ATM Collected By ID No.") { }

            }
            group("Audit Trail")
            {
                Editable = isEditable;
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendATMApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckATMApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelATMApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
        isEditable, isApproved : Boolean;

    trigger OnAfterGetRecord()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;

    trigger OnOpenPage()
    begin
        isEditable := (rec."Approval Status" = rec."Approval Status"::New);
        isApproved := (rec."Approval Status" = rec."Approval Status"::Approved);
    end;
}
page 90175 "Pending ATM Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    CardPageId = "Pending ATM Application";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90176 "Approved ATM Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    CardPageId = "Approved ATM Application";
    SourceTableView = where("Approval Status" = const(Approved));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90177 "Processed ATM Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    CardPageId = "ATM Application";
    SourceTableView = where("Approval Status" = const(Approved), Processed = const(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90178 "ATM Applications Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ATM Application";
    CardPageId = "ATM Application (RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member ID"; Rec."Member ID") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90179 "New Loan Batches"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Header";
    SourceTableView = where("Approval Status" = const(New));
    CardPageId = "Loan Batch";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

        }
    }
}
page 90180 "Pending Loan Batches"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Header";
    CardPageId = "Loan Batch RO";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90181 "Approved Loan Batches"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Header";
    CardPageId = "Loan Batch RO";
    SourceTableView = where("Approval Status" = const(Approved), Posted = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90182 "Posted Loan Batches"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Header";
    CardPageId = "Loan Batch RO";
    SourceTableView = where(Posted = Const(True));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90183 "Loan Batches Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Header";
    CardPageId = "Loan Batch RO";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90184 "Loan Batch Lines"
{
    PageType = Listpart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Batch Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Loan No"; Rec."Loan No") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount")
                {

                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Principle Amount"; Rec."Principle Amount")
                {

                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Insurance Amount"; Rec."Insurance Amount")
                {

                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Total Recoveries"; Rec."Total Recoveries")
                {

                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Net Amount"; Rec."Net Amount")
                {

                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Posted; Rec.Posted) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90185 "Loan Batch"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Batch Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
            part("Loan Batch Lines"; "Loan Batch Lines")
            {
                SubPageLink = "Batch No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Schedule")
            {
                Image = Print;
                PromotedCategory = Report;
                Promoted = true;
                trigger OnAction()
                var
                    LoanBatch: Record "Loan Batch Header";
                begin
                    LoanBatch.Reset();
                    LoanBatch.SetRange("Document No", Rec."Document No");
                    if LoanBatch.FindSet() then
                        Report.RunModal(Report::"Disbursement Schedule", true, false, LoanBatch);
                end;
            }
            action("Import Loans")
            {
                ApplicationArea = All;
                Image = Import;
                trigger OnAction();
                var
                    LoanApplication: record "Loan Application";
                    LoanBatchLines: record "Loan Batch Lines";
                    LoansLookup: Page "Loans Lookup";
                begin
                    LoanBatchLines.Reset();
                    LoanBatchLines.SetRange("Batch No", Rec."Document No");
                    if LoanBatchLines.FindSet() then
                        LoanBatchLines.DeleteAll(true);
                    Commit();
                    LoanApplication.reset;
                    LoanApplication.SetRange("Loan Balance", 0);
                    LoanApplication.setrange("Loan Batch No.", '');
                    LoanApplication.setrange("Approval Status", LoanApplication."Approval Status"::Approved);
                    LoanApplication.SetRange(Posted, false);
                    if LoanApplication.findset then begin
                        clear(LoansLookup);
                        LoansLookup.SetParameters(0, Rec."Document No");
                        LoansLookup.LookUpMode := true;
                        LoansLookup.SetTableView(LoanApplication);
                        LoansLookup.RunModal();
                    end else
                        Message('There are no approved loans to add to the batch')
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanBacthApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendLoanBatchForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanBacthApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelLoanBatchForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
}
page 90186 "Loan Batch RO"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Batch Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    modifyallowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Description; Rec.Description) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
            part("Loan Batch Lines"; "Loan Batch Lines")
            {
                SubPageLink = "Batch No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Print Schedule")
            {
                Image = Print;
                PromotedCategory = Report;
                Promoted = true;
                trigger OnAction()
                var
                    LoanBatch: Record "Loan Batch Header";
                begin
                    LoanBatch.Reset();
                    LoanBatch.SetRange("Document No", Rec."Document No");
                    if LoanBatch.FindSet() then
                        Report.RunModal(Report::"Disbursement Schedule", true, false, LoanBatch);
                end;
            }

            action("Process Batch")
            {
                Image = ApplicationWorksheet;
                Promoted = true;
                trigger OnAction()
                var
                    LoansManagement: Codeunit "Loans Management";
                begin
                    rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to Process the Batch?'+' '+Rec."Document No") then begin
                        LoansManagement.PostBatch(Rec."Document No");
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanBacthApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelLoanBatchForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: codeunit "Approval Mgmt. Ext";
}
page 90187 "External Banks"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "External Banks";
    CardPageId = "Ext. Bank Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bank Code"; Rec."Bank Code") { }
                field("Bank Name"; Rec."Bank Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90188 "Branches"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "External Bank Branches";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Branch Code"; Rec."Branch Code") { }
                field("Branch Name"; Rec."Branch Name") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90189 "Ext. Bank Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "External Banks";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Bank Code"; Rec."Bank Code") { }
                field("Bank Name"; Rec."Bank Name") { }
                part(Branches; Branches)
                {
                    SubPageLink = "Bank Code" = field("Bank Code");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90190 "Pending Member Exits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    CardPageId = "Member Exit Header(RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Posted; Rec.Posted) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90191 "Approved Member Exits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    CardPageId = "Member Exit Header(RO)";
    SourceTableView = where("Approval Status" = const(Approved), Posted = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Posted; Rec.Posted) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90192 "Processed Member Exits"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    CardPageId = "Member Exit Header(RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Posted; Rec.Posted) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90193 "Member Exit Header(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Instant; Rec.Instant) { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Withdrawal Type"; Rec."Withdrawal Type") { }
                field("Withdrawal Reason"; Rec."Withdrawal Reason") { }
                group(Analysis)
                {
                    field("Total Assets"; Rec."Total Assets") { }
                    field(Liabilities; Rec.Liabilities) { }
                    field(Guarantees; Rec.Guarantees) { }
                }
            }
            part("Exit Lines"; "Member Exit Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberExitApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberExitForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Post?') then begin
                        MemberMgt.PostMemberExit(Rec."Document No");
                    end;
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        MemberMgt: Codeunit "Member Management";
}
page 90194 "Member Exits Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Exit Header";
    CardPageId = "Member Exit Header(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Posted; Rec.Posted) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90195 "Checkoff Upload Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checkoff Upload";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Check No"; Rec."Check No") { }
                field("Member Name"; Rec."Member Name") { }
                field(Amount; Rec.Amount) { }
                field(Remarks; Rec.Remarks) { }
                field(Refrence; Rec.Refrence) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90196 "Checkoff Calculations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Calculation";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Check No"; Rec."Check No") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field(Amount; Rec.Amount) { }
                field("Amount (Base)"; Rec."Amount (Base)") { }
                field("Entry Type"; Rec."Entry Type") { }
                field("Loan No"; Rec."Loan No") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}

page 90197 "Dividend Progression"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Progression";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No") { }
                field("Member No"; Rec."Member No") { }
                field("Account No"; Rec."Account No") { }
                field("Start Date"; Rec."Start Date") { }
                field("Closing Date"; Rec."Closing Date") { }
                field("Net Change"; Rec."Net Change")
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field(Ratio; Rec.Ratio) { }
                field("Rate Type"; Rec."Rate Type") { }
                field(Rate; Rec.Rate) { }
                field("Amount Earned"; Rec."Amount Earned")
                {
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90198 "New Guarantor Mgt."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Header";
    CardPageId = "Guarantor Mgt.";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90199 "Pending Guarantor Mgt."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Guarantor Mgt. (RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90200 "Approved Guarantor Mgt."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Approval Status" = const(Approved));
    CardPageId = "Guarantor Mgt. (RO)";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90201 "Posted Guarantor Mgt."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Approval Status" = const(Approved), Processed = const(true));
    CardPageId = "Guarantor Mgt. (RO)";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90202 "Guarantor Mgt. Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Guarantor Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Approval Status" = const(Approved), Processed = const(true));
    CardPageId = "Guarantor Mgt. (RO)";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90203 "New Loan Recovery"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Header";
    SourceTableView = where("Approval Status" = const(New));
    CardPageId = "Loan Recovery";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90204 "Pending Loan Recovery"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Header";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Loan Recovery(RO)";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90205 "Approved Loan Recovery"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Header";
    SourceTableView = where("Approval Status" = const(Approved), Processed = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Loan Recovery(RO)";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReOpen)
            {
                Image = ReOpen;
                trigger OnAction()
                begin
                    if Confirm('Do you want to reopen?') then begin
                        Rec."Approval Status" := Rec."Approval Status"::New;
                        Rec.Modify();
                        Message('Document Reopenned Successfully');
                    end;
                end;
            }
            action("Post Recovery")
            {
                ApplicationArea = All;
                Image = Post;
                trigger OnAction();
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    rec.TestField("Approval Status", rec."Approval Status"::Approved);
                    if Confirm('Do you want to post?') then begin
                        LoansMgt.PostLoanRecovery(rec."Document No");
                    end;
                end;
            }
        }
    }
}
page 90206 "Posted Loan Recovery"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Header";
    CardPageId = "Loan Recovery(RO)";
    SourceTableView = where("Approval Status" = const(Approved), Processed = const(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90207 "Loan Recovery Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    CardPageId = "Loan Recovery(RO)";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90208 "Loan Recovery Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovery Lines";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member Deposits"; Rec."Member Deposits") { }
                field("Outstanding Guarantee"; Rec."Outstanding Guarantee") { }
                field("Recovery Type"; Rec."Recovery Type") { }
                field("Recovery Amount"; Rec."Recovery Amount") { }
                field("Product Code"; rec."Product Code") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90209 "Loan Recovery"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Recovery Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { Editable = false; }
                field("Posting Date"; Rec."Posting Date") { }
            }
            group("Member Info")
            {
                field("Member No"; Rec."Member No") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Loan Balance"; Rec."Loan Balance") { }
                field("Accrued Interest"; Rec."Accrued Interest") { }
                field("Total Recoverable"; Rec."Total Recoverable") { }
                field("Self Recovery Amount"; Rec."Self Recovery Amount") { }
                field("Guarantor Recovery"; rec."Guarantor Deposit Recovery") { }
                field("Guarantor Liability Recovery"; Rec."Guarantor Liability Recovery") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member Deposits"; Rec."Member Deposits") { }
                field("Member Balances"; "Member Balances")
                {
                    StyleExpr = 'Strong';
                }
            }
            part("Recovery Lines"; "Loan Recovery Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Aportion Loan Balance")
            {
                Image = Calculate;
                trigger OnAction()
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    CalcFields("Self Recovery Amount");
                    if "Self Recovery Amount" <> 0 then
                        Error('You Cannot Combine Self Recovery and Guarantor Recovery');
                    if Confirm('Do you want to Aportion?') then
                        LoansMgt.PopulateGuarantorRatios("Document No");
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                var
                    TotalRecovery, TotalRecoverable : Decimal;
                begin
                    rec.CalcFields("Guarantor Deposit Recovery", "Guarantor Liability Recovery", "Self Recovery Amount");
                    TotalRecovery := (Rec."Guarantor Deposit Recovery" + rec."Self Recovery Amount" + rec."Guarantor Liability Recovery");
                    TotalRecoverable := Rec."Total Recoverable";
                    TotalRecoverable := Round(TotalRecoverable, 1, '=');
                    TotalRecovery := Round(TotalRecovery, 1, '=');
                    if TotalRecovery > TotalRecoverable then
                        Error('You cannot recover more than the loan balance of %1 %2', "Total Recoverable", (Rec."Guarantor Deposit Recovery" + rec."Self Recovery Amount" + rec."Guarantor Liability Recovery"));
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckLoanRecoveryApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendLoanRecoveryForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanRecoveryApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelLoanRecoveryForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90210 "Loan Recovery(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Loan Recovery Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { Editable = false; }
                field("Posting Date"; Rec."Posting Date") { }
            }
            group("Member Info")
            {
                field("Member No"; Rec."Member No") { }
                field("Loan No"; Rec."Loan No") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Loan Balance"; Rec."Loan Balance") { }
                field("Accrued Interest"; Rec."Accrued Interest") { }
                field("Total Recoverable"; Rec."Total Recoverable") { }
                field("Self Recovery Amount"; Rec."Self Recovery Amount") { }
                field("Member Name"; Rec."Member Name") { }
                field("Member Deposits"; Rec."Member Deposits") { }
            }
            part("Recovery Lines"; "Loan Recovery Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Recovery")
            {
                ApplicationArea = All;
                Image = Post;
                trigger OnAction();
                var
                    LoansMgt: Codeunit "Loans Management";
                begin
                    rec.TestField("Approval Status", rec."Approval Status"::Approved);
                    if Confirm('Do you want to post?') then begin
                        LoansMgt.PostLoanRecovery(rec."Document No");
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanRecoveryApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendLoanRecoveryForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckLoanRecoveryApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelLoanRecoveryForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90211 "Defaulter Notice(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Notice Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Notice Date"; Rec."Notice Date") { }
                field("First Notice Sent On"; Rec."First Notice Sent On") { }
                field("Second Notice Sent On"; Rec."Second Notice Sent On") { }
                field("Third Notice Sent On"; Rec."Third Notice Sent On") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
            }
            part("Notice Lines"; "Notice Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90212 "Pending Member Reactivations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Activations";
    CardPageId = "Member Reactivation Card(RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90213 "Approved Member Reactivations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Activations";
    CardPageId = "Member Reactivation Card(RO)";
    SourceTableView = where("Approval Status" = const(Approved), Posted = const(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90214 "Posted Member Reactivations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Activations";
    CardPageId = "Member Reactivation Card(RO)";
    SourceTableView = where("Approval Status" = const(Approved), Posted = const(true));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Posted; Rec.Posted) { }
                field("Posted By"; Rec."Posted By") { }
                field("Posted On"; Rec."Posted On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90215 "Member Reactivations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Activations";
    CardPageId = "Member Reactivation Card(RO)";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90216 "Member Reactivation Card(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Member Activations";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                group(charges)
                {
                    field("Reactivation Fee"; Rec."Reactivation Fee")
                    {
                        ShowMandatory = true;
                    }
                    field("Reactivation Fee Amount"; Rec."Reactivation Fee Amount")
                    {
                        ShowMandatory = true;
                    }
                    field("Pay From Account Type"; Rec."Pay From Account Type")
                    {
                        ShowMandatory = true;
                    }
                    field("Pay From Account"; Rec."Pay From Account")
                    {
                        ShowMandatory = true;
                    }
                    field("Payment Refrence"; Rec."Payment Refrence")
                    {
                        ShowMandatory = true;
                    }
                }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to reactivate the member') then begin
                        MemberMgt.ActivateMember(Rec."Document No");
                    end;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckMemberActivationApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendMemberActivationForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMemberActivationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnCancelMemberActivationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }

        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90217 "Pending Allocations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Allocations";
    SourceTableView = where("Member Allocated" = const(false));
    CardPageId = "Dividend Allocation Card";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Dividend Code"; Rec."Dividend Code") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field("Pubished On"; Rec."Pubished On") { }
                field("Expiry Date"; Rec."Expiry Date") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Published; Rec.Published) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90218 "Submitted Allocations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dividend Allocations";
    SourceTableView = where("Member Allocated" = const(true));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Dividend Allocation Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Dividend Code"; Rec."Dividend Code")
                {
                    StyleExpr = StyleText;
                }
                field("Member No"; Rec."Member No")
                {
                    StyleExpr = StyleText;
                }
                field("Member Name"; Rec."Member Name")
                {
                    StyleExpr = StyleText;
                }
                field("Account No"; Rec."Account No")
                {
                    StyleExpr = StyleText;
                }
                field("Account Name"; Rec."Account Name")
                {
                    StyleExpr = StyleText;
                }
                field("Pubished On"; Rec."Pubished On")
                {
                    StyleExpr = StyleText;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    StyleExpr = StyleText;
                }
                field("Allocated By"; Rec."Allocated By")
                {
                    StyleExpr = StyleText;
                }
                field("Allocation Date"; Rec."Allocation Date")
                {
                    StyleExpr = StyleText;
                }
                field("Allocation Type"; Rec."Allocation Type")
                {
                    StyleExpr = StyleText;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
        }
    }
    var
        StyleText: Text[50];

    trigger OnAfterGetRecord()
    begin
        case rec."Allocation Type" of
            rec."Allocation Type"::"Bank Transfer":
                StyleText := 'StandardAccent';
            rec."Allocation Type"::Capitalize:
                StyleText := 'StrongAccent';
            rec."Allocation Type"::"Loan Repayment":
                StyleText := 'Ambiguous';
            rec."Allocation Type"::"Mobile Money":
                StyleText := 'Attention';
            else
                StyleText := 'Ambiguous';
        end;
    end;
}
page 90219 "Dividend Allocation Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dividend Allocations";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Dividend Code"; Rec."Dividend Code") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field("Gross Amount"; Rec."Gross Amount") { }
                field(Charges; Rec.Charges) { }
                field("Net Amount"; Rec."Net Amount") { }
            }
            group(Allocation)
            {
                field("Allocation Type"; Rec."Allocation Type")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                    Editable = isMobileMoney;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    Editable = isBankAllocation;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Editable = isBankAllocation;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    Editable = isBankAllocation;
                }
                field("Capitalize to Account"; Rec."Capitalize to Account")
                {
                    Editable = isCapitalization;
                }
                field("Loan No"; Rec."Loan No")
                {
                    Editable = isLoanAllocation;
                }
            }
            group("Audit Trail")
            {
                Editable = false;
                field("Pubished On"; Rec."Pubished On") { }
                field("Expiry Date"; Rec."Expiry Date") { }
                field("Allocated By"; Rec."Allocated By") { }
                field("Allocation Date"; Rec."Allocation Date") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Submit Allocation")
            {
                ApplicationArea = All;
                Enabled = isPublished;
                trigger OnAction()
                begin
                    if Confirm('Do you want to Publish the dividend allocation?') then begin
                        DividendMgt.SubmitDividendAllocation(rec."Dividend Code", rec."Member No", Rec."Account No");
                    end;
                end;
            }
        }
    }

    var
        DividendMgt: Codeunit "Dividend Management";
        isBankAllocation, isMobileMoney, isCapitalization, isLoanAllocation, isPublished : boolean;
    trigger OnAfterGetRecord()
    begin
        SetLookandFeel();
    end;

    trigger OnOpenPage()
    begin
        SetLookandFeel();
    end;

    local procedure SetLookandFeel()
    var
    begin
        isPublished := rec.Published;
        Case Rec."Allocation Type" of
            rec."Allocation Type"::"Bank Transfer":
                begin
                    isBankAllocation := true;
                    isMobileMoney := false;
                    isCapitalization := false;
                    isLoanAllocation := false;
                end;
            rec."Allocation Type"::Capitalize:
                begin
                    isCapitalization := true;
                    isMobileMoney := false;
                    isBankAllocation := false;
                    isLoanAllocation := false;
                end;
            rec."Allocation Type"::"Mobile Money":
                begin
                    isMobileMoney := true;
                    isCapitalization := false;
                    isBankAllocation := false;
                    isLoanAllocation := false;
                end;
            Rec."Allocation Type"::"Loan Repayment":
                begin
                    isLoanAllocation := true;
                    isMobileMoney := false;
                    isBankAllocation := false;
                    isMobileMoney := false;
                    isCapitalization := false;
                    isBankAllocation := false;
                    isLoanAllocation := false;
                end;
        End;
    end;
}
page 90220 "Pending Checkoffs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    CardPageId = "Checkoff Card(RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const("Approval Pending"));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90221 "Approved Checkoffs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    CardPageId = "Checkoff Card(RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(Approved));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90222 "Posted Checkoffs"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    CardPageId = "Checkoff Card(RO)";
    SourceTableView = where(Posted = const(true), "Approval Status" = const(Approved));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
                field("Employer Code"; Rec."Employer Code") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90223 "Checkoff Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    CardPageId = "Checkoff Card(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90224 "Checkoff Card(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { Editable = false; }
                field("Document Date"; Rec."Document Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Employer Code"; Rec."Employer Code") { }
                field(Amount; Rec.Amount) { }
                field("Posting Description"; Rec."Posting Description") { }
                field("Upload Type"; Rec."Upload Type") { }
                field("Balancing Account Type"; Rec."Balancing Account Type") { }
                field("Balancing Account No"; Rec."Balancing Account No") { }
                field("Suspense Account"; Rec."Suspense Account") { }
                field("Charge Code"; Rec."Charge Code") { }
                group(Computations)
                {
                    field("Uploaded Amount"; Rec."Uploaded Amount") { }
                    field(Variance; rec.Variance) { }
                }
            }
            part("Checkoff Lines"; "Checkoff Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reopen)
            {
                Image = ReopenCancelled;
                Promoted = true;
                trigger OnAction()
                begin
                    rec.TestField(Posted, false);
                    if Confirm('Do you want to reopen?') then begin
                        rec."Approval Status" := rec."Approval Status"::New;
                        rec.Modify();
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelCheckOffForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                Image = PostApplication;
                Promoted = true;
                trigger OnAction()
                var
                    CheckOff: Codeunit "Checkoff Management";
                begin
                    rec.TestField(Rec."Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to Post?') then begin
                        CheckOff.PostCheckoff(rec."Document No");
                    end;
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90225 "Document Uploads"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Document Uploads";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No")
                {
                    Editable = isSOAP;
                }
                field("Parent Type"; Rec."Parent Type")
                {
                    Editable = isSOAP;
                }
                field("Parent No"; Rec."Parent No")
                {
                    Editable = isSOAP;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = isSOAP;
                }
                field("Document No"; Rec."Document No")
                {
                    Editable = isSOAP;
                }
                field(URL; Rec.URL)
                {
                    Editable = isSOAP;
                }
                field("Added By"; Rec."Added By")
                {
                    Editable = isSOAP;
                }
                field("Added On"; Rec."Added On")
                {
                    Editable = isSOAP;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        isSOAP: Boolean;

    trigger OnOpenPage()
    begin
        isSOAP := (CurrentClientType <> ClientType::Windows);
    end;
}
page 90226 "Online Guarantor Sub Requests"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Online Guarantor Sub.";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No")
                {
                    Editable = isSoap;
                }
                field("Guarantor No"; Rec."Guarantor No")
                {
                    Editable = isSoap;
                }
                field("Replace With"; Rec."Replace With")
                {
                    Editable = isSoap;
                }
                field("Replace With Name"; Rec."Replace With Name")
                {
                    Editable = isSoap;
                }
                field("Loan Balance"; Rec."Loan Balance")
                {
                    Editable = isSoap;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = isSoap;
                }
                field(Status; Rec.Status)
                {
                    Editable = isSoap;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        isSoap: Boolean;

    trigger OnOpenPage()
    begin
        isSoap := (CurrentClientType <> ClientType::Windows);
    end;
}
page 90227 "Sub Counties"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sub Counties";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("County Code"; Rec."County Code") { }
                field("Sub County Code"; Rec."Sub County Code") { }
                field("Sub County Name"; Rec."Sub County Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90228 "Cheque Book Types"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Book Types";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
                field(Description; Rec.Description) { }
                field("Clearing Bank Code"; Rec."Clearing Bank Code") { }
                field("Clearing Charge Code"; Rec."Clearing Charge Code") { }
                field("Leaf Charge"; Rec."Leaf Charge") { }
                field("Cheque Books"; rec."Cheque Books") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90229 "New Cheque Book Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Book Applications";
    SourceTableView = where(Processed = const(false), "Approval Status" = const(New));
    CardPageId = "Cheque Book Application";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90230 "Pending Cheque Book App."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Book Applications";
    SourceTableView = where(Processed = const(false), "Approval Status" = const("Approval Pending"));
    CardPageId = "Cheque Book Application(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90231 "Approved Cheque Book App."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Book Applications";
    SourceTableView = where(Processed = const(false), "Approval Status" = const(Approved));
    CardPageId = "Cheque Book Application(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90232 "Processed Cheque Book App."
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Book Applications";
    SourceTableView = where(Processed = const(true), "Approval Status" = const(Approved));
    CardPageId = "Cheque Book Application(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
                field("Charge Amount"; Rec."Charge Amount") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90233 "Cheque Book Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Book Applications";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Application No"; Rec."Application No")
                {
                    Editable = isSOAP;
                }
                field("Application Date"; Rec."Application Date") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
            }
            group("Member Information")
            {
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Amount"; Rec."Charge Amount") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckChequeBookApplicationApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendChequeBookApplicationForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelChequeBookApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isSOAP: Boolean;

    trigger OnOpenPage()
    begin
        isSOAP := (CurrentClientType <> ClientType::Windows);
    end;
}
page 90234 "Cheque Book Application(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Book Applications";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = false;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Cheque Book Type"; Rec."Cheque Book Type") { }
            }
            group("Member Information")
            {
                Editable = false;
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account No"; Rec."Account No") { }
                field("Account Name"; Rec."Account Name") { }
                field("No. of Leafs"; Rec."No. of Leafs") { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Amount"; Rec."Charge Amount") { }
            }
            group(Collection)
            {
                Editable = isPendingCollection;
                field("Serial No"; Rec."Serial No")
                {
                    ShowMandatory = true;
                }
                field("Collected By Name"; Rec."Collected By Name")
                {
                    ShowMandatory = true;
                }
                field("Collected By ID No"; Rec."Collected By ID No")
                {
                    ShowMandatory = true;
                }
                field("Collected By Phone No"; Rec."Collected By Phone No")
                {
                    ShowMandatory = true;
                }
                field("Collected On"; Rec."Collected On")
                {
                    ShowMandatory = true;
                }
                field("Collected At"; Rec."Collected At")
                {
                    ShowMandatory = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckChequeBookApplicationApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendChequeBookApplicationForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelChequeBookApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        isPendingCollection: Boolean;
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";

    trigger OnOpenPage()
    begin
        isPendingCollection := ((rec."Approval Status" = rec."Approval Status"::Approved) and (Rec.Processed = false));
    end;

    trigger OnAfterGetRecord()
    begin
        isPendingCollection := ((rec."Approval Status" = rec."Approval Status"::Approved) and (Rec.Processed = false));
    end;
}

page 90235 "Signatories & Directors"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Group & Company Members";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Designation; Rec.Designation) { }
                field("Full Name"; Rec."Full Name") { }
                field("National ID No"; Rec."National ID No") { }
                field("Phone No"; Rec."Phone No") { }
                field("Source Code"; Rec."Source Code")
                {
                    Visible = NOT IsWindowsClient;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Images)
            {
                ApplicationArea = All;
                RunObject = page "Signatory Images";
                RunPageLink = "Entry No." = field("Entry No."), "Source Code" = field("Source Code"), Type = field(Type);
            }
        }
    }
    var
        IsWindowsClient: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsWindowsClient := (CurrentClientType = ClientType::Windows);
    end;

    trigger OnOpenPage()
    begin
        IsWindowsClient := (CurrentClientType = ClientType::Windows);
    end;
}

page 90236 "Signatory Images"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Group & Company Members";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Passport Image"; Rec."Passport Image") { }
                field(Signature; Rec.Signature) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90237 "New Inter Acc. Transfers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Inter Account Transfer";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New));
    CardPageId = "Inter Account Transfer";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Account"; Rec."Destination Account") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90238 "Pending Inter Acc. Transfers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Inter Account Transfer";
    SourceTableView = where(Posted = const(false), "Approval Status" = const("Approval Pending"));
    CardPageId = "Inter Account Transfer(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Account"; Rec."Destination Account") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90239 "Approved Inter Acc. Transfers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Inter Account Transfer";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(Approved));
    CardPageId = "Inter Account Transfer(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Account"; Rec."Destination Account") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90240 "Posted Inter Acc. Transfers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Inter Account Transfer";
    SourceTableView = where(Posted = const(true));
    CardPageId = "Inter Account Transfer(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Account"; Rec."Destination Account") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90241 "Inter Acc. Transfers"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Inter Account Transfer";
    CardPageId = "Inter Account Transfer(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Account"; Rec."Destination Account") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90242 "Inter Account Transfer"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Inter Account Transfer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
            }
            group("Source Details")
            {
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Transfer From"; Rec."Transfer From") { }
                field("Source Balance"; Rec."Source Balance") { }
            }
            group("Transfer Amount")
            {
                field(Amount; Amount) { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Amount"; Rec."Charge Amount") { }
            }
            group(Destination)
            {
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Name"; Rec."Destination Name") { }
                field("Destination Account"; Rec."Destination Account") { }
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Posted; Rec.Posted) { }
                field("Posted On"; Rec."Posted On") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckInterAccountTransferApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendInterAccountTransferForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelInterAccountTransferForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90243 "Inter Account Transfer(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Inter Account Transfer";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Description"; Rec."Posting Description") { }
            }
            group("Source Details")
            {
                field("Member No"; Rec."Member No") { }
                field("Source Name"; Rec."Source Name") { }
                field("Transfer From"; Rec."Transfer From") { }
                field("Source Balance"; Rec."Source Balance") { }
            }
            group("Transfer Amount")
            {
                field(Amount; Amount) { }
                field("Charge Code"; Rec."Charge Code") { }
                field("Charge Amount"; Rec."Charge Amount") { }
            }
            group(Destination)
            {
                field("Destination Member"; Rec."Destination Member") { }
                field("Destination Name"; Rec."Destination Name") { }
                field("Destination Account"; Rec."Destination Account") { }
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Posted; Rec.Posted) { }
                field("Posted On"; Rec."Posted On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckInterAccountTransferApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendInterAccountTransferForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelInterAccountTransferForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    Rec.TestField("Approval Status", Rec."Approval Status"::Approved);
                    if Confirm('Do you want to Post?') then
                        FosaMgt.PostInterAccountTransfer(Rec."Document No");
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        FosaMgt: Codeunit "FOSA Management";
}

page 90244 "New Account Openning"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Account Openning";
    SourceTableView = where("Approval Status" = const(New));
    CardPageId = "Account Openning";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Type"; Rec."Product Type") { }
                field("Product Name"; Rec."Product Name") { }
                field("Juniour Account"; Rec."Juniour Account") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90245 "Pending Account Openning"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Account Openning";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    CardPageId = "Account Openning(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Type"; Rec."Product Type") { }
                field("Product Name"; Rec."Product Name") { }
                field("Juniour Account"; Rec."Juniour Account") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90246 "Processed Account Openning"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Account Openning";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    CardPageId = "Account Openning(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Type"; Rec."Product Type") { }
                field("Product Name"; Rec."Product Name") { }
                field("Juniour Account"; Rec."Juniour Account") { }
                field("Created On"; Rec."Created On") { }
                field("Created By"; Rec."Created By") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90247 "Account Openning"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Account Openning";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Type"; Rec."Product Type")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Product Name"; Rec."Product Name") { }
            }
            group("Juniour Account Details")
            {
                Visible = isJuniour;
                field("Full Name"; Rec."Full Name") { }
                field("Birth Certificate No"; Rec."Birth Certificate No") { }
                field("Birth Notification No"; Rec."Birth Notification No") { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field("Child Image"; Rec."Child Image") { }
            }
            group("Audit Trail")
            {
                field("Approval Status"; Rec."Approval Status") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Juniour Account"; Rec."Juniour Account") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckAccountOpenningApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendAccountOpenningForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelaccountOpenningForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        isJuniour := "Juniour Account";
    end;

    var
        isJuniour: Boolean;
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90248 "Account Openning(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Account Openning";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Product Type"; Rec."Product Type")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Product Name"; Rec."Product Name") { }
            }
            group("Juniour Account Details")
            {
                Visible = isJuniour;
                field("Full Name"; Rec."Full Name") { }
                field("Birth Certificate No"; Rec."Birth Certificate No") { }
                field("Birth Notification No"; Rec."Birth Notification No") { }
                field("Date of Birth"; Rec."Date of Birth") { }
                field("Child Image"; Rec."Child Image") { }
            }
            group("Audit Trail")
            {
                field("Approval Status"; Rec."Approval Status") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Juniour Account"; Rec."Juniour Account") { }
            }
        }
    }

    actions
    {

        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do you want to send approval request?') then begin
                        if ApprovalsMgmtExt.CheckAccountOpenningApprovalsWorkflowEnable(Rec) then
                            ApprovalsMgmtExt.OnSendAccountOpenningForApproval(Rec);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    if Confirm('Do yoy want to cancel?') then
                        ApprovalsMgmtExt.OnCancelaccountOpenningForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        isJuniour := rec."Juniour Account";
    end;

    var
        isJuniour: Boolean;
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}

page 90249 "Loan Collateral"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Securities";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Security Code"; Rec."Security Code") { }
                field(Description; Rec.Description) { }
                field("Security Value"; Rec."Security Value") { }
                field("Outstanding Value"; Rec."Outstanding Value") { }
                field(Guarantee; Rec.Guarantee) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90250 "New Bulk SMS"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bulk SMS Header";
    SourceTableView = where(Sent = const(false));
    CardPageId = "Bulk SMS Card";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90251 "Sent Bulk SMS"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bulk SMS Header";
    SourceTableView = where(Sent = const(true));
    CardPageId = "Bulk SMS Card(RO)";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90252 "Bulk SMS Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Bulk SMS Lines";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Full Name"; Rec."Full Name") { }
                field("Phone No"; Rec."Phone No") { }
                field(Sent; Rec.Sent) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90253 "Bulk SMS Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bulk SMS Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("SMS Message"; Rec."SMS Message")
                {
                    MultiLine = true;
                }
            }
            part("Bulk SMS Lines"; "Bulk SMS Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Sent; Rec.Sent) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    BulkSMSLines: Record "Bulk SMS Lines";
                begin
                    BulkSMSLines.Reset();
                    BulkSMSLines.SetRange("Document No", rec."Document No");
                    if BulkSMSLines.FindSet() then
                        BulkSMSLines.DeleteAll();
                    Commit();
                    Clear(BulkSMSUpload);
                    BulkSMSUpload.SetBulkSMSNo(Rec."Document No");
                    BulkSMSUpload.Run();
                    ;
                end;
            }
            action("Populate All Members")
            {
                Image = Vendor;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    MemberMgt.SendBulkSMS(rec."Document No");
                end;
            }
            action(Process)
            {
                Image = Email;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    MemberMgt.SendBulkSMS(rec."Document No");
                end;
            }
        }
    }

    var
        myInt: Integer;
        BulkSMSUpload: xmlport "Import BulkSMS";
}
page 90254 "Bulk SMS Card(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Bulk SMS Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("SMS Message"; Rec."SMS Message")
                {
                    MultiLine = true;
                }
            }
            part("Bulk SMS Lines"; "Bulk SMS Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Sent; Rec.Sent) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90255 "Member Subscriptions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Member Subscriptions";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Code"; Rec."Source Code") { }
                field("Account Type"; Rec."Account Type") { }
                field("Account Name"; Rec."Account Name") { }
                field("Start Date"; Rec."Start Date") { }
                field(Amount; Rec.Amount) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90256 "New Checkoff Variations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Variation Header";
    SourceTableView = where(Processed = const(false), "Portal Status" = const(New));
    CardPageId = "Checkoff Variation";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Processed; Rec.Processed) { }
                field("Portal Status"; "Portal Status") { }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CheckOffVariation: Record "Checkoff Variation Header";
                begin
                    CheckOffVariation.Reset();
                    if CheckOffVariation.FindSet() then
                        CheckOffVariation.DeleteAll();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90257 "Posted Checkoff Variations"
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Variation Header";
    SourceTableView = where(Processed = const(false));
    CardPageId = "Checkoff Variation(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Processed; Rec.Processed) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90258 "Checkoff Variation Lines"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checkoff Variation Lines";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No")
                {
                    Visible = NoT isWindows;
                }
                field("Acount Code"; "Acount Code") { }
                field(Description; Description) { }
                field("Current Contribution"; "Current Contribution") { }
                field("New Contribution"; "New Contribution") { }
                field(Modified; Modified) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        isWindows := GuiAllowed;
    end;

    var
        isWindows: Boolean;
}
page 90259 "Checkoff Variation"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Variation Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Member Name"; "Member Name") { }
                field("Effective Date"; "Effective Date") { }
            }
            part("Check Off Variation Lines"; "Checkoff Variation Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Portal Status"; "Portal Status") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Post Variation")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Do you want to Post') then begin
                        LoansMGT.PostVariation(Rec."Document No");
                    end;
                end;
            }
        }
    }

    var
        LoansMGT: Codeunit "Loans Management";
}
page 90260 "Checkoff Variation(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Variation Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Member Name"; "Member Name") { }
            }

            part("Check Off Variation Lines"; "Checkoff Variation Lines")
            {
                SubPageLink = "Document No" = field("Document No");
            }
            group("Audit Trail")
            {
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90261 "Checkoff Advice"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Checkoff Advice";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; "Entry No") { }
                field("Member No"; "Member No") { }
                field("Member Name"; "Member Name") { }
                field("Employer Code"; "Employer Code") { }
                field("Product Type"; "Product Type") { }
                field("Product Name"; "Product Name") { }
                field("Account No"; "Account No") { }
                field("Advice Date"; "Advice Date") { }
                field("Advice Type"; "Advice Type") { }
                field("Amount Off"; "Amount Off") { }
                field("Amount On"; "Amount On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90262 "Member Controls"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Members;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Mobile Loan Blocked"; "Mobile Loan Blocked") { }
                field("Fosa Account Activated"; "Fosa Account Activated") { }
                field("FOSA Account Activator"; "FOSA Account Activator") { }
                field("Can Guarantee"; "Can Guarantee") { }
            }
        }
        area(FactBoxes)
        {
            part(Member; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {

        }
    }

    var
        myInt: Integer;
}

page 90263 "New Mobile Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Applications";
    SourceTableView = where("Approval Status" = const(New));
    CardPageId = "Mobile Application";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("FOSA Account"; "FOSA Account") { }
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90264 "Pending Mobile Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Applications";
    SourceTableView = where("Approval Status" = const("Approval Pending"));
    CardPageId = "Mobile Application(RO)";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("FOSA Account"; "FOSA Account") { }
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90265 "Processed Mobile Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Applications";
    SourceTableView = where("Approval Status" = const(Approved));
    CardPageId = "Mobile Application(RO)";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("FOSA Account"; "FOSA Account") { }
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90266 "Mobile Applications"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Applications";
    CardPageId = "Mobile Application(RO)";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("FOSA Account"; "FOSA Account") { }
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90267 "Mobile Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Mobile Applications";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field(Reactivation; Reactivation) { }
                field("Full Name"; "Full Name") { }
                field("Phone No"; "Phone No") { }
                field("ID No"; "ID No") { }
                field("FOSA Account"; "FOSA Account") { }
            }
            group("Audit Trail")
            {
                Editable = false;
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
                field(Processed; Processed) { }
                field("Processed By"; "Processed By") { }
                field("Processed On"; "Processed On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckMobileApplicationApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendMobileApplicationForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelMobileApplicationForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90268 "Mobile Application(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Mobile Applications";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("Phone No"; "Phone No") { }
                field("FOSA Account"; "FOSA Account") { }
            }
            group("Audit Trail")
            {
                Editable = false;
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
                field("Approval Status"; "Approval Status") { }
                field(Processed; Processed) { }
                field("Processed By"; "Processed By") { }
                field("Processed On"; "Processed On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90269 "Mobile Members"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Members";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Member No"; "Member No") { }
                field("Full Name"; "Full Name") { }
                field("Phone No"; "Phone No") { }
                field("ID No"; "ID No") { }

                field("Activated By"; "Activated By") { }
                field("Activated On"; "Activated On") { }
                field("FOSA Account"; "FOSA Account") { }
                field("Member Status"; "Member Status") { }
                field("Last Reactivation Date"; "Last Reactivation Date") { }
                field("Mobile Ledger"; "Mobile Ledger") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Block)
            {
                ApplicationArea = All;
                Promoted = true;

                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    TestField("Member Status", "Member Status"::Active);
                    if Confirm('Do you want to Block?') then
                        MemberMgt.BlockMobileMember("Member No");
                end;
            }
        }
    }
}
page 90270 "Mobile Ledger"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Mobile Member Ledger";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; "Entry No") { }
                field("Document No"; "Document No") { }
                field("Document Type"; "Document Type") { }
                field("Member No"; "Member No") { }
                field("Posting Date"; "Posting Date") { }
                field("Posting Time"; "Posting Time") { }
                field("User ID"; "User ID") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

page 90271 "Customer Feedback"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Customer Feedback";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; "Entry No")
                {
                    Editable = isSoapClient;
                }
                field("Category Code"; "Category Code")
                {
                    Editable = isSoapClient;
                }
                field(Details; Details)
                {
                    Editable = isSoapClient;
                }
                field(Status; Status)
                {
                    Editable = isSoapClient;
                }
                field("Created On"; "Created On")
                {
                    Editable = isSoapClient;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    trigger OnOpenPage()
    begin
        isSoapClient := (CurrentClientType = clienttype::SOAP);
    end;

    var
        isSoapClient: Boolean;
}

page 90272 "Teller Transaction Card(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Teller Transactions";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Member No"; Rec."Member No")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Account No"; Rec."Account No")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    trigger OnValidate()
                    begin
                        rec."Approval Required" := ApprovalsMgmtExt.isTellerTransactionApprovalWorkflowEnabled(Rec);
                    end;
                }
                field("Transacted By Name"; Rec."Transacted By Name") { ShowMandatory = True; }
                field("Transacted By ID No"; Rec."Transacted By ID No") { ShowMandatory = True; }

                group("Document Dimensions")
                {
                    Editable = false;
                    field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                    field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                }
            }
            group("Static Information")
            {
                Editable = false;
                field("Available Balance"; rec."Available Balance") { }
                field("Member Name"; Rec."Member Name") { }
                field("Account Name"; Rec."Account Name") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Approval Required"; Rec."Approval Required") { }
                field("Approval Status"; Rec."Approval Status") { }
                field(Posted; Rec.Posted) { }
            }
        }
        area(FactBoxes)
        {
            part(Images; "Member Images FactBox")
            {
                SubPageLink = "Member No." = field("Member No");
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Veiw Member Image")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = StepInto;
                PromotedCategory = Process;
                RunObject = page "Member Images";
                RunPageLink = "Member No." = field("Member No");
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90274 "Delete Document"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Batch Delete";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Field("Batch No"; "Batch No") { }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Delete By Batch")
            {
                ApplicationArea = All;
                Promoted = true;
                Image = StepInto;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    MemberMgt: Codeunit "Member Management";
                begin
                    //MemberMgt.deleteByBatch("Batch No");
                end;
            }
        }
    }
}

page 90275 "New Online Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Online Loan Application";
    CardPageId = "Online Application(RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New), "Portal Status" = const(New));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                }
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field("Portal Status"; "Portal Status") { }
                field("Created On"; "Created On") { }


            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90276 "Submitted Online Loans"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Online Loan Application";
    CardPageId = "Online Application(RO)";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(New), "Portal Status" = const(Submitted));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                }
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Member No."; Rec."Member No.") { }
                field("Member Name"; Rec."Member Name") { }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field("Product Code"; Rec."Product Code") { }
                field("Product Description"; Rec."Product Description") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Approved Amount"; Rec."Approved Amount") { }
                field(Status; Status) { }
                field("Created On"; "Created On") { }
                field("Submitted On"; "Submitted On") { }
            }
        }
        area(Factboxes)
        {
            part("Member Statistics"; "Member Statistics Factbox")
            {
                SubPageLink = "Member No." = field("Member No.");
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90277 "Online Application"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Online Loan Application";
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Prorated Days"; Rec."Prorated Days") { editable = false; }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
            group("Member Details")
            {
                Editable = isOpen;
                field("Member No."; Rec."Member No.")
                {
                    ShowMandatory = true;
                }
                field(Witness; Rec.Witness)
                {
                    ShowMandatory = true;
                }
                field("Member Name"; Rec."Member Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
            group("Loan Details")
            {
                Editable = isOpen;
                field("Product Code"; Rec."Product Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Recommended Amount"; rec."Recommended Amount") { }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Editable = false;
                }
                field("Recovery Mode"; Rec."Recovery Mode") { }
                group("Economic Sector")
                {
                    field("Sector Code"; Rec."Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub Sector Code"; Rec."Sub Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub-Susector Code"; Rec."Sub-Susector Code")
                    {
                        ShowMandatory = true;
                    }
                }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field("Loan Period"; Rec.Installments)
                {
                    Caption = 'Loan Period';
                }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field("Interest Repayment Method"; rec."Interest Repayment Method")
                {
                }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Total Securities"; Rec."Total Securities") { }
                field("Total Collateral"; Rec."Total Collateral") { }
                field("Insurance Amount"; Rec."Insurance Amount") { }
                field("New Monthly Installment"; Rec."New Monthly Installment") { }
            }
            group("Repayment Details")
            {
                Editable = isOpen;
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Approval Status"; Rec."Approval Status") { Editable = false; }
            }
            group("Transfer Details")
            {
                field("Pay to Bank Code"; Rec."Pay to Bank Code") { }
                field("Pay to Branch Code"; Rec."Pay to Branch Code") { }
                field("Pay to Account No"; Rec."Pay to Account No") { }
                field("Pay to Account Name"; Rec."Pay to Account Name") { }
            }
            group("Portal Information")
            {
                field("Portal Status"; Rec."Portal Status") { }
                field("Rejection Remarks"; Rec."Rejection Remarks") { }
                field("Member Deposits"; LoansManagement.GetMemberDeposits(Rec."Member No.")) { }
                field("Expected Amount"; LoansManagement.GetNetAmount(Rec."Application No")) { }
                field("Maximum Repayment Period"; "Maximum Repayment Period") { }

            }
        }
        area(FactBoxes)
        {
            part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Guarantors)
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Loan Guarantors";
                RunPageLink = "Loan No" = field("Application No");
            }
            action(Securities)
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Loan Collateral";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Online Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action("Payslip Information")
            {
                Image = AccountingPeriods;
                RunObject = page "Loan Appraisal Parameters";
                RunPageLink = "Loan No" = field("Application No");
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        LoansManagement: Codeunit "Loans Management";

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: Boolean;
        Portal: Codeunit PortalIntegrations;
}
page 90278 "Online Application(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Online Loan Application";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = isOpen;
                field("Application No"; Rec."Application No") { }
                field("Application Date"; Rec."Application Date") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Prorated Days"; Rec."Prorated Days") { editable = false; }
                field("Sales Person"; Rec."Sales Person") { }
                field("Sales Person Name"; Rec."Sales Person Name") { }
            }
            group("Member Details")
            {
                Editable = isOpen;
                field("Member No."; Rec."Member No.")
                {
                    ShowMandatory = true;
                }
                field(Witness; Rec.Witness)
                {
                    ShowMandatory = true;
                }
                field("Member Name"; Rec."Member Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
            }
            group("Loan Details")
            {
                Editable = isOpen;
                field("Product Code"; Rec."Product Code") { }
                field("Applied Amount"; Rec."Applied Amount") { }
                field("Recommended Amount"; rec."Recommended Amount") { }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    Editable = false;
                }
                field("Recovery Mode"; Rec."Recovery Mode") { }
                group("Economic Sector")
                {
                    field("Sector Code"; Rec."Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub Sector Code"; Rec."Sub Sector Code")
                    {
                        ShowMandatory = true;
                    }
                    field("Sub-Susector Code"; Rec."Sub-Susector Code")
                    {
                        ShowMandatory = true;
                    }
                }
                field("Product Description"; Rec."Product Description") { }
                field("Grace Period"; Rec."Grace Period") { }
                field("Repayment Start Date"; Rec."Repayment Start Date") { }
                field("Loan Period"; Rec.Installments)
                {
                    Caption = 'Loan Period';
                }
                field("Repayment End Date"; Rec."Repayment End Date") { }
                field("Mode of Disbursement"; Rec."Mode of Disbursement") { }
                field("Disbursement Account"; Rec."Disbursement Account") { }
                field("Interest Repayment Method"; rec."Interest Repayment Method")
                {
                }
                field("Interest Rate"; Rec."Interest Rate") { }
                field("Rate Type"; Rec."Rate Type") { }
                field("Total Securities"; Rec."Total Securities") { }
                field("Total Collateral"; Rec."Total Collateral") { }
                field("Insurance Amount"; Rec."Insurance Amount") { }
                field("New Monthly Installment"; Rec."New Monthly Installment") { }
            }
            group("Repayment Details")
            {
                Editable = isOpen;
                field("Principle Repayment"; Rec."Principle Repayment") { }
                field("Interest Repayment"; Rec."Interest Repayment") { }
                field("Total Repayment"; Rec."Total Repayment") { }
                field("Loan Account"; Rec."Loan Account") { }
                field("Approval Status"; Rec."Approval Status") { Editable = false; }
            }
            group("Transfer Details")
            {
                field("Pay to Bank Code"; Rec."Pay to Bank Code") { }
                field("Pay to Branch Code"; Rec."Pay to Branch Code") { }
                field("Pay to Account No"; Rec."Pay to Account No") { }
                field("Pay to Account Name"; Rec."Pay to Account Name") { }
            }
            group("Portal Information")
            {
                field("Portal Status"; Rec."Portal Status") { }
                field("Rejection Remarks"; Rec."Rejection Remarks") { }
                field("Member Deposits"; LoansManagement.GetMemberDeposits(Rec."Member No.")) { }
                field("Expected Amount"; LoansManagement.GetNetAmount(Rec."Application No")) { }
                field("Maximum Repayment Period"; "Maximum Repayment Period") { }

            }
        }
        area(FactBoxes)
        {
            part("Loan Statistics"; "Loan Details Factbox")
            {
                SubPageLink = "Application No" = field("Application No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send To Loans")
            {
                Promoted = true;
                Image = AccountingPeriods;
                trigger OnAction()
                begin
                    if Confirm('Do you want to submit the Online Loan Application?') then begin
                        LoansManagement.createLoan("Application No");
                        Message('Submitted Successfully');
                        CurrPage.Close();
                    end;
                end;
            }

            action("Guarantors Requests")
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Guarantor Requests";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Witness Requests")
            {
                Promoted = true;
                Image = StepOver;
                RunObject = page "Witness Requests";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Print Schedule")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Loan Application";
                begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Repayment Schedule", true, false, LoanApplication);
                end;
            }
            action("Print Application")
            {
                ApplicationArea = all;
                Promoted = true;
                Image = Print;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    LoanApplication: Record "Online Loan Application";
                begin
                    if LoanApplication."Appraisal Commited" = false then begin
                        LoansManagement.ValidateOnlineAppraisal(Rec);
                        Rec.CalcFields("Monthly Inistallment");
                        if Rec."Monthly Inistallment" = 0 then
                            Error('Please Generate the loan schedule first');
                        LoansManagement.OnlineAppraiseZeroDeposits(Rec);
                    end;
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Application No", Rec."Application No");
                    if LoanApplication.FindSet() then
                        Report.Run(Report::"Loan Application", true, false, LoanApplication);
                end;
            }
            action(Recoveries)
            {
                Image = StepOut;
                RunObject = page "Loan Recoveries";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Member Balances")
            {
                Image = ActivateDiscounts;
                RunObject = page "Appraisal Account Balances";
                RunPageLink = "Loan No" = field("Application No");
            }
            action("Payslip Information")
            {
                Image = AccountingPeriods;
                RunObject = page "Loan Appraisal Parameters";
                RunPageLink = "Loan No" = field("Application No");
            }
        }
    }

    trigger OnOpenPage()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    trigger OnAfterGetRecord()
    begin
        isOpen := (Rec."Approval Status" = Rec."Approval Status"::New);
    end;

    var
        LoansManagement: Codeunit "Loans Management";

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
        isOpen: Boolean;
        Portal: Codeunit PortalIntegrations;
}

page 90279 "Guarantor Requests"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Online Guarantor Requests";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Request Type" = const(Guarantor));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ID No"; "ID No")
                {

                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Member No"; "Member No") { }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(PhoneNo; Rec.PhoneNo)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(AppliedAmount; Rec.AppliedAmount)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Amount Accepted"; Rec."Amount Accepted")
                {
                    Editable = isWindowsClient;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Editable = isWindowsClient;
                }
                field("Created On"; "Created On")
                {
                    Editable = isWindowsClient;
                }
                field("Responded On"; "Responded On")
                {
                    Editable = isWindowsClient;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {


        }
    }
    var
        isWindowsClient: Boolean;

    trigger OnOpenPage()
    begin
        if CurrentClientType <> ClientType::Windows then
            isWindowsClient := true;
    end;
}
page 90280 "Witness Requests"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Online Guarantor Requests";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = where("Request Type" = const(Witness));
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("ID No"; "ID No")
                {

                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Member No"; "Member No") { }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(PhoneNo; Rec.PhoneNo)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field(AppliedAmount; Rec.AppliedAmount)
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Editable = isWindowsClient;

                }
                field("Amount Accepted"; Rec."Amount Accepted")
                {
                    Editable = isWindowsClient;
                }
                field("Requested Amount"; Rec."Requested Amount")
                {
                    Editable = isWindowsClient;
                }
                field("Created On"; "Created On")
                {
                    Editable = isWindowsClient;
                }
                field("Responded On"; "Responded On")
                {
                    Editable = isWindowsClient;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {


        }
    }
    var
        isWindowsClient: Boolean;

    trigger OnOpenPage()
    begin
        if CurrentClientType <> ClientType::Windows then
            isWindowsClient := true;
    end;
}

page 90281 "Member Images FactBox"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Members;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    LinksAllowed = false;
    layout
    {
        area(Content)
        {
            group("Passport Image")
            {
                field("Member Image"; "Member Image") { }
            }
            group("Signature")
            {
                field("Member Signature"; "Member Signature") { }
            }
        }
    }

    var
        myInt: Integer;
}
page 90282 "Pending Receipts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(false), "Approval Status" = const("Approval Pending"));
    CardPageId = "Receipt(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.")
                {
                    StyleExpr = Approved;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Type"; Rec."Receiving Account Type")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account No."; Rec."Receiving Account No.")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Name"; Rec."Receiving Account Name")
                {
                    StyleExpr = Approved;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = Approved;
                }
                field("Created By"; Rec."Created By")
                {
                    StyleExpr = Approved;
                }
                field("Created On"; Rec."Created On")
                {
                    StyleExpr = Approved;
                }
                field("Approval Status"; "Approval Status")
                {
                    StyleExpr = Approved;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        case "Approval Status" of
            "Approval Status"::New:
                begin
                    Approved := 'Standard';
                end;
            "Approval Status"::"Approval Pending":
                begin
                    Approved := 'Attention';
                end;
            "Approval Status"::Approved:
                begin
                    Approved := 'StrongAccent';
                end;
        end
    end;

    var
        Approved: Text;
}

page 90283 "Approved Receipts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(false), "Approval Status" = const(Approved));
    CardPageId = "Receipt(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.")
                {
                    StyleExpr = Approved;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Type"; Rec."Receiving Account Type")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account No."; Rec."Receiving Account No.")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Name"; Rec."Receiving Account Name")
                {
                    StyleExpr = Approved;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = Approved;
                }
                field("Created By"; Rec."Created By")
                {
                    StyleExpr = Approved;
                }
                field("Created On"; Rec."Created On")
                {
                    StyleExpr = Approved;
                }
                field("Approval Status"; "Approval Status")
                {
                    StyleExpr = Approved;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        case "Approval Status" of
            "Approval Status"::New:
                begin
                    Approved := 'Standard';
                end;
            "Approval Status"::"Approval Pending":
                begin
                    Approved := 'Attention';
                end;
            "Approval Status"::Approved:
                begin
                    Approved := 'StrongAccent';
                end;
        end
    end;

    var
        Approved: Text;
}
page 90284 "Receipts Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Receipt Header";
    CardPageId = "Receipt(RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Receipt No."; Rec."Receipt No.")
                {
                    StyleExpr = Approved;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Type"; Rec."Receiving Account Type")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account No."; Rec."Receiving Account No.")
                {
                    StyleExpr = Approved;
                }
                field("Receiving Account Name"; Rec."Receiving Account Name")
                {
                    StyleExpr = Approved;
                }
                field(Amount; Rec.Amount)
                {
                    StyleExpr = Approved;
                }
                field("Created By"; Rec."Created By")
                {
                    StyleExpr = Approved;
                }
                field("Created On"; Rec."Created On")
                {
                    StyleExpr = Approved;
                }
                field("Approval Status"; "Approval Status")
                {
                    StyleExpr = Approved;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        case "Approval Status" of
            "Approval Status"::New:
                begin
                    Approved := 'Standard';
                end;
            "Approval Status"::"Approval Pending":
                begin
                    Approved := 'Attention';
                end;
            "Approval Status"::Approved:
                begin
                    Approved := 'StrongAccent';
                end;
        end
    end;

    var
        Approved: Text;
}
page 90285 "Receipt(RO)"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Receipt Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Receipt No."; Rec."Receipt No.") { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Receiving Account Type"; Rec."Receiving Account Type") { }
                field("Receiving Account No."; Rec."Receiving Account No.") { }
                field("External Document No."; Rec."External Document No.") { }
                field("Receiving Account Name"; Rec."Receiving Account Name") { }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { }
                field(Amount; Rec.Amount) { }
                field("Allocated Amount"; Rec."Allocated Amount") { }
                field("Posting Description"; Rec."Posting Description")
                {
                    ShowMandatory = true;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ShowMandatory = true;
                }


            }
            part("Receipt Details"; "Receipt Lines")
            {
                SubPageLink = "Receipt No." = field("Receipt No.");
            }
            group("Audit Trail")
            {

                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action("Send Approval Request")
            {
                ApplicationArea = All;
                Image = SendApprovalRequest;
                trigger OnAction();
                begin
                    if ApprovalsMgmtExt.CheckBosaReceiptApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmtExt.OnSendBosaReceiptForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Image = CancelApprovalRequest;
                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelBosaReceiptForApproval(Rec);
                end;
            }
            action(Comments)
            {
                ApplicationArea = all;
                Image = ViewComments;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Image = Approve;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                        EXIT;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Image = Reject;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                        EXIT;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = all;
                Image = Delegate;
                Promoted = true;
                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF NOT CONFIRM('Are you sure you want to Delegate the document?') THEN
                        EXIT;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                    CurrPage.CLOSE();
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                image = Post;
                trigger OnAction()
                begin
                    TestField("Approval Status", "Approval Status"::Approved);
                    if Confirm('Do you want to Post?') then begin
                        ReceiptManagement.PostReceipt(Rec);
                    end
                end;
            }
            action("Print")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    Receipt: Record "Receipt Header";
                begin
                    Receipt.Reset();
                    Receipt.SetRange("Receipt No.", Rec."Receipt No.");
                    if Receipt.FindFirst() then
                        Report.RunModal(Report::"Cash Receipt", true, false, Receipt);
                end;

            }
        }
    }

    var
        ReceiptManagement: Codeunit "Receipt Management";
        ApprovalsMgmtExt: Codeunit "Approval Mgmt. Ext";
}
page 90286 "Standing Orders Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Standing Order";
    CardPageId = "Standing Order Card (RO)";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Document No"; Rec."Document No") { }
                field("Standing Order Class"; Rec."Standing Order Class") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Amount Type"; Rec."Amount Type") { }
                field(Amount; Rec.Amount) { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90287 "Document Uploads(RO)"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Document Uploads";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No"; Rec."Entry No")
                {
                    Editable = isSOAP;
                }
                field("Parent Type"; Rec."Parent Type")
                {
                    Editable = isSOAP;
                }
                field("Parent No"; Rec."Parent No")
                {
                    Editable = isSOAP;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = isSOAP;
                }
                field("Document No"; Rec."Document No")
                {
                    Editable = isSOAP;
                }
                field(URL; Rec.URL)
                {
                    Editable = isSOAP;
                }
                field("Added By"; Rec."Added By")
                {
                    Editable = isSOAP;
                }
                field("Added On"; Rec."Added On")
                {
                    Editable = isSOAP;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    var
        isSOAP: Boolean;

    trigger OnOpenPage()
    begin
        isSOAP := (CurrentClientType <> ClientType::Windows);
    end;
}
page 90288 "Submitted Checkoff Variations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Checkoff Variation Header";
    SourceTableView = where(Processed = const(false), "Portal Status" = const(Submitted));
    CardPageId = "Checkoff Variation";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No") { }
                field("Member No"; Rec."Member No") { }
                field("Member Name"; Rec."Member Name") { }
                field("Created By"; Rec."Created By") { }
                field("Created On"; Rec."Created On") { }
                field(Processed; Rec.Processed) { }
                field("Portal Status"; "Portal Status") { }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CheckOffVariation: Record "Checkoff Variation Header";
                begin
                    CheckOffVariation.Reset();
                    if CheckOffVariation.FindSet() then
                        CheckOffVariation.DeleteAll();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
page 90289 "Appraisal FOSA Salary"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan FOSA Salaries";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Amount Earned"; "Amount Earned") { }
                field(Recoveries; Recoveries) { }
                field("Net Salary"; "Net Salary") { }
                field("Posting Date"; "Posting Date") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90290 "Member Accounts List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Vendor;
    InsertAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Member Account Card";
    SourceTableView = where("Account Type" = filter(Sacco | loan));
    layout
    {
        area(Content)
        {

            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    StyleExpr = StyleText;
                }
                field("Member No."; "Member No.") { }
                field(Name; Rec.Name)
                {
                    StyleExpr = StyleText;
                }
                field("Search Name"; Rec."Search Name")
                {
                    StyleExpr = StyleText;
                }
                field(Balance; Rec.Balance)
                {
                    StyleExpr = StyleText;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StyleText;
                }
                field("Account Class"; Rec."Account Class")
                {
                    StyleExpr = StyleText;
                }
                field("Account Code"; Rec."Account Code")
                {
                    StyleExpr = StyleText;
                }
                field("Card No"; MemberMgt.MaskCardNo(Rec."Card No"))
                {
                    StyleExpr = StyleText;
                }
                field("NWD Account"; "NWD Account") { }
                field("Share Capital Account"; "Share Capital Account") { }
                field("Juniour Account"; "Juniour Account") { }

            }
        }
        area(FactBoxes)
        {
            part(Statistics; "Account Statistics")
            {
                SubPageLink = "No." = field("No.");
            }
        }

    }

    var
        StyleText: Text[100];
        MemberMgt: Codeunit "Member Management";

    trigger OnAfterGetRecord()
    begin
        if rec."Account Class" = rec."Account Class"::Loan then
            StyleText := 'Ambiguous'
        else
            if rec."Account Class" = rec."Account Class"::"Fixed Deposit" then
                StyleText := 'StrongAccent'
            else
                StyleText := 'Favorable';
    end;

}
page 90291 "Held Amounts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Uncleared Effects";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No"; "Document No") { }
                field("Member No"; "Member No") { }
                field("Member Name"; "Member Name") { }
                field("Entry No"; "Entry No") { }
                field(Amount; Amount) { }
                field("Created By"; "Created By") { }
                field("Created On"; "Created On") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}
page 90292 "Member Account Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Vendor;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; "No.") { }
                field("Member No."; "Member No.") { }
                field(Name; Name) { }
                field(Balance; Balance) { }
                field("Uncleared Effects"; "Uncleared Effects") { }
                field("Cheques On Hand"; "Cheques On Hand") { }

                field(BookBalance; BookBalance)
                {
                    Editable = false;
                    StyleExpr = 'Strong';
                }
            }
        }
        area(FactBoxes)
        {
            part(Statistics; "Account Statistics")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    UnclearedEffect: Record "Uncleared Effects";
                begin
                    UnclearedEffect.Reset();
                    if UnclearedEffect.FindSet() then begin
                        repeat
                            UnclearedEffect."Account No" := '501' + UnclearedEffect."Member No";
                            UnclearedEffect.Modify();
                        until UnclearedEffect.Next() = 0;
                    end;
                end;
            }
        }
    }

    var
        BookBalance: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Uncleared Effects", Balance);
        BookBalance := 0;
        BookBalance := Balance - "Uncleared Effects";
    end;
}

page 90293 "Account Statistics"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Vendor;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; "No.") { }
                field(Name; Name) { }
                field(Balance; Balance) { }
                field("Uncleared Effects"; "Uncleared Effects") { }
                field("Available Balance"; BookBalance) { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        BookBalance: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Uncleared Effects", Balance);
        BookBalance := 0;
        BookBalance := Balance - "Uncleared Effects";
    end;
}
page 90294 "Loan Recovery Accounts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Loan Recovey Accounts";
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Account No"; "Account No") { }
                field("Account Name"; "Account Name") { }
                field("Current Balance"; "Current Balance") { }
                field("Recovery Amount"; "Recovery Amount") { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}