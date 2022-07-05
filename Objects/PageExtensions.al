pageextension 90000 "Company Info. Ext" extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(Picture)
        {
            field(Defaulter; Defaulter) { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 90001 "Vendor Ledger Ext." extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Member No."; Rec."Member No.") { }
            field("Member Posting Type"; Rec."Member Posting Type") { }
            field("Loan No."; Rec."Loan No.") { }
            field("Transaction Type"; Rec."Transaction Type") { }
        }
    }

    actions
    {
        addafter("&Navigate")
        {
            action("Delete Entry")
            {
                trigger OnAction()
                var
                    BankLedger: Record "Bank Account Ledger Entry";
                    VendorLedger: Record "Vendor Ledger Entry";
                    DetLedger: Record "Detailed Vendor Ledg. Entry";
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Document No.", Rec."Document No.");
                    if GLEntry.FindSet() then
                        GLEntry.DeleteAll();
                    VendorLedger.Reset();
                    VendorLedger.SetRange("Document No.", Rec."Document No.");
                    if VendorLedger.FindSet() then
                        VendorLedger.DeleteAll();
                    DetLedger.Reset();
                    DetLedger.SetRange("Document No.", Rec."Document No.");
                    if DetLedger.FindSet() then
                        DetLedger.DeleteAll();
                    BankLedger.Reset();
                    BankLedger.SetRange("Document No.", Rec."Document No.");
                    if BankLedger.FindSet() then
                        BankLedger.DeleteAll();
                end;
            }
        }
    }

    var
        myInt: Integer;
}
pageextension 90002 "Det. Vendor Ledger Ext." extends "Detailed Vendor Ledg. Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Member No."; Rec."Member No.") { }
            field("Member Posting Type"; Rec."Member Posting Type") { }
            field("Loan No."; Rec."Loan No.") { }
            field("Transaction Type"; Rec."Transaction Type") { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}

pageextension 90003 "Vendor List Ext." extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetRange("Account Type", Rec."Account Type"::"Supplier");
        Rec.FilterGroup(0);
    end;

    var
        myInt: Integer;
}
pageextension 90004 "Vendor Lookup Ext." extends "Vendor Lookup"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    begin
        //Rec.FilterGroup(2);
        //Rec.SetRange("Account Type", Rec."Account Type"::General);
        // Rec.FilterGroup(0);
    end;

    var
        myInt: Integer;
}
pageextension 90005 "G/L Entries Preview Ext." extends "G/L Entries Preview"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Transaction Type"; Rec."Transaction Type") { }
            field("Member No."; Rec."Member No.") { }
            field("Member Posting Type"; Rec."Member Posting Type") { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 90006 "G/L Entries Ext." extends "General Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Transaction Type"; Rec."Transaction Type") { }
            field("Member No."; Rec."Member No.") { }
            field("Member Posting Type"; Rec."Member Posting Type") { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}

pageextension 90007 "Bank Statements Ext." extends "Bank Account Statement List"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 90008 "Bank Statement Ext." extends "Bank Account Statement"
{
    Editable = false;
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    //Variables, procedures and triggers are not allowed on Page Customizations
}

pageextension 90009 "Bank Card Ext" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Blocked)
        {
            field("Account Type"; rec."Account Type") { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 90010 "BOSA_User Setup Ext" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Register Time")
        {
            field("View Protected Account"; Rec."View Protected Account") { }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}
pageextension 90012 "CustomPost" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("Post Custom")
            {
                trigger OnAction()
                var
                    JournalMgt: Codeunit "Journal Management";
                    JournalLine: Record "Gen. Journal Line";
                    JnlPost: Codeunit "Gen. Jnl.-Post Line";
                begin
                    JournalLine.Reset();
                    JournalLine.SetRange("Journal Template Name", "Journal Template Name");
                    JournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                    if JournalLine.FindSet() then begin
                        repeat
                            JnlPost.Run(JournalLine);
                            JournalLine.Delete();
                            Commit();
                        until JournalLine.Next() = 0;
                    end;
                end;

            }
        }
    }

    var
        myInt: Integer;
}
pageextension 90013 "PaymentJnlExt" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Account No.")
        {
            field("Member Posting Type"; "Member Posting Type") { }
            field("Member No."; "Member No.") { }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action("Update Lines")
            {
                trigger OnAction()
                var
                    JournalLine: Record "Gen. Journal Line";
                    Vendor: Record Vendor;
                    ProductFactory: Record "Product Factory";
                begin
                    JournalLine.Reset();
                    JournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
                    JournalLine.SetRange("Journal Template Name", "Journal Template Name");
                    JournalLine.SetRange("Account Type", JournalLine."Account Type"::Vendor);
                    if JournalLine.FindSet() then begin
                        repeat
                            if Vendor.get(JournalLine."Account No.") then begin
                                if ProductFactory.get(Vendor."Account Code") then begin
                                    JournalLine."Member Posting Type" := ProductFactory."Member Posting Type";
                                    JournalLine.Modify();
                                end else begin
                                    if ProductFactory.get(Vendor."Vendor Posting Group") then begin
                                        JournalLine."Member Posting Type" := ProductFactory."Member Posting Type";
                                        JournalLine.Modify();
                                    end;
                                end;
                                if Vendor."Member No." <> '' then
                                    Vendor."Account Type" := Vendor."Account Type"::Sacco;
                                Vendor.Modify();
                            end;
                        until JournalLine.Next() = 0;
                        Message('Done');
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}
