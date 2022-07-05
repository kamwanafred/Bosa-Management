tableextension 90008 "Company Info. Ext" extends "Company Information"
{
    fields
    {
        // Add changes to table fields here
        field(90000; "Defaulter"; blob)
        {
            Subtype = Bitmap;
        }
    }

    var
        myInt: Integer;
}
tableextension 90009 VendorExt extends Vendor
{
    LookupPageId = "Vendor Lookup Custom";
    fields
    {
        // Add changes to table fields here
        field(90001; "Member No."; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = members;
        }
        field(90002; "Account Type"; Option)
        {
            OptionMembers = "Supplier","Sacco","Loan","Service Provider","EFT";
        }
        field(90003; Status; Option)
        {
            OptionMembers = "Active","Dormant";
        }
        field(90004; "Account Class"; option)
        {
            OptionMembers = General,NWD,Collections,"Fixed Deposit",Loan;
        }
        field(90005; "Account Code"; Code[20]) { Editable = false; }
        field(90006; "Share Capital Account"; Boolean) { }
        field(90007; "NWD Account"; Boolean) { }
        field(90008; "Transacting Account"; Boolean) { }
        field(90009; "Child Scheme Account"; Boolean) { }
        field(90010; "Cash Withdrawal Allowed"; Boolean) { }
        field(90011; "Cash Deposit Allowed"; Boolean) { }
        field(90012; "Fixed Deposit Account"; Boolean) { }
        field(90013; "Holiday Account"; Boolean) { }
        field(90014; "ATM Use Allowed"; Boolean) { }
        field(90015; "Cash Transfer Allowed"; Boolean) { }
        field(90016; "Card No"; Code[50])
        {
            Editable = false;
        }
        field(90017; "Cheque Book Allowed"; Boolean) { }
        field(90018; "Uncleared Effects"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Uncleared Effects".Amount where("Account No" = field("No."), Cleared = const(false)));
        }
        field(90019; "Juniour Account"; Boolean) { }
        field(90020; "Cheques On Hand"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Cheque Deposits".Amount where("Account No." = field("No."), "Document Status" = const(Received)));
        }
    }
    keys
    {
        key(BOSA; "Member No.") { }
    }

    var
        myInt: Integer;
}
tableextension 90010 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
                Product: Record "Product Factory";
            begin
                if "Account Type" = "Account Type"::Vendor then begin
                    if Vendor.get("Account No.") then begin
                        if Vendor."Member No." <> '' then begin
                            if Product.get(Vendor."Account Code") then
                                "Member Posting Type" := Product."Member Posting Type";
                        end;
                    end;
                end;
            end;
        }
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
    }

    var
        myInt: Integer;
}
tableextension 90011 "G/L Entry Ext." extends "G/L Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}
tableextension 90012 "Bank Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}
tableextension 90013 "Vendor Ledger Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}
tableextension 90014 "Det. Vendor Ext." extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}
tableextension 90015 "Cust. Ledger Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}
tableextension 90016 "Det. Cust. Ledg. Ext" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
        field(90004; "Transaction Time"; Time) { }
    }

    var
        myInt: Integer;
}

tableextension 90017 "Bank Stataement" extends "Bank Account Statement"
{
    fields
    {
        // Add changes to table fields here
    }
    trigger OnBeforeDelete()
    begin
        Error('Delete is Not Allowed on Posted Documents!');

    end;

    var
        myInt: Integer;
}

tableextension 90018 "Bank Account Ext." extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(90001; "Account Type"; Option)
        {
            OptionMembers = Main,Till,Treasury,"ATM Settlment","Mobile Banking Control";
        }
    }

    var
        myInt: Integer;
}

tableextension 90019 "BOSA_User Setup Ext." extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(90001; "View Protected Account"; Boolean) { }
    }

    var
        myInt: Integer;
}
tableextension 90020 "Document Attachments ext" extends "Document Attachment"
{
    fields
    {
        // Add changes to table fields here
        field(80100; "Attachment Type"; Option)
        {
            OptionMembers = "Member Application","Loan Application";
        }
    }

    var
        myInt: Integer;
}

tableextension 90021 "Posted Gen. Journal Line Ext" extends "Posted Gen. Journal Line"
{
    fields
    {
        field(90000; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Members;
        }
        field(90001; "Transaction Type"; Option)
        {
            OptionMembers = General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        }
        field(90002; "Member Posting Type"; Option)
        {
            OptionMembers = "General","Withdrawable Deposit","Share Capital","Non Withrawable Deposit","Loans",Insurance,Investments,"Entrance Fee",Holiday;
        }
        field(90003; "Loan No."; Code[20]) { }
    }

    var
        myInt: Integer;
}