page 95000 "Credit Clerk"
{
    PageType = RoleCenter;
    Caption = 'Credit Clerk';

    layout
    {
        area(RoleCenter)
        {
            part(Part1; Headlines)
            {
                ApplicationArea = All;
            }
            // group(Group1)
            // {
            part(Part2; "Credit Cue")
            {
                ApplicationArea = Basic, Suite;
            }
            //}
        }


    }

    actions
    {
        area(Creation)
        {
            action("&Purchase Invoices")
            {
                RunObject = Page "Purchase Invoice";
                RunPageMode = Create;
            }
            action("Payment Voucher")
            {
                RunObject = page "Payment Voucher";
                RunPageMode = Create;
            }
            action("Cash Receipt")
            {
                RunObject = page Receipt;
                RunPageMode = Create;
            }
            action("New Member")
            {
                RunObject = page "Member Application";
                RunPageMode = Create;
            }
            action("New Collateral")
            {
                RunObject = page "Collateral Application";
                RunPageMode = Create;
            }
            action("New Loan")
            {
                RunObject = page Loan;
                RunPageMode = Create;
            }
            action("New Fixed Asset")
            {
                RunObject = page "Fixed Asset Card";
                RunPageMode = Create;
            }
        }
        area(Sections)
        {
            group(Approvals_)
            {
                Caption = 'Approvals';
                ToolTip = 'Approve requests made by other users.';
                action(Action77)
                {
                    ApplicationArea = Suite;
                    Caption = 'Requests to Approve';
                    Image = Approvals;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'View the number of approval requests that require your approval.';
                }
            }
            group("FOSA Operations")
            {
                group("FOSA Setups")
                {
                    action(Counties)
                    {
                        RunObject = page Counties;
                    }
                    action("Teller Treasury Setup")
                    {
                        RunObject = page "Teller - Treasury Setup";
                    }
                    action("Coinage Setup")
                    {
                        RunObject = page "Coinage Setup";
                    }
                    action("Mobile Transactions Setup")
                    {
                        RunObject = page "Mobile Transaction Setup";
                    }
                    action(Employers)
                    {
                        RunObject = page Employers;
                    }
                }
                group("Tellering/Treasury")
                {
                    action("Cash Deposit/Withdrawal")
                    {
                        RunObject = page "Teller Transactions";
                    }
                    action("Receive From Bank")
                    {
                        RunObject = page "Receive From Bank";
                    }
                    action("Send to Bank")
                    {
                        RunObject = page "Send To Bank";
                    }
                    action("Request From Treasury")
                    {
                        RunObject = page "Request From Treasury";
                    }
                    action("Issue To Teller")
                    {
                        RunObject = page "Issue to Teller";
                    }
                    action("Receive From Treasury")
                    {
                        RunObject = page "Receive From Treasury";
                    }
                    action("Inter Teller Transfer")
                    {
                        RunObject = page "Inter Teller Transfer";
                    }
                    action("Inter Teller Receiving")
                    {
                        RunObject = page "Inter Teller Receiving";
                    }
                    action("Return to Treasury")
                    {
                        RunObject = page "Return To Treasury";
                    }
                    action("Receive From Teller")
                    {
                        RunObject = page "Receive From Teller";
                    }
                }
                group("Inter Account Transfers")
                {
                    action("New Inter Account Transfers")
                    {
                        RunObject = page "New Inter Acc. Transfers";
                    }
                    action("Pending Inter Account Transfers")
                    {
                        RunObject = page "Pending Inter Acc. Transfers";
                    }
                    action("Approved Inter Account Transfers")
                    {
                        RunObject = page "Approved Inter Acc. Transfers";
                    }
                    action("Posted Inter Account Transfers")
                    {
                        RunObject = page "Posted Inter Acc. Transfers";
                    }
                }
                group("Bankers Cheques")
                {
                    action("Bankers Cheque Types")
                    {
                        RunObject = page "Bankers Cheque Types";
                    }
                    action("New Bankers Cheque")
                    {
                        RunObject = page "New Bankers Cheques";
                    }
                    action("Pending Bankers Cheques")
                    {
                        RunObject = page "Pending Bankers Cheques";
                    }
                    action("Approved Bankers Cheques")
                    {
                        RunObject = page "Approved Bankers Cheques";
                    }
                    action("Posted Bankers Cheques")
                    {
                        RunObject = page "Posted Bankers Cheques";
                    }
                }
                group("Cheque Book Management")
                {
                    action("Cheque Book Types")
                    {
                        RunObject = page "Cheque Book Types";
                    }
                    group("Cheque Book Applications")
                    {
                        action("New Cheque Book Application")
                        {
                            Image = ActivateDiscounts;
                            RunObject = page "New Cheque Book Applications";
                        }

                        action("Pending Cheque Book Application")
                        {
                            Image = ActivateDiscounts;
                            RunObject = page "Pending Cheque Book App.";
                        }

                        action("Approved Cheque Book Application")
                        {
                            Image = ActivateDiscounts;
                            RunObject = page "Approved Cheque Book App.";
                        }
                        action("Processed Cheque Book Application")
                        {
                            Image = ActivateDiscounts;
                            RunObject = page "Processed Cheque Book App.";
                        }
                    }
                }
                group("Cheque Truncation")
                {
                    action("Cheque Types")
                    {
                        RunObject = page "Cheque Types";
                    }
                    action("New Cheque Deposit")
                    {
                        RunObject = page "New Cheque Deposits";
                    }
                    action("Cheques On Hand")
                    {
                        RunObject = page "Cheques On Hand";
                    }
                    action("Cleared Cheques")
                    {
                        RunObject = page "Cleared Cheques";
                    }
                    action("Bounced Cheques")
                    {
                        RunObject = page "Bounced Cheques";
                    }
                }
                group("Standing Orders")
                {
                    action("Standing Order Types")
                    {
                        RunObject = page "Standing Order Types";
                    }
                    action("New Standing Order")
                    {
                        RunObject = page "New Standing Orders";
                    }
                    action("Pending Standing Orders")
                    {
                        RunObject = page "Pending Standing Orders";
                    }
                    action("Running Standing Orders")
                    {
                        RunObject = page "Running Standing Orders";
                    }
                    action("Terminated Standing Orders")
                    {
                        RunObject = page "Terminated Standing Orders";
                    }
                }
                group("ATM Management")
                {
                    action("ATM Types")
                    {
                        RunObject = page "ATM Types";
                    }
                    action("ATM Applications")
                    {
                        RunObject = page "ATM Applications";
                    }
                    action("Pending ATM Applications")
                    {
                        RunObject = page "Pending ATM Applications";
                    }
                    action("Approved ATM Applications")
                    {
                        RunObject = page "Approved ATM Applications";
                    }
                    action("Processed ATM Application")
                    {
                        RunObject = page "Processed ATM Applications";
                    }
                    action("ATM Transactions")
                    {
                        RunObject = page "ATM Transactions";
                    }
                }
            }
            group("Credit Management")
            {
                group("Credit Setups")
                {
                    action("Economic Sectors")
                    {
                        RunObject = page "Economic Sectors";
                    }

                    action("Recoveries Setup")
                    {
                        RunObject = page "External Recoveries Setup";
                    }
                    action(Charges)
                    {
                        RunObject = page Charges;
                    }
                    action("Transaction Types")
                    {
                        RunObject = page "Sacco Transactions";
                    }
                    action("Loan Products")
                    {
                        RunObject = Page "Product Factory";
                    }
                    action("Appraisal Parameters")
                    {
                        RunObject = page "Appraisal Parameters";
                    }
                    action("Collateral Types")
                    {
                        RunObject = page "Collateral Types";
                    }
                }
                action("Loan Calculator")
                {
                    RunObject = page "Loan Calculators";
                }
                group(Collaterals)
                {

                    action("Collateral Applications")
                    {
                        RunObject = page "Collateral Applications";
                    }
                    action("Collateral Register")
                    {
                        RunObject = page "Collateral Register";
                    }
                    action("Collateral Release")
                    {
                        RunObject = page "Collateral Releases";
                    }
                }
                group(Approvals)
                {
                    action("Requests to Approve")
                    {
                        RunObject = page "Requests to Approve";
                    }
                    action("Approval Requests")
                    {
                        RunObject = page "Approval Request Entries";
                    }
                }
                group("Loan Processing")
                {
                    action("Loan Applications")
                    {
                        RunObject = page Loans;
                    }
                    action("Loans Pending Approval")
                    {
                        RunObject = page "Pending Loans";
                    }
                    action("Approved Loans")
                    {
                        RunObject = page "Approved Loans";
                    }
                    action("Running Loans")
                    {
                        RunObject = page "Posted Loans";
                    }
                    action("Cleared Loans")
                    {
                        RunObject = page "Cleared Loans";
                    }
                }
                group("Loan Batching")
                {
                    action("New Loan Batches")
                    {
                        Image = StepOver;
                        RunObject = page "New Loan Batches";
                    }
                    action("Pending Loan Batches")
                    {
                        Image = Percentage;
                        RunObject = page "Pending Loan Batches";
                    }
                    action("Approved Loan Batches")
                    {
                        Image = PostedCreditMemo;
                        RunObject = page "Approved Loan Batches";
                    }
                    action("Posted Loan Batches")
                    {
                        Image = DocInBrowser;
                        RunObject = page "Posted Loan Batches";
                    }
                }
                action("Mobile Transactions")
                {
                    RunObject = page "Mobile Transactions";
                }
                group("Guarantor Management")
                {
                    action("New Guarantor Substitution")
                    {
                        Image = Create;
                        RunObject = page "New Guarantor Mgt.";
                    }
                    action("Pending Guarantor Substitution")
                    {
                        Image = Create;
                        RunObject = page "Pending Guarantor Mgt.";
                    }

                    action("Approved Guarantor Substitution")
                    {
                        Image = Create;
                        RunObject = page "Approved Guarantor Mgt.";
                    }

                    action("Posted Guarantor Substitution")
                    {
                        Image = Create;
                        RunObject = page "Posted Guarantor Mgt.";
                    }
                }
                group("Analysis & Reporting")
                {
                    action("Loan Register")
                    {
                        RunObject = report "Loan Register";
                    }

                    action("Loan Transactions")
                    {
                        RunObject = report "Loan Transactions";
                    }
                    action("Payments Due")
                    {
                        RunObject = report "Payments Due";
                    }
                }
                group("Periodic Activities")
                {
                    action("Transfer Minimum Share Capital")
                    {
                        RunObject = report "Transfer Shares - Q";
                    }
                    group("Checkoff Variation")
                    {
                        action("Online Checkoff Variations")
                        {
                            RunObject = page "New Checkoff Variations";
                        }
                        action("New Checkoff Variations")
                        {
                            RunObject = page "Submitted Checkoff Variations";
                        }
                        action("Processed Checkoff Variations")
                        {
                            RunObject = page "Posted Checkoff Variations";
                        }
                        action("Check Off Advice")
                        {
                            RunObject = page "Checkoff Advice";
                        }
                    }

                    group("Checkoff Processing")
                    {

                        action("New Checkoff")
                        {
                            RunObject = page Checkoffs;
                        }
                        action("Pending Checkoff")
                        {
                            RunObject = page "Pending Checkoffs";
                        }
                        action("Approved Checkoffs")
                        {
                            RunObject = page "Approved Checkoffs";
                        }
                        action("Posted Checkoffs")
                        {
                            RunObject = page "Posted Checkoffs";
                        }
                        action("All Checkoffs")
                        {
                            RunObject = page "Checkoff Lookup";
                        }
                    }
                    action("Capitalize Interest")
                    {
                        RunObject = report "Post Interests - Q";
                    }
                    group("Bulk SMS")
                    {
                        action("New Bulk SMS")
                        {
                            RunObject = page "New Bulk SMS";
                        }
                        action("Sent Bulk SMS")
                        {
                            RunObject = page "Sent Bulk SMS";
                        }
                    }
                }
                group("Loan Recovery")
                {
                    group("Demand Notes")
                    {
                        action("Prepare Defaulter Notice")
                        {
                            RunObject = page "New Defaulter Notices";
                        }
                        action("Processed Defaulter Notice")
                        {
                            RunObject = page "Processed Defaulter Notices";
                        }
                    }
                    action("New Loan Recovery")
                    {
                        RunObject = page "New Loan Recovery";
                    }
                    action("Pending Loan Recovery")
                    {
                        RunObject = page "Pending Loan Recovery";
                    }
                    action("Approved Loan Recovery")
                    {
                        RunObject = page "Approved Loan Recovery";
                    }
                    action("Posted Loan Recovery")
                    {
                        RunObject = page "Posted Loan Recovery";
                    }
                }
            }
            group("Fixed Deposit Management")
            {
                action("Fixed Deposit Types")
                {
                    RunObject = page "Fixed Deposit Types";
                }
                action("New Fixed Deposits")
                {
                    RunObject = page "Fixed Deposits";
                }
                action("Fixed Deposits Pending Approval")
                {
                    RunObject = page "Pending Fixed Deposits";
                }
                action("Running Fixed Deposits")
                {
                    RunObject = page "Running Fixed Deposits";
                }
                action("Terminated Fixed Deposits")
                {
                    RunObject = page "Terminated Fixed Deposits";
                }
            }
            group(Membership)
            {
                action("Membership Applications")
                {
                    RunObject = Page "Member Applications";
                }
                group("Account Openning")
                {
                    action("New Account Openning")
                    {
                        RunObject = page "New Account Openning";
                    }
                    action("Pending Account Openning")
                    {
                        RunObject = page "Pending Account Openning";
                    }
                    action("NProcessedew Account Openning")
                    {
                        RunObject = page "Processed Account Openning";
                    }

                }
                group(Integrations)
                {
                    group(Loans)
                    {
                        action("New Loan Applications")
                        {
                            RunObject = page "New Online Loans";
                        }
                        action("Submitted Loans")
                        {
                            RunObject = page "Submitted Online Loans";
                        }
                        action("Online Guarantor Requests")
                        {
                            RunObject = page "Online Guarantor Requests";
                        }
                        action("Online Uploads")
                        {
                            RunObject = page "Document Uploads";
                        }
                        action("Guarantor Subsitutions")
                        {
                            RunObject = page "Online Guarantor Sub Requests";
                        }
                    }
                }

                group("Dividend Management")
                {
                    action("Dividend List")
                    {
                        RunObject = page "Dividend List";
                    }
                    group("Allocations")
                    {
                        action("Pending Allocations")
                        {
                            RunObject = page "Pending Allocations";
                        }
                        action("Submitted Allocations")
                        {
                            RunObject = page "Submitted Allocations";
                        }
                    }
                }
                action("Member List")
                {
                    RunObject = page Members;
                }
                action(DeleteBatch)
                {
                    RunObject = page "Delete Document";
                }
                action("Member Update")
                {
                    RunObject = page "Member Editings";
                }
                action("Member Versions")
                {
                    RunObject = page "Member Versions";
                }
                group("Member Exit")
                {
                    action("New Member Withdrawal")
                    {
                        RunObject = page "New Member Exits";
                    }
                    action("Pending Member Withdrawal")
                    {
                        RunObject = page "Pending Member Exits";
                    }
                    action("Approved Member Exits")
                    {
                        RunObject = page "Approved Member Exits";
                    }
                    action("Processed Member Exit")
                    {
                        RunObject = page "Processed Member Exits";
                    }
                }
                group("Member Reactivations")
                {
                    action("New Member Reactivation")
                    {
                        Image = NewDepreciationBook;
                        RunObject = Page "New Member Reactivations";

                    }
                    action("Pending Member Reactivation")
                    {
                        Image = NewDepreciationBook;
                        RunObject = Page "Pending Member Reactivations";

                    }
                    action("Approved Member Reactivation")
                    {
                        Image = NewDepreciationBook;
                        RunObject = Page "Approved Member Reactivations";

                    }
                    action("Processed Member Reactivation")
                    {
                        Image = NewDepreciationBook;
                        RunObject = Page "Posted Member Reactivations";

                    }
                }
                group("Receipting")
                {
                    action("New Receipts")
                    {
                        RunObject = page Receipts;
                    }
                    action("Receipts Pending Approval")
                    {
                        RunObject = page "Pending Receipts";
                    }
                    action("Approved Receipts")
                    {
                        RunObject = page "Approved Receipts";
                    }
                    action("Posted Receipts")
                    {
                        RunObject = page "Posted Receipts";
                    }
                }
                group("Reports & Analysis")
                {
                    action("Member &List")
                    {
                        RunObject = report "Member List";
                    }
                    action("Member Statement")
                    {
                        RunObject = report "Member Statement";
                    }
                }
            }
            group(Setups)
            {
                action("General Setup")
                {
                    RunObject = page "Sacco Setup";
                }
                action("Member Types")
                {
                    RunObject = page "Member Categories";
                }
                action("External Banks")
                {
                    RunObject = page "External Banks";
                }
            }

            group("Mobile Banking")
            {
                group("Mobile Applications")
                {
                    action("New Mobile Application")
                    {
                        RunObject = page "New Mobile Applications";
                    }
                    action("Pending Mobile Application")
                    {
                        RunObject = page "Pending Mobile Applications";
                    }
                    action("Approved Mobile Application")
                    {
                        RunObject = page "Processed Mobile Applications";
                    }
                }
                action("Mobile Members")
                {
                    RunObject = page "Mobile Members";
                }
                action("Incoming Mobile Transactions")
                {
                    RunObject = page "Mobile Transactions";
                }
            }
            group("Financial Management")
            {
                group(Payables)
                {
                    action(Vendors)
                    {
                        RunObject = page "Vendor List";
                    }
                    action("Purchase Invoices")
                    {
                        RunObject = Page "Purchase Invoices";
                    }
                    action("Purchase Orders")
                    {
                        RunObject = page "Purchase Orders";
                    }
                    action("Purchase Credit Memos")
                    {
                        RunObject = page "Purchase Credit Memos";
                    }
                }
                group("General Ledger")
                {
                    action("Chart of Accounts")
                    {
                        RunObject = page "Chart of Accounts";
                    }
                    action("Vendor Posting Groups")
                    {
                        RunObject = page "Vendor Posting Groups";
                    }
                    action("Fixed Assets")
                    {
                        RunObject = page "Fixed Asset List";
                    }
                    action("Bank Accounts")
                    {
                        RunObject = page "Bank Account List";
                    }
                    action("Bank Reconciliation")
                    {
                        RunObject = page "Bank Acc. Reconciliation List";
                    }
                    action("Journal Vouchers")
                    {
                        RunObject = page "Journal Vouchers";
                    }
                    group("&Analysis & Reporting")
                    {
                        action("Account Schedules")
                        {
                            RunObject = page "Account Schedule";
                        }
                        action("Trial Balance")
                        {
                            RunObject = report "Trial Balance";
                        }
                        action("Detailed Trial Balance")
                        {
                            RunObject = report "Detail Trial Balance";
                        }
                        action("Aged Accounts Payable")
                        {
                            RunObject = report "Aged Accounts Payable";
                        }
                        action("Cash Book")
                        {
                            RunObject = report "Bank Acc. - Detail Trial Bal.";
                        }
                    }
                }
                group("Fixed Asset Management")
                {
                    action("FA Classes")
                    {
                        RunObject = page "FA Classes";
                    }
                    action("FA Subclasses")
                    {
                        RunObject = page "FA Subclasses";
                    }
                    action("&Fixed Assets")
                    {
                        RunObject = page "Fixed Asset List";
                    }
                    action("FA G/L Journal")
                    {
                        RunObject = page "Fixed Asset G/L Journal";
                    }
                    action("Calculate Depreciation")
                    {
                        RunObject = report "Calculate Depreciation";
                    }
                    action("FA Book Value")
                    {
                        RunObject = report "Fixed Asset - Book Value 01";
                    }
                    action("Posting Groups")
                    {
                        RunObject = page "FA Posting Groups";
                    }
                    action("Depreciation Books")
                    {
                        RunObject = Page "Depreciation Book List";
                    }
                    action("FA Posting Setup")
                    {
                        RunObject = page "FA Posting Type Setup";
                    }
                }
                group("Posted Documents")
                {
                    action("Posted Payment Vouchers")
                    {
                        RunObject = page "Posted Payment Vouchers";
                    }
                    action("Posted Cash Receipts")
                    {
                        RunObject = page "Posted Receipts";
                    }
                    action("Print Cash Book")
                    {
                        RunObject = report "Cash Book";
                    }
                }
            }
        }
        area(Embedding)
        {

            action("Membership Application")
            {
                RunObject = Page "Member Applications";
            }

            action(Members)
            {
                RunObject = page Members;
            }
            action("Member Accounts")
            {
                RunObject = page "Member Accounts List";
            }
            action("Payment Vouchers")
            {
                RunObject = page "Payment Vouchers";
            }
            action("Cash Receipts")
            {
                RunObject = page Receipts;
            }
            action("My Posted Receipts")
            {
                RunObject = page "Posted Receipts";
            }

        }
        area(Reporting)
        {
            group("FOSA Reports")
            {
                action("Account Listing")
                {
                    Image = AbsenceCalendar;
                    RunObject = report "Member Account List";
                }
                action("Monthly Receipts")
                {
                    Image = Receipt;
                    RunObject = report "Monthly Receipts";
                }
                action("Teller & Treasury Statement")
                {
                    Image = Absence;
                    RunObject = report "Cash Book";
                }
                action("Run Standing Order")
                {
                    Image = Absence;
                    RunObject = report "Run Standing Orders - Q";
                }
                action("Standing Order Register")
                {
                    Image = AbsenceCalendar;
                    RunObject = report "Standing Order Register";
                }
            }
            group("Credit Reports")
            {
                group("Daily Reports")
                {
                    action("Loan Issued Summary report ")
                    {
                        Image = AbsenceCategory;
                        RunObject = report "Disbursement Summary";
                    }
                    action("Loans balances Summary")
                    {
                        Image = ApplicationWorksheet;
                        RunObject = report "Loan Balances Summary";
                    }
                    action("Loan guaranteed report")
                    {
                        Image = Segment;
                        RunObject = report "Member Guarantees";
                    }
                    action("Loan guarantors Report")
                    {
                        Image = Segment;
                        RunObject = report "Member Guarantors";
                    }
                    action("Savings and Loans listing Report")
                    {
                        Image = Segment;
                        RunObject = report "Savings And Loan Listing";
                    }
                }
                action("Product Analysis")
                {
                    Image = PostApplication;
                    RunObject = report "Loan Transactions";
                }
                action("Guarantor Register")
                {
                    Image = VendorBill;
                    RunObject = report "Guarantor Register";
                }
                action("Loans Register")
                {
                    Image = Receivables;
                    RunObject = report "Loan Register";
                }
                action("Statement of Deposit Return")
                {
                    Image = VendorLedger;
                    RunObject = report "Statement of Deposit Rtn.";
                }
                action("Risk Classification")
                {
                    Image = Aging;
                    RunObject = report "Risk Classification";
                }
                action("Loan Defaulters")
                {
                    Image = AssemblyBOM;
                    RunObject = report Defaulters;
                }
                action("Recovery Advice")
                {
                    Image = ExportAttachment;
                    RunObject = report "Checkoff Advise";
                }
                action("Loan Recoveries")
                {
                    Image = Agreement;
                    RunObject = report "Loan Recovery";
                }
                action("Member Next Of KIN")
                {
                    Image = Customer;
                    RunObject = report "Member KINS";
                }
                action("Sectorial Lending Return")
                {
                    Image = AdjustItemCost;
                    RunObject = report "Sectorial Lending";
                }
            }
        }
    }
}
page 95001 "Headlines"
{
    PageType = HeadlinePart;

    layout
    {

        area(Content)
        {
            field(Headline1; Text001) { }
            field(Headline2; 'You have made a total of ' + Format(loans) + ' loan application(s)')
            {
            }
            field(Headline3; 'Total Placements')
            {

            }
            field(Headline4; 'Loans Disbursed')
            {

            }
            field(Headline5; 'Fixed Deposits Created ' + Format(loans))
            {

            }
            field(HeadLine6; GetHighestLoanAmount()) { }
        }
    }
    trigger OnOpenPage()
    var
        Users: Record User;
    begin
        LoanApplications.Reset();
        LoanApplications.SetRange("Created By", UserId);
        if LoanApplications.FindSet() then
            loans := LoanApplications.Count;
        if Users.get(UserSecurityId()) then
            Text001 := 'Hello ' + Users."Full Name"
    end;

    local procedure GetHighestLoanAmount() LoanText: Text[250]
    var
        LoanApplication: Record "Loan Application";
    begin
        LoanText := '';
        LoanApplication.Reset();
        LoanApplication.SetRange(Posted, true);
        LoanApplication.SetCurrentKey("Approved Amount");
        LoanApplication.SetAscending("Approved Amount", false);
        if LoanApplication.FindFirst() then
            LoanText := 'Your highest Loan is ' + LoanApplication."Product Description" + ' to ' + LoanApplication."Member Name" + ' of ' + Format(LoanApplication."Approved Amount");
        exit(LoanText);
    end;

    var
        UserSetup: Record "User Setup";
        Text001: Text[250];
        LoanApplications: Record "Loan Application";
        loans: Integer;
}
page 95003 "Credit Cue"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = CreditCueTable;

    layout
    {
        area(Content)
        {
            cuegroup("SACCO Actions")
            {
                CuegroupLayout = Wide;

                actions
                {

                    action("New Loan")
                    {
                        RunObject = page Loans;
                        Image = TileRed;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("New Member")
                    {
                        RunObject = page "Member Application";
                        Image = TileGreen;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("New Fixed Deposit")
                    {
                        RunObject = page "Fixed Deposits";
                        Image = TileBrickCalendar;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("New Standing Order")
                    {
                        RunObject = page "New Standing Orders";
                        Image = TileBlue;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Approval Requests")
                    {
                        RunObject = page "Requests to Approve";
                        Image = TileNew;
                    }
                }
            }
            cuegroup(SACCO)
            {
                CuegroupLayout = Wide;
                field("Gross Disbursals"; Rec."Gross Disbursals")
                {
                    ApplicationArea = All;
                    DrillDownPageId = Loans;
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';

                }
                field("Mobile Transactions"; Rec."Mobile Transactions")
                {
                    DrillDown = true;
                    DrillDownPageId = "Mobile Transactions";
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("ATM Transactions"; Rec."ATM Transactions")
                {
                    DrillDown = true;
                    DrillDownPageId = "ATM Transactions";
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
            }
            cuegroup("SACCO Management")
            {
                field("Collateral in Store"; Rec."Collateral in Store")
                {
                    DrillDownPageId = "Collateral Register";
                    AutoFormatType = 10;
                    AutoFormatExpression = '1,2:2';
                }
                field("Total Members"; Rec."Total Members")
                {
                    DrillDownPageId = Members;
                }
                field("Running Standing Orders"; Rec."Running Standing Orders")
                {
                    DrillDownPageId = "Running Standing Orders";
                }
                field("Pending Member Applications"; rec."Pending Member Applications")
                {
                    DrillDownPageId = "Member Applications";
                }

                field("ATM Applications"; Rec."ATM Applications")
                {
                    DrillDown = true;
                    DrillDownPageId = "ATM Applications";
                }


            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get(0, UserId) then begin
            Rec.Init();
            Rec.PrimaryKey := 0;
            Rec."User ID" := UserId;
            Rec.Insert();
        end;
    end;

    var
        myInt: Integer;
}
page 95004 "Placement Cue"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = CreditCueTable;

    layout
    {
        area(Content)
        {
            cuegroup(GroupName)
            {
                field("Placements Portfolio"; Rec."Placements Portfolio")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Fixed Deposits";
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
page 95005 "Approvals Cue"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = CreditCueTable;

    layout
    {
        area(Content)
        {
            cuegroup(GroupName)
            {
                field("Requests to Approve"; Rec."Requests to Approve")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Requests to Approve";
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