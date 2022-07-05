report 90000 "Accrue Interest - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where(Posted = const(true));
            trigger OnAfterGetRecord()
            var
                LoansManagement: Codeunit "Loans Management";
            begin
                LoansManagement.AccrueLoanInterest("Loan Application");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}

report 90001 "Post Interests - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(BDate; BillDate) { }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        LoansManagement: Codeunit "Loans Management";
        BillDate: Date;

    trigger OnPostReport()
    begin
        LoansManagement.PostLoanInterest(BillDate);
    end;
}

report 90002 "Post Repayments - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = where("Account Class" = const(Collections));
            trigger OnAfterGetRecord()
            var
                LoansManagement: Codeunit "Loans Management";
            begin
                if PaymentDate = 0D then
                    PaymentDate := Today;
                LoansManagement.PostLoanRepayments(Vendor, PaymentDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Display Filters")
                {
                    field("Payment Date"; PaymentDate) { }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
        PaymentDate: Date;
}

report 90003 "Post Penalties - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            DataItemTableView = where(Posted = const(true), "Freeze Penalty" = const(False), Closed = const(false), "Loan Balance" = filter(> 0));
            trigger OnAfterGetRecord()
            var
                PrincipalPaid: Decimal;
                InterestArrears: Decimal;
                LoanSchedule: Record "Loan Schedule";
                DateFilter: Text[200];
                ArrearsAmount: Decimal;
                LoanApp: Record "Loan Application";
                LoanProducts: Record "Product Factory";
                VendorLedger: Record "Vendor Ledger Entry";
                GenJournalBatch: Record "Gen. Journal Batch";
            begin
                if PenaltyDate = 0D then
                    PenaltyDate := Today;
                "Loan Application".CalcFields("Loan Balance");
                if "Loan Application"."Loan Account" = '' then
                    CurrReport.Skip();
                if "Loan Application"."Loan Balance" <= 0 then
                    CurrReport.Skip();
                if "Loan Application"."Posting Date" >= PenaltyDate then
                    CurrReport.Skip();
                JournalBatch := 'PEN-BILL';
                JournalTemplate := 'PAYMENT';
                if not GenJournalBatch.get(JournalTemplate, JournalBatch) then begin
                    GenJournalBatch.Init();
                    GenJournalBatch."Journal Template Name" := JournalTemplate;
                    GenJournalBatch.Name := JournalBatch;
                    GenJournalBatch.Description := 'Loans Repayment Batch';
                    GenJournalBatch.Insert();
                end;
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                if GenJournalLine.FindSet() then
                    GenJournalLine.DeleteAll();

                if NOT LoanProducts.get("Loan Application"."Product Code") then
                    CurrReport.Skip();
                ArrearsAmount := 0;
                InterestArrears := 0;
                if PenaltyDate = 0D then
                    PenaltyDate := Today;
                DateFilter := '..' + Format(PenaltyDate);
                PrincipalPaid := 0;
                PostingDate := PenaltyDate;
                LoanSchedule.Reset();
                LoanSchedule.SetFilter("Expected Date", DateFilter);
                LoanSchedule.SetRange("Loan No.", "Loan Application"."Application No");
                if LoanSchedule.FindSet() then begin
                    LoanSchedule.CalcSums("Principle Repayment");
                    ArrearsAmount := LoanSchedule."Principle Repayment";
                end;
                LoanApp.Reset();
                LoanApp.SetFilter("Date Filter", DateFilter);
                LoanApp.SetRange("Application No", "Loan Application"."Application No");
                if LoanApp.FindSet() then begin
                    LoanApp.CalcFields("Principle Balance", "Interest Balance", "Total Interest Due", "Interest Paid");
                    PrincipalPaid := LoanApp."Approved Amount" - LoanApp."Principle Balance";
                    ArrearsAmount -= PrincipalPaid;
                    InterestArrears := (LoanApp."Total Interest Due" + LoanApp."Interest Paid");
                    ArrearsAmount += InterestArrears;
                end;
                if ArrearsAmount <= 0 then
                    ArrearsAmount := 0;
                if ArrearsAmount = 0 then
                    CurrReport.Skip();
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                if GenJournalLine.FindSet() then
                    GenJournalLine.DeleteAll();
                DocumentNo := Format(PostingDate);
                VendorLedger.Reset();
                VendorLedger.SetRange("Document No.", DocumentNo);
                VendorLedger.SetRange("Reason Code", "Loan Application"."Application No");
                VendorLedger.SetRange(Reversed, false);
                if VendorLedger.FindFirst() then
                    CurrReport.Skip();

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := JournalTemplate;
                GenJournalLine."Journal Batch Name" := JournalBatch;
                GenJournalLine."Document No." := DocumentNo;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Posting Date" := PostingDate;
                LineNo += 1000;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", "Loan Application"."Loan Account");
                GenJournalLine."Debit Amount" := ABS(ArrearsAmount * LoanProducts."Penalty Rate" * 0.01);
                GenJournalLine.VALIDATE("Debit Amount");
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Due";
                GenJournalLine."Message to Recipient" := (COPYSTR('Penalty Charged On ' + "Loan Application"."Application No", 1, 50));
                GenJournalLine.Description := GenJournalLine."Message to Recipient";
                GenJournalLine."Due Date" := "Loan Application"."Repayment End Date";
                GenJournalLine."Reason Code" := "Loan Application"."Application No";
                GenJournalLine."Source Code" := "Loan Application"."Product Code";
                GenJournalLine."External Document No." := "Loan Application"."Member No.";
                GenJournalLine."Member No." := "Loan Application"."Member No.";
                GenJournalLine."Loan No." := "Loan Application"."Application No";
                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                GenJournalLine.Validate("Bal. Account No.", LoanProducts."Penalty Due Account");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                /*GenJournalLine.ValidateShortcutDimCode(3,"Loan Application"."Sector Code");
                GenJournalLine.ValidateShortcutDimCode(4,"Loan Application"."Subsector Code");
                GenJournalLine.ValidateShortcutDimCode(5,"Loan Application"."Sub-Subsector Code");*/
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
                //Post transaction
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                if GenJournalLine.FindSet() then
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field("Penalty Posting Date"; PenaltyDate) { }

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        GenJournalLine: Record "Gen. Journal Line";
        JournalTemplate: code[20];
        JournalBatch: code[20];
        LineNo: Integer;
        DocumentNo: code[20];
        PostingDate: date;
        Product: Record "Product Factory";
        LoansManagement: Codeunit "Loans Management";
        PenaltyDate: Date;
        Dim1: Code[20];
        Dim2: Code[20];
}

report 90004 "Loan Repayment Schedule"
{
    UsageCategory = Administration;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Schedule.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")

        {
            column(Application_No; "Application No") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Application_Date; "Application Date") { }
            column(Applied_Amount; "Applied Amount") { }
            dataitem("Loan Schedule"; "Loan Schedule")
            {
                DataItemLink = "Loan No." = field("Application No");
                column(Entry_No; "Entry No") { }
                column(Document_No_; "Document No.") { }
                column(Principle_Repayment; "Principle Repayment") { }
                column(Interest_Repayment; "Interest Repayment") { }
                column(Monthly_Repayment; "Monthly Repayment") { }
                column(Running_Balance; "Running Balance") { }
                column("CompanyLogo"; CompanyInformation.Picture) { }
                column("CompanyName"; CompanyInformation.Name) { }
                column("CompanyAddress1"; CompanyInformation.Address) { }
                column("CompanyAddress2"; CompanyInformation."Address 2") { }
                column("CompanyPhone"; CompanyInformation."Phone No.") { }
                column("CompanyEmail"; CompanyInformation."E-Mail") { }
                column(Expected_Date; "Expected Date") { }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
}
report 90005 "Loan Appraisal"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Appraisal.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {

            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(Member_No_; "Member No.") { }
            column(BridgingLoan; BridgingLoan) { }
            column(ProratedInterest; ProratedInterest) { }
            column(ExternalEffect; ExternalEffect) { }
            column(Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(Insurance_Amount; "Insurance Amount") { }
            column(GuarantorWarning; GuarantorWarning) { }
            column(LoanToDepositRatioWarning; LoanToDepositRatioWarning) { }
            column(AmountToDeposit; AmountToDeposit) { }
            column(BridgingCommision; BridgingCommision) { }
            column(ThirdRuleWarning; ThirdRuleWarning) { }
            column(Product_Description; "Product Description") { }
            column(Applied_Amount; "Applied Amount") { }
            column(PayrollNo; PayrollNo) { }
            column(Approved_Amount; "Approved Amount") { }
            column(TagLine; TagLine) { }
            column(Repayment_Start_Date; "Repayment Start Date") { }
            column(Repayment_End_Date; "Repayment End Date") { }
            column(Installments; Installments) { }
            column(Share_Capital; "Share Capital") { }
            column(Deposits; Deposits) { }
            column(Total_Loans; "Total Loans") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(AmountInWords; AmountInWords[1]) { }
            column(BasicPay; BasicPay) { }
            column(HouseAllowance; HouseAllowance) { }
            column(OtherEarnings; OtherEarnings) { }
            column(OtherDeductions; OtherDeductions) { }
            column(OneThird; OneThird) { }
            column(NetIncome; NetIncome) { }
            column(MInstallment; MInstallment) { }
            column(NewNet; NewNet) { }
            column(QualifiedAmount; QualifiedAmount) { }
            column(QualifiedDepositWise; QualifiedDepositWise) { }
            column(QualifiedSalaryWise; QualifiedSalaryWise) { }
            column(AvailableRecovery; AvailableRecovery) { }
            column(ClearedEffect; ClearedEffect) { }

            dataitem("Loan Charges"; "Loan Charges")
            {
                DataItemLink = "Loan No." = field("Application No");
                column(Loan_No_; "Loan No.") { }
                column(Charge_Code; "Charge Code") { }
                column(Charge_Description; "Charge Description") { }
                column(Rate; Rate) { }
                column(Rate_Type; "Rate Type") { }
                column(Amount; Amount) { }

                trigger OnAfterGetRecord()
                begin
                    Amount := 0;
                    Amount := "Loan Charges".Rate;
                    if "Loan Charges"."Rate Type" = "Loan Charges"."Rate Type"::"Percentage of Principle" then
                        Amount := "Loan Application"."Approved Amount" * "Loan Charges".Rate * 0.01;
                    net -= Amount;
                end;
            }
            dataitem("Loan Securities"; "Loan Securities")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Security_Type; "Security Type") { }
                column(Security_Code; "Security Code") { }
                column(Description; Description) { }
                column(Security_Value; "Security Value") { }
                trigger OnAfterGetRecord()
                begin
                    //Message('Get here');
                end;

            }
            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Member_No; "Member No") { }
                column(GMember_Name; "Member Name") { }
                column(Total_Deposits; "Member Deposits") { }
                column(Guarantor_Value; "Multiplied Deposits") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
                column(PFNumber; "Member No") { }
            }

            trigger OnPreDataItem()
            begin
                BasicPay := 0;
                HouseAllowance := 0;
                OtherEarnings := 0;
                OtherDeductions := 0;
                OneThird := 0;
                NetIncome := 0;
                MInstallment := 0;
                NewNet := 0;
                Net := 0;
                ClearedEffect := 0;
                GuarantorWarning := '';
                ThirdRuleWarning := '';
                ExternalEffect := 0;
                BridgingLoan := 0;
                ProratedInterest := 0;
                TagLine := '';
            end;

            trigger OnAfterGetRecord()
            var
                LCharge: record "Loan Charges";
                AppraisalParameters: Record "Loan Appraisal Parameters";
                LoansManagement: Codeunit "Loans Management";
                LoanRecoveries: Record "Loan Recoveries";
            begin
                "Loan Application".Validate("Insurance Amount");
                LoansManagement.GetDepositBoostAmount("Loan Application"."Application No");
                PayrollNo := '';
                if Member.get("Loan Application"."Member No.") then
                    PayrollNo := Member."Payroll No.";
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount, "Commission Amount", "Prorated Interest");
                    BridgingLoan := LoanRecoveries.Amount;
                    ProratedInterest := LoanRecoveries."Prorated Interest";
                    BridgingCommision := LoanRecoveries."Commission Amount";
                end;
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::External);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount, "Commission Amount");
                    ExternalEffect := LoanRecoveries.Amount;
                end;
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Account);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount, "Commission Amount");
                    AmountToDeposit := LoanRecoveries.Amount;
                end;
                "Loan Application".Deposits := LoansManagement.GetMemberDeposits("Loan Application"."Member No.");
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                Net := "Loan Application"."Approved Amount";
                GuarantorWarning := '';
                "Loan Application".CalcFields("Total Securities", "Total Collateral");
                if "Loan Application"."Total Securities" + "Loan Application"."Total Collateral" < "Loan Application"."Applied Amount" then
                    GuarantorWarning := 'The Loan is unsecured';
                "Loan Application".CalcFields("Monthly Inistallment");
                MInstallment := "Loan Application"."Monthly Inistallment";
                AppraisalParameters.Reset();
                AppraisalParameters.SetRange("Loan No", "Loan Application"."Application No");
                if AppraisalParameters.FindSet() then begin
                    repeat
                        if AppraisalParameters.Type = AppraisalParameters.Type::Earnig then
                            NetIncome += AppraisalParameters."Parameter Value"
                        else
                            NetIncome -= AppraisalParameters."Parameter Value";
                        ParameterSetup.Get(AppraisalParameters."Appraisal Code");
                        if ParameterSetup."Cleared Effect" then
                            ClearedEffect += AppraisalParameters."Parameter Value";
                        if AppraisalParameters.Type = AppraisalParameters.Type::Deduction then
                            OtherDeductions += AppraisalParameters."Parameter Value"
                        else begin
                            if AppraisalParameters.Class = AppraisalParameters.Class::"Basic Pay" then
                                BasicPay += AppraisalParameters."Parameter Value"
                            else
                                if AppraisalParameters.Class = AppraisalParameters.Class::Allowance then
                                    HouseAllowance += AppraisalParameters."Parameter Value"
                                else begin
                                    if ParameterSetup."Cleared Effect" = false then
                                        OtherEarnings += AppraisalParameters."Parameter Value";
                                end;
                        end;
                    until AppraisalParameters.Next() = 0;
                end;
                LoanProduct.get("Loan Application"."Product Code");
                SpecialLoan := 0;
                SpecialLoans2 := 0;
                LoansManagement.GetMemberSpecialLoanAmount("Loan Application"."Member No.", SpecialLoans2, SpecialLoan);
                "Total Loans" := LoansManagement.GetMemberLoans("Loan Application"."Member No.") - LoansManagement.GetRefinancedLoans("Application No") - SpecialLoans2;
                QualifiedDepositWise := ((LoansManagement.GetMemberDeposits("Loan Application"."Member No.") - SpecialLoan + LoansManagement.GetBoostedDeposits("Loan Application"."Application No")) * LoanProduct."Loan Multiplier");
                QualifiedSalaryWise := 0;
                OneThird := (1 / 3) * BasicPay;
                NewNet := NetIncome - MInstallment;
                AvailableRecovery := NetIncome - OneThird;
                QualifiedAmount := QualifiedDepositWise;
                MaxCredit := QualifiedDepositWise - "Total Loans";
                if NewNet < OneThird then
                    ThirdRuleWarning := 'One third rule not met';

                if LoanProduct."Appraise with 0 Deposits" = false then begin
                    if QualifiedAmount < "Loan Application"."Applied Amount" then
                        LoanToDepositRatioWarning := 'Loan-to-Deposit ratio not met';
                end;
                if (("Loan Application"."Applied Amount" <= MaxCredit) OR (NewNet > OneThird)) then
                    TagLine := 'This member qualifies for ' + Format("Loan Application"."Applied Amount") + ' recoverable ' + format(Round("Loan Application"."Monthly Inistallment", 0.10, '=')) + ' for ' + Format("Loan Application".Installments) + ' months'
                else
                    TagLine := 'This member does not qualify for ' + Format("Loan Application"."Applied Amount");
                "Loan Application".CalcFields("Total Recoveries");
                if "Loan Application"."Total Recoveries" > "Loan Application"."Applied Amount" then
                    ThirdRuleWarning := 'You cannot refinance more than the applied amount';
                /* Clear(AmountInWords)
                 Check.InitTextVariable();
                 Check.FormatNoText(AmountInWords, Net, '');*/
                if QualifiedAmount > "Loan Application"."Applied Amount" then
                    QualifiedAmount := "Loan Application"."Applied Amount";
                if "Loan Application"."Appraisal Commited" = false then begin
                    if ((LoanProduct."Appraise with 0 Deposits") AND (NewNet > OneThird)) then begin
                        "Loan Application"."Recommended Amount" := "Loan Application"."Applied Amount";
                        "Loan Application"."Approved Amount" := "Loan Application"."Applied Amount";
                    end else begin
                        "Loan Application"."Recommended Amount" := QualifiedAmount;
                        "Loan Application"."Approved Amount" := QualifiedAmount;
                    end;
                    "Loan Application".Modify();
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        PayrollNo: Code[20];
        Amount: Decimal;
        MaxCredit, AvailableRecovery, QualifiedSalaryWise, QualifiedDepositWise, QualifiedAmount, BridgingLoan, ProratedInterest, ExternalEffect, AmountToDeposit, BridgingCommision : decimal;
        ClearedEffect, BasicPay, HouseAllowance, OtherEarnings, OtherDeductions, OneThird, NetIncome, MInstallment, NewNet : decimal;
        CompanyInformation: Record "Company Information";
        Check: report Check;
        AmountInWords: array[2] of Text[250];
        LoanProduct: Record "Product Factory";
        AppraisalAccounts: Record "Appraisal Accounts";
        Net: Decimal;
        Member: Record Members;
        ParameterSetup: Record "Appraisal Parameters";
        TagLine, GuarantorWarning, ThirdRuleWarning, LoanToDepositRatioWarning, RetirementWarning : Text[100];
        SpecialLoan, SpecialLoans2 : Decimal;

}
report 90006 "Generate Loan Ageing - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Loan Application"."Member Name");
                LoansManagement.ClassifyLoan("Application No", AsAtDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Report Parameters")
                {
                    field("As At Date"; AsAtDate)
                    {
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnInitReport()
    begin
        Window.Open('Calculating Arrears \#1###');
    end;

    trigger OnPostReport()
    begin
        Window.Close();
    end;

    var
        LoansManagement: Codeunit "Loans Management";
        AsAtDate: date;
        Window: Dialog;
}
report 90007 "Collateral Acceptance"
{
    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Collateral Acceptance.rdl';
    dataset
    {
        dataitem("Collateral Application"; "Collateral Application")
        {
            column(Document_No; "Document No") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Collateral_Description; "Collateral Description") { }
            column(National_ID_No; "National ID No") { }
            column(KRA_PIN_No_; "KRA PIN No.") { }
            column(Serial_No; "Serial No") { }
            column(Registration_No; "Registration No") { }
            column(Joint_Ownership; "Joint Ownership") { }
            column(Collateral_Value; "Collateral Value") { }
            column(Last_Valuation_Date; "Last Valuation Date") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
}

report 90008 "Loan Register"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan register.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date";
            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(EmployerCode; EmployerCode) { }
            column(EmployerName; EmployerName) { }
            column(Product_Description; "Product Description") { }
            column(Applied_Amount; "Applied Amount") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Interest_Balance; "Interest Balance") { }
            column(Penalty_Balance; "Penalty Balance") { }
            column(Principle_Balance; "Principle Balance") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Branch; "Global Dimension 1 Code") { }
            column(Interest_Rate; "Interest Rate") { }
            column(Installments; Installments) { }
            column(Sales_Person; "Sales Person") { }
            column(Sales_Person_Name; "Sales Person Name") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Interest_Repayment_Method; "Interest Repayment Method") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                EmployerCode := '';
                EmployerName := '';
                if Members.Get("Member No.") then begin
                    if Employers.Get(EmployerCode) then begin
                        EmployerCode := Employers.Code;
                        EmployerName := Employers.Name;
                    end;
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
}

report 90009 "Member Statement"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Statement.rdl';

    dataset
    {
        dataitem(Member; Members)
        {
            RequestFilterFields = "Member No.", "Date Filter";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column("MemberNo"; Member."Member No.") { }
            column("MemberName"; Member."Full Name") { }
            column("PhoneNo"; Member."Mobile Phone No.") { }
            column("NationalIDNo"; Member."National ID No") { }
            column("KRAPINNo"; Member."KRA PIN") { }
            column(Payroll_No; "Payroll No") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No."), "No." = field("Account Filter");
                DataItemTableView = sorting("No.") where("Account Class" = filter(<> Loan));
                column(No_; "No.") { }
                column(Name; Name) { }
                column(OpenningBalance; OpenningBalance) { }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Entry No.") where(reversed = const(false));
                    column(Entry_No_; "Entry No.") { }
                    column(Posting_Date; "Posting Date") { }
                    column(Document_No_; "Document No.") { }
                    column(Description; Description) { }
                    column(Debit_Amount; "Debit Amount") { }
                    column(Credit_Amount; "Credit Amount") { }
                    column(RunningBalance; RunningBalance) { }
                    trigger OnAfterGetRecord()
                    begin
                        "Vendor Ledger Entry".CalcFields(Amount);
                        RunningBalance += (-1 * "Vendor Ledger Entry".Amount);
                    end;
                }
                trigger OnPreDataItem()
                begin
                    if ((LoanFilter <> '') AND (AccountFilter = '')) then
                        Vendor.SetFilter("Member No.", 'philipayekomukhebo');
                    if DateFilter <> '' then begin
                        OpenningBalance := 0;
                        RunningBalance := 0;
                        DateRec.Reset();
                        DateRec.SetFilter("Period Start", DateFilter);
                        if DateRec.FindSet() then begin
                            RangeMin := DateRec.GetRangeMin("Period Start");
                            RangeMin := CalcDate('-1D', RangeMin);
                        end;
                    end;
                end;

                trigger OnAfterGetRecord()
                begin
                    OpenningBalance := 0;
                    RunningBalance := 0;
                    if Member.Get(Vendor."Member No.") then;
                    DetailedEntries.Reset();
                    DetailedEntries.SetRange("Vendor No.", Vendor."No.");
                    if RangeMin <> 0D then
                        DetailedEntries.SetFilter("Posting Date", '..%1', RangeMin);
                    if DetailedEntries.FindSet() then begin
                        DetailedEntries.CalcSums(Amount);
                        OpenningBalance := DetailedEntries.Amount;
                    end;
                    OpenningBalance := RunningBalance;
                end;
            }
            dataitem("Loan Application"; "Loan Application")
            {
                DataItemLink = "Member No." = field("Member No."), "Application No" = field("Loan Filter");
                DataItemTableView = sorting("Application No");
                column(Application_No; "Application No") { }
                column(Member_No_; "Member No.") { }
                column(ProductNameCalculated; ProductName) { }
                column(Application_Date; "Application Date") { }
                column(Approved_Amount; "Approved Amount") { }
                column(Monthly_Inistallment; ProductName) { }
                column(LoanName; "Product Description") { }
                column(Product_Code; "Product Code") { }
                column(Product_Description; "Product Description") { }
                dataitem(CreditLedger; "Vendor Ledger Entry")
                {
                    DataItemTableView = sorting("Entry No.") where(Reversed = const(false));
                    DataItemLink = "Loan No." = field("Application No"), "Vendor No." = field("Loan Account");
                    column(CredEntry_No_; "Entry No.") { }
                    column(CredPosting_Date; "Posting Date") { }
                    column(CredDocument_No_; "Document No.") { }
                    column(CredDescription; Description) { }
                    column(CredDebit_Amount; "Debit Amount") { }
                    column(CredCredit_Amount; "Credit Amount") { }
                    column(CredRunningBalance; RunningBalance) { }
                    trigger OnAfterGetRecord()
                    begin
                        CalcFields(Amount);
                        RunningBalance += Amount;
                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    "Loan Application".CalcFields(Disbursements);
                    if "Loan Application".Disbursements = 0 then
                        CurrReport.Skip();
                    RunningBalance := 0;
                    OpenningBalance := 0;
                    RunningBalance := OpenningBalance;
                    ProductName := '';
                    ProductName := "Loan Application"."Product Description";
                end;

                trigger OnPreDataItem()
                begin
                    if ((LoanFilter = '') AND (AccountFilter <> '')) then
                        "Loan Application".SetFilter("Member No.", 'philipayekomukhebo');
                end;

            }
            trigger OnPreDataItem()
            begin

                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                DateFilter := '';
                LoanFilter := '';
                AccountFilter := '';
                LoanFilter := Member.GetFilter("Loan Filter");
                AccountFilter := Member.GetFilter("Account Filter");
                DateFilter := Member.GetFilter("Date Filter");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        ProductName: Text;
        DateFilter: Text[250];
        OpenningBalance: Decimal;
        RunningBalance: Decimal;
        DetailedEntries: Record "Detailed Vendor Ledg. Entry";
        RangeMin: date;
        DateRec: Record Date;
        CompanyInformation: Record "Company Information";
        LoanFilter, AccountFilter : text[100];
}

report 90010 "Payments Due"
{
    UsageCategory = Administration;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Payment Details.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter";
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(PhoneNo; PhoneNo) { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            dataitem("Loan Schedule"; "Loan Schedule")
            {
                DataItemLink = "Loan No." = field("Application No"), "Expected Date" = field("Date Filter");
                column(Expected_Date; "Expected Date") { }
                column(Monthly_Repayment; "Monthly Repayment") { }
                column(Interest_Repayment; "Interest Repayment") { }
                column(Principle_Repayment; "Principle Repayment") { }
            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                PhoneNo := '';
                if Members.get("Loan Application"."Member No.") then
                    PhoneNo := Members."Mobile Phone No.";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Members: Record Members;
        PhoneNo: Code[30];
}
report 90011 "Collateral Collection"
{
    UsageCategory = Administration;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Collateral Release.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Collateral Release"; "Collateral Release")
        {
            column(Document_No; "Document No") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Comments; Comments) { }
            column(Remarks; Remarks) { }
            column(Collateral; Collateral) { }
            column(Collateral_Description; "Collateral Description") { }
            column(Collected_By; "Collected By") { }
            column(Collected_By_ID_No; "Collected By ID No") { }
            column(Collection_Date; "Collection Date") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            dataitem("Loan Schedule"; "Loan Schedule") { }
            trigger OnPreDataItem()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
}

report 90012 "Payment Reminders - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = True;
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            //DataItemTableView = where(Posted = const(true), Closed = const(false));
            trigger OnAfterGetRecord()
            begin
                "Loan Application".CalcFields("Loan Balance");
                if "Loan Application"."Loan Balance" <= 0 then
                    CurrReport.Skip();
                MInstallment := 0;
                TargetDate := DMY2Date(25, 02, 2021);
                LoanSchedule.Reset();
                LoanSchedule.SetRange("Loan No.", "Loan Application"."Application No");
                LoanSchedule.SetRange("Expected Date", TargetDate);
                if LoanSchedule.FindFirst() then
                    MInstallment := round(LoanSchedule."Monthly Repayment", 1, '>');
                SMS := 'Dear ' + "Loan Application"."Member Name" + ' Your ' + "Loan Application"."Product Description"
                + ' Monthly Installment of Ksh. ' + Format(MInstallment)
                + ' is Due on ' + Format(TargetDate) + '. Thank You';
                PhoneNo := '0729143665';
                if MInstallment > 0 then
                    NotificationsMgt.SendSms(PhoneNo, SMS);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        TargetDate: Date;
        PhoneNo: Text[250];
        SMS: Text[250];
        Members: Record Members;
        Amnt: Decimal;
        CompanyInformation: Record "Company Information";
        LoanSchedule: Record "Loan Schedule";
        MInstallment: Decimal;
        NotificationsMgt: Codeunit "Notifications Management";
}

report 90013 "Bulk SMS"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = True;
    dataset
    {
        dataitem(Members; Members)
        {
            trigger OnAfterGetRecord()
            begin
                if Members."Mobile Phone No." = '' then
                    CurrReport.Skip();
                if sms = '' then
                    Error('Please Fill In the SMS Message');
                PhoneNo := '';
                PhoneNo := Members."Mobile Phone No.";
                NotificationsMgt.SendSms(PhoneNo, SMS);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("SMS Message")
                {
                    field(SMS; SMS)
                    {
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        PhoneNo: Text[250];
        SMS: Text[250];
        Amnt: Decimal;
        CompanyInformation: Record "Company Information";
        LoanSchedule: Record "Loan Schedule";
        MInstallment: Decimal;
        NotificationsMgt: Codeunit "Notifications Management";

}

report 90014 "Loan Transactions"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Transactions.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date";
            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column(Applied_Amount; "Applied Amount") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Interest_Balance; "Interest Paid") { }
            column(Penalty_Balance; "Penalty Paid") { }
            column(Principle_Balance; "Principle Paid") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Branch; "Global Dimension 1 Code") { }
            column(Interest_Rate; "Interest Rate") { }
            column(Installments; Installments) { }
            column(Sales_Person; "Sales Person") { }
            column(Sales_Person_Name; "Sales Person Name") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Total_Interest_Due; "Total Interest Due") { }
            column(Interest_Paid; "Interest Paid") { }
            column(Principle_Paid; "Principle Paid") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                ProjectedInterest := 0;
                LoanSchedule.Reset();
                LoanSchedule.SetRange("Loan No.", "Loan Application"."Application No");
                if LoanSchedule.FindSet() then begin
                    LoanSchedule.CalcSums("Interest Repayment");
                    ProjectedInterest := LoanSchedule."Interest Repayment";
                end;
                "Loan Application".CalcFields("Total Interest Due");
                ProjectedInterest -= "Loan Application"."Total Interest Due";
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        ProjectedInterest: Decimal;
        LoanSchedule: Record "Loan Schedule";
}
report 90015 "Defaulter Notice"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Defaulter Notice.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Member No.";
            CalcFields = "Loan Balance", "Monthly Principle";
            column(Application_No; "Application No") { }
            column(Main_Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(DefaulterSignature; CompanyInformation.Defaulter) { }
            column(Approved_Amount; Format("Approved Amount")) { }
            column(Total_Arrears; "Total Arrears") { }
            column(NoticeDate; NoticeDate) { }
            column(Posting_Date; "Posting Date") { }
            column(Monthly_Principle; Format(Round("Monthly Principle", 1, '>'))) { }
            column(Loan_Balance; Format(Round("Loan Balance", 1, '>'))) { }
            column(Defaulted_Installments; "Defaulted Installments") { }
            column(MemberAddress; MemberInfo[1]) { }
            column(MemberEmail; MemberInfo[2]) { }
            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Loan No" = field("Application No");
                DataItemTableView = where(Substituted = const(false));
                column(Member_No; "Member No") { }
                column(Member_Name; "Member Name") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
            }
            trigger OnAfterGetRecord()
            begin
                Clear(MemberInfo);
                Members.Get("Member No.");
                MemberInfo[1] := Members.Address;
                MemberInfo[2] := Members."E-Mail Address";
                if NoticeDate = 0D then
                    NoticeDate := Today;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture, Defaulter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        NoticeDate: Date;
        CompanyInformation: Record "Company Information";
        PayrollNo: Code[20];
        MemberMgt: Codeunit "Member Management";
        IssueDate: Date;
        MemberInfo: array[10] of Text[100];
        Members: Record Members;
}
report 90016 "Member List"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Member List.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            column(Member_No_; "Member No.") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Mobile_Phone_No_; "Mobile Phone No.") { }
            column(Alt__Phone_No; "Alt. Phone No") { }
            column(Gender; Gender) { }
            column(Date_of_Birth; "Date of Birth") { }
            column(Payroll_No; "Payroll No") { }
            column(Date_of_Registration; "Date of Registration") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
}
report 90017 "Accrue FD Interests - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Fixed Deposit Register"; "Fixed Deposit Register")
        {
            DataItemTableView = where(Posted = const(true));
            trigger OnAfterGetRecord()
            begin
                FDManagement.PostFDAccrual("Fixed Deposit Register");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        FDManagement: Codeunit "Fixed Deposit Mgt.";
}

report 90018 "Marture Fixed Deposits - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Fixed Deposit Register"; "Fixed Deposit Register")
        {
            DataItemTableView = where(Posted = const(true), Terminated = const(false));
            trigger OnAfterGetRecord()
            var
                FDManagement: Codeunit "Fixed Deposit Mgt.";
            begin
                if "Fixed Deposit Register"."End Date" = Today then begin
                    FDManagement.MatureFixedDeposit("Fixed Deposit Register");
                end else
                    CurrReport.Skip();
                ;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
}
report 90019 "Payment Voucher"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\Financials\Report Layouts\Payment Voucher.rdl';
    dataset
    {
        dataitem("Payments Header"; "Payments Header")
        {
            column(Document_No_; "Document No.") { }
            column(Paying_Account_Type; "Paying Account Type") { }
            column(Paying_Account_No_; "Paying Account No.") { }
            column(Paying_Account_Name; "Paying Account Name") { }
            column(Payee_Account_Type; "Payee Account Type") { }
            column(Payee_Account_No; "Payee Account No") { }
            column(Payee_Account_Name; "Payee Account Name") { }
            column(Posting_Description; "Posting Description") { }
            column(Posting_Date; "Posting Date") { }
            column(payment_Amount; "payment Amount") { }
            column("Cheque_No"; "Cheque No") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(AmountInWords; AmountInWords[1]) { }
            trigger OnAfterGetRecord()
            begin
                /* Check.InitTextVariable();
                 Check.FormatNoText(AmountInWords, "payment Amount", '');
                 CompanyInformation.get;
                 CompanyInformation.CalcFields(Picture);*/
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        AmountInWords: array[2] of Text[250];
        Check: report Check;
        CompanyInformation: record "Company Information";
}
report 90020 "Cash Book"
{
    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC; //0606
    RDLCLayout = '.\Loan Management\Credit Reports\Cash Book.rdl';

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            RequestFilterFields = "No.", "Date Filter";
            column(No_; "No.") { }
            column(Name; Name) { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(OpenningBalance; OpenningBalance) { }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No."), "Posting Date" = field("Date Filter");
                DataItemTableView = sorting("Posting Date", "Entry No.") where(reversed = const(false));
                column(Entry_No_; "Entry No.") { }
                column(Posting_Date; "Posting Date") { }
                column(Document_No_; "Document No.") { }
                column(Amount; Amount) { }
                column(Credit_Amount; "Credit Amount") { }
                column(Debit_Amount; "Debit Amount") { }
                column(RunningBalance; RunningBalance) { }
                column(User_ID; "User ID") { }
                column(Description; Description) { }
                trigger OnAfterGetRecord()
                begin
                    RunningBalance += "Bank Account Ledger Entry".Amount;
                end;
            }
            trigger OnPostDataItem()
            begin
                DateFilter := "Bank Account".GetFilter("Date Filter");
                OpenningBalance := 0;
                RunningBalance := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                OpenningBalance := 0;
                if DateFilter <> '' then begin
                    DateRec.Reset();
                    DateRec.SetFilter("Period Start", DateFilter);
                    if DateRec.FindFirst() then begin
                        LowDate := DateRec.GetRangeMin("Period Start");
                        LowDate := CalcDate('-1D', LowDate);
                    end;
                    BankLedger.Reset();
                    BankLedger.SetFilter("Posting Date", '..%1', LowDate);
                    BankLedger.SetRange("Bank Account No.", "Bank Account"."No.");
                    if BankLedger.FindSet() then begin
                        BankLedger.CalcSums(Amount);
                        OpenningBalance := BankLedger.Amount;
                    end;
                end else
                    OpenningBalance := 0;
                RunningBalance := OpenningBalance;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        OpenningBalance: Decimal;
        RunningBalance: Decimal;
        DateFilter: Text;
        BankLedger: Record "Bank Account Ledger Entry";
        DateRec: Record Date;
        LowDate: date;
}
report 90021 "Cash Receipt"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\Receipt.rdl';
    dataset
    {
        dataitem("Receipt Header"; "Receipt Header")
        {
            column(Receipt_No_; "Receipt No.") { }
            column(Receiving_Account_Type; "Receiving Account Type") { }
            column(Receiving_Account_No_; "Receiving Account No.") { }
            column(Receiving_Account_Name; "Receiving Account Name") { }
            column(Posting_Date; "Posting Date") { }
            column(Posting_Description; "Posting Description") { }
            column(Amount; Amount) { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            dataitem("Receipt Lines"; "Receipt Lines")
            {
                DataItemLink = "Receipt No." = field("Receipt No.");
                column(Receipt_Type; "Receipt Type") { }
                column(Description; Description) { }
                column(AllocationAmount; Amount) { }
                column(Member_No_; "Member No.") { }
                column(MemberName; MemberName) { }
                trigger OnAfterGetRecord()
                begin
                    MemberName := '';
                    if Members.Get("Member No.") then
                        MemberName := Members."Full Name"
                    else
                        MemberName := 'Non Member';
                end;

            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {

            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Members: Record Members;
        MemberName: Text;
}
report 90022 "Run Standing Orders - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Standing Order"; "Standing Order")
        {
            trigger OnAfterGetRecord()
            begin
                if RunDate = 0D then
                    RunDate := Today;
                if "Standing Order"."Salary Based" then
                    CurrReport.Skip();
                if "Standing Order"."Amount Type" = "Standing Order"."Amount Type"::Sweep then
                    CurrReport.Skip();
                if "Standing Order"."Run From Day" = 0 then
                    CurrReport.Skip();
                FosaMgt.RunStandingOrder("Standing Order"."Document No", RunDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Parameters)
                {
                    field(Name; RunDate)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        RunDate: Date;
        FosaMgt: Codeunit "FOSA Management";
}

report 90023 "Disbursement Schedule"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\DisbursementSchedule.rdl';
    dataset
    {
        dataitem("Loan Batch Header"; "Loan Batch Header")
        {

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Document_No; "Document No") { }
            column(Created_By; "Created By") { }
            column(Created_On; "Created On") { }
            column(Posting_Date; "Posting Date") { }
            dataitem("Loan Batch Lines"; "Loan Batch Lines")
            {
                DataItemLink = "Batch No" = field("Document No");
                DataItemTableView = sorting("Batch No", "Loan No");
                column(Loan_No; "Loan No") { }
                column(ApprovedAmount; ApprovedAmount) { }
                column(MemberNo; MemberNo) { }
                column(MemberName; MemberName) { }
                column(BankCode; BankCode) { }
                column(BankAccount; BankAccount) { }
                column(BridgedAmount; BridgedAmount) { }
                column(BridgedCommission; BridgedCommission) { }
                column(InsurancePremium; InsurancePremium) { }
                column(RTGS; RTGS) { }
                column(SMS; SMS) { }
                column(RobinhoodTax; RobinhoodTax) { }
                column(ShareBoostComm; ShareBoostComm) { }
                column(CRB; CRB) { }
                column(Appraisal; Appraisal) { }
                column(ChequeAmount; ChequeAmount) { }
                column(InvestmentAmount; InvestmentAmount) { }
                column(ShareBoost; ShareBoost) { }
                column(Interest; Interest) { }
                column(AmountDue; AmountDue) { }
                column(Product; Product) { }
                trigger OnAfterGetRecord()
                begin
                    CRB := 0;
                    Appraisal := 0;
                    SMS := 0;
                    InsurancePremium := 0;
                    BridgedAmount := 0;
                    BridgedCommission := 0;
                    ShareBoost := 0;
                    ShareBoostComm := 0;
                    ApprovedAmount := 0;
                    NetAmount := 0;
                    MemberNo := '';
                    MemberName := '';
                    BankCode := '';
                    BankAccount := '';
                    Product := '';
                    ChequeAmount := 0;
                    if LoanApplication.Get("Loan No") then begin
                        Interest := LoanApplication."Approved Amount" * LoanApplication."Interest Rate" * 0.01 * (1 / 12) * (1 / 30) * LoanApplication."Prorated Days";
                        Interest := Round(Interest, 1, '=');
                        MemberNo := LoanApplication."Member No.";
                        MemberName := LoanApplication."Member Name";
                        BankAccount := LoanApplication."Pay to Account No";
                        BankCode := LoanApplication."Pay to Bank Code";
                        if BankCode = '' then begin
                            BankCode := 'FOSA';
                            BankAccount := LoanApplication."Disbursement Account";
                        end;
                        ApprovedAmount := LoanApplication."Approved Amount";
                        LoanRecovery.Reset();
                        LoanRecovery.SetRange("Recovery Type", LoanRecovery."Recovery Type"::Loan);
                        LoanRecovery.SetRange("Loan No", LoanApplication."Application No");
                        if LoanRecovery.FindSet() then begin
                            LoanRecovery.CalcSums(Amount, "Commission Amount");
                            BridgedAmount := LoanRecovery.Amount;
                            BridgedAmount := LoanRecovery."Commission Amount";
                        end;

                        LoanRecovery.Reset();
                        LoanRecovery.SetRange("Recovery Type", LoanRecovery."Recovery Type"::Loan);
                        LoanRecovery.SetRange("Loan No", LoanApplication."Application No");
                        if LoanRecovery.FindSet() then begin
                            LoanRecovery.CalcSums(Amount, "Commission Amount");
                            BridgedAmount := LoanRecovery.Amount;
                            BridgedCommission := LoanRecovery."Commission Amount";
                        end;
                        LoanRecovery.Reset();
                        LoanRecovery.SetRange("Recovery Type", LoanRecovery."Recovery Type"::Account);
                        LoanRecovery.SetRange("Loan No", LoanApplication."Application No");
                        if LoanRecovery.FindSet() then begin
                            LoanRecovery.CalcSums(Amount, "Commission Amount");
                            ShareBoost := LoanRecovery.Amount;
                            ShareBoostComm := LoanRecovery."Commission Amount";
                        end;
                        LoanRecovery.Reset();
                        LoanRecovery.SetRange("Recovery Type", LoanRecovery."Recovery Type"::External);
                        LoanRecovery.SetRange("Loan No", LoanApplication."Application No");
                        if LoanRecovery.FindSet() then begin
                            LoanRecovery.CalcSums(Amount, "Commission Amount");
                            ChequeAmount := LoanRecovery.Amount;
                        end;
                        InsurancePremium := LoanApplication."Insurance Amount";
                        if LoanProducts.get(LoanApplication."Product Code") then begin
                            Product := LoanProducts.Name;
                            CRB := LoansMgt.GetChargeAmount(LoanProducts."Loan Charges", 'CRB', LoanApplication."Approved Amount");
                            Appraisal := LoansMgt.GetChargeAmount(LoanProducts."Loan Charges", 'APPR', LoanApplication."Approved Amount");
                            SMS := LoansMgt.GetChargeAmount(LoanProducts."Loan Charges", 'SMS', LoanApplication."Approved Amount");
                            RTGS := LoansMgt.GetChargeAmount(LoanProducts."Loan Charges", 'RTGS', LoanApplication."Approved Amount");
                            RobinhoodTax := LoansMgt.GetChargeAmount(LoanProducts."Loan Charges", 'APP-DUTY', LoanApplication."Approved Amount");
                        end;
                    end;
                    NetAmount :=
                    ApprovedAmount - CRB - Appraisal - SMS - InsurancePremium - BridgedAmount - BridgedCommission - ShareBoost - ShareBoostComm - RTGS - RobinhoodTax - InvestmentAmount - Interest - ChequeAmount;
                    AmountDue := NetAmount;
                end;

            }
            trigger OnPreDataItem()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        LoanRecovery: Record "Loan Recoveries";
        LoanProducts: Record "Product Factory";
        LoanApplication: Record "Loan Application";
        LoansMgt: Codeunit "Loans Management";
        Product, BankCode, BankAccount, MemberNo, MemberName : Code[100];
        CompanyInformation: Record "Company Information";
        Member: Record Members;
        Interest, AmountDue, ApprovedAmount, NetAmount : decimal;
        BridgedAmount, BridgedCommission, InsurancePremium, RTGS, SMS, RobinhoodTax, ShareBoostComm, CRB, Appraisal, ChequeAmount, InvestmentAmount, ShareBoost : Decimal;
}
report 90024 "Guarantor Register"
{
    UsageCategory = Administration;
    ApplicationArea = All;

    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Guarantors.rdl';
    dataset
    {
        dataitem("Loan Guarantees"; "Loan Guarantees")
        {
            column(Loan_No; "Loan No") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Member_Deposits; "Member Deposits") { }
            column(Guaranteed_Amount; "Guaranteed Amount") { }
            column(Substituted; Substituted) { }
            column(Arrears; Arrears) { }
            column(LoanClassification; LoanClassification) { }
            column(Outstanding_Guarantees; "Outstanding Guarantees") { }
            column(OwnerNo; OwnerNo) { }
            column(OwnerName; OwnerName) { }
            column(LoanBalance; LoanBalance) { }
            column(ProductCode; ProductCode) { }
            column(ProductName; ProductName) { }
            column(LoanPrinciple; LoanPrinciple) { }
            trigger OnAfterGetRecord()
            begin
                OutstandingGrnt := 0;
                LoanClassification := '';
                Arrears := 0;
                OwnerName := '';
                OwnerNo := '';
                ProductCode := '';
                ProductName := '';
                LoanPrinciple := 0;
                LoanBalance := 0;
                if LoanApplication.Get("Loan Guarantees"."Loan No") then begin
                    LoanApplication.CalcFields("Loan Balance");
                    ProductCode := LoanApplication."Product Code";
                    ProductName := LoanApplication."Product Description";
                    OwnerName := LoanApplication."Member Name";
                    OwnerNo := LoanApplication."Member No.";
                    LoanBalance := LoanApplication."Loan Balance";
                    LoanPrinciple := LoanApplication."Applied Amount";
                    LoanClassification := Format(LoanApplication."Loan Classification");
                    Arrears := LoanApplication."Total Arrears";
                    OutstandingGrnt := MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", "Loan Guarantees"."Member No");
                end else
                    CurrReport.Skip();
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        MemberMgt: Codeunit "Member Management";
        LoanApplication: Record "Loan Application";
        OutstandingGrnt, Arrears, LoanPrinciple, LoanBalance : Decimal;
        LoanClassification, OwnerNo, OwnerName, ProductCode, ProductName : Text;
}
report 90025 "Statement of Deposit Rtn."
{
    UsageCategory = Administration;
    ApplicationArea = All;

    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\StatementOfDepositReturn.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Member_No_; "Member No.") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No.");
                column(Account_Code; "Account Code") { }
                column(Net_Change; "Net Change") { }
                column(AccountClass; AccountClass) { }
                column(GroupCode; GroupCode) { }
                column(GroupOrder; GroupOrder) { }
                column(Position; Position) { }
                trigger OnPreDataItem()
                begin
                    Vendor.SetFilter("Date Filter", DateFilter);
                end;

                trigger OnAfterGetRecord()
                begin
                    Vendor.CALCFIELDS("Net Change");
                    Position := 0;
                    AccountClass := '';
                    GroupCode := '';
                    GroupOrder := 0;
                    IF Vendor."Share Capital Account" THEN
                        CurrReport.SKIP;
                    if Vendor."Account Class" = Vendor."Account Class"::Loan then
                        CurrReport.Skip();
                    IF (Vendor."Net Change") > 1000000 THEN BEGIN
                        AccountClass := 'Over 1,000,000';
                        Position := 5;
                    END ELSE
                        IF (((Vendor."Net Change") >= 300000) AND (((Vendor."Net Change") <= 1000000))) THEN BEGIN
                            AccountClass := '300,000 to 1,000,000';
                            Position := 4;
                        END ELSE
                            IF (((Vendor."Net Change") >= 100000) AND (((Vendor."Net Change") < 300000))) THEN BEGIN
                                AccountClass := '100,000 to 300,000';
                                Position := 3;
                            END ELSE
                                IF (((Vendor."Net Change") >= 50000) AND (((Vendor."Net Change") < 100000))) THEN BEGIN
                                    AccountClass := '50,000 to 100,000';
                                    Position := 2;
                                END ELSE
                                    IF (Vendor."Net Change") < 50000 THEN BEGIN
                                        AccountClass := 'Less than 50,000';
                                        Position := 1;
                                    END;
                    IF Vendor."Fixed Deposit Account" THEN BEGIN
                        GroupCode := 'Term';
                        GroupOrder := 3;
                    END ELSE BEGIN
                        IF Vendor."NWD Account" THEN BEGIN
                            GroupCode := 'Non-Withdrawable';
                            GroupOrder := 2;
                        END ELSE BEGIN
                            GroupCode := 'Savings';
                            GroupOrder := 1;
                        END;
                    END;

                end;
            }
            trigger OnAfterGetRecord()
            begin
                DateFilter := '';
                DateFilter := Members.GetFilter("Date Filter");
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        CompanyInformation: Record "Company Information";
        DateFilter: Text[100];
        Position, GroupOrder : Integer;
        AccountClass, GroupCode : Code[100];
}

report 90026 "Risk Classification"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\RiskClassification.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            column(Loan_Classification; "Loan Classification") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Provision; Provision) { }
            column(ProvisionAmount; ProvisionAmount) { }
            column(Net_Change_Principal; "Net Change-Principal") { }
            column(Application_No; "Application No") { }
            column(GroupText; GroupText) { }
            trigger OnAfterGetRecord()
            begin
                GroupText := '';
                if "Loan Application"."Product Code" = '1212' then
                    GroupText := 'Reschedule/Renegotiated Loans'
                else
                    GroupText := 'Classification';
                Provision := 0;
                ProvisionAmount := 0;
                case "Loan Application"."Loan Classification" of
                    "Loan Application"."Loan Classification"::Performing:
                        Provision := 0.01;
                    "Loan Application"."Loan Classification"::Watch:
                        Provision := 0.05;
                    "Loan Application"."Loan Classification"::Substandard:
                        Provision := 0.25;
                    "Loan Application"."Loan Classification"::Doubtfull:
                        Provision := 0.50;
                    "Loan Application"."Loan Classification"::Loss:
                        Provision := 1;
                end;
                ProvisionAmount := "Loan Application"."Net Change-Principal" * Provision;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Name; AsAt)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    var
        AsAt: Date;
        DateFilter, GroupText : Text;
        Provision, ProvisionAmount : decimal;
        GroupOrder1, GroupOrder2 : Integer;
}

report 90027 Defaulters
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\Defaulters.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Loan Classification", "Application No", "Posting Date";

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Application_No; "Application No") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Loan_Classification; "Loan Classification") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Net_Change_Principal; "Net Change-Principal") { }
            column(Total_Arrears; "Total Arrears") { }
            column(Defaulted_Days; "Defaulted Days") { }
            column(Defaulted_Installments; "Defaulted Installments") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Monthly_Inistallment; "Monthly Inistallment") { }
            column(Installments; Installments) { }
            column(Interest_Rate; "Interest Rate") { }
            column(PhoneNo; PhoneNo) { }
            column(StaffNo; StaffNo) { }
            trigger OnAfterGetRecord()
            begin
                StaffNo := '';
                PhoneNo := '';
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                if Member.Get("Loan Application"."Member No.") then begin
                    StaffNo := Member."Payroll No";
                    PhoneNo := Member."Mobile Phone No.";
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    var
        AsAt: Date;
        DateFilter, GroupText : Text;
        Provision, ProvisionAmount : decimal;
        PhoneNo, StaffNo : Code[20];
        Member: Record Members;
        GroupOrder1, GroupOrder2 : Integer;
        CompanyInformation: Record "Company Information";
}
report 90028 "Member Account List"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Account List.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            column(Member_No_; "Member No.") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Mobile_Phone_No_; "Mobile Phone No.") { }
            column(Alt__Phone_No; "Alt. Phone No") { }
            column(Gender; Gender) { }
            column(Date_of_Birth; "Date of Birth") { }
            column(Payroll_No; "Payroll No") { }
            column(Date_of_Registration; "Date of Registration") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No.");
                DataItemTableView = sorting("No.");
                column(Net_Change; "Net Change") { }
                column(Name; Name) { }
                trigger OnPreDataItem()
                begin
                    SetFilter("Date Filter", DateFilter);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                DateFilter := Members.GetFilter("Date Filter");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
}
report 90029 "Monthly Receipts"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Monthly Receipts.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            column(Member_No_; "Member No.") { }

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Mobile_Phone_No_; "Mobile Phone No.") { }
            column(Alt__Phone_No; "Alt. Phone No") { }
            column(Gender; Gender) { }
            column(Date_of_Birth; "Date of Birth") { }
            column(Payroll_No; "Payroll No") { }
            column(Date_of_Registration; "Date of Registration") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No."), "Account Code" = field("Account Type Filter");
                DataItemTableView = sorting("No.");
                column(Net_Change; "Net Change") { }
                column(Name; Name) { }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No." = field("No.");
                    DataItemTableView = sorting("Entry No.") where(Reversed = const(false));
                    column(Posting_Date; "Posting Date") { }
                    column(Amount; Amount) { }
                }
                trigger OnPreDataItem()
                begin
                    SetFilter("Date Filter", DateFilter);
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                DateFilter := Members.GetFilter("Date Filter");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        DateFilter: Text;
}
report 90030 "Member Application"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Application.rdl';

    dataset
    {
        dataitem("Member Application"; "Member Application")
        {

            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Application_No_; "Application No.") { }
            column(Member_Category; "Member Category") { }
            column(First_Name; "First Name") { }
            column(Middle_Name; "Middle Name") { }
            column(Last_Name; "Last Name") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(KRA_PIN; "KRA PIN") { }
            column(Date_of_Birth; "Date of Birth") { }
            column(Occupation; Occupation) { }
            column(Gender; Gender) { }
            column(Employer_Code; "Employer Code") { }
            column(Station_Code; "Station Code") { }
            column(Payroll_No_; "Payroll No.") { }
            column(Designation; Designation) { }
            column(Address; Address) { }
            column(Alt__Phone_No; "Alt. Phone No") { }
            column(County; County) { }
            column(Sub_County; "Sub County") { }
            column(Town_of_Residence; "Town of Residence") { }
            column(Estate_of_Residence; "Estate of Residence") { }
            column(Member_Image; "Member Image") { }
            column(Front_ID_Image; "Front ID Image") { }
            column(Back_ID_Image; "Back ID Image") { }
            column(Member_Signature; "Member Signature") { }
            column(ATM; ATM) { }
            column(Mobile; Mobile) { }
            column(Portal; Portal) { }
            column(FOSA; FOSA) { }
            column(Marketing_Texts; "Marketing Texts") { }
            dataitem("Nexts of Kin"; "Nexts of Kin")
            {
                DataItemLink = "Source Code" = field("Application No.");
                DataItemTableView = sorting("Source Code");
                column(KIN_ID; "KIN ID") { }
                column(Kin_Type; "Kin Type") { }
                column(Name; Name) { }
                column(Kin_Date_of_Birth; "Date of Birth") { }
                column(Phone_No_; "Phone No.") { }
                column(Allocation; Allocation) { }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                "Member Application".CalcFields("Member Image", "Member Signature", "Front ID Image", "Back ID Image");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        CompanyInformation: Record "Company Information";
}
report 90031 "Transfer Shares - Q"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DataItemName; Members)
        {
            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Full Name");
                MemberManagement.TransferShareCapital("Member No.");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {

            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }



    var
        MemberManagement: Codeunit "Member Management";
        Window: Dialog;

    trigger OnPreReport()
    begin
        Window.open('Validating \#1###')
    end;

    trigger OnPostReport()
    begin
        Window.close;
    end;
}
report 90032 "Checkoff Advise"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = Normal;
    RDLCLayout = '.\Loan Management\Credit Reports\Checkoff Advise.rdl';
    dataset
    {
        dataitem("Checkoff Advice"; "Checkoff Advice")
        {
            RequestFilterFields = "Advice Date", "Advice Type", "Employer Code";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(PayrollNo; PayrollNo) { }
            column(Member_No; "Member No") { }
            column(MemberName; "Member Name") { }
            column(Amount_Off; "Amount Off") { }
            column(Amount_On; "Amount On") { }
            column(Current_Balance; "Current Balance") { }
            column(Advice_Date; "Advice Date") { }
            column(Advice_Type; "Advice Type") { }
            column(AccountNo; AccountNo) { }
            column(ProductName; "Product Name") { }
            column(Loan_No; "Loan No") { }
            column(EmployerCode; "Employer Code") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                if "Amount On" = 0 then
                    CurrReport.Skip();
                PayrollNo := '';
                if Members.get("Member No") then
                    PayrollNo := Members."Payroll No";
                if PayrollNo = '' then
                    PayrollNo := Members."Payroll No.";
                AccountNo := '';
                if "Advice Type" in ["Advice Type"::Adjustment, "Advice Type"::"New Member", "Advice Type"::RMF] then begin
                    Vendor.Reset();
                    Vendor.SetRange("Member No.", "Member No");
                    Vendor.SetRange("Account Code", "Account No");
                    if Vendor.FindFirst() then
                        AccountNo := Vendor."No.";
                end else begin
                    LoanApplication.Reset();
                    LoanApplication.SetRange("Member No.", "Member No");
                    LoanApplication.SetRange("Product Code", "Account No");
                    LoanApplication.SetFilter("Loan Balance", '>0');
                    if LoanApplication.FindFirst() then begin
                        AccountNo := LoanApplication."Application No";
                        "Loan No" := AccountNo;
                    end;
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Members: Record Members;
        PayrollNo, AccountNo, EmployerCode : Code[20];
        MemberName, ProductName : Text[200];
        Vendor: Record Vendor;
        LoanApplication: Record "Loan Application";
}
report 90033 "Loan Recovery"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Recovery.rdl';
    dataset
    {
        dataitem("Loan Recovery Header"; "Loan Recovery Header")
        {
            RequestFilterFields = "Posting Date", "Member No";
            column(Document_No; "Document No") { }
            column(Posting_Date; "Posting Date") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Accrued_Interest; "Accrued Interest") { }
            column(Self_Recovery_Amount; "Self Recovery Amount") { }
            column(Guarantor_Deposit_Recovery; "Guarantor Deposit Recovery") { }
            column(Guarantor_Liability_Recovery; "Guarantor Liability Recovery") { }
            column(Total_Recoverable; "Total Recoverable") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(PayrollNo; PayrollNo) { }
            column(Loan_No; "Loan No") { }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                PayrollNo := '';
                if Members.get("Member No") then
                    PayrollNo := Members."Payroll No";
                if PayrollNo = '' then
                    PayrollNo := Members."Payroll No.";
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        Members: Record Members;
        PayrollNo: Code[20];
}
report 90034 "Member KINS"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Member KINS.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            RequestFilterFields = "Member No.";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Member_No_; "Member No.") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Payroll_No; "Payroll No") { }
            dataitem("Nexts of Kin"; "Nexts of Kin")
            {
                DataItemLink = "Source Code" = field("Member No.");
                DataItemTableView = sorting("Source Code");
                column(Kin_Type; "Kin Type") { }
                column(KIN_ID; "KIN ID") { }
                column(Name; Name) { }
                column(Phone_No_; "Phone No.") { }
                column(Allocation; Allocation) { }
                column(Date_of_Birth; "Date of Birth") { }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                PayrollNo := '';
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PayrollNo: Code[20];
}
report 90035 "Member Guarantees"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Guarantees.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            RequestFilterFields = "Member No.";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Deposits; Deposits) { }
            column(Member_No_; "Member No.") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Payroll_No; "Payroll No") { }
            column(MaxSelfGuarantee; MaxSelfGuarantee) { }
            column(MaxNonSelfGuarantee; MaxNonSelfGuarantee) { }
            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Member No" = field("Member No.");
                DataItemTableView = sorting("Member No");
                column(Loan_No; "Loan No") { }
                column(Member_Deposits; "Member Deposits") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
                column(Substituted; Substituted) { }
                column(Arrears; Arrears) { }
                column(LoanClassification; LoanClassification) { }
                column(OutstandingGrnt; OutstandingGrnt) { }
                column(IssueDate; IssueDate) { }
                column(OwnerNo; OwnerNo) { }
                column(OwnerName; OwnerName) { }
                column(LoanBalance; LoanBalance) { }
                column(ProductCode; ProductCode) { }
                column(ProductName; ProductName) { }
                column(LoanPrinciple; LoanPrinciple) { }
                column(PayrollNo; PayrollNo) { }
                column(ReplaceWith; ReplaceWith) { }
                column(ReplaceDate; ReplaceDate) { }
                trigger OnAfterGetRecord()
                begin
                    OutstandingGrnt := 0;
                    LoanClassification := '';
                    PayrollNo := '';
                    Arrears := 0;
                    OwnerName := '';
                    OwnerNo := '';
                    ProductCode := '';
                    ProductName := '';
                    ReplaceWith := '';
                    LoanPrinciple := 0;
                    LoanBalance := 0;
                    Clear(IssueDate);
                    Clear(ReplaceDate);
                    if LoanApplication.Get("Loan Guarantees"."Loan No") then begin
                        if Members1.Get(LoanApplication."Member No.") then begin
                            PayrollNo := Members1."Payroll No";
                            if PayrollNo = '' then
                                PayrollNo := Members1."Payroll No.";
                        end;
                        LoanApplication.CalcFields("Loan Balance");
                        IssueDate := LoanApplication."Posting Date";
                        ProductCode := LoanApplication."Product Code";
                        ProductName := LoanApplication."Product Description";
                        OwnerName := LoanApplication."Member Name";
                        OwnerNo := LoanApplication."Member No.";
                        LoanBalance := LoanApplication."Loan Balance";
                        LoanPrinciple := LoanApplication."Applied Amount";
                        LoanClassification := Format(LoanApplication."Loan Classification");
                        Arrears := LoanApplication."Total Arrears";
                        OutstandingGrnt := MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", "Loan Guarantees"."Member No");
                        if Substituted then begin
                            if GuarantorHder.Get("Document No.") then
                                ReplaceDate := GuarantorHder."Posting Date";
                            if ReplaceDate = 0D then
                                ReplaceDate := dt2date(GuarantorHder."Created On");
                            GuarantorLines.Reset();
                            GuarantorLines.SetRange("Document No", "Document No.");
                            GuarantorLines.SetRange("Member No", "Member No");
                            if GuarantorLines.FindSet() then begin
                                GuarantorDetLines.Reset();
                                GuarantorDetLines.SetRange("Document No", "Document No.");
                                GuarantorDetLines.SetRange("Line No", GuarantorLines."Line No");
                                if GuarantorDetLines.FindSet() then begin
                                    repeat
                                        ReplaceWith += (GuarantorDetLines."Member No" + ',');
                                    until GuarantorDetLines.Next() = 0;
                                end;
                            end;
                        end;
                        if StrLen(ReplaceWith) > 0 then
                            ReplaceWith := CopyStr(ReplaceWith, 1, StrLen(ReplaceWith) - 1)
                    end else
                        CurrReport.Skip();
                end;

            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                MaxNonSelfGuarantee := 0;
                MaxSelfGuarantee := 0;
                MaxSelfGuarantee := LoansMGt.GetSelfGuaranteeEligibility("Member No.");
                MaxNonSelfGuarantee := LoansMGt.GetNonSelfGuaranteeEligibility("Member No.");
                Deposits := 0;
                Members.CalcFields("Total Deposits");
                Deposits := Members."Total Deposits";
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PayrollNo: Code[20];
        MemberMgt: Codeunit "Member Management";
        LoanApplication: Record "Loan Application";
        OutstandingGrnt, Arrears, LoanPrinciple, LoanBalance, MaxSelfGuarantee, MaxNonSelfGuarantee, Deposits : Decimal;
        LoanClassification, OwnerNo, OwnerName, ProductCode, ProductName, ReplaceWith : Text;
        GuarantorDetLines: Record "Guarantor Mgt. Det. Lines";
        GuarantorLines: Record "Guarantor Lines";
        GuarantorHder: Record "Guarantor Header";
        IssueDate, ReplaceDate : Date;
        Members1: Record Members;
        LoansMGt: Codeunit "Loans Management";
}
report 90036 "Member Guarantors"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Guarantors.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            RequestFilterFields = "Member No.";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Member_No_; "Member No.") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Payroll_No; "Payroll No") { }
            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Loan Owner" = field("Member No.");
                DataItemTableView = sorting("Member No");
                column(Loan_No; "Loan No") { }
                column(Member_No; "Member No") { }
                column(Member_Name; "Member Name") { }
                column(Member_Deposits; "Member Deposits") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
                column(Substituted; Substituted) { }
                column(Arrears; Arrears) { }
                column(LoanClassification; LoanClassification) { }
                column(Outstanding_Guarantees; "Outstanding Guarantees") { }
                column(OwnerNo; OwnerNo) { }
                column(OwnerName; OwnerName) { }
                column(LoanBalance; LoanBalance) { }
                column(ProductCode; ProductCode) { }
                column(ProductName; ProductName) { }
                column(LoanPrinciple; LoanPrinciple) { }
                trigger OnAfterGetRecord()
                begin
                    OutstandingGrnt := 0;
                    LoanClassification := '';
                    Arrears := 0;
                    OwnerName := '';
                    OwnerNo := '';
                    ProductCode := '';
                    ProductName := '';
                    LoanPrinciple := 0;
                    LoanBalance := 0;
                    if LoanApplication.Get("Loan Guarantees"."Loan No") then begin
                        LoanApplication.CalcFields("Loan Balance");
                        ProductCode := LoanApplication."Product Code";
                        ProductName := LoanApplication."Product Description";
                        OwnerName := LoanApplication."Member Name";
                        OwnerNo := LoanApplication."Member No.";
                        LoanBalance := LoanApplication."Loan Balance";
                        LoanPrinciple := LoanApplication."Applied Amount";
                        LoanClassification := Format(LoanApplication."Loan Classification");
                        Arrears := LoanApplication."Total Arrears";
                        OutstandingGrnt := MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", "Loan Guarantees"."Member No");
                    end else
                        CurrReport.Skip();
                end;

            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                PayrollNo := '';
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PayrollNo: Code[20];
        MemberMgt: Codeunit "Member Management";
        LoanApplication: Record "Loan Application";
        OutstandingGrnt, Arrears, LoanPrinciple, LoanBalance : Decimal;
        LoanClassification, OwnerNo, OwnerName, ProductCode, ProductName : Text;
}
report 90037 "Sectorial Lending"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Sectorial Lending.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter";
            column(Sector_Code; "Sector Code") { }
            column(Sub_Sector_Code; "Sub Sector Code") { }
            column(Sub_Susector_Code; "Sub-Susector Code") { }
            column(Net_Change_Principal; "Net Change-Principal") { }
            column(SectorName; SectorName) { }
            column(SubSectorName; SubSectorName) { }
            column(SubSubSectorName; SubSubSectorName) { }

            trigger OnAfterGetRecord()
            begin
                SectorName := '';
                SubSectorName := '';
                SubSubSectorName := '';
                if Sectors.Get("Loan Application"."Sector Code") then
                    SectorName := Sectors."Sector Name";
                if SubSector.Get("Loan Application"."Sector Code", "Loan Application"."Sub Sector Code") then
                    SubSectorName := SubSector."Sub Sector Name";
                if SubSubSector.get("Loan Application"."Sector Code", "Loan Application"."Sub Sector Code", "Loan Application"."Sub-Susector Code") then
                    SubSubSectorName := SubSubSector."Sub-Subsector Description";

            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        SectorName, SubSectorName, SubSubSectorName : text[200];
        Sectors: Record "Economic Sectors";
        SubSubSector: Record "Economic Sub-subsector";
        SubSector: Record "Economic Subsectors";
}
report 90038 "Loan Application"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;
    RDLCLayout = '.\Loan Management\Credit Reports\LoanForm.rdl';
    dataset
    {
        dataitem("Loan Application"; "Online Loan Application")
        {

            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Installments; Installments) { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column(Interest_Rate; "Interest Rate") { }
            column(Applied_Amount; "Applied Amount") { }
            column(Approved_Amount; "Approved Amount") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(SectorName; SectorName) { }
            column(SubSectorName; SubSectorName) { }
            column(SubSubSectorname; SubSubSectorname) { }
            column(AmountInWords; AmountInWords[1]) { }
            column(EmployerName; EmployerName) { }
            column(New_Monthly_Installment; "New Monthly Installment") { }
            column(BankCode; BankCode) { }
            column(BankName; BankName) { }
            column(AccountName; AccountName) { }
            column(AccountNo; AccountNo) { }
            column(GrossSalary; GrossSalary) { }
            column(PhoneNo; PhoneNo) { }
            column(PayrollNo; PayrollNo) { }
            column(Station; Station) { }
            column(Age; Age) { }
            column(EMail; EMail) { }
            column(MemberSignature; Member."Member Signature") { }

            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Member_No; "Member No") { }
                column(GMember_Name; "Member Name") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
                column(GuarantorSignature; Guarantors."Member Signature") { }
                column(GuarantorEmail; Guarantors."E-Mail Address") { }
                column(GuarantorNationalID; Guarantors."National ID No") { }
                column(GuarantorPhoneNo; Guarantors."Mobile Phone No.") { }
                trigger OnAfterGetRecord()
                begin
                    if Guarantors.Get("Loan Guarantees"."Member No") then begin
                        Guarantors.CalcFields("Member Signature");
                    end;
                end;
            }
            dataitem("Loan Recoveries"; "Loan Recoveries")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Recovery_Code; "Recovery Code") { }
                column(Recovery_Description; "Recovery Description") { }
                column(Current_Balance; "Current Balance") { }

            }
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            var
                LCharge: record "Loan Charges";
                AppraisalParameters: Record "Loan Appraisal Parameters";
                LoansManagement: Codeunit "Loans Management";
                LoanRecoveries: Record "Loan Recoveries";
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                SectorName := '';
                SubSectorName := '';
                SubSubSectorname := '';
                if EconomicSectors.get("Loan Application"."Sector Code") then
                    SectorName := EconomicSectors."Sector Name";
                if SubSectors.get("Sector Code", "Sub Sector Code") then
                    SubSectorName := SubSectors."Sub Sector Name";
                if SubSubSectors.get("Sector Code", "Sub Sector Code", "Sub-Susector Code") then
                    SubSubSectorname := SubSubSectors."Sub-Subsector Description";
                if Member.get("Member No.") then begin
                    Member.CalcFields("Member Signature");
                    if Member."Date of Birth" <> 0D then
                        Age := Format(Date2DMY(Today, 3) - Date2DMY(Member."Date of Birth", 3)) + ' YEARS';
                    EMail := Member."E-Mail Address";
                    if Employers.get(Member."Employer Code") then
                        EmployerName := Employers.Name;
                    PhoneNo := Member."Mobile Phone No.";
                    PayrollNo := Member."Payroll No";
                    if PayrollNo = '' then
                        PayrollNo := Member."Payroll No.";
                end;
                /*Clear(AmountInWords)
                Check.InitTextVariable();
                Check.FormatNoText(AmountInWords, Net, '');*/
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        Employers: Record "Employer Codes";
        Guarantors: Record Members;
        GrossSalary: Decimal;
        EmployerName: Text;
        EMail, PayrollNo, BankCode, BankName, AccountNo, AccountName, PhoneNo, Station, Age : Code[100];
        CompanyInformation: Record "Company Information";
        Check: report Check;
        AmountInWords: array[2] of Text[250];
        LoanProduct: Record "Product Factory";
        PayslipInfo: Record "Loan Appraisal Parameters";
        AppraisalAccounts: Record "Appraisal Accounts";
        Net: Decimal;
        Member: Record Members;
        EconomicSectors: Record "Economic Sectors";
        SubSectors: Record "Economic Subsectors";
        SubSubSectors: Record "Economic Sub-subsector";
        TagLine, GuarantorWarning, ThirdRuleWarning, LoanToDepositRatioWarning, RetirementWarning, SectorName, SubSectorName, SubSubSectorname : Text[100];

}
report 90039 "Member Statement2"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\Member Statement.rdl';

    dataset
    {
        dataitem(Member; Members)
        {
            RequestFilterFields = "Member No.", "Date Filter";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column("MemberNo"; Member."Member No.") { }
            column("MemberName"; Member."Full Name") { }
            column("PhoneNo"; Member."Mobile Phone No.") { }
            column("NationalIDNo"; Member."National ID No") { }
            column("KRAPINNo"; Member."KRA PIN") { }
            column(Payroll_No; "Payroll No") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No."), "No." = field("Account Filter");
                DataItemTableView = sorting("No.") where("Account Class" = filter(<> Loan));
                column(No_; "No.") { }
                column(Name; Name) { }
                column(OpenningBalance; OpenningBalance) { }
                dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No." = field("No."), "Posting Date" = field("Date Filter");
                    DataItemTableView = sorting("Entry No.");
                    column(Entry_No_; "Entry No.") { }
                    column(Posting_Date; "Posting Date") { }
                    column(Document_No_; "Document No.") { }
                    column(Description; Description) { }
                    column(Debit_Amount; "Debit Amount") { }
                    column(Credit_Amount; "Credit Amount") { }
                    column(RunningBalance; RunningBalance) { }
                    trigger OnAfterGetRecord()
                    begin
                        "Vendor Ledger Entry".CalcFields(Amount);
                        RunningBalance += (-1 * "Vendor Ledger Entry".Amount);
                    end;
                }
                trigger OnPreDataItem()
                begin
                    if ((LoanFilter <> '') AND (AccountFilter = '')) then
                        Vendor.SetFilter("Member No.", 'philipayekomukhebo');
                    if DateFilter <> '' then begin
                        OpenningBalance := 0;
                        RunningBalance := 0;
                        DateRec.Reset();
                        DateRec.SetFilter("Period Start", DateFilter);
                        if DateRec.FindSet() then begin
                            RangeMin := DateRec.GetRangeMin("Period Start");
                            RangeMin := CalcDate('-1D', RangeMin);
                        end;
                    end;
                end;

                trigger OnAfterGetRecord()
                begin
                    OpenningBalance := 0;
                    RunningBalance := 0;
                    if Member.Get(Vendor."Member No.") then;
                    DetailedEntries.Reset();
                    DetailedEntries.SetRange("Vendor No.", Vendor."No.");
                    if RangeMin <> 0D then
                        DetailedEntries.SetFilter("Posting Date", '..%1', RangeMin);
                    if DetailedEntries.FindSet() then begin
                        DetailedEntries.CalcSums(Amount);
                        OpenningBalance := DetailedEntries.Amount;
                    end;
                    OpenningBalance := RunningBalance;
                end;
            }
            dataitem("Loan Application"; "Loan Application")
            {
                DataItemLink = "Member No." = field("Member No."), "Application No" = field("Loan Filter");
                DataItemTableView = sorting("Application No") where(Disbursed = const(true));
                column(Application_No; "Application No") { }
                column(Member_No_; "Member No.") { }
                column(Application_Date; "Application Date") { }
                column(Approved_Amount; "Approved Amount") { }
                column(Monthly_Inistallment; "Monthly Inistallment") { }
                dataitem(CreditLedger; "Vendor Ledger Entry")
                {
                    DataItemTableView = sorting("Entry No.");
                    DataItemLink = "Reason Code" = field("Application No"), "Vendor No." = field("Loan Account");
                    column(CredEntry_No_; "Entry No.") { }
                    column(CredPosting_Date; "Posting Date") { }
                    column(CredDocument_No_; "Document No.") { }
                    column(CredDescription; Description) { }
                    column(CredDebit_Amount; "Debit Amount") { }
                    column(CredCredit_Amount; "Credit Amount") { }
                    column(CredRunningBalance; RunningBalance) { }
                    trigger OnAfterGetRecord()
                    begin
                        CalcFields(Amount);
                        RunningBalance += Amount;
                    end;

                }
                trigger OnAfterGetRecord()
                begin
                    RunningBalance := 0;
                    OpenningBalance := 0;
                    RunningBalance := OpenningBalance;
                end;

                trigger OnPreDataItem()
                begin
                    if ((LoanFilter = '') AND (AccountFilter <> '')) then
                        "Loan Application".SetFilter("Member No.", 'philipayekomukhebo');
                end;

            }
            trigger OnPreDataItem()
            begin

                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                DateFilter := '';
                LoanFilter := '';
                AccountFilter := '';
                LoanFilter := Member.GetFilter("Loan Filter");
                AccountFilter := Member.GetFilter("Account Filter");
                DateFilter := Member.GetFilter("Date Filter");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        DateFilter: Text[250];
        OpenningBalance: Decimal;
        RunningBalance: Decimal;
        DetailedEntries: Record "Detailed Vendor Ledg. Entry";
        RangeMin: date;
        DateRec: Record Date;
        CompanyInformation: Record "Company Information";
        LoanFilter, AccountFilter : text[100];
}
report 90040 "Online Repayment Schedule"
{
    UsageCategory = Administration;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Online Loan Schedule.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Online Loan Application")

        {
            column(Application_No; "Application No") { }
            column(Member_No_; "Member No.") { }
            column(Member_Name; "Member Name") { }
            column(Application_Date; "Application Date") { }
            column(Applied_Amount; "Applied Amount") { }
            dataitem("Loan Schedule"; "Loan Schedule")
            {
                DataItemLink = "Loan No." = field("Application No");
                column(Entry_No; "Entry No") { }
                column(Document_No_; "Document No.") { }
                column(Principle_Repayment; "Principle Repayment") { }
                column(Interest_Repayment; "Interest Repayment") { }
                column(Monthly_Repayment; "Monthly Repayment") { }
                column(Running_Balance; "Running Balance") { }
                column("CompanyLogo"; CompanyInformation.Picture) { }
                column("CompanyName"; CompanyInformation.Name) { }
                column("CompanyAddress1"; CompanyInformation.Address) { }
                column("CompanyAddress2"; CompanyInformation."Address 2") { }
                column("CompanyPhone"; CompanyInformation."Phone No.") { }
                column("CompanyEmail"; CompanyInformation."E-Mail") { }
                column(Expected_Date; "Expected Date") { }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
}

report 90041 "Membership Form"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\Member_Joining.rdl';
    dataset
    {
        dataitem(DataItemName; "Member Application")
        {
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Application_No_; "Application No.") { }
            column(First_Name; "First Name") { }
            column(Middle_Name; "Middle Name") { }
            column(Last_Name; "Last Name") { }
            column(Nationality; Nationality) { }
            column(National_ID_No; "National ID No") { }
            column(KRA_PIN; "KRA PIN") { }
            column(Employer_Code; "Employer Code") { }
            column(Designation; Designation) { }
            column(Payroll_No_; "Payroll No.") { }
            column(Mobile_Phone_No_; "Mobile Phone No.") { }
            column(E_Mail_Address; "E-Mail Address") { }
            column(Address; Address) { }
            column(Town_of_Residence; "Town of Residence") { }
            column(FOSA; FOSA) { }
            column(Mobile; Mobile) { }
            column(ATM; ATM) { }
            column(Member_Image; "Member Image") { }
            dataitem("Nexts of Kin"; "Nexts of Kin")
            {
                DataItemLink = "Source Code" = field("Application No.");
                column(Name; Name) { }
                column(Kin_Type; "Kin Type") { }
                column(Allocation; Allocation) { }
                column(KIN_ID; "KIN ID") { }
                column(Phone_No_; "Phone No.") { }
            }
            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                CalcFields("Member Image");
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        myInt: Integer;
        CompanyInformation: Record "Company Information";
}
report 90042 "Standing Order Register"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = '.\Loan Management\Credit Reports\Standing_Order_Register.rdl';
    dataset
    {
        dataitem(DataItemName; "Standing Order")
        {
            column(Document_No; "Document No") { }
            column(STO_Type; "STO Type") { }
            column(Member_No; "Member No") { }
            column(Member_Name; "Member Name") { }
            column(Start_Date; "Start Date") { }
            column(Created_On; "Created On") { }
            column(Account_No; "Account No") { }
            column(AccountName; AccountName) { }
            column(PFNumber; PFNumber) { }
            column(EmployerName; EmployerName) { }
            column(Standing_Order_Class; "Standing Order Class") { }
            column(Destination_Account; "Destination Account") { }
            column(Destination_Name; "Destination Name") { }
            column(LastRunDate; LastRunDate) { }
            column(NextRunDate; NextRunDate) { }
            column(Period; Period) { }
            column(Run_From_Day; "Run From Day") { }
            column(Amount; Amount) { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        AccountName, PFNumber, EmployerName, Frequency : Text;
        LastRunDate, NextRunDate : Date;
        Vendor: Record Vendor;
}
report 90043 "FOSA Appraisal"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    RDLCLayout = '.\Loan Management\Credit Reports\FOSA Appraisal.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {

            column(Application_No; "Application No") { }
            column(Application_Date; "Application Date") { }
            column(Member_No_; "Member No.") { }
            column(BridgingLoan; BridgingLoan) { }
            column(ExternalEffect; ExternalEffect) { }
            column(Member_Name; "Member Name") { }
            column(Product_Code; "Product Code") { }
            column(Insurance_Amount; "Insurance Amount") { }
            column(GuarantorWarning; GuarantorWarning) { }
            column(LoanToDepositRatioWarning; LoanToDepositRatioWarning) { }
            column(AmountToDeposit; AmountToDeposit) { }
            column(BridgingCommision; BridgingCommision) { }
            column(ProratedInterest; ProratedInterest) { }
            column(ThirdRuleWarning; ThirdRuleWarning) { }
            column(Product_Description; "Product Description") { }
            column(Applied_Amount; "Applied Amount") { }
            column(PayrollNo; PayrollNo) { }
            column(Approved_Amount; "Approved Amount") { }
            column(MaxCredit; MaxCredit) { }
            column(TagLine; TagLine) { }
            column(Repayment_Start_Date; "Repayment Start Date") { }
            column(Repayment_End_Date; "Repayment End Date") { }
            column(Installments; Installments) { }
            column(Share_Capital; "Share Capital") { }
            column(Deposits; Deposits) { }
            column(Total_Loans; "Total Loans") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(AmountInWords; AmountInWords[1]) { }
            column(BasicPay; BasicPay) { }
            column(HouseAllowance; HouseAllowance) { }
            column(OtherEarnings; OtherEarnings) { }
            column(OtherDeductions; OtherDeductions) { }
            column(OneThird; OneThird) { }
            column(NetIncome; NetIncome) { }
            column(MInstallment; MInstallment) { }
            column(NewNet; NewNet) { }
            column(QualifiedAmount; QualifiedAmount) { }
            column(QualifiedDepositWise; QualifiedDepositWise) { }
            column(QualifiedSalaryWise; QualifiedSalaryWise) { }
            column(AvailableRecovery; AvailableRecovery) { }
            column(ClearedEffect; ClearedEffect) { }

            dataitem("Loan Charges"; "Loan Charges")
            {
                DataItemLink = "Loan No." = field("Application No");
                column(Loan_No_; "Loan No.") { }
                column(Charge_Code; "Charge Code") { }
                column(Charge_Description; "Charge Description") { }
                column(Rate; Rate) { }
                column(Rate_Type; "Rate Type") { }
                column(Amount; Amount) { }

                trigger OnAfterGetRecord()
                begin
                    Amount := 0;
                    Amount := "Loan Charges".Rate;
                    if "Loan Charges"."Rate Type" = "Loan Charges"."Rate Type"::"Percentage of Principle" then
                        Amount := "Loan Application"."Approved Amount" * "Loan Charges".Rate * 0.01;
                    net -= Amount;
                end;
            }
            dataitem("Loan Securities"; "Loan Securities")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Security_Type; "Security Type") { }
                column(Security_Code; "Security Code") { }
                column(Description; Description) { }
                column(Security_Value; "Security Value") { }
                trigger OnAfterGetRecord()
                begin
                    //Message('Get here');
                end;

            }
            dataitem("Loan Guarantees"; "Loan Guarantees")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Member_No; "Member No") { }
                column(GMember_Name; "Member Name") { }
                column(Total_Deposits; "Member Deposits") { }
                column(Guarantor_Value; "Multiplied Deposits") { }
                column(Guaranteed_Amount; "Guaranteed Amount") { }
                column(PFNumber; "Member No") { }
            }
            dataitem("Loan FOSA Salaries"; "Loan FOSA Salaries")
            {
                DataItemLink = "Loan No" = field("Application No");
                column(Posting_Date; "Posting Date") { }
                column(Amount_Earned; "Amount Earned") { }
                column(Recoveries; Recoveries) { }
                column(Net_Salary; "Net Salary") { }
            }
            trigger OnPreDataItem()
            begin
                BasicPay := 0;
                HouseAllowance := 0;
                OtherEarnings := 0;
                OtherDeductions := 0;
                OneThird := 0;
                NetIncome := 0;
                MInstallment := 0;
                NewNet := 0;
                Net := 0;
                ClearedEffect := 0;
                GuarantorWarning := '';
                ThirdRuleWarning := '';
                ExternalEffect := 0;
                BridgingLoan := 0;
                TagLine := '';
            end;

            trigger OnAfterGetRecord()
            var
                LCharge: record "Loan Charges";
                AppraisalParameters: Record "Loan Appraisal Parameters";
                LoansManagement: Codeunit "Loans Management";
                LoanRecoveries: Record "Loan Recoveries";
            begin
                MaxCredit := 0;
                "Loan Application".Validate("Insurance Amount");
                LoansManagement.GetDepositBoostAmount("Loan Application"."Application No");
                PayrollNo := '';
                if Member.get("Loan Application"."Member No.") then
                    PayrollNo := Member."Payroll No.";
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount);
                    BridgingLoan := LoanRecoveries.Amount;
                    BridgingCommision := LoanRecoveries."Commission Amount";
                end;
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::External);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount, "Commission Amount");
                    ExternalEffect := LoanRecoveries.Amount;
                end;
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", "Loan Application"."Application No");
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Account);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums(Amount, "Commission Amount");
                    AmountToDeposit := LoanRecoveries.Amount;
                end;
                "Loan Application".Deposits := LoansManagement.GetMemberDeposits("Loan Application"."Member No.");
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                Net := "Loan Application"."Approved Amount";
                GuarantorWarning := '';
                "Loan Application".CalcFields("Total Securities", "Total Collateral");
                if "Loan Application"."Total Securities" + "Loan Application"."Total Collateral" < "Loan Application"."Applied Amount" then
                    GuarantorWarning := 'The Loan is unsecured';
                "Loan Application".CalcFields("Monthly Inistallment");
                MInstallment := "Loan Application"."Monthly Inistallment";
                AppraisalParameters.Reset();
                AppraisalParameters.SetRange("Loan No", "Loan Application"."Application No");
                if AppraisalParameters.FindSet() then begin
                    repeat
                        if AppraisalParameters.Type = AppraisalParameters.Type::Earnig then
                            NetIncome += AppraisalParameters."Parameter Value"
                        else
                            NetIncome -= AppraisalParameters."Parameter Value";
                        ParameterSetup.Get(AppraisalParameters."Appraisal Code");
                        if ParameterSetup."Cleared Effect" then
                            ClearedEffect += AppraisalParameters."Parameter Value";
                        if AppraisalParameters.Type = AppraisalParameters.Type::Deduction then
                            OtherDeductions += AppraisalParameters."Parameter Value"
                        else begin
                            if AppraisalParameters.Class = AppraisalParameters.Class::"Basic Pay" then
                                BasicPay += AppraisalParameters."Parameter Value"
                            else
                                if AppraisalParameters.Class = AppraisalParameters.Class::Allowance then
                                    HouseAllowance += AppraisalParameters."Parameter Value"
                                else begin
                                    if ParameterSetup."Cleared Effect" = false then
                                        OtherEarnings += AppraisalParameters."Parameter Value";
                                end;
                        end;
                    until AppraisalParameters.Next() = 0;
                end;
                LoanProduct.get("Loan Application"."Product Code");
                SpecialLoan := 0;
                SpecialLoans2 := 0;
                LoansManagement.GetMemberSpecialLoanAmount("Loan Application"."Member No.", SpecialLoans2, SpecialLoan);
                "Total Loans" := LoansManagement.GetMemberLoans("Loan Application"."Member No.") - LoansManagement.GetRefinancedLoans("Application No") - SpecialLoans2;
                QualifiedDepositWise := ((LoansManagement.GetMemberDeposits("Loan Application"."Member No.") - SpecialLoan + LoansManagement.GetBoostedDeposits("Loan Application"."Application No")) * LoanProduct."Loan Multiplier");
                QualifiedSalaryWise := 0;
                OneThird := (1 / 3) * BasicPay;
                NewNet := NetIncome - MInstallment;
                AvailableRecovery := NetIncome - OneThird;
                QualifiedAmount := QualifiedDepositWise;
                AvailableRecovery := LoansManagement.AppraiseFosaSalary("Member No.", "Product Code", "Application No");
                MaxCredit := LoansManagement.GetReversalAmortizationAmount(AvailableRecovery, "Interest Rate", Installments);
                if NewNet < OneThird then
                    ThirdRuleWarning := 'One third rule not met';

                if LoanProduct."Appraise with 0 Deposits" = false then begin
                    if QualifiedAmount < "Loan Application"."Applied Amount" then
                        LoanToDepositRatioWarning := 'Loan-to-Deposit ratio not met';
                end;
                if (("Loan Application"."Applied Amount" <= MaxCredit) OR (NewNet > OneThird)) then
                    TagLine := 'This member qualifies for ' + Format("Loan Application"."Applied Amount") + ' recoverable ' + format(Round("Loan Application"."Monthly Inistallment", 0.10, '=')) + ' for ' + Format("Loan Application".Installments) + ' months'
                else
                    TagLine := 'This member does not qualify for ' + Format("Loan Application"."Applied Amount");
                "Loan Application".CalcFields("Total Recoveries");
                if "Loan Application"."Total Recoveries" > "Loan Application"."Applied Amount" then
                    ThirdRuleWarning := 'You cannot refinance more than the applied amount';
                /* Clear(AmountInWords)
                 Check.InitTextVariable();
                 Check.FormatNoText(AmountInWords, Net, '');*/
                if QualifiedAmount > "Loan Application"."Applied Amount" then
                    QualifiedAmount := "Loan Application"."Applied Amount";
                if "Loan Application"."Appraisal Commited" = false then begin
                    if ((LoanProduct."Appraise with 0 Deposits") AND (NewNet > OneThird)) then begin
                        "Loan Application"."Recommended Amount" := "Loan Application"."Applied Amount";
                        "Loan Application"."Approved Amount" := "Loan Application"."Applied Amount";
                    end else begin
                        "Loan Application"."Recommended Amount" := QualifiedAmount;
                        "Loan Application"."Approved Amount" := QualifiedAmount;
                    end;
                    "Loan Application".Modify();
                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        PayrollNo: Code[20];
        Amount: Decimal;
        MaxCredit, AvailableRecovery, QualifiedSalaryWise, QualifiedDepositWise, QualifiedAmount, BridgingLoan, ProratedInterest, ExternalEffect, AmountToDeposit, BridgingCommision : decimal;
        ClearedEffect, BasicPay, HouseAllowance, OtherEarnings, OtherDeductions, OneThird, NetIncome, MInstallment, NewNet : decimal;
        CompanyInformation: Record "Company Information";
        Check: report Check;
        AmountInWords: array[2] of Text[250];
        LoanProduct: Record "Product Factory";
        AppraisalAccounts: Record "Appraisal Accounts";
        Net: Decimal;
        Member: Record Members;
        ParameterSetup: Record "Appraisal Parameters";
        TagLine, GuarantorWarning, ThirdRuleWarning, LoanToDepositRatioWarning, RetirementWarning : Text[100];
        SpecialLoan, SpecialLoans2 : Decimal;

}
report 90044 "Disbursement Summary"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Disbursement Summary.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date";
            column(Application_No; "Application No") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Filters; Filters) { }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                if "Loan Application"."Applied Amount" = 0 then
                    CurrReport.Skip();
                EmployerCode := '';
                EmployerName := '';
                if Members.Get("Member No.") then begin
                    if Employers.Get(EmployerCode) then begin
                        EmployerCode := Employers.Code;
                        EmployerName := Employers.Name;
                    end;
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
}
report 90045 "Loan Balances Summary"
{

    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Loan Balances Summary.rdl';
    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "Date Filter", "Member No.", "Application No", "Application Date";
            column(Application_No; "Application No") { }
            column(Approved_Amount; "Approved Amount") { }
            column(Loan_Balance; "Loan Balance") { }
            column(Product_Code; "Product Code") { }
            column(Product_Description; "Product Description") { }
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Filters; Filters) { }
            trigger OnPreDataItem()
            begin
                Filters := "Loan Application".GetFilters;
                CompanyInformation.get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                if "Loan Application"."Applied Amount" = 0 then
                    CurrReport.Skip();
                EmployerCode := '';
                EmployerName := '';
                if Members.Get("Member No.") then begin
                    if Employers.Get(EmployerCode) then begin
                        EmployerCode := Employers.Code;
                        EmployerName := Employers.Name;
                    end;
                end;
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        EmployerCode, EmployerName : Code[100];
        Members: Record Members;
        Employers: Record "Employer Codes";
        Filters: Text;
}
report 90046 "Savings And Loan Listing"
{

    UsageCategory = Administration;
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = '.\Loan Management\Credit Reports\Savings And Loan Listing.rdl';
    dataset
    {
        dataitem(Members; Members)
        {
            RequestFilterFields = "Member No.";
            column("CompanyLogo"; CompanyInformation.Picture) { }
            column("CompanyName"; CompanyInformation.Name) { }
            column("CompanyAddress1"; CompanyInformation.Address) { }
            column("CompanyAddress2"; CompanyInformation."Address 2") { }
            column("CompanyPhone"; CompanyInformation."Phone No.") { }
            column("CompanyEmail"; CompanyInformation."E-Mail") { }
            column(Member_No_; "Member No.") { }
            column(Full_Name; "Full Name") { }
            column(National_ID_No; "National ID No") { }
            column(Payroll_No; "Payroll No") { }
            column(Total_Deposits; "Total Deposits") { }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "Member No." = field("Member No.");
                DataItemTableView = where("Account Class" = const(Loan));
                column(No_; "No.") { }
                column(Name; Name) { }
                column(Net_Change; "Net Change") { }
            }

            trigger OnAfterGetRecord()
            begin
                CompanyInformation.get;
                CompanyInformation.CalcFields(Picture);
                Members.CalcFields("Total Deposits");
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PayrollNo: Code[20];
        MemberMgt: Codeunit "Member Management";
        IssueDate: Date;
        SortingOrder: Integer;
}

//report 90015
//Ru9Novt5n+Kqf