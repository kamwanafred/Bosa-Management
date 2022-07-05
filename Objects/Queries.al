query 90000 "Members Query"
{
    QueryType = API;
    APIPublisher = 'PublisherName';
    APIGroup = 'GroupName';
    APIVersion = 'v1.0';
    EntityName = 'SACCOMembers';
    EntitySetName = 'SACCOMembers';

    elements
    {
        dataitem(Members; Members)
        {
            column(Member_No_; "Member No.") { }
            column(Gender; Gender) { }
            column(Date_of_Birth; "Date of Birth") { }
            column(Date_of_Registration; "Date of Registration") { }
            column(Sales_Person; "Sales Person") { }
            filter(FilterName; "Date of Registration")
            {

            }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}

query 90001 Loans
{
    QueryType = API;
    APIPublisher = 'PublisherName';
    APIGroup = 'GroupName';
    APIVersion = 'v1.0';
    EntityName = 'Loans';
    EntitySetName = 'Loans';

    elements
    {
        dataitem(Loan_Application; "Loan Application")
        {
            column(Application_No; "Application No") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Applied_Amount; "Applied Amount") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Sales_Person; "Sales Person") { }
            column(Sales_Person_Name; "Sales Person Name") { }
            column(Posting_Date; "Posting Date") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column(Member_No_; "Member No.") { }
        }
    }

    var
        myInt: Integer;
        Members: Record Members;
        MemberGender: Text;

    trigger OnBeforeOpen()
    begin

    end;
}
query 90002 "Credit Ledger Entry"
{
    QueryType = API;
    APIPublisher = 'PublisherName';
    APIGroup = 'GroupName';
    APIVersion = 'v1.0';
    EntityName = 'CreditLedgerEntry';
    EntitySetName = 'CreditLedgerEntry';


    elements
    {
        dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
        {
            DataItemTableFilter = "Transaction Type" = filter("Loan Disbursal" | "Interest Due" | "Interest Paid" | "Principle Paid" | "Interest Paid"), "Member Posting Type" = const(Loans);
            column(Posting_Date; "Posting Date") { }
            column(Transaction_Type; "Transaction Type") { }
            column(Amount; Amount) { }
            column(Reason_Code; "Reason Code") { }
            column(Vendor_Posting_Group; "Vendor Posting Group") { }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}

query 90003 "Savings Ledger Entry"
{
    QueryType = API;
    APIPublisher = 'PublisherName';
    APIGroup = 'GroupName';
    APIVersion = 'v1.0';
    EntityName = 'SavingsLedgerEntry';
    EntitySetName = 'SavingsLedgerEntry';


    elements
    {
        dataitem(Vendor_Ledger_Entry; "Vendor Ledger Entry")
        {
            DataItemTableFilter = "Member Posting Type" = filter(<> Loans);
            column(Posting_Date; "Posting Date") { }
            column(Transaction_Type; "Transaction Type") { }
            column(Amount; Amount) { }
            column(Reason_Code; "Reason Code") { }
            column(Vendor_Posting_Group; "Vendor Posting Group") { }
            column(Member_No_; "Member No.") { }
            column(Member_Posting_Type; "Member Posting Type") { }
        }
    }

    var
        myInt: Integer;

    trigger OnBeforeOpen()
    begin

    end;
}