/// <summary>
/// Codeunit Member Management (ID 90001).
/// </summary>
codeunit 90001 "Member Management"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// MaskCardNo.
    /// </summary>
    /// <param name="CardNo">Code[20].</param>
    /// <returns>Return variable MaskedCardNo of type Code[50].</returns>
    procedure MaskCardNo(CardNo: Code[20]) MaskedCardNo: Code[50]
    var
        MiddlePart, StartPart, LastPart : Code[20];
    begin
        if StrLen(CardNo) > 4 then begin
            StartPart := CopyStr(CardNo, 1, 4);
            LastPart := CopyStr(CardNo, StrLen(CardNo) - 4, 4);
            MaskedCardNo := StartPart + '-XXXX-XXXX-XXXX-' + LastPart;
        end else
            MaskedCardNo := '';
        exit(MaskedCardNo);
    end;

    internal procedure UpdateMemberAccounts(ProductCode: Code[20])
    var
        Vendor: Record Vendor;
        ProductSetup: Record "Product Factory";
        Window: Dialog;
    begin
        ProductSetup.Get(ProductCode);
        Vendor.Reset();
        Vendor.SetRange("Account Code", ProductCode);
        if Vendor.FindSet() then begin
            Window.Open('Updating \#1##');
            repeat
                Window.Update(1, Vendor."No.");
                Vendor."Cash Deposit Allowed" := ProductSetup."Cash Deposit Allowed";
                Vendor."Cash Withdrawal Allowed" := ProductSetup."Cash Withdrawal Allowed";
                Vendor."Juniour Account" := ProductSetup."Juniour Account";
                Vendor."Share Capital Account" := ProductSetup."Share Capital";
                Vendor."NWD Account" := ProductSetup."NWD Account";
                Vendor."Fixed Deposit Account" := ProductSetup."Fixed Deposit";
                Vendor.Modify();
            until Vendor.Next() = 0;
            Window.Close();
        end;
    end;

    /// <summary>
    /// CreateAtmLien.
    /// </summary>
    /// <param name="DocumentNo">Code[20].</param>
    procedure CreateAtmLien(DocumentNo: Code[20])
    var
        UnclearedEffect: Record "Uncleared Effects";
        EntryNo: Integer;
        ATMApplication: Record "ATM Application";
        JournalMgt: Codeunit "Journal Management";
        Charges: Decimal;
    begin
        ATMApplication.Get(DocumentNo);
        Charges := 0;
        Charges := JournalMgt.GetTransactionCharges(ATMApplication."Transaction Code", 999999);
        EntryNo := 1;
        UnclearedEffect.reset;
        if UnclearedEffect.FindLast() then
            EntryNo := UnclearedEffect."Entry No" + 1;
        UnclearedEffect.Init();
        UnclearedEffect."Entry No" := EntryNo;
        UnclearedEffect."Document No" := DocumentNo;
        UnclearedEffect."Member Name" := ATMApplication."Member Name";
        UnclearedEffect.Amount := Charges;
        UnclearedEffect."Member No" := ATMApplication."Member No";
        UnclearedEffect."Account No" := ATMApplication."Account No.";
        UnclearedEffect."Created By" := UserId;
        UnclearedEffect."Created On" := CurrentDateTime;
        UnclearedEffect.Insert();
    end;

    procedure ReverseAtmLien(DocumentNo: Code[20])
    var
        UnclearedEffect: Record "Uncleared Effects";
        EntryNo: Integer;
        ATMApplication: Record "ATM Application";
        JournalMgt: Codeunit "Journal Management";
        Charges: Decimal;
    begin
        ATMApplication.Get(DocumentNo);
        Charges := 0;
        Charges := JournalMgt.GetTransactionCharges(ATMApplication."Transaction Code", 999999);
        EntryNo := 1;
        UnclearedEffect.reset;
        if UnclearedEffect.FindLast() then
            EntryNo := UnclearedEffect."Entry No" + 1;
        UnclearedEffect.Init();
        UnclearedEffect."Entry No" := EntryNo;
        UnclearedEffect."Document No" := DocumentNo;
        UnclearedEffect."Member Name" := ATMApplication."Member Name";
        UnclearedEffect.Amount := -1 * Charges;
        UnclearedEffect."Member No" := ATMApplication."Member No";
        UnclearedEffect."Account No" := ATMApplication."Account No.";
        UnclearedEffect."Created By" := UserId;
        UnclearedEffect."Created On" := CurrentDateTime;
        UnclearedEffect.Insert();
    end;

    internal procedure PostATMLinking(DocumentNo: Code[20])
    var
        ATMApplication: Record "ATM Application";
        Vendor: Record Vendor;
        ATMCards: Record "ATM Cards";
        JournalMgt: Codeunit "Journal Management";
        PostingAmount, AvailableBalance, Charges : Decimal;
        JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, MemberNo, SourceCode, Dim8, ReasonCode, ExternalDocumentNo : Code[20];
        PostingDate: Date;
        LineNo: Integer;
        JournalManagement: Codeunit "Journal Management";
        LoansMgt: Codeunit "Loans Management";
    begin
        ATMApplication.Get(DocumentNo);
        Vendor.get(ATMApplication."Account No.");
        Vendor.CalcFields(Balance, "Uncleared Effects");
        AvailableBalance := Vendor.Balance - Vendor."Uncleared Effects";
        if AvailableBalance < 0 then
            AvailableBalance := 0;
        /*Charges := JournalMgt.GetTransactionCharges(ATMApplication."Transaction Code", 999);
        if Charges > AvailableBalance then
            Error('The Account does not have sufficient funds');*/
        Vendor.Reset();
        Vendor.SetRange("Card No", ATMApplication."Card No.");
        if Vendor.FindSet() then begin
            repeat
                Vendor."Card No" := '';
                Vendor.Modify();
            until Vendor.Next() = 0;
        end;
        if not ATMCards.Get(ATMApplication."Card No.", ATMApplication."ATM Type") then begin
            ATMCards.Init();
            ATMCards."ATM Type" := ATMApplication."ATM Type";
            ATMCards."Card No." := ATMApplication."Card No.";
            ATMCards.Validate("ATM Type");
            ATMCards."Account No" := ATMApplication."Account No.";
            ATMCards."Assigned By" := UserId;
            ATMCards."Assigned On" := CurrentDateTime;
            ATMCards.Status := ATMCards.Status::Transacting;
            ATMCards."Assigned to Account No" := ATMApplication."Account No.";
            ATMCards."Assigned To Member No." := ATMApplication."Member No";
            ATMCards.Insert();
        end else begin
            ATMCards.Validate("ATM Type");
            ATMCards."Account No" := ATMApplication."Account No.";
            ATMCards."Assigned By" := UserId;
            ATMCards."Assigned On" := CurrentDateTime;
            ATMCards.Status := ATMCards.Status::Transacting;
            ATMCards."Assigned to Account No" := ATMApplication."Account No.";
            ATMCards."Assigned To Member No." := ATMApplication."Member No";
            ATMCards.Modify();
        end;
        Vendor.Reset();
        Vendor.SetRange("No.", ATMApplication."Account No.");
        if Vendor.FindFirst() then begin
            Vendor."Card No" := ATMApplication."Card No.";
            Vendor.Modify();
        end;
        //Post Charges
        PostingAmount := 9999999;
        MemberNo := ATMApplication."Member No";
        PostingDate := Today;
        SourceCode := 'ATMLINK';
        ReasonCode := SourceCode;
        ExternalDocumentNo := DocumentNo;
        JournalBatch := 'ATMLINK';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'ATM Linking');
        LineNo := JournalManagement.AddCharges(
            ATMApplication."Transaction Code", LoansMgt.GetFOSAAccount(MemberNo), PostingAmount, LineNo, DocumentNo, MemberNo,
            SourceCode, ReasonCode, ExternalDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, true);
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        ATMApplication.Processed := true;
        ATMApplication."Processed At" := time;
        ATMApplication."Processed By" := userid;
        ATMApplication."Processed On" := Today;
        ATMApplication.Modify();
        ReverseAtmLien(ATMApplication."Application No");
    end;

    procedure BlockMobileMember(MemberNo: Code[20])
    var
        MobileMembers: Record "Mobile Members";
        MobileLedger: Record "Mobile Member Ledger";
        EntryNo: Integer;
    begin
        MobileMembers.Get(MemberNo);
        MobileMembers."Member Status" := MobileMembers."Member Status"::Blocked;
        MobileMembers.Modify();
        MobileLedger.Reset();
        if MobileLedger.FindLast() then
            EntryNo := MobileLedger."Entry No" + 1
        else
            EntryNo := 1;
        MobileLedger.Init();
        MobileLedger."Entry No" := EntryNo;
        MobileLedger."Document No" := Format(Today);
        MobileLedger."User ID" := UserId;
        MobileLedger."Posting Date" := Today;
        MobileLedger."Posting Time" := time;
        MobileLedger."Member No" := MemberNo;
        MobileLedger."Document Type" := MobileLedger."Document Type"::Blocking;
        MobileLedger.Insert();
    end;

    procedure PostMobileApplication(DocumentNo: Code[20])
    var
        MobileApplication: Record "Mobile Applications";
        MobileMembers: Record "Mobile Members";
        MobileLedger: Record "Mobile Member Ledger";
        EntryNo: Integer;
    begin
        MobileApplication.Get(DocumentNo);
        if MobileMembers.Get(MobileApplication."Member No") then begin
            MobileMembers."Member Status" := MobileMembers."Member Status"::Active;
            MobileMembers.Modify();
            MobileLedger.Reset();
            if MobileLedger.FindLast() then
                EntryNo := MobileLedger."Entry No" + 1
            else
                EntryNo := 1;
            MobileLedger.Init();
            MobileLedger."Entry No" := EntryNo;
            MobileLedger."Document No" := DocumentNo;
            MobileLedger."User ID" := UserId;
            MobileLedger."Posting Date" := Today;
            MobileLedger."Posting Time" := time;
            MobileLedger."Member No" := MobileApplication."Member No";
            MobileLedger."Document Type" := MobileLedger."Document Type"::Reactivation;
            MobileLedger.Insert();
        end else begin
            MobileLedger.Reset();
            if MobileLedger.FindLast() then
                EntryNo := MobileLedger."Entry No" + 1
            else
                EntryNo := 1;
            MobileLedger.Init();
            MobileLedger."Entry No" := EntryNo;
            MobileLedger."Document No" := DocumentNo;
            MobileLedger."User ID" := UserId;
            MobileLedger."Posting Date" := Today;
            MobileLedger."Posting Time" := time;
            MobileLedger."Member No" := MobileApplication."Member No";
            MobileLedger."Document Type" := MobileLedger."Document Type"::Activation;
            MobileLedger.Insert();
            MobileMembers.Init();
            MobileMembers."Member No" := MobileApplication."Member No";
            MobileMembers."Full Name" := MobileApplication."Full Name";
            MobileMembers."FOSA Account" := MobileApplication."FOSA Account";
            MobileMembers."Phone No" := MobileApplication."Phone No";
            MobileMembers."ID No" := MobileApplication."ID No";
            MobileMembers."Activated On" := CurrentDateTime;
            MobileMembers."Activated By" := UserId;
            MobileMembers."Member Status" := MobileMembers."Member Status"::Active;
            MobileMembers.Insert();
        end;
    end;

    procedure PopulateIPRSData(ApplicationNo: Code[20]; IDNo: Code[20])
    var
        MemberApplication: record "Member Application";
        HtClient: HttpClient;
        URLCode: TextConst ENU = 'https://test-api.ekenya.co.ke/Ushuru_APP_API/iprs';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken, JLinesToken, ResultToken : JsonToken;
        JArray: JsonArray;
        JObject, NewJObject : JsonObject;
        JValue: JsonValue;
        i: Integer;
        ResponseText, PayLoad : Text;
        MpesaIntegrations: Codeunit "MPesa Integrations";
    begin
        MemberApplication.Get(ApplicationNo);
        PayLoad := '{'
            + '"phoneNumber":"254704113452"' + ','
            + '"idType":"GetDataByIdCard"' + ','
            + '"idNumber":"' + IDNo + '"' + ','
            + '"deviceId":"2345412341561"'
        + '}';
        JObject.ReadFrom(MpesaIntegrations.CallService('IPRS', URLCode, 2, PayLoad, '', ''));
        Clear(JToken);
        if JObject.Get('data', JLinesToken) then begin
            NewJObject := JLinesToken.AsObject();
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'First_Name');
            MemberApplication."First Name" := ResultToken.AsValue().AsText();

            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'Other_Name');
            MemberApplication."Middle Name" := ResultToken.AsValue().AsCode();

            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'Surname');
            MemberApplication."Last Name" := ResultToken.AsValue().AsCode();
            /*Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'Date_of_Birth');
            MemberApplication."Date of Birth" := DT2Date(ResultToken.AsValue().AsDateTime());*/
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'Gender');
            if ResultToken.AsValue().AsCode() = 'M' then
                MemberApplication.Gender := MemberApplication.Gender::Male
            else
                MemberApplication.Gender := MemberApplication.Gender::Female;
            MemberApplication.Validate("Full Name");
            MemberApplication.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Receipt Management", 'OnAfterPostReceipt', '', true, true)]

    local procedure OnAfterPostReceipt(var Receipt: Record "Receipt Header")
    var
        CheckOffAdvice: Record "Checkoff Advice";
        EntryNo: Integer;
        ReceiptLines: Record "Receipt Lines";
        Vendor: Record Vendor;
        Loan: Record "Loan Application";
    begin
        CheckOffAdvice.Reset();
        if CheckOffAdvice.FindLast() then
            EntryNo := CheckOffAdvice."Entry No" + 1
        else
            EntryNo := 1;
        ReceiptLines.Reset();
        ReceiptLines.SetRange("Receipt No.", Receipt."Receipt No.");
        if ReceiptLines.FindSet() then begin
            repeat
                CheckOffAdvice.Init();
                CheckOffAdvice."Entry No" := EntryNo;
                EntryNo += 1;
                CheckOffAdvice."Member No" := ReceiptLines."Member No.";
                CheckOffAdvice."Amount Off" := ReceiptLines.Amount;
                CheckOffAdvice."Amount On" := 0;
                CheckOffAdvice."Current Balance" := 0;
                if ReceiptLines."Posting Type" = ReceiptLines."Posting Type"::"Loan Receipt" then begin
                    If Loan.get(ReceiptLines."Loan No.") then begin
                        Loan.CalcFields("Loan Balance");
                        CheckOffAdvice."Current Balance" := Loan."Loan Balance";
                        CheckOffAdvice."Product Type" := Loan."Product Code";
                        CheckOffAdvice."Product Type" := Loan."Product Description";
                    end;
                end;
                if ReceiptLines."Posting Type" = ReceiptLines."Posting Type"::"Member Receipt" then begin
                    if Vendor.get(ReceiptLines."Bal. Account No.") then begin
                        if Vendor."NWD Account" then begin
                            Vendor.CalcFields(Balance);
                            CheckOffAdvice."Current Balance" := Vendor.Balance;
                            CheckOffAdvice."Product Type" := Vendor."Account Code";
                            CheckOffAdvice."Product Type" := Vendor.Name;
                        end;
                    end;
                end;
                CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::Adjustment;
                CheckOffAdvice."Advice Date" := Receipt."Posting Date";
                CheckOffAdvice.Insert();
            until ReceiptLines.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Member Management", 'OnAfterCreateMember', '', true, true)]

    local procedure CreateAdvice(Member: Record Members)
    var
        CheckOffAdvice: Record "Checkoff Advice";
        EntryNo: Integer;
        SubScriptions: Record "Member Subscriptions";
    begin
        CheckOffAdvice.Reset();
        if CheckOffAdvice.FindLast() then
            EntryNo := CheckOffAdvice."Entry No" + 1
        else
            EntryNo := 1;
        SubScriptions.Reset();
        SubScriptions.SetRange("Source Code", Member."Member No.");
        SubScriptions.SetFilter(Amount, '>0');
        if SubScriptions.FindSet() then begin
            repeat
                CheckOffAdvice.Init();
                CheckOffAdvice."Entry No" := EntryNo;
                EntryNo += 1;
                CheckOffAdvice."Member No" := Member."Member No.";
                CheckOffAdvice."Amount Off" := 0;
                CheckOffAdvice."Amount On" := SubScriptions.Amount;
                CheckOffAdvice."Current Balance" := 0;
                CheckOffAdvice."Product Type" := SubScriptions."Account Type";
                CheckOffAdvice."Product Name" := SubScriptions."Account Name";
                CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::"New Member";
                CheckOffAdvice."Advice Date" := SubScriptions."Start Date";
                CheckOffAdvice.Insert();
            until SubScriptions.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FOSA Management", 'OnAfterPostTellerTransaction', '', true, true)]

    local procedure OnAfterPostTellerTransaction(TellerTransaction: Record "Teller Transactions")
    var
        CheckOffAdvice: Record "Checkoff Advice";
        EntryNo: Integer;
        Vendor: Record Vendor;
        ProductFactory: Record "Product Factory";
        SubScriptions: Record "Member Subscriptions";
        StartDate, EndDate : Date;
    begin
        EndDate := TellerTransaction."Posting Date";
        StartDate := DMY2Date(Date2DMY(EndDate, 1), Date2DMY(EndDate, 2), Date2DMY(EndDate, 3));
        CheckOffAdvice.Reset();
        if CheckOffAdvice.FindLast() then
            EntryNo := CheckOffAdvice."Entry No" + 1
        else
            EntryNo := 1;
        if Vendor.get(TellerTransaction."Account No") then begin
            if Vendor."NWD Account" then begin
                Vendor.CalcFields(Balance);
                CheckOffAdvice.Reset();
                CheckOffAdvice.SetRange("Member No", Vendor."Member No.");
                CheckOffAdvice.SetRange("Product Type", Vendor."Account Code");
                CheckOffAdvice.SetRange("Advice Date", StartDate, EndDate);
                if CheckOffAdvice.findset then
                    CheckOffAdvice.Deleteall;
                CheckOffAdvice.Init();
                CheckOffAdvice."Entry No" := EntryNo;
                EntryNo += 1;
                CheckOffAdvice."Member No" := Vendor."Member No.";
                CheckOffAdvice."Amount Off" := 0;
                CheckOffAdvice."Amount On" := SubScriptions.Amount;
                CheckOffAdvice."Current Balance" := 0;
                CheckOffAdvice."Product Type" := Vendor."Account Code";
                CheckOffAdvice."Product Name" := Vendor.Name;
                CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::Adjustment;
                CheckOffAdvice."Advice Date" := EndDate;
                CheckOffAdvice."Current Balance" := Vendor.Balance;
                CheckOffAdvice.Insert();
            end;
        end;
    end;

    procedure SendBulkSMS(DocumentNo: code[20])
    var
        BulkSMSLines: Record "Bulk SMS Lines";
        BulkSMSHeader: Record "Bulk SMS Header";
        Window: dialog;
        SMS: Codeunit "Notifications Management";
    begin
        BulkSMSHeader.Get(DocumentNo);
        BulkSMSLines.SetRange(Sent, false);
        BulkSMSLines.SetRange("Document No", DocumentNo);
        if BulkSMSLines.FindSet() then begin
            Window.Open('Sending \#1##');
            repeat
                Window.Update(1, BulkSMSLines."Full Name");
                SMS.SendSms(BulkSMSLines."Phone No", BulkSMSHeader."SMS Message");
                BulkSMSLines.Sent := true;
                BulkSMSLines.Modify();
                Commit();
            until BulkSMSLines.Next() = 0;
            Window.Close();
        end;
        BulkSMSHeader.Sent := true;
        BulkSMSHeader.Modify();
    end;

    procedure PopulateBulkSMSMemberList(DocumentNo: code[20])
    var
        BulkSMSLines: Record "Bulk SMS Lines";
        BulkSMSHeader: Record "Bulk SMS Header";
        Window: dialog;
        SMS: Codeunit "Notifications Management";
        Members: Record Members;
    begin
        BulkSMSHeader.Get(DocumentNo);
        BulkSMSLines.Reset();
        BulkSMSLines.SetRange("Document No", DocumentNo);
        if BulkSMSLines.FindSet() then
            BulkSMSLines.DeleteAll();
        Members.Reset();
        Members.SetRange("Member Status", Members."Member Status"::Active);
        if Members.FindSet() then begin
            Window.Open('Sending \#1##');
            repeat
                Window.Update(1, Members."Full Name");
                BulkSMSLines.init;
                BulkSMSLines."Full Name" := Members."Full Name";
                BulkSMSLines."Phone No" := Members."Mobile Phone No.";
                BulkSMSLines.Insert();
            until Members.Next() = 0;
            Window.Close();
        end;
        BulkSMSHeader.Sent := true;
        BulkSMSHeader.Modify();
    end;

    procedure TransferShareCapital(MemberNo: code[20])
    var
        SharesBalance, MinimumBalance, CurrentBalance, DepositBalance, Diffrence, PostingAmount : Decimal;
        Member: Record Members;
        Vendor, Vendor2 : Record Vendor;
        ProductType: Record "Product Factory";
        LoansMgt: Codeunit "Loans Management";
        JournalManagement: Codeunit "Journal Management";
        LineNo: Integer;
        PostingDescription: Text[50];
        JournalTemplate, JournalBatch, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, AccountNo, DocumentNo, ReasonCode, SourceCode, ExternalDocumentNo : code[20];
        PostingDate: Date;
    begin
        JournalBatch := 'TRNSF';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Minimum Share Capital');
        if Member.get(MemberNo) then begin
            DocumentNo := Format(Today);
            PostingDate := Today;
            DepositBalance := LoansMgt.GetMemberDeposits(MemberNo);
            SharesBalance := LoansMgt.GetMemberShares(MemberNo);
            MinimumBalance := 5000;
            Diffrence := MinimumBalance - SharesBalance;
            if Diffrence < 0 then
                Diffrence := 0;
            if ((Vendor.get(GetMemberAccount(MemberNo, 'DEPOSIT'))) AND (Vendor.get(GetMemberAccount(MemberNo, 'SHARES')))) then begin
                if DepositBalance > Diffrence then begin
                    LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Share Transfers');
                    //Debit Provision Account                                
                    PostingAmount := 0;
                    PostingAmount := Diffrence;
                    PostingDescription := 'Share Transfer';
                    AccountNo := '';
                    AccountNo := GetMemberAccount(MemberNo, 'DEPOSIT');
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                    AccountNo := GetMemberAccount(MemberNo, 'SHARE');
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                    JournalManagement.CompletePosting(JournalBatch, JournalTemplate);
                end;
            end;
        end;
    end;

    procedure OpenAccounts(DocumentNo: Code[20]) AccNo: Code[20]
    var
        AccountOpenning: Record "Account Openning";
        Vendor: Record Vendor;
        AccountNo, prefix, MemberNo : code[20];
        ProductSetup: Record "Product Factory";
        Member: Record Members;
        NoSeries: Codeunit NoSeriesManagement;
    begin
        AccountOpenning.Get(DocumentNo);
        MemberNo := AccountOpenning."Member No";
        if ProductSetup.get(AccountOpenning."Product Type") then begin
            ProductSetup.TestField(Prefix);
            AccountNo := '';
            if ProductSetup."No. Series" <> '' then
                AccountNo := NoSeries.GetNextNo(ProductSetup."No. Series", Today, true)
            else
                AccountNo := ProductSetup.Prefix + MemberNo + ProductSetup.Suffix;
            if ProductSetup."Product Type" <> ProductSetup."Product Type"::"Investment Account" then begin
                if not Vendor.get(AccountNo) then begin
                    Vendor.Init();
                    Vendor."No." := AccountNo;
                    Vendor.Name := UpperCase(ProductSetup.Name);
                    Vendor."Vendor Posting Group" := ProductSetup."Posting Group";
                    Vendor."Search Name" := UpperCase(AccountOpenning."Member Name");
                    Vendor."Account Type" := Vendor."Account Type"::Sacco;
                    Vendor."Member No." := MemberNo;
                    Vendor."Account Code" := ProductSetup.Code;
                    Vendor."Account Class" := ProductSetup."Account Class";
                    Vendor."Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                    Vendor."Global Dimension 2 Code" := Member."Global Dimension 2 Code";
                    Vendor."Juniour Account" := AccountOpenning."Juniour Account";
                    Vendor.Insert();
                end;
            end else begin

            end;
        end;
        exit(AccountNo);
    end;

    procedure ViewProtectedAccounts(UserCode: code[100]) CanView: Boolean
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.get(UserCode);
        exit(UserSetup."View Protected Account");
    end;

    procedure PopulateSubscriptions(MemberApplication: Record "Member Application")
    var
        Products: Record "Product Factory";
        Subscriptions: Record "Member Subscriptions";
    begin
        Subscriptions.Reset();
        Subscriptions.SetRange("Source Code", MemberApplication."Application No.");
        if Subscriptions.FindSet() then
            Subscriptions.DeleteAll();
        Products.Reset();
        Products.SetFilter("Account Class", '%1|%2', Products."Account Class"::Collections, Products."Account Class"::NWD);
        if Products.FindSet() then begin
            repeat
                Subscriptions.Init();
                Subscriptions."Source Code" := MemberApplication."Application No.";
                Subscriptions."Account Type" := Products.Code;
                Subscriptions."Account Name" := Products.Name;
                Subscriptions."Start Date" := MemberApplication."Subscription Start Date";
                Subscriptions."Minmum Contribution" := Products."Minimum Contribution";
                Subscriptions.Insert();
            until Products.Next() = 0;
        end;
    end;

    procedure ActivateMember(DocumentNo: code[20])
    var
        Members: Record Members;
        Vendor: Record Vendor;
        MemberActivation: Record "Member Activations";
        LineNo: Integer;
        JournalManagement: Codeunit "Journal Management";
        PostingDate: Date;
        PostingDescription: Text[50];
        PostingAmount: Decimal;
        LoansMgt: Codeunit "Loans Management";
        JournalTemplate, JournalBatch, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, ExternalDocumentNo, ReasonCode, SourceCode, MemberNo, AccountNo : code[20];
    begin
        MemberActivation.Get(DocumentNo);
        Members.Get(MemberActivation."Member No.");
        Members."Member Status" := Members."Member Status"::Active;
        Members.Modify();
        Vendor.Reset();
        Vendor.SetRange("Member No.", Members."Member No.");
        if Vendor.FindSet() then begin
            repeat
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.Modify();
            until Vendor.Next() = 0;
        end;

        JournalBatch := 'MACT';
        JournalTemplate := 'SACCO';
        AccountNo := '';
        MemberNo := MemberActivation."Member No.";
        PostingDate := MemberActivation."Posting Date";
        ExternalDocumentNo := MemberActivation."Payment Refrence";
        SourceCode := 'MXT';
        ReasonCode := 'MXT';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Member Activations');
        AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
        if MemberActivation."Pay From Account Type" = MemberActivation."Pay From Account Type"::"Cash Book" then begin
            PostingDescription := 'Activation Fee Paid';
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            AccountNo := '';
            AccountNo := MemberActivation."Pay From Account";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"Bank Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        end;
        PostingAmount := 9999999;
        LineNo := JournalManagement.AddCharges(
            MemberActivation."Reactivation Fee", LoansMgt.GetFOSAAccount(MemberNo), PostingAmount, LineNo, DocumentNo, MemberNo,
            SourceCode, ReasonCode, ExternalDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, False);
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        MemberActivation.Posted := true;
        MemberActivation."Posted By" := UserId;
        MemberActivation."Posted On" := CurrentDateTime;
        MemberActivation.Modify();
    end;

    procedure GetMemberAccount(MemberNo: Code[20]; AccountType: Code[20]) MemberAccount: Code[20]
    var
        ProductFactory: Record "Product Factory";
        Vendor: Record Vendor;
    begin
        case AccountType of
            'FOSA':
                begin
                    Vendor.Reset();
                    Vendor.SetRange("No.", '501' + MemberNo);
                    Vendor.SetRange(Blocked, 0);
                    if Vendor.FindFirst() then
                        exit(Vendor."No.")
                    else
                        MemberAccount := 'PHILIPAYEKO';

                end;
            'DEPOSIT', 'DEP', 'DEPOSITS':
                begin
                    ProductFactory.Reset();
                    ProductFactory.SetRange("NWD Account", true);
                    if ProductFactory.FindFirst() then begin
                        Vendor.Reset();
                        Vendor.SetRange("Member No.", MemberNo);
                        Vendor.SetRange("Account Code", ProductFactory.code);
                        if Vendor.FindFirst() then
                            MemberAccount := Vendor."No."
                        else
                            MemberAccount := 'PHILIPAYEKO';
                    end;
                end;
            'SHARE', 'SHARES', 'SHARECAPITAL', 'SHARE CAPITAL':
                begin
                    ProductFactory.Reset();
                    ProductFactory.SetRange("Share Capital", true);
                    if ProductFactory.FindFirst() then begin
                        Vendor.Reset();
                        Vendor.SetRange("Member No.", MemberNo);
                        Vendor.SetRange("Account Code", ProductFactory.code);
                        if Vendor.FindFirst() then
                            MemberAccount := Vendor."No."
                        else
                            MemberAccount := 'PHILIPAYEKO';
                    end;
                end;
        end;
        exit(MemberAccount);
    end;

    procedure GetOutstandingGuarantee(LoanNo: Code[20]; MemberNo: Code[20]) OutstandingGuarantee: Decimal
    var
        LoanApplication: Record "Loan Application";
        LoanGuarantee: Record "Loan Guarantees";
        ApprovedAmount, LoanBalance, TotalGuarantee, Ratio : Decimal;
    begin
        if LoanApplication.Get(LoanNo) then begin
            LoanApplication.CalcFields("Loan Balance");
            if LoanApplication."Loan Balance" <= 0 then
                OutstandingGuarantee := 0
            else begin
                LoanApplication.CalcFields("Loan Balance", "Total Securities");
                LoanBalance := LoanApplication."Loan Balance";
                ApprovedAmount := LoanApplication."Approved Amount";
                TotalGuarantee := LoanApplication."Total Securities";
                LoanGuarantee.Reset();
                LoanGuarantee.SetRange("Loan No", LoanNo);
                LoanGuarantee.SetRange("Member No", MemberNo);
                if LoanGuarantee.FindFirst() then begin
                    if LoanGuarantee.Substituted then
                        Ratio := 0
                    else
                        Ratio := LoanGuarantee."Guaranteed Amount" / ApprovedAmount;
                end;
                OutstandingGuarantee := LoanBalance * Ratio;
                if OutstandingGuarantee > TotalGuarantee then
                    OutstandingGuarantee := TotalGuarantee;
            end;
        end else
            OutstandingGuarantee := 0;
        exit(OutstandingGuarantee);
    end;

    procedure PopulateMemberAssetsLiabilities(DocumentNo: Code[20])
    var
        Member: Record Members;
        MemberExitHeader: Record "Member Exit Header";
        MemberExitLines: Record "Member Exit Lines";
        DateFilter: Text[100];
        Window: Dialog;
        LoanApplication: Record "Loan Application";
        Vendor: Record Vendor;
        EntryNo: Integer;
        LoanGuarantors: record "Loan Guarantees";
        LoansMgt: Codeunit "Loans Management";
        ok: Boolean;
    begin
        Window.Open('Copying \Assets #1## \Libilities #2##');
        MemberExitHeader.Get(DocumentNo);
        Member.get(MemberExitHeader."Member No");
        DateFilter := '..' + Format(MemberExitHeader."Posting Date");
        EntryNo := 1;
        MemberExitLines.Reset();
        MemberExitLines.SetRange("Document No", DocumentNo);
        if MemberExitLines.FindSet() then
            MemberExitLines.DeleteAll();
        Vendor.Reset();
        Vendor.SetRange("Member No.", Member."Member No.");
        Vendor.SetRange("Account Type", Vendor."Account Type"::Sacco);
        if Vendor.FindSet() then begin
            repeat
                Window.Update(1, Vendor.Name);
                Vendor.CalcFields(Balance);
                if Vendor.Balance <> 0 then begin
                    Window.Update(1, Vendor.Name);
                    MemberExitLines.Init();
                    MemberExitLines."Document No" := DocumentNo;
                    MemberExitLines."Entry Type" := MemberExitLines."Entry Type"::Asset;
                    MemberExitLines."Entry No" := EntryNo;
                    EntryNo += 1;
                    MemberExitLines."Account No" := Vendor."No.";
                    MemberExitLines."Account Name" := Vendor.Name;
                    MemberExitLines.Balance := Vendor.Balance;
                    MemberExitLines."Amount (Base)" := Vendor.Balance;
                    Ok := MemberExitLines.Insert();
                end;
            until Vendor.Next() = 0;
        end;
        LoanApplication.Reset();
        LoanApplication.SetFilter("Loan Balance", '<>0');
        LoanApplication.SetRange("Member No.", MemberExitHeader."Member No");
        LoanApplication.SetFilter("Date Filter", DateFilter);
        if LoanApplication.FindSet() then begin
            repeat
                Window.Update(2, LoanApplication."Member Name");
                LoanApplication.CalcFields("Loan Balance");
                MemberExitLines.Init();
                MemberExitLines."Document No" := DocumentNo;
                MemberExitLines."Entry Type" := MemberExitLines."Entry Type"::Liability;
                MemberExitLines."Entry No" := EntryNo;
                EntryNo += 1;
                MemberExitLines."Account No" := LoanApplication."Application No";
                MemberExitLines."Account Name" := LoanApplication."Product Code" + ' ' + LoanApplication."Product Description";
                MemberExitLines.Balance := LoanApplication."Loan Balance";
                MemberExitLines."Amount (Base)" := -1 * LoanApplication."Loan Balance";
                MemberExitLines."Accrued Interest" := LoansMgt.GetAccruedInterest(LoanApplication."Application No", MemberExitHeader."Posting Date");
                Ok := MemberExitLines.Insert();
            until LoanApplication.Next() = 0;
        end;
        LoanGuarantors.reset;
        LoanGuarantors.SetRange("Member No", MemberExitHeader."Member No");
        if LoanGuarantors.FindSet() then begin
            repeat
                Window.Update(2, LoanApplication."Member Name");
                MemberExitLines.Init();
                MemberExitLines."Document No" := DocumentNo;
                MemberExitLines."Entry Type" := MemberExitLines."Entry Type"::Guarantee;
                MemberExitLines."Entry No" := EntryNo;
                EntryNo += 1;
                MemberExitLines."Account No" := LoanGuarantors."Loan No";
                LoanApplication.Reset();
                LoanApplication.SetFilter("Date Filter", DateFilter);
                LoanApplication.SetRange("Application No", LoanGuarantors."Loan No");
                if LoanApplication.FindSet() then begin
                    LoanApplication.CalcFields("Loan Balance");
                    MemberExitLines."Account Name" := LoanApplication."Member Name";
                    MemberExitLines.Balance := GetOutstandingGuarantee(LoanApplication."Application No", LoanGuarantors."Member No");
                    MemberExitLines."Amount (Base)" := -1 * GetOutstandingGuarantee(LoanApplication."Application No", LoanGuarantors."Member No");
                    if LoanApplication."Loan Balance" <> 0 then
                        Ok := MemberExitLines.Insert();
                end;
            until LoanGuarantors.Next() = 0;
        end;
        MemberExitHeader.CalcFields("Accrued Interest", Liabilities, "Total Assets");
        MemberExitHeader."Net Amount" := MemberExitHeader."Total Assets" + MemberExitHeader.Liabilities - MemberExitHeader."Accrued Interest";
        MemberExitHeader.Modify();
        Window.Close();
    end;

    procedure PostMemberExit(DocumentNo: Code[20])
    var
        SaccoSetup: Record "Sacco Setup";
        MemberExitLines: Record "Member Exit Lines";
        AccountNo, ExtDocNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, MemberNo, ReasonCode, SourceCode : Code[20];
        LineNo: Integer;
        JournalManagement: Codeunit "Journal Management";
        PostingDate: Date;
        PostingDescription: Text[50];
        PostingAmount: Decimal;
        MemberExit: Record "Member Exit Header";
        Vendor: Record Vendor;
        LoanApplication: Record "Loan Application";
        GLEntry: Record "G/L Entry";
        Member: Record Members;
        LoansMgt: Codeunit "Loans Management";
        Mobile: Codeunit ThirdPartyIntegrations;
        LoanProduct: Record "Product Factory";
    begin
        JournalBatch := 'MEXIT';
        JournalTemplate := 'GENERAL';
        GLEntry.Reset();
        GLEntry.SetRange("External Document No.", JournalBatch);
        GLEntry.SetRange("Document No.", DocumentNo);
        GLEntry.SetRange("Journal Batch Name", JournalBatch);
        if not GLEntry.IsEmpty then begin
        end else begin
            AccountNo := '';
            MemberExit.Get(DocumentNo);
            MemberNo := MemberExit."Member No";
            MemberExit.CalcFields("Total Assets", Liabilities);
            PostingDate := MemberExit."Posting Date";
            ExtDocNo := JournalBatch;
            SourceCode := 'MXT';
            ReasonCode := 'MXT';
            SaccoSetup.Get();
            AccountNo := SaccoSetup."Member Exits Control";
            PostingAmount := MemberExit."Total Assets" - MemberExit."Accrued Interest" + MemberExit.Liabilities - JournalManagement.GetTransactionCharges(MemberExit."Charge Code", (MemberExit."Total Assets" + MemberExit.Liabilities));
            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Member Exits');
            PostingDescription := 'Member Withdrawal -> ' + MemberNo;
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            MemberExitLines.Reset();
            MemberExitLines.SetRange("Document No", DocumentNo);
            if MemberExitLines.FindSet() then begin
                repeat
                    case MemberExitLines."Entry Type" of
                        MemberExitLines."Entry Type"::Asset:
                            begin
                                PostingDescription := 'Member Withdrawal -> ' + MemberNo;
                                PostingAmount := 0;
                                PostingAmount := MemberExitLines.Balance;
                                AccountNo := '';
                                AccountNo := MemberExitLines."Account No";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        MemberExitLines."Entry Type"::Liability:
                            begin
                                if LoanApplication.get(MemberExitLines."Account No") then begin
                                    PostingAmount := 0;
                                    PostingAmount := MemberExitLines.Balance;
                                    AccountNo := '';
                                    AccountNo := LoanApplication."Loan Account";
                                    LoanApplication.CalcFields("Interest Balance", "Principle Balance");
                                    ReasonCode := LoanApplication."Application No";
                                    SourceCode := LoanApplication."Product Code";
                                    PostingAmount := LoanApplication."Interest Balance";
                                    if PostingAmount < 0 then
                                        PostingAmount := 0;
                                    PostingDescription := 'Interest Paid';
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    LoanProduct.Get(LoanApplication."Product Code");
                                    if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                        AccountNo := '';
                                        AccountNo := LoanProduct."Interest Paid Account";
                                        LineNo := JournalManagement.CreateJournalLine(
                                            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        AccountNo := '';
                                        AccountNo := LoanProduct."Interest Due Account";
                                        LineNo := JournalManagement.CreateJournalLine(
                                            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    end;
                                    AccountNo := LoanProduct."Interest Paid Account";
                                    PostingDescription := 'Interest Paid';
                                    PostingAmount := MemberExitLines."Accrued Interest";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    PostingDescription := 'Principal Paid';
                                    PostingAmount := 0;
                                    PostingAmount := LoanApplication."Principle Balance";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end;
                            end;
                    end;
                until MemberExitLines.Next() = 0;
            end;

            LineNo := JournalManagement.AddCharges(
                MemberExit."Charge Code", LoansMgt.GetFOSAAccount(MemberNo), MemberExit."Total Assets" + MemberExit.Liabilities, LineNo, DocumentNo, MemberNo,
                SourceCode, ReasonCode, ExtDocNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, False);
            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);

            MemberExit.Posted := true;
            MemberExit.Modify();
            Member.Get(MemberNo);
            Member."Member Status" := Member."Member Status"::Withdrawn;
            Member.Modify();
        end;
    end;

    procedure Check18(ParseDate: Date)
    var
        myInt: Integer;
    begin
        if CalcDate('-18Y', Today) > ParseDate then
            Error('You Must be at least 18 years');
    end;

    [IntegrationEvent(false, false)]
    procedure onBeforeCreateMember(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterCreateMember(var MemberApplication: Record "Member Application"; Member: Record Members)
    begin
    end;

    procedure CreateMember(var MemberApplication: Record "Member Application") MNo: Code[20]
    var
        Member: Record Members;
        DefaultAccounts: Record "Category Default Accounts";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Subscriptions: Record "Member Subscriptions";
        Subscriptions2: Record "Member Subscriptions";
        Kins: Record "Nexts of Kin";
        Kins2: Record "Nexts of Kin";
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        MemberNo: code[20];
        ProductSetup: Record "Product Factory";
        AccountNo: code[20];
    begin
        onBeforeCreateMember(MemberApplication);
        MemberNo := '';
        MemberNo := MemberApplication."Member No.";
        SaccoSetup.get;
        SaccoSetup.TestField("Member Nos.");
        if MemberNo = '' then
            MemberNo := NoSeries.GetNextNo(SaccoSetup."Member Nos.", Today, true);
        Member.init;
        Member."Member No." := MemberNo;
        Member."First Name" := MemberApplication."First Name";
        Member."Middle Name" := MemberApplication."Middle Name";
        Member."Last Name" := MemberApplication."Last Name";
        Member."Full Name" := MemberApplication."Full Name";
        Member."Mobile Phone No." := MemberApplication."Mobile Phone No.";
        Member."Alt. Phone No" := MemberApplication."Alt. Phone No";
        Member.Gender := MemberApplication.Gender;
        Member."National ID No" := MemberApplication."National ID No";
        Member."Date of Birth" := MemberApplication."Date of Birth";
        Member."Created By" := UserId;
        Member."Created On" := CurrentDateTime;
        Member."Payroll No." := MemberApplication."Payroll No.";
        Member."Employer Code" := MemberApplication."Employer Code";
        member.Address := MemberApplication.Address;
        member.City := MemberApplication.City;
        Member.County := MemberApplication.County;
        Member."Sub County" := MemberApplication."Sub County";
        Member."Member Category" := MemberApplication."Member Category";
        Member."E-Mail Address" := MemberApplication."E-Mail Address";
        Member."Back ID Image" := MemberApplication."Back ID Image";
        Member."Front ID Image" := MemberApplication."Front ID Image";
        Member."Member Image" := MemberApplication."Member Image";
        Member."Marital Status" := MemberApplication."Marital Status";
        Member."KRA PIN" := MemberApplication."KRA PIN";
        Member."Type of Residence" := MemberApplication."Type of Residence";
        Member.Occupation := MemberApplication.Occupation;
        Member."Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
        Member."Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
        Member."Spouse ID No" := MemberApplication."Spouse ID No";
        Member."Spouse Name" := MemberApplication."Spouse Name";
        Member."Spouse Phone No" := MemberApplication."Spouse Phone No";
        Member."Estate of Residence" := MemberApplication."Estate of Residence";
        Member."Employer Code" := MemberApplication."Employer Code";
        Member."Station Code" := MemberApplication."Station Code";
        Member.Designation := MemberApplication.Designation;
        Member."Payroll No" := MemberApplication."Payroll No.";
        Member."Payroll No." := MemberApplication."Payroll No.";
        Member."Town of Residence" := MemberApplication."Town of Residence";
        Member."Estate of Residence" := MemberApplication."Estate of Residence";
        Member."Group Name" := MemberApplication."Group Name";
        Member."Group No" := MemberApplication."Group No";
        Member."Date of Registration" := MemberApplication."Date of Registration";
        Member."Certificate Expiry" := MemberApplication."Certificate Expiry";
        Member."Certificate of Incoop" := MemberApplication."Certificate of Incoop";
        Member."Is Group" := MemberApplication."Is Group";
        Member."Member Signature" := MemberApplication."Member Signature";
        Member."Protected Account" := MemberApplication."Protected Account";
        Member."Account Owner" := MemberApplication."Account Owner";
        Member."Marketing Texts" := MemberApplication."Marketing Texts";
        Member.FOSA := MemberApplication.FOSA;
        Member.ATM := MemberApplication.ATM;
        Member.Portal := MemberApplication.Portal;
        Member.Insert(true);
        DefaultAccounts.Reset();
        DefaultAccounts.SetRange("Category Code", MemberApplication."Member Category");
        if DefaultAccounts.FindSet then begin
            repeat
                if ProductSetup.get(DefaultAccounts."Product Code") then begin
                    ProductSetup.TestField(Prefix);
                    AccountNo := '';
                    AccountNo := ProductSetup.Prefix + MemberNo + ProductSetup.Suffix;
                    if ProductSetup."Product Type" <> ProductSetup."Product Type"::"Investment Account" then begin
                        if not Vendor.get(AccountNo) then begin
                            Vendor.Init();
                            Vendor."No." := AccountNo;
                            Vendor.Name := UpperCase(ProductSetup.Name);
                            Vendor."Vendor Posting Group" := ProductSetup."Posting Group";
                            Vendor."Search Name" := UpperCase(MemberApplication."Full Name");
                            Vendor."Account Type" := Vendor."Account Type"::Sacco;
                            Vendor."Member No." := MemberNo;
                            Vendor."Account Code" := ProductSetup.Code;
                            Vendor."Account Class" := ProductSetup."Account Class";
                            Vendor."Global Dimension 1 Code" := MemberApplication."Global Dimension 1 Code";
                            Vendor."Global Dimension 2 Code" := MemberApplication."Global Dimension 2 Code";
                            Vendor."Cash Deposit Allowed" := ProductSetup."Cash Deposit Allowed";
                            Vendor."Cash Withdrawal Allowed" := ProductSetup."Cash Withdrawal Allowed";
                            Vendor."Juniour Account" := ProductSetup."Juniour Account";
                            Vendor."Share Capital Account" := ProductSetup."Share Capital";
                            Vendor."NWD Account" := ProductSetup."NWD Account";
                            Vendor."Fixed Deposit Account" := ProductSetup."Fixed Deposit";
                            Vendor.Insert();
                        end;
                    end else begin

                    end;
                end;
            until DefaultAccounts.Next = 0;
        end;
        Kins.Reset();
        Kins.SetRange("Source Code", MemberApplication."Application No.");
        if Kins.FindSet() then begin
            repeat
                if not Kins2.get(MemberNo, Kins."Kin Type", Kins."KIN ID") then begin
                    Kins2.Init();
                    Kins2.TransferFields(Kins, false);
                    Kins2."Source Code" := MemberNo;
                    Kins2."KIN ID" := Kins."KIN ID";
                    Kins2."Kin Type" := Kins."Kin Type";
                    Kins2.Insert();
                end;
            until Kins.Next() = 0;
        end;
        Subscriptions.Reset();
        Subscriptions.SetRange("Source Code", MemberApplication."Application No.");
        if Subscriptions.FindSet() then begin
            repeat
                if not Subscriptions2.get(MemberNo, Subscriptions."Account Type") then begin
                    Subscriptions2.Init();
                    Subscriptions2.TransferFields(Subscriptions, false);
                    Subscriptions2."Source Code" := MemberNo;
                    Subscriptions2."Account Type" := Subscriptions."Account Type";
                    Subscriptions2."Start Date" := Subscriptions."Start Date";
                    Subscriptions2.Insert();
                end;
            until Subscriptions.Next() = 0;
        end;
        MemberApplication.Processed := true;
        MemberApplication."Member No." := MemberNo;
        MemberApplication.Modify();
        OnAfterCreateMember(MemberApplication, Member);
        exit(MemberNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', True, True)]
    procedure OnBeforeInsertDtldVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        if GenJournalLine."Member No." <> '' then begin
            if GenJournalLine."Member Posting Type" = GenJournalLine."Member Posting Type"::General then
                Error('Select the correct posting Type');
        end;
        DtldVendLedgEntry."Member No." := GenJournalLine."Member No.";
        DtldVendLedgEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        DtldVendLedgEntry."Transaction Type" := GenJournalLine."Transaction Type";
        DtldVendLedgEntry."Loan No." := GenJournalLine."Loan No.";
        DtldVendLedgEntry."Transaction Time" := Time;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', true, true)]
    procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        DtldCustLedgEntry."Member No." := GenJournalLine."Member No.";
        DtldCustLedgEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        DtldCustLedgEntry."Transaction Type" := GenJournalLine."Transaction Type";
        DtldCustLedgEntry."Loan No." := GenJournalLine."Loan No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    procedure OnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."Member No." := GenJournalLine."Member No.";
        GLEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        GLEntry."Transaction Type" := GenJournalLine."Transaction Type";
        GLEntry."Loan No." := GenJournalLine."Loan No.";
        GLEntry."Transaction Time" := Time;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        VendorLedgerEntry."Member No." := GenJournalLine."Member No.";
        VendorLedgerEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        VendorLedgerEntry."Transaction Type" := GenJournalLine."Transaction Type";
        VendorLedgerEntry."Loan No." := GenJournalLine."Loan No.";
        VendorLedgerEntry."Transaction Time" := Time;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, true)]
    procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."Member No." := GenJournalLine."Member No.";
        CustLedgerEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        CustLedgerEntry."Transaction Type" := GenJournalLine."Transaction Type";
        CustLedgerEntry."Loan No." := GenJournalLine."Loan No.";
        CustLedgerEntry."Transaction Time" := Time;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry."Member No." := GenJournalLine."Member No.";
        BankAccountLedgerEntry."Member Posting Type" := GenJournalLine."Member Posting Type";
        BankAccountLedgerEntry."Transaction Type" := GenJournalLine."Transaction Type";
        BankAccountLedgerEntry."Loan No." := GenJournalLine."Loan No.";
        BankAccountLedgerEntry."Transaction Time" := Time;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterCheckGenJnlLine', '', true, true)]
    procedure OnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            if Vendor.get(GenJournalLine."Account No.") then begin
                if Vendor."Account Class" = Vendor."Account Class"::Loan then begin
                    GenJournalLine.TestField("Loan No.");
                    GenJournalLine.TestField("Member No.");
                    GenJournalLine.TestField("Member Posting Type");
                    if (GenJournalLine."Transaction Type" IN [GenJournalLine."Transaction Type"::"Penalty Due", GenJournalLine."Transaction Type"::"Penalty Paid", GenJournalLine."Transaction Type"::"Loan Disbursal", GenJournalLine."Transaction Type"::"Interest Due", GenJournalLine."Transaction Type"::"Interest Paid",
                         GenJournalLine."Transaction Type"::"Principle Paid"]) = false then
                        Error('The Transaction type %1 is not allowed for loan account!', GenJournalLine."Transaction Type");
                end;
                if Vendor."Account Type" = Vendor."Account Type"::Sacco then begin
                    GenJournalLine.TestField("Member No.");
                end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnBeforeSendMemberApplicationForApproval(MemberApplication: Record "Member Application")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Member Management", 'OnBeforeSendMemberApplicationForApproval', '', true, true)]
    local procedure CheckMemberMandatoryFields(MemberApplication: Record "Member Application")
    var
        FormartedID: Integer;
        MemberKins: Record "Nexts of Kin";
        Members: Record Members;
    begin
        MemberApplication.TestField("Date of Birth");
        MemberApplication.TestField("KRA PIN");
        MemberApplication.TestField("National ID No");
        MemberApplication.TestField("Mobile Phone No.");
        MemberApplication.TestField("Member Category");
        MemberApplication.TestField(Occupation);
        MemberApplication.TestField(County);
        MemberApplication.TestField("Employer Code");
        MemberApplication.TestField("Payroll No.");
        Members.Reset();
        Members.SetRange("National ID No", MemberApplication."National ID No");
        if Members.FindFirst() then
            Error('The National ID No is already linked to ' + Members."Full Name");

        Members.Reset();
        Members.SetRange("Payroll No", MemberApplication."Payroll No.");
        Members.SetRange("Employer Code", MemberApplication."Employer Code");
        if Members.FindFirst() then
            Error('The Payroll No is already linked to ' + Members."Full Name");
        MemberKins.Reset();
        MemberKins.SetRange("Source Code", MemberApplication."Application No.");
        if MemberKins.FindSet() then begin
            MemberKins.CalcSums(Allocation);
            if MemberKins.Allocation <> 100 then
                Error('The Next of Kin Allocation mus be 100%');
        end else
            Error('Please provide next of Kin information');
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Member Management", 'OnBeforeSendMemberApplicationForApproval', '', true, true)]
    local procedure CheckMemberDuplication(MemberApplication: Record "Member Application")
    var
        Members: Record Members;
    begin
        if MemberApplication."National ID No" <> '' then begin
            Members.Reset();
            Members.SetRange("National ID No", MemberApplication."National ID No");
            if Members.FindFirst() then
                Error('The National ID %1 is already Linked to member %2', MemberApplication."National ID No", Members."Full Name");
        end;
        if MemberApplication."Mobile Phone No." <> '' then begin
            Members.Reset();
            Members.SetRange("Mobile Phone No.", MemberApplication."Mobile Phone No.");
            if Members.FindFirst() then
                Error('The Mobile Phone %1 is already Linked to member %2', MemberApplication."Mobile Phone No.", Members."Full Name");
        end;
        if MemberApplication."KRA PIN" <> '' then begin
            Members.Reset();
            Members.SetRange("KRA PIN", MemberApplication."KRA PIN");
            if Members.FindFirst() then
                Error('The KRA PIN  %1 is already Linked to member %2', MemberApplication."KRA PIN", Members."Full Name");
        end;
    end;

    procedure ProcessmemberEditing(MemberEditing: Record "Member Editing")
    var
        MemberVersions: Record "Member Versions";
        Member: Record Members;
        MemberKins, MemberKins1 : record "Nexts of Kin";
    begin
        MemberEditing.CalcFields("Member Image", "Front ID Image", "Back ID Image");
        if Member.Get(MemberEditing."Member No.") then begin
            if not MemberVersions.Get(MemberEditing."Document No.") then begin
                MemberVersions.Init();
                MemberVersions."Document No." := MemberEditing."Document No.";
                MemberVersions."First Name" := Member."First Name";
                MemberVersions."Middle Name" := Member."Middle Name";
                MemberVersions."Last Name" := Member."Last Name";
                MemberVersions."Mobile Phone No." := Member."Mobile Phone No.";
                MemberVersions."Alt. Phone No" := Member."Alt. Phone No";
                MemberVersions.Gender := Member.Gender;
                MemberVersions."National ID No" := Member."National ID No";
                MemberVersions."Date of Birth" := Member."Date of Birth";
                MemberVersions."Payroll No." := Member."Payroll No.";
                MemberVersions.Address := Member.Address;
                MemberVersions.City := Member.City;
                MemberVersions.County := Member.County;
                MemberVersions."Sub County" := Member."Sub County";
                MemberVersions."Marital Status" := Member."Marital Status";
                MemberVersions.Occupation := Member.Occupation;
                MemberVersions."Type of Residence" := Member."Type of Residence";
                MemberVersions."Member Image" := Member."Member Image";
                MemberVersions."Front ID Image" := Member."Front ID Image";
                MemberVersions."Back ID Image" := Member."Back ID Image";
                MemberVersions."Marital Status" := Member."Marital Status";
                MemberVersions."Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                MemberVersions."Global Dimension 2 Code" := Member."Global Dimension 2 Code";
                MemberVersions."Spouse ID No" := Member."Spouse ID No";
                MemberVersions."Spouse Name" := Member."Spouse Name";
                MemberVersions."Spouse Phone No" := Member."Spouse Phone No";
                MemberVersions."Member No." := MemberEditing."Member No.";
                MemberVersions."Type of Residence" := MemberEditing."Type of Residence";
                MemberVersions."Estate of Residence" := MemberEditing."Estate of Residence";
                MemberVersions."Employer Code" := MemberEditing."Employer Code";
                MemberVersions."Payroll No" := MemberEditing."Payroll No.";
                MemberVersions."Payroll No." := MemberEditing."Payroll No.";
                MemberVersions.Designation := MemberEditing.Designation;
                MemberVersions."Station Code" := MemberEditing."Station Code";
                MemberVersions."Mobile Transacting No" := MemberEditing."Mobile Transacting No";
                MemberVersions.Insert();
            end else begin
                MemberVersions."Member No." := MemberEditing."Member No.";
                MemberVersions."First Name" := Member."First Name";
                MemberVersions."Middle Name" := Member."Middle Name";
                MemberVersions."Last Name" := Member."Last Name";
                MemberVersions."Mobile Phone No." := Member."Mobile Phone No.";
                MemberVersions."Alt. Phone No" := Member."Alt. Phone No";
                MemberVersions.Gender := Member.Gender;
                MemberVersions."National ID No" := Member."National ID No";
                MemberVersions."Date of Birth" := Member."Date of Birth";
                MemberVersions."Payroll No." := Member."Payroll No.";
                MemberVersions.Address := Member.Address;
                MemberVersions.City := Member.City;
                MemberVersions.County := Member.County;
                MemberVersions."Sub County" := Member."Sub County";
                MemberVersions."Marital Status" := Member."Marital Status";
                MemberVersions.Occupation := Member.Occupation;
                MemberVersions."Type of Residence" := Member."Type of Residence";
                MemberVersions."Member Image" := Member."Member Image";
                MemberVersions."Front ID Image" := Member."Front ID Image";
                MemberVersions."Back ID Image" := Member."Back ID Image";
                MemberVersions."Marital Status" := Member."Marital Status";
                MemberVersions."Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                MemberVersions."Global Dimension 2 Code" := Member."Global Dimension 2 Code";
                MemberVersions."Spouse ID No" := Member."Spouse ID No";
                MemberVersions."Spouse Name" := Member."Spouse Name";
                MemberVersions."Spouse Phone No" := Member."Spouse Phone No";
                MemberVersions."Type of Residence" := MemberEditing."Type of Residence";
                MemberVersions."Estate of Residence" := MemberEditing."Estate of Residence";
                MemberVersions."Employer Code" := MemberEditing."Employer Code";
                MemberVersions."Payroll No" := MemberEditing."Payroll No.";
                MemberVersions."Payroll No." := MemberEditing."Payroll No.";
                MemberVersions.Designation := MemberEditing.Designation;
                MemberVersions."Station Code" := MemberEditing."Station Code";
                MemberVersions."Mobile Transacting No" := MemberEditing."Mobile Transacting No";
                MemberVersions.Modify();
            end;
            Member."First Name" := MemberEditing."First Name";
            Member."Middle Name" := MemberEditing."Middle Name";
            Member."Last Name" := MemberEditing."Last Name";
            Member.Validate("Full Name");
            Member."Mobile Phone No." := MemberEditing."Mobile Phone No.";
            Member."Alt. Phone No" := MemberEditing."Alt. Phone No";
            Member.Gender := MemberEditing.Gender;
            Member."National ID No" := MemberEditing."National ID No";
            Member."Date of Birth" := MemberEditing."Date of Birth";
            Member."Payroll No." := MemberEditing."Payroll No.";
            Member.Address := MemberEditing.Address;
            Member.City := MemberEditing.City;
            Member.County := MemberEditing.County;
            Member."Sub County" := MemberEditing."Sub County";
            Member."Marital Status" := MemberEditing."Marital Status";
            Member.Occupation := MemberEditing.Occupation;
            Member."Type of Residence" := MemberEditing."Type of Residence";
            Member."Member Image" := MemberEditing."Member Image";
            Member."Front ID Image" := MemberEditing."Front ID Image";
            Member."Back ID Image" := MemberEditing."Back ID Image";
            Member."Marital Status" := MemberEditing."Marital Status";
            Member."Global Dimension 1 Code" := MemberEditing."Global Dimension 1 Code";
            Member."Global Dimension 2 Code" := MemberEditing."Global Dimension 2 Code";
            Member."Spouse ID No" := MemberEditing."Spouse ID No";
            Member."Spouse Name" := MemberEditing."Spouse Name";
            Member."Spouse Phone No" := MemberEditing."Spouse Phone No";
            Member."Type of Residence" := MemberEditing."Type of Residence";
            Member."Estate of Residence" := MemberEditing."Estate of Residence";
            Member."Employer Code" := MemberEditing."Employer Code";
            Member."Payroll No" := MemberEditing."Payroll No.";
            Member."Payroll No." := MemberEditing."Payroll No.";
            Member.Designation := MemberEditing.Designation;
            Member."Station Code" := MemberEditing."Station Code";
            Member."Group Name" := MemberEditing."Group Name";
            Member."Group No" := MemberEditing."Group No";
            Member."E-Mail Address" := MemberEditing."E-Mail Address";
            Member."Member Signature" := MemberEditing."Member Signature";
            Member."Protected Account" := MemberEditing."Protected Account";
            Member."Account Owner" := MemberEditing."Account Owner";
            Member."Mobile Transacting No" := MemberEditing."Mobile Transacting No";
            Member.Modify();
        end;
        if MemberEditing."Update KINS" then begin
            MemberKins.Reset();
            MemberKins.SetRange("Source Code", MemberEditing."Member No.");
            if MemberKins.FindSet() then
                MemberKins.DeleteAll();
            MemberKins.Reset();
            MemberKins.SetRange("Source Code", MemberEditing."Document No.");
            if MemberKins.FindSet() then begin
                repeat
                    MemberKins1.Init();
                    MemberKins1.TransferFields(MemberKins, false);
                    MemberKins1."Source Code" := MemberEditing."Member No.";
                    MemberKins1."Kin Type" := MemberKins."Kin Type";
                    MemberKins1."KIN ID" := MemberKins."KIN ID";
                    MemberKins1.Insert();
                until MemberKins.Next() = 0;
            end;
        end;
        MemberEditing.Processed := true;
        MemberEditing.Modify();
    end;

    var
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
}
codeunit 90002 "Loans Management"
{
    trigger OnRun()
    begin

    end;

    procedure GetCollateralValueOnLoan(DocumentNo: Code[20]; LoanNo: Code[20]) OutstandingValue: Decimal
    var
        LoanColateral: Record "Loan Securities";
        LoanApplication: Record "Loan Application";
        Ratio1, Ratio2 : Decimal;
    begin
        LoanColateral.Reset();
        LoanColateral.SetRange("Loan No", LoanNo);
        LoanColateral.SetRange("Security Type", LoanColateral."Security Type"::Collateral);
        LoanColateral.SetRange("Security Code", DocumentNo);
        if LoanColateral.FindFirst() then begin
            if LoanApplication.Get(LoanColateral."Loan No") then begin
                LoanApplication.CalcFields("Loan Balance", "Total Collateral", "Total Securities");
                if LoanApplication."Loan Balance" <= 0 then
                    exit(0)
                else begin
                    if LoanApplication."Total Securities" > 0 then
                        Ratio1 := LoanApplication."Total Collateral" / LoanApplication."Total Securities"
                    else
                        Ratio1 := 1;
                    if LoanApplication."Total Collateral" = 0 then
                        exit(0)
                    else begin
                        Ratio2 := LoanColateral.Guarantee / LoanApplication."Total Collateral";
                        OutstandingValue := Ratio1 * Ratio2 * LoanApplication."Loan Balance";
                        exit(OutstandingValue);
                    end;
                end;
            end else
                exit(0);
        end else
            exit(0);
    end;

    procedure GetCollateralValue(DocumentNo: Code[20]) CurrentValue: Decimal
    var
        ColateralRegister: Record "Collateral Register";
        LoanColateral: Record "Loan Securities";
        LoanAmount, LoanBalance, Ratio : Decimal;
    begin
        if ColateralRegister.get(DocumentNo) then begin
            LoanColateral.Reset();
            LoanColateral.SetRange("Security Code", DocumentNo);
            if LoanColateral.FindSet() then begin
                repeat
                    CurrentValue += GetCollateralValueOnLoan(DocumentNo, LoanColateral."Loan No");
                until LoanColateral.Next() = 0;
            end else
                exit(ColateralRegister."Caollateral Value");
        end else
            exit(0);
    end;

    procedure ClassifyLoan(LoanNo: Code[20]; AsAtDate: Date)
    var
        DateFilter: Text;
        LoanApplication: Record "Loan Application";
        DefaultedDays: Integer;
        DefaultedInstallments, ExpectedPrinciple, ExpectedInterest, PrinciplePaid, InterestPaid, PrincipleArrears, InterestArrears, TotalArrears, MonthlyInstallment : Decimal;
    begin
        DateFilter := '..' + Format(AsAtDate);
        if LoanApplication.Get(LoanNo) then begin
            LoanApplication.CalcFields("Monthly Inistallment");
            MonthlyInstallment := LoanApplication."Monthly Inistallment";
        end;
        LoanApplication.Reset();
        LoanApplication.SetFilter("Date Filter", DateFilter);
        LoanApplication.SetRange("Application No", LoanNo);
        if LoanApplication.FindSet() then begin
            LoanApplication.CalcFields("Principle Balance", "Principle Repayment", "Interest Paid", "Total Interest Due", "Loan Balance");
            if LoanApplication."Loan Balance" > 0 then begin
                ExpectedPrinciple := LoanApplication."Principle Repayment";
                PrinciplePaid := LoanApplication."Approved Amount" - LoanApplication."Principle Balance";
                if PrinciplePaid < 0 then
                    PrinciplePaid := 0;
                InterestPaid := LoanApplication."Interest Paid";
                ExpectedInterest := LoanApplication."Total Interest Due";
                InterestArrears := ExpectedInterest + InterestPaid;
                if InterestArrears < 0 then
                    InterestArrears := 0;
                PrincipleArrears := ExpectedPrinciple - PrinciplePaid;
                if PrincipleArrears < 0 then
                    PrincipleArrears := 0;
                TotalArrears := PrincipleArrears + InterestArrears;
                if MonthlyInstallment > 0 then
                    DefaultedInstallments := TotalArrears / MonthlyInstallment
                else
                    DefaultedInstallments := 0;
                DefaultedDays := Round((DefaultedInstallments * 30), 1, '>');
                if DefaultedDays < 0 then
                    DefaultedDays := 0;
                IF DefaultedDays = 0 THEN BEGIN
                    LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Performing;
                END ELSE
                    IF ((DefaultedDays > 0) AND (DefaultedDays <= 30)) THEN BEGIN
                        LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Watch;
                    END ELSE
                        IF ((DefaultedDays > 30) AND (DefaultedDays <= 180)) THEN BEGIN
                            LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Substandard;
                        END ELSE
                            IF ((DefaultedDays > 180) AND (DefaultedDays <= 360)) THEN BEGIN
                                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Doubtfull;
                            END ELSE BEGIN
                                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Loss;
                            END;
                LoanApplication."Defaulted Days" := DefaultedDays;
                LoanApplication.Closed := false;
                LoanApplication."Total Arrears" := TotalArrears;
                LoanApplication."Principle Arrears" := PrincipleArrears;
                LoanApplication."Interest Arrears" := InterestArrears;
                LoanApplication."Defaulted Installments" := Round(DefaultedInstallments, 1, '>');
            end else begin
                LoanApplication."Defaulted Days" := 0;
                LoanApplication."Defaulted Installments" := 0;
                LoanApplication."Total Arrears" := 0;
                LoanApplication."Principle Arrears" := 0;
                LoanApplication."Interest Arrears" := 0;
                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Performing;
            end;
            LoanApplication.Modify();
        end;
    end;

    procedure PopulateGuarantorRatios(DocumentNo: Code[20])
    var
        RecoveryHeader: Record "Loan Recovery Header";
        Ratio, TotalGuarantee : Decimal;
        RecoveryLines: Record "Loan Recovery Lines";
        LoanGuarantee: Record "Loan Guarantees";
        SaccoSetup: Record "Sacco Setup";
    begin
        SaccoSetup.Get();
        RecoveryHeader.Get(DocumentNo);
        RecoveryHeader.CalcFields("Self Recovery Amount");
        LoanGuarantee.Reset();
        LoanGuarantee.SetRange("Loan No", RecoveryHeader."Loan No");
        LoanGuarantee.SetRange(Substituted, false);
        if LoanGuarantee.FindSet() then begin
            LoanGuarantee.CalcSums("Guaranteed Amount");
            TotalGuarantee := LoanGuarantee."Guaranteed Amount";
        end;
        RecoveryLines.Reset();
        RecoveryLines.SetRange("Document No", DocumentNo);
        if RecoveryLines.FindSet() then begin
            repeat
                LoanGuarantee.Reset();
                LoanGuarantee.SetRange("Loan No", RecoveryHeader."Loan No");
                LoanGuarantee.SetRange("Member No", RecoveryLines."Member No");
                if LoanGuarantee.FindSet() then
                    Ratio := LoanGuarantee."Guaranteed Amount" / TotalGuarantee;
                RecoveryLines."Recovery Type" := RecoveryLines."Recovery Type"::"Guarantor Liability Loan";
                RecoveryLines."Product Code" := SaccoSetup."Defaulter Loan Product";
                RecoveryLines."Recovery Amount" := Ratio * (RecoveryHeader."Total Recoverable" - RecoveryHeader."Self Recovery Amount");
                RecoveryLines.Modify();
            until RecoveryLines.Next() = 0;
        end;
    end;

    procedure GetReversalAmortizationAmount(AvailableAmount: Decimal; InterestRate: Decimal; Period: Integer) Principle: Decimal;
    var
        AvailableForLoan, RatePerMonth : Decimal;
        LoanPeriod: Integer;
        CalcVar1, CalcVar2, CalcVar3, CalcVar4 : decimal;
    begin
        RatePerMonth := InterestRate / 12;
        LoanPeriod := Period;
        CalcVar3 := LoanPeriod;
        CalcVar4 := 1 + (RatePerMonth / 100);
        AvailableForLoan := AvailableAmount;
        CalcVar1 := 0;
        CalcVar1 := (Power(CalcVar4, CalcVar3)) - 1;
        CalcVar2 := 0;
        CalcVar2 := RatePerMonth * Power(CalcVar4, LoanPeriod);
        Principle := 0;
        Principle := AvailableForLoan * (CalcVar1 / CalcVar2) * 100;
        exit(Principle)
    end;

    procedure GetRefinancedLoans(LoanNo: Code[20]) Recoveries: Decimal
    var
        LoanRecovery: Record "Loan Recoveries";
    begin
        Recoveries := 0;
        LoanRecovery.Reset();
        LoanRecovery.SetRange("Loan No", LoanNo);
        LoanRecovery.SetRange("Recovery Type", LoanRecovery."Recovery Type"::Loan);
        if LoanRecovery.FindSet() then begin
            LoanRecovery.CalcSums(Amount);
            Recoveries := LoanRecovery.Amount;
        end;
        exit(Recoveries);
    end;

    procedure GetDepositBoostAmount(LoanNo: Code[20])
    var
        Deposits, Multipplier, NWDBoost, MemberLoans, BuyOffs, HalfShares, AppliedAmount : decimal;
        LoanProduct: Record "Product Factory";
        LoanApplication: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
        MemberMgt: Codeunit "Member Management";
    begin
        if LoanApplication.Get(LoanNo) then begin
            AppliedAmount := LoanApplication."Applied Amount";
            LoanProduct.Get(LoanApplication."Product Code");
            if LoanProduct."Boost Deposits" then begin
                Multipplier := LoanProduct."Loan Multiplier";
                MemberLoans := GetMemberLoans(LoanApplication."Member No.");
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Loan No", LoanNo);
                LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
                if LoanRecoveries.FindSet() then begin
                    LoanRecoveries.CalcSums("Current Balance");
                    BuyOffs := LoanRecoveries."Current Balance";
                end;
                Deposits := GetMemberDeposits(LoanApplication."Member No.");
                HalfShares := Deposits * 0.5;
                NWDBoost := (AppliedAmount - ((Deposits * Multipplier) - MemberLoans + BuyOffs)) / Multipplier;
                if NWDBoost < 0 then
                    NWDBoost := 0;
                If NWDBoost > HalfShares then
                    NWDBoost := HalfShares;
                if NWDBoost > LoanProduct."Max. NWD Boost" then
                    NWDBoost := LoanProduct."Max. NWD Boost";
                LoanRecoveries.Reset();
                LoanRecoveries.SetRange("Recovery Code", MemberMgt.GetMemberAccount(LoanApplication."Member No.", 'DEPOSIT'));
                LoanRecoveries.SetRange("Loan No", LoanNo);
                if LoanRecoveries.FindSet() then
                    LoanRecoveries.DeleteAll();
                if NWDBoost > 0 then begin
                    LoanRecoveries.Init();
                    LoanRecoveries."Loan No" := LoanNo;
                    LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Account;
                    LoanRecoveries.Validate("Recovery Code", MemberMgt.GetMemberAccount(LoanApplication."Member No.", 'DEPOSIT'));
                    LoanRecoveries."Current Balance" := Deposits;
                    LoanRecoveries.Validate(Amount, NWDBoost);
                    LoanRecoveries.Insert();
                end;
            end;
        end;
    end;

    internal procedure createLoan(LoanNo: Code[20]) NewLoan: Code[20]
    var
        OnlineLoanApplication: Record "Online Loan Application";
        LoanApplication: Record "Loan Application";
        OnlineGuarantorRequests: Record "Online Guarantor Requests";
        LoanGuarantees: Record "Loan Guarantees";
        SaccoSetup: Record "Sacco Setup";
        NewLoanNo: Code[20];
        NoSeries: Codeunit NoSeriesManagement;
        PayslipInfo, PayslipInfo2 : Record "Loan Appraisal Parameters";
        LoanRecovery, LoanRecovery2 : Record "Loan Recoveries";
    begin
        SaccoSetup.Get();
        SaccoSetup.TestField("Loan Application Nos.");
        NewLoanNo := NoSeries.GetNextNo(SaccoSetup."Loan Application Nos.", Today, true);
        OnlineLoanApplication.get(LoanNo);
        LoanApplication.Init();
        LoanApplication.TransferFields(OnlineLoanApplication, false);
        LoanApplication."Application No" := NewLoanNo;

        OnlineGuarantorRequests.Reset();
        OnlineGuarantorRequests.SetRange("Loan No", LoanNo);
        OnlineGuarantorRequests.SetRange(Status, OnlineGuarantorRequests.Status::Accepted);
        OnlineGuarantorRequests.SetRange("Request Type", OnlineGuarantorRequests."Request Type"::Witness);
        if OnlineGuarantorRequests.FindSet() then begin
            LoanApplication.Witness := OnlineGuarantorRequests."Member No";
        end;
        LoanApplication.Insert();
        OnlineGuarantorRequests.Reset();
        OnlineGuarantorRequests.SetRange("Loan No", LoanNo);
        OnlineGuarantorRequests.SetRange(Status, OnlineGuarantorRequests.Status::Accepted);
        OnlineGuarantorRequests.SetRange("Request Type", OnlineGuarantorRequests."Request Type"::Guarantor);
        if OnlineGuarantorRequests.FindSet() then begin
            repeat
                LoanGuarantees.Reset();
                LoanGuarantees.SetRange("Loan No", LoanNo);
                LoanGuarantees.SetRange("Member No", OnlineGuarantorRequests."Member No");
                if LoanGuarantees.FindSet() then
                    LoanGuarantees.DeleteAll();
                if LoanApplication.Get(NewLoanNo) then begin
                    LoanGuarantees.Init();
                    LoanGuarantees."Loan No" := NewLoanNo;
                    LoanGuarantees.Validate("Member No", OnlineGuarantorRequests."Member No");
                    LoanGuarantees."Guaranteed Amount" := OnlineGuarantorRequests."Amount Accepted";
                    LoanGuarantees."Loan Owner" := LoanApplication."Member No.";
                    LoanGuarantees.Insert(true);
                end;
            until OnlineGuarantorRequests.Next() = 0;
        end;
        PayslipInfo.Reset();
        PayslipInfo.SetRange("Loan No", LoanNo);
        if PayslipInfo.FindSet() then begin
            repeat
                PayslipInfo2.Init();
                PayslipInfo2.TransferFields(PayslipInfo, false);
                PayslipInfo2."Loan No" := NewLoanNo;
                PayslipInfo2."Appraisal Code" := PayslipInfo."Appraisal Code";
                PayslipInfo2.Insert();
            until PayslipInfo.Next() = 0;
        end;
        LoanRecovery.Reset();
        LoanRecovery.SetRange("Loan No", LoanNo);
        if LoanRecovery.FindSet() then begin
            repeat
                LoanRecovery2.Init();
                LoanRecovery2.TransferFields(LoanRecovery, false);
                LoanRecovery2."Loan No" := NewLoan;
                LoanRecovery2."Recovery Type" := LoanRecovery."Recovery Type";
                LoanRecovery2."Recovery Code" := LoanRecovery."Recovery Code";
                LoanRecovery2.Insert();
            until LoanRecovery.Next() = 0;
        end;
        OnlineLoanApplication."Portal Status" := OnlineLoanApplication."Portal Status"::Processing;
        OnlineLoanApplication.Modify();
        exit(NewLoanNo);
    end;

    procedure PopulateMinimumContribution(ApplicationNo: Code[20]) Amount: Decimal
    var
        Members: Record Members;
        Products: Record "Product Factory";
        SaccoSetup: Record "Sacco Setup";
        LoanApplication: Record "Loan Application";
        OnlineLoanApplication: Record "Online Loan Application";
        MemberNo, ProductCode : Code[20];
        AppliedAmount: Decimal;
    begin
        SaccoSetup.Get();
        ProductCode := '';
        MemberNo := '';
        AppliedAmount := 0;
        Amount := SaccoSetup."Minimum Deposit Cont.";
        if OnlineLoanApplication.Get(ApplicationNo) then begin
            MemberNo := OnlineLoanApplication."Member No.";
            ProductCode := OnlineLoanApplication."Product Code";
            AppliedAmount := OnlineLoanApplication."Applied Amount";
        end else begin
            if LoanApplication.Get(ApplicationNo) then begin
                ProductCode := LoanApplication."Product Code";
                MemberNo := LoanApplication."Member No.";
                AppliedAmount := OnlineLoanApplication."Applied Amount";
            end;
        end;
        if AppliedAmount > 2000000 then
            Amount := 5000
        else begin
            LoanApplication.Reset();
            LoanApplication.SetFilter("Approved Amount", '>2000000');
            LoanApplication.SetFilter("Member No.", MemberNo);
            if LoanApplication.FindFirst() then
                Amount := 5000
            else begin
                if Products.Get(ProductCode) then begin
                    if Products."Minimum Deposit Contribution" <> 0 then
                        Amount := Products."Minimum Deposit Contribution"
                    else
                        Amount := SaccoSetup."Minimum Deposit Cont.";
                end;
            end;
        end;
    end;

    internal procedure SendGuarantorRequestCommunication(GuarantorRequest: Record "Online Guarantor Requests")
    var
        SMSText, SMSNo : Text;
        Notifications: Codeunit "Notifications Management";
        Members, Members2 : Record Members;
        LoanApplication: Record "Online Loan Application";
        Portal: Codeunit PortalIntegrations;
        RespCode: Code[20];
    begin
        if Members.Get(GuarantorRequest."Member No") then begin
            if LoanApplication.get(GuarantorRequest."Loan No") then begin
                if Members2.Get(LoanApplication."Member No.") then begin
                    if GuarantorRequest."Request Type" = GuarantorRequest."Request Type"::Guarantor then
                        SMSText := 'Dear ' + Members."Full Name" + ', ' + Members2."Full Name" + ' has requested loan Guarantorship of  ' + format(GuarantorRequest.AppliedAmount) + ' Kindly login to the portal to accept or reject the request. https://webportal.ushurusacco.com:7100 Email: info@ushurusacco.com Phone: 0207608700'
                    else
                        if GuarantorRequest."Request Type" = GuarantorRequest."Request Type"::Witness then
                            SMSText := 'Dear ' + Members."Full Name" + ',' + Members2."Full Name" + ' has requested you to witness a loan for them.Please Log In to the App/Members Portal to process the request.';
                    SMSNo := Members."Mobile Phone No.";
                    Notifications.SendSms(SMSNo, SMSText);
                    if Members."Member No." = Members2."Member No." then
                        Portal.ProcessGuarantorRequest(GuarantorRequest."Loan No", Members."National ID No", 0, GuarantorRequest.AppliedAmount, 0, RespCode);
                end;
            end;
        end;
    end;

    procedure GetProratedInterest(LoanNo: Code[20]; AsAtDate: Date) ProratedInterest: Decimal
    var
        LoanApplication: Record "Loan Application";
        DateFilter: Text;
        Days: Integer;
        SDate: Date;
    begin
        DateFilter := '..' + Format(AsAtDate);
        LoanApplication.Reset();
        LoanApplication.SetFilter("Date Filter", DateFilter);
        LoanApplication.SetRange("Application No", LoanNo);
        if LoanApplication.FindSet() then begin
            LoanApplication.CalcFields("Last Interest Charge", "Loan Balance");
            SDate := LoanApplication."Last Interest Charge";
            if SDate = 0D then
                SDate := LoanApplication."Posting Date";
            Days := AsAtDate - SDate;
            if Days < 0 then
                Days := 0;
            ProratedInterest := LoanApplication."Loan Balance" * LoanApplication."Interest Rate" * 0.01 * (Days / 365);
            exit(ProratedInterest);
        end else
            exit(0);
    end;

    internal procedure CheckOkToGuarantee(MemberNo: Code[20]; LoanNo: Code[20])
    var
        LoanApplication: Record "Loan Application";
    begin
        if LoanApplication.Get(LoanNo) then begin
            if MemberNo = LoanApplication.Witness then
                Error('You Cannot Be a Guarantor Since you are a Witness');
        end;
    end;

    internal procedure CheckOkToWitness(MemberNo: Code[20]; LoanNo: Code[20])
    var
        LoanApplication: Record "Loan Application";
        LoanGguarantors: Record "Loan Guarantees";
    begin
        if LoanApplication.Get(LoanNo) then begin
            LoanGguarantors.Reset();
            LoanGguarantors.SetRange("Loan No", LoanNo);
            LoanGguarantors.SetRange("Member No", MemberNo);
            if LoanGguarantors.FindFirst() then
                Error('You Cannot Be a Guarantor Since you are a Witness');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Loans Management", 'OnAfterPostLoan', '', true, true)]
    procedure CreateAdvice(var LoanApplication: Record "Loan Application")
    var
        CheckOffAdvice: Record "Checkoff Advice";
        EntryNo: Integer;
        LoanRecoveries: Record "Loan Recoveries";
        LApplication: Record "Loan Application";
        ProductType: Record "Product Factory";
        Subscriptions: Record "Member Subscriptions";
        Vendor: Record Vendor;
    begin
        CheckOffAdvice.Reset();
        CheckOffAdvice.setrange("Member No", LoanApplication."Member No.");
        if CheckOffAdvice.findset then
            CheckOffAdvice.deleteall;
        CheckOffAdvice.Reset();
        if CheckOffAdvice.FindLast() then
            EntryNo := CheckOffAdvice."Entry No" + 1
        else
            EntryNo := 1;
        LoanApplication.CalcFields("Monthly Inistallment", "Monthly Principle");
        CheckOffAdvice.Init();
        CheckOffAdvice."Entry No" := EntryNo;
        EntryNo += 1;
        CheckOffAdvice."Member No" := LoanApplication."Member No.";
        CheckOffAdvice."Amount Off" := 0;
        if LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::Amortised then
            CheckOffAdvice."Amount On" := round(LoanApplication."Monthly Inistallment", 100, '=')
        else
            CheckOffAdvice."Amount On" := round(LoanApplication."Monthly Principle", 100, '=');
        CheckOffAdvice."Current Balance" := LoanApplication."Approved Amount";
        CheckOffAdvice."Product Type" := LoanApplication."Product Code";
        CheckOffAdvice."Product Name" := LoanApplication."Product Description";
        CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::"New Loan";
        CheckOffAdvice."Advice Date" := LoanApplication."Repayment Start Date";
        CheckOffAdvice.Insert();
        if LoanApplication."New Monthly Installment" > 0 then begin
            ProductType.Reset();
            ProductType.SetRange("NWD Account", true);
            if ProductType.FindFirst() then begin
                Vendor.Reset();
                Vendor.SetRange("Member No.", LoanApplication."Member No.");
                Vendor.SetRange("Account Code", ProductType.Code);
                if Vendor.FindFirst() then begin
                    CheckOffAdvice.Init();
                    CheckOffAdvice."Entry No" := EntryNo;
                    EntryNo += 1;
                    CheckOffAdvice."Member No" := LoanApplication."Member No.";
                    Subscriptions.Reset();
                    Subscriptions.SetRange("Account Type", ProductType.Code);
                    Subscriptions.SetRange("Source Code", LoanApplication."Member No.");
                    if Subscriptions.FindFirst() then begin
                        CheckOffAdvice."Amount Off" := Subscriptions.Amount;
                        Subscriptions.Amount := LoanApplication."New Monthly Installment";
                        Subscriptions.Modify;
                    end else begin
                        Subscriptions.Init();
                        Subscriptions."Source Code" := LoanApplication."Member No.";
                        Subscriptions."Account Type" := ProductType.Code;
                        Subscriptions."Account Name" := ProductType.Name;
                        Subscriptions."Start Date" := LoanApplication."Posting Date";
                        Subscriptions.Amount := LoanApplication."New Monthly Installment";
                        Subscriptions.Insert();
                    end;
                    CheckOffAdvice."Amount On" := LoanApplication."New Monthly Installment";
                    CheckOffAdvice."Current Balance" := Vendor.Balance;
                    CheckOffAdvice."Product Type" := ProductType.Code;
                    CheckOffAdvice."Product Name" := ProductType.Name;
                    CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::Adjustment;
                    CheckOffAdvice."Advice Date" := LoanApplication."Repayment Start Date";
                    CheckOffAdvice.Insert();
                end;
            end;
        end;
        LoanRecoveries.Reset();
        LoanRecoveries.SetRange("Loan No", LoanApplication."Application No");
        if LoanRecoveries.FindSet() then begin
            repeat
                if LoanRecoveries."Recovery Type" = LoanRecoveries."Recovery Type"::Loan then begin
                    if LApplication.Get(LoanRecoveries."Recovery Code") then begin
                        CheckOffAdvice.Init();
                        CheckOffAdvice."Entry No" := EntryNo;
                        EntryNo += 1;
                        CheckOffAdvice."Member No" := LoanApplication."Member No.";
                        CheckOffAdvice."Amount Off" := 0;
                        if LApplication."New Monthly Installment" <> 0 then
                            CheckOffAdvice."Amount On" := LApplication."New Monthly Installment"
                        else
                            CheckOffAdvice."Amount On" := round(LApplication."Monthly Inistallment", 1, '>');
                        CheckOffAdvice."Current Balance" := LApplication."Approved Amount";
                        CheckOffAdvice."Product Type" := LApplication."Product Code";
                        CheckOffAdvice."Product Name" := LApplication."Product Description";
                        CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::Stoppage;
                        CheckOffAdvice."Advice Date" := LApplication."Repayment Start Date";
                        CheckOffAdvice.Insert();
                    end;
                end;
            until LoanRecoveries.Next() = 0;
        end;
    end;

    procedure PostVariation(DocumentNo: code[20])
    var
        VariationHeader: Record "Checkoff Variation Header";
        VariationLines: Record "Checkoff Variation Lines";
        CheckOffAdvice: Record "Checkoff Advice";
        EntryNo: Integer;
        LoanApplication: Record "Loan Application";
    begin
        CheckOffAdvice.Reset();
        if CheckOffAdvice.FindLast() then
            EntryNo := CheckOffAdvice."Entry No" + 1
        else
            EntryNo := 1;
        VariationHeader.Get(DocumentNo);
        VariationLines.Reset();
        VariationLines.SetRange("Document No", DocumentNo);
        VariationLines.SetRange(Modified, True);
        if VariationLines.FindSet() then begin
            repeat
                CheckOffAdvice.Init();
                CheckOffAdvice."Entry No" := EntryNo;
                EntryNo += 1;
                CheckOffAdvice."Member No" := VariationHeader."Member No";
                CheckOffAdvice."Amount Off" := VariationLines."Current Contribution";
                CheckOffAdvice."Amount On" := VariationLines."New Contribution";
                CheckOffAdvice."Current Balance" := VariationLines."Account Balance";
                CheckOffAdvice."Product Type" := VariationLines."Acount Code";
                CheckOffAdvice."Product Name" := VariationLines.Description;
                CheckOffAdvice."Advice Type" := CheckOffAdvice."Advice Type"::Adjustment;
                CheckOffAdvice."Advice Date" := VariationHeader."Effective Date";
                CheckOffAdvice.Insert();
                if LoanApplication.get(VariationLines."Acount Code") then begin
                    LoanApplication.Rescheduled := true;
                    LoanApplication."Rescheduled Installment" := VariationLines."New Contribution";
                    LoanApplication.Modify();
                end;
            until VariationLines.Next() = 0;
        end;
        VariationHeader.Processed := true;
        VariationHeader.Modify();
    end;

    procedure PopulateDefaulters(DocumentNo: code[20])
    var
        DefaulerNoticeLines: Record "Notice Lines";
        DefaultNotice: Record "Notice Header";
        LoanApplication: Record "Loan Application";
        Window: Dialog;
        Member: Record Members;
        All, Current : integer;
        Ok: Boolean;
    begin
        DefaultNotice.get(DocumentNo);
        DefaulerNoticeLines.RESET;
        DefaulerNoticeLines.SETRANGE("Document No", DefaultNotice."Document No");
        DefaulerNoticeLines.SETRANGE(Notified, FALSE);
        IF DefaulerNoticeLines.FINDSET THEN
            DefaulerNoticeLines.DELETEALL;
        LoanApplication.RESET;
        LoanApplication.SETFILTER("Total Arrears", '>0');
        LoanApplication.SETFILTER("Loan Balance", '>0');
        IF LoanApplication.FINDSET THEN BEGIN
            Window.OPEN('Populating \#1##\@2@@');
            All := LoanApplication.COUNT;
            Current := 0;
            REPEAT
                Window.UPDATE(1, LoanApplication."Member Name");
                Window.UPDATE(2, ((Current / All) * 10000) DIV 1);
                LoanApplication.CalcFields("Loan Balance");
                Current += 1;
                DefaulerNoticeLines.INIT;
                DefaulerNoticeLines."Document No" := DefaultNotice."Document No";
                DefaulerNoticeLines."Member No" := LoanApplication."Member No.";
                DefaulerNoticeLines."Member Name" := LoanApplication."Member Name";
                DefaulerNoticeLines."Loan No" := LoanApplication."Application No";
                DefaulerNoticeLines."Product Code" := LoanApplication."Product Code";
                DefaulerNoticeLines."Product Description" := LoanApplication."Product Description";
                DefaulerNoticeLines."Loan Balance" := LoanApplication."Loan Balance";
                DefaulerNoticeLines."Defaulted Days" := LoanApplication."Defaulted Days";
                DefaulerNoticeLines."Total Arrears" := ROUND(LoanApplication."Total Arrears", 1, '=');
                IF ((LoanApplication."Defaulted Days" <= 30) AND (LoanApplication."Defaulted Days" > 0)) THEN
                    DefaulerNoticeLines."Notice Type" := DefaulerNoticeLines."Notice Type"::"1st"
                ELSE
                    IF ((LoanApplication."Defaulted Days" > 30) AND (LoanApplication."Defaulted Days" <= 60)) THEN
                        DefaulerNoticeLines."Notice Type" := DefaulerNoticeLines."Notice Type"::"2nd"
                    ELSE
                        DefaulerNoticeLines."Notice Type" := DefaulerNoticeLines."Notice Type"::"3rd";
                IF Member.GET(LoanApplication."Member No.") THEN
                    DefaulerNoticeLines."E-Mail" := Member."E-Mail Address";
                LoanApplication.CALCFIELDS("Total Securities", "Self Guarantee");
                IF LoanApplication."Total Securities" = LoanApplication."Self Guarantee" THEN
                    DefaulerNoticeLines."Self Guarantee" := TRUE;
                DefaulerNoticeLines."Defaulted Installments" := LoanApplication."Defaulted Installments";
                IF DefaulerNoticeLines."Defaulted Days" > 0 THEN
                    Ok := DefaulerNoticeLines.INSERT;
            UNTIL LoanApplication.NEXT = 0;
            Window.CLOSE;
        END else
            Message('No Loans in the filter ' + LoanApplication.GetFilters);
    end;

    procedure SendNotice(var DocumentNo: Code[20]; NoticeType: Option "1st","2nd","3rd");
    var
        DefaulerNoticeLines: Record "Notice Lines";
        DefaultNotice: Record "Notice Header";
        Member: Record Members;
        CompanyInformation: Record "Company Information";
        SenderName, SenderAddress, Body, Subject : Text[100];
        Receipient, ReceipientCC : List of [Text];
        Window: Dialog;
        LoanApplicationSecurities: Record "Loan Guarantees";
        CreditEmailMGt: Codeunit "Credit Email Management";
        FilePath: Text;
        MessageBody: BigText;
        LoanApplication: Record "Loan Application";
    begin
        Clear(MessageBody);
        DefaultNotice.get(DocumentNo);
        DefaulerNoticeLines.RESET;
        DefaulerNoticeLines.SETRANGE("Document No", DefaultNotice."Document No");
        CASE NoticeType OF
            NoticeType::"1st":
                DefaulerNoticeLines.SETRANGE("Notice Type", DefaulerNoticeLines."Notice Type"::"1st");
            NoticeType::"2nd":
                DefaulerNoticeLines.SETRANGE("Notice Type", DefaulerNoticeLines."Notice Type"::"2nd");
            NoticeType::"3rd":
                DefaulerNoticeLines.SETRANGE("Notice Type", DefaulerNoticeLines."Notice Type"::"3rd");
        END;
        DefaulerNoticeLines.SETRANGE(Notified, FALSE);
        DefaulerNoticeLines.SETFILTER("E-Mail", '<>0');
        IF DefaulerNoticeLines.FINDSET THEN BEGIN
            CompanyInformation.GET;
            SenderName := CompanyInformation.Name;
            Window.OPEN('Sending \#1###');
            REPEAT
                Window.UPDATE(1, DefaulerNoticeLines."Member Name");
                IF DefaulerNoticeLines."E-Mail" <> '' THEN BEGIN
                    CASE NoticeType OF
                        NoticeType::"1st":
                            BEGIN
                                FilePath := 'C:\Attachments\' + DefaulerNoticeLines."Loan No" + '.pdf';
                                if file.Exists(FilePath) then
                                    file.Erase(FilePath);
                                LoanApplication.Reset();
                                LoanApplication.SetRange("Application No", DefaulerNoticeLines."Loan No");
                                if LoanApplication.FindSet() then begin
                                    REPORT.SAVEASPDF(Report::"Defaulter Notice", FilePath, LoanApplication);
                                end;
                                Member.GET(DefaulerNoticeLines."Member No");
                                Receipient.Add(Member."E-Mail Address");
                                Subject := 'Loan Repayment Default 1st Reminder-' + DefaulerNoticeLines."Member No";
                                MessageBody.AddText('<p style="font-family:Times New Roman">Dear ' + DefaulerNoticeLines."Member Name" + ',<BR><BR><BR>');
                                MessageBody.AddText('Please note that your ' + DefaulerNoticeLines."Product Description" + ' Loan account is in Kshs. ' + FORMAT(DefaulerNoticeLines."Total Arrears") + ' arrears as at ' + FORMAT(TODAY) + '.');
                                MessageBody.AddText('<BR><BR>');
                                MessageBody.AddText('Kindly settle the specified amount within 14 Days.<BR>');
                                MessageBody.AddText('<BR>Take note that the account continues to attract 1 % interest charge on a monthly basis. Also note that all accounts in arrears will attract a 3 % penalty charge of the repayment amount.');
                                MessageBody.AddText('<BR><BR>If you’ve already made your payment, kindly accept our thanks and apologies for any inconvenience this notice may have caused you.<br><br>');
                                MessageBody.AddText('<BR><BR>Yours Faithfully,<BR>');
                                MessageBody.AddText('<BR>Loan Recovery Section.<BR>');
                                MessageBody.AddText('<BR>Mhasibu Sacco Ltd');
                                CreditEmailMGt.SendEmail(MessageBody, Subject, Receipient, ReceipientCC, FilePath, 'Defaulter Notice.PDF');
                            END;
                        NoticeType::"2nd":
                            BEGIN
                                Member.GET(DefaulerNoticeLines."Member No");
                                Receipient.Add(Member."E-Mail Address");
                                FilePath := 'C:\Attachments\' + DefaulerNoticeLines."Loan No" + '.pdf';
                                if file.Exists(FilePath) then
                                    file.Erase(FilePath);
                                LoanApplication.Reset();
                                LoanApplication.SetRange("Application No", DefaulerNoticeLines."Loan No");
                                if LoanApplication.FindSet() then begin
                                    REPORT.SAVEASPDF(Report::"Defaulter Notice", FilePath, LoanApplication);
                                end;
                                Subject := 'Loan Repayment Default 2nd Reminder-' + DefaulerNoticeLines."Member No";
                                MessageBody.AddText('<p style="font-family:Times New Roman">Dear ' + DefaulerNoticeLines."Member Name" + ',<BR><BR><BR>');
                                MessageBody.AddText('Further to our previous communications, we would like to bring to your attention that your ' + DefaulerNoticeLines."Product Description"
                                + ' Loan arrears stand at Ksh. ' + FORMAT(DefaulerNoticeLines."Total Arrears") + ' arrears as at ' + FORMAT(TODAY) + '.');
                                MessageBody.AddText('<BR>Take note that the account continues to attract a 1 % interest charge on a monthly basis. Also note that all accounts in arrears will attract a penalty charge of 3% of the repayment amount.<BR>');
                                MessageBody.AddText('<BR>Kindly but urgently make arrangements to regularize the arrears as soon as possible but not later than 14 days from the date of this letter. <BR>');
                                IF DefaulerNoticeLines."Self Guarantee" = FALSE THEN
                                    MessageBody.AddText('<BR><B>FURTHER NOTE:</B> Until you have fully cleared your loan arrears, your guarantors will not be allowed to borrow to avoid further exposure to the Sacco.<BR>');
                                MessageBody.AddText('<BR>In case you require any clarification in regard to the above, kindly contact the undersigned.<BR>');
                                MessageBody.AddText('<BR>Yours Faithfully,<BR>');
                                MessageBody.AddText('Loan Recovery Section.<BR>');
                                MessageBody.AddText('Mhasibu Sacco Ltd<BR>');
                                LoanApplicationSecurities.RESET;
                                LoanApplicationSecurities.SETRANGE(Substituted, false);
                                LoanApplicationSecurities.SETRANGE("Loan No", DefaulerNoticeLines."Loan No");
                                IF LoanApplicationSecurities.FINDSET THEN BEGIN
                                    REPEAT
                                        IF Member.GET(LoanApplicationSecurities."Member No") THEN BEGIN
                                            IF Member."E-Mail Address" <> '' THEN
                                                ReceipientCC.Add(Member."E-Mail Address");
                                        END;
                                    UNTIL LoanApplicationSecurities.NEXT = 0;
                                END;
                                CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, ReceipientCC, FilePath, 'Defaulter Notice.PDF');
                            END;
                        NoticeType::"3rd":
                            BEGIN
                                Member.GET(DefaulerNoticeLines."Member No");
                                Receipient.add(Member."E-Mail Address");
                                FilePath := 'C:\Attachments\' + DefaulerNoticeLines."Loan No" + '.pdf';
                                if file.Exists(FilePath) then
                                    file.Erase(FilePath);
                                LoanApplication.Reset();
                                LoanApplication.SetRange("Application No", DefaulerNoticeLines."Loan No");
                                if LoanApplication.FindSet() then begin
                                    REPORT.SAVEASPDF(Report::"Defaulter Notice", FilePath, LoanApplication);
                                end;
                                Subject := 'Loan Repayment Default 3rd Reminder-' + DefaulerNoticeLines."Member No";
                                MessageBody.AddText('<p style="font-family:Times New Roman">Dear ' + DefaulerNoticeLines."Member Name" + ',<BR><BR><BR>');
                                MessageBody.AddText('Dear ' + DefaulerNoticeLines."Member Name" + ',<BR><BR><BR>');
                                MessageBody.AddText('Further to our previous communications, we would like to bring to your attention that your '
                                + DefaulerNoticeLines."Product Description" + ' Loan arrears stand at Ksh. ' + FORMAT(DefaulerNoticeLines."Total Arrears") + ' as at ' + FORMAT(TODAY) + '.');
                                MessageBody.AddText('<BR><BR>Take note that the account continues to attract a 1 % interest charge on a monthly basis.');
                                MessageBody.AddText('<BR><BR>Please note that all accounts in arrears will attract a penalty charge of 3% of the repayment amount.');
                                MessageBody.AddText('<BR><BR>Kindly but urgently make arrangements to regularize the arrears as soon as possible but not later than 14 days from the date of this letter. ');
                                IF DefaulerNoticeLines."Self Guarantee" = FALSE THEN
                                    MessageBody.AddText('<BR><B>FURTHER NOTE:<B> Until you settle your outstanding loan arrears, your guarantors will not be allowed to borrow to avoid further exposure to the Sacco. '
                                      + 'We will also recover the loan from yourself and your guarantors without any further reference to you. ');
                                MessageBody.AddText('Please note that if the arrears are not settled within the aforesaid timeline, the Sacco '
                                + 'will have no alternative but to forward your name to the Credit Reference Bureau as per the Sacco policy.</B>');
                                MessageBody.AddText('<BR><BR><BR>Yours Faithfully,<BR>');
                                MessageBody.AddText('<BR>Loan Recovery Section.<BR>');
                                MessageBody.AddText('<BR>Mhasibu Sacco Ltd<BR>');
                                LoanApplicationSecurities.RESET;
                                LoanApplicationSecurities.SETRANGE(Substituted, FALSE);
                                LoanApplicationSecurities.SETRANGE("Loan No", DefaulerNoticeLines."Loan No");
                                IF LoanApplicationSecurities.FINDSET THEN BEGIN
                                    REPEAT
                                        IF Member.GET(LoanApplicationSecurities."Member No") THEN BEGIN
                                            IF Member."E-Mail Address" <> '' THEN
                                                ReceipientCC.Add(Member."E-Mail Address");
                                        END;
                                    UNTIL LoanApplicationSecurities.NEXT = 0;
                                END;
                                CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, ReceipientCC, FilePath, 'Defaulter Notice.PDF');
                            END;
                    END;
                    DefaulerNoticeLines.Notified := TRUE;
                    DefaulerNoticeLines.MODIFY;
                    COMMIT;
                END;
            UNTIL DefaulerNoticeLines.NEXT = 0;
            Window.CLOSE;
        END;
    end;

    procedure GetNetAmount(LoanNo: code[20]) NetAmount: Decimal;
    var
        LoanApplication: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
        LoanProducts: Record "Product Factory";
        JournalManagement: Codeunit "Journal Management";
    begin
        NetAmount := 0;
        if LoanApplication.get(LoanNo) then begin
            NetAmount := LoanApplication."Approved Amount";
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanNo);
            if LoanRecoveries.FindSet() then begin
                LoanRecoveries.CalcSums(Amount, "Commission Amount");
                NetAmount -= (LoanRecoveries.Amount + LoanRecoveries."Commission Amount");
            end;
            if LoanProducts.get(LoanApplication."Product Code") then begin
                NetAmount -= JournalManagement.GetTransactionCharges(LoanProducts."Loan Charges", LoanApplication."Approved Amount");
            end;
        end;
        exit(NetAmount);
    end;

    procedure PostLoanRecovery(DocumentNo: Code[20])
    var
        RecoveryHeader: Record "Loan Recovery Header";
        RecoveryLines: Record "Loan Recovery Lines";
        LoanApplication, NewLoanApp : Record "Loan Application";
        SaccoSetup: Record "Sacco Setup";
        LoanProduct, NewLoanProduct : Record "Product Factory";
        LineNo: Integer;
        MemberMgt: Codeunit "Member Management";
        JournalManagement: Codeunit "Journal Management";
        JournalBatch, JournalTemplate, ReasonCode, SourceCode, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, MemberNo, ExternalDocumentNo, AccountNo : code[20];
        NewMemberNo, NewReasonCode, NewSourceCode : Code[20];
        NoSeries: Codeunit NoSeriesManagement;
        PostingDate: Date;
        PostingAmount, TotalRecoveredAmount, InterestPaid, PrinciplePaid : Decimal;
        RecoveryAccounts: Record "Loan Recovey Accounts";
        PostingDescription: Text[50];
    begin
        SaccoSetup.Get();
        RecoveryHeader.Get(DocumentNo);
        RecoveryHeader.CalcFields("Self Recovery Amount");
        JournalBatch := 'LREC';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Loan Recoveries Batch');
        RecoveryHeader.TestField("Approval Status", RecoveryHeader."Approval Status"::Approved);
        RecoveryHeader.CalcFields("Guarantor Deposit Recovery", "Guarantor Liability Recovery");
        TotalRecoveredAmount := RecoveryHeader."Guarantor Deposit Recovery" + RecoveryHeader."Self Recovery Amount" + RecoveryHeader."Guarantor Liability Recovery";
        LoanApplication.Get(RecoveryHeader."Loan No");
        PostingDate := RecoveryHeader."Posting Date";
        LoanProduct.Get(LoanApplication."Product Code");
        ReasonCode := LoanApplication."Application No";
        SourceCode := LoanApplication."Product Code";
        MemberNo := LoanApplication."Member No.";
        if RecoveryHeader."Self Recovery Amount" > 0 then begin
            RecoveryAccounts.Reset();
            RecoveryAccounts.SetRange("Document No", DocumentNo);
            RecoveryAccounts.SetFilter("Recovery Amount", '>0');
            if RecoveryAccounts.FindSet() then begin
                repeat
                    AccountNo := '';
                    AccountNo := RecoveryAccounts."Account No";
                    PostingDescription := 'Loan Recovery';
                    PostingAmount := 0;
                    PostingAmount := RecoveryAccounts."Recovery Amount";
                    //Debit Depositor
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                until RecoveryAccounts.Next() = 0;
            end;
        end;
        RecoveryLines.Reset();
        RecoveryLines.SetRange("Document No", DocumentNo);
        if RecoveryLines.FindSet() then begin
            repeat
                case RecoveryLines."Recovery Type" of
                    RecoveryLines."Recovery Type"::Deposits:
                        begin
                            PostingAmount := 0;
                            PostingAmount := RecoveryLines."Recovery Amount";
                            PostingDescription := 'Loan Recovery ' + RecoveryHeader."Member Name";
                            NewMemberNo := '';
                            NewMemberNo := RecoveryLines."Member No";
                            AccountNo := '';
                            AccountNo := MemberMgt.GetMemberAccount(NewMemberNo, 'DEPOSIT');
                            //Debit Depositor
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, NewMemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                        end;
                    RecoveryLines."Recovery Type"::"Guarantor Liability Loan":
                        begin
                            PostingAmount := 0;
                            PostingAmount := RecoveryLines."Recovery Amount";
                            NewMemberNo := '';
                            NewMemberNo := RecoveryLines."Member No";
                            NewReasonCode := '';
                            NewReasonCode := NoSeries.GetNextNo(SaccoSetup."Loan Application Nos.", Today, true);
                            NewLoanProduct.Get(RecoveryLines."Product Code");
                            NewLoanApp.Init();
                            NewLoanApp."Application No" := NewReasonCode;
                            NewLoanApp."Product Code" := NewLoanProduct.Code;
                            NewLoanApp."Product Description" := NewLoanProduct.Name;
                            NewLoanApp."Member No." := NewMemberNo;
                            NewLoanApp."Member Name" := RecoveryLines."Member Name";
                            NewLoanApp."Application Date" := PostingDate;
                            NewLoanApp."Posting Date" := PostingDate;
                            NewLoanApp."Posted On" := CurrentDateTime;
                            NewLoanApp."Loan Account" := CreateLoanAccounts(NewLoanApp);
                            NewLoanApp."Applied Amount" := RecoveryLines."Recovery Amount";
                            NewLoanApp."Approved Amount" := NewLoanApp."Applied Amount";
                            NewLoanApp."Approval Status" := NewLoanApp."Approval Status"::Approved;
                            NewLoanApp.Status := NewLoanApp.Status::Disbursed;
                            NewLoanApp."Loan Classification" := NewLoanApp."Loan Classification"::Loss;
                            NewLoanApp.Posted := true;
                            NewLoanApp.Disbursed := true;
                            NewLoanApp.Insert();
                            PostingDescription := 'Guarantor Liability Loan Disbursal';
                            AccountNo := NewLoanApp."Loan Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, NewMemberNo, DocumentNo, GlobalTransactionType::"Loan Disbursal", LineNo, NewLoanProduct.Code, NewReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                        end;
                end;
            until RecoveryLines.Next() = 0;
        end;
        LoanApplication.CalcFields("Interest Balance", "Principle Balance");
        if ((LoanApplication."Interest Balance" + RecoveryHeader."Accrued Interest") < TotalRecoveredAmount) then begin
            InterestPaid := LoanApplication."Interest Balance" + RecoveryHeader."Accrued Interest";
            TotalRecoveredAmount -= (LoanApplication."Interest Balance" + RecoveryHeader."Accrued Interest");
        end else begin
            InterestPaid := TotalRecoveredAmount;
            TotalRecoveredAmount := 0;
        end;
        PrinciplePaid := TotalRecoveredAmount;
        PostingAmount := 0;
        PostingAmount := InterestPaid;
        PostingDescription := 'Interest Paid';
        AccountNo := '';
        AccountNo := LoanApplication."Loan Account";
        //Debit Depositor
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        LoanProduct.Get(LoanApplication."Product Code");
        if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
            AccountNo := '';
            AccountNo := LoanProduct."Interest Paid Account";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            AccountNo := '';
            AccountNo := LoanProduct."Interest Due Account";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        end;
        PostingAmount := 0;
        PostingAmount := RecoveryHeader."Accrued Interest";
        AccountNo := '';
        AccountNo := LoanProduct."Interest Paid Account";
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        PostingDescription := 'Accrued Interest';
        AccountNo := LoanApplication."Loan Account";
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Due", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        PostingAmount := 0;
        PostingAmount := PrinciplePaid;
        PostingDescription := 'Principle Paid';
        AccountNo := '';
        AccountNo := LoanApplication."Loan Account";
        //Debit Depositor
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        RecoveryHeader.Processed := true;
        RecoveryHeader.Modify();
    end;

    procedure GetArrearsAmount(LoanNo: Code[20]; AsAtDate: Date)
    var
        DateFilter: Text[100];
        LoanApplication: Record "Loan Application";
        ExpectedPrinciple, ExpectedInterest, PrinciplePaid, InterestPaid, InterestArrears, PrincipleArrears, TotalArrears : decimal;
        DefaultedInstallments, DefaultedDays : integer;
    begin
        DateFilter := '..' + Format(AsAtDate);
        LoanApplication.Reset();
        LoanApplication.SetFilter("Date Filter", DateFilter);
        LoanApplication.SetRange("Application No", LoanNo);
        if LoanApplication.FindSet() then begin
            LoanApplication.CalcFields("Monthly Inistallment", "Interest Paid", "Principle Repayment", "Total Interest Due", "Net Change-Principal");
            if ((LoanApplication."Loan Balance" > 0) AND (LoanApplication."Monthly Inistallment" > 0)) then begin
                if LoanApplication."Repayment End Date" < AsAtDate then begin
                    DefaultedDays := AsAtDate - LoanApplication."Repayment End Date";
                    DefaultedInstallments := Round((DefaultedDays / 365), 1, '>');
                    if DefaultedDays < 365 then begin
                        DefaultedDays := 365;
                        DefaultedInstallments := 12;
                    end;
                end else begin
                    ExpectedPrinciple := LoanApplication."Principle Repayment";
                    PrinciplePaid := LoanApplication."Approved Amount" - LoanApplication."Net Change-Principal";
                    ExpectedInterest := LoanApplication."Total Interest Due";
                    InterestPaid := LoanApplication."Interest Paid";
                    InterestArrears := ExpectedInterest + InterestPaid;
                    PrincipleArrears := ExpectedPrinciple - PrinciplePaid;
                    TotalArrears := PrincipleArrears + InterestArrears;
                    DefaultedInstallments := Round((TotalArrears / LoanApplication."Monthly Inistallment"), 1, '>');
                    DefaultedInstallments := DefaultedInstallments * 30;
                end;
                LoanApplication."Interest Arrears" := InterestArrears;
                LoanApplication."Principle Arrears" := PrincipleArrears;
                LoanApplication."Total Arrears" := TotalArrears;
                LoanApplication."Defaulted Installments" := DefaultedInstallments;
                LoanApplication."Defaulted Days" := DefaultedDays;
                IF DefaultedDays = 0 THEN
                    LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Performing
                ELSE
                    IF ((DefaultedDays > 0) AND (DefaultedDays <= 30)) THEN
                        LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Watch
                    ELSE
                        IF ((DefaultedDays > 30) AND (DefaultedDays <= 180)) THEN
                            LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Substandard
                        ELSE
                            IF ((DefaultedDays > 180) AND (DefaultedDays <= 360)) THEN
                                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Doubtfull
                            ELSE
                                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Loss;
                LoanApplication.Modify();
            end else begin
                LoanApplication."Loan Classification" := LoanApplication."Loan Classification"::Performing;
                LoanApplication."Total Arrears" := 0;
                LoanApplication."Interest Arrears" := 0;
                LoanApplication."Principle Arrears" := 0;
                LoanApplication.Modify();
            end;
        end;
    end;

    procedure GetChargeAmount(TransactionCode: Code[20]; ChargeCode: Code[20]; BaseAmount: Decimal) ChargeAmount: Decimal
    var
        TransactionCharges: Record "Transaction Charges";
        TransactionCalcScheme, TransactionCalcScheme1 : Record "Transaction Calc. Scheme";
        PostingAmount, TotalCharges, TempBase : Decimal;
    begin
        TotalCharges := 0;
        TransactionCharges.RESET;
        TransactionCharges.SETRANGE("Transaction Code", TransactionCode);
        TransactionCharges.SetRange("Charge Code", ChargeCode);
        IF TransactionCharges.FindSet() THEN BEGIN
            REPEAT
                PostingAmount := 0;
                IF TransactionCharges."Calculation Type" = TransactionCharges."Calculation Type"::"Calculation Scheme" THEN BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", TransactionCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        PostingAmount := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::Percentage THEN
                            PostingAmount := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                    END;
                END ELSE BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", TransactionCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Source Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        TempBase := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::"Percentage" THEN
                            TempBase := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                        TransactionCalcScheme1.RESET;
                        TransactionCalcScheme1.SETFILTER("Lower Limit", '<=%1', TempBase);
                        TransactionCalcScheme1.SETFILTER("Upper Limit", '>=%1', TempBase);
                        TransactionCalcScheme1.SETRANGE("Transaction Code", TransactionCode);
                        TransactionCalcScheme1.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                        IF TransactionCalcScheme1.FINDFIRST THEN BEGIN
                            PostingAmount := TransactionCalcScheme1.Rate;
                            IF TransactionCalcScheme1."Rate Type" = TransactionCalcScheme1."Rate Type"::"Percentage" THEN
                                PostingAmount := ((TransactionCalcScheme1.Rate) / 100) * TempBase;
                        END;
                    END;
                END;
                TotalCharges += PostingAmount;
            UNTIL TransactionCharges.NEXT = 0;
        END;
        Exit(TotalCharges);
    end;

    procedure AppraiseZeroDeposits(LoanApplication: record "Loan Application")
    var
        LoanProducts: Record "Product Factory";
        LoanRecoveries: Record "Loan Recoveries";
        MemberDeposits, ExpectedDeposits, Variance : Decimal;
        Ok: Boolean;
        AccountNo: Code[20];
        MemberMgt: Codeunit "Member Management";
    begin
        AccountNo := '';
        ExpectedDeposits := 0;
        if LoanProducts.Get(LoanApplication."Product Code") then begin
            if LoanProducts."Loan Multiplier" <> 0 then
                ExpectedDeposits := LoanApplication."Applied Amount" / LoanProducts."Loan Multiplier"
            else
                ExpectedDeposits := LoanApplication."Applied Amount" / 4;
            if LoanProducts."Appraise with 0 Deposits" then begin
                MemberDeposits := GetMemberDeposits(LoanApplication."Member No.");
                Variance := ExpectedDeposits - MemberDeposits;
                if Variance < 0 then
                    Variance := 0;
                AccountNo := MemberMgt.GetMemberAccount(LoanApplication."Member No.", 'DEPOSIT');
                if not LoanRecoveries.Get(LoanApplication."Application No", LoanRecoveries."Recovery Type"::Account, AccountNo) then begin
                    LoanRecoveries.Init();
                    LoanRecoveries."Loan No" := LoanApplication."Application No";
                    LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Account;
                    LoanRecoveries.Validate("Recovery Code", 'DEP-' + LoanApplication."Member No.");
                    LoanRecoveries.Amount := Variance;
                    LoanRecoveries.Validate(Amount);
                    if Variance <> 0 then
                        Ok := LoanRecoveries.Insert();
                end;
            end;
        end;
        Commit();
    end;

    procedure OnlineAppraiseZeroDeposits(LoanApplication: record "Online Loan Application")
    var
        LoanProducts: Record "Product Factory";
        LoanRecoveries: Record "Loan Recoveries";
        MemberDeposits, ExpectedDeposits, Variance : Decimal;
        Ok: Boolean;
    begin
        LoanRecoveries.Reset();
        LoanRecoveries.SetRange("Loan No", LoanApplication."Application No");
        LoanRecoveries.SetRange("Recovery Code", 'DEP-' + LoanApplication."Member No.");
        if LoanRecoveries.FindSet() then
            LoanRecoveries.Delete();
        ExpectedDeposits := 0;
        if LoanProducts.Get(LoanApplication."Product Code") then begin
            if LoanProducts."Loan Multiplier" <> 0 then
                ExpectedDeposits := LoanApplication."Applied Amount" / LoanProducts."Loan Multiplier"
            else
                ExpectedDeposits := LoanApplication."Applied Amount" / 4;
            if LoanProducts."Appraise with 0 Deposits" then begin
                MemberDeposits := GetMemberDeposits(LoanApplication."Member No.");
                Variance := ExpectedDeposits - MemberDeposits;
                if Variance < 0 then
                    Variance := 0;
                LoanRecoveries.Init();
                LoanRecoveries."Loan No" := LoanApplication."Application No";
                LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Account;
                LoanRecoveries.Validate("Recovery Code", 'DEP-' + LoanApplication."Member No.");
                LoanRecoveries.Amount := Variance;
                LoanRecoveries.Validate(Amount);
                if Variance <> 0 then
                    Ok := LoanRecoveries.Insert();
            end;
        end;
        Commit();
    end;

    procedure GetFOSAAccount(MemberNo: Code[20]) FOSAAccount: Code[20]
    var
        AccountType: Record "Product Factory";
        Vendor: Record Vendor;
        MemberMgt: Codeunit "Member Management";
    begin
        FOSAAccount := MemberMgt.GetMemberAccount(MemberNo, 'FOSA');
        if not Vendor.get(FOSAAccount) then
            Error('The Member Does Not Have a FOSA Account');
        exit(FOSAAccount);
    end;

    procedure PopulateAppraisalParameters(Loan: Record "Loan Application")
    var
        LoanAppraisalParameters: Record "Loan Appraisal Parameters";
        AppraisalParameters: Record "Appraisal Parameters";
        Vendor: Record Vendor;
        AccountTypes: Record "Product Factory";
        AppraisalAccounts: Record "Appraisal Accounts";
        Loans: Record "Loan Application";
        LoanProducts: Record "Product Factory";
        LoanApp: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
        ProductFactory: Record "Product Factory";
        CommissionPercent: Decimal;
    begin
        LoanAppraisalParameters.Reset();
        LoanAppraisalParameters.SetRange("Loan No", loan."Application No");
        if LoanAppraisalParameters.findset then
            LoanAppraisalParameters.DeleteAll();
        AppraisalAccounts.Reset();
        AppraisalAccounts.SetRange("Loan No", Loan."Application No");
        if AppraisalAccounts.FindSet() then
            AppraisalAccounts.DeleteAll();
        if LoanProducts.Get(Loan."Product Code") then begin
            Loans.Reset();
            Loans.SetRange("Member No.", Loan."Member No.");
            loans.SetFilter("Loan Balance", '>0');
            if Loans.FindSet() then begin
                repeat
                    loans.CalcFields("Loan Balance");
                    AppraisalAccounts.Init();
                    AppraisalAccounts."Loan No" := Loan."Application No";
                    AppraisalAccounts."Account Type" := AppraisalAccounts."Account Type"::Loan;
                    AppraisalAccounts."Account No" := Loans."Application No";
                    AppraisalAccounts."Account Description" := Loans."Product Description";
                    AppraisalAccounts.Balance := Loans."Loan Balance";
                    AppraisalAccounts.Insert();
                until Loans.Next() = 0;
            end;
            Vendor.Reset();
            Vendor.SetRange("Member No.", Loan."Member No.");
            if Vendor.FindSet() then begin
                repeat
                    Vendor.CalcFields("Net Change");
                    if Vendor."Account Class" = Vendor."Account Class"::NWD then begin
                        AppraisalAccounts.Init();
                        AppraisalAccounts."Loan No" := Loan."Application No";
                        AppraisalAccounts."Account Type" := AppraisalAccounts."Account Type"::"Member Account";
                        AppraisalAccounts."Account No" := Vendor."No.";
                        AppraisalAccounts."Account Description" := Vendor.Name;
                        AppraisalAccounts.Balance := Vendor."Net Change";
                        if Vendor."Account Class" = Vendor."Account Class"::NWD then
                            AppraisalAccounts."Mulltipled Value" := Vendor."Net Change" * LoanProducts."Loan Multiplier";
                        AppraisalAccounts.Insert();
                    end;
                until Vendor.Next() = 0;
            end;
            AppraisalParameters.Reset();
            if AppraisalParameters.FindSet() then begin
                repeat
                    LoanAppraisalParameters.Init();
                    LoanAppraisalParameters."Loan No" := Loan."Application No";
                    LoanAppraisalParameters."Appraisal Code" := AppraisalParameters.Code;
                    LoanAppraisalParameters."Parameter Description" := AppraisalParameters.Description;
                    LoanAppraisalParameters.Type := AppraisalParameters.Type;
                    LoanAppraisalParameters.Class := AppraisalParameters.Class;
                    LoanAppraisalParameters.Insert();
                until AppraisalParameters.Next() = 0;
            end;
        end;
        LoanApp.Reset();
        LoanApp.SetFilter("Loan Balance", '>0');
        LoanApp.SetRange("Member No.", Loan."Member No.");
        LoanApp.SetRange("Product Code", Loan."Product Code");
        if LoanApp.FindSet() then begin
            ProductFactory.Get(LoanApp."Product Code");
            CommissionPercent := 0;
            CommissionPercent := ProductFactory."Discounting %";
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", Loan."Application No");
            LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
            LoanRecoveries.SetRange("Recovery Code", LoanApp."Application No");
            if LoanRecoveries.findfirst then begin
                LoanRecoveries."Recovery Description" := ProductFactory.Name;
                LoanRecoveries."Commission %" := CommissionPercent;
                LoanRecoveries."Commission Account" := ProductFactory."Commission Account";
                LoanApp.CalcFields("Loan Balance");
                LoanRecoveries."Current Balance" := LoanApp."Loan Balance";
                LoanRecoveries.Validate(Amount, LoanRecoveries."Current Balance");
                LoanRecoveries.Modify();
            end else begin
                ProductFactory.Get(LoanApp."Product Code");
                LoanRecoveries.Init();
                LoanRecoveries."Loan No" := Loan."Application No";
                LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Loan;
                LoanRecoveries.Validate("Recovery Code", LoanApp."Application No");
                ProductFactory.Get(LoanApp."Product Code");
                LoanRecoveries."Recovery Code" := LoanApp."Application No";
                LoanRecoveries."Recovery Description" := ProductFactory.Name;
                LoanRecoveries."Commission %" := CommissionPercent;
                LoanRecoveries."Commission Account" := ProductFactory."Commission Account";
                LoanApp.CalcFields("Loan Balance");
                LoanRecoveries."Current Balance" := LoanApp."Loan Balance";
                LoanRecoveries.Validate(Amount, LoanRecoveries."Current Balance");
                LoanRecoveries.Insert();
            end;
        end;
    end;

    procedure GetBoostedDeposits(Application: Code[20]) BoostedAmount: Decimal
    var
        Recoveries: Record "Loan Recoveries";
    begin
        Recoveries.Reset();
        Recoveries.SetRange("Recovery Type", Recoveries."Recovery Type"::Account);
        Recoveries.SetRange("Loan No", Application);
        if Recoveries.FindSet() then begin
            Recoveries.CalcSums(Amount);
            BoostedAmount := Recoveries.Amount;
        end;
        exit(BoostedAmount);
    end;

    procedure PopulateOnlineAppraisalParameters(Loan: Record "Online Loan Application")
    var
        LoanAppraisalParameters: Record "Loan Appraisal Parameters";
        AppraisalParameters: Record "Appraisal Parameters";
        Vendor: Record Vendor;
        AccountTypes: Record "Product Factory";
        AppraisalAccounts: Record "Appraisal Accounts";
        Loans: Record "Loan Application";
        LoanProducts: Record "Product Factory";
        LoanApp: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
        ProductFactory: Record "Product Factory";
        CommissionPercent: Decimal;
    begin
        LoanAppraisalParameters.Reset();
        LoanAppraisalParameters.SetRange("Loan No", loan."Application No");
        if LoanAppraisalParameters.findset then
            LoanAppraisalParameters.DeleteAll();
        AppraisalAccounts.Reset();
        AppraisalAccounts.SetRange("Loan No", Loan."Application No");
        if AppraisalAccounts.FindSet() then
            AppraisalAccounts.DeleteAll();
        if LoanProducts.Get(Loan."Product Code") then begin
            Loans.Reset();
            Loans.SetRange("Member No.", Loan."Member No.");
            loans.SetFilter("Loan Balance", '>0');
            if Loans.FindSet() then begin
                repeat
                    loans.CalcFields("Loan Balance");
                    AppraisalAccounts.Init();
                    AppraisalAccounts."Loan No" := Loan."Application No";
                    AppraisalAccounts."Account Type" := AppraisalAccounts."Account Type"::Loan;
                    AppraisalAccounts."Account No" := Loans."Application No";
                    AppraisalAccounts."Account Description" := Loans."Product Description";
                    AppraisalAccounts.Balance := Loans."Loan Balance";
                    AppraisalAccounts.Insert();
                until Loans.Next() = 0;
            end;
            Vendor.Reset();
            Vendor.SetRange("Member No.", Loan."Member No.");
            if Vendor.FindSet() then begin
                repeat
                    Vendor.CalcFields("Net Change");
                    if Vendor."Account Class" = Vendor."Account Class"::NWD then begin
                        AppraisalAccounts.Init();
                        AppraisalAccounts."Loan No" := Loan."Application No";
                        AppraisalAccounts."Account Type" := AppraisalAccounts."Account Type"::"Member Account";
                        AppraisalAccounts."Account No" := Vendor."No.";
                        AppraisalAccounts."Account Description" := Vendor.Name;
                        AppraisalAccounts.Balance := Vendor."Net Change";
                        if Vendor."Account Class" = Vendor."Account Class"::NWD then
                            AppraisalAccounts."Mulltipled Value" := (Vendor."Net Change" + GetBoostedDeposits(Loan."Application No")) * LoanProducts."Loan Multiplier";
                        AppraisalAccounts.Insert();
                    end;
                until Vendor.Next() = 0;
            end;
            AppraisalParameters.Reset();
            if AppraisalParameters.FindSet() then begin
                repeat
                    LoanAppraisalParameters.Init();
                    LoanAppraisalParameters."Loan No" := Loan."Application No";
                    LoanAppraisalParameters."Appraisal Code" := AppraisalParameters.Code;
                    LoanAppraisalParameters."Parameter Description" := AppraisalParameters.Description;
                    LoanAppraisalParameters.Type := AppraisalParameters.Type;
                    LoanAppraisalParameters.Class := AppraisalParameters.Class;
                    LoanAppraisalParameters.Insert();
                until AppraisalParameters.Next() = 0;
            end;
        end;
        LoanApp.Reset();
        LoanApp.SetFilter("Loan Balance", '>0');
        LoanApp.SetRange("Member No.", Loan."Member No.");
        LoanApp.SetRange("Product Code", Loan."Product Code");
        if LoanApp.FindSet() then begin
            ProductFactory.Get(LoanApp."Product Code");
            CommissionPercent := 0;
            CommissionPercent := ProductFactory."Discounting %";
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", Loan."Application No");
            LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
            LoanRecoveries.SetRange("Recovery Code", LoanApp."Application No");
            if LoanRecoveries.findfirst then begin
                LoanRecoveries."Recovery Description" := ProductFactory.Name;
                LoanRecoveries."Commission %" := CommissionPercent;
                LoanRecoveries."Commission Account" := ProductFactory."Commission Account";
                LoanApp.CalcFields("Loan Balance");
                LoanRecoveries."Current Balance" := LoanApp."Loan Balance";
                LoanRecoveries.Validate(Amount, LoanRecoveries."Current Balance");
                LoanRecoveries.Modify();
            end else begin
                ProductFactory.Get(LoanApp."Product Code");
                LoanRecoveries.Init();
                LoanRecoveries."Loan No" := Loan."Application No";
                LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Loan;
                LoanRecoveries.Validate("Recovery Code", LoanApp."Application No");
                ProductFactory.Get(LoanApp."Product Code");
                LoanRecoveries."Recovery Code" := LoanApp."Application No";
                LoanRecoveries."Recovery Description" := ProductFactory.Name;
                LoanRecoveries."Commission %" := CommissionPercent;
                LoanRecoveries."Commission Account" := ProductFactory."Commission Account";
                LoanApp.CalcFields("Loan Balance");
                LoanRecoveries."Current Balance" := LoanApp."Loan Balance";
                LoanRecoveries.Validate(Amount, LoanRecoveries."Current Balance");
                LoanRecoveries.Insert();
            end;
        end;
    end;

    procedure GetMemberLoans(MemberNo: Code[20]) LoanBalance: Decimal
    var
        Members: Record Members;
    begin
        LoanBalance := 0;
        if Members.Get(MemberNo) then begin
            Members.CalcFields("Outstanding Loans");
            LoanBalance := Members."Outstanding Loans";
        end;
        if LoanBalance < 0 then
            LoanBalance := 0;
        exit(LoanBalance);
    end;

    procedure GetMemberShares(MemberNo: Code[20]) SharesBalance: Decimal
    var
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.setrange("Member No.", MemberNo);
        Vendor.SetRange("Account Code", 'S01');
        if Vendor.FindSet() then begin
            repeat
                Vendor.CalcFields("Net Change");
                SharesBalance += Vendor."Net Change";
            until Vendor.Next() = 0;
        end;
        if SharesBalance < 0 then
            SharesBalance := 0;
        exit(SharesBalance);
    end;

    procedure GetSelfGuaranteeEligibility(MemberNo: code[20]) SelfGuaranteeAmount: Decimal
    var
        Vendor: Record Vendor;
        SelfG, NonSelfG, Deposits, DepositBalance, MultipliedDeposit : Decimal;
        LoanGuarantee: Record "Loan Guarantees";
        AccountType: Record "Product Factory";
        Member: Record Members;
    begin
        Member.Get(MemberNo);
        Member.CalcFields("Self Guarantee", "Non-Self Guarantee");
        SelfG := 0;
        NonSelfG := 0;
        GetSelfGuaranteeAmount(MemberNo, SelfG, NonSelfG);
        Deposits := 0;
        Deposits := GetMemberDeposits(MemberNo);
        if NonSelfG = 0 then
            SelfGuaranteeAmount := (Deposits * 0.8) - SelfG
        else
            SelfGuaranteeAmount := ((Deposits * 0.8) - (NonSelfG / GetGuarantorMultiplier) - SelfG);
        exit(SelfGuaranteeAmount);
    end;

    procedure GetGuarantorMultiplier() Multiplier: Decimal
    var
        SaccoSetup: Record "Sacco Setup";
    begin
        SaccoSetup.Get();
        if SaccoSetup."Guarantor Multiplier" = 0 then
            Multiplier := 1
        else
            Multiplier := SaccoSetup."Guarantor Multiplier";
        exit(Multiplier);
    end;

    procedure GetSelfGuaranteeAmount(MemberNo: Code[20]; var SelfAmount: Decimal; var NonSelfAmount: Decimal)
    var
        LoanGuarantee: Record "Loan Guarantees";
        MembebrMgt: Codeunit "Member Management";
    begin
        SelfAmount := 0;
        NonSelfAmount := 0;
        LoanGuarantee.Reset();
        LoanGuarantee.SetRange(Substituted, false);
        LoanGuarantee.SetRange("Member No", MemberNo);
        if LoanGuarantee.FindSet() then begin
            repeat
                LoanGuarantee.CalcFields("Loan Owner");
                if LoanGuarantee."Loan Owner" = MemberNo then
                    SelfAmount += MembebrMgt.GetOutstandingGuarantee(LoanGuarantee."Loan No", LoanGuarantee."Member No")
                else
                    NonSelfAmount += MembebrMgt.GetOutstandingGuarantee(LoanGuarantee."Loan No", LoanGuarantee."Member No");

            until LoanGuarantee.next() = 0;
        end;

    end;

    procedure GetNonSelfGuaranteeEligibility(MemberNo: code[20]) NonSelfGuaranteeAmount: Decimal
    var
        Vendor: Record Vendor;
        SelfG, NonSelfG, Deposits, DepositBalance, MultipliedDeposit, OutstandingGuarantee : Decimal;
        LoanGuarantee: Record "Loan Guarantees";
        AccountType: Record "Product Factory";
        Member: Record Members;
        MemberMgt: Codeunit "Member Management";
    begin
        Member.Get(MemberNo);
        Member.CalcFields("Self Guarantee", "Non-Self Guarantee");
        Deposits := 0;
        SelfG := 0;
        NonSelfG := 0;
        Deposits := GetMemberDeposits(MemberNo);
        OutstandingGuarantee := GetMemberOutstandingGuarantee(MemberNo);
        GetSelfGuaranteeAmount(MemberNo, SelfG, NonSelfG);
        NonSelfGuaranteeAmount := (Deposits * GetGuarantorMultiplier) - OutstandingGuarantee;
        if NonSelfGuaranteeAmount > GetMemberDeposits(MemberNo) then
            NonSelfGuaranteeAmount := GetMemberDeposits(MemberNo);
        exit(NonSelfGuaranteeAmount);
    end;

    procedure GetMemberOutstandingGuarantee(MemberNo: Code[20]) OutStandingGuarantee: Decimal
    var
        LoanGuarantee: Record "Loan Guarantees";
        MemberMgt: Codeunit "Member Management";
    begin
        OutStandingGuarantee := 0;
        LoanGuarantee.Reset();
        LoanGuarantee.SetRange(Substituted, false);
        LoanGuarantee.SetRange("Member No", MemberNo);
        if LoanGuarantee.FindSet() then begin
            repeat
                OutStandingGuarantee += MemberMgt.GetOutstandingGuarantee(MemberNo, LoanGuarantee."Loan No");
            until LoanGuarantee.Next() = 0;
        end;
        exit(OutStandingGuarantee);
    end;

    procedure GetMemberSpecialLoanAmount(MemberNo: Code[20]; var TotalLoanBalance: Decimal; var SpecialShare: Decimal)
    var
        LoanProduct: Record "Product Factory";
        LoanApplication: Record "Loan Application";
    begin
        LoanProduct.Reset();
        LoanProduct.SetRange("Special Loan Multiplier", true);
        if LoanProduct.FindSet() then begin
            repeat
                LoanApplication.Reset();
                LoanApplication.SetFilter("Loan Balance", '>0');
                LoanApplication.SetRange("Member No.", MemberNo);
                LoanApplication.SetRange("Product Code", LoanProduct.Code);
                if LoanApplication.FindSet() then begin
                    repeat
                        LoanApplication.CalcFields("Loan Balance");
                        TotalLoanBalance += LoanApplication."Loan Balance";
                        SpecialShare += (LoanApplication."Loan Balance" / LoanProduct."Loan Multiplier");
                    until LoanApplication.Next() = 0;
                end;
            until LoanProduct.Next() = 0;
        end;
    end;

    procedure GetMemberDeposits(MemberNo: Code[20]) Deposits: Decimal
    var
        Vendor: Record Vendor;
        FormatedNo: code[20];
        AccountType: Record "Product Factory";
        Member: Record Members;
    begin
        Deposits := 0;
        if Member.Get(MemberNo) then begin
            Member.CalcFields("Total Deposits");
            Deposits := Member."Total Deposits";
        end;
        if Deposits < 0 then
            Deposits := 0;
        exit(Deposits);
    end;

    internal procedure AppraiseFosaSalary(MemberNo: Code[20]; ProductCode: Code[20]; LoanNo: Code[20]) Eligibility: Decimal
    var
        LProducts: Record "Product Factory";
        SDate, EndDate : Date;
        DateFilter: Text;
        CurrentDocNo, PrevDocNo : Code[20];
        SalaryCount: Integer;
        CheckOffLines, CheckOffLines2 : Record "Checkoff Lines";
        NetAmount, LowestAmount, BaseAmount : Decimal;
        FosaSalaries: Record "Loan FOSA Salaries";
    begin
        BaseAmount := 0;
        EndDate := Today;
        SDate := CalcDate('-3M', EndDate);
        SDate := DMY2Date(1, Date2DMY(SDate, 2), Date2DMY(SDate, 3));
        SalaryCount := 0;
        DateFilter := Format(SDate) + '..' + Format(EndDate);
        FosaSalaries.Reset();
        FosaSalaries.SetRange("Loan No", LoanNo);
        if FosaSalaries.FindSet() then
            FosaSalaries.DeleteAll();
        if LProducts.Get(ProductCode) then begin
            if LProducts."Salary Based" then begin
                SalaryCount := 0;
                CheckOffLines.Reset();
                CheckOffLines.SetRange("Member No", MemberNo);
                CheckOffLines.SetFilter("Posting Date", DateFilter);
                CheckOffLines.SetRange("Upload Type", CheckOffLines."Upload Type"::Salary);
                CheckOffLines.SetRange(Posted, true);
                if CheckOffLines.FindSet() then begin
                    PrevDocNo := 'PREV';
                    repeat
                        CurrentDocNo := CheckOffLines."Document No";
                        if CurrentDocNo <> PrevDocNo then begin
                            SalaryCount += 1;
                            PrevDocNo := CurrentDocNo;
                            CheckOffLines2.Reset();
                            CheckOffLines2.CopyFilters(CheckOffLines);
                            CheckOffLines2.SetRange("Document No", CurrentDocNo);
                            if CheckOffLines2.FindSet() then begin
                                CheckOffLines2.CalcFields("Net Amount", "Posting Date", "Amount Earned", Recoveries);
                                NetAmount := -1 * CheckOffLines2."Net Amount";
                                if ((LowestAmount = 0) OR (NetAmount < LowestAmount)) then
                                    LowestAmount := NetAmount;
                                BaseAmount += NetAmount;
                                FosaSalaries.Init();
                                FosaSalaries."Loan No" := LoanNo;
                                FosaSalaries."Posting Date" := CheckOffLines2."Posting Date";
                                FosaSalaries."Document No" := CurrentDocNo;
                                FosaSalaries."Amount Earned" := -1 * CheckOffLines2."Amount Earned";
                                FosaSalaries.Recoveries := CheckOffLines2.Recoveries;
                                FosaSalaries."Net Salary" := -1 * CheckOffLines2."Net Amount";
                                FosaSalaries.Insert();
                            end;
                        end;
                    until CheckOffLines.Next() = 0;
                end;
                if ((LProducts."Min. Salary Count" <> 0) AND (SalaryCount < LProducts."Min. Salary Count")) then
                    Error('You must have processed at least %1 salaries between %2', LProducts."Min. Salary Count", DateFilter);
                case LProducts."Salary Appraisal Type" of
                    LProducts."Salary Appraisal Type"::"Average Net":
                        BaseAmount := BaseAmount / SalaryCount;
                    LProducts."Salary Appraisal Type"::"Lowest Net":
                        BaseAmount := LowestAmount;
                end;
                Eligibility := BaseAmount * LProducts."Salary %" * 0.01;
            end;
        end;
        exit(Eligibility);
    end;

    procedure GenerateLoanRepaymentSchedule(var LoanApplication: Record "Loan Application")
    var
        Window: Dialog;
        RepaymentSchedule: Record "Loan Schedule";
        LoanProducts: Record "Product Factory";
        EntryNo, i : Integer;
        InstallmentNo: Code[20];
        EndDate: Date;
        PrincipleBalance: Decimal;
        StartDate: date;
        PrincipleAmnt: Decimal;
        InterestBalance: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        ExpectedDate: date;
        TempEDate: Date;
        AnniversaryDay: Integer;
        NextMonth: Integer;
        Year: Integer;
    begin
        i := 1;
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", LoanApplication."Application No");
        if RepaymentSchedule.FindSet() then
            RepaymentSchedule.DeleteAll();
        Window.OPEN('Creating Schedule \#1## \#2##');
        LoanProducts.GET(LoanApplication."Product Code");
        if LoanApplication."Repayment Start Date" = 0D then
            LoanApplication."Repayment Start Date" := GetRepaymentStartDate(LoanApplication);
        LoanApplication.TESTFIELD("Repayment Start Date");
        LoanApplication."Repayment Start Date" := GetRepaymentStartDate(LoanApplication);
        LoanApplication.TESTFIELD(Installments);
        LoanApplication."Repayment End Date" := CalcDate(Format(LoanApplication.Installments) + 'M', LoanApplication."Repayment Start Date");
        LoanApplication.Modify();
        AnniversaryDay := Date2DMY(LoanApplication."Repayment Start Date", 1);
        RepaymentSchedule.RESET;
        IF RepaymentSchedule.FINDLAST THEN
            EntryNo := RepaymentSchedule."Entry No" + 1
        ELSE
            EntryNo := 1;
        PrincipleBalance := LoanApplication."Approved Amount";
        if PrincipleBalance = 0 then
            PrincipleBalance := LoanApplication."Applied Amount";
        EndDate := LoanApplication."Repayment End Date";
        StartDate := LoanApplication."Repayment Start Date";
        PrincipleAmnt := 0;
        PrincipleAmnt := PrincipleBalance;
        InterestBalance := 0;
        LBalance := PrincipleBalance;
        PrincipleAmnt := PrincipleBalance;
        NextMonth := 0;
        Year := 0;
        Window.Update(2, EndDate);
        REPEAT
            i += 1;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::Amortised THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    TotalMRepay := ROUND((LoanApplication."Interest Rate" / 12 / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 12 / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>')
                ELSE
                    TotalMRepay := ROUND((LoanApplication."Interest Rate" / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>');
                LInterest := LBalance / 100 / 12 * LoanApplication."Interest Rate";
                LPrincipal := TotalMRepay - LInterest;
            END;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Straight Line" THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                LPrincipal := PrincipleAmnt / LoanApplication."Installments";
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    LInterest := (LoanApplication."Interest Rate" / 12 / 100) * PrincipleAmnt
                ELSE
                    LInterest := (LoanApplication."Interest Rate" / 100) * PrincipleAmnt;
                LInterest := LInterest;
            END;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Reducing Balance" THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                LPrincipal := PrincipleAmnt / LoanApplication."Installments";
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    LInterest := (LoanApplication."Interest Rate" / 12 / 100) * LBalance
                ELSE
                    LInterest := (LoanApplication."Interest Rate" / 100) * LBalance;
                LInterest := LInterest;
            END;
            LBalance := LBalance - LPrincipal;
            ExpectedDate := StartDate;
            InstallmentNo := GetDocumentNo(StartDate);
            RepaymentSchedule.INIT;
            RepaymentSchedule."Entry No" := EntryNo;
            EntryNo += 1;
            RepaymentSchedule."Document No." := InstallmentNo;
            RepaymentSchedule."Expected Date" := StartDate;
            RepaymentSchedule.Description := 'Monthly Installment';
            RepaymentSchedule."Principle Repayment" := LPrincipal;
            RepaymentSchedule."Interest Repayment" := LInterest;
            RepaymentSchedule."Monthly Repayment" := LPrincipal + LInterest;
            RepaymentSchedule."Running Balance" := LBalance;
            RepaymentSchedule."Loan No." := LoanApplication."Application No";
            RepaymentSchedule.INSERT;
            Window.UPDATE(1, InstallmentNo);
            StartDate := CalcDate('1M', StartDate);
            IF StartDate > EndDate THEN BEGIN
                StartDate := EndDate;
            END;
        UNTIL i > LoanApplication.Installments;
        Window.CLOSE;
    end;

    procedure GenerateOnlineLoanRepaymentSchedule(var LoanApplication: Record "Online Loan Application")
    var
        Window: Dialog;
        RepaymentSchedule: Record "Loan Schedule";
        LoanProducts: Record "Product Factory";
        EntryNo, i : Integer;
        InstallmentNo: Code[20];
        EndDate: Date;
        PrincipleBalance: Decimal;
        StartDate: date;
        PrincipleAmnt: Decimal;
        InterestBalance: Decimal;
        LBalance, RunningBalance : Decimal;
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        ExpectedDate: date;
        TempEDate: Date;
        AnniversaryDay: Integer;
        NextMonth: Integer;
        Year: Integer;
    begin
        i := 1;
        RepaymentSchedule.Reset();
        RepaymentSchedule.SetRange("Loan No.", LoanApplication."Application No");
        if RepaymentSchedule.FindSet() then
            RepaymentSchedule.DeleteAll();
        Window.OPEN('Creating Schedule \#1## \#2##');
        LoanProducts.GET(LoanApplication."Product Code");
        LoanApplication.TESTFIELD("Repayment Start Date");
        LoanApplication."Repayment Start Date" := GetRepaymentOnlineStartDate(LoanApplication);
        LoanApplication.TESTFIELD(Installments);
        LoanApplication."Repayment End Date" := CalcDate(Format(LoanApplication.Installments) + 'M', LoanApplication."Repayment Start Date");
        LoanApplication.Modify();
        AnniversaryDay := Date2DMY(LoanApplication."Repayment Start Date", 1);
        RepaymentSchedule.RESET;
        IF RepaymentSchedule.FINDLAST THEN
            EntryNo := RepaymentSchedule."Entry No" + 1
        ELSE
            EntryNo := 1;
        PrincipleBalance := LoanApplication."Approved Amount";
        if PrincipleBalance = 0 then
            PrincipleBalance := LoanApplication."Applied Amount";
        EndDate := LoanApplication."Repayment End Date";
        StartDate := LoanApplication."Repayment Start Date";
        PrincipleAmnt := 0;
        PrincipleAmnt := PrincipleBalance;
        InterestBalance := 0;
        LBalance := PrincipleBalance;
        PrincipleAmnt := PrincipleBalance;
        RunningBalance := LBalance;
        NextMonth := 0;
        Year := 0;
        Window.Update(2, EndDate);
        REPEAT
            i += 1;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::Amortised THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    TotalMRepay := ROUND((LoanApplication."Interest Rate" / 12 / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 12 / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>')
                ELSE
                    TotalMRepay := ROUND((LoanApplication."Interest Rate" / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>');
                LInterest := LBalance / 100 / 12 * LoanApplication."Interest Rate";
                LPrincipal := TotalMRepay - LInterest;
            END;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Straight Line" THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                LPrincipal := PrincipleAmnt / LoanApplication."Installments";
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    LInterest := (LoanApplication."Interest Rate" / 12 / 100) * PrincipleAmnt
                ELSE
                    LInterest := (LoanApplication."Interest Rate" / 100) * PrincipleAmnt;
                LInterest := LInterest;
            END;
            IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Reducing Balance" THEN BEGIN
                LoanApplication.TESTFIELD("Installments");
                LPrincipal := PrincipleAmnt / LoanApplication."Installments";
                IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                    LInterest := (LoanApplication."Interest Rate" / 12 / 100) * LBalance
                ELSE
                    LInterest := (LoanApplication."Interest Rate" / 100) * LBalance;
                LInterest := LInterest;
            END;
            RunningBalance -= LPrincipal;
            ExpectedDate := StartDate;
            InstallmentNo := GetDocumentNo(StartDate);
            RepaymentSchedule.INIT;
            RepaymentSchedule."Entry No" := EntryNo;
            EntryNo += 1;
            RepaymentSchedule."Document No." := InstallmentNo;
            RepaymentSchedule."Expected Date" := StartDate;
            RepaymentSchedule.Description := 'Monthly Installment';
            RepaymentSchedule."Principle Repayment" := LPrincipal;
            RepaymentSchedule."Interest Repayment" := LInterest;
            RepaymentSchedule."Monthly Repayment" := LPrincipal + LInterest;
            RepaymentSchedule."Running Balance" := RunningBalance;
            RepaymentSchedule."Loan No." := LoanApplication."Application No";
            RepaymentSchedule.INSERT;
            LBalance := LBalance - LPrincipal;
            Window.UPDATE(1, InstallmentNo);
            StartDate := CalcDate('1M', StartDate);
            IF StartDate > EndDate THEN BEGIN
                StartDate := EndDate;
            END;
        UNTIL i > LoanApplication.Installments;
        Window.CLOSE;

    end;

    procedure GetDocumentNo(ParseDate: Date) DocumentNo: Code[20]
    begin
        case Date2DMY(ParseDate, 2) of
            1:
                DocumentNo := 'JAN';
            2:
                DocumentNo := 'FEB';
            3:
                DocumentNo := 'MAR';
            4:
                DocumentNo := 'APR';
            5:
                DocumentNo := 'MAY';
            6:
                DocumentNo := 'JUN';
            7:
                DocumentNo := 'JUL';
            8:
                DocumentNo := 'AUG';
            9:
                DocumentNo := 'SEP';
            10:
                DocumentNo := 'OCT';
            11:
                DocumentNo := 'NOV';
            12:
                DocumentNo := 'DEC';
        end;
        DocumentNo += ('-' + Format(Date2DMY(ParseDate, 3)));
        exit(DocumentNo);
    end;

    procedure CreateLoanAccounts(var LoanApplication: Record "Loan Application") AccountNo: Code[20]
    var
        Vendor: Record Vendor;
        LoanProduct: Record "Product Factory";
        AccType: Record "Product Factory";
    begin
        LoanProduct.get(LoanApplication."Product Code");
        LoanProduct.TestField("Posting Group");
        AccountNo := LoanProduct.Prefix + LoanApplication."Member No.";
        if not Vendor.get(AccountNo) then begin
            Vendor.Init();
            Vendor."No." := AccountNo;
            Vendor.Name := UpperCase(LoanProduct.Name);
            Vendor."Vendor Posting Group" := LoanProduct."Posting Group";
            Vendor."Search Name" := UpperCase(LoanApplication."Member Name");
            Vendor."Account Type" := Vendor."Account Type"::Loan;
            Vendor."Member No." := LoanApplication."Member No.";
            Vendor."Account Class" := Vendor."Account Class"::Loan;
            Vendor.Insert();
        end;
        exit(AccountNo);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforePostLoan(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterPostLoan(Var LoanApplication: Record "Loan Application")
    begin
    end;

    local procedure CreateUnclearedEffec(LoanNo: Code[20])
    var
        UnclearedEffect: Record "Uncleared Effects";
        EntryNo: Integer;
        LoanApplication: Record "Loan Application";
        DetailedVendorLedger: Record "Detailed Vendor Ledg. Entry";
        NetAmount: Decimal;
    begin
        if LoanApplication.get(LoanNo) then begin
            if LoanApplication."Pay to Account No" <> '' then begin
                DetailedVendorLedger.Reset();
                DetailedVendorLedger.SetRange("Vendor No.", LoanApplication."Disbursement Account");
                DetailedVendorLedger.SetRange("Document No.", LoanNo);
                if DetailedVendorLedger.FindSet() then begin
                    DetailedVendorLedger.CalcSums(Amount);
                    NetAmount := DetailedVendorLedger.Amount;
                end;
                EntryNo := 1;
                UnclearedEffect.reset;
                if UnclearedEffect.FindLast() then
                    EntryNo := UnclearedEffect."Entry No" + 1;
                UnclearedEffect.Init();
                UnclearedEffect."Entry No" := EntryNo;
                UnclearedEffect."Document No" := LoanNo;
                UnclearedEffect."Member Name" := LoanApplication."Member Name";
                UnclearedEffect.Amount := -1 * NetAmount;
                UnclearedEffect."Member No" := LoanApplication."Member No.";
                UnclearedEffect."Account No" := LoanApplication."Disbursement Account";
                UnclearedEffect.Insert();
            end
        end;
    end;

    procedure PostBatch(var BatchNo: Code[20])
    var
        LoanBatchLines: Record "Loan Batch Lines";
        Window: Dialog;
        LoanApplication: Record "Loan Application";
        LoanBatch: Record "Loan Batch Header";
    begin
        LoanBatchLines.Reset();
        LoanBatchLines.SetRange("Batch No", BatchNo);
        LoanBatchLines.SetRange(Posted, false);
        if LoanBatchLines.FindSet() then begin
            Window.Open('Posting \#1##');
            repeat
                Window.Update(1, LoanBatchLines."Loan No");
                if LoanApplication.Get(LoanBatchLines."Loan No") then begin
                    DisburseLoan(LoanApplication);
                    LoanBatchLines.Posted := true;
                    LoanBatchLines.Modify();
                    Commit();
                end;
            until LoanBatchLines.Next() = 0;
            Window.Close();
        end;
        if LoanBatch.get(BatchNo) then begin
            LoanBatch.Posted := true;
            LoanBatch."Posted By" := UserId;
            LoanBatch."Posted On" := CurrentDateTime;
            LoanBatch.Modify(true);
        end;
    end;

    procedure DisburseLoan(var LoanApplication: Record "Loan Application")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PostingDate: date;
        LoanCharges: Record "Loan Charges";
        PostingAmount, RemainingAmount : Decimal;
        GLEntry: Record "G/L Entry";
        SrcCode, RsnCode, JournalBatch, JournalTemplate, AccountNo, ReasonCode, SourceCode, MemberNo, DocumentNo, ExternalDocumentNo : Code[20];
        LoanRecoveries: Record "Loan Recoveries";
        JournalManagement: Codeunit "Journal Management";
        PostingDescription: Text[50];
        ExternalRecSetup: Record "External Recoveries Setup";
        LoanApp: Record "Loan Application";
        LoanProduct: Record "Product Factory";
        BaseAmount, PrincipalBalance, InterestBalance, PenaltyBalance, PenaltyPaid, InterestPaid, PrincipalPaid : Decimal;
        SaccoSetup: Record "Sacco Setup";
        LoanGuarantee: Record "Loan Guarantees";
        Guarantors: Integer;
    begin
        DocumentNo := LoanApplication."Application No";
        SaccoSetup.Get();
        GLEntry.Reset();
        GLEntry.SetRange("Document No.", DocumentNo);
        if GLEntry.FindFirst() then begin
            LoanApplication.Status := LoanApplication.Status::Disbursed;
            LoanApplication.Posted := True;
            LoanApplication."Loan Account" := CreateLoanAccounts(LoanApplication);
            LoanApplication."Appraisal Commited" := true;
            LoanApplication.Modify(true);
        end else begin
            OnBeforePostLoan(LoanApplication);
            JournalBatch := 'LOANS';
            JournalTemplate := 'SACCO';
            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Loan Disbursements Batch');
            ReasonCode := LoanApplication."Application No";
            SourceCode := LoanApplication."Product Code";
            MemberNo := LoanApplication."Member No.";
            LoanApplication."Loan Account" := CreateLoanAccounts(LoanApplication);
            RemainingAmount := 0;
            RemainingAmount := LoanApplication."Approved Amount";
            AccountNo := '';
            ExternalDocumentNo := LoanApplication."Cheque No.";
            AccountNo := LoanApplication."Loan Account";
            PostingDate := LoanApplication."Posting Date";
            PostingDescription := 'Loan Disbursal';
            PostingAmount := 0;
            PostingAmount := LoanApplication."Applied Amount";
            AccountNo := LoanApplication."Loan Account";
            //Debit Loan
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Loan Disbursal", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            AccountNo := '';
            AccountNo := LoanApplication."Disbursement Account";
            PostingAmount := 0;
            PostingAmount := LoanApplication."Approved Amount";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Loan Disbursal", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", DocumentNo);
            if LoanRecoveries.FindSet() then begin
                repeat
                    case LoanRecoveries."Recovery Type" of
                        LoanRecoveries."Recovery Type"::Account:
                            begin
                                PostingDescription := LoanRecoveries."Recovery Description";
                                AccountNo := '';
                                AccountNo := LoanRecoveries."Recovery Code";
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries.Amount;
                                RemainingAmount -= PostingAmount;
                                PostingDescription := 'Recovery for ' + AccountNo;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                RemainingAmount -= PostingAmount;
                                AccountNo := '';
                                AccountNo := LoanRecoveries."Commission Account";
                                PostingDescription := '';
                                PostingDescription := 'Commision On Recovery ' + LoanRecoveries."Recovery Code";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                AccountNo := '';
                                AccountNo := LoanApplication."Disbursement Account";
                                PostingDescription := '';
                                PostingDescription := 'Commision On ' + LoanRecoveries."Recovery Description";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries.Amount;
                                PostingDescription := 'Recovery for ' + AccountNo;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        LoanRecoveries."Recovery Type"::External:
                            begin
                                PostingDescription := LoanRecoveries."Recovery Description";
                                AccountNo := '';
                                ExternalRecSetup.Get(LoanRecoveries."Recovery Code");
                                AccountNo := ExternalRecSetup."Post To Account No";
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries.Amount;
                                RemainingAmount -= PostingAmount;
                                PostingDescription := LoanRecoveries."Recovery Description";
                                IF ExternalRecSetup."Post To Account Type" = ExternalRecSetup."Post To Account Type"::"Payable Account" then begin
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end else begin
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end;
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                RemainingAmount -= PostingAmount;
                                AccountNo := '';
                                AccountNo := LoanRecoveries."Commission Account";
                                PostingDescription := '';
                                PostingDescription := 'Commision On ' + LoanRecoveries."Recovery Description";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                AccountNo := '';
                                AccountNo := LoanApplication."Disbursement Account";
                                PostingDescription := '';
                                PostingDescription := 'Commision On ' + LoanRecoveries."Recovery Description";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingDescription := LoanRecoveries."Recovery Description";
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries.Amount;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        LoanRecoveries."Recovery Type"::Loan:
                            begin
                                BaseAmount := 0;
                                PrincipalBalance := 0;
                                InterestBalance := 0;
                                PenaltyBalance := 0;
                                BaseAmount := LoanRecoveries.Amount;
                                SrcCode := '';
                                RsnCode := '';
                                LoanApp.Get(LoanRecoveries."Recovery Code");
                                LoanApp.CalcFields("Principle Balance", "Penalty Balance", "Interest Balance");
                                LoanProduct.get(LoanApp."Product Code");
                                PrincipalBalance := LoanApp."Principle Balance";
                                PenaltyBalance := LoanApp."Penalty Balance";
                                InterestBalance := LoanApp."Interest Balance" + LoanRecoveries."Prorated Interest";
                                if InterestBalance < 0 then
                                    InterestBalance := 0;
                                if PenaltyBalance < 0 then
                                    PenaltyBalance := 0;
                                if PrincipalBalance < 0 then
                                    PrincipalBalance := 0;

                                if BaseAmount > PenaltyBalance then begin
                                    PenaltyPaid := PenaltyBalance;
                                    BaseAmount -= PenaltyPaid;
                                end else begin
                                    PenaltyPaid := BaseAmount;
                                    BaseAmount := 0;
                                end;
                                if BaseAmount > InterestBalance then begin
                                    InterestPaid := InterestBalance;
                                    BaseAmount -= InterestBalance;
                                end else begin
                                    InterestPaid := BaseAmount;
                                    BaseAmount := 0;
                                end;
                                if BaseAmount > PrincipalBalance then begin
                                    PrincipalPaid := PrincipalBalance;
                                end else begin
                                    PrincipalPaid := BaseAmount;
                                end;
                                SrcCode := LoanApp."Product Code";
                                RsnCode := LoanApp."Application No";
                                PostingDescription := LoanRecoveries."Recovery Description";
                                AccountNo := '';
                                AccountNo := LoanApp."Loan Account";
                                PostingAmount := 0;
                                PostingAmount := PenaltyPaid;
                                PostingDescription := 'Penalty Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Penalty Paid", LineNo, SrcCode,
                                    RsnCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                //Prorated Interest
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Prorated Interest";
                                PostingDescription := 'Prorated Interest';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                    RsnCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                //Prorated Interest
                                PostingAmount := 0;
                                PostingAmount := InterestPaid;
                                PostingDescription := 'Interest Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                    RsnCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := PrincipalPaid;
                                PostingDescription := 'Principal Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SrcCode,
                                    RsnCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                SaccoSetup.Get();
                                if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                    AccountNo := LoanProduct."Penalty Paid Account";
                                    PostingAmount := 0;
                                    PostingAmount := PenaltyPaid;
                                    PostingDescription := 'Penalty Paid';
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Penalty Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    AccountNo := '';
                                    AccountNo := LoanProduct."Penalty Due Account";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Penalty Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    PostingAmount := 0;
                                    PostingAmount := InterestPaid;
                                    PostingDescription := 'Interest Paid';
                                    AccountNo := '';
                                    AccountNo := LoanProduct."Interest Paid Account";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    AccountNo := '';
                                    AccountNo := LoanProduct."Interest Due Account";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    //Prorated Interest
                                    PostingAmount := 0;
                                    PostingAmount := LoanRecoveries."Prorated Interest";
                                    PostingDescription := 'Prorated Interest';
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end else begin
                                    //Prorated Interest
                                    PostingDescription := 'Prorated Interest';
                                    PostingAmount := 0;
                                    PostingAmount := LoanRecoveries."Prorated Interest";
                                    AccountNo := '';
                                    AccountNo := LoanProduct."Interest Paid Account";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SrcCode,
                                        RsnCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end;
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                RemainingAmount -= (PostingAmount + PrincipalPaid + PenaltyPaid + InterestPaid);
                                AccountNo := '';
                                AccountNo := LoanRecoveries."Commission Account";
                                PostingDescription := '';
                                PostingDescription := 'Commision On ' + LoanRecoveries."Recovery Description";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries."Commission Amount";
                                AccountNo := '';
                                AccountNo := LoanApplication."Disbursement Account";
                                PostingDescription := '';
                                PostingDescription := LoanRecoveries."Recovery Description";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                PostingAmount := 0;
                                PostingAmount := LoanRecoveries.Amount;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                    ReasonCode, ExternalDocumentNo,
                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                    end;
                until LoanRecoveries.Next() = 0;
            end;
            if LoanApplication."Insurance Amount" > 0 then begin
                LoanProduct.Get(LoanApplication."Product Code");
                PostingDescription := 'RMF Premium';
                PostingAmount := LoanApplication."Insurance Amount";
                AccountNo := LoanApplication."Disbursement Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                AccountNo := '';
                AccountNo := LoanProduct."Insurance Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * ((100 - LoanProduct."Insurance Income %") * PostingAmount * 0.01),
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                AccountNo := '';
                AccountNo := LoanProduct."Insurance Income Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * ((LoanProduct."Insurance Income %") * PostingAmount * 0.01),
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            end;
            LoanProduct.Get(LoanApplication."Product Code");
            if ((LoanApplication."Prorated Days" > 0) and (LoanProduct."Salary Based" = false)) then begin
                LoanProduct.TestField("Interest Paid Account");
                PostingDescription := 'Interest Recovered';
                PostingAmount := LoanApplication."Approved Amount" * LoanApplication."Interest Rate" * 0.01;
                PostingAmount := PostingAmount * (LoanApplication."Prorated Days" / 365);
                AccountNo := LoanApplication."Disbursement Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                AccountNo := LoanProduct."Interest Paid Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            end;
            if LoanProduct."Charge UpFront Interest" then begin
                LoanProduct.TestField("Interest Paid Account");
                LoanApplication.CalcFields("Interest Repayment");
                PostingAmount := LoanApplication."Interest Repayment";
                PostingDescription := 'Interest Recovered';
                AccountNo := LoanApplication."Disbursement Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                AccountNo := LoanProduct."Interest Paid Account";
                LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", LineNo, SourceCode,
                                        ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            end;
            if SaccoSetup."Guarantor Notice Charge" > 0 then begin
                LoanGuarantee.Reset();
                LoanGuarantee.SetRange("Loan No", LoanApplication."Application No");
                if LoanGuarantee.FindSet() then begin
                    Guarantors := LoanGuarantee.Count;
                    AccountNo := '';
                    AccountNo := SaccoSetup."Guarantor Notice Inc. Acc.";
                    PostingDescription := 'Guarantor Notice Charges ' + Format(Guarantors) + ' guarantors';
                    PostingAmount := 0;
                    PostingAmount := Guarantors * SaccoSetup."Guarantor Notice Charge";
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Loan Disbursal", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                    AccountNo := '';
                    AccountNo := LoanApplication."Disbursement Account";
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Loan Disbursal", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                end;
            end;
            LineNo := JournalManagement.AddCharges(
                LoanProduct."Loan Charges", LoanApplication."Disbursement Account", LoanApplication."Approved Amount", LineNo, DocumentNo, MemberNo,
                SourceCode, ReasonCode, ExternalDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);

            /*LoanApplication.Status := LoanApplication.Status::Disbursed;
            LoanApplication.Posted := True;
            LoanApplication.Modify();
            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
            CreateUnclearedEffec(DocumentNo);*/
            OnAfterPostLoan(LoanApplication);
        end;
        OnAfterPostLoan(LoanApplication);
    end;

    procedure PostCollateralRegistration(CollateralApplication: Record "Collateral Application")
    var
        CollateralRegister: Record "Collateral Register";
    begin
        if not CollateralRegister.get(CollateralApplication."Document No") then begin
            CollateralRegister.Init();
            CollateralRegister."Document No" := CollateralApplication."Document No";
            CollateralRegister."Member No" := CollateralApplication."Member No";
            CollateralRegister."Member Name" := CollateralApplication."Member Name";
            CollateralRegister."Collateral Type" := CollateralApplication."Collateral Type";
            CollateralRegister."Collateral Description" := CollateralApplication."Collateral Description";
            CollateralRegister."Caollateral Value" := CollateralApplication."Collateral Value";
            CollateralRegister.Guarantee := CollateralApplication.Guarantee;
            CollateralRegister."Registration No" := CollateralApplication."Registration No";
            CollateralApplication."Serial No" := CollateralApplication."Serial No";
            CollateralRegister."Posting Date" := CollateralApplication."Posting Date";
            CollateralRegister."Security Type" := CollateralApplication."Security Type";
            CollateralRegister."Owner ID No" := CollateralApplication."Owner ID No";
            CollateralRegister."Owner Name" := CollateralApplication."Owner Name";
            CollateralRegister."Owner Phone No." := CollateralApplication."Owner Phone No.";
            CollateralRegister."Insurance Expiry Date" := CollateralApplication."Insurance Expiry Date";
            CollateralRegister."Linking Date" := CollateralApplication."Linking Date";
            CollateralRegister."Car Track Due Date" := CollateralApplication."Car Track Due Date";
            CollateralRegister.Insert();
            CollateralApplication.Posted := true;
            CollateralApplication.Modify();
        end else begin
            CollateralApplication.Posted := true;
            CollateralApplication.Modify();
        end;
        OnAfterAcceptCollateral(CollateralApplication);
    end;

    procedure AccrueLoanInterest(LoanApplication: Record "Loan Application")
    var
        AccrualEntries: Record "Loan Interest Accrual";
        LineNo: Integer;
        MonthlyInstallment: Decimal;
        Days: Integer;
        ScheduleStartDate: Date;
        ScheduleEndDate: Date;
        StartDate: Date;
        EndDate: Date;
        LoanSchedule: Record "Loan Schedule";
        AnniversaryDay: Integer;
        DateRec: Record Date;
    begin
        StartDate := 0D;
        EndDate := 0D;
        ScheduleStartDate := 0D;
        ScheduleEndDate := 0D;
        LineNo := 1;
        AnniversaryDay := Date2DMY(LoanApplication."Repayment Start Date", 1);
        LoanApplication.Modify();
        if AnniversaryDay = 31 then begin
            if Date2DMY(Today, 2) in [4, 6, 9, 11] then
                StartDate := DMY2Date(30, Date2DMY(Today, 2), Date2DMY(Today, 3))
            else begin
                if Date2DMY(Today, 2) = 2 then begin
                    if Date2DMY(Today, 3) MOD 4 = 0 then
                        StartDate := DMY2Date(29, Date2DMY(Today, 2), Date2DMY(Today, 3))
                    else
                        StartDate := DMY2Date(28, Date2DMY(Today, 2), Date2DMY(Today, 3));
                end else
                    StartDate := DMY2Date(31, Date2DMY(Today, 2), Date2DMY(Today, 3));
            end;
        end else
            if AnniversaryDay = 30 then begin
                if Date2DMY(Today, 2) = 2 then begin
                    if Date2DMY(Today, 3) MOD 4 = 0 then
                        StartDate := DMY2Date(29, Date2DMY(Today, 2), Date2DMY(Today, 3))
                    else
                        StartDate := DMY2Date(28, Date2DMY(Today, 2), Date2DMY(Today, 3));
                end else
                    StartDate := DMY2Date(AnniversaryDay, Date2DMY(Today, 2), Date2DMY(Today, 3));
            end else
                if AnniversaryDay = 29 then begin
                    if Date2DMY(Today, 2) = 2 then begin
                        if Date2DMY(Today, 3) MOD 4 = 0 then
                            StartDate := DMY2Date(29, Date2DMY(Today, 2), Date2DMY(Today, 3))
                        else
                            StartDate := DMY2Date(28, Date2DMY(Today, 2), Date2DMY(Today, 3));
                    end else
                        StartDate := DMY2Date(AnniversaryDay, Date2DMY(Today, 2), Date2DMY(Today, 3));

                end else
                    StartDate := DMY2Date(AnniversaryDay, Date2DMY(Today, 2), Date2DMY(Today, 3));
        EndDate := StartDate;
        StartDate := CalcDate('-1M', StartDate);
        if StartDate < LoanApplication."Repayment Start Date" then
            StartDate := LoanApplication."Repayment Start Date";
        ScheduleStartDate := DMY2Date(1, Date2DMY(Today, 2), Date2DMY(Today, 3));
        if DateRec.get(DateRec."Period Type"::Month, ScheduleStartDate) then
            ScheduleEndDate := DateRec."Period End";
        Days := EndDate - StartDate;
        if Days = 0 then
            days := 31;
        LoanSchedule.Reset();
        LoanSchedule.SetRange("Loan No.", LoanApplication."Application No");
        LoanSchedule.SetRange("Expected Date", ScheduleStartDate, ScheduleEndDate);
        if LoanSchedule.FindFirst() then
            MonthlyInstallment := LoanSchedule."Interest Repayment";
        AccrualEntries.Reset();
        if AccrualEntries.FindLast() then
            LineNo := AccrualEntries."Entry No." + 1;
        repeat
            AccrualEntries.Reset();
            AccrualEntries.SetRange("Loan No.", LoanApplication."Application No");
            AccrualEntries.SetRange("Entry Date", StartDate);
            if AccrualEntries.IsEmpty then begin
                AccrualEntries.Init();
                AccrualEntries."Entry No." := LineNo;
                LineNo += 1;
                AccrualEntries."Loan No." := LoanApplication."Application No";
                AccrualEntries."Created By" := UserId;
                AccrualEntries."Created On" := CurrentDateTime;
                AccrualEntries.Description := 'Interest Accrual - ' + Format(StartDate);
                AccrualEntries."Entry Date" := StartDate;
                AccrualEntries."Entry Type" := AccrualEntries."Entry Type"::"Interest Accrual";
                AccrualEntries."Member Name" := LoanApplication."Member Name";
                AccrualEntries."Member No." := LoanApplication."Member No.";
                AccrualEntries.Amount := MonthlyInstallment / Days;
                AccrualEntries.Open := true;
                AccrualEntries.Insert();
            end;
            StartDate := CalcDate('1D', StartDate);
        until (StartDate > Today);
    end;

    procedure GetRepaymentStartDate(LoanApplication: Record "Loan Application") RepaymentStartDate: date
    var
        dayNo: integer;
        Mnth: integer;
        year: integer;
        VendorLedger: Record "Vendor Ledger Entry";
    begin
        if LoanApplication."Posting Date" = 0D then begin
            VendorLedger.Reset();
            VendorLedger.SetRange("Transaction Type", VendorLedger."Transaction Type"::"Loan Disbursal");
            VendorLedger.SetRange("Loan No.", LoanApplication."Application No");
            if VendorLedger.FindFirst() then
                LoanApplication."Posting Date" := VendorLedger."Posting Date";
        end;
        if LoanApplication."Posting Date" <> 0D then begin
            dayNo := Date2DMY(LoanApplication."Posting Date", 1);
            if dayNo < 5 then
                RepaymentStartDate := CalcDate('CM', LoanApplication."Posting Date")
            else
                RepaymentStartDate := CalcDate('CM+1M', LoanApplication."Posting Date")
        end;
        exit(RepaymentStartDate);
    end;

    procedure GetRepaymentOnlineStartDate(LoanApplication: Record "Online Loan Application") RepaymentStartDate: date
    var
        dayNo: integer;
        Mnth: integer;
        year: integer;
    begin
        if LoanApplication."Posting Date" <> 0D then begin
            dayNo := Date2DMY(LoanApplication."Posting Date", 1);
            if dayNo < 5 then
                RepaymentStartDate := CalcDate('CM', LoanApplication."Posting Date")
            else
                RepaymentStartDate := CalcDate('CM+1M', LoanApplication."Posting Date")
        end;
        exit(RepaymentStartDate);
    end;

    procedure CalculatePenalty(LoanApplication: Record "Loan Application"; DateAt: Date) Penalty: Decimal
    var
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        Schedule: Record "Loan Schedule";
        InstallmentDue: Decimal;
        InstallmentPaid: Decimal;
        DefaultedInstallment: Decimal;
        Product: Record "Product Factory";
        AnnivarsaryDay: Integer;
        AnnivarsadyDate: date;
    begin
        Penalty := 0;
        InstallmentDue := 0;
        InstallmentPaid := 0;
        AnnivarsaryDay := 0;
        DefaultedInstallment := 0;
        AnnivarsadyDate := 0D;
        AnnivarsaryDay := Date2DMY(CalcDate(Product."Penalty Grace Period", LoanApplication."Repayment Start Date"), 1);
        if AnnivarsaryDay > 28 then begin
            if Date2DMY(DateAt, 2) in [1, 3, 5, 7, 8, 10, 12] then
                AnnivarsadyDate := DMY2Date(AnnivarsaryDay, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3))
            else
                if Date2DMY(DateAt, 2) in [4, 6, 9, 11] then begin
                    if AnnivarsaryDay > 30 then
                        AnnivarsadyDate := DMY2Date(30, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3))
                    else
                        AnnivarsadyDate := DMY2Date(AnnivarsaryDay, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3))
                end else begin
                    if Date2DMY(DateAt, 3) mod 4 = 0 then
                        AnnivarsadyDate := DMY2Date(29, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3))
                    else
                        AnnivarsadyDate := DMY2Date(28, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3));
                end;
        end else
            AnnivarsadyDate := DMY2Date(AnnivarsaryDay, Date2DMY(DateAt, 2), Date2DMY(DateAt, 3));
        if AnnivarsadyDate >= Today then
            exit(0);
        Schedule.Reset();
        Schedule.SetRange("Loan No.", LoanApplication."Application No");
        Schedule.SetRange("Document No.", GetDocumentNo(DateAt));
        if Schedule.FindFirst() then begin
            InstallmentDue := Schedule."Principle Repayment";
        end;
        DetailedVendorLedgerEntry.Reset();
        DetailedVendorLedgerEntry.SetRange("Vendor No.", LoanApplication."Loan Account");
        DetailedVendorLedgerEntry.SetRange("Loan No.", LoanApplication."Application No");
        DetailedVendorLedgerEntry.SetRange("Transaction Type", DetailedVendorLedgerEntry."Transaction Type"::"Interest Due");
        if DetailedVendorLedgerEntry.FindSet() then begin
            DetailedVendorLedgerEntry.CalcSums(Amount);
            InstallmentDue += DetailedVendorLedgerEntry.Amount;
        end;
        DetailedVendorLedgerEntry.Reset();
        DetailedVendorLedgerEntry.SetRange("Vendor No.", LoanApplication."Loan Account");
        DetailedVendorLedgerEntry.SetRange("Loan No.", LoanApplication."Application No");
        DetailedVendorLedgerEntry.SetFilter("Transaction Type", '%1|%2', DetailedVendorLedgerEntry."Transaction Type"::"Interest Paid", DetailedVendorLedgerEntry."Transaction Type"::"Principle Paid");
        if DetailedVendorLedgerEntry.FindSet() then begin
            DetailedVendorLedgerEntry.CalcSums(Amount);
            InstallmentPaid += DetailedVendorLedgerEntry.Amount;
        end;
        DefaultedInstallment := InstallmentDue + InstallmentPaid;
        if DefaultedInstallment < 0 then
            exit(0);
        Penalty := DefaultedInstallment * Product."Penalty Rate" * 0.01;
        exit(Penalty);
    end;

    procedure PostLoanRepayments(CollectionsAccount: Record Vendor; PaymentDate: Date)
    var
        DateFilter: Text[200];
        BaseAmount: Decimal;
        LoanApplication: Record "Loan Application";
        ProductType: Record "Product Factory";
        PostingAmount: Decimal;
        JournalBatch: code[20];
        JournalTemplate: code[20];
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        PostingDate: date;
        DocumentNo: code[20];
        DisbursementAccount: code[20];
        LoanCharges: Record "Loan Charges";
        RemainingAmount: Decimal;
        LoanSecurities: Record "Loan Securities";
        CollateralRegister: Record "Collateral Register";
        GLEntry: Record "G/L Entry";
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        NotificationMgt: Codeunit "Notifications Management";
        PhoneNo: Text[250];
        SMS: Text[250];
        Members: Record Members;
        Amnt: Decimal;
        CompanyInformation: Record "Company Information";
        ColAccount: Record Vendor;
    begin
        DateFilter := '..' + Format(PaymentDate);
        BaseAmount := 0;
        if Members.Get(CollectionsAccount."Member No.") then begin
            JournalBatch := 'REPAY';
            JournalTemplate := 'Payments';
            PostingDate := PaymentDate;
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
            ColAccount.Reset();
            ColAccount.SetRange("No.", CollectionsAccount."No.");
            ColAccount.SetFilter("Date Filter", DateFilter);
            if ColAccount.FindFirst() then begin
                ColAccount.CalcFields("Net Change", Balance);
                BaseAmount := ColAccount."Net Change";
            end;

            if BaseAmount < 0 then
                BaseAmount := 0;
            Amnt := 0;
            Amnt := BaseAmount;
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", CollectionsAccount."Member No.");
            LoanApplication.SetRange(Posted, true);
            LoanApplication.SetFilter("Date Filter", DateFilter);
            if LoanApplication.Find('-') then begin
                SaccoSetup.Get();
                repeat
                    LoanApplication.CalcFields("Loan Balance");
                    if LoanApplication."Loan Balance" = 0 then begin
                        LoanApplication.Closed := true;
                        LoanApplication.Modify();
                    end else begin
                        if ProductType.Get(LoanApplication."Product Code") then begin
                            DocumentNo := NoSeries.GetNextNo(SaccoSetup."Loan Repayment Nos.", Today, true);
                            Dim1 := LoanApplication."Global Dimension 1 Code";
                            Dim2 := LoanApplication."Global Dimension 2 Code";
                            LoanApplication.CalcFields("Penalty Balance", "Interest Balance", "Principle Balance");
                            if LoanApplication."Penalty Balance" > 0 then begin
                                PostingAmount := LoanApplication."Penalty Balance";
                                if PostingAmount > BaseAmount then begin
                                    PostingAmount := BaseAmount;
                                    BaseAmount := 0;
                                end else begin
                                    BaseAmount -= PostingAmount;
                                end;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", LoanApplication."Loan Account");
                                GenJournalLine."Credit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Credit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                                GenJournalLine."Message to Recipient" := 'Penalty Paid ';
                                GenJournalLine.Description := 'Penalty Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", CollectionsAccount."No.");
                                GenJournalLine."Debit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Debit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                                GenJournalLine."Message to Recipient" := 'Penalty Paid ';
                                GenJournalLine.Description := 'Penalty Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine.VALIDATE("Account No.", ProductType."Penalty Paid Account");
                                GenJournalLine."Credit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Credit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Penalty Paid";
                                GenJournalLine."Message to Recipient" := 'Penalty Paid ';
                                GenJournalLine.Description := 'Penalty Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine.validate("Bal. Account No.", ProductType."Penalty Due Account");
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                            end;
                            if LoanApplication."Interest Balance" > 0 then begin
                                PostingAmount := LoanApplication."Interest Balance";
                                if PostingAmount > BaseAmount then begin
                                    PostingAmount := BaseAmount;
                                    BaseAmount := 0;
                                end else begin
                                    BaseAmount -= PostingAmount;
                                end;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", LoanApplication."Loan Account");
                                GenJournalLine."Credit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Credit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                GenJournalLine."Message to Recipient" := 'Interest Paid ';
                                GenJournalLine.Description := 'Interest Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                //Debit Collections
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", CollectionsAccount."No.");
                                GenJournalLine."Debit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Debit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                GenJournalLine."Message to Recipient" := 'Interest Paid ';
                                GenJournalLine.Description := 'Interest Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                //Transfer to income
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                GenJournalLine.VALIDATE("Account No.", ProductType."Interest Paid Account");
                                GenJournalLine."Credit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Credit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Interest Paid";
                                GenJournalLine."Message to Recipient" := 'Interest Paid ';
                                GenJournalLine.Description := 'Interest Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                                GenJournalLine.validate("Bal. Account No.", ProductType."Interest Due Account");
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                            end;
                            if LoanApplication."Principle Balance" > 0 then begin
                                PostingAmount := LoanApplication."Principle Balance";
                                if PostingAmount > BaseAmount then begin
                                    PostingAmount := BaseAmount;
                                    BaseAmount := 0;
                                end else begin
                                    BaseAmount -= PostingAmount;
                                end;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", LoanApplication."Loan Account");
                                GenJournalLine."Credit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Credit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Principle Paid";
                                GenJournalLine."Message to Recipient" := 'Principal Paid ';
                                GenJournalLine.Description := 'Principal Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                                //Credit Loan
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := JournalTemplate;
                                GenJournalLine."Journal Batch Name" := JournalBatch;
                                GenJournalLine."Document No." := DocumentNo;
                                GenJournalLine."Line No." := LineNo;
                                GenJournalLine."Posting Date" := PostingDate;
                                LineNo += 1000;
                                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                                GenJournalLine.VALIDATE("Account No.", CollectionsAccount."No.");
                                GenJournalLine."Debit Amount" := ABS(PostingAmount);
                                GenJournalLine.VALIDATE("Debit Amount");
                                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Principle Paid";
                                GenJournalLine."Message to Recipient" := 'Principal Paid ';
                                GenJournalLine.Description := 'Principal Paid ';
                                GenJournalLine."Due Date" := LoanApplication."Repayment End Date";
                                GenJournalLine."Reason Code" := LoanApplication."Application No";
                                GenJournalLine."Source Code" := LoanApplication."Product Code";
                                GenJournalLine."External Document No." := LoanApplication."Member No.";
                                GenJournalLine."Loan No." := LoanApplication."Application No";
                                GenJournalLine."Member No." := LoanApplication."Member No.";
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                                /*GenJournalLine.ValidateShortcutDimCode(3,LoanApplication."Sector Code");
                                GenJournalLine.ValidateShortcutDimCode(4,LoanApplication."Subsector Code");
                                GenJournalLine.ValidateShortcutDimCode(5,LoanApplication."Sub-Subsector Code");*/
                                IF GenJournalLine.Amount <> 0 THEN
                                    GenJournalLine.INSERT;
                            end;
                        end;
                    end;
                until LoanApplication.Next() = 0;
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                if GenJournalLine.FindSet() then
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
                if Amnt > 0 then begin
                    CompanyInformation.get;
                    if Members.Get(LoanApplication."Member No.") then begin
                        if Members."Mobile Phone No." <> '' then begin
                            PhoneNo := Members."Mobile Phone No.";
                            SMS := 'Dear ' + Members."Full Name" + ' your Receipt of Ksh. ' + Format(Amnt) + ' has been successfully Received at ' + CompanyInformation.Name;
                            NotificationMgt.SendSms(PhoneNo, SMS);
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure PostCollateralCollection(Collection: record "Collateral Release")
    var
        CollateralRegister: Record "Collateral Register";
    begin
        if CollateralRegister.get(Collection.Collateral) then begin
            CollateralRegister.Status := CollateralRegister.Status::Collected;
            CollateralRegister.Modify();
            Collection.Posted := true;
            Collection.Modify();
        end;
    end;

    procedure PostLoanInterest(PDate: Date)
    var
        PostingDate, enddate : Date;
        LoanSchedule, LoanSchedule1 : Record "Loan Schedule";
        PostingAmount: Decimal;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DocumentNo, JournalBatch, JournalTemplate : code[20];
        LineNo: Integer;
        LoanProduct: Record "Product Factory";
        BalanceAtDate, InterestDue : Decimal;
        DateFilter, PostingDescription : Text[200];
        LoanApplication: Record "Loan Application";
        Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, SourceCode, ReasonCode, MemberNo, AccountNo : Code[20];
        JournalManagement: Codeunit "Journal Management";
        SaccoSetup: Record "Sacco Setup";
        Window: Dialog;
        Current, All : Integer;
    begin
        DateFilter := '..' + Format(PDate);
        LoanApplication.Reset();
        LoanApplication.SetFilter("Date Filter", DateFilter);
        LoanApplication.SetCurrentKey("Product Code");
        if LoanApplication.FindSet() then begin
            All := LoanApplication.Count;
            Current := 0;
            Window.Open('Billing \#1### \#2###\@3@@\Interest #4##');
            JournalBatch := 'INT-BILL';
            JournalTemplate := 'SACCO';
            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Loan Disbursements Batch');
            repeat
                InterestDue := 0;
                Current += 1;
                Window.Update(1, LoanApplication."Product Description");
                Window.Update(2, LoanApplication."Member Name");
                Window.Update(3, ((Current / all) * 10000) div 1);
                LoanApplication.CalcFields("Net Change-Principal");
                BalanceAtDate := LoanApplication."Net Change-Principal";
                if BalanceAtDate > 0 then begin
                    if LoanApplication."Interest Repayment Method" <> LoanApplication."Interest Repayment Method"::Amortised then
                        InterestDue := BalanceAtDate * LoanApplication."Interest Rate" * 0.01 * (1 / 12)
                    else begin
                        enddate := CalcDate('CM', PDate);
                        LoanSchedule.Reset();
                        LoanSchedule.SetRange("Loan No.", LoanApplication."Application No");
                        LoanSchedule.SetRange("Expected Date", PDate, enddate);
                        if LoanSchedule.FindSet() then begin
                            LoanSchedule.CalcSums("Interest Repayment");
                            InterestDue := LoanSchedule."Interest Repayment";
                        end;
                    end;
                    Window.Update(4, InterestDue);
                    Dim1 := LoanApplication."Global Dimension 1 Code";
                    Dim2 := LoanApplication."Global Dimension 2 Code";
                    LoanProduct.Get(LoanApplication."Product Code");
                    PostingAmount := 0;
                    PostingAmount := InterestDue;
                    DocumentNo := GetDocumentNo(PDate);
                    VendorLedgerEntry.Reset();
                    VendorLedgerEntry.SetRange("Loan No.", LoanApplication."Application No");
                    VendorLedgerEntry.SetRange("Transaction Type", VendorLedgerEntry."Transaction Type"::"Interest Due");
                    VendorLedgerEntry.SetRange(Reversed, false);
                    VendorLedgerEntry.SetRange("Document No.", DocumentNo);
                    VendorLedgerEntry.SetRange("Vendor No.", LoanApplication."Loan Account");
                    if VendorLedgerEntry.IsEmpty then begin
                        ReasonCode := LoanApplication."Application No";
                        SourceCode := LoanApplication."Product Code";
                        ReasonCode := LoanApplication."Application No";
                        SourceCode := LoanApplication."Product Code";
                        MemberNo := LoanApplication."Member No.";
                        LoanApplication."Loan Account" := CreateLoanAccounts(LoanApplication);
                        PostingDescription := 'Interest Due ' + DocumentNo;
                        PostingAmount := 0;
                        PostingAmount := InterestDue;
                        PostingDate := PDate;
                        //Debit Loan
                        AccountNo := '';
                        AccountNo := LoanApplication."Loan Account";
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Due", LineNo, SourceCode, ReasonCode, DocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                        LoanProduct.Get(LoanApplication."Product Code");
                        AccountNo := '';
                        SaccoSetup.Get();
                        if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then
                            AccountNo := LoanProduct."Interest Due Account"
                        else
                            AccountNo := LoanProduct."Interest Paid Account";
                        //Credit Income
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Due", LineNo, SourceCode, ReasonCode, DocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                    end;
                end;
            until LoanApplication.Next() = 0;
            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
            Window.Close();
        end else
            Error('1212 %1', LoanApplication.GetFilters);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeSendLoanForApproval(LoanApplication: Record "Loan Application")
    begin
    end;

#pragma warning disable AL0114
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Loans Management", 'OnBeforeSendLoanForApproval', '', true, true)]
#pragma warning restore AL0114
    local procedure checkLoanFields(LoanApplication: Record "Loan Application")
    var
        MemberLoans: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
    begin
        LoanApplication.TestField("Applied Amount");
        LoanApplication.CalcFields("Total Repayment", "Total Securities", "Total Collateral");
        LoanApplication.TestField("Total Repayment");
        LoanApplication.TestField("Approved Amount");
        if (LoanApplication."Total Collateral" + LoanApplication."Total Securities") < LoanApplication."Approved Amount" then
            Error('The Loan is Unsecured');
        LoanApplication.TestField("Disbursement Account");
        LoanApplication.TestField("Sales Person");
        MemberLoans.Reset();
        MemberLoans.SetRange("Product Code", LoanApplication."Product Code");
        MemberLoans.SetRange("Member No.", LoanApplication."Member No.");
        MemberLoans.SetFilter("Application No", '<>%1', LoanApplication."Application No");
        MemberLoans.SetRange(Posted, true);
        MemberLoans.SetRange(Closed, false);
        if MemberLoans.FindFirst() then begin
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanApplication."Application No");
            LoanRecoveries.SetRange("Recovery Code", MemberLoans."Application No");
            if LoanRecoveries.IsEmpty then
                Error('The Member %1 has a running %2 loan %3. Please Close the Account first! %4', LoanApplication."Member Name", LoanApplication."Product Description", MemberLoans."Application No", MemberLoans.GetFilters);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterAcceptCollateral(CollateralApplication: Record "Collateral Application")
    begin
    end;

    procedure GenerateCalculatorSchedule(var LoanCalculator: Record "Loan Calculator")
    var
        Window: Dialog;
        CalculatorLines: Record "Loan Calculator Lines";
        LoanProducts: Record "Product Factory";
        EntryNo: Integer;
        InstallmentNo: Code[20];
        EndDate: Date;
        PrincipleBalance: Decimal;
        StartDate: date;
        PrincipleAmnt: Decimal;
        InterestBalance: Decimal;
        LBalance: Decimal;
        TotalMRepay: Decimal;
        LPrincipal: Decimal;
        LInterest: Decimal;
        ExpectedDate: date;
        TempEDate: Date;
        AnniversaryDay: Integer;
        NextMonth: Integer;
        Year: Integer;
    begin
        CalculatorLines.Reset();
        CalculatorLines.SetRange("Calculator No", LoanCalculator."Document No");
        if CalculatorLines.FindSet() then
            CalculatorLines.DeleteAll();
        Window.OPEN('Creating Schedule \#1##');
        LoanProducts.GET(LoanCalculator."Loan Product");
        LoanCalculator.TestField("Repayment Start Date");
        CalculatorLines.Reset();
        if CalculatorLines.FindLast() then
            EntryNo := CalculatorLines."Entry No" + 1
        else
            EntryNo := 1;
        PrincipleBalance := LoanCalculator."Principal Amount";
        EndDate := CalcDate(Format(LoanCalculator."Installments (Months)") + 'M', LoanCalculator."Repayment Start Date");
        StartDate := LoanCalculator."Repayment Start Date";
        PrincipleAmnt := 0;
        PrincipleAmnt := PrincipleBalance;
        InterestBalance := 0;
        LBalance := PrincipleBalance;
        PrincipleAmnt := PrincipleBalance;
        NextMonth := 0;
        Year := 0;
        REPEAT

            IF LoanCalculator."Rate Type" = LoanCalculator."Rate Type"::Amortised THEN BEGIN
                LoanCalculator.TestField("Installments (Months)");
                TotalMRepay := ROUND((LoanCalculator."Interest Rate" / 12 / 100) / (1 - POWER((1 + (LoanCalculator."Interest Rate" / 12 / 100)), -(LoanCalculator."Installments (Months)"))) * (PrincipleAmnt), 0.0001, '>');
                LInterest := LBalance / 100 / 12 * LoanCalculator."Interest Rate";
                LPrincipal := TotalMRepay - LInterest;
            END;
            IF LoanCalculator."Rate Type" = LoanCalculator."Rate Type"::"Straight Line" THEN BEGIN
                LoanCalculator.TESTFIELD("Installments (Months)");
                LPrincipal := PrincipleAmnt / LoanCalculator."Installments (Months)";
                LInterest := (LoanCalculator."Interest Rate" / 12 / 100) * PrincipleAmnt;
                LInterest := LInterest;
            END;
            IF LoanCalculator."Rate Type" = LoanCalculator."Rate Type"::"Reducing Balance" THEN BEGIN
                LoanCalculator.TESTFIELD("Installments (Months)");
                LPrincipal := PrincipleAmnt / LoanCalculator."Installments (Months)";
                LInterest := (LoanCalculator."Interest Rate" / 12 / 100) * LBalance;
                LInterest := LInterest;
            END;
            LBalance := LBalance - LPrincipal;
            ExpectedDate := StartDate;
            InstallmentNo := GetDocumentNo(StartDate);
            CalculatorLines.INIT;
            CalculatorLines."Entry No" := EntryNo;
            EntryNo += 1;
            CalculatorLines."Installment No" := InstallmentNo;
            CalculatorLines."Expected Date" := StartDate;
            CalculatorLines."Principal Amount" := LPrincipal;
            CalculatorLines."Interest Amount" := LInterest;
            CalculatorLines."Installment Amount" := LPrincipal + LInterest;
            CalculatorLines."Running Balance" := LBalance;
            CalculatorLines."Calculator No" := LoanCalculator."Document No";
            CalculatorLines.INSERT;
            StartDate := CalcDate('1M', StartDate);
            Window.UPDATE(1, InstallmentNo);
        UNTIL StartDate = EndDate;
        Window.CLOSE;

    end;

    procedure ValidateAppraisal(LoanApplication: record "Loan Application")
    var
        LoanProduct: Record "Product Factory";
        LoanApplication2: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
    begin
        LoanApplication2.Reset();
        LoanApplication2.SetRange("Member No.", LoanApplication."Member No.");
        LoanApplication2.SetRange("Product Code", LoanApplication."Product Code");
        LoanApplication2.SetFilter("Loan Balance", '>0');
        if LoanApplication2.FindFirst() then begin
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanApplication."Application No");
            LoanRecoveries.SetRange("Recovery Code", LoanApplication2."Application No");
            if LoanRecoveries.IsEmpty then
                Error('The Member has a running loan of ' + LoanApplication."Product Description");
        end;
        LoanProduct.Get(LoanApplication."Product Code");
        if LoanProduct."Minimum Deposit Balance" > GetMemberDeposits(LoanApplication."Member No.") then
            Error('You must have at least Kes. %1 to qualify for this loan', LoanProduct."Minimum Deposit Balance");

    end;

    procedure ValidateOnlineAppraisal(LoanApplication: record "Online Loan Application")
    var
        LoanProduct: Record "Product Factory";
        LoanApplication2: Record "Loan Application";
        LoanRecoveries: Record "Loan Recoveries";
    begin
        LoanApplication2.Reset();
        LoanApplication2.SetRange("Member No.", LoanApplication."Member No.");
        LoanApplication2.SetRange("Product Code", LoanApplication."Product Code");
        LoanApplication2.SetFilter("Loan Balance", '>0');
        if LoanApplication2.FindFirst() then begin
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanApplication."Application No");
            LoanRecoveries.SetRange("Recovery Code", LoanApplication2."Application No");
            if LoanRecoveries.IsEmpty then
                Error('The Member has a running loan of ' + LoanApplication."Product Description");
        end;
        LoanProduct.Get(LoanApplication."Product Code");
        if LoanProduct."Minimum Deposit Balance" > GetMemberDeposits(LoanApplication."Member No.") then
            Error('You must have at least Kes. %1 to qualify for this loan', LoanProduct."Minimum Deposit Balance");

    end;

    procedure PopulateGuarantorSubLines(DocumentNo: Code[20])
    var
        GuarantorLines: Record "Guarantor Lines";
        LoanGuarantors: Record "Loan Guarantees";
        GuarantorHeader: Record "Guarantor Header";
        LineNo: Integer;
        MemberMgt: Codeunit "Member Management";
        LoanApplication: Record "Loan Application";
    begin
        GuarantorHeader.get(DocumentNo);
        GuarantorLines.Reset();
        GuarantorLines.SetRange("Document No", DocumentNo);
        if GuarantorLines.FindSet() then
            GuarantorLines.DeleteAll();
        LoanGuarantors.Reset();
        LoanGuarantors.SetRange(Substituted, false);
        LoanGuarantors.SetRange("Loan No", GuarantorHeader."Loan No");
        if LoanGuarantors.FindSet() then begin
            repeat
                if LoanApplication.Get(LoanGuarantors."Loan No") then begin
                    LoanApplication.CalcFields("Loan Balance");
                    GuarantorLines.Init();
                    GuarantorLines."Document No" := DocumentNo;
                    GuarantorLines."Line No" := LineNo;
                    LineNo += 1;
                    GuarantorLines."Loan No." := GuarantorHeader."Loan No";
                    GuarantorLines."Member No" := LoanGuarantors."Member No";
                    GuarantorLines."Member Name" := LoanGuarantors."Member Name";
                    GuarantorLines."Loan Balance" := LoanApplication."Loan Balance";
                    GuarantorLines."Loan Principle" := LoanApplication."Approved Amount";
                    GuarantorLines."Product Code" := LoanApplication."Product Code";
                    GuarantorLines."Product Description" := LoanApplication."Product Description";
                    GuarantorLines."Outstanding Guarantee" := MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", LoanGuarantors."Member No");
                    GuarantorLines.Insert();
                end;
            until LoanGuarantors.Next() = 0;
        end;
    end;

    procedure ProcessGuarantorSubstitution(DocumentNo: Code[20])
    var
        GuarantorHeader: Record "Guarantor Header";
        GuarantorLines: Record "Guarantor Lines";
        GuarantorDetLines: Record "Guarantor Mgt. Det. Lines";
        LoanGuarantee1, LoanGuarantee, LoanGuarantee2 : Record "Loan Guarantees";
        OriginalGuarantee: Decimal;
    begin
        GuarantorHeader.Get(DocumentNo);
        GuarantorHeader.TestField(Processed, false);
        GuarantorHeader.TestField("Approval Status", GuarantorHeader."Approval Status"::Approved);
        GuarantorLines.Reset();
        GuarantorLines.SetRange("Document No", DocumentNo);
        if GuarantorLines.FindSet() then begin
            repeat
                GuarantorLines.CalcFields(Substitution);
                if GuarantorLines.Release then begin
                    LoanGuarantee.Reset();
                    LoanGuarantee.SetRange("Loan No", GuarantorLines."Loan No.");
                    LoanGuarantee.SetRange("Member No", GuarantorLines."Member No");
                    if LoanGuarantee.FindSet() then begin
                        LoanGuarantee.Substituted := true;
                        LoanGuarantee."Substituted By" := UserId;
                        LoanGuarantee."Document No." := DocumentNo;
                        LoanGuarantee.Modify();
                    end;
                end else begin
                    if GuarantorLines.Substitution then begin
                        LoanGuarantee.Reset();
                        LoanGuarantee.SetRange("Loan No", GuarantorLines."Loan No.");
                        LoanGuarantee.SetRange("Member No", GuarantorLines."Member No");
                        if LoanGuarantee.FindSet() then begin
                            LoanGuarantee.Substituted := true;
                            LoanGuarantee."Substituted By" := UserId;
                            LoanGuarantee."Document No." := DocumentNo;
                            LoanGuarantee.Modify();
                        end;
                        GuarantorDetLines.Reset();
                        GuarantorDetLines.SetRange("Document No", DocumentNo);
                        GuarantorDetLines.SetRange("Line No", GuarantorLines."Line No");
                        GuarantorLines.SetFilter("Guaranteed Amount", '>0');
                        if GuarantorDetLines.FindSet() then begin
                            repeat
                                LoanGuarantee1.Reset();
                                LoanGuarantee1.SetRange("Loan No", GuarantorLines."Loan No.");
                                LoanGuarantee1.SetRange("Member No", GuarantorDetLines."Member No");
                                if not LoanGuarantee1.FindSet() then begin
                                    LoanGuarantee1.Init();
                                    LoanGuarantee1."Loan No" := GuarantorLines."Loan No.";
                                    LoanGuarantee1."Member No" := GuarantorDetLines."Member No";
                                    LoanGuarantee1."Member Name" := GuarantorDetLines."Member Name";
                                    LoanGuarantee1."Member Deposits" := GetMemberDeposits((GuarantorDetLines."Member No"));
                                    LoanGuarantee1."Available Guarantee" := GuarantorDetLines."Qualified Guarantee";
                                    LoanGuarantee1."Guaranteed Amount" := GuarantorDetLines."Guarantee Amount";
                                    LoanGuarantee1.Insert();
                                end else begin
                                    OriginalGuarantee := 0;
                                    LoanGuarantee2.Reset();
                                    LoanGuarantee2.SetRange("Loan No", GuarantorLines."Loan No.");
                                    LoanGuarantee2.SetRange("Member No", GuarantorLines."Member No");
                                    if LoanGuarantee2.FindSet() then
                                        OriginalGuarantee := LoanGuarantee2."Guaranteed Amount";
                                    LoanGuarantee1."Guaranteed Amount" += OriginalGuarantee;
                                    LoanGuarantee1.Modify();
                                end;
                            until GuarantorDetLines.Next() = 0;
                        end;
                    end;
                end;
            until GuarantorLines.Next() = 0;
        end;
        GuarantorHeader.Processed := true;
        GuarantorHeader.Modify();
        Message('Guarantor Substituted Successfully!');
    end;

    procedure GetAccruedInterest(LoanNo: Code[20]; AsAtDate: Date) AccruedInterest: Decimal
    var
        DetailedVendorLedger: Record "Detailed Vendor Ledg. Entry";
        LoanApplication: Record "Loan Application";
        DateFilter: Text;
        Days: Integer;
    begin
        DateFilter := '..' + Format(AsAtDate);
        LoanApplication.Reset();
        LoanApplication.SetRange("Application No", LoanNo);
        LoanApplication.SetFilter("Date Filter", DateFilter);
        if LoanApplication.findset then begin
            DetailedVendorLedger.Reset();
            DetailedVendorLedger.SetRange("Reason Code", LoanNo);
            DetailedVendorLedger.SetFilter("Posting Date", DateFilter);
            DetailedVendorLedger.SetRange("Vendor No.", LoanApplication."Loan Account");
            DetailedVendorLedger.SetRange("Transaction Type", DetailedVendorLedger."Transaction Type"::"Interest Due");
            if DetailedVendorLedger.FindLast() then
                Days := AsAtDate - DetailedVendorLedger."Posting Date"
            else begin
                DetailedVendorLedger.Reset();
                DetailedVendorLedger.SetRange("Reason Code", LoanNo);
                DetailedVendorLedger.SetFilter("Posting Date", DateFilter);
                DetailedVendorLedger.SetRange("Vendor No.", LoanApplication."Loan Account");
                DetailedVendorLedger.SetRange("Transaction Type", DetailedVendorLedger."Transaction Type"::"Loan Disbursal");
                if DetailedVendorLedger.FindLast() then
                    Days := AsAtDate - DetailedVendorLedger."Posting Date"
            end;
            if Days <= 0 then
                Days := 0;
            LoanApplication.CalcFields("Loan Balance");
            AccruedInterest := (Days / 365) * LoanApplication."Loan Balance" * LoanApplication."Interest Rate" * 0.01;
            exit(AccruedInterest);
        end;
    end;

    var
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8 : code[20];
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
}
codeunit 90003 "Fixed Deposit Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure CreateFixedDepositSchedule(FixedDeposit: Record "Fixed Deposit Register")
    VAR
        Schedule: Record "Fixed Deposit Schedule";
        EntryNo: Integer;
        SDate: date;
        FPrinciple: Decimal;
        Interest: Decimal;
        FDTypes: Record "Fixed Deposit Types";
    begin
        SDate := FixedDeposit."Start Date";
        FDTypes.Get(FixedDeposit."FD Type");
        FPrinciple := 0;
        FPrinciple := FixedDeposit.Amount;
        FixedDeposit.TestField("End Date");
        Schedule.Reset();
        Schedule.SetRange("FD No", FixedDeposit."FD No.");
        Schedule.SetRange(Transferred, true);
        if Schedule.FindSet() then
            Error('The FD Has transferred Entries. The Schedule Cannot be modified');
        Schedule.Reset();
        Schedule.SetRange("FD No", FixedDeposit."FD No.");
        if Schedule.FindSet() then
            Schedule.DeleteAll();
        EntryNo := 1;
        Schedule.Reset();
        if Schedule.FindLast() then
            EntryNo := Schedule."Entry No." + 1;
        repeat
            Interest := 0;
            Interest := FixedDeposit.Rate * FPrinciple * 0.01 * (1 / 12);
            if FDTypes."Interest Calculation Type" = FDTypes."Interest Calculation Type"::"Reducing Balance" then
                FPrinciple += Interest;
            Schedule.Init();
            Schedule."Entry No." := EntryNo;
            EntryNo += 1;
            Schedule."FD No" := FixedDeposit."FD No.";
            Schedule.Description := 'Accrued Interest for ' + Format(SDate);
            Schedule."Posting Date" := SDate;
            Schedule.Amount := Interest;
            Schedule.Insert();
            SDate := CalcDate('1M', SDate);
        until SDate >= FixedDeposit."End Date";
    end;

    procedure CreateFDAccount(FixedDeposit: Record "Fixed Deposit Register") FDAccount: Code[20]
    var
        Vendor: Record Vendor;
        FDType: Record "Fixed Deposit Types";
        AccountType: Record "Product Factory";
        AccNo: Code[20];
    begin
        FDType.get(FixedDeposit."FD Type");
        AccountType.get(FDType."Linking Account Type");
        AccountType.TestField(Prefix);
        AccNo := AccountType.Prefix + FixedDeposit."Member No.";
        if not Vendor.get(AccNo) then begin
            Vendor.Init();
            Vendor."No." := AccNo;
            Vendor.Name := AccountType.Name;
            Vendor."Search Name" := FixedDeposit."Member Name";
            Vendor."Member No." := FixedDeposit."Member No.";
            Vendor."Account Type" := Vendor."Account Type"::Sacco;
            Vendor."Vendor Posting Group" := AccountType."Posting Group";
            Vendor.Insert();
        end;
        exit(AccNo);
    end;

    procedure ActivateFD(FixedDeposti: Record "Fixed Deposit Register")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        JournalTemplate: code[20];
        JournalBatch: Code[20];
        LineNo: Integer;
        DocumentNo: Code[20];
        PostingDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        JournalTemplate := 'PAYMENT';
        JournalBatch := 'FD-PST';
        PostingDate := FixedDeposti."Posting Date";
        DocumentNo := FixedDeposti."FD No.";
        if not GenJournalBatch.get(JournalTemplate, JournalBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Insert();
        end;
        LineNo := 1000;
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();

        //Debit Source Account
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := PostingDate;
        LineNo += 1000;
        if FixedDeposti."Funds Source" = FixedDeposti."Funds Source"::"Member Account" then
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor
        else
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine.VALIDATE("Account No.", FixedDeposti."Source Account");
        GenJournalLine."Debit Amount" := FixedDeposti.Amount;
        GenJournalLine.VALIDATE("Debit Amount");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Message to Recipient" := 'Fixed deposit activation';
        GenJournalLine.Description := GenJournalLine."Message to Recipient";
        GenJournalLine."Due Date" := PostingDate;
        GenJournalLine."Reason Code" := DocumentNo;
        GenJournalLine."Source Code" := 'FD-ACT';
        GenJournalLine."External Document No." := DocumentNo;
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Fixed Deposit";
        GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
        GenJournalLine."Member No." := FixedDeposti."Member No.";
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //Credit Destination Account        
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := PostingDate;
        LineNo += 1000;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.VALIDATE("Account No.", CreateFDAccount(FixedDeposti));
        GenJournalLine."Credit Amount" := FixedDeposti.Amount;
        GenJournalLine.VALIDATE("Credit Amount");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Message to Recipient" := 'Fixed deposit activation';
        GenJournalLine.Description := GenJournalLine."Message to Recipient";
        GenJournalLine."Due Date" := PostingDate;
        GenJournalLine."Reason Code" := DocumentNo;
        GenJournalLine."Source Code" := 'FD-ACT';
        GenJournalLine."External Document No." := DocumentNo;
        GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Fixed Deposit";
        GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
        GenJournalLine."Member No." := FixedDeposti."Member No.";
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;

        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
        FixedDeposti.Posted := true;
        FixedDeposti."Control Account" := CreateFDAccount(FixedDeposti);
        FixedDeposti."Posted By" := UserId;
        FixedDeposti.Modify(true);
    end;

    procedure PostFDAccrual(FixedDeposit: Record "Fixed Deposit Register")
    var
        NoSeries: Codeunit NoSeriesManagement;
        Schedule: Record "Fixed Deposit Schedule";
        JournalTemplate: code[20];
        JournalBatch: Code[20];
        LineNo: Integer;
        DocumentNo: Code[20];
        PostingDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        FDType: Record "Fixed Deposit Types";
        PostingAmount: decimal;
    begin
        if FDType.Get(FixedDeposit."FD Type") = false then
            exit;
        JournalTemplate := 'PAYMENT';
        JournalBatch := 'FD-ACCR';
        if not GenJournalBatch.get(JournalTemplate, JournalBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Insert();
        end;
        Schedule.Reset();
        Schedule.SetRange("FD No", FixedDeposit."FD No.");
        Schedule.SetRange(Transferred, false);
        Schedule.SetFilter("Posting Date", '..%1', Today);
        if Schedule.FindSet() then begin
            repeat
                PostingAmount := 0;
                PostingAmount := (100 - FDType."Withholding Tax Rate") * Schedule.Amount * 0.01;
                LineNo := 1000;
                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                if GenJournalLine.FindSet() then
                    GenJournalLine.DeleteAll();
                PostingDate := Schedule."Posting Date";
                DocumentNo := NoSeries.GetNextNo(FDType."No. Series", Today, true);
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := JournalTemplate;
                GenJournalLine."Journal Batch Name" := JournalBatch;
                GenJournalLine."Document No." := DocumentNo;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Posting Date" := PostingDate;
                LineNo += 1000;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE("Account No.", FDType."Interest Payable Account");
                GenJournalLine."Debit Amount" := PostingAmount;
                GenJournalLine.VALIDATE("Debit Amount");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJournalLine."Message to Recipient" := Schedule.Description;
                GenJournalLine.Description := GenJournalLine."Message to Recipient";
                GenJournalLine."Due Date" := PostingDate;
                GenJournalLine."Reason Code" := DocumentNo;
                GenJournalLine."Source Code" := 'FD-ACC';
                GenJournalLine."External Document No." := DocumentNo;
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Fixed Deposit";
                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
                GenJournalLine."Member No." := FixedDeposit."Member No.";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;

                PostingAmount := Schedule.Amount;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := JournalTemplate;
                GenJournalLine."Journal Batch Name" := JournalBatch;
                GenJournalLine."Document No." := DocumentNo;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Posting Date" := PostingDate;
                LineNo += 1000;
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                GenJournalLine.VALIDATE("Account No.", FDType."Interest Provision Account");
                GenJournalLine."Credit Amount" := PostingAmount;
                GenJournalLine.VALIDATE("Credit Amount");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                GenJournalLine."Message to Recipient" := Schedule.Description;
                GenJournalLine.Description := GenJournalLine."Message to Recipient";
                GenJournalLine."Due Date" := PostingDate;
                GenJournalLine."Reason Code" := DocumentNo;
                GenJournalLine."Source Code" := 'FD-ACC';
                GenJournalLine."External Document No." := DocumentNo;
                GenJournalLine."Transaction Type" := GenJournalLine."Transaction Type"::"Fixed Deposit";
                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
                GenJournalLine."Member No." := FixedDeposit."Member No.";
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;

                GenJournalLine.Reset();
                GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
                GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
                if GenJournalLine.FindSet() then
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
                Schedule.Transferred := true;
                Schedule.Modify(true);
            until Schedule.Next() = 0;
        end;
    end;

    procedure MatureFixedDeposit(FixedDeposit: Record "Fixed Deposit Register")
    var
        NewFDNo: code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        LineNo: Integer;
        PostingDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        FDType: Record "Fixed Deposit Types";
        SaccoJournal: Codeunit "Journal Management";
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        AccountNo, ExtDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, DocumentNo, MemberNo, ReasonCode, SourceCode : code[20];
        PostingDescription: Text[50];
        PostingAmount: Decimal;
    begin
        if FixedDeposit."End Date" > Today then
            Error('You Cannot Mature the fixed deposit before its due date of %1', FixedDeposit."End Date");
        if not FDType.get(FixedDeposit."FD Type") then
            exit;
        DocumentNo := FixedDeposit."FD No.";
        MemberNo := FixedDeposit."Member No.";
        FixedDeposit.CalcFields("Total Interest Payable");
        FixedDeposit.TestField("Total Interest Payable");
        JournalTemplate := 'SACCO';
        JournalBatch := 'FD-PST';
        PostingDate := FixedDeposit."End Date";
        PostingAmount := FixedDeposit."Total Interest Payable";
        LineNo := SaccoJournal.PrepareJournal(JournalTemplate, JournalBatch, 'Fixed Deposits');
        //Pay Interest      
        PostingDescription := 'Interest Earned ' + FixedDeposit."FD No.";
        DocumentNo := FixedDeposit."FD No.";
        AccountNo := '';
        AccountNo := FDType."Interest Provision Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);

        AccountNo := '';
        AccountNo := FixedDeposit."Control Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);

        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);

        AccountNo := '';
        AccountNo := FixedDeposit."Source Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        //Refund Principle
        PostingDescription := 'Fixed Deposit Marturity ' + FixedDeposit."FD No.";
        PostingAmount := 0;
        PostingAmount := FixedDeposit.Amount;
        AccountNo := '';
        AccountNo := FixedDeposit."Source Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        AccountNo := '';
        AccountNo := FixedDeposit."Control Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        if FixedDeposit."Marturity Instructions" <> FixedDeposit."Marturity Instructions"::Liquidate then begin
            NewFDNo := CopyFixedDeposit(FixedDeposit);
            PostingDescription := 'Fixed Deposit Roll OVer ' + FixedDeposit."FD No.";
            if FixedDeposit."Marturity Instructions" = FixedDeposit."Marturity Instructions"::"Roll Over Principle" then
                PostingAmount := FixedDeposit.Amount
            else
                PostingAmount := (FixedDeposit.Amount + FixedDeposit."Total Interest Payable" - SaccoJournal.GetTransactionCharges(FDType."Charge Code", FixedDeposit."Total Interest Payable"));
            AccountNo := '';
            AccountNo := FixedDeposit."Source Account";
            LineNo := SaccoJournal.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            AccountNo := '';
            AccountNo := FixedDeposit."Control Account";
            LineNo := SaccoJournal.CreateJournalLine(
                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
            FixedDeposit.Terminated := true;
        end else begin
            FixedDeposit.Terminated := true;
        end;
        LineNo := SaccoJournal.AddCharges(FDType."Charge Code", FixedDeposit."Source Account", FixedDeposit."Total Interest Payable", LineNo, DocumentNo, MemberNo, 'FD', 'FD', SourceCode, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
        SaccoJournal.CompletePosting(JournalTemplate, JournalBatch);
        FixedDeposit.Modify();
    end;

    procedure CancelFixedDeposit(FixedDeposit: Record "Fixed Deposit Register")
    var
        NewFDNo: code[20];
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        LineNo: Integer;
        PostingDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        FDType: Record "Fixed Deposit Types";
        SaccoJournal: Codeunit "Journal Management";
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        AccountNo, ExtDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, DocumentNo, MemberNo, ReasonCode, SourceCode : code[20];
        PostingDescription: Text[50];
        PostingAmount: Decimal;
    begin
        if not FDType.get(FixedDeposit."FD Type") then
            exit;
        DocumentNo := FixedDeposit."FD No.";
        MemberNo := FixedDeposit."Member No.";
        FixedDeposit.CalcFields("Total Interest Payable");
        JournalTemplate := 'PAYMENT';
        JournalBatch := 'FD-PST';
        PostingDate := FixedDeposit."End Date";
        PostingAmount := FixedDeposit."Total Interest Payable";
        LineNo := SaccoJournal.PrepareJournal(JournalTemplate, JournalBatch, 'Fixed Deposits');
        PostingDescription := 'Principle Reversed ' + FixedDeposit."FD No.";
        PostingAmount := 0;
        PostingAmount := FixedDeposit.Amount;
        AccountNo := '';
        AccountNo := FixedDeposit."Source Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        AccountNo := '';
        AccountNo := FixedDeposit."Control Account";
        LineNo := SaccoJournal.CreateJournalLine(
            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocumentNo,
            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
        FixedDeposit.Terminated := true;
        FixedDeposit.Modify();
        SaccoJournal.CompletePosting(JournalTemplate, JournalBatch);
    end;

    local procedure CopyFixedDeposit(FixedDeposit: Record "Fixed Deposit Register") NewFDNo: code[20]
    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        NewFixedDeposit: Record "Fixed Deposit Register";
        FDNo: code[20];
        FDType: Record "Fixed Deposit Types";
    begin
        SaccoSetup.get;
        SaccoSetup.TestField("FD Nos.");
        FDNo := NoSeries.GetNextNo(SaccoSetup."FD Nos.", Today, true);
        NewFixedDeposit.Init();
        NewFixedDeposit.TransferFields(FixedDeposit, false);
        NewFixedDeposit."FD No." := FDNo;
        if FixedDeposit."Marturity Instructions" = NewFixedDeposit."Marturity Instructions"::"Roll Over Net" then begin
            NewFixedDeposit.Amount := (FixedDeposit.Amount + FixedDeposit."Total Interest Payable" - (FDType."Withholding Tax Rate" * FixedDeposit."Total Interest Payable" * 0.01));
        end;
        NewFixedDeposit."Start Date" := FixedDeposit."End Date";
        NewFixedDeposit.Validate("Start Date");
        NewFixedDeposit.Insert();
        CreateFixedDepositSchedule(NewFixedDeposit);
        FixedDeposit.Terminated := true;
        FixedDeposit.Modify();
        exit(FDNo);
    end;

    var
        myInt: Integer;
}
codeunit 90004 ThirdPartyIntegrations
{
    trigger OnRun()
    begin
    end;

    //------------------Eclectics Requests
    procedure CompleteOnlineLoanApplication(LoanNo: Code[20]; var ResponseCode: code[20]; var ResponseMessage: BigText)
    var
        OnlineLoanGuarantors: Record "Online Guarantor Requests";
        LoanApplication: Record "Online Loan Application";
    begin
        Clear(ResponseMessage);
        Clear(ResponseCode);
        OnlineLoanGuarantors.Reset();
        OnlineLoanGuarantors.SetRange(Status, OnlineLoanGuarantors.Status::New);
        OnlineLoanGuarantors.SetRange("Loan No", LoanNo);
        if OnlineLoanGuarantors.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The ' + format(OnlineLoanGuarantors."Request Type") + ' ' + OnlineLoanGuarantors."Member Name" + ' has not responded to your request"}');
            exit;
        end;
        LoanApplication.Get(LoanNo);
        if LoanApplication."Portal Status" <> LoanApplication."Portal Status"::New then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Is Already Submitted"}');
            exit;
        end;
        LoanApplication.CalcFields("Total Securities", "Total Collateral", "Total Repayment");
        if (LoanApplication."Total Securities" + LoanApplication."Total Collateral") < LoanApplication."Applied Amount" then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan is unsecured"}');
            exit;
        end;
        if LoanApplication."Total Repayment" = 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Generate the Schedule"}');
            exit;
        end;
        LoanApplication."Portal Status" := LoanApplication."Portal Status"::Submitted;
        LoanApplication."Submitted On" := CurrentDateTime;
        LoanApplication.Modify();
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Loan Submitted"}');
        exit;
    end;

    procedure UploadLoanDocument(LoanNo: code[20]; FilePath: Text; FileName: Text; ResponseCode: Code[20]; ResponseMessage: BigText)
    begin

    end;

    procedure GetLoanApplications(MemberNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Requests: Record "Online Guarantor Requests";
        OnlineLoanApplication: Record "Online Loan Application";
        Members: Record Members;
        EconomicSectors: Record "Economic Sectors";
        SubSecotrs: Record "Economic Subsectors";
        SubSubSectors: Record "Economic Sub-subsector";
        AdjustedNet: Decimal;
        Tresp1: BigText;
        LoanSchedule: Record "Repayment Schedule";
        LoanParameters: Record "Loan Appraisal Parameters";
        Ok: Boolean;
        LoansMgt: Codeunit "Loans Management";
        PortalMgt: Codeunit PortalIntegrations;
        BridgedLoans: Record "Loan Recoveries";
    begin
        if Members.Get(MemberNo) then begin
            ResponseMessage.AddText('{"MemberNo":"' + MemberNo + '","MemberName":"' + Members."Full Name" + '","Loans":[');
            Clear(TempResponse);
            OnlineLoanApplication.Reset();
            OnlineLoanApplication.SetRange(Status, OnlineLoanApplication.Status::Application);
            if OnlineLoanApplication.FindSet() then begin
                repeat
                    Ok := EconomicSectors.Get(OnlineLoanApplication."Sector Code");
                    Ok := SubSecotrs.get(OnlineLoanApplication."Sector Code", OnlineLoanApplication."Sub Sector Code");
                    Ok := SubSubSectors.Get(OnlineLoanApplication."Sector Code", OnlineLoanApplication."Sub Sector Code", OnlineLoanApplication."Sub-Susector Code");
                    TempResponse.AddText('{"LoanNo":"' + OnlineLoanApplication."Application No" + '",');
                    TempResponse.AddText('"ProductCode":"' + OnlineLoanApplication."Product Code" + '",');
                    TempResponse.AddText('"ProductName":"' + OnlineLoanApplication."Product Description" + '",');
                    TempResponse.AddText('"AppliedAmount":"' + Format(OnlineLoanApplication."Applied Amount") + '",');
                    TempResponse.AddText('"SectorCode":"' + OnlineLoanApplication."Sector Code" + '",');
                    TempResponse.AddText('"SectorName":"' + EconomicSectors."Sector Name" + '",');
                    TempResponse.AddText('"SubSectorCode":"' + SubSecotrs."Sub Sector Code" + '",');
                    TempResponse.AddText('"SubSecotrName":"' + SubSecotrs."Sub Sector Name" + '",');
                    TempResponse.AddText('"SubSubSectorCode":"' + SubSubSectors."Sub-Subsector Code" + '",');
                    TempResponse.AddText('"SubSubSectorName":"' + SubSubSectors."Sub-Subsector Description" + '",');
                    TempResponse.AddText('"BankCode":"' + OnlineLoanApplication."Pay to Bank Code" + '",');
                    TempResponse.AddText('"BranchCode":"' + OnlineLoanApplication."Pay to Branch Code" + '",');
                    TempResponse.AddText('"PayslipInformation":[');
                    Clear(Tresp1);
                    if STRLEN(FORMAT(Tresp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp1), 1, STRLEN(FORMAT(Tresp1)) - 1));
                    LoanParameters.Reset();
                    LoanParameters.SetRange("Loan No", OnlineLoanApplication."Application No");
                    if LoanParameters.FindSet() then begin
                        repeat
                            Tresp1.AddText('{"ParameterCode":"' + LoanParameters."Appraisal Code" + '",');
                            Tresp1.AddText('"ParameterDescription":"' + LoanParameters."Parameter Description" + '",');
                            Tresp1.AddText('"ParameterValue":"' + Format(LoanParameters."Parameter Value") + '"},');
                        until LoanParameters.Next() = 0;
                    end;
                    if STRLEN(FORMAT(Tresp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp1), 1, STRLEN(FORMAT(Tresp1)) - 1));
                    TempResponse.AddText('],"LoanSchedule":[');
                    Clear(Tresp1);
                    LoanSchedule.Reset();
                    LoanSchedule.SetRange("Loan No.", OnlineLoanApplication."Application No");
                    if LoanSchedule.FindSet() then begin
                        repeat
                            Tresp1.AddText('{"Installment":"' + LoanSchedule."Document No." + '",');
                            Tresp1.AddText('"ExpectedDate":"' + Format(LoanSchedule."Expected Date") + '",');
                            Tresp1.AddText('"PrincipleAmount":"' + Format(LoanSchedule."Principle Repayment") + '",');
                            Tresp1.AddText('"InterestAmount":"' + Format(LoanSchedule."Interest Repayment") + '",');
                            Tresp1.AddText('"Installment":"' + Format(LoanSchedule."Monthly Repayment") + '",');
                            Tresp1.AddText('"RunningBalance":"' + Format(LoanSchedule."Running Balance") + '"}');
                        until LoanSchedule.Next() = 0;
                    end;
                    if STRLEN(FORMAT(Tresp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp1), 1, STRLEN(FORMAT(Tresp1)) - 1));
                    TempResponse.AddText('],"Requests":[');
                    Clear(Tresp1);
                    Requests.Reset();
                    Requests.SetRange("Loan No", OnlineLoanApplication."Application No");
                    if Requests.FindSet() then begin
                        repeat
                            Tresp1.AddText('{"RequestType":"' + Format(Requests."Request Type") + '",');
                            Tresp1.AddText('"MemberNo":"' + Format(Requests."Member No") + '",');
                            Tresp1.AddText('"MemberName":"' + Format(Requests."Member Name") + '",');
                            Tresp1.AddText('"MemberIDNo":"' + Format(Requests."ID No") + '",');
                            Tresp1.AddText('"RequestedAmount":"' + Format(Requests."Requested Amount") + '",');
                            Tresp1.AddText('"AcceptedAmount":"' + Format(Requests."Amount Accepted") + '",');
                            Tresp1.AddText('"Status":"' + Format(Requests.Status) + '"},');
                        until Requests.Next() = 0;
                    end;
                    if STRLEN(FORMAT(Tresp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp1), 1, STRLEN(FORMAT(Tresp1)) - 1));
                    AdjustedNet := PortalMgt.AdjustedNet(OnlineLoanApplication."Application No");
                    TempResponse.AddText('],"BridgedLoans":[');
                    Clear(Tresp1);
                    BridgedLoans.Reset();
                    BridgedLoans.SetRange("Loan No", OnlineLoanApplication."Application No");
                    if BridgedLoans.FindSet() then begin
                        repeat
                            Tresp1.AddText('{"LoanNo":"' + Format(BridgedLoans."Recovery Code") + '",');
                            Tresp1.AddText('"ProductName":"' + Format(BridgedLoans."Recovery Description") + '",');
                            Tresp1.AddText('"BridgedAmount":"' + Format(BridgedLoans.Amount) + '"},');
                        until BridgedLoans.Next() = 0;
                    end;
                    if STRLEN(FORMAT(Tresp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp1), 1, STRLEN(FORMAT(Tresp1)) - 1));
                    AdjustedNet := PortalMgt.AdjustedNet(OnlineLoanApplication."Application No");
                    TempResponse.AddText('],');
                    TempResponse.AddText('"AdjustedNet":"' + format(AdjustedNet) + '",');
                    TempResponse.AddText('"Status":"' + Format(OnlineLoanApplication.Status) + '"},');
                until OnlineLoanApplication.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText(']}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
        end;
    end;

    procedure SubmitLoanApplication(MemberNo: Code[20]; ProductCode: Code[20]; PrincipleAmount: Decimal; Installemnts: Integer; BankCode: Code[20]; BranchCode: Code[20]; AccountName: Text[100]; AccountNo: Code[30]; SectorCode: Code[20]; SubSectorCode: Code[20]; SubSubSector: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        SaccoSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        LoanNo, FOSAAccount : Code[20];
        LProduct: Record "Product Factory";
        OnlineLoanApplication: Record "Online Loan Application";
        EconomicSector: Record "Economic Sectors";
        SubSectorRec: Record "Economic Subsectors";
        SubSubSectorRec: Record "Economic Sub-subsector";
        LoansMgt: Codeunit "Loans Management";
        MemberMgt: Codeunit "Member Management";
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        if (SectorCode = '') or (SubSectorCode = '') or (SubSectorCode = '') or (ProductCode = '') or (PrincipleAmount = 0) or (Installemnts = 0) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide All parameters"}');
            exit;
        end;
        if not EconomicSector.Get(SectorCode) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Economic Sector Does Not Exist"}');
            exit;
        end;

        if not SubSectorRec.Get(SectorCode, SubSectorCode) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Economic Sub Sector Does Not Exist"}');
            exit;
        end;

        if not SubSubSectorRec.Get(SectorCode, SubSectorCode, SubSubSector) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Economic Sector Does Not Exist"}');
            exit;
        end;
        OnlineLoanApplication.Reset();
        OnlineLoanApplication.SetRange("Member No.", MemberNo);
        OnlineLoanApplication.SetRange("Portal Status", OnlineLoanApplication."Portal Status"::New);
        OnlineLoanApplication.SetRange("Product Code", ProductCode);
        if OnlineLoanApplication.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"You have a pending loan application"}');
            exit;
        end;
        LProduct.Get(ProductCode);
        SaccoSetup.Get();
        LoanNo := NoSeries.GetNextNo(SaccoSetup."Online Loan Nos.", Today, true);
        OnlineLoanApplication.Init();
        OnlineLoanApplication."Application No" := LoanNo;
        OnlineLoanApplication.Validate("Member No.", MemberNo);
        OnlineLoanApplication.Validate("Product Code", ProductCode);
        OnlineLoanApplication."Application Date" := Today;
        OnlineLoanApplication."Posting Date" := Today;
        OnlineLoanApplication."Repayment Start Date" := LoansMgt.GetRepaymentOnlineStartDate(OnlineLoanApplication);
        OnlineLoanApplication.Validate(Installments, Installemnts);
        OnlineLoanApplication.Validate("Applied Amount", PrincipleAmount);
        OnlineLoanApplication."Approved Amount" := OnlineLoanApplication."Applied Amount";
        OnlineLoanApplication."Source Type" := OnlineLoanApplication."Source Type"::Channels;
        OnlineLoanApplication."Mode of Disbursement" := OnlineLoanApplication."Mode of Disbursement"::FOSA;
        FOSAAccount := MemberMgt.GetMemberAccount(MemberNo, 'FOSA');
        OnlineLoanApplication."Disbursement Account" := FOSAAccount;
        OnlineLoanApplication."Sector Code" := SectorCode;
        OnlineLoanApplication."Sub Sector Code" := SubSectorCode;
        OnlineLoanApplication."Sub-Susector Code" := SubSubSector;
        OnlineLoanApplication.Insert();
        LoansMgt.GenerateOnlineLoanRepaymentSchedule(OnlineLoanApplication);
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Loan Created Successfully","LoanNo":"' + LoanNo + '"}');
    end;

    procedure SubmitBridgingLoans(LoanNo: Code[20]; BridgingLoanNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        LoanRecoveries: Record "Loan Recoveries";
        OnlineLoanApplication: Record "Online Loan Application";
        LoanApplication: Record "Loan Application";
        BridgedAmount: Decimal;
        LoansMgt: Codeunit "Loans Management";
    begin
        BridgedAmount := 0;
        if OnlineLoanApplication.Get(LoanNo) then begin
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanNo);
            LoanRecoveries.SetRange("Recovery Type", LoanRecoveries."Recovery Type"::Loan);
            LoanRecoveries.SetRange("Recovery Code", BridgingLoanNo);
            if LoanRecoveries.FindSet() then
                LoanRecoveries.DeleteAll();
            LoanRecoveries.Reset();
            LoanRecoveries.SetRange("Loan No", LoanNo);
            if LoanRecoveries.FindSet() then begin
                LoanRecoveries.CalcSums(Amount);
                BridgedAmount := LoanRecoveries.Amount;
            end;
            if LoanApplication.get(BridgingLoanNo) then begin
                LoanApplication.CalcFields("Loan Balance");
                if (LoanApplication."Loan Balance" + BridgedAmount) > OnlineLoanApplication."Applied Amount" then begin
                    ResponseCode := '01';
                    ResponseMessage.AddText('{"Error":"The Bridging Loan is more than the applied amount"}');
                    exit;
                end;
                if LoanApplication."Loan Balance" <= 0 then begin
                    ResponseCode := '01';
                    ResponseMessage.AddText('{"Error":"The Bridging Loan is cleared"}');
                    exit;
                end else begin
                    LoanRecoveries.Init();
                    LoanRecoveries."Loan No" := LoanNo;
                    LoanRecoveries."Recovery Type" := LoanRecoveries."Recovery Type"::Loan;
                    LoanRecoveries.Validate("Recovery Code", BridgingLoanNo);
                    LoanRecoveries."Recovery Description" := LoanApplication."Product Description";
                    LoanRecoveries."Current Balance" := LoanApplication."Loan Balance";
                    LoanRecoveries."Prorated Interest" := LoansMgt.GetProratedInterest(LoanApplication."Application No", LoanApplication."Application Date");
                    LoanRecoveries.Validate(Amount, (LoanRecoveries."Current Balance" + LoanRecoveries."Prorated Interest"));
                    LoanRecoveries.Validate(Amount, LoanApplication."Loan Balance");
                    LoanRecoveries.Validate("Commission Amount");
                    LoanRecoveries.Insert();
                    ResponseCode := '00';
                    ResponseMessage.AddText('{"Message":"Bridging Loan Added Successfully"}');
                    exit;
                end;
            end else begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Bridging Loan Does Not Exist"}');
                exit;
            end;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Application Does Not Exist"}');
            exit;
        end;
    end;

    procedure SubmitLoanAppraisalParameter(LoanNo: Code[20]; ParameterCode: Code[20]; ParameterValue: Decimal; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        LoanAppraisalParameters: Record "Loan Appraisal Parameters";
        OnlineLoanApplication: Record "Online Loan Application";
        AppraisalParameters: Record "Appraisal Parameters";
    begin
        clear(ResponseCode);
        clear(ResponseMessage);
        if AppraisalParameters.Get(ParameterCode) then begin
            if OnlineLoanApplication.Get(LoanNo) then begin
                if LoanAppraisalParameters.get(LoanNo, ParameterCode) then begin
                    LoanAppraisalParameters.Validate("Parameter Value", ParameterValue);
                    LoanAppraisalParameters.Modify();
                end else begin
                    LoanAppraisalParameters.Init();
                    LoanAppraisalParameters."Loan No" := LoanNo;
                    LoanAppraisalParameters.Validate("Appraisal Code", ParameterCode);
                    LoanAppraisalParameters.Validate("Parameter Value", ParameterValue);
                    LoanAppraisalParameters.Insert();
                end;
                ResponseCode := '00';
                LoanAppraisalParameters.Reset();
                LoanAppraisalParameters.SetRange("Loan No", LoanNo);
                if LoanAppraisalParameters.FindSet() then begin
                    ResponseMessage.AddText('{"AppraisalParameters":[');
                    Clear(TempResponse);
                    repeat
                        TempResponse.AddText('{"ParameterCode":"' + LoanAppraisalParameters."Appraisal Code" + '",');
                        TempResponse.AddText('"Description":"' + LoanAppraisalParameters."Parameter Description" + '",');
                        TempResponse.AddText('"Value":"' + Format(LoanAppraisalParameters."Parameter Value") + '"},');
                    until LoanAppraisalParameters.Next() = 0;
                    if STRLEN(FORMAT(TempResponse)) > 1 then
                        ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
                    ResponseMessage.AddText(']}');
                end;
            end else begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Loan Application does not Exist"}');
                exit;
            end;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Appraisal parameter does not Exist"}');
            exit;
        end;
    end;

    procedure GetAppraisalPayslipParameters(var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        AppraisalParameters: Record "Appraisal Parameters";
    begin
        ResponseCode := '00';
        ResponseMessage.AddText('{"AppraisalParaeters":[');
        clear(TempResponse);
        AppraisalParameters.Reset();
        if AppraisalParameters.FindSet() then begin
            repeat
                TempResponse.AddText('{"ParameterCode":"' + AppraisalParameters.Code + '",');
                TempResponse.AddText('"Description":"' + AppraisalParameters.Description + '"},');
            until AppraisalParameters.Next() = 0;
        end;
        if STRLEN(FORMAT(TempResponse)) > 1 then
            ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        ResponseMessage.AddText(']}');
    end;

    procedure SubmitGuarantorRequest(LoanNo: Code[20]; MemberNo: Code[20]; RequestedAmount: Decimal; var ResponseCode: Code[10]; var ResponseMessage: BigText)
    var
        OnlineGuarantorReq, OnlineGuarantorReq1 : Record "Online Guarantor Requests";
        OnlineLoanApplication: Record "Online Loan Application";
        TRespCode: Code[20];
        Member: Record Members;
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        if MemberNo = '' then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide the member you wish to request"}');
            exit;
        end;
        if Member.Get(MemberNo) = false then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide a valid member you wish to request"}');
            exit;
        end;
        if OnlineLoanApplication.Get(LoanNo) then begin
            OnlineGuarantorReq1.Reset();
            OnlineGuarantorReq1.SetRange("Member No", MemberNo);
            OnlineGuarantorReq1.SetRange("Loan No", LoanNo);
            OnlineGuarantorReq1.SetRange("Request Type", OnlineGuarantorReq1."Request Type"::Witness);
            if OnlineGuarantorReq1.FindFirst() then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member is already requested to be a witness"}');
                exit;
            end;
            OnlineGuarantorReq1.Reset();
            OnlineGuarantorReq1.SetRange("Member No", MemberNo);
            OnlineGuarantorReq1.SetRange("Loan No", LoanNo);
            OnlineGuarantorReq1.SetRange("Request Type", OnlineGuarantorReq1."Request Type"::Guarantor);
            if OnlineGuarantorReq1.IsEmpty then begin
                if Member.Get(MemberNo) then begin
                    OnlineGuarantorReq.Init();
                    OnlineGuarantorReq."Loan No" := LoanNo;
                    OnlineGuarantorReq."ID No" := Member."National ID No";
                    OnlineGuarantorReq."Member No" := MemberNo;
                    OnlineGuarantorReq."Member Name" := Member."Full Name";
                    OnlineGuarantorReq."Request Type" := OnlineGuarantorReq."Request Type"::Guarantor;
                    OnlineGuarantorReq."Loan Principal" := OnlineLoanApplication."Applied Amount";
                    OnlineGuarantorReq.PhoneNo := Member."Mobile Phone No.";
                    OnlineGuarantorReq.Applicant := OnlineLoanApplication."Member No.";
                    OnlineGuarantorReq.ApplicantName := OnlineLoanApplication."Member Name";
                    OnlineGuarantorReq."Application Date" := Today;
                    OnlineGuarantorReq."Requested Amount" := RequestedAmount;
                    OnlineGuarantorReq."Product Name" := OnlineLoanApplication."Product Description";
                    OnlineGuarantorReq."Loan Type" := OnlineLoanApplication."Product Code";
                    OnlineGuarantorReq."Created On" := CurrentDateTime;
                    OnlineGuarantorReq.Insert();
                end else begin
                    ResponseCode := '01';
                    ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
                    exit;
                end;
            end;
            if MemberNo = OnlineLoanApplication."Member No." then begin
                ProcessGuarantorRequest(LoanNo, Member."National ID No", 0, RequestedAmount, 0, TRespCode, TempResponse);
            end;
            ResponseCode := '00';
            ResponseMessage.AddText('{"Message":"Guarantor Requested Successfully"}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Application ' + LoanNo + ' does not exist"}');
            exit;
        end;
    end;

    procedure SubmitWitnessRequest(LoanNo: Code[20]; MemberNo: Code[20]; var ResponseCode: Code[10]; var ResponseMessage: BigText)
    var
        OnlineGuarantorReq, OnlineGuarantorReq1 : Record "Online Guarantor Requests";
        OnlineLoanApplication: Record "Online Loan Application";
        Member: Record Members;
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        if MemberNo = '' then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide the member you wish to request"}');
            exit;
        end;
        if Member.Get(MemberNo) = false then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide a valid member you wish to request"}');
            exit;
        end;
        if OnlineLoanApplication.Get(LoanNo) then begin
            OnlineGuarantorReq1.Reset();
            OnlineGuarantorReq1.SetRange("Member No", MemberNo);
            OnlineGuarantorReq1.SetRange("Loan No", LoanNo);
            OnlineGuarantorReq1.SetRange("Request Type", OnlineGuarantorReq1."Request Type"::Guarantor);
            if OnlineGuarantorReq1.FindFirst() then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member is already requested to be a Guarantor"}');
                exit;
            end;
            if MemberNo = OnlineLoanApplication."Member No." then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"You Cannot self-Witness"}');
                exit;
            end;
            OnlineGuarantorReq.Reset();
            OnlineGuarantorReq.SetRange("Loan No", LoanNo);
            if OnlineGuarantorReq.FindSet() then
                OnlineGuarantorReq.DeleteAll();
            OnlineGuarantorReq1.Reset();
            OnlineGuarantorReq1.SetRange("Member No", MemberNo);
            OnlineGuarantorReq1.SetRange("Loan No", LoanNo);
            OnlineGuarantorReq1.SetRange("Request Type", OnlineGuarantorReq1."Request Type"::Witness);
            if OnlineGuarantorReq1.IsEmpty then begin
                if Member.Get(MemberNo) then begin
                    OnlineGuarantorReq.Init();
                    OnlineGuarantorReq."Loan No" := LoanNo;
                    OnlineGuarantorReq."Member No" := MemberNo;
                    OnlineGuarantorReq."ID No" := Member."National ID No";
                    OnlineGuarantorReq."Member Name" := Member."Full Name";
                    OnlineGuarantorReq."Request Type" := OnlineGuarantorReq."Request Type"::Witness;
                    OnlineGuarantorReq."Loan Principal" := OnlineLoanApplication."Applied Amount";
                    OnlineGuarantorReq.PhoneNo := Member."Mobile Phone No.";
                    OnlineGuarantorReq.Applicant := OnlineLoanApplication."Member No.";
                    OnlineGuarantorReq.ApplicantName := OnlineLoanApplication."Member Name";
                    OnlineGuarantorReq."Application Date" := Today;
                    OnlineGuarantorReq."Product Name" := OnlineLoanApplication."Product Description";
                    OnlineGuarantorReq."Loan Type" := OnlineLoanApplication."Product Code";
                    OnlineGuarantorReq."Created On" := CurrentDateTime;
                    OnlineGuarantorReq.Insert();
                end else begin
                    ResponseCode := '01';
                    ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
                    exit;
                end;
            end;
            ResponseCode := '00';
            ResponseMessage.AddText('{"Message":"Witness Requested Successfully"}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Application ' + LoanNo + ' does not exist"}');
            exit;
        end;
    end;

    procedure GetEconomicSectors(var ResponseCode: Code[10]; var ResponseMessage: BigText)
    var
        EconomicSectors: Record "Economic Sectors";
        EconomicSubSectors: Record "Economic Subsectors";
        EconomicSubSubSectors: Record "Economic Sub-subsector";
        TempResp1, TempResp2 : Bigtext;
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        ResponseMessage.AddText('{"EconomicSectors":[');
        EconomicSectors.Reset();
        if EconomicSectors.FindSet() then begin
            Clear(TempResponse);
            repeat
                TempResponse.AddText('{"Code":"' + EconomicSectors."Sector Code" + '",');
                TempResponse.AddText('"Name":"' + EconomicSectors."Sector Name" + '",');
                TempResponse.AddText('"SubSectors":[');
                EconomicSubSectors.Reset();
                EconomicSubSectors.SetRange("Sector Code", EconomicSectors."Sector Code");
                if EconomicSubSectors.FindSet() then begin
                    clear(TempResp1);
                    repeat
                        TempResp1.AddText('{"SubSectorCode":"' + EconomicSubSectors."Sub Sector Code" + '",');
                        TempResp1.AddText('"SubSectorName":"' + EconomicSubSectors."Sub Sector Name" + '",');
                        TempResp1.AddText('"SubSubSectors":[');
                        EconomicSubSubSectors.Reset();
                        EconomicSubSubSectors.SetRange("Sector Code", EconomicSectors."Sector Code");
                        EconomicSubSubSectors.SetRange("Sub Sector Code", EconomicSubSectors."Sub Sector Code");
                        if EconomicSubSubSectors.FindSet() then begin
                            repeat
                                TempResp2.AddText('{"SubSubSectorCode":"' + EconomicSubSubSectors."Sub-Subsector Code" + '",');
                                TempResp2.AddText('"SubSubSectorName":"' + EconomicSubSubSectors."Sub-Subsector Description" + '"},');
                            until EconomicSubSubSectors.Next() = 0;
                            if STRLEN(FORMAT(TempResp2)) > 1 then
                                TempResp1.ADDTEXT(COPYSTR(FORMAT(TempResp2), 1, STRLEN(FORMAT(TempResp2)) - 1));
                        end;
                        TempResp1.AddText(']},');
                    until EconomicSubSectors.Next() = 0;
                    if STRLEN(FORMAT(TempResp1)) > 1 then
                        TempResponse.ADDTEXT(COPYSTR(FORMAT(TempResp1), 1, STRLEN(FORMAT(TempResp1)) - 1));
                end;
                TempResponse.AddText(']},');
            until EconomicSectors.Next() = 0;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        end;
        ResponseMessage.AddText(']}');
        ResponseCode := '00';
    end;

    procedure GetLoanSchedule(LoanNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        LoanSchedule: Record "Repayment Schedule";
        i: Integer;
        RunningBalance, Principle : Decimal;
        LoanApplication: Record "Online Loan Application";
        LoansMgt: Codeunit "Loans Management";
    begin
        i := 1;
        Clear(ResponseCode);
        Clear(ResponseMessage);
        if LoanApplication.get(LoanNo) then begin
            LoansMgt.GenerateOnlineLoanRepaymentSchedule(LoanApplication);
            Principle := LoanApplication."Applied Amount";
            RunningBalance := Principle;
            ResponseMessage.AddText('{"LoanNo":"' + LoanNo + '","PrincipleAmount":"' + Format(Principle) + '","Schedule":[');
            LoanSchedule.Reset();
            LoanSchedule.SetRange("Loan No.", LoanApplication."Application No");
            if LoanSchedule.FindSet() then begin
                repeat
                    TempResponse.AddText('{');
                    TempResponse.AddText('"InstallmentNo":"' + format(i) + '",');
                    TempResponse.AddText('"ExpectedDate":"' + LoanSchedule."Document No." + '",');
                    TempResponse.AddText('"PrincipleAmount":"' + format(LoanSchedule."Principle Repayment") + '",');
                    TempResponse.AddText('"InterestAmount":"' + format(LoanSchedule."Interest Repayment") + '",');
                    TempResponse.AddText('"RunningBalance":"' + format(LoanSchedule."Running Balance") + '"},');
                    i += 1;
                until LoanSchedule.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText(']}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Schedule Has not been created"}');
        end;
    end;

    procedure ProcessGuarantorRequest(LoanNo: Code[20]; IDNo: code[20]; ResponseType: Option Accepted,Reject; Amount: Decimal; RequestType: Option Guarantor,Witness; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        OnlineGuarantors: Record "Online Guarantor Requests";
        SMSMgt: Codeunit "Notifications Management";
        SMSText, SMSNo : text[250];
        Member: Record Members;
        LoanApplication: Record "Online Loan Application";
        LoanGuarantees: Record "Loan Guarantees";
    begin
        Clear(responseCode);
        Clear(ResponseMessage);
        OnlineGuarantors.Reset();
        OnlineGuarantors.SetRange("ID No", IDNo);
        OnlineGuarantors.SetRange("Loan No", LoanNo);
        if RequestType = RequestType::Guarantor then
            OnlineGuarantors.SetRange("Request Type", OnlineGuarantors."Request Type"::Guarantor)
        else
            OnlineGuarantors.SetRange("Request Type", OnlineGuarantors."Request Type"::Witness);
        if OnlineGuarantors.FindSet() then begin
            IDNo := OnlineGuarantors."Member No";
            if ResponseType = ResponseType::Accepted then begin
                OnlineGuarantors.Status := OnlineGuarantors.Status::Accepted;
                if RequestType = RequestType::Witness then begin
                    if LoanApplication.Get(LoanNo) then begin
                        LoanApplication.Validate(Witness, IDNo);
                        LoanApplication.Modify();
                    end;
                end else begin
                    OnlineGuarantors."Amount Accepted" := Amount;
                    LoanGuarantees.Reset();
                    LoanGuarantees.SetRange("Loan No", LoanNo);
                    LoanGuarantees.SetRange("Member No", IDNo);
                    if LoanGuarantees.FindSet() then
                        LoanGuarantees.DeleteAll();
                    if LoanApplication.Get(LoanNo) then begin
                        LoanGuarantees.Init();
                        LoanGuarantees."Loan No" := LoanNo;
                        LoanGuarantees.Validate("Member No", IDNo);
                        LoanGuarantees."Guaranteed Amount" := Amount;
                        LoanGuarantees."Loan Owner" := LoanApplication."Member No.";
                        LoanGuarantees.Insert(true);
                    end;
                end;
            end else
                OnlineGuarantors.Status := OnlineGuarantors.Status::Rejected;
            OnlineGuarantors."Amount Accepted" := Amount;
            OnlineGuarantors."Responded On" := CurrentDateTime;
            OnlineGuarantors.Modify();
            responseCode := '00';
            if Member.Get(OnlineGuarantors.Applicant) then begin
                if OnlineGuarantors."Request Type" = OnlineGuarantors."Request Type"::Guarantor then
                    SMSText := 'Dear ' + Member."Full Name" + ', ' + OnlineGuarantors."Member Name" + ' has accepted your guarantee request'
                else
                    SMSText := 'Dear ' + Member."Full Name" + ', ' + OnlineGuarantors."Member Name" + ' has accepted your loan witness request';
                SMSNo := Member."Mobile Phone No.";
                SMSMgt.SendSms(SMSNo, SMSText);
            end;
            ResponseMessage.AddText('{"Response":"Processed Successfully"}');
        end else begin
            responseCode := '01';
            ResponseMessage.AddText('{"Error":"The Guarantor Request Cannot Be Processed"}');
        end;
    end;

    internal procedure checkMobileBankingRegistration(var MemberNo: Code[20]) Registered: Boolean
    var
        MobileMembers: Record "Mobile Members";
    begin
        MobileMembers.Reset();
        MobileMembers.SetRange("Member No", MemberNo);
        MobileMembers.SetRange("Member Status", MobileMembers."Member Status"::Active);
        Registered := MobileMembers.FindFirst();
        //exit(Registered);
        exit(true);
    end;

    procedure GetMemberGuarantorInformation(var MemberNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Member, Member2 : Record Members;
        Guarantors: Record "Loan Guarantees";
        LoansMgt: Codeunit "Loans Management";
        LoanApplication: Record "Loan Application";
        MemberMgt: Codeunit "Member Management";
        OnlineGuarantorReq: Record "Online Guarantor Requests";
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        if Member.Get(MemberNo) then begin
            if not checkMobileBankingRegistration(MemberNo) then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
                exit;
            end;
            ResponseCode := '00';
            ResponseMessage.AddText('{"MemberName":"');
            ResponseMessage.AddText(Member."Full Name" + '","MyGuarantors":[');
            Clear(TempResponse);
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", Member."Member No.");
            if LoanApplication.FindSet() then begin
                repeat
                    LoanApplication.CalcFields("Loan Balance");
                    if LoanApplication."Loan Balance" > 0 then begin
                        Guarantors.Reset();
                        Guarantors.SetRange("Loan No", LoanApplication."Application No");
                        if Guarantors.FindSet() then begin
                            repeat
                                TempResponse.AddText('{');
                                TempResponse.AddText('"LoanNo":"' + LoanApplication."Application No" + '",');
                                TempResponse.AddText('"GuarantorCode":"' + Guarantors."Member No" + '",');
                                TempResponse.AddText('"GuarantorName":"' + Guarantors."Member Name" + '",');
                                TempResponse.AddText('"GuaranteedAmount":"' + Format(Guarantors."Guaranteed Amount") + '",');
                                TempResponse.AddText('"LoanBalance":"' + Format(LoanApplication."Loan Balance") + '",');
                                TempResponse.AddText('"OutstandingGuarantee":"' + Format(MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", MemberNo)) + '"');
                                TempResponse.AddText('},');
                            until Guarantors.Next() = 0;
                        end;
                    end;
                until LoanApplication.Next = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            Clear(TempResponse);
            ResponseMessage.AddText('],"MyGuarantees":[');
            Guarantors.Reset();
            Guarantors.SetRange("Member No", MemberNo);
            if Guarantors.FindSet() then begin
                repeat
                    if LoanApplication.Get(Guarantors."Loan No") then begin
                        LoanApplication.CalcFields("Loan Balance");
                        if LoanApplication."Loan Balance" > 0 then begin
                            TempResponse.AddText('{');
                            TempResponse.AddText('"LoanNo":"' + LoanApplication."Application No" + '",');
                            TempResponse.AddText('"OwnerNo":"' + LoanApplication."Member No." + '",');
                            TempResponse.AddText('"OwnerName":"' + LoanApplication."Member Name" + '",');
                            TempResponse.AddText('"LoanBalance":"' + format(LoanApplication."Loan Balance") + '",');
                            TempResponse.AddText('"LoanStatus":"' + format(LoanApplication."Loan Classification") + '",');
                            TempResponse.AddText('"GuaranteedAmount":"' + Format(Guarantors."Guaranteed Amount") + '",');
                            TempResponse.AddText('"OutstandingGuarantee":"' + Format(MemberMgt.GetOutstandingGuarantee(LoanApplication."Application No", MemberNo)) + '"');
                            TempResponse.AddText('},');
                        end;
                    end;
                until Guarantors.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText('],"MyRequests":[');
            Clear(TempResponse);
            OnlineGuarantorReq.Reset();
            OnlineGuarantorReq.SetRange(Status, OnlineGuarantorReq.Status::New);
            OnlineGuarantorReq.SetRange("ID No", Member."National ID No");
            if OnlineGuarantorReq.FindSet() then begin
                repeat
                    TempResponse.AddText('{');
                    TempResponse.AddText('"LoanNo":"' + OnlineGuarantorReq."Loan No" + '",');
                    TempResponse.AddText('"LoanPrinciple":"' + format(OnlineGuarantorReq."Loan Principal") + '",');
                    TempResponse.AddText('"Applicant":"' + OnlineGuarantorReq.Applicant + '",');
                    TempResponse.AddText('"ApplicantName":"' + OnlineGuarantorReq.ApplicantName + '",');
                    TempResponse.AddText('"Type":"' + Format(OnlineGuarantorReq."Request Type") + '",');
                    TempResponse.AddText('"RequestedAmount":"' + format(OnlineGuarantorReq."Requested Amount") + '"');
                    TempResponse.AddText('},');
                until OnlineGuarantorReq.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText('],"LoansIHaveWitnessed":[');
            Clear(TempResponse);
            LoanApplication.Reset();
            LoanApplication.SetRange(Witness, Member."Member No.");
            if LoanApplication.FindSet() then begin
                repeat
                    LoanApplication.CalcFields("Loan Balance");
                    if LoanApplication."Loan Balance" > 0 then begin
                        TempResponse.AddText('{');
                        TempResponse.AddText('"LoanNo":"' + LoanApplication."Application No" + '",');
                        TempResponse.AddText('"LoanPrinciple":"' + format(LoanApplication."Approved Amount") + '",');
                        TempResponse.AddText('"OwnerNo":"' + LoanApplication."Member No." + '",');
                        TempResponse.AddText('"OwnerName":"' + LoanApplication."Member Name" + '",');
                        TempResponse.AddText('"LoanType":"' + LoanApplication."Product Description" + '",');
                        TempResponse.AddText('"LoanBalance":"' + format(LoanApplication."Loan Balance") + '"');
                        TempResponse.AddText('},');
                    end;
                until LoanApplication.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText('],"MyWitnesses":[');
            Clear(TempResponse);
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", Member."Member No.");
            if LoanApplication.FindSet() then begin
                repeat
                    LoanApplication.CalcFields("Loan Balance");
                    if LoanApplication."Loan Balance" > 0 then begin
                        if Member2.Get(LoanApplication.Witness) then begin
                            TempResponse.AddText('{');
                            TempResponse.AddText('"LoanNo":"' + LoanApplication."Application No" + '",');
                            TempResponse.AddText('"LoanPrinciple":"' + format(LoanApplication."Approved Amount") + '",');
                            TempResponse.AddText('"WitnessCode":"' + LoanApplication.Witness + '",');
                            TempResponse.AddText('"WitnessName":"' + Member2."Full Name" + '",');
                            TempResponse.AddText('"LoanType":"' + LoanApplication."Product Description" + '",');
                            TempResponse.AddText('"LoanBalance":"' + format(LoanApplication."Loan Balance") + '"');
                            TempResponse.AddText('},');
                        end;
                    end;
                until LoanApplication.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText(']');
            ResponseMessage.AddText('}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
        end;
    end;

    procedure GetMemberNextOfKins(var MemberNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Members: Record Members;
        NextOfKins: Record "Nexts of Kin";
    begin
        Clear(ResponseMessage);
        Clear(ResponseCode);
        if Members.Get(MemberNo) then begin
            if not checkMobileBankingRegistration(MemberNo) then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
                exit;
            end;
            ResponseCode := '00';
            ResponseMessage.AddText('{"FullName":"' + Members."Full Name" + '","NextOfKins":[');
            Clear(TempResponse);
            NextOfKins.Reset();
            NextOfKins.SetRange("Source Code", MemberNo);
            if NextOfKins.FindSet() then begin
                repeat
                    TempResponse.AddText('{');
                    TempResponse.AddText('"KinType":"' + Format(NextOfKins."Kin Type") + '",');
                    TempResponse.AddText('"KinID":"' + NextOfKins."KIN ID" + '",');
                    TempResponse.AddText('"Name":"' + NextOfKins.Name + '",');
                    TempResponse.AddText('"Allocation":"' + Format(NextOfKins.Allocation) + '"');
                    TempResponse.AddText('},');
                until NextOfKins.Next() = 0;
            end;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            ResponseMessage.AddText(']}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
        end;
    end;

    internal procedure PopulateCRBData(MemberIDNo: Code[20]; MembrPhoneNo: Code[20])
    var
        MemberApplication: record "Member Application";
        HtClient: HttpClient;
        URLCode: TextConst ENU = 'https://test-api.ekenya.co.ke/Ushuru_APP_API/crb';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken, JLinesToken, ResultToken : JsonToken;
        JArray: JsonArray;
        JObject, NewJObject : JsonObject;
        JValue: JsonValue;
        i: Integer;
        ResponseText, PayLoad : Text;
        MpesaIntegrations: Codeunit "MPesa Integrations";
    begin
        PayLoad := '{'
            + '"phoneNumber": "' + MembrPhoneNo + '",'
            + '"requestType":"product131",'
            + '"firstName":"Surname 271481",'
            + '"surName":"OtherNames 271481",'
            + '"idNumber":"' + MemberIDNo + '",'
            + '"deviceId":"23454123345461"'
        + '}';
        JObject.ReadFrom(MpesaIntegrations.CallService('crb', URLCode, 2, PayLoad, '', ''));
        Clear(JToken);
        if JObject.Get('data', JLinesToken) then begin
            NewJObject := JLinesToken.AsObject();
            ///Mobiloan Accounts
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'mobiLoanAccounts');
            Message('mobiLoanAccounts %1', ResultToken.AsValue().AsInteger());
            //AverageMobiLoanPrinciple
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'avgMobiLoanPrincipalAmount');
            Message('avgMobiLoanPrincipalAmount %1', ResultToken.AsValue().AsDecimal());
            //MaximumMobiLoanPrinciple
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'maxMobiLoanPrincipalAmount');
            Message('maxMobiLoanPrincipalAmount %1', ResultToken.AsValue().AsDecimal());
        end;
    end;

    procedure PostMobileLoanApplication(var CUSTOMER_NO: Code[20]; var LOAN_PRODUCTCODE: Code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var TRANSACTION_AMOUNT: Decimal; var NARRATION: Code[100]; var REPAYMENTPERIOD: Integer; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        LoanApplication: Record "Loan Application";
        SMSManagement: Codeunit "Notifications Management";
        LoanNo, MemberNumber, FOSAAccount, LoanAccount : Code[20];
        GeneralSetup: Record "Sacco Setup";
        NoSeries: Codeunit NoSeriesManagement;
        MemberMgt: Codeunit "Member Management";
        LoansMgt: Codeunit "Loans Management";
        SMSPhoneNo, SMSText : Text;
        LoanProducts: Record "Product Factory";
    begin
        Clear(ResponseMessage);
        Clear(ResponseCode);
        if LoanProducts.Get(LOAN_PRODUCTCODE) then begin
            if TRANSACTION_AMOUNT > LoanProducts."Maximum Loan Amount" then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Loan Has Exceeded The Maximum Amount"}');
                exit;
            end;
            if REPAYMENTPERIOD > LoanProducts."Maximum Installments" then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The repayment period has exceeded the Maximum allowed Installments"}');
                exit;
            end;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Product Does Not Exist"}');
            exit;
        end;
        if Member.Get(CUSTOMER_NO) then begin
            /*if Member."Fosa Account Activated" = false then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member Does Not have a FOSA Account"}');
                exit;
            end;*/
            MemberNumber := Member."Member No.";
            FOSAAccount := MemberMgt.GetMemberAccount(MemberNumber, 'FOSA');
            if FOSAAccount = 'PHILIPAYEKO' then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member Does Not have a FOSA Account"}');
                exit;
            end;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
            exit;
        end;
        GeneralSetup.Get();
        LoanNo := NoSeries.GetNextNo(GeneralSetup."Loan Application Nos.", Today, true);
        LoanApplication.Init();
        LoanApplication."Application No" := LoanNo;
        LoanApplication.Validate("Member No.", MemberNumber);
        LoanApplication.Validate("Product Code", LOAN_PRODUCTCODE);
        LoanApplication."Application Date" := Today;
        LoanApplication."Posting Date" := Today;
        LoanApplication."Repayment Start Date" := LoansMgt.GetRepaymentStartDate(LoanApplication);
        LoanApplication.Validate(Installments, REPAYMENTPERIOD);
        LoanApplication.Validate("Applied Amount", TRANSACTION_AMOUNT);
        LoanApplication."Approved Amount" := LoanApplication."Applied Amount";
        LoanApplication."Source Type" := LoanApplication."Source Type"::Channels;
        LoanApplication."Mode of Disbursement" := LoanApplication."Mode of Disbursement"::FOSA;
        LoanApplication."Disbursement Account" := FOSAAccount;
        LoanApplication."Loan Account" := LoanAccount;
        LoanApplication."Billing Account" := LoanAccount;
        LoanApplication.Insert();
        LoansMgt.GenerateLoanRepaymentSchedule(LoanApplication);
        LoansMgt.DisburseLoan(LoanApplication);

        IF Member.GET(LoanApplication."Member No.") THEN BEGIN
            SMSPhoneNo := Member."Mobile Phone No.";
            SMSText := 'Dear ' + Member."Full Name" + ' your ' + LoanApplication."Product Description" + ' of Kes. ' + FORMAT(LoanApplication."Approved Amount") + ' has been Disbursed Successfully';
            SMSManagement.SendSms(SMSPhoneNo, SMSText);
        END;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Loan Application Received Successfully","LoanNumber":"'
        + LoanNo + '","DueDate":"' + Format(LoanApplication."Repayment End Date") + '"}');
    end;

    procedure GetMobileTransactionTypes(var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        MobileTransactions: Record "Mobile Transaction Setup";
    begin
        responseCode := '00';
        ResponseMessage.AddText('{"TransactionTypes":[');
        MobileTransactions.Reset();
        if MobileTransactions.findset then begin
            repeat
                ResponseMessage.AddText('{');
                ResponseMessage.AddText('"TransactionCode":"' + MobileTransactions."Transaction Code" + '",');
                ResponseMessage.AddText('"TransactionName":"' + MobileTransactions.Description + '",');
                ResponseMessage.AddText('"ChargeCode":"' + MobileTransactions."Charge Code" + '", ');
                ResponseMessage.AddText('"MinimumAmount":"' + format(MobileTransactions."Minimum Amount") + '",');
                ResponseMessage.AddText('"MaximumAmount":"' + format(MobileTransactions."Maximum Amount") + '"');
                ResponseMessage.AddText('},');
            until MobileTransactions.Next() = 0;
        end;
        ResponseMessage.AddText(']}');
    end;

    procedure LookUpTransactionCharges(var ChargeCode: Code[20]; var TransactionAmount: Decimal; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        SaccoTransactionTypes: Record "Sacco Transaction Types";
        JournalMgt: Codeunit "Journal Management";
        ChargeAmount: Decimal;
    begin
        if SaccoTransactionTypes.Get(ChargeCode) then begin
            ChargeAmount := JournalMgt.GetTransactionCharges(ChargeCode, TransactionAmount);
            ResponseCode := '00';
            ResponseMessage.AddText('{"ChargeAmount":"' + format(ChargeAmount) + '"}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Charge Code Does Not Exist"}');
            exit;
        end;
    end;

    Procedure GetMobiLoanAppraisal(var CUSTOMER_NO: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var NARRATION: code[50]; var NUMBER_OF_MONTHS: integer; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        QualifiedAmount, MinSalary : Decimal;
        VendorLedger: Record "Vendor Ledger Entry";
        Sdate, Edate, TempSdate : Date;
        MobileMembers: Record "Mobile Members";
        LoanApplication: Record "Loan Application";
        LoanProducts: Record "Product Factory";
        MemberMgt: Codeunit "Member Management";
        DetailedLedger: Record "Detailed Vendor Ledg. Entry";
    begin
        clear(ResponseCode);
        Clear(ResponseMessage);
        if LoanProducts.Get(REQUEST_TYPE) = false then begin
            responseCode := '01';
            ResponseMessage.AddText('{"Error":"The Loan Product ' + REQUEST_TYPE + ' does not exist"}');
            exit;
        end;
        LoanProducts.Get(REQUEST_TYPE);
        if Member.Get(CUSTOMER_NO) then begin
            /*if not checkMobileBankingRegistration(CUSTOMER_NO) then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
                exit;
            end;
            if Member."Mobile Loan Blocked" then begin
                responseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member is blocked to Access Mobile Loans"}');
                exit;
            end;
            Member.CalcFields("Total Deposits");
            case LoanProducts."Mobile Appraisal Type" of
                LoanProducts."Mobile Appraisal Type"::"Deposit Multiplier":
                    begin
                        DetailedLedger.Reset();
                        DetailedLedger.SetRange("Vendor No.", MemberMgt.GetMemberAccount(Member."Member No.", 'DEPOSIT'));
                        if DetailedLedger.FindSet() then begin
                            DetailedLedger.CalcSums(Amount);
                            QualifiedAmount := DetailedLedger.Amount * -1 * LoanProducts."Mobile Appraisal Calculator" * 0.01;
                        end;
                        if QualifiedAmount < 0 then
                            QualifiedAmount := 0;
                        //Check 3 Months
                        TempSdate := CalcDate('-3M', Today);
                        TempSdate := CalcDate('-CM', TempSdate);
                        repeat
                            VendorLedger.Reset();
                            VendorLedger.SetRange("Member No.", Member."Member No.");
                            VendorLedger.SetRange("Vendor No.", MemberMgt.GetMemberAccount(Member."Member No.", 'DEPOSIT'));
                            VendorLedger.SetRange("Posting Date", TempSdate, CalcDate('CM', TempSdate));
                            if VendorLedger.IsEmpty then begin
                                responseCode := '01';
                                ResponseMessage.AddText('{"Error":"You Must have been an active Member for the last 3 Months"}');
                                exit;
                            end;
                            TempSdate := CalcDate('1M', TempSdate);
                        until TempSdate >= Today;
                    end;
                LoanProducts."Mobile Appraisal Type"::"Percent of Net Salary":
                    begin
                        //Check 3 Months
                        TempSdate := CalcDate('-3M', Today);
                        repeat
                            VendorLedger.Reset();
                            VendorLedger.SetRange("Member No.", Member."Member No.");
                            VendorLedger.SetRange("Transaction Type", VendorLedger."Transaction Type"::"End Month Salary");
                            VendorLedger.SetRange("Posting Date", TempSdate, CalcDate('CM', TempSdate));
                            if VendorLedger.FindFirst() then begin
                                VendorLedger.CalcFields(Amount);
                                if ((MinSalary = 0) OR (VendorLedger.Amount < MinSalary)) then
                                    MinSalary := VendorLedger.Amount;
                            end else begin
                                responseCode := '01';
                                ResponseMessage.AddText('{"Error":"You Must have been an active Member for the last 3 Months"}');
                                exit;
                            end;
                            TempSdate := CalcDate('1M', TempSdate);
                        until TempSdate >= Today;
                        QualifiedAmount := MinSalary * LoanProducts."Mobile Appraisal Calculator" * 0.01;
                    end;
            end;
            //Check Mobile Membership
            MobileMembers.Reset();
            MobileMembers.SetRange("Member Status", MobileMembers."Member Status"::Active);
            MobileMembers.SetRange("Member No", Member."Member No.");
            if MobileMembers.IsEmpty then begin
                responseCode := '01';
                ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
                exit;
            end;
            if NUMBER_OF_MONTHS > 3 then begin
                responseCode := '01';
                ResponseMessage.AddText('{"Error":"The Repayment Period Cannot Exceed 3 Months"}');
                exit;
            end;
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", Member."Member No.");
            LoanApplication.SetFilter("Loan Balance", '>0');
            LoanApplication.SetFilter("Loan Classification", '<>%1', LoanApplication."Loan Classification"::Performing);
            if LoanApplication.FindFirst() then begin
                responseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member has a defaulted Loan}');
                exit;
            end;
            //Check Deposits
            if QualifiedAmount > 150000 then
                QualifiedAmount := 150000;*/
            QualifiedAmount := 50000;
            responseCode := '00';
            ResponseMessage.AddText('{"QualifiedAmount":"' + format(QualifiedAmount) + '"}');
        end else begin
            responseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
        end;

    end;

    procedure CustomerLookup(var PHONE_NUMBER: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberNo: Code[20];
        Member: Record Members;
        TempResponse: BigText;
    begin
        Clear(TempResponse);
        clear(responseCode);
        clear(ResponseMessage);
        if Member.Get(getMemberNoFromPhoneNo(PHONE_NUMBER)) then begin
            MemberNo := Member."Member No.";
        end else begin
            Member.Reset();
            Member.SetRange("National ID No", PHONE_NUMBER);
            if Member.FindFirst() then
                MemberNo := Member."Member No."
            else begin
                responseCode := '01';
                ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
                exit;
            end;
        end;
        Member.get(MemberNo);
        if not checkMobileBankingRegistration(MemberNo) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
            exit;
        end;
        responseCode := '00';
        ResponseMessage.AddText('{' +
                        '"FIRST_NAME":"' + Member."First Name" + '",' +
                        '"SECOND_NAME":"' + Member."Middle Name" + '",' +
                        '"LAST_NAME":"' + Member."Last Name" + '",' +
                        '"IDENTIFICATION_NUMBER":"' + Member."National ID No" + '",' +
                        '"IDENTIFICATION_TYPE":"National ID",' +
                        '"GENDER":"' + Format(Member.Gender) + '",' +
                        '"EMAIL_ADDRESS":"' + Member."E-Mail Address" + '",' +
                        '"PHYSICAL_ADDRESS":"' + Member.Address + '",' +
                        '"DATE_OF_BIRTH":"' + format(Member."Date of Birth") + '",' +
                        '"CUSTOMER_NO":"' + MemberNo + '"' +
                    '}');
    end;

    procedure AccountsLookup(var ACCOUNT_NUMBER: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberNo: Code[20];
        Member: Record Members;
        TempResponse: BigText;
        Vendor: Record Vendor;
    begin
        Clear(TempResponse);
        clear(responseCode);
        clear(ResponseMessage);
        if Member.get(ACCOUNT_NUMBER) then
            MemberNo := Member."Member No."
        else
            if Member.Get(getMemberNoFromPhoneNo(ACCOUNT_NUMBER)) then begin
                MemberNo := Member."Member No.";
            end else begin
                Member.Reset();
                Member.SetRange("National ID No", ACCOUNT_NUMBER);
                if Member.FindFirst() then
                    MemberNo := Member."Member No."
                else begin
                    responseCode := '01';
                    ResponseMessage.AddText('{"Error":"The Member Does Not Exist"}');
                    exit;
                end;
            end;
        Member.get(MemberNo);
        if not checkMobileBankingRegistration(MemberNo) then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"You are not registered for Mobile Banking"}');
            exit;
        end;
        responseCode := '00';
        ResponseMessage.AddText('{' +
                        '"FIRST_NAME":"' + Member."First Name" + '",' +
                        '"SECOND_NAME":"' + Member."Middle Name" + '","Accounts":[');
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", Member."Member No.");
        IF Vendor.FINDSET THEN BEGIN
            REPEAT
                Vendor.CALCFIELDS(Balance);
                TempResponse.ADDTEXT('{"Code":"' + Vendor."No."
                + '","Description":"' + Vendor.Name
                + '","ShareCapital":"' + FORMAT(Vendor."Share Capital Account")
                + '","CashWithdrawAllowed":"' + FORMAT(Vendor."Cash Withdrawal Allowed")
                + '","CashDepositAllowed":"' + FORMAT(Vendor."Cash Deposit Allowed")
                + '","CashTransferAllowed":"' + FORMAT(Vendor."Cash Transfer Allowed")
                + '","Balance":"' + FORMAT(Vendor.Balance, 0, 1)
                + '"}');
                TempResponse.ADDTEXT(',');
            UNTIL Vendor.NEXT = 0;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        END;
        ResponseMessage.AddText(']}');
    end;

    procedure BalanceInquiry(var ACCOUNT_NUMBER: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberNo: Code[20];
        Member: Record Members;
        TempResponse: BigText;
        Vendor: Record Vendor;
        BookBalance, AvailableBalance : Decimal;
        Charges, BalanceBefore : Decimal;
    begin
        Clear(TempResponse);
        clear(responseCode);
        clear(ResponseMessage);
        if Vendor.get(ACCOUNT_NUMBER) then begin
            BookBalance := 0;
            AvailableBalance := 0;
            responseCode := '00';
            Vendor.CALCFIELDS(Balance, "Uncleared Effects");
            if (BalanceBefore - Charges) < 0 then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
                exit;
            end;
            BookBalance := Vendor.Balance;
            AvailableBalance := BookBalance - Vendor."Uncleared Effects";
            ResponseMessage.AddText('{"AccountNo":"' +
            Vendor."No." + '","AccountBalance":"' + Format(BookBalance) + '","ActualBalance":"' + Format(AvailableBalance) + '"}');
        end else begin
            responseCode := '01';
            ResponseMessage.AddText('{"Error":"The Account Does Not Exist"}');
            exit;
        end;
    end;

    procedure MiniStatement(var ACCOUNT_NUMBER: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var NARRATION: Code[100]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberNo, DrCr : Code[20];
        Member: Record Members;
        TempResponse: BigText;
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        i: integer;
        Charges, BalanceBefore : Decimal;
        OpenningBalance, RunningBalance : Decimal;
        DetailedLedger: Record "Detailed Vendor Ledg. Entry";
        LastDate: Date;
    begin
        Clear(TempResponse);
        clear(responseCode);
        clear(ResponseMessage);
        Vendor.RESET;
        Vendor.SETRANGE("No.", ACCOUNT_NUMBER);
        IF Vendor.FIND('-') THEN BEGIN
            Vendor.CALCFIELDS(Balance);
            if (BalanceBefore - Charges) < 0 then begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
                exit;
            end;
            LastDate := 0D;
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE(Reversed, FALSE);
            VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
            VendorLedgerEntry.SetCurrentKey("Posting Date");
            VendorLedgerEntry.SetAscending("Posting Date", false);
            IF VendorLedgerEntry.FINDSET THEN BEGIN
                REPEAT
                    LastDate := VendorLedgerEntry."Posting Date";
                UNTIL (VendorLedgerEntry.NEXT = 0) OR (i = 8);
            END;
            if LastDate <> 0D then begin
                LastDate := CalcDate('-1D', LastDate);
                DetailedLedger.Reset();
                DetailedLedger.SetFilter("Posting Date", '..%1', LastDate);
                DetailedLedger.SetRange("Vendor No.", Vendor."No.");
                if DetailedLedger.FindSet() then begin
                    DetailedLedger.CalcSums(Amount);
                    OpenningBalance := DetailedLedger.Amount;
                end;
            end else
                OpenningBalance := 0;
            RunningBalance := 0;
            RunningBalance := OpenningBalance;
            responseCode := '00';
            ResponseMessage.ADDTEXT('{"Transactions":[');
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE(Reversed, FALSE);
            VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
            VendorLedgerEntry.SetCurrentKey("Posting Date");
            VendorLedgerEntry.SetAscending("Posting Date", false);
            IF VendorLedgerEntry.FINDSET THEN BEGIN
                i := 1;
                REPEAT
                    DrCr := '';
                    VendorLedgerEntry.CALCFIELDS(Amount);
                    if VendorLedgerEntry.Amount > 0 then
                        DrCr := 'D'
                    else
                        DrCr := 'C';
                    RunningBalance += VendorLedgerEntry.Amount;
                    TempResponse.ADDTEXT('{"transactionID":"' + FORMAT(VendorLedgerEntry."Document No.") + '",');
                    TempResponse.ADDTEXT('"DrCr":"' + DrCr + '",');
                    TempResponse.ADDTEXT('"Description":"' + VendorLedgerEntry.Description + '",');
                    TempResponse.ADDTEXT('"postingDate":"' + FORMAT(VendorLedgerEntry."Posting Date") + '",');
                    TempResponse.ADDTEXT('"postingTime":"' + FORMAT(VendorLedgerEntry."Transaction Time") + '",');
                    TempResponse.ADDTEXT('"amount":"' + FORMAT(ABS(VendorLedgerEntry.Amount), 0, 1) + '",');
                    TempResponse.ADDTEXT('"RunningBalance":"' + FORMAT((RunningBalance), 0, 1) + '"}');
                    TempResponse.ADDTEXT(',');
                    i += 1;
                UNTIL (VendorLedgerEntry.NEXT = 0) OR (i = 8);
                IF STRLEN(FORMAT(TempResponse)) > 1 THEN
                    ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            END;
            ResponseMessage.ADDTEXT(']}');
        END ELSE BEGIN
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Account Does Not Exist"}');
            Exit;
        END;

    end;

    procedure GetFullStatement(var ACCOUNT_NUMBER: code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var NARRATION: Code[100]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        EmailAddress, FilePath, DateFilter, SenderAddress, SenderName, Subject, Body : text[250];
        Receipient: List of [Text];
        Vendor: Record Vendor;
        Member: Record Members;
        AccountFilter: Text[250];
        MemberNo: Code[20];
        BalanceBefore, Charges : Decimal;
        CreditEmailMgt: Codeunit "Credit Email Management";
        MessageBody: BigText;
    begin
        Clear(MessageBody);
        FilePath := 'C:\Attachments\' + ACCOUNT_NUMBER + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        if Vendor.get(ACCOUNT_NUMBER) then begin
            AccountFilter := Vendor."No.";
            MemberNo := Vendor."Member No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.ADDTEXT('{"Response":"The Account ' + ACCOUNT_NUMBER + ' does not exist"}');
            EXIT;
        end;

        if (BalanceBefore - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        CLEAR(ResponseCode);
        CLEAR(ResponseMessage);
        Member.RESET;
        Member.SETRANGE("Member No.", MemberNo);
        Member.SetFilter("Account Filter", AccountFilter);
        IF Member.FINDSET THEN BEGIN
            EmailAddress := '';
            EmailAddress := Member."E-Mail Address";
            EmailAddress := 'ayeko@iansoftltd.com';
            REPORT.SAVEASPDF(Report::"Member Statement", FilePath, Member);
            SenderName := 'eStatemet';
            Receipient.Add(emailAddress);
            Receipient.Add('philipbrs@outlook.com');
            Subject := 'Account Statement ' + DateFilter + ' ' + ACCOUNT_NUMBER;
            MessageBody.AddText('Dear ' + Member."Full Name" + '<br><BR>Please find attached your Statement');
            CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, Receipient, FilePath, 'Account Statement');
            ResponseCode := '00';
            ResponseMessage.ADDTEXT('{"Response":"The Statement has been Mailed"}');
        END ELSE BEGIN
            ResponseCode := '01';
            ResponseMessage.ADDTEXT('{"Response":"The Account ' + ACCOUNT_NUMBER + ' does not exist"}');
            EXIT;
        END;
    end;

    procedure GetLoanStatement(var CUSTOMER_NO: code[20]; var LOAN_PRODUCT_CODE: Code[20]; var CHANNEL_REFERENCE: Code[20]; var REQUEST_TYPE: Code[20]; var TRANSACTION_AMOUNT: Decimal; var NARRATION: Code[200]; var responseCode: Code[20]; var ResponseMessage: BigText)
    var
        EmailAddress, FilePath, DateFilter, SenderAddress, SenderName, Subject, Body : text[250];
        Receipient, ReceipientCC : List of [Text];
        Vendor: Record Vendor;
        CreditEmailMgt: Codeunit "Credit Email Management";
        MessageBody: BigText;
        Member: Record Members;
        AccountFilter: Text[250];
        MemberNo: Code[20];
        LoanApplication: Record "Loan Application";
    begin
        FilePath := 'C:\Attachments\' + CUSTOMER_NO + LOAN_PRODUCT_CODE + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        LoanApplication.Reset();
        LoanApplication.SetRange("Member No.", CUSTOMER_NO);
        LoanApplication.SetRange("Application No", LOAN_PRODUCT_CODE);
        if LoanApplication.FindSet() then begin
            AccountFilter := LoanApplication."Application No";
            MemberNo := CUSTOMER_NO;
        end else begin
            ResponseCode := '01';
            ResponseMessage.ADDTEXT('{"Response":"The Loan ' + LOAN_PRODUCT_CODE + ' does not exist"}');
            EXIT;
        end;
        CLEAR(ResponseCode);
        CLEAR(ResponseMessage);
        Member.RESET;
        Member.SETRANGE("Member No.", MemberNo);
        Member.SetFilter("Loan Filter", AccountFilter);
        IF Member.FINDSET THEN BEGIN
            EmailAddress := '';
            EmailAddress := Member."E-Mail Address";
            EmailAddress := 'ayeko@iansoftltd.com';
            REPORT.SAVEASPDF(Report::"Member Statement", FilePath, Member);
            Receipient.Add(emailAddress);
            Receipient.Add('philipbrs@outlook.com');
            Subject := 'Account Statement ' + DateFilter + ' ' + LOAN_PRODUCT_CODE;
            MessageBody.AddText('Dear ' + Member."Full Name" + ' Please Find attached your loan statement');
            CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, Receipient, FilePath, 'Loan Statement');
            ResponseCode := '00';
            ResponseMessage.ADDTEXT('{"Response":"The Statement has been Mailed"}');
        END ELSE BEGIN
            ResponseCode := '01';
            ResponseMessage.ADDTEXT('{"Response":"The Account ' + MemberNo + ' does not exist"}');
            EXIT;
        END;
    end;

    procedure InterAccountTransfer(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CREDIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists"}');
            exit;
        end;
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if Vendor.get(CREDIT_ACCOUNT_NUMBER) then begin
            CrMember := Vendor."Member No.";
            CrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('300') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);

        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '300';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure InterMemberTransfer(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CREDIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists"}');
            exit;
        end;
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if Vendor.get(CREDIT_ACCOUNT_NUMBER) then begin
            CrMember := Vendor."Member No.";
            CrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('301') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);

        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '301';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure MobileB2CWithdrawal(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists"}');
            exit;
        end;

        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('200') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '200';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure MobileC2BDeposit(Var CREDIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists"}');
            exit;
        end;
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        if Vendor.get(CREDIT_ACCOUNT_NUMBER) then begin
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
            CrMember := Vendor."Member No.";
            CrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Credit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('100') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        BalanceAfter := BalanceBefore - Charges + TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '100';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure AirtimePurchase(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists "' + CHANNEL_REFERENCE + '}');
            exit;
        end;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('400') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '400';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure PesaLink(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists "' + CHANNEL_REFERENCE + '}');
            exit;
        end;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('500') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '500';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure UtilityBills(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var BILL_IDENTIFIER: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists "' + CHANNEL_REFERENCE + '}');
            exit;
        end;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('600') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '600';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions."Utility Code" := BILL_IDENTIFIER;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure CardlessInitiation(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists "' + CHANNEL_REFERENCE + '}');
            exit;
        end;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('650') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '650';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure GoodsPayment(Var DEBIT_ACCOUNT_NUMBER: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: code[20]; var TRANSACTION_AMOUNT: Decimal; var CREDIT_ACCOUNT_CURRENCY: code[20]; var NARRATION: text[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        EntryNo: integer;
        Vendor: record Vendor;
        MobileTransactions: Record "Mobile Transsactions";
        CrMember, DrMember, CrAccount, DrAccount : Code[20];
        BalanceBefore, BalanceAfter, Charges : decimal;
        TransactionTypes: Record "Mobile Transaction Setup";
        JournalMgt: Codeunit "Journal Management";
    begin
        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists "' + CHANNEL_REFERENCE + '}');
            exit;
        end;
        if Vendor.get(DEBIT_ACCOUNT_NUMBER) then begin
            DrMember := Vendor."Member No.";
            DrAccount := Vendor."No.";
            Vendor.CalcFields(Balance);
            BalanceBefore := Vendor.Balance;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Debit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        if TransactionTypes.Get('550') then
            Charges := JournalMgt.GetTransactionCharges(TransactionTypes."Charge Code", TRANSACTION_AMOUNT);
        if (BalanceBefore - TRANSACTION_AMOUNT - Charges) < 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Insufficient Funds"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '550';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := CrAccount;
        MobileTransactions."Cr_Member No" := CrMember;
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure TransactionReversal(Var ORIGINAL_TRANSACTION_REF: Code[20]; var REQUEST_TYPE: code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        LoanApplication: Record "Loan Application";
    begin
        CLEAR(responseCode);
        CLEAR(responseMessage);
        GLEntry.RESET;
        GLEntry.SETRANGE(Reversed, FALSE);
        GLEntry.SETRANGE("Document No.", ORIGINAL_TRANSACTION_REF);
        IF GLEntry.FINDSET THEN BEGIN
            REPEAT
                ReversalEntry.SetHideDialog(TRUE);
                ReversalEntry.SetHideWarningDialogs;
                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
            UNTIL GLEntry.NEXT = 0;
            responseCode := '01';
            responseMessage.ADDTEXT('{"Response":"Successfully Reversed ' + ORIGINAL_TRANSACTION_REF + '"}');
        END ELSE BEGIN
            GLEntry.RESET;
            GLEntry.SETRANGE(Reversed, FALSE);
            GLEntry.SETRANGE("External Document No.", ORIGINAL_TRANSACTION_REF);
            IF GLEntry.FINDSET THEN BEGIN
                REPEAT
                    ReversalEntry.SetHideDialog(TRUE);
                    ReversalEntry.SetHideWarningDialogs;
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                UNTIL GLEntry.NEXT = 0;
                responseCode := '00';
                responseMessage.ADDTEXT('Successfully Reversed ' + ORIGINAL_TRANSACTION_REF);
            END ELSE BEGIN
                responseCode := '01';
                responseMessage.ADDTEXT('{"Response":"Document No not found for Reversal"}');
            END;
            LoanApplication.RESET;
            LoanApplication.SetRange("Cheque No.", ORIGINAL_TRANSACTION_REF);
            IF LoanApplication.FINDSET THEN BEGIN
                LoanApplication.Status := LoanApplication.Status::Reversed;
                LoanApplication.MODIFY;
            END;
        END;
    end;

    internal procedure PostMobileTransactions()
    var
        MobileTransactions: Record "Mobile Transsactions";
        MobileTransactionsSetup: Record "Mobile Transaction Setup";
        PostingDescription: Text[50];
        Dim1, Dim2, Dim3, Dim4, DIm5, Dim6, DIm7, Dim8, JournalBatch, JournalTemplate, DocumentNo : code[20];
        LineNo: Integer;
        PostingDate: Date;
    begin
        JournalBatch := 'ITL-MOBI';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Mobile Transactions');
        MobileTransactions.Reset();
        MobileTransactions.SetRange(Posted, false);
        MobileTransactions.SetCurrentKey("Entry No");
        MobileTransactions.SetAscending("Entry No", false);
        if MobileTransactions.FindSet() then begin
            repeat
                DocumentNo := MobileTransactions."Document No";
                if MobileTransactionsSetup.Get(MobileTransactions."Transaction Type") then begin
                    case MobileTransactions."Transaction Type" of
                        '100'://Cash Deposit
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Cr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Cr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Cr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '200'://Cash Withdrawal
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Withdrawal", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Withdrawal", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Dr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Dr_Account No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '300'://Inter Account Transfer
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Cr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '301'://Inter Member Transfer   
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Cr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '400'://Airtime Purchase  
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Mobile Transactions');
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '500'://Pesa Link
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '600'://Utility Bills
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);

                            end;
                        '550'://Goods Payment
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                            end;
                        '650'://Cardless Initiation
                            begin
                                PostingDate := DT2Date(MobileTransactions."Created On");
                                //Debit Balancing Account
                                PostingDescription := MobileTransactions.Narration;
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    MobileTransactions."Dr_Account No",
                                    PostingDate,
                                    PostingDescription,
                                    MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Dr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    MobileTransactionsSetup."Balancing Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * MobileTransactions.Amount,
                                    Dim1, Dim2,
                                    MobileTransactions."Cr_Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cash Deposit", LineNo, 'MOBI', 'MOBI',
                                    MobileTransactions."Cr_Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.AddCharges(MobileTransactionsSetup."Charge Code",
                                    MobileTransactions."Dr_Account No",
                                    MobileTransactions.Amount,
                                    LineNo,
                                    DocumentNo,
                                    MobileTransactions."Dr_Member No",
                                    'MOBI', 'MOBI', MobileTransactions."Cr_Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);

                            end;
                    end;
                end;
                JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                MobileTransactions.Posted := true;
                MobileTransactions."Posted On" := CurrentDateTime;
                MobileTransactions.Modify();
            until MobileTransactions.Next() = 0;
        end;
    end;
    //------------------ Eclectics Requests
    procedure GetMemberCategories(var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberCategories: Record "Member Categories";
    begin
        CLEAR(ResponseMessage);
        CLEAR(TempResponse);
        CLEAR(ResponseCode);
        ResponseMessage.ADDTEXT('{"Categories":[');
        MemberCategories.RESET;
        IF MemberCategories.FINDSET THEN BEGIN
            ResponseCode := '00';
            REPEAT
                TempResponse.ADDTEXT('{"Code":"' + MemberCategories.Code + '","Description":"' + MemberCategories.Description + '"}');
                TempResponse.ADDTEXT(',');
            UNTIL MemberCategories.NEXT = 0;
        END ELSE
            ResponseCode := '01';
        if STRLEN(FORMAT(TempResponse)) > 1 then
            ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        ResponseMessage.ADDTEXT(']}');
    end;

    procedure GetLoanProducts(var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        LoanProducts: Record "Product Factory";
        InterestBands: Record "Product Interest Bands";
        Tresp: BigText;
    begin
        CLEAR(ResponseMessage);
        CLEAR(TempResponse);
        CLEAR(ResponseCode);
        ResponseMessage.ADDTEXT('{"LoanProducts":[');
        LoanProducts.RESET;
        LoanProducts.SetRange("Product Type", LoanProducts."Product Type"::"Loan Account");
        IF LoanProducts.FINDSET THEN BEGIN
            ResponseCode := '00';
            REPEAT
                TempResponse.AddText('{');
                TempResponse.ADDTEXT('"Code":"' + LoanProducts.Code + '",');
                TempResponse.AddText('"Description":"' + LoanProducts.Name + '",');
                TempResponse.AddText('"MinimumInstallments":"' + Format(LoanProducts."Minimum Installments") + '",');
                TempResponse.AddText('"MaximumInstallments":"' + Format(LoanProducts."Maximum Installments") + '",');
                TempResponse.AddText('"MinimumAmount":"' + Format(LoanProducts."Minimum Loan Amount") + '",');
                TempResponse.AddText('"MaximumAmount":"' + Format(LoanProducts."Maximum Loan Amount") + '",');
                TempResponse.AddText('"MobileLoan":"' + Format(LoanProducts."Mobile Loan") + '",');
                TempResponse.AddText('"InterestRate":[');
                Clear(Tresp);
                InterestBands.Reset();
                InterestBands.SetRange("Product Code", LoanProducts.Code);
                InterestBands.SetRange(Active, true);
                if InterestBands.FindSet() then begin
                    repeat
                        Tresp.AddText('{');
                        Tresp.AddText('"InstallmentFrom":"' + Format(InterestBands."Min Installments") + '",');
                        Tresp.AddText('"InstallmentTo":"' + Format(InterestBands."Max Installments") + '",');
                        Tresp.AddText('"InterestRate":"' + Format(InterestBands."Interest Rate") + '"');
                        Tresp.AddText('},');
                    until InterestBands.Next() = 0;
                end;
                if StrLen(Format(Tresp)) > 0 then
                    TempResponse.ADDTEXT(COPYSTR(FORMAT(Tresp), 1, STRLEN(FORMAT(Tresp)) - 1));
                TempResponse.ADDTEXT(']},');
            UNTIL LoanProducts.NEXT = 0;
        END ELSE
            ResponseCode := '01';
        if StrLen(Format(TempResponse)) > 0 then
            ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        ResponseMessage.ADDTEXT(']}');
    end;

    internal procedure GetInterestRate(LoanProduct: Code[20]) Rate: decimal
    var
        LoanProducts: Record "Product Factory";
        InterestBands: Record "Product Interest Bands";
    begin
        InterestBands.reset;
        InterestBands.SetRange(Active, true);
        InterestBands.SetRange("Product Code", LoanProduct);
        if InterestBands.FindLast() then
            Rate := InterestBands."Interest Rate";
        exit(Rate);
    end;

    procedure LoanRepaymentRequest(var CUSTOMER_NO: code[20]; var LOAN_PRODUCTCODE: Code[20]; var CHANNEL_REFERENCE: code[20]; var REQUEST_TYPE: Code[20]; var TRANSACTION_AMOUNT: Decimal; var NARRATION: Code[50]; var ResponseCode: code[20]; var ResponseMessage: BigText)
    var
        MobileTransactions: record "Mobile Transsactions";
        EntryNo: integer;
        LoanApplication: record "Loan Application";
        BalanceBefore, BalanceAfter, Charges : Decimal;
        DrMember, DrAccount : Code[20];
    begin
        MobileTransactions.Reset();
        if MobileTransactions.FindLast() then
            EntryNo := MobileTransactions."Entry No" + 1
        else
            EntryNo := 1;
        MobileTransactions.Reset();
        MobileTransactions.SetRange("Document No", CHANNEL_REFERENCE);
        if MobileTransactions.FindFirst() then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Transaction already exists"}');
            exit;
        end;

        BalanceBefore := 0;
        BalanceAfter := 0;
        Charges := 0;
        if LoanApplication.Get(LOAN_PRODUCTCODE) then begin
            LoanApplication.CalcFields("Loan Balance");
            BalanceBefore := LoanApplication."Loan Balance";
            DrMember := 'LOAN';
            DrAccount := 'LOAN';
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Credit Account Does Not Exist"}');
            exit;
        end;
        if TRANSACTION_AMOUNT <= 0 then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"Please Provide Transaction Amount"}');
            exit;
        end;
        BalanceAfter := BalanceBefore - Charges - TRANSACTION_AMOUNT;
        MobileTransactions.INIT;
        MobileTransactions."Entry No" := EntryNo;
        MobileTransactions."Transaction Type" := '900';
        MobileTransactions."Document No" := CHANNEL_REFERENCE;
        MobileTransactions."Dr_Account No" := DrAccount;
        MobileTransactions."Dr_Member No" := DrMember;
        MobileTransactions."Cr_Account No" := LoanApplication."Loan Account";
        MobileTransactions."Cr_Member No" := LoanApplication."Member No.";
        MobileTransactions.Amount := TRANSACTION_AMOUNT;
        MobileTransactions."Created By" := userid;
        MobileTransactions."Created On" := CurrentDateTime;
        MobileTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Message":"Transaction Received","BeginningBalance":"' + Format(BalanceBefore)
        + '","Charges":"' + Format(Charges) + '","BalanceAfter":"' + Format(BalanceAfter) + '"}');
    end;

    procedure GetMemberProfile(var RefrenceCode: Code[20]; Var ResponseCode: Code[10]; var ResponseMessage: BigText)
    var
        LoanApplication: Record "Loan Application";
        MemberNo, MemberNo1 : Code[20];
        isMobileLoan: Boolean;
        LoanProducts: Record "Product Factory";
        Witnessname: Text;
        Members2: Record Members;
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        Clear(TempResponse);
        MemberNo := '';
        MemberNo1 := GetMemberNoFromPhoneNo(RefrenceCode);
        if Member.Get(MemberNo1) then
            MemberNo := Member."Member No."
        else begin
            Member.Reset();
            Member.SetRange("Member No.", RefrenceCode);
            if Member.FindFirst() then
                MemberNo := Member."Member No."
            else begin
                Member.Reset();
                Member.SetRange("National ID No", RefrenceCode);
                if Member.FindFirst() then
                    MemberNo := Member."Member No."
                else
                    MemberNo := 'PHILIPAYEKO';
            end;
        end;
        if checkMobileBankingRegistration(MemberNo) = false then begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member is Not registered for Mobile Banking ' + RefrenceCode + '"}');
            exit;
        end;
        IF Member.GET(MemberNo) THEN BEGIN
            IF Member."E-Mail Address" = '' THEN
                Member."E-Mail Address" := 'phi';
            ResponseMessage.ADDTEXT('{"MemberNo":"' + Member."Member No." + '","DateOfRegistration":"' + format(Member."Date of Registration") + '","FullName":"' + Member."Full Name" + '","NationalIDNo":"' + Member."National ID No" + '","PhoneNo":"' + Member."Mobile Phone No." + '","Email":"' + Member."E-Mail Address" + '","Accounts":[');
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."Member No.");
            IF Vendor.FINDSET THEN BEGIN
                ResponseCode := '00';
                REPEAT
                    Vendor.CALCFIELDS(Balance);
                    TempResponse.ADDTEXT('{"Code":"' + Vendor."No."
                    + '","Description":"' + Vendor.Name
                    + '","ShareCapital":"' + FORMAT(Vendor."Share Capital Account")
                    + '","CashWithdrawAllowed":"' + FORMAT(Vendor."Cash Withdrawal Allowed")
                    + '","CashDepositAllowed":"' + FORMAT(Vendor."Cash Deposit Allowed")
                    + '","CashTransferAllowed":"' + FORMAT(Vendor."Cash Transfer Allowed")
                    + '","Balance":"' + FORMAT(Vendor.Balance, 0, 1)
                    + '"}');
                    TempResponse.ADDTEXT(',');
                UNTIL Vendor.NEXT = 0;
                if STRLEN(FORMAT(TempResponse)) > 1 then
                    ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            END;
            ResponseMessage.ADDTEXT(']');
            ResponseMessage.ADDTEXT(',"Loans":[');
            CLEAR(TempResponse);
            LoanApplication.RESET;
            LoanApplication.SETRANGE("Member No.", Member."Member No.");
            IF LoanApplication.FINDSET THEN BEGIN
                REPEAT
                    Witnessname := '';
                    if Members2.Get(LoanApplication.Witness) then
                        Witnessname := Members2."Full Name";
                    if LoanProducts.Get(LoanApplication."Product Code") then
                        isMobileLoan := LoanProducts."Mobile Loan";
                    LoanApplication.CALCFIELDS("Loan Balance", "Monthly Inistallment");
                    TempResponse.ADDTEXT('{"LoanNo":"' + LoanApplication."Application No"
                    + '","Description":"' + LoanApplication."Product Description"
                    + '","PrincipleAmount":"' + FORMAT(LoanApplication."Approved Amount", 0, 1)
                    + '","Installments":"' + FORMAT(LoanApplication.Installments)
                    + '","MonthlyInstallment":"' + FORMAT(ROUND(LoanApplication."Monthly Inistallment", 0.01, '>'), 0, 1)
                    + '","ApplicationDate":"' + FORMAT(LoanApplication."Posting Date")
                    + '","Status":"' + FORMAT(LoanApplication.Status)
                    + '","MobileLoan":"' + FORMAT(isMobileLoan)
                    + '","WitnessCode":"' + LoanApplication.Witness
                    + '","WitnessName":"' + Witnessname
                    + '","DueDate":"' + Format(LoanApplication."Repayment End Date")
                    + '","ControlAccount":"' + LoanApplication."Loan Account"
                    + '","Balance":"' + FORMAT(ROUND(LoanApplication."Loan Balance", 0.01, '>'), 0, 1)
                    + '"}');
                    TempResponse.ADDTEXT(',');
                UNTIL LoanApplication.NEXT = 0;
                if STRLEN(FORMAT(TempResponse)) > 1 then
                    ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            END;
            ResponseMessage.ADDTEXT(']}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"There is No Member Linked to Refrence Number ' + RefrenceCode + '"}');
            Exit;
        end;
    end;

    local procedure getMemberNoFromPhoneNo(PhoneNo: code[20]) MemberNo: Code[20]
    var
        Phone1, Phone2, Phone3, Phone4 : code[20];
    begin
        Phone1 := '';
        Phone2 := '';
        Phone3 := '';
        Phone4 := '';
        IF COPYSTR(PhoneNo, 1, 1) = '0' THEN BEGIN
            Phone1 := PhoneNo;
            Phone2 := '254' + COPYSTR(PhoneNo, 2, STRLEN(PhoneNo));
            Phone3 := '+254' + COPYSTR(PhoneNo, 2, STRLEN(PhoneNo));
            Phone4 := COPYSTR(PhoneNo, 2, STRLEN(PhoneNo));
        END;
        IF ((COPYSTR(PhoneNo, 1, 1) <> '0') AND (STRLEN(PhoneNo) = 9)) THEN BEGIN
            Phone1 := '0' + PhoneNo;
            Phone2 := '254' + COPYSTR(PhoneNo, 2, STRLEN(PhoneNo));
            Phone3 := '+254' + COPYSTR(PhoneNo, 2, STRLEN(PhoneNo));
            Phone4 := PhoneNo;
        END;
        IF COPYSTR(PhoneNo, 1, 3) = '254' THEN BEGIN
            Phone1 := '0' + COPYSTR(PhoneNo, 4, STRLEN(PhoneNo));
            Phone2 := PhoneNo;
            Phone3 := '+' + COPYSTR(PhoneNo, 1, STRLEN(PhoneNo));
            Phone4 := COPYSTR(PhoneNo, 4, STRLEN(PhoneNo));
        END;
        IF COPYSTR(PhoneNo, 1, 4) = '+254' THEN BEGIN
            Phone1 := '0' + COPYSTR(PhoneNo, 5, STRLEN(PhoneNo));
            Phone2 := COPYSTR(PhoneNo, 5, STRLEN(PhoneNo));
            ;
            Phone3 := PhoneNo;
            Phone4 := COPYSTR(PhoneNo, 5, STRLEN(PhoneNo));
        END;
        MemberNo := '';
        IF ((Phone1 = '') AND (Phone2 = '') AND (Phone3 = '') AND (Phone4 = '')) THEN
            EXIT('PHILIPAYEKO');

        Member.RESET;
        Member.SETRANGE("Mobile Phone No.", Phone1);
        IF Member.FINDFIRST = FALSE THEN BEGIN
            Member.RESET;
            Member.SETRANGE("Mobile Phone No.", Phone2);
            IF Member.FINDFIRST = FALSE THEN BEGIN
                Member.RESET;
                Member.SETRANGE("Mobile Phone No.", Phone3);
                IF Member.FINDFIRST = FALSE THEN BEGIN
                    Member.RESET;
                    Member.SETRANGE("Mobile Phone No.", Phone4);
                    IF Member.FINDFIRST = FALSE THEN
                        MemberNo := 'PHILIPAYEKO'
                    ELSE
                        MemberNo := Member."Member No.";
                END ELSE
                    MemberNo := Member."Member No.";
            END ELSE
                MemberNo := Member."Member No.";
        END ELSE
            MemberNo := Member."Member No.";
        IF Member.GET(MemberNo) THEN
            EXIT(MemberNo)
        ELSE
            EXIT('PHILIPAYEKO');

    end;

    procedure ProcessReversal(var RequestID: code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        GLEntry: Record "G/L Entry";
        ReversalEntry: Record "Reversal Entry";
        LoanApplication: Record "Loan Application";
    begin
        CLEAR(responseCode);
        CLEAR(responseMessage);
        GLEntry.RESET;
        GLEntry.SETRANGE(Reversed, FALSE);
        GLEntry.SETRANGE("Document No.", requestID);
        IF GLEntry.FINDSET THEN BEGIN
            REPEAT
                ReversalEntry.SetHideDialog(TRUE);
                ReversalEntry.SetHideWarningDialogs;
                ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
            UNTIL GLEntry.NEXT = 0;
            responseCode := '00';
            responseMessage.ADDTEXT('{"Response":"Successfully Reversed ' + requestID + '"}');
        END ELSE BEGIN
            GLEntry.RESET;
            GLEntry.SETRANGE(Reversed, FALSE);
            GLEntry.SETRANGE("External Document No.", requestID);
            IF GLEntry.FINDSET THEN BEGIN
                REPEAT
                    ReversalEntry.SetHideDialog(TRUE);
                    ReversalEntry.SetHideWarningDialogs;
                    ReversalEntry.ReverseTransaction(GLEntry."Transaction No.");
                UNTIL GLEntry.NEXT = 0;
                responseCode := '00';
                responseMessage.ADDTEXT('Successfully Reversed ' + requestID);
            END ELSE BEGIN
                responseCode := '01';
                responseMessage.ADDTEXT('{"Response":"Document No not found for Reversal"}');
            END;
            LoanApplication.RESET;
            LoanApplication.SetRange("Cheque No.", RequestID);
            IF LoanApplication.FINDSET THEN BEGIN
                LoanApplication.Status := LoanApplication.Status::Reversed;
                LoanApplication.MODIFY;
            END;
        END;

    end;

    procedure GetMemberImage(var PhoneNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Customer: Record Members;
        FileName: Text[250];
        Ostream: OutStream;
        ExportFile: File;
        MediaResourcesMgt: Codeunit "Media Resources Mgt.";
        iStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
    begin
        CLEAR(responseCode);
        CLEAR(responseMessage);
        IF Customer.GET(GetMemberNoFromPhoneNo(PhoneNo)) THEN BEGIN
            Customer.CalcFields("Member Image");
            responseCode := '00';
            responseMessage.ADDTEXT('{"Image":"');
            IF Customer."Member Image".HasValue THEN BEGIN
                FileName := 'C:\Attachments\' + FORMAT(Customer."Member No.") + '.png';
                Customer."Member Image".Export(FileName);
                IF ExportFile.OPEN(FileName) THEN BEGIN
                    ExportFile.CREATEINSTREAM(iStream);
                    responseMessage.AddText(Base64Convert.ToBase64(iStream));
                    ExportFile.CLOSE;
                END;
            END;
            responseMessage.ADDTEXT('"}');
        END ELSE BEGIN
            responseCode := '01';
            responseMessage.ADDTEXT('{"Response":"The Member Does Not Exist"}');
        END;
    end;
    //ATM Functions
    procedure ATMGetBookBalance(var cardNumber: code[100]; var ResponseCode: code[20]; var ResponseMessage: BigText)
    var
        Bal: Decimal;
        AccountTypesSetup: Record "Product Factory";
    begin
        CLEAR(ResponseCode);
        Bal := 0;
        CLEAR(ResponseMessage);
        Vendor.RESET;
        Vendor.SETRANGE("Card No", cardNumber);
        IF Vendor.FINDFIRST THEN BEGIN
            IF AccountTypesSetup.GET(Vendor."Account Code") THEN;
            Vendor.CALCFIELDS(Balance);
            Bal := Vendor.Balance;
            IF Bal < 0 THEN
                Bal := 0;
            ResponseCode := '00';
            ResponseMessage.AddText('{"BookBalance":"' + format(bal, 0, 1) + '"}');
            exit;
        END ELSE BEGIN
            ResponseCode := '01';
            ResponseMessage.AddText('{"StatusDescription":"Card Does Not Exist"}');
            exit;
        end;
    end;

    procedure ATMWithdaw(Var tranType: Code[50]; Var processCode: Code[50]; Var termId: Code[50]; Var Trace: Code[50]; Var ReversalTraceID: Code[50]; Var Reversed: Code[50]; Var CardNumber: Code[50]; Var transactionDescription: Code[50]; Var Amount: Decimal; Var atmLocation: Code[50]; Var cardAcceptorterminalId: Code[50]; Var iTransType: Code[50]; Var isCoopBankAtm: Code[50]; Var refNo: Code[50]; Var cardAccountNumber: Code[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        ATMTransactions: record "ATM Transactions";
        EntryNo: integer;
    Begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        EntryNo := 1;
        ATMTransactions.RESET;
        IF ATMTransactions.FINDLAST THEN
            EntryNo := ATMTransactions."Entry No." + 1;
        ATMTransactions.INIT;
        ATMTransactions."Entry No." := EntryNo;
        ATMTransactions."Trace ID" := Trace;
        ATMTransactions."Posting Date" := TODAY;
        ATMTransactions."Account No" := cardAccountNumber;
        ATMTransactions.Description := transactionDescription;
        ATMTransactions.Amount := Amount;
        ATMTransactions."Posting S" := transactionDescription;
        ATMTransactions.Posted := FALSE;
        ATMTransactions."Unit ID" := termId;
        ATMTransactions."Transaction Type" := iTransType;
        ATMTransactions."Trans Time" := FORMAT(TIME);
        ATMTransactions."Transaction Time" := TIME;
        ATMTransactions."Transaction Date" := TODAY;
        ATMTransactions.Source := 0;
        ATMTransactions.Reversed := FALSE;
        ATMTransactions."Reversed Posted" := FALSE;
        ATMTransactions."Reversal Trace ID" := ReversalTraceID;
        ATMTransactions."Transaction Description" := transactionDescription;
        ATMTransactions."Withdrawal Location" := atmLocation;
        CASE UPPERCASE(transactionDescription) OF
            'POS-CASH WITHDRAWAL':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"POS - Cash Withdrawal";
            'CASH W/D - COOP BANK':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"Cash Withdrawal - Coop ATM";
            'CASH W/D - VISA ATM':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"Cash Withdrawal - VISA ATM";
            'POS NORMAL PURCHASE':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"POS - Normal Purchase";
            'POS-BALANCE ENQUIRY':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"POS - Balance Enquiry";
            'UTILITY PAYMENT':
                ATMTransactions."Transaction Type Charges" := ATMTransactions."Transaction Type Charges"::"Utility Payment";
        END;
        ATMTransactions."Card Acceptor Terminal ID" := cardAcceptorterminalId;
        ATMTransactions."ATM Card No" := CardNumber;
        IF Vendor.GET(cardAccountNumber) THEN
            ATMTransactions."Customer Names" := Vendor."Search Name";
        ATMTransactions."Process Code" := processCode;
        ATMTransactions."Reference No" := refNo;
        ATMTransactions."Is Coop Bank" := (isCoopBankAtm = '0');
        //ATMTransactions."POS Vendor":=FALSE;
        ATMTransactions.INSERT;
        ResponseCode := '00';
        ResponseMessage.AddText('{"Status":"Received Successfully"}');
    end;

    procedure ATMGetUnclearedEffects(var CardAccountNumber: code[50]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Vendor: Record Vendor;
    begin
        CLEAR(ResponseMessage);
        Clear(ResponseCode);
        Vendor.RESET;
        Vendor.SETRANGE("No.", CardAccountNumber);
        IF Vendor.FINDFIRST THEN BEGIN
            ResponseCode := '00';
            Vendor.CALCFIELDS("Uncleared Effects");
            ResponseMessage.ADDTEXT('{"UnclearedEffects":"' + Format(Vendor."Uncleared Effects", 0, 1) + '"}');
        END ELSE begin
            ResponseCode := '01';
            ResponseMessage.ADDTEXT('{"Error":"0"}');
        end;
    end;

    procedure ATMGetLinkedCardInfo(var cardNumber: Code[100]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Vendor: Record Vendor;
    begin
        clear(ResponseCode);
        Clear(ResponseMessage);
        Vendor.RESET;
        Vendor.SETRANGE("Card No", cardNumber);
        IF Vendor.FIND('-') THEN BEGIN
            if Member.Get(Vendor."Member No.") then begin
                ResponseCode := '00';
                ResponseMessage.AddText('{"Status":"1","CardHolderName":"' + Member."Full Name" + '","AccountCanWithdraw":"Yes","LinkedAccountNumber":"' + Vendor."No." + '"}');
            end else begin
                ResponseCode := '01';
                ResponseMessage.AddText('{"Status":"0","CardHolderName":"","AccountCanWithdraw":"No","LinkedAccountNumber":""}');
            end;
        END ELSE BEGIN

            ResponseCode := '01';
            ResponseMessage.AddText('{"Status":"0","CardHolderName":"","AccountCanWithdraw":"No","LinkedAccountNumber":""}');

        END;
    end;

    local procedure ATMGetChargeCode(TransactionNo: code[20]) ChargeCode: Code[20]
    var
        ATMTransactions: Record "ATM Transactions";
        ATMCards: Record "ATM Cards";
        ATMTypes: Record "ATM Types";
    begin
        ChargeCode := '';
        ATMTransactions.RESET;
        ATMTransactions.SETRANGE("Reference No", TransactionNo);
        ATMTransactions.SETRANGE(Reversed, FALSE);
        IF ATMTransactions.FINDSET THEN BEGIN
            ATMCards.RESET;
            ATMCards.SETRANGE("Card No.", ATMTransactions."ATM Card No");
            IF ATMCards.FINDFIRST THEN BEGIN
                IF ATMTypes.GET(ATMCards."ATM Type") THEN BEGIN
                    CASE ATMTransactions."Transaction Type Charges" OF
                        ATMTransactions."Transaction Type Charges"::"Airtime Purchase":
                            ChargeCode := ATMTypes."Airtime Purchase T. Code";
                        ATMTransactions."Transaction Type Charges"::"Balance Enquiry":
                            ChargeCode := '';
                        ATMTransactions."Transaction Type Charges"::"Cash Withdrawal - Coop ATM":
                            ChargeCode := ATMTypes."Withdrawal T. Code (Coop)";
                        ATMTransactions."Transaction Type Charges"::"Cash Withdrawal - VISA ATM":
                            ChargeCode := ATMTypes."Withdrawal T. Code (VISA)";
                        ATMTransactions."Transaction Type Charges"::"Mini Statement":
                            ChargeCode := '';
                        ATMTransactions."Transaction Type Charges"::"POS - Balance Enquiry":
                            ChargeCode := ATMTypes."POS Balance Enquiry T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Benefit Cash Withdrawal":
                            ChargeCode := ATMTypes."POS Benefit CW T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Cash Deposit":
                            ChargeCode := ATMTypes."POS Cash Deposit T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Cash Deposit to Card":
                            ChargeCode := ATMTypes."POS Card Deposit T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Cash Withdrawal":
                            ChargeCode := ATMTypes."POS Cash Withdrawal T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - M Banking":
                            ChargeCode := ATMTypes."POS M Banking T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Mini Statement":
                            ChargeCode := ATMTypes."POS Ministatement T. Code";
                        ATMTransactions."Transaction Type Charges"::"POS - Normal Purchase":
                            ChargeCode := ATMTypes."POS Purchase T. Code (Normal)";
                        ATMTransactions."Transaction Type Charges"::"POS - Purchase With Cash Back":
                            ChargeCode := ATMTypes."POS Purchase T. Code (CBack)";
                        ATMTransactions."Transaction Type Charges"::"POS - School Payment":
                            ChargeCode := ATMTypes."POS School Payment T. Code";
                        ATMTransactions."Transaction Type Charges"::"Utility Payment":
                            ChargeCode := ATMTypes."Utility Payments T. Code";
                    END;
                END;
            END;
        END;
        exit(ChargeCode);
    end;

    local procedure GetSettlmentAccount(CardNo: code[50]) SettlementAccount: code[20]
    var
        ATMCards: Record "ATM Cards";
        ATMTypes: Record "ATM Types";
    begin
        ATMCards.RESET;
        ATMCards.SETRANGE("Card No.", CardNo);
        IF ATMCards.FINDFIRST THEN BEGIN
            IF ATMTypes.GET(ATMCards."ATM Type") THEN
                SettlementAccount := ATMTypes."ATM Settlment Account"
            ELSE
                SettlementAccount := 'BN0007';
        END ELSE
            SettlementAccount := 'BN0007';
        EXIT(SettlementAccount);
    end;

    local procedure SendSMSNotification(ATMTransactions: Record "ATM Transactions")
    var
        Member: Record Members;
        Vendor: Record Vendor;
        SMSManagement: Codeunit "Notifications Management";
        SMSPhoneNo, SMSText : Text[300];
    begin
        IF Vendor.GET(ATMTransactions."Account No") THEN BEGIN
            IF Member.GET(Vendor."Member No.") THEN BEGIN
                SMSPhoneNo := Member."Mobile Phone No.";
                IF NOT ATMTransactions.Reversed THEN
                    SMSText := 'Dear ' + Member."Full Name" + ' your ' + FORMAT(ATMTransactions."Transaction Type Charges") + ' of Kes. ' + FORMAT(ATMTransactions.Amount) + ' has been processed Successfully'
                ELSE
                    SMSText := 'Dear ' + Member."Full Name" + ' your ' + FORMAT(ATMTransactions."Transaction Type Charges") + ' of Kes. ' + FORMAT(ATMTransactions.Amount) + ' has been Reversed Successfully';
                SMSManagement.SendSms(SMSPhoneNo, SMSText);
            END;
        END;

    end;

    internal procedure PostATMTransactions()
    var
        ATMTransactions: Record "ATM Transactions";
    begin
        ATMTransactions.Reset();
        ATMTransactions.SetRange(Posted, false);
        if ATMTransactions.FindSet() then begin
            repeat
                PostATMTransaction(ATMTransactions."Reference No");
            until ATMTransactions.Next() = 0;
        end;
    end;

    internal procedure PostATMTransaction(TransactionNo: code[20])
    var
        JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, ChargeCode, Dim6, Dim7, Dim8, MemberNumber, DocumentNo, AccountNumber, ExternalDocumentNo : code[20];
        isReversal: Boolean;
        LineNo: Integer;
        ATMTransactions: Record "ATM Transactions";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        JournalManagement: Codeunit "Journal Management";
        PostingDate: Date;
        PostingAmount: Decimal;
        PostingDescription: Text;
    begin
        JournalBatch := 'ATM';
        IF isReversal THEN
            JournalBatch := 'ATM-REV';
        JournalTemplate := 'PAYMENT';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'ATM Transactions');
        Dim1 := '';
        Dim2 := '';
        ATMTransactions.RESET;
        ATMTransactions.SETRANGE("Reference No", TransactionNo);
        ATMTransactions.SETRANGE(Reversed, isReversal);
        IF ATMTransactions.FINDSET THEN BEGIN
            IF ATMTransactions.Reversed THEN
                DocumentNo := 'R:' + TransactionNo
            ELSE
                DocumentNo := TransactionNo;
            BankAccountLedgerEntry.RESET;
            BankAccountLedgerEntry.SETRANGE("Document No.", DocumentNo);
            BankAccountLedgerEntry.SETRANGE(Reversed, FALSE);
            IF BankAccountLedgerEntry.ISEMPTY THEN BEGIN
                //Debit Member
                AccountNumber := ATMTransactions."Account No";
                PostingDate := ATMTransactions."Posting Date";
                IF Vendor.GET(ATMTransactions."Account No") THEN
                    MemberNumber := Vendor."Member No.";
                PostingAmount := ATMTransactions.Amount;
                IF ATMTransactions.Reversed THEN
                    PostingDescription := 'R:' + COPYSTR(ATMTransactions."Transaction Description" + ' at ' + ATMTransactions."Withdrawal Location", 1, 50)
                ELSE
                    PostingDescription := COPYSTR(ATMTransactions."Transaction Description" + ' at ' + ATMTransactions."Withdrawal Location", 1, 50);
                ExternalDocumentNo := TransactionNo;
                PostingAmount := ATMTransactions.Amount;
                LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Vendor,
                            ATMTransactions."Account No",
                            PostingDate,
                            PostingDescription,
                            PostingAmount,
                            Dim1, Dim2,
                            MemberNumber,
                            DocumentNo,
                            GlobalTransactionType::ATM, LineNo, 'MOBI', 'MOBI',
                            MemberNumber,
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                //Credit Settlement    
                AccountNumber := GetSettlmentAccount(ATMTransactions."ATM Card No");
                LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"Bank Account",
                            AccountNumber,
                            PostingDate,
                            PostingDescription,
                            -1 * PostingAmount,
                            Dim1, Dim2,
                            MemberNumber,
                            DocumentNo,
                            GlobalTransactionType::ATM, LineNo, 'MOBI', 'MOBI',
                            MemberNumber,
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                //Charges
                ChargeCode := '';
                ChargeCode := ATMGetChargeCode(TransactionNo);
                LineNo := JournalManagement.AddCharges(ChargeCode,
                    ATMTransactions."Account No",
                    ATMTransactions.Amount,
                    LineNo,
                    DocumentNo,
                    MemberNumber,
                    'MOBI', 'MOBI', MemberNumber, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                //CreateCharges                
                JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                ATMTransactions.Posted := TRUE;
                ATMTransactions.MODIFY;
            END ELSE BEGIN
                ATMTransactions.Posted := TRUE;
                ATMTransactions.MODIFY;
            END;
        END;
    end;

    var
        TempResponse: BigText;
        Member: Record Members;
        Vendor: Record Vendor;
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        JournalManagement: Codeunit "Journal Management";
}
codeunit 90005 "Global Event Subscribers"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, 90075, 'OnAfterInsertEvent', '', true, true)]
    internal procedure SendGuarantorRequestCommunication(RunTrigger: Boolean; var Rec: Record "Online Guarantor Requests")
    var
        SMSText, SMSNo : Text;
        Notifications: Codeunit "Notifications Management";
        Members, Members2 : Record Members;
        LoanApplication: Record "Online Loan Application";
        Portal: Codeunit PortalIntegrations;
        RespCode: Code[20];
        GuarantorRequest: Record "Online Guarantor Requests";
    begin
        GuarantorRequest := Rec;
        if Members.Get(GuarantorRequest."Member No") then begin
            if LoanApplication.get(GuarantorRequest."Loan No") then begin
                if Members2.Get(LoanApplication."Member No.") then begin
                    if Members."Member No." = Members2."Member No." then
                        Portal.ProcessGuarantorRequest(GuarantorRequest."Loan No", Members."National ID No", 0, GuarantorRequest.AppliedAmount, 0, RespCode);
                end;
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Member Management", 'OnAfterCreateMember', '', true, true)]
    local procedure UpdateEmployeeDetails(var MemberApplication: Record "Member Application")
    var
        Employee: Record Employee;
        NotificationsMGT: Codeunit "Notifications Management";
        SMSText, SMSNo : Text[150];
        CompanyInfo: Record "Company Information";
    begin
        /*Employee.Reset();
        Employee.SetRange();*/
        SMSNo := MemberApplication."Mobile Phone No.";
        SMSText := 'Dear ' + MemberApplication."Full Name" + ' Welcome to ' + CompanyInfo.Name + ' your member number is ' + MemberApplication."Member No."
        + ' for any inquiries, contact ' + CompanyInfo."Phone No.";
        NotificationsMGT.SendSms(SMSNo, SMSText);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        LoanApplication: Record "Loan Application";
        MemberApplication: Record "Member Application";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Loan Application":
                begin
                    RecRef.Open(Database::"Loan Application");
                    if LoanApplication.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(LoanApplication);
                end;
            DATABASE::"Member Application":
                begin
                    RecRef.Open(Database::"Member Application");
                    if MemberApplication.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(MemberApplication);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', true, true)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: code[20];
    begin
        case RecRef.Number of
            DATABASE::"Loan Application":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Member Application":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Loans Management", 'OnAfterPostLoan', '', true, true)]
    procedure OnAfterPostLoan(var LoanApplication: Record "Loan Application")
    var
        PhoneNo: Text[250];
        SMS: Text[250];
        Members: Record Members;
        Amnt: Decimal;
        CompanyInformation: Record "Company Information";
        LoanSchedule: Record "Loan Schedule";
        MInstallment: Decimal;
        NotificationsMgt: Codeunit "Notifications Management";
    begin
        LoanSchedule.Reset();
        LoanSchedule.SetRange("Loan No.", LoanApplication."Application No");
        if LoanSchedule.FindFirst() then
            MInstallment := round(LoanSchedule."Monthly Repayment", 1, '>');
        SMS := 'Dear ' + LoanApplication."Member Name" + ' Your ' + LoanApplication."Product Description" + ' of Ksh. ' + Format(LoanApplication."Approved Amount")
        + ' has been posted. Your Monthly Installment Ksh. '
        + Format(MInstallment) + ' Payable from ' + Format(LoanApplication."Repayment Start Date") + '. Thank You';
        if Members.get(LoanApplication."Member No.") then begin
            PhoneNo := Members."Mobile Phone No.";
            if PhoneNo <> '' then begin
                NotificationsMgt.SendSms(PhoneNo, SMS);
            end
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Loans Management", 'OnAfterAcceptCollateral', '', true, true)]
    local procedure OnAfterAcceptCollateral(CollateralApplication: Record "Collateral Application")
    var
        PhoneNo: Text[250];
        SMS: Text[250];
        Members: Record Members;
        Amnt: Decimal;
        CompanyInformation: Record "Company Information";
        LoanSchedule: Record "Loan Schedule";
        MInstallment: Decimal;
        NotificationsMgt: Codeunit "Notifications Management";
    begin
        SMS := 'Dear ' + CollateralApplication."Member Name" + ' Your ' + CollateralApplication."Collateral Description"
        + ' has been successfully Received and will be used to guarantee you a loan to the tune of Ksh.'
        + Format(CollateralApplication.Guarantee) + '. Thank You';
        if Members.get(CollateralApplication."Member No") then begin
            if PhoneNo <> '' then begin
                PhoneNo := Members."Mobile Phone No.";
                NotificationsMgt.SendSms(PhoneNo, SMS);
            end
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Member Management", 'OnAfterCreateMember', '', true, true)]
    local procedure SendSMS(var MemberApplication: Record "Member Application"; Member: Record Members)
    VAR
        SMSText: Text[250];
        SMSNo: Text[250];
        NotificationMgt: Codeunit "Notifications Management";
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get;
        SMSText := 'Dear ' + MemberApplication."Full Name" + ' Welcome to ' + CompanyInfo.Name + '. Your Member No. is '
        + Member."Member No." + '.Thank you for choosing us';
        SMSNo := MemberApplication."Mobile Phone No.";
        NotificationMgt.SendSms(SMSNo, SMSText);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendLoanApplicationForApproval', '', true, true)]
    local procedure SendEmailOnLoanAcceptance(var LoanApplication: Record "Loan Application")
    var
        Member: Record Members;
        Receipient: List of [Text];
        SenderName, SenderID, Subject, Body : Text[100];
        CreditEmailMgt: Codeunit "Credit Email Management";
        MessageBody: BigText;
        CompanyInfo: Record "Company Information";
        SMS: Codeunit "Notifications Management";
        SMSPhone, SMSText : Text[250];
    begin
        Clear(MessageBody);
        CompanyInfo.get;
        if Member.Get(LoanApplication."Member No.") then begin
            SMSPhone := Member."Mobile Phone No.";
            SMSText := 'Dear ' + Member."Full Name" + 'Your ' + LoanApplication."Product Description" + ' application of ' + Format(LoanApplication."Applied Amount") + ' has been received and is being processed.';
            SMS.SendSms(SMSPhone, SMSText);
            SenderName := CompanyInfo.Name;
            Receipient.Add(Member."E-Mail Address");
            Subject := 'Loan Processing';
            MessageBody.AddText('Dear ' + Member."Full Name");
            MessageBody.AddText('<BR><BR>');
            MessageBody.AddText('Your ' + LoanApplication."Product Description" + ' application of ' + Format(LoanApplication."Applied Amount") + ' has been received and is being processed.');
            CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, Receipient, '', 'Account Statement');
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure SendEmailOnDocumentApproval(RecRef: RecordRef)
    var
        LoanApplication: Record "Loan Application";
        Member: Record Members;
        Receipient: List of [Text];
        SenderName, SenderID, Subject, Body : Text[100];
        MessageBody: BigText;
        CompanyInfo: Record "Company Information";
        SMS: Codeunit "Notifications Management";
        SMSPhone, SMSText : Text[250];
        CreditEmailMgt: Codeunit "Credit Email Management";
    begin
        case RecRef.Number of
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    CompanyInfo.get;
                    if Member.Get(LoanApplication."Member No.") then begin
                        SMSPhone := Member."Mobile Phone No.";
                        SMSPhone := '0729143665';
                        SMSText := 'Dear ' + Member."Full Name" + 'Your ' + LoanApplication."Product Description" + ' application of ' + Format(LoanApplication."Applied Amount") + ' has been approved.';
                        SMS.SendSms(SMSPhone, SMSText);
                        SenderName := CompanyInfo.Name;
                        //Receipient.Add(Member."E-Mail Address");
                        Receipient.Add('ayeko@iansoftltd.com');
                        Subject := 'Loan Processing';
                        MessageBody.AddText('Dear ' + Member."Full Name");
                        MessageBody.AddText('<BR><BR>');
                        MessageBody.AddText('Your ' + LoanApplication."Product Description" + ' application of ' + Format(LoanApplication."Applied Amount") + ' has been approved.');
                        CreditEmailMgt.SendEmail(MessageBody, Subject, Receipient, Receipient, '', 'Account Statement');
                    end;
                end;
        end;
    end;

    var
        myInt: Integer;
}
codeunit 90006 "Journal Management"
{
    trigger OnRun()
    begin

    end;

    procedure PrepareJournal(JournalTemplate: Code[20]; JournalBatch: Code[20]; Description: Text[50]) LineNo: Integer
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if not GenJournalTemplate.Get(JournalTemplate) then begin
            GenJournalTemplate.Init();
            GenJournalTemplate.Name := JournalTemplate;
            GenJournalTemplate.Description := 'SACCO Batches';
            GenJournalTemplate.Type := GenJournalTemplate.Type::General;
            GenJournalTemplate.Insert();
        end;
        if not GenJournalBatch.Get(JournalTemplate, JournalBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Description := Description;
            GenJournalBatch.Insert();
        end;
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();
        LineNo := 10000;
        exit(LineNo);
    end;

    procedure AddCharges(ChargeCode: Code[20]; DebitAccount: Code[20]; BaseAmount: Decimal; LineNo: Integer; DocumentNo: Code[20]; MemberNo: code[20]; SourceCode: Code[20]; ReasonCode: Code[20]; ExternalDocumentNo: Code[20]; JournalBatch: Code[20]; JournalTemplate: Code[20];
    Dim1: Code[20]; Dim2: Code[20]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; Dim6: Code[20]; Dim7: Code[20]; Dim8: Code[20]; PostingDate: Date; SelfBalancing: Boolean) EntyNo: Integer
    var
        SaccoTTypes: Record "Sacco Transaction Types";
        TransactionCharges: Record "Transaction Charges";
        TransactionCalcScheme, TransactionCalcScheme1 : Record "Transaction Calc. Scheme";
        TempBase, PostingAmount : Decimal;
        AccountNumber: code[20];
        PostingDescription: Text[50];
    begin
        TransactionCharges.RESET;
        TransactionCharges.SETRANGE("Transaction Code", ChargeCode);
        IF TransactionCharges.FindSet() THEN BEGIN
            REPEAT
                PostingAmount := 0;
                ///
                IF TransactionCharges."Calculation Type" = TransactionCharges."Calculation Type"::"Calculation Scheme" THEN BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", ChargeCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        PostingAmount := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::Percentage THEN
                            PostingAmount := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                    END;
                END ELSE BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", ChargeCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Source Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        TempBase := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::"Percentage" THEN
                            TempBase := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                        TransactionCalcScheme1.RESET;
                        TransactionCalcScheme1.SETFILTER("Lower Limit", '<=%1', TempBase);
                        TransactionCalcScheme1.SETFILTER("Upper Limit", '>=%1', TempBase);
                        TransactionCalcScheme1.SETRANGE("Transaction Code", ChargeCode);
                        TransactionCalcScheme1.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                        IF TransactionCalcScheme1.FINDFIRST THEN BEGIN
                            PostingAmount := TransactionCalcScheme1.Rate;
                            IF TransactionCalcScheme1."Rate Type" = TransactionCalcScheme1."Rate Type"::"Percentage" THEN
                                PostingAmount := ((TransactionCalcScheme1.Rate) / 100) * TempBase;
                        END;
                    END;
                END;
                AccountNumber := '';
                AccountNumber := TransactionCharges."Post to Account";
                PostingDescription := '';
                PostingDescription := 'Chrg:' + TransactionCharges."Charge Description";
                EntyNo := CreateJournalLine(GlobalAccountType::"G/L Account", AccountNumber, PostingDate, PostingDescription, -1 * PostingAmount,
                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", EntyNo + 1000000, SourceCode, ReasonCode, ExternalDocumentNo, JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                if SelfBalancing then begin
                    AccountNumber := '';
                    AccountNumber := DebitAccount;
                    EntyNo := CreateJournalLine(GlobalAccountType::Vendor, AccountNumber, PostingDate, PostingDescription, PostingAmount,
                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Disb. Rec", EntyNo + 1000000, SourceCode, ReasonCode, ExternalDocumentNo, JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                end;
            UNTIL TransactionCharges.NEXT = 0;
        END;
        exit(EntyNo);
    end;

    procedure GetTransactionCharges(ChargeCode: Code[20]; BaseAmount: Decimal) TotalCharges: Decimal
    var
        SaccoTTypes: Record "Sacco Transaction Types";
        TransactionCharges: Record "Transaction Charges";
        TransactionCalcScheme, TransactionCalcScheme1 : Record "Transaction Calc. Scheme";
        TempBase, PostingAmount : Decimal;
    begin
        TotalCharges := 0;
        TransactionCharges.RESET;
        TransactionCharges.SETRANGE("Transaction Code", ChargeCode);
        IF TransactionCharges.FindSet() THEN BEGIN
            REPEAT
                PostingAmount := 0;
                ///
                IF TransactionCharges."Calculation Type" = TransactionCharges."Calculation Type"::"Calculation Scheme" THEN BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", ChargeCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        PostingAmount := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::Percentage THEN
                            PostingAmount := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                    END;
                END ELSE BEGIN
                    TransactionCalcScheme.RESET;
                    TransactionCalcScheme.SETFILTER("Lower Limit", '<=%1', BaseAmount);
                    TransactionCalcScheme.SETFILTER("Upper Limit", '>=%1', BaseAmount);
                    TransactionCalcScheme.SETRANGE("Transaction Code", ChargeCode);
                    TransactionCalcScheme.SETRANGE("Charge Code", TransactionCharges."Source Code");
                    IF TransactionCalcScheme.FINDFIRST THEN BEGIN
                        TempBase := TransactionCalcScheme.Rate;
                        IF TransactionCalcScheme."Rate Type" = TransactionCalcScheme."Rate Type"::"Percentage" THEN
                            TempBase := ((TransactionCalcScheme.Rate) / 100) * BaseAmount;
                        TransactionCalcScheme1.RESET;
                        TransactionCalcScheme1.SETFILTER("Lower Limit", '<=%1', TempBase);
                        TransactionCalcScheme1.SETFILTER("Upper Limit", '>=%1', TempBase);
                        TransactionCalcScheme1.SETRANGE("Transaction Code", ChargeCode);
                        TransactionCalcScheme1.SETRANGE("Charge Code", TransactionCharges."Charge Code");
                        IF TransactionCalcScheme1.FINDFIRST THEN BEGIN
                            PostingAmount := TransactionCalcScheme1.Rate;
                            IF TransactionCalcScheme1."Rate Type" = TransactionCalcScheme1."Rate Type"::"Percentage" THEN
                                PostingAmount := ((TransactionCalcScheme1.Rate) / 100) * TempBase;
                        END;
                    END;
                END;
                TotalCharges += PostingAmount;
            UNTIL TransactionCharges.NEXT = 0;
        END;
        Exit(TotalCharges);
    end;

    procedure CompletePosting(JournalTemplate: Code[20]; JournalBatch: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatch);
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplate);
        IF GenJournalLine.FindSet() THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Ext", GenJournalLine);
    end;

    procedure CreateJournalLine(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee; AccountNo: Code[20]; PostingDate: Date; PostingDescription: Text[50];
    Amount: Decimal; Dimension1: Code[20]; Dimension2: Code[20]; MemberNo: Code[20]; DocumentNo: Code[20];
    "Transaction Type": Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
     LineNo: Integer; SourceCode: Code[20]; ReasonCode: Code[20]; ExternalDocNo: code[20]; JournalTemplate: Code[20]; JournalBatch: Code[20];
    Dimension3: Code[20]; Dimension4: Code[20]; Dimension5: Code[20]; Dimension6: Code[20]; Dimension7: Code[20]; Dimension8: Code[20]) EntryNo: Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := PostingDate;
        LineNo += 1000;
        case AccountType of
            AccountType::"Bank Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            AccountType::Customer:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            AccountType::Employee:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
            AccountType::"Fixed Asset":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
            AccountType::"G/L Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            AccountType::"IC Partner":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"IC Partner";
            AccountType::Vendor:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        end;
        GenJournalLine.VALIDATE("Account No.", AccountNo);
        GenJournalLine.VALIDATE(Amount, Amount);
        GenJournalLine."Transaction Type" := "Transaction Type";
        GenJournalLine."Message to Recipient" := PostingDescription;
        GenJournalLine.Description := PostingDescription;
        GenJournalLine."Due Date" := PostingDate;
        GenJournalLine."Reason Code" := copystr(ReasonCode, 1, 10);
        GenJournalLine."Source Code" := SourceCode;
        GenJournalLine."Payment Reference" := ExternalDocNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine."Member No." := MemberNo;
        GenJournalLine."Loan No." := ReasonCode;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", Dimension1);
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", Dimension2);
        GenJournalLine.ValidateShortcutDimCode(1, Dimension1);
        GenJournalLine.ValidateShortcutDimCode(2, Dimension2);
        GenJournalLine.ValidateShortcutDimCode(3, Dimension3);
        GenJournalLine.ValidateShortcutDimCode(4, Dimension4);
        GenJournalLine.ValidateShortcutDimCode(5, Dimension5);
        GenJournalLine.ValidateShortcutDimCode(6, Dimension6);
        GenJournalLine.ValidateShortcutDimCode(7, Dimension7);
        GenJournalLine.ValidateShortcutDimCode(8, Dimension8);
        if AccountType = AccountType::Vendor then begin
            if Vendor.get(AccountNo) then begin
                if Vendor."Account Class" = Vendor."Account Class"::Loan then
                    GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans
                else begin
                    if Vendor."Share Capital Account" then
                        GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Share Capital"
                    else
                        if Vendor."NWD Account" then
                            GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit"
                        else
                            if Vendor."Fixed Deposit Account" then
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit"
                            else
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Withdrawable Deposit";
                end;
            end;
        end;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        EXIT(LineNo);
    end;

    procedure PostJournalVoucher(JournalVoucher: record "JV Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        PostingDate: date;
        JVLines: Record "JV Lines";
        ProductFactory: Record "Product Factory";
        Dim1: code[20];
        Dim2: code[20];
    begin
        JournalBatch := 'JVS';
        JournalTemplate := 'PAYMENT';
        Dim1 := JournalVoucher."Global Dimension 1 Code";
        Dim2 := JournalVoucher."Global Dimension 2 Code";
        if not GenJournalBatch.get(JournalTemplate, JournalBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Insert();
        end;
        GenJournalLine.reset;
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();
        PostingDate := JournalVoucher."Posting Date";
        DocumentNo := JournalVoucher."Document No.";
        LineNo := 1000;
        JVLines.Reset();
        JVLines.SetRange("Document No.", JournalVoucher."Document No.");
        if JVLines.FindSet() then begin
            repeat
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := JournalTemplate;
                GenJournalLine."Journal Batch Name" := JournalBatch;
                GenJournalLine."Document No." := DocumentNo;
                GenJournalLine."Line No." := LineNo;
                GenJournalLine."Posting Date" := PostingDate;
                LineNo += 1000;
                case JVLines."Account Type" of
                    JVLines."Account Type"::"Customer Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    JVLines."Account Type"::"Bank Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                    JVLines."Account Type"::"Vendor Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    JVLines."Account Type"::"Member Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    JVLines."Account Type"::"G/L Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    JVLines."Account Type"::"Loan Account":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    JVLines."Account Type"::"Fixed Asset":
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                end;

                GenJournalLine.VALIDATE("Account No.", JVLines."Post to Account");
                if JVLines."Credit Amount" > 0 then begin
                    GenJournalLine."Credit Amount" := JVLines."Credit Amount";
                    GenJournalLine.VALIDATE("Credit Amount");
                end else
                    if JVLines."Debit Amount" > 0 then begin
                        GenJournalLine."Debit Amount" := JVLines."Debit Amount";
                        GenJournalLine.VALIDATE("Debit Amount");
                    end;
                GenJournalLine."Message to Recipient" := JVLines."Posting Description";
                GenJournalLine.Description := GenJournalLine."Message to Recipient";
                GenJournalLine."Due Date" := PostingDate;
                if JVLines."Account Type" = JVLines."Account Type"::"Loan Account" then
                    GenJournalLine."Reason Code" := JVLines."Account No.";
                GenJournalLine."Source Code" := 'JV';
                GenJournalLine."External Document No." := JournalVoucher."External Document No.";
                GenJournalLine."Member No." := JVLines."Member No.";
                GenJournalLine."Transaction Type" := JVLines."Transaction Type";
                GenJournalLine."Loan No." := GenJournalLine."Reason Code";
                if JVLines."Member No." <> '' then begin
                    if ProductFactory.get(JVLines."Account No.") then begin
                        case ProductFactory."Product Type" of
                            ProductFactory."Product Type"::"Transacting Account":
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Withdrawable Deposit";
                            ProductFactory."Product Type"::"Investment Account":
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
                            ProductFactory."Product Type"::"Loan Account":
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                            ProductFactory."Product Type"::"Savings Account":
                                GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::"Non Withrawable Deposit";
                        end;
                    end;
                end;
                if JVLines."Account Type" = JVLines."Account Type"::"Loan Account" then
                    GenJournalLine."Member Posting Type" := GenJournalLine."Member Posting Type"::Loans;
                if JVLines."Account Type" IN [JVLines."Account Type"::"Loan Account", JVLines."Account Type"::"Member Account"] = false then
                    GenJournalLine."Member No." := '';
                if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account" then
                    GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::Purchase;
                GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
                GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
                IF GenJournalLine.Amount <> 0 THEN
                    GenJournalLine.INSERT;
            until JVLines.Next = 0;
        end;
        GenJournalLine.RESET;
        GenJournalLine.SETFILTER("Account No.", '<>%1', '');
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatch);
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplate);
        IF GenJournalLine.FINDFIRST THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        JournalVoucher.Posted := true;
        JournalVoucher.Modify();
    end;

    var
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
}
codeunit 90007 "Payments Management"
{
    trigger OnRun()
    begin

    end;

    procedure PostPaymentVoucher(PaymentVoucher: record "Payments Header")
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        PostingDate: date;
    begin
        Dim1 := PaymentVoucher."Global Dimension 1 Code";
        Dim2 := PaymentVoucher."Global Dimension 2 Code";
        JournalBatch := 'PAYMENTS';
        JournalTemplate := 'PAYMENT';
        if not GenJournalBatch.get(JournalTemplate, JournalBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JournalTemplate;
            GenJournalBatch.Name := JournalBatch;
            GenJournalBatch.Insert();
        end;
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Batch Name", JournalBatch);
        GenJournalLine.SetRange("Journal Template Name", JournalTemplate);
        if GenJournalLine.FindSet() then
            GenJournalLine.DeleteAll();
        LineNo := 1000;
        PostingDate := PaymentVoucher."Posting Date";
        DocumentNo := PaymentVoucher."Document No.";
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := PostingDate;
        LineNo += 1000;
        case PaymentVoucher."Paying Account Type" of
            PaymentVoucher."Paying Account Type"::"Bank Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
            PaymentVoucher."Paying Account Type"::"G/L Account":
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        end;
        GenJournalLine.VALIDATE("Account No.", PaymentVoucher."Paying Account No.");
        GenJournalLine."Credit Amount" := PaymentVoucher."payment Amount";
        GenJournalLine.VALIDATE("Credit Amount");
        GenJournalLine."Message to Recipient" := PaymentVoucher."Posting Description";
        GenJournalLine.Description := GenJournalLine."Message to Recipient";
        GenJournalLine."Due Date" := PaymentVoucher."Posting Date";
        GenJournalLine."Reason Code" := DocumentNo;
        GenJournalLine."Source Code" := 'PAYMENTS';
        GenJournalLine."External Document No." := PaymentVoucher."Cheque No";
        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplate;
        GenJournalLine."Journal Batch Name" := JournalBatch;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Posting Date" := PostingDate;
        LineNo += 1000;
        case PaymentVoucher."Payee Account Type" of
            PaymentVoucher."Payee Account Type"::Customer:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            PaymentVoucher."Payee Account Type"::Service:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
            PaymentVoucher."Payee Account Type"::Supplier:
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        end;
        GenJournalLine.VALIDATE("Account No.", PaymentVoucher."Payee Account No");
        GenJournalLine."Debit Amount" := PaymentVoucher."payment Amount";
        GenJournalLine.VALIDATE("Debit Amount");
        GenJournalLine."Message to Recipient" := PaymentVoucher."Posting Description";
        GenJournalLine.Description := GenJournalLine."Message to Recipient";
        GenJournalLine."Due Date" := PaymentVoucher."Posting Date";
        GenJournalLine."Reason Code" := DocumentNo;
        GenJournalLine."Source Code" := 'PAYMENTS';
        GenJournalLine."External Document No." := PaymentVoucher."Cheque No";
        GenJournalLine.Validate("Shortcut Dimension 1 Code", Dim1);
        GenJournalLine.Validate("Shortcut Dimension 2 Code", Dim2);
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;

        GenJournalLine.RESET;
        GenJournalLine.SETFILTER("Account No.", '<>%1', '');
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatch);
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplate);
        IF GenJournalLine.FINDFIRST THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        PaymentVoucher.Posted := true;
        PaymentVoucher.Modify();
    end;

    var
        Dim1: code[20];
        Dim2: code[20];
}
codeunit 90008 "Receipt Management"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforePostCashReceip(var Receipt: Record "Receipt Header")
    begin
    end;

    [IntegrationEvent(FALSE, false)]
    procedure OnAfterPostReceipt(var Receipt: Record "Receipt Header")
    begin
    end;


    procedure PostReceipt(var Receipt: Record "Receipt Header")
    var
        ReceiptLines: Record "Receipt Lines";
        LoansMgt: Codeunit "Loans Management";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        PostingDate: date;
        JournalManagement: Codeunit "Journal Management";
        PostingDescription: Text[50];
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, AccountNo, MemberNo : code[20];
        PostingAmount, LoanBalance, InterestBalance, BaseAmount : Decimal;
        LoanApplication: Record "Loan Application";
        SaccoSetup: Record "Sacco Setup";
        LoanProduct: Record "Product Factory";
    begin
        OnBeforePostCashReceip(Receipt);
        JournalBatch := 'RCTS';
        JournalTemplate := 'SACCO';
        Dim1 := Receipt."Global Dimension 1 Code";
        Dim2 := Receipt."Global Dimension 2 Code";
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Cash Receipt');
        PostingDescription := Receipt."Posting Description";
        AccountNo := Receipt."Receiving Account No.";
        PostingDate := Receipt."Posting Date";
        DocumentNo := Receipt."Receipt No.";
        PostingAmount := 0;
        PostingAmount := Receipt.Amount;
        if PostingDescription = '' then
            PostingDescription := 'Cash Receipt';
        case Receipt."Receiving Account Type" of
            Receipt."Receiving Account Type"::"Bank Account":
                LineNo := JournalManagement.CreateJournalLine(
                    GlobalAccountType::"Bank Account",
                    AccountNo,
                    PostingDate,
                    PostingDescription,
                    PostingAmount,
                    Dim1, Dim2,
                    MemberNo,
                    DocumentNo,
                    GlobalTransactionType::General, LineNo, 'FOSA', 'TRNS', DocumentNo,
                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            Receipt."Receiving Account Type"::"G/L Account":
                LineNo := JournalManagement.CreateJournalLine(
                    GlobalAccountType::"G/L Account",
                    AccountNo,
                    PostingDate,
                    PostingDescription,
                    PostingAmount,
                    Dim1, Dim2,
                    MemberNo,
                    DocumentNo,
                    GlobalTransactionType::General, LineNo, 'FOSA', 'TRNS', DocumentNo,
                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            Receipt."Receiving Account Type"::Customer:
                LineNo := JournalManagement.CreateJournalLine(
                    GlobalAccountType::Customer,
                    AccountNo,
                    PostingDate,
                    PostingDescription,
                    PostingAmount,
                    Dim1, Dim2,
                    MemberNo,
                    DocumentNo,
                    GlobalTransactionType::General, LineNo, 'FOSA', 'TRNS', DocumentNo,
                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            Receipt."Receiving Account Type"::Vendor:
                LineNo := JournalManagement.CreateJournalLine(
                    GlobalAccountType::Vendor,
                    AccountNo,
                    PostingDate,
                    PostingDescription,
                    PostingAmount,
                    Dim1, Dim2,
                    MemberNo,
                    DocumentNo,
                    GlobalTransactionType::General, LineNo, 'FOSA', 'TRNS', DocumentNo,
                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
        end;
        ReceiptLines.Reset();
        ReceiptLines.SetRange("Receipt No.", Receipt."Receipt No.");
        if ReceiptLines.FindSet() then begin
            repeat
                PostingAmount := 0;
                PostingAmount := ReceiptLines.Amount;
                MemberNo := '';
                MemberNo := ReceiptLines."Member No.";
                case ReceiptLines."Posting Type" of
                    ReceiptLines."Posting Type"::"Customer Receipt":
                        begin
                            AccountNo := ReceiptLines."Account Type";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Customer,
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                    ReceiptLines."Posting Type"::"Inter Bank":
                        begin
                            AccountNo := ReceiptLines."Account Type";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"Bank Account",
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                    ReceiptLines."Posting Type"::"Loan Receipt":
                        begin
                            LoanApplication.Get(ReceiptLines."Loan No.");
                            LoanProduct.Get(LoanApplication."Product Code");
                            AccountNo := '';
                            AccountNo := LoanApplication."Loan Account";
                            MemberNo := LoanApplication."Member No.";
                            LoanApplication.CalcFields("Loan Balance", "Interest Balance");
                            LoanBalance := LoanApplication."Loan Balance";
                            InterestBalance := LoanApplication."Interest Balance" + LoansMgt.GetProratedInterest(LoanApplication."Application No", Receipt."Posting Date");
                            if PostingAmount > LoanApplication."Loan Balance" then
                                Error('You Cannot overpay a loan');
                            BaseAmount := ReceiptLines.Amount;
                            if BaseAmount > InterestBalance then begin
                                PostingAmount := InterestBalance;
                                BaseAmount -= PostingAmount;
                            end else begin
                                PostingAmount := BaseAmount;
                                BaseAmount := 0;
                            end;
                            SaccoSetup.Get();
                            PostingDescription := 'Interest Paid';
                            AccountNo := LoanApplication."Loan Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor,
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Interest Paid", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                AccountNo := LoanProduct."Interest Due Account";
                                //Prorated Interest
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    'Prorated Interest',
                                    LoansMgt.GetProratedInterest(LoanApplication."Application No", Receipt."Posting Date"),
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Due", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account",
                                    LoanProduct."Interest Due Account",
                                    PostingDate,
                                    'Prorated Interest',
                                    -1 * LoansMgt.GetProratedInterest(LoanApplication."Application No", Receipt."Posting Date"),
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Due", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                //Prorated Interest
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    AccountNo,
                                    PostingDate,
                                    PostingDescription,
                                    PostingAmount,
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Paid", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                AccountNo := LoanProduct."Interest Paid Account";
                                AccountNo := LoanApplication."Loan Account";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account",
                                    AccountNo,
                                    PostingDate,
                                    PostingDescription,
                                    -1 * PostingAmount,
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Paid", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);

                            end else begin
                                //Prorated Interest
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    'Prorated Interest',
                                    LoansMgt.GetProratedInterest(LoanApplication."Application No", Receipt."Posting Date"),
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Due", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"G/L Account",
                                    LoanProduct."Interest Paid Account",
                                    PostingDate,
                                    'Prorated Interest',
                                    -1 * LoansMgt.GetProratedInterest(LoanApplication."Application No", Receipt."Posting Date"),
                                    Dim1, Dim2,
                                    MemberNo,
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Due", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            end;
                            PostingAmount := BaseAmount;
                            PostingDescription := 'Principle Paid';
                            AccountNo := LoanApplication."Loan Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor,
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Principle Paid", LineNo, LoanApplication."Product Code", LoanApplication."Application No", DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                    ReceiptLines."Posting Type"::"Member Receipt":
                        begin
                            AccountNo := ReceiptLines."Bal. Account No.";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor,
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                    ReceiptLines."Posting Type"::"Service Receipt":
                        begin
                            AccountNo := ReceiptLines."Account Type";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"G/L Account",
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                    ReceiptLines."Posting Type"::"Vendor Receipt":
                        begin
                            AccountNo := ReceiptLines."Account Type";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor,
                                AccountNo,
                                PostingDate,
                                PostingDescription,
                                -1 * PostingAmount,
                                Dim1, Dim2,
                                MemberNo,
                                DocumentNo,
                                GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        end;
                end;
            until ReceiptLines.Next = 0;
        end;
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        Receipt.Posted := true;
        Receipt.Modify();
        OnAfterPostReceipt(Receipt);
    end;

    var

        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        ProductFactory: record "Product Factory";
}
codeunit 90009 "Notifications Management"
{
    trigger OnRun()
    begin

    end;

    procedure SendSms(Var PhoneNo: text[250]; var SmsMessage: Text[250])
    var
        HtClient: HttpClient;
        Text001: TextConst ENU = 'https://api.mobilesasa.com/v1/send/message?senderID=MOBILESASA&api_token=6ROpYca51rzhmzWu00fBz49D2sz2LBDPNK2EH9uf24ef0CemOmjqXTBMtLPZ';
        Text002: TextConst ENU = '&message=';
        Text003: TextConst ENU = '&phone=';
        Content: HttpContent;
        Response: HttpResponseMessage;
        SaccoSetup: Record "Sacco Setup";
    begin
        PhoneNo := '0729143665';
        SaccoSetup.Get();
        if SaccoSetup."Block SMS" = false then
            HtClient.Post(Text001 + Text002 + SmsMessage + Text003 + PhoneNo, content, Response);
    end;

    procedure CheckSMSBalance()
    var
        HtClient: HttpClient;
        Text001: TextConst ENU = 'https://account.mobilesasa.com/api/balance?api_key=$2y$10$l9NXtO2JsP.wYo94MJO0z.cjjyxLJKnXpVjuLTmkjYKUfeOnJUaHC&username=APHITECH LTD';
        Content: HttpContent;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Values: Text[250];
        i: Integer;
    begin
        HtClient.Post(Text001, content, Response);
        //Content.ReadAs(Values);               
        Response.Content.ReadAs(Values);
        Message('Your SMS Bundle Balance is %1', Values);
    end;

    var
        myInt: Integer;
}
codeunit 90010 "MPesa Integrations"
{
    trigger OnRun()
    begin

    end;

    procedure CallService(ProjectName: Text; RequestUrl: Text; RequestType: Option Get,Patch,Post,Delete; payload: Text; Username: Text; Password: Text): Text
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        ResponseText: Text;
        contentHeaders: HttpHeaders;
    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        //RequestHeaders.Add('Authorization', CreateBasicAuthHeader(Username, Password));

        case RequestType of
            RequestType::Get:
                Client.Get(RequestURL, ResponseMessage);
            RequestType::patch:
                begin
                    RequestContent.WriteFrom(payload);

                    RequestContent.GetHeaders(contentHeaders);
                    contentHeaders.Clear();
                    contentHeaders.Add('Content-Type', 'application/json-patch+json');

                    RequestMessage.Content := RequestContent;

                    RequestMessage.SetRequestUri(RequestURL);
                    RequestMessage.Method := 'PATCH';

                    client.Send(RequestMessage, ResponseMessage);
                end;
            RequestType::post:
                begin
                    RequestContent.WriteFrom(payload);

                    RequestContent.GetHeaders(contentHeaders);
                    contentHeaders.Clear();
                    contentHeaders.Add('Content-Type', 'application/json');

                    Client.Post(RequestURL, RequestContent, ResponseMessage);
                end;
            RequestType::delete:
                Client.Delete(RequestURL, ResponseMessage);
        end;

        ResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    procedure GetCRBDataLoad()
    var
        HtClient: HttpClient;
        URLCode: TextConst ENU = 'https://test-api.ekenya.co.ke/Ushuru_APP_API/crb';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken: JsonToken;
        JArray: JsonArray;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
        PayLoad, ResponseText : Text;
    begin
        PayLoad := '{'
        + '"phoneNumber":"254704113452"' + ','
        + '"requestType":"product131"' + ','
        + '"firstName":"Surname"' + ','
        + '"surName":"OtherNames"' + ','
        + '"idNumber":"5602299"' + ','
        + '"deviceId":"23454123345461"'
        + '}';
        Message(CallService('CRB', URLCode, 2, PayLoad, '', ''));
    end;

    procedure GetIPRSDataLoad()
    var
        HtClient: HttpClient;
        URLCode: TextConst ENU = 'https://test-api.ekenya.co.ke/Ushuru_APP_API/iprs';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken: JsonToken;
        JArray: JsonArray;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
        ResponseText, PayLoad : Text;
    begin
        PayLoad := '{'
            + '"phoneNumber":"254704113452"' + ','
            + '"idType":"GetDataByIdCard"' + ','
            + '"idNumber":"31397774"' + ','
            + '"deviceId":"2345412341561"'
        + '}';
        JObject.ReadFrom(CallService('IPRS', URLCode, 2, PayLoad, '', ''));
    end;

    procedure GenerateAccessToken() AccessToken: Text[250]
    var
        HtClient: HttpClient;
        Text001: TextConst ENU = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken: JsonToken;
        JArray: JsonArray;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
    begin
        UserName := 'Azs2KejU1ARvIL5JdJsARbV2gDrWmpOB';
        Password := 'hipGvFJbOxri330c';
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        HtClient.DefaultRequestHeaders().Add('Authorization', AuthString);
        HtClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        HtClient.Get(Text001, Response);
        ok := Response.Content.ReadAs(AccessToken);
        OK := JArray.ReadFrom('[' + AccessToken + ']');
        for i := 0 to JArray.count - 1 do begin
            JArray.Get(i, JToken);
            Jobject := JToken.AsObject;
        end;
        JToken := GetJsonToken(JObject, 'access_token');
        AccessToken := JToken.AsValue().AsText();
        Message(AccessToken);
        exit(AccessToken);
    end;

    procedure GetJsonToken(JObject: JsonObject; JKey: Text[250]) JToken: JsonToken
    begin
        if JObject.Get(JKey, JToken) then
            exit(JToken)
        else
            error('Key Not Found ' + JKey);
    end;

    procedure ReadJsonObject(JObject: JsonObject; JItem: Text[100]; KeyID: Text[100]) ItemValue: Text
    var
        ResultToken, JOrderNoToken : JsonToken;
        JOrderDateToken: JsonToken;
        JSellToCustomerNoToken: JsonToken;
        JLinesToken, JToken : JsonToken;
        JLinesArray: JsonArray;
        NewJObject: JsonObject;
    begin
        Clear(JToken);
        if JObject.Get(JItem, JLinesToken) then begin
            NewJObject := JLinesToken.AsObject();
            ResultToken := GetJsonToken(NewJObject, KeyID);
            ItemValue := ResultToken.AsValue().AsText();
        end;
    end;

    local procedure ReadJSonArray(JArray: JsonArray) FirstName: Text[100];
    var
        JArrayTokens: JsonToken;
        Jobject: JsonObject;

        JToken: JsonToken;
    begin
        foreach JArrayTokens in JArray do begin
            Jobject := JArrayTokens.AsObject();
            if Jobject.Get('First_Name', JToken) then
                FirstName := JToken.AsValue().AsText();
        end;
        Message('First Name %1', FirstName);
        exit(FirstName);
    end;

    procedure GenerateB2CRequest() ResponseText: Text[250]
    var
        HtClient: HttpClient;
        Text001: TextConst ENU = 'https://sandbox.safaricom.co.ke/mpesa/b2c/v1/paymentrequest';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken: JsonToken;
        JArray: JsonArray;
        JObject: JsonObject;
        JValue: JsonValue;
        i: Integer;
        Body: Text[250];
    begin
        UserName := 'Azs2KejU1ARvIL5JdJsARbV2gDrWmpOB';
        Password := 'hipGvFJbOxri330c';
        AuthString := STRSUBSTNO('%1:%2', UserName, Password);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        HtClient.DefaultRequestHeaders().Add('Authorization', AuthString);
        HtClient.DefaultRequestHeaders.Add('Accept', 'application/json');
        HtClient.DefaultRequestHeaders.Add('content-type', 'application/json');
        HtClient.DefaultRequestHeaders.Add('authorization', 'Bearer <Access-Token>');
        /*MessageBody.AddText('"{\"InitiatorName\":\" \",\"SecurityCredential\":\" \",\"CommandID\":\" \",\"Amount\":\" \",\"PartyA\":\" \",'
        + '\"PartyB\":\" \",\"Remarks\":\" \",\"QueueTimeOutURL\":\"http://your_timeout_url\",'
        + '\"ResultURL\":\"http://your_result_url\",\"Occasion\":\" \"}"');*/
        Content.Clear();
        Content.WriteFrom(body);
        HtClient.Post(Text001, Content, Response);
        ok := Response.Content.ReadAs(ResponseText);
        OK := JArray.ReadFrom('[' + ResponseText + ']');
        for i := 0 to JArray.count - 1 do begin
            JArray.Get(i, JToken);
            Jobject := JToken.AsObject;
        end;
    end;

    var
        myInt: Integer;
}
codeunit 90011 "Workflow Event Handling Ext"
{
    trigger OnRun()
    begin

    end;

    procedure RunWorkflowOnSendLoanApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendLoanApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendCollateralApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendCollateralApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendCollateralReleaseForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendCollateralReleaseForApproval'));
    end;

    procedure RunWorkflowOnSendMemberApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMemberApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendMemberUpdateForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMemberUpdateForApproval'));
    end;

    procedure RunWorkflowOnSendPaymentVoucherForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendPaymentVoucherForApproval'));
    end;

    procedure RunWorkflowOnSendJournalVoucherForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendJournalVoucherForApproval'));
    end;

    procedure RunWorkflowOnSendTellerTransactionForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendTellerTransactionForApproval'));
    end;

    procedure RunWorkflowOnSendStandingOrderForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendStandingOrderForApproval'));
    end;

    procedure RunWorkflowOnSendMemberFixedDepositForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMemberFixedDepositForApproval'));
    end;

    procedure RunWorkflowOnSendBankersChequeForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendBankersChequeForApproval'));
    end;

    procedure RunWorkflowOnSendATMApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendATMApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendLoanBatchForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendLoanBatchForApproval'));
    end;

    procedure RunWorkflowOnSendMemberExitForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMemberExitForApproval'));
    end;

    procedure RunWorkflowOnSendGuarantorMgtForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendGuarantorMgtForApproval'));
    end;

    procedure RunWorkflowOnSendLoanRecoveryForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendLoanRecoveryForApproval'));
    end;

    procedure RunWorkflowOnSendMemberActivationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMemberActivationForApproval'));
    end;

    procedure RunWorkflowOnSendCheckOffForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendCheckOffForApproval'));
    end;

    procedure RunWorkflowOnSendChequeBookApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendChequeBookApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendChequeBookTransactionForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendChequeBookTransactionForApproval'));
    end;

    procedure RunWorkflowOnSendInterAccountTransferForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendInterAccountTransferForApproval'));
    end;

    procedure RunWorkflowOnSendAccountOpenningForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendAccountOpenningForApproval'));
    end;

    procedure RunWorkflowOnSendBosaReceiptForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendBosaReceiptForApproval'));
    end;

    procedure RunWorkflowOnSendMobileApplicationForApprovalCode(): code[128]
    var
    begin
        exit(UpperCase('RunWorkflowOnSendMobileApplicationForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendLoanApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnSendLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendLoanApplicationForApprovalCode, LoanApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendCollateralApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnSendCollateralApplicationForApproval(var CollateralApplication: Record "Collateral Application")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendCollateralApplicationForApprovalCode, CollateralApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendCollateralReleaseForApproval', '', true, true)]
    procedure RunWorkflowOnSendCollateralReleaseForApproval(var CollateralRelease: Record "Collateral Release")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendCollateralReleaseForApprovalCode, CollateralRelease);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMemberApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnSendMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMemberApplicationForApprovalCode, MemberApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMemberUpdateForApproval', '', true, true)]
    procedure RunWorkflowOnSendMemberUpdateForApproval(var MemberUpdate: Record "Member Editing")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMemberUpdateForApprovalCode, MemberUpdate);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendPaymentVoucherForApproval', '', true, true)]
    procedure RunWorkflowOnSendPaymentVoucherForApproval(var PaymentVoucher: Record "Payments Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendPaymentVoucherForApprovalCode, PaymentVoucher);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendJournalVoucherForApproval', '', true, true)]
    procedure RunWorkflowOnSendJournalVoucherForApproval(var JournalVoucher: Record "JV Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendJournalVoucherForApprovalCode, JournalVoucher);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendTellerTransactionForApproval', '', true, true)]
    procedure RunWorkflowOnSendTellerTransactionForApproval(var TellerTransaction: Record "Teller Transactions")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendTellerTransactionForApprovalCode, TellerTransaction);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendStandingOrderForApproval', '', true, true)]
    procedure RunWorkflowOnSendStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendStandingOrderForApprovalCode, StandingOrder);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMemberFixedDepositForApproval', '', true, true)]
    procedure RunWorkflowOnSendMemberFixedDepositForApproval(var FixedDeposit: Record "Fixed Deposit Register")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMemberFixedDepositForApprovalCode, FixedDeposit);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendBankersChequeForApproval', '', true, true)]
    procedure RunWorkflowOnSendBankersChequeForApproval(var BankersCheque: Record "Bankers Cheque")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendBankersChequeForApprovalCode, BankersCheque);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendATMApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnSendATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendATMApplicationForApprovalCode, ATMApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendLoanBatchForApproval', '', true, true)]
    procedure RunWorkflowOnSendLoanBatchForApproval(var LoanBatch: Record "Loan Batch Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendLoanBatchForApprovalCode, LoanBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMemberExitForApproval', '', true, true)]
    procedure RunWorkflowOnSendMemberExitForApproval(var MemberExit: Record "Member Exit Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMemberExitForApprovalCode, MemberExit);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendGuarantorMgtForApproval', '', true, true)]
    procedure RunWorkflowOnSendGuarantorMgtForApproval(var GuarantorMgt: Record "Guarantor Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendGuarantorMgtForApprovalCode, GuarantorMgt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendLoanRecoveryForApproval', '', true, true)]
    procedure RunWorkflowOnSendLoanRecoveryForApproval(var LoanRecovery: Record "Loan Recovery Header")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendLoanRecoveryForApprovalCode, LoanRecovery);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMemberActivationForApproval', '', true, true)]
    procedure RunWorkflowOnSendMemberActivationForApproval(var MemberActivation: Record "Member Activations")
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMemberActivationForApprovalCode, MemberActivation);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendCheckOffForApproval', '', true, true)]
    procedure RunWorkflowOnCheckOffForApproval(CheckOff: Record "Checkoff Header");
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendCheckOffForApprovalCode, CheckOff);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendChequeBookApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnChequeBookApplicationForApproval(ChequeBookApplication: Record "Cheque Book Applications");
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendChequeBookApplicationForApprovalCode, ChequeBookApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendChequeBookTransactionForApproval', '', true, true)]
    procedure RunWorkflowOnChequeBookTransactionForApproval(ChequeBookTransaction: Record "Cheque Book Transactions");
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendChequeBookTransactionForApprovalCode, ChequeBookTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendInterAccountTransferForApproval', '', true, true)]
    procedure RunWorkflowOnInterAccountTransferForApproval(InterAccountTransfer: Record "Inter Account Transfer");
    var
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendInterAccountTransferForApprovalCode, InterAccountTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendAccountOpenningForApproval', '', true, true)]
    procedure RunWorkflowOnAccountOpenningForApproval(AccountOpenning: Record "Account Openning");
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendAccountOpenningForApprovalCode, AccountOpenning);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendBosaReceiptForApproval', '', true, true)]
    procedure RunWorkflowOnBosaReceiptForApproval(BosaReceipt: Record "Receipt Header");
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendBosaReceiptForApprovalCode, BosaReceipt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnSendMobileApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnMobileApplicationForApproval(MobileApplication: Record "Mobile Applications");
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnSendMobileApplicationForApprovalCode, MobileApplication);
    end;

    procedure RunWorkflowOnCancelLoanApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelLoanApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelCollateralApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelCollateralApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelCollateralReleaseApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelCollateralReleaseForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMemberApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberUpdateApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMemberUpdateForApproval'));
    end;

    procedure RunWorkflowOnCancelPaymentVoucherApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPaymentVoucherForApproval'));
    end;

    procedure RunWorkflowOnCancelJournalVoucherApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelJournalVoucherForApproval'));
    end;

    procedure RunWorkflowOnCancelTellerTransactionApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelTellerTransactionForApproval'));
    end;

    procedure RunWorkflowOnCancelStandingOrderApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelStandingOrderForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberFixedDepositApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMemberFixedDepositForApproval'));
    end;

    procedure RunWorkflowOnCancelBankersChequeApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelBankersChequeForApproval'));
    end;

    procedure RunWorkflowOnCancelATMApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelATMApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelLoanBatchApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelLoanBatchForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberExitApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMemberExitForApproval'));
    end;

    procedure RunWorkflowOnCancelGuarantorMgtApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelGuarantorMgtForApproval'));
    end;

    procedure RunWorkflowOnCancelLoanRecoveryApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelLoanRecoveryForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberActivationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMemberActivationForApproval'));
    end;

    procedure RunWorkflowOnCancelCheckOffApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelCheckOffForApproval'));
    end;

    procedure RunWorkflowOnCancelChequeBookApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelChequeBookApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelChequeBookTransactionApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelChequeBookTransactionForApproval'));
    end;

    procedure RunWorkflowOnCancelInterAccountTransferApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelInterAccountTransferForApproval'));
    end;

    procedure RunWorkflowOnCancelAccountOpenningApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelAccountOpenningForApproval'));
    end;

    procedure RunWorkflowOnCancelBosaReceiptApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelBosaReceiptForApproval'));
    end;

    procedure RunWorkflowOnCancelMobileApplicationApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelMobileApplicationForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelLoanApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelLoanApplicationApprovalCode, LoanApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelCollateralApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelCollateralApplicationForApproval(var Collateral: Record "Collateral Application")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelCollateralApplicationApprovalCode, Collateral);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelCollateralReleaseForApproval', '', true, true)]
    procedure RunWorkflowOnCancelCollateralReleaseForApproval(var CollateralRelease: Record "Collateral Release")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelCollateralReleaseApprovalCode, CollateralRelease);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMemberApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMemberApplicationApprovalCode, MemberApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMemberUpdateForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMemberUpdateForApproval(var MemberUpdate: Record "Member Editing")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMemberUpdateApprovalCode, MemberUpdate);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelPaymentVoucherForApproval', '', true, true)]
    procedure RunWorkflowOnCancelPaymentVoucherForApproval(var PaymentVoucher: Record "Payments Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelPaymentVoucherApprovalCode, PaymentVoucher);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelJournalVoucherForApproval', '', true, true)]
    procedure RunWorkflowOnCancelJournalVoucherForApproval(var JournalVoucher: Record "JV Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelJournalVoucherApprovalCode, JournalVoucher);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelTellerTransactionForApproval', '', true, true)]
    procedure RunWorkflowOnCancelTellerTransactionForApproval(var TellerTransaction: Record "Teller Transactions")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelTellerTransactionApprovalCode, TellerTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelStandingOrderForApproval', '', true, true)]
    procedure RunWorkflowOnCancelStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelStandingOrderApprovalCode, StandingOrder);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMemberFixedDepositForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMemberFixedDepositForApproval(var FixedDeposit: Record "Fixed Deposit Register")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMemberFixedDepositApprovalCode, FixedDeposit);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelBankersChequeForApproval', '', true, true)]
    procedure RunWorkflowOnCancelBankersCheuqueForApproval(var BankersCheque: Record "Bankers Cheque")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelBankersChequeApprovalCode, BankersCheque);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelATMApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelATMApplicationApprovalCode, ATMApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelLoanBatchForApproval', '', true, true)]
    procedure RunWorkflowOnCancelLoanBatchForApproval(var LoanBatch: Record "Loan Batch Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelLoanBatchApprovalCode, LoanBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMemberExitForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMemberExitForApproval(var MemberExit: Record "Member Exit Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMemberExitApprovalCode, MemberExit);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelGuarantorMgtForApproval', '', true, true)]
    procedure RunWorkflowOnCancelGuarantorMgtForApproval(var GuarantorMgt: Record "Guarantor Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelGuarantorMgtApprovalCode, GuarantorMgt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelLoanRecoveryForApproval', '', true, true)]
    procedure RunWorkflowOnCancelLoanRecoveryForApproval(var LoanRecovery: Record "Loan Recovery Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelLoanRecoveryApprovalCode, LoanRecovery);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMemberActivationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMemberActivationForApproval(var MemberActivation: Record "Member Activations")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMemberActivationApprovalCode, MemberActivation);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelCheckOffForApproval', '', true, true)]
    procedure RunWorkflowOnCancelCheckOffForApproval(var CheckOff: Record "Checkoff Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelCheckOffApprovalCode, CheckOff);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelChequeBookApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Applications")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelChequeBookApplicationApprovalCode, ChequeBookApplication);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelChequeBookTransactionForApproval', '', true, true)]
    procedure RunWorkflowOnCancelChequeBookTransactionForApproval(var ChequeBookTransaction: Record "Cheque Book Transactions")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelChequeBookTransactionApprovalCode, ChequeBookTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelInterAccountTransferForApproval', '', true, true)]
    procedure RunWorkflowOnCancelInterAccountTransferForApproval(var InterAccountTransfer: Record "Inter Account Transfer")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelInterAccountTransferApprovalCode, InterAccountTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelAccountOpenningForApproval', '', true, true)]
    procedure RunWorkflowOnCancelAccountOpenningForApproval(var AccountOpenning: Record "Account Openning")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelAccountOpenningApprovalCode, AccountOpenning);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelBosaReceiptForApproval', '', true, true)]
    procedure RunWorkflowOnCancelBosaReceiptForApproval(var BosaReceipt: Record "Receipt Header")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelBosaReceiptApprovalCode, BosaReceipt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgmt. Ext", 'OnCancelMobileApplicationForApproval', '', true, true)]
    procedure RunWorkflowOnCancelMobileApplicationForApproval(var MobileApplication: Record "Mobile Applications")
    begin
        WorkFlowManagement.HandleEvent(RunWorkflowOnCancelMobileApplicationApprovalCode, MobileApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelLoanApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanApplicationApprovalCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
            RunWorkflowOnCancelCollateralApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelCollateralApplicationApprovalCode, RunWorkflowOnSendCollateralApplicationForApprovalCode);
            RunWorkflowOnCancelCollateralReleaseApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelCollateralReleaseApprovalCode, RunWorkflowOnSendCollateralReleaseForApprovalCode);
            RunWorkflowOnCancelMemberApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberApplicationApprovalCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
            RunWorkflowOnCancelMemberUpdateApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberUpdateApprovalCode, RunWorkflowOnSendMemberUpdateForApprovalCode);
            RunWorkflowOnCancelPaymentVoucherApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPaymentVoucherApprovalCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
            RunWorkflowOnCancelJournalVoucherApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelJournalVoucherApprovalCode, RunWorkflowOnSendJournalVoucherForApprovalCode);
            RunWorkflowOnCancelTellerTransactionApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelTellerTransactionApprovalCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
            RunWorkflowOnCancelStandingOrderApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStandingOrderApprovalCode, RunWorkflowOnSendStandingOrderForApprovalCode);
            RunWorkflowOnCancelMemberFixedDepositApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberFixedDepositApprovalCode, RunWorkflowOnSendMemberFixedDepositForApprovalCode);
            RunWorkflowOnCancelBankersChequeApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelBankersChequeApprovalCode, RunWorkflowOnSendBankersChequeForApprovalCode);
            RunWorkflowOnCancelATMApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelATMApplicationApprovalCode, RunWorkflowOnSendATMApplicationForApprovalCode);
            RunWorkflowOnCancelLoanBatchApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanBatchApprovalCode, RunWorkflowOnSendLoanBatchForApprovalCode);
            RunWorkflowOnCancelMemberExitApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberExitApprovalCode, RunWorkflowOnSendMemberExitForApprovalCode);
            RunWorkflowOnCancelGuarantorMgtApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelGuarantorMgtApprovalCode, RunWorkflowOnSendGuarantorMgtForApprovalCode);
            RunWorkflowOnCancelLoanRecoveryApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanRecoveryApprovalCode, RunWorkflowOnSendLoanRecoveryForApprovalCode);
            RunWorkflowOnCancelMemberActivationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberActivationApprovalCode, RunWorkflowOnSendMemberActivationForApprovalCode);
            RunWorkflowOnCancelCheckOffApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelCheckOffApprovalCode, RunWorkflowOnSendCheckOffForApprovalCode);
            RunWorkflowOnCancelChequeBookApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelChequeBookApplicationApprovalCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
            RunWorkflowOnCancelChequeBookTransactionApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelChequeBookTransactionApprovalCode, RunWorkflowOnSendChequeBookTransactionForApprovalCode);
            RunWorkflowOnCancelInterAccountTransferApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelInterAccountTransferApprovalCode, RunWorkflowOnSendInterAccountTransferForApprovalCode);
            RunWorkflowOnCancelAccountOpenningApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelAccountOpenningApprovalCode, RunWorkflowOnSendAccountOpenningForApprovalCode);
            RunWorkflowOnCancelBosaReceiptApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelBosaReceiptApprovalCode, RunWorkflowOnSendBosaReceiptForApprovalCode);
            RunWorkflowOnCancelMobileApplicationApprovalCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMobileApplicationApprovalCode, RunWorkflowOnSendMobileApplicationForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMobileApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendCollateralApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendCollateralReleaseForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberUpdateForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJournalVoucherForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberFixedDepositForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBankersChequeForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanBatchForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendGuarantorMgtForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanRecoveryForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberActivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendCheckOffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendChequeBookTransactionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendInterAccountTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendAccountOpenningForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendBosaReceiptForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMobileApplicationForApprovalCode);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanApplicationForApprovalCode, Database::"Loan Application", SendLoanApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanApplicationApprovalCode, Database::"Loan Application", CancelLoanApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendCollateralApplicationForApprovalCode, Database::"Collateral Application", SendCollateralApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelCollateralApplicationApprovalCode, Database::"Collateral Application", CancelCollateralApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendCollateralReleaseForApprovalCode, Database::"Collateral Release", SendCollateralReleaseApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelCollateralReleaseApprovalCode, Database::"Collateral Release", CancelCollateralReleaseApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberApplicationForApprovalCode, Database::"Member Application", SendMemberAppApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberApplicationApprovalCode, Database::"Member Application", CancelMemberAppApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberUpdateForApprovalCode, Database::"Member Editing", SendMemberUpdateApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberUpdateApprovalCode, Database::"Member Editing", CancelMemberUpdateApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPaymentVoucherForApprovalCode, Database::"Payments Header", SendPaymentVoucherApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPaymentVoucherApprovalCode, Database::"Payments Header", CancelPaymentVoucherApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendJournalVoucherForApprovalCode, Database::"JV Header", SendJournalVoucherApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelJournalVoucherApprovalCode, Database::"JV Header", CancelJournalVoucherApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendTellerTransactionForApprovalCode, Database::"Teller Transactions", SendTellerTransactionApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelTellerTransactionApprovalCode, Database::"Teller Transactions", CancelTellerTransactionApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStandingOrderForApprovalCode, Database::"Standing Order", SendStandingOrderApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStandingOrderApprovalCode, Database::"Standing Order", CancelStandingOrderApprovalTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberFixedDepositForApprovalCode, Database::"Fixed Deposit Register", SendMemberFixedDepositTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberFixedDepositApprovalCode, Database::"Fixed Deposit Register", CancelMemberFixedDepositTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBankersChequeForApprovalCode, Database::"Bankers Cheque", SendBankersChequeTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBankersChequeApprovalCode, Database::"Bankers Cheque", CancelBankersChequeTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendATMApplicationForApprovalCode, Database::"ATM Application", SendATMApplicationTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelATMApplicationApprovalCode, Database::"ATM Application", CancelATMApplicationTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanBatchForApprovalCode, Database::"Loan Batch Header", SendLoanBatchTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanBatchApprovalCode, Database::"Loan Batch Header", CancelLoanBatchTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberExitForApprovalCode, Database::"Member Exit Header", SendMemberExitTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberExitApprovalCode, Database::"Member Exit Header", CancelMemberExitTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGuarantorMgtForApprovalCode, Database::"Guarantor Header", SendGuarantorMgtTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGuarantorMgtApprovalCode, Database::"Guarantor Header", CancelGuarantorMgtTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanRecoveryForApprovalCode, Database::"Loan Recovery Header", SendLoanRecoveryTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanRecoveryApprovalCode, Database::"Loan Recovery Header", CancelLoanRecoveryTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberActivationForApprovalCode, Database::"Member Activations", SendMemberActivationTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberActivationApprovalCode, Database::"Member Activations", CancelMemberActivationTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendCheckOffForApprovalCode, Database::"Checkoff Header", SendCheckOffTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelCheckOffApprovalCode, Database::"Checkoff Header", CancelCheckOffTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendChequeBookApplicationForApprovalCode, Database::"Cheque Book Applications", SendChequeBookAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelChequeBookApplicationApprovalCode, Database::"Cheque Book Applications", CancelChequeBookAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendChequeBookTransactionForApprovalCode, Database::"Cheque Book Transactions", SendChequeBookTransTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelChequeBookTransactionApprovalCode, Database::"Cheque Book Transactions", CancelChequeBookTransTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendInterAccountTransferForApprovalCode, Database::"Inter Account Transfer", SendAccTransTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelInterAccountTransferApprovalCode, Database::"Inter Account Transfer", CancelAccTransTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendAccountOpenningForApprovalCode, Database::"Account Openning", SendAccOpenningTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelAccountOpenningApprovalCode, Database::"Account Openning", CancelAccOpenningTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBosaReceiptForApprovalCode, Database::"Receipt Header", SendBosaReceiptTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBosaReceiptApprovalCode, Database::"Receipt Header", CancelBosaReceiptTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMobileApplicationForApprovalCode, Database::"Mobile Applications", SendMobileAppTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMobileApplicationApprovalCode, Database::"Mobile Applications", CancelMobileAppTxt, 0, false);
    end;

    var
        WorkFlowManagement: Codeunit 1501;
        WorkflowEventHandling: Codeunit 1520;
        SendMobileApprovalTxt: TextConst ENU = 'Approval for Mobile Application is Sent';
        CancelMobileApprovalTxt: TextConst ENU = 'Approval for Mobile Application is Cancelled';
        SendLoanApprovalTxt: TextConst ENU = 'Approval for Loan Application is Sent';
        CancelLoanApprovalTxt: TextConst ENU = 'Approval for Loan Application is Cancelled';
        SendCollateralApprovalTxt: TextConst ENU = 'Approval for Collateral Application is Sent';
        CancelCollateralApprovalTxt: TextConst ENU = 'Approval for Collateral Application is Cancelled';
        SendCollateralReleaseApprovalTxt: TextConst ENU = 'Approval for Collateral Release is Sent';
        CancelCollateralReleaseApprovalTxt: TextConst ENU = 'Approval for Collateral Release is Cancelled';
        SendMemberAppApprovalTxt: TextConst ENU = 'Approval for Member Application is Sent';
        CancelMemberAppApprovalTxt: TextConst ENU = 'Approval for Member Application Cancelled';
        SendMemberUpdateApprovalTxt: TextConst ENU = 'Approval for Member Update is Sent';
        CancelMemberUpdateApprovalTxt: TextConst ENU = 'Approval for Member Update Cancelled';
        SendPaymentVoucherApprovalTxt: TextConst ENU = 'Approval for Payment Voucher is Sent';
        CancelPaymentVoucherApprovalTxt: TextConst ENU = 'Approval for Payment Voucher Cancelled';
        SendJournalVoucherApprovalTxt: TextConst ENU = 'Approval for Journal Voucher is Sent';
        CancelJournalVoucherApprovalTxt: TextConst ENU = 'Approval for Journal Voucher Cancelled';
        SendTellerTransactionApprovalTxt: TextConst ENU = 'Approval for Teller Transaction is Sent';
        CancelTellerTransactionApprovalTxt: TextConst ENU = 'Approval for Teller Transaction Cancelled';
        SendStandingOrderApprovalTxt: TextConst ENU = 'Approval for Standing Order is Sent';
        CancelStandingOrderApprovalTxt: TextConst ENU = 'Approval for Standing Order Cancelled';
        SendMemberFixedDepositTxt: TextConst ENU = 'Approval for Member Fixed Deposit is Sent';
        CancelMemberFixedDepositTxt: TextConst ENU = 'Approval for Member Fixed Deposit Cancelled';
        SendBankersChequeTxt: TextConst ENU = 'Approval for Bankers Cheque is Sent';
        CancelBankersChequeTxt: TextConst ENU = 'Approval for Bankers Cheque Cancelled';
        SendATMApplicationTxt: TextConst ENU = 'Approval for ATM Application is Sent';
        CancelATMApplicationTxt: TextConst ENU = 'Approval for ATM Application Cancelled';
        SendLoanBatchTxt: TextConst ENU = 'Approval for a Loan Batch is Sent';
        CancelLoanBatchTxt: TextConst ENU = 'Approval for a Loan Batch Cancelled';
        SendMemberExitTxt: TextConst ENU = 'Approval for a Member Exit is Sent';
        CancelMemberExitTxt: TextConst ENU = 'Approval for a Member Exit Cancelled';
        SendGuarantorMgtTxt: TextConst ENU = 'Approval for a Guarantor Substitution is Sent';
        CancelGuarantorMgtTxt: TextConst ENU = 'Approval for a Guarantor Substitution is Cancelled';
        SendLoanRecoveryTxt: TextConst ENU = 'Approval for a loan recovery is Sent';
        CancelLoanRecoveryTxt: TextConst ENU = 'Approval for a loan recovery is Cancelled';
        SendMemberActivationTxt: TextConst ENU = 'Approval for a Member Activation is Sent';
        CancelMemberActivationTxt: TextConst ENU = 'Approval for a Member Activation is Cancelled';
        SendCheckOffTxt: TextConst ENU = 'Approval for a Checkoff is Sent';
        CancelCheckOffTxt: TextConst ENU = 'Approval for a Checkoff is Cancelled';
        SendChequeBookAppTxt: TextConst ENU = 'Approval for a Member Cheque Book Application is Sent';
        CancelChequeBookAppTxt: TextConst ENU = 'Approval for a Member Cheque Book Application is Cancelled';
        SendChequeBookTransTxt: TextConst ENU = 'Approval for a Member Cheque Book Transaction is Sent';
        CancelChequeBookTransTxt: TextConst ENU = 'Approval for a Member Cheque Book Transaction is Cancelled';
        SendAccTransTxt: TextConst ENU = 'Approval for an Account Transfer is Sent';
        CancelAccTransTxt: TextConst ENU = 'Approval for an Account Transfer is Cancelled';
        SendAccOpenningTxt: TextConst ENU = 'Approval for an Account Openning is Sent';
        CancelAccOpenningTxt: TextConst ENU = 'Approval for an Account Openning is Cancelled';
        SendBosaReceiptTxt: TextConst ENU = 'Approval for an Bosa Receipt is Sent';
        CancelBosaReceiptTxt: TextConst ENU = 'Approval for an Bosa Receipt is Cancelled';
        SendMobileAppTxt: TextConst ENU = 'Approval for an Mobile Application is Sent';
        CancelMobileAppTxt: TextConst ENU = 'Approval for an Mobile Application is Cancelled';
}
codeunit 90012 "Approval Mgmt. Ext"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendCollateralApplicationForApproval(var CollateralApplication: Record "Collateral Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendCollateralReleaseForApproval(var CollateralRelease: Record "Collateral Release")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberUpdateForApproval(var MemberUpdate: Record "Member Editing")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPaymentVoucherForApproval(var PaymentVoucher: Record "Payments Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendJournalVoucherForApproval(var JournalVoucher: Record "JV Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTellerTransactionForApproval(var TellerTransaction: Record "Teller Transactions")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberFixedDepositForApproval(var FixedDeposit: Record "Fixed Deposit Register")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendBankersChequeForApproval(var BankersCheque: Record "Bankers Cheque")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanBatchForApproval(var LoanBatch: Record "Loan Batch Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberExitForApproval(var MemberExit: Record "Member Exit Header")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendGuarantorMgtForApproval(var GuarantorMgt: Record "Guarantor Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanRecoveryForApproval(var LoanRecovery: Record "Loan Recovery Header")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendMemberActivationForApproval(var MemberActivation: Record "Member Activations")
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendCheckoffForApproval(var Checkoff: Record "Checkoff Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Applications")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeBookTransactionForApproval(var ChequeBookTransaction: Record "Cheque Book Transactions")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendInterAccountTransferForApproval(var InterAccountTransfer: Record "Inter Account Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAccountOpenningForApproval(var AccountOpenning: Record "Account Openning")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendBosaReceiptForApproval(var BosaReceipt: Record "Receipt Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMobileApplicationForApproval(var MobileApplication: Record "Mobile Applications")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelCollateralApplicationForApproval(var Collateral: Record "Collateral Application")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelCollateralReleaseForApproval(var CollateralRelease: Record "Collateral Release")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMemberUpdateForApproval(var MemberUpdate: Record "Member Editing")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelPaymentVoucherForApproval(var PaymentVoucher: Record "Payments Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelJournalVoucherForApproval(var JournalVoucher: Record "JV Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelTellerTransactionForApproval(var TellerTransaction: Record "Teller Transactions")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMemberFixedDepositForApproval(var FixedDeposit: Record "Fixed Deposit Register")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelBankersChequeForApproval(var BankersCheque: Record "Bankers Cheque")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelLoanBatchForApproval(var LoanBatch: Record "Loan Batch Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMemberExitForApproval(var MemberExit: Record "Member Exit Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelGuarantorMgtForApproval(var GuarantorMgt: Record "Guarantor Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelLoanRecoveryForApproval(var LoanRecovery: Record "Loan Recovery Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMemberActivationForApproval(var MemberActivation: Record "Member Activations")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelCheckoffForApproval(var Checkoff: Record "Checkoff Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Applications")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelChequeBookTransactionForApproval(var ChequeBookTransaction: Record "Cheque Book Transactions")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelInterAccountTransferForApproval(var InterAccountTransfer: Record "Inter Account Transfer")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelAccountOpenningForApproval(var AccountOpenning: Record "Account Openning")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelBosaReceiptForApproval(var BosaReceipt: Record "Receipt Header")
    begin
    end;

    [IntegrationEvent(False, false)]
    procedure OnCancelMobileApplicationForApproval(var MobileApplication: Record "Mobile Applications")

    begin
    end;

    procedure CheckLoanApplicationApprovalsWorkflowEnable(var LoanApplication: Record "Loan Application"): Boolean
    begin
        if not isLoanApplicationApprovalWorkflowEnabled(LoanApplication) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckCollateralApplicationApprovalsWorkflowEnable(var CollateralApplication: Record "Collateral Application"): Boolean
    begin
        if not isCollateralApplicationApprovalWorkflowEnabled(collateralApplication) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckCollateralReleaseApprovalsWorkflowEnable(var CollateralRelease: Record "Collateral Release"): Boolean
    begin
        if not isCollateralReleaseApprovalWorkflowEnabled(CollateralRelease) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMemberApplicationApprovalsWorkflowEnable(var MemberApplication: Record "Member Application"): Boolean
    begin
        if not isMemberApplicationApprovalWorkflowEnabled(MemberApplication) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMemberUpdateApprovalsWorkflowEnable(var MemberUpdate: Record "Member Editing"): Boolean
    begin
        if not isMemberUpdateApprovalWorkflowEnabled(MemberUpdate) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckPaymentVoucherApprovalsWorkflowEnable(var PaymentVoucher: Record "Payments Header"): Boolean
    begin
        if not isPaymentVoucherApprovalWorkflowEnabled(PaymentVoucher) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckJournalVoucherApprovalsWorkflowEnable(var JournalVoucher: Record "JV Header"): Boolean
    begin
        if not isJournalVoucherApprovalWorkflowEnabled(JournalVoucher) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckTellerTransactionApprovalsWorkflowEnable(var TellerTransaction: Record "Teller Transactions"): Boolean
    begin
        if not isTellerTransactionApprovalWorkflowEnabled(TellerTransaction) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckStandingOrderApprovalsWorkflowEnable(var StandingOrder: Record "Standing Order"): Boolean
    begin
        if not isStandingOrderApprovalWorkflowEnabled(StandingOrder) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMemberFixedDepositApprovalsWorkflowEnable(var FixedDeposit: Record "Fixed Deposit Register"): Boolean
    begin
        if not isMemberFixedDepositApprovalWorkflowEnabled(FixedDeposit) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckBankersChequeApprovalsWorkflowEnable(var BankersCheque: Record "Bankers Cheque"): Boolean
    begin
        if not isBankersChequeApprovalWorkflowEnabled(BankersCheque) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckATMApplicationApprovalsWorkflowEnable(var ATMApplication: Record "ATM Application"): Boolean
    begin
        if not isATMApplicationApprovalWorkflowEnabled(ATMApplication) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckLoanBacthApprovalsWorkflowEnable(var LoanBacth: Record "Loan Batch header"): Boolean
    begin
        if not isLoanBatchApprovalWorkflowEnabled(LoanBacth) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMemberExitApprovalsWorkflowEnable(var MemberExit: Record "Member Exit header"): Boolean
    begin
        if not isMemberExitApprovalWorkflowEnabled(MemberExit) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;


    procedure CheckGuarantorMgtApprovalsWorkflowEnable(var GuarantorMgt: Record "Guarantor Header"): Boolean
    begin
        if not isGuarantorMgtApprovalWorkflowEnabled(GuarantorMgt) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckLoanRecoveryApprovalsWorkflowEnable(var LoanRecovery: Record "Loan Recovery Header"): Boolean
    begin
        if not isLoanRecoveryApprovalWorkflowEnabled(LoanRecovery) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMemberActivationApprovalsWorkflowEnable(var MemberActivation: Record "Member Activations"): Boolean
    begin
        if not isMemberActivationApprovalWorkflowEnabled(MemberActivation) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckCheckOffApprovalsWorkflowEnable(var CheckOff: Record "Checkoff Header"): Boolean
    begin
        if not isCheckOffApprovalWorkflowEnabled(CheckOff) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckChequeBookApplicationApprovalsWorkflowEnable(var ChequeBookApplication: Record "Cheque Book Applications"): Boolean
    begin
        if not isChequeBookApplicationApprovalWorkflowEnabled(ChequeBookApplication) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckChequeBookTransactionApprovalsWorkflowEnable(var ChequeBookTransaction: Record "Cheque Book Transactions"): Boolean
    begin
        if not isChequeBookTransactionApprovalWorkflowEnabled(ChequeBookTransaction) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckInterAccountTransferApprovalsWorkflowEnable(var InterAccountTransfer: Record "Inter Account Transfer"): Boolean
    begin
        if not isInterAccountTransferApprovalWorkflowEnabled(InterAccountTransfer) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;


    procedure CheckAccountOpenningApprovalsWorkflowEnable(var AccountOpenning: Record "Account Openning"): Boolean
    begin
        if not isAccountOpenningApprovalWorkflowEnabled(AccountOpenning) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckBosaReceiptApprovalsWorkflowEnable(var BosaReceipt: Record "Receipt Header"): Boolean
    begin
        if not isBosaReceiptApprovalWorkflowEnabled(BosaReceipt) then
            Error(NoWorkflowEnabledError);
        exit(true);
    end;

    procedure CheckMobileApplicationApprovalsWorkflowEnable(var MobileApplication: Record "Mobile Applications"): Boolean
    begin
        if not isMobileApplicationApprovalWorkflowEnabled(MobileApplication) then
            Error(NoWorkflowEnabledError);

        exit(true);
    end;

    procedure isLoanApplicationApprovalWorkflowEnabled(var LoanApplication: Record "Loan Application"): Boolean
    begin
        if LoanApplication."Approval Status" <> LoanApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(LoanApplication, WorkflowEventHandlingCust.RunWorkflowOnSendLoanApplicationForApprovalCode()))
    end;

    procedure isCollateralApplicationApprovalWorkflowEnabled(var CollateralApplication: Record "Collateral Application"): Boolean
    begin
        if CollateralApplication."Approval Status" <> CollateralApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(CollateralApplication, WorkflowEventHandlingCust.RunWorkflowOnSendCollateralApplicationForApprovalCode()))
    end;

    procedure isCollateralReleaseApprovalWorkflowEnabled(var CollateralRelease: Record "Collateral Release"): Boolean
    begin
        if CollateralRelease."Approval Status" <> CollateralRelease."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(CollateralRelease, WorkflowEventHandlingCust.RunWorkflowOnSendCollateralReleaseForApprovalCode()))
    end;

    procedure isMemberApplicationApprovalWorkflowEnabled(var MemberApplication: Record "Member Application"): Boolean
    begin
        if MemberApplication."Approval Status" <> MemberApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(MemberApplication, WorkflowEventHandlingCust.RunWorkflowOnSendMemberApplicationForApprovalCode()))
    end;

    procedure isMemberUpdateApprovalWorkflowEnabled(var MemberUpdate: Record "Member Editing"): Boolean
    begin
        if MemberUpdate."Approval Status" <> MemberUpdate."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(MemberUpdate, WorkflowEventHandlingCust.RunWorkflowOnSendMemberUpdateForApprovalCode()))
    end;

    procedure isPaymentVoucherApprovalWorkflowEnabled(var PaymentVoucher: Record "Payments Header"): Boolean
    begin
        if PaymentVoucher."Approval Status" <> PaymentVoucher."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(PaymentVoucher, WorkflowEventHandlingCust.RunWorkflowOnSendPaymentVoucherForApprovalCode()))
    end;

    procedure isJournalVoucherApprovalWorkflowEnabled(var JournalVoucher: Record "JV Header"): Boolean
    begin
        if JournalVoucher."Approval Status" <> JournalVoucher."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(JournalVoucher, WorkflowEventHandlingCust.RunWorkflowOnSendJournalVoucherForApprovalCode()))
    end;

    procedure isTellerTransactionApprovalWorkflowEnabled(var TellerTransaction: Record "Teller Transactions"): Boolean
    begin
        if TellerTransaction."Approval Status" <> TellerTransaction."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(TellerTransaction, WorkflowEventHandlingCust.RunWorkflowOnSendTellerTransactionForApprovalCode()))
    end;

    procedure isStandingOrderApprovalWorkflowEnabled(var StandingOrder: Record "Standing Order"): Boolean
    begin
        if StandingOrder."Approval Status" <> StandingOrder."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(StandingOrder, WorkflowEventHandlingCust.RunWorkflowOnSendStandingOrderForApprovalCode()))
    end;

    procedure isMemberFixedDepositApprovalWorkflowEnabled(var FixedDeposit: Record "Fixed Deposit Register"): Boolean
    begin
        if FixedDeposit."Approval Status" <> FixedDeposit."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(FixedDeposit, WorkflowEventHandlingCust.RunWorkflowOnSendMemberFixedDepositForApprovalCode()))
    end;

    procedure isBankersChequeApprovalWorkflowEnabled(var BankersCheque: Record "Bankers Cheque"): Boolean
    begin
        if BankersCheque."Approval Status" <> BankersCheque."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(BankersCheque, WorkflowEventHandlingCust.RunWorkflowOnSendBankersChequeForApprovalCode()))
    end;

    procedure isATMApplicationApprovalWorkflowEnabled(var ATMApplication: Record "ATM Application"): Boolean
    begin
        if ATMApplication."Approval Status" <> ATMApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(ATMApplication, WorkflowEventHandlingCust.RunWorkflowOnSendATMApplicationForApprovalCode()))
    end;

    procedure isLoanBatchApprovalWorkflowEnabled(var LoanBatch: Record "Loan Batch Header"): Boolean
    begin
        if LoanBatch."Approval Status" <> LoanBatch."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(LoanBatch, WorkflowEventHandlingCust.RunWorkflowOnSendLoanBatchForApprovalCode()))
    end;

    procedure isMemberExitApprovalWorkflowEnabled(var MemberExit: Record "Member Exit Header"): Boolean
    begin
        if MemberExit."Approval Status" <> MemberExit."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(MemberExit, WorkflowEventHandlingCust.RunWorkflowOnSendMemberExitForApprovalCode()))
    end;

    procedure isGuarantorMgtApprovalWorkflowEnabled(var GuarantorMgt: Record "Guarantor Header"): Boolean
    begin
        if GuarantorMgt."Approval Status" <> GuarantorMgt."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(GuarantorMgt, WorkflowEventHandlingCust.RunWorkflowOnSendGuarantorMgtForApprovalCode()))
    end;

    procedure isLoanRecoveryApprovalWorkflowEnabled(var LoanRecovery: Record "Loan Recovery Header"): Boolean
    begin
        if LoanRecovery."Approval Status" <> LoanRecovery."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(LoanRecovery, WorkflowEventHandlingCust.RunWorkflowOnSendLoanRecoveryForApprovalCode()))
    end;


    procedure isMemberActivationApprovalWorkflowEnabled(var MemberActivation: Record "Member Activations"): Boolean
    begin
        if MemberActivation."Approval Status" <> MemberActivation."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(MemberActivation, WorkflowEventHandlingCust.RunWorkflowOnSendMemberActivationForApprovalCode()))
    end;

    procedure isCheckOffApprovalWorkflowEnabled(var CheckOff: Record "Checkoff Header"): Boolean
    begin
        if CheckOff."Approval Status" <> CheckOff."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(CheckOff, WorkflowEventHandlingCust.RunWorkflowOnSendCheckOffForApprovalCode()))
    end;

    procedure isChequeBookApplicationApprovalWorkflowEnabled(var ChequeBookApplication: Record "Cheque Book Applications"): Boolean
    begin
        if ChequeBookApplication."Approval Status" <> ChequeBookApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(ChequeBookApplication, WorkflowEventHandlingCust.RunWorkflowOnSendChequeBookApplicationForApprovalCode()))
    end;

    procedure isChequeBookTransactionApprovalWorkflowEnabled(var ChequeBookTransaction: Record "Cheque Book Transactions"): Boolean
    begin
        if ChequeBookTransaction."Approval Status" <> ChequeBookTransaction."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(ChequeBookTransaction, WorkflowEventHandlingCust.RunWorkflowOnSendChequeBookTransactionForApprovalCode()))
    end;

    procedure isInterAccountTransferApprovalWorkflowEnabled(var InterAccountTransfer: Record "Inter Account Transfer"): Boolean
    begin
        if InterAccountTransfer."Approval Status" <> InterAccountTransfer."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(InterAccountTransfer, WorkflowEventHandlingCust.RunWorkflowOnSendInterAccountTransferForApprovalCode()))
    end;

    procedure isAccountOpenningApprovalWorkflowEnabled(var AccountOpenning: Record "Account Openning"): Boolean
    begin
        if AccountOpenning."Approval Status" <> AccountOpenning."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(AccountOpenning, WorkflowEventHandlingCust.RunWorkflowOnSendAccountOpenningForApprovalCode()))
    end;

    procedure isBosaReceiptApprovalWorkflowEnabled(var BosaReceipt: Record "Receipt Header"): Boolean
    begin
        if BosaReceipt."Approval Status" <> BosaReceipt."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(BosaReceipt, WorkflowEventHandlingCust.RunWorkflowOnSendBosaReceiptForApprovalCode()))
    end;

    procedure isMobileApplicationApprovalWorkflowEnabled(var MobileApplication: Record "Mobile Applications"): Boolean
    begin
        if MobileApplication."Approval Status" <> MobileApplication."Approval Status"::New then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(MobileApplication, WorkflowEventHandlingCust.RunWorkflowOnSendMobileApplicationForApprovalCode()))
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        LoanApplication: Record "Loan Application";
        CollateralApplication: Record "Collateral Application";
        CollateralRelease: Record "Collateral Release";
        MemberApplication: Record "Member Application";
        MemberUpdate: Record "Member Editing";
        PaymentVoucher: Record "Payments Header";
        JournalVoucher: Record "JV Header";
        TellerTransaction: Record "Teller Transactions";
        StandingOrder: Record "Standing Order";
        FixedDeposit: Record "Fixed Deposit Register";
        BankersCheque: Record "Bankers Cheque";
        ATMApplication: Record "ATM Application";
        LoanBatch: Record "Loan Batch Header";
        MemberExit: Record "Member Exit Header";
        Member: Record Members;
        GuarantorMgt: Record "Guarantor Header";
        LoanRecovery: Record "Loan Recovery Header";
        MemberActivation: Record "Member Activations";
        CheckOff: Record "Checkoff Header";
        ChequeBookTransaction: Record "Cheque Book Transactions";
        ChequeBookApplication: Record "Cheque Book Applications";
        InterAccountTransfer: Record "Inter Account Transfer";
        AccountOpenning: Record "Account Openning";
        BosaReceipt: Record "Receipt Header";
        MobileApplication: Record "Mobile Applications";
    begin
        case RecRef.Number of
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    ApprovalEntryArgument."Document No." := LoanApplication."Application No";
                end;
            Database::"Collateral Application":
                begin
                    RecRef.SetTable(CollateralApplication);
                    ApprovalEntryArgument."Document No." := CollateralApplication."Document No";
                end;
            Database::"Collateral Release":
                begin
                    RecRef.SetTable(CollateralRelease);
                    ApprovalEntryArgument."Document No." := CollateralRelease."Document No";
                end;
            Database::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    ApprovalEntryArgument."Document No." := MemberApplication."Application No.";
                end;
            Database::"Member Editing":
                begin
                    RecRef.SetTable(MemberUpdate);
                    ApprovalEntryArgument."Document No." := MemberUpdate."Document No.";
                end;
            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    ApprovalEntryArgument."Document No." := PaymentVoucher."Document No.";
                end;
            Database::"JV Header":
                begin
                    RecRef.SetTable(JournalVoucher);
                    ApprovalEntryArgument."Document No." := JournalVoucher."Document No.";
                end;
            Database::"Teller Transactions":
                begin
                    RecRef.SetTable(TellerTransaction);
                    ApprovalEntryArgument."Document No." := TellerTransaction."Document No";
                end;
            Database::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    ApprovalEntryArgument."Document No." := StandingOrder."Document No";
                end;
            Database::"Fixed Deposit Register":
                begin
                    RecRef.SetTable(FixedDeposit);
                    ApprovalEntryArgument."Document No." := FixedDeposit."FD No.";
                end;
            Database::"Bankers Cheque":
                begin
                    RecRef.SetTable(BankersCheque);
                    ApprovalEntryArgument."Document No." := BankersCheque."Document No.";
                end;
            Database::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ApprovalEntryArgument."Document No." := ATMApplication."Application No";
                end;
            Database::"Loan Batch Header":
                begin
                    RecRef.SetTable(LoanBatch);
                    ApprovalEntryArgument."Document No." := LoanBatch."Document No";
                end;
            Database::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExit);
                    ApprovalEntryArgument."Document No." := MemberExit."Document No";
                end;
            Database::"Guarantor Header":
                begin
                    RecRef.SetTable(GuarantorMgt);
                    ApprovalEntryArgument."Document No." := GuarantorMgt."Document No";
                end;
            Database::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecovery);
                    ApprovalEntryArgument."Document No." := LoanRecovery."Document No";
                end;
            Database::"Member Activations":
                begin
                    RecRef.SetTable(MemberActivation);
                    ApprovalEntryArgument."Document No." := MemberActivation."Document No";
                end;
            Database::"Checkoff Header":
                begin
                    RecRef.SetTable(CheckOff);
                    ApprovalEntryArgument."Document No." := CheckOff."Document No";
                end;
            Database::"Cheque Book Applications":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ApprovalEntryArgument."Document No." := ChequeBookApplication."Application No";
                end;
            Database::"Cheque Book Transactions":
                begin
                    RecRef.SetTable(ChequeBookTransaction);
                    ApprovalEntryArgument."Document No." := ChequeBookTransaction."Document No";
                end;
            Database::"Inter Account Transfer":
                begin
                    RecRef.SetTable(InterAccountTransfer);
                    ApprovalEntryArgument."Document No." := InterAccountTransfer."Document No";
                end;
            Database::"Account Openning":
                begin
                    RecRef.SetTable(AccountOpenning);
                    ApprovalEntryArgument."Document No." := AccountOpenning."Document No";
                end;
            Database::"Receipt Header":
                begin
                    RecRef.SetTable(BosaReceipt);
                    ApprovalEntryArgument."Document No." := BosaReceipt."Receipt No.";
                end;
            Database::"Mobile Applications":
                begin
                    RecRef.SetTable(MobileApplication);
                    ApprovalEntryArgument."Document No." := MobileApplication."Document No";
                end;
        end;
    end;

    var
        WorkflowManagement: Codeunit 1501;
        WorkflowEventHandlingCust: Codeunit "Workflow Event Handling Ext";
        NoWorkflowEnabledError: TextConst ENU = 'No Workflow for this record type is enabled';
}
codeunit 90013 "Workflow Response Handling Ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LoanApplication: Record "Loan Application";
        CollateralApplication: Record "Collateral Application";
        CollateralRelease: Record "Collateral Release";
        MemberApplication: Record "Member Application";
        MemberUpdate: Record "Member Editing";
        PaymentVoucher: Record "Payments Header";
        JournalVoucher: Record "JV Header";
        TellerTransaction: Record "Teller Transactions";
        StandingOrder: Record "Standing Order";
        FixedDeposit: Record "Fixed Deposit Register";
        BankersCheque: Record "Bankers Cheque";
        ATMApplication: Record "ATM Application";
        LoanBatch: Record "Loan Batch Header";
        MemberExit: Record "Member Exit Header";
        Member: Record Members;
        GuarantorMgt: Record "Guarantor Header";
        LoanRecovery: Record "Loan Recovery Header";
        MemberActivation: record "Member Activations";
        CheckOff: Record "Checkoff Header";
        ChequeBookTransaction: Record "Cheque Book Transactions";
        ChequeBookApplication: Record "Cheque Book Applications";
        InterAccountTransfer: Record "Inter Account Transfer";
        AccountOpenning: Record "Account Openning";
        BosaReceipt: Record "Receipt Header";
        MobileApplication: Record "Mobile Applications";
        MemberMgt: Codeunit "Member Management";
    begin
        case RecRef.Number of
            Database::"Collateral Application":
                begin
                    RecRef.SetTable(CollateralApplication);
                    CollateralApplication."Approval Status" := CollateralApplication."Approval Status"::New;
                    CollateralApplication.Modify;
                    Handled := true;
                end;
            Database::"Collateral Release":
                begin
                    RecRef.SetTable(CollateralRelease);
                    CollateralRelease."Approval Status" := CollateralRelease."Approval Status"::New;
                    CollateralRelease.Modify;
                    Handled := true;
                end;
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    LoanApplication."Approval Status" := LoanApplication."Approval Status"::New;
                    LoanApplication."Appraisal Commited" := false;
                    LoanApplication.Modify;
                    Handled := true;
                end;
            Database::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    MemberApplication."Approval Status" := MemberApplication."Approval Status"::New;
                    MemberApplication.Modify();
                    Handled := true;
                end;
            Database::"Member Editing":
                begin
                    RecRef.SetTable(MemberUpdate);
                    MemberUpdate."Approval Status" := MemberUpdate."Approval Status"::New;
                    MemberUpdate.Modify();
                    Handled := true;
                end;
            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher."Approval Status" := PaymentVoucher."Approval Status"::New;
                    PaymentVoucher.Modify();
                    Handled := true;
                end;
            Database::"JV Header":
                begin
                    RecRef.SetTable(JournalVoucher);
                    JournalVoucher."Approval Status" := JournalVoucher."Approval Status"::New;
                    JournalVoucher.Modify();
                    Handled := true;
                end;
            Database::"Teller Transactions":
                begin
                    RecRef.SetTable(TellerTransaction);
                    TellerTransaction."Approval Status" := TellerTransaction."Approval Status"::New;
                    TellerTransaction.Modify();
                    Handled := true;
                end;
            Database::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    StandingOrder."Approval Status" := StandingOrder."Approval Status"::New;
                    StandingOrder.Modify();
                    Handled := true;
                end;
            Database::"Fixed Deposit Register":
                begin
                    RecRef.SetTable(FixedDeposit);
                    FixedDeposit."Approval Status" := FixedDeposit."Approval Status"::New;
                    FixedDeposit.Modify();
                    Handled := true;
                end;
            Database::"Bankers Cheque":
                begin
                    RecRef.SetTable(BankersCheque);
                    BankersCheque."Approval Status" := BankersCheque."Approval Status"::New;
                    BankersCheque.Modify();
                    Handled := true;
                end;
            Database::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ATMApplication."Approval Status" := ATMApplication."Approval Status"::New;
                    MemberMgt.ReverseAtmLien(ATMApplication."Application No");
                    ATMApplication.Modify();
                    Handled := true;
                end;
            Database::"Loan Batch Header":
                begin
                    RecRef.SetTable(LoanBatch);
                    LoanBatch."Approval Status" := LoanBatch."Approval Status"::New;
                    LoanBatch.Modify();
                    Handled := true;
                end;
            Database::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExit);
                    MemberExit."Approval Status" := MemberExit."Approval Status"::New;
                    if Member.Get(MemberExit."Member No") then begin
                        Member."Member Status" := Member."Member Status"::Active;
                        Member.Modify();
                    end;
                    MemberExit.Modify();
                    Handled := true;
                end;
            Database::"Guarantor Header":
                begin
                    RecRef.SetTable(GuarantorMgt);
                    GuarantorMgt."Approval Status" := GuarantorMgt."Approval Status"::New;
                    GuarantorMgt.Modify();
                    Handled := true;
                end;
            Database::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecovery);
                    LoanRecovery."Approval Status" := LoanRecovery."Approval Status"::New;
                    LoanRecovery.Modify();
                    Handled := true;
                end;
            Database::"Member Activations":
                begin
                    RecRef.SetTable(MemberActivation);
                    MemberActivation."Approval Status" := MemberActivation."Approval Status"::New;
                    MemberActivation.Modify();
                    Handled := true;
                end;
            Database::"Checkoff Header":
                begin
                    RecRef.SetTable(CheckOff);
                    CheckOff."Approval Status" := CheckOff."Approval Status"::New;
                    CheckOff.Modify();
                    Handled := true;
                end;
            Database::"Cheque Book Applications":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ChequeBookApplication."Approval Status" := ChequeBookApplication."Approval Status"::New;
                    ChequeBookApplication.Modify();
                    Handled := true;
                end;
            Database::"Cheque Book Transactions":
                begin
                    RecRef.SetTable(ChequeBookTransaction);
                    ChequeBookTransaction."Approval Status" := ChequeBookTransaction."Approval Status"::New;
                    ChequeBookTransaction.Modify();
                    Handled := true;
                end;
            Database::"Inter Account Transfer":
                begin
                    RecRef.SetTable(InterAccountTransfer);
                    InterAccountTransfer."Approval Status" := InterAccountTransfer."Approval Status"::New;
                    InterAccountTransfer.Modify();
                    Handled := true;
                end;
            Database::"Account Openning":
                begin
                    RecRef.SetTable(AccountOpenning);
                    AccountOpenning."Approval Status" := AccountOpenning."Approval Status"::New;
                    AccountOpenning.Modify();
                    Handled := true;
                end;
            Database::"Receipt Header":
                begin
                    RecRef.SetTable(BosaReceipt);
                    BosaReceipt."Approval Status" := BosaReceipt."Approval Status"::New;
                    BosaReceipt.Modify();
                    Handled := true;
                end;
            Database::"Mobile Applications":
                begin
                    RecRef.SetTable(MobileApplication);
                    MobileApplication."Approval Status" := MobileApplication."Approval Status"::New;
                    MobileApplication.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LoanApplication: Record "Loan Application";
        CollateralApplication: Record "Collateral Application";
        CollateralRelease: Record "Collateral Release";
        MemberApplication: Record "Member Application";
        MemberUpdate: Record "Member Editing";
        PaymentVoucher: Record "Payments Header";
        JournalVoucher: Record "JV Header";
        TellerTransaction: Record "Teller Transactions";
        StandingOrder: Record "Standing Order";
        FixedDeposit: Record "Fixed Deposit Register";
        FDManagement: Codeunit "Fixed Deposit Mgt.";
        BankersCheque: Record "Bankers Cheque";
        ATMApplication: Record "ATM Application";
        LoanBatch: record "Loan Batch Header";
        MemberExit: Record "Member Exit Header";
        Member: Record Members;
        GuarantorMgt: Record "Guarantor Header";
        LoanRecovery: Record "Loan Recovery Header";
        MemberActivation: Record "Member Activations";
        Checkoff: Record "Checkoff Header";
        ChequeBookTransaction: Record "Cheque Book Transactions";
        ChequeBookApplication: Record "Cheque Book Applications";
        InterAccountTransfer: Record "Inter Account Transfer";
        AccountOpenning: Record "Account Openning";
        BosaReceipt: Record "Receipt Header";
        MobileApplication: Record "Mobile Applications";
        MemberMgt: Codeunit "Member Management";
    begin
        case RecRef.Number of
            Database::"Collateral Application":
                begin
                    RecRef.SetTable(CollateralApplication);
                    CollateralApplication."Approval Status" := CollateralApplication."Approval Status"::Approved;
                    CollateralApplication.Modify;
                    Handled := true;
                end;
            Database::"Collateral Release":
                begin
                    RecRef.SetTable(CollateralRelease);
                    CollateralRelease."Approval Status" := CollateralRelease."Approval Status"::Approved;
                    CollateralRelease.Modify;
                    Handled := true;
                end;
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    LoanApplication."Approval Status" := LoanApplication."Approval Status"::Approved;
                    LoanApplication."Appraisal Commited" := true;
                    LoanApplication.Modify;
                    Handled := true;
                end;
            Database::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    MemberApplication."Approval Status" := MemberApplication."Approval Status"::Approved;
                    MemberApplication.Modify;
                    Handled := true;
                end;
            Database::"Member Editing":
                begin
                    RecRef.SetTable(MemberUpdate);
                    MemberUpdate."Approval Status" := MemberUpdate."Approval Status"::Approved;
                    MemberUpdate.Modify;
                    Handled := true;
                end;
            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher."Approval Status" := PaymentVoucher."Approval Status"::Approved;
                    PaymentVoucher.Modify;
                    Handled := true;
                end;
            Database::"JV Header":
                begin
                    RecRef.SetTable(JournalVoucher);
                    JournalVoucher."Approval Status" := JournalVoucher."Approval Status"::Approved;
                    JournalVoucher.Modify;
                    Handled := true;
                end;
            Database::"Teller Transactions":
                begin
                    RecRef.SetTable(TellerTransaction);
                    TellerTransaction."Approval Status" := TellerTransaction."Approval Status"::Approved;
                    TellerTransaction.Modify;
                    Handled := true;
                end;
            Database::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    StandingOrder."Approval Status" := StandingOrder."Approval Status"::Approved;
                    StandingOrder.Running := true;
                    StandingOrder.Modify;
                    Handled := true;
                end;
            Database::"Fixed Deposit Register":
                begin
                    RecRef.SetTable(FixedDeposit);
                    FixedDeposit."Approval Status" := FixedDeposit."Approval Status"::Approved;
                    FDManagement.ActivateFD(FixedDeposit);
                    Handled := true;
                end;
            Database::"Bankers Cheque":
                begin
                    RecRef.SetTable(BankersCheque);
                    BankersCheque."Approval Status" := BankersCheque."Approval Status"::Approved;
                    BankersCheque.Modify();
                    Handled := true;
                end;
            Database::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ATMApplication."Approval Status" := ATMApplication."Approval Status"::Approved;
                    ATMApplication.Modify();
                    Handled := true;
                end;
            Database::"Loan Batch Header":
                begin
                    RecRef.SetTable(LoanBatch);
                    LoanBatch."Approval Status" := LoanBatch."Approval Status"::Approved;
                    LoanBatch.Modify();
                    Handled := true;
                end;
            Database::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExit);
                    MemberExit."Approval Status" := MemberExit."Approval Status"::Approved;
                    MemberExit.Modify();
                    Handled := true;
                end;
            Database::"Guarantor Header":
                begin
                    RecRef.SetTable(GuarantorMgt);
                    GuarantorMgt."Approval Status" := GuarantorMgt."Approval Status"::Approved;
                    GuarantorMgt.Modify();
                    Handled := true;
                end;
            Database::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecovery);
                    LoanRecovery."Approval Status" := LoanRecovery."Approval Status"::Approved;
                    LoanRecovery.Modify();
                    Handled := true;
                end;
            Database::"Member Activations":
                begin
                    RecRef.SetTable(MemberActivation);
                    MemberActivation."Approval Status" := MemberActivation."Approval Status"::Approved;
                    MemberActivation.Modify();
                    Handled := true;
                end;
            Database::"Checkoff Header":
                begin
                    RecRef.SetTable(Checkoff);
                    Checkoff."Approval Status" := Checkoff."Approval Status"::Approved;
                    Checkoff.Modify();
                    Handled := true;
                end;
            Database::"Cheque Book Applications":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ChequeBookApplication."Approval Status" := ChequeBookApplication."Approval Status"::Approved;
                    ChequeBookApplication.Modify();
                    Handled := true;
                end;
            Database::"Cheque Book Transactions":
                begin
                    RecRef.SetTable(ChequeBookTransaction);
                    ChequeBookTransaction."Approval Status" := ChequeBookTransaction."Approval Status"::Approved;
                    ChequeBookTransaction.Modify();
                    Handled := true;
                end;
            Database::"Inter Account Transfer":
                begin
                    RecRef.SetTable(InterAccountTransfer);
                    InterAccountTransfer."Approval Status" := InterAccountTransfer."Approval Status"::Approved;
                    InterAccountTransfer.Modify();
                    Handled := true;
                end;
            Database::"Account Openning":
                begin
                    RecRef.SetTable(AccountOpenning);
                    AccountOpenning."Approval Status" := AccountOpenning."Approval Status"::Approved;
                    AccountOpenning."New Account No" := MemberMgt.OpenAccounts(AccountOpenning."Document No");
                    AccountOpenning.Processed := true;
                    AccountOpenning.Modify();
                    Handled := true;
                end;
            Database::"Receipt Header":
                begin
                    RecRef.SetTable(BosaReceipt);
                    BosaReceipt."Approval Status" := BosaReceipt."Approval Status"::Approved;
                    BosaReceipt.Modify();
                    Handled := true;
                end;
            Database::"Mobile Applications":
                begin
                    RecRef.SetTable(MobileApplication);
                    MobileApplication."Approval Status" := MobileApplication."Approval Status"::Approved;
                    MobileApplication.Processed := true;
                    MobileApplication."Processed By" := UserId;
                    MobileApplication."Processed On" := CurrentDateTime;
                    MemberMgt.PostMobileApplication(MobileApplication."Document No");
                    MobileApplication.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        LoanApplication: Record "Loan Application";
        CollateralApplication: Record "Collateral Application";
        CollateralRelease: Record "Collateral Release";
        MemberApplication: Record "Member Application";
        MemberUpdate: Record "Member Editing";
        PaymentVoucher: Record "Payments header";
        JournalVoucher: Record "JV header";
        TellerTransaction: Record "Teller Transactions";
        StandingOrder: Record "Standing Order";
        FixedDeposit: Record "Fixed Deposit Register";
        BankersCheque: Record "Bankers Cheque";
        MemberMgt: Codeunit "Member Management";
        ATMApplication: Record "ATM Application";
        LoanBatch: Record "Loan Batch Header";
        MemberExit: Record "Member Exit Header";
        Member: Record Members;
        GuarantorMgt: Record "Guarantor Header";
        LoanRecovery: Record "Loan Recovery Header";
        MemberActivation: Record "Member Activations";
        Checkoff: Record "Checkoff Header";
        ChequeBookTransaction: Record "Cheque Book Transactions";
        ChequeBookApplication: Record "Cheque Book Applications";
        InterAccountTransfer: Record "Inter Account Transfer";
        AccountOpenning: Record "Account Openning";
        BosaReceipt: Record "Receipt Header";
        MobileApplication: Record "Mobile Applications";
    begin
        case RecRef.Number of
            Database::"Collateral Application":
                begin
                    RecRef.SetTable(CollateralApplication);
                    CollateralApplication."Approval Status" := CollateralApplication."Approval Status"::"Approaval Pending";
                    CollateralApplication.Modify;
                    IsHandled := true;
                end;
            Database::"Collateral Release":
                begin
                    RecRef.SetTable(CollateralRelease);
                    CollateralRelease."Approval Status" := CollateralRelease."Approval Status"::"Approaval Pending";
                    CollateralRelease.Modify;
                    IsHandled := true;
                end;
            Database::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    LoanApplication."Approval Status" := LoanApplication."Approval Status"::"Approval Pending";
                    LoanApplication."Appraisal Commited" := true;
                    LoanApplication.Modify;
                    IsHandled := true;
                end;
            Database::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    MemberApplication."Approval Status" := MemberApplication."Approval Status"::"Pending Approval";
                    MemberApplication.Modify;
                    IsHandled := true;
                end;
            Database::"Member Editing":
                begin
                    RecRef.SetTable(MemberUpdate);
                    MemberUpdate."Approval Status" := MemberUpdate."Approval Status"::"Pending Approval";
                    MemberUpdate.Modify;
                    IsHandled := true;
                end;
            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentVoucher);
                    PaymentVoucher."Approval Status" := PaymentVoucher."Approval Status"::"Approval Pending";
                    PaymentVoucher.Modify;
                    IsHandled := true;
                end;
            Database::"JV Header":
                begin
                    RecRef.SetTable(JournalVoucher);
                    JournalVoucher."Approval Status" := JournalVoucher."Approval Status"::"Approval Pending";
                    JournalVoucher.Modify;
                    IsHandled := true;
                end;
            Database::"Teller Transactions":
                begin
                    RecRef.SetTable(TellerTransaction);
                    TellerTransaction."Approval Status" := TellerTransaction."Approval Status"::"Approval Pending";
                    TellerTransaction.Modify;
                    IsHandled := true;
                end;
            Database::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    StandingOrder."Approval Status" := StandingOrder."Approval Status"::"Approval Pending";
                    StandingOrder.Modify;
                    IsHandled := true;
                end;
            Database::"Fixed Deposit Register":
                begin
                    RecRef.SetTable(FixedDeposit);
                    FixedDeposit."Approval Status" := FixedDeposit."Approval Status"::"Approval Pending";
                    FixedDeposit.Modify;
                    IsHandled := true;
                end;
            Database::"Bankers Cheque":
                begin
                    RecRef.SetTable(BankersCheque);
                    BankersCheque."Approval Status" := BankersCheque."Approval Status"::"Approval Pending";
                    BankersCheque.Modify;
                    IsHandled := true;
                end;
            Database::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ATMApplication."Approval Status" := ATMApplication."Approval Status"::"Approval Pending";
                    MemberMgt.CreateAtmLien(ATMApplication."Application No");
                    ATMApplication.Modify;
                    IsHandled := true;
                end;
            Database::"Loan Batch Header":
                begin
                    RecRef.SetTable(LoanBatch);
                    LoanBatch."Approval Status" := LoanBatch."Approval Status"::"Approval Pending";
                    LoanBatch.Modify;
                    IsHandled := true;
                end;
            Database::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExit);
                    MemberExit."Approval Status" := MemberExit."Approval Status"::"Approval Pending";
                    MemberExit.Modify;
                    if Member.get(MemberExit."Member No") then begin
                        Member."Member Status" := Member."Member Status"::"Withdrawal-Pending";
                        Member.Modify();
                    end;
                    IsHandled := true;
                end;
            Database::"Guarantor Header":
                begin
                    RecRef.SetTable(GuarantorMgt);
                    GuarantorMgt."Approval Status" := GuarantorMgt."Approval Status"::"Approval Pending";
                    GuarantorMgt.Modify;
                    IsHandled := true;
                end;
            Database::"Loan Recovery Header":
                begin
                    RecRef.SetTable(LoanRecovery);
                    LoanRecovery."Approval Status" := LoanRecovery."Approval Status"::"Approval Pending";
                    LoanRecovery.Modify;
                    IsHandled := true;
                end;
            Database::"Member Activations":
                begin
                    RecRef.SetTable(MemberActivation);
                    MemberActivation."Approval Status" := MemberActivation."Approval Status"::"Approval Pending";
                    MemberActivation.Modify;
                    IsHandled := true;
                end;
            Database::"Checkoff Header":
                begin
                    RecRef.SetTable(Checkoff);
                    Checkoff."Approval Status" := Checkoff."Approval Status"::"Approval Pending";
                    Checkoff.Modify;
                    IsHandled := true;
                end;
            Database::"Cheque Book Applications":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ChequeBookApplication."Approval Status" := ChequeBookApplication."Approval Status"::"Approval Pending";
                    ChequeBookApplication.Modify;
                    IsHandled := true;
                end;
            Database::"Cheque Book Transactions":
                begin
                    RecRef.SetTable(ChequeBookTransaction);
                    ChequeBookTransaction."Approval Status" := ChequeBookTransaction."Approval Status"::"Approval Pending";
                    ChequeBookTransaction.Modify;
                    IsHandled := true;
                end;
            Database::"Inter Account Transfer":
                begin
                    RecRef.SetTable(InterAccountTransfer);
                    InterAccountTransfer."Approval Status" := InterAccountTransfer."Approval Status"::"Approval Pending";
                    InterAccountTransfer.Modify;
                    IsHandled := true;
                end;
            Database::"Account Openning":
                begin
                    RecRef.SetTable(AccountOpenning);
                    AccountOpenning."Approval Status" := AccountOpenning."Approval Status"::"Approval Pending";
                    AccountOpenning.Modify;
                    IsHandled := true;
                end;
            Database::"Receipt Header":
                begin
                    RecRef.SetTable(BosaReceipt);
                    BosaReceipt."Approval Status" := BosaReceipt."Approval Status"::"Approval Pending";
                    BosaReceipt.Modify;
                    IsHandled := true;
                end;
            Database::"Mobile Applications":
                begin
                    RecRef.SetTable(MobileApplication);
                    MobileApplication."Approval Status" := MobileApplication."Approval Status"::"Approval Pending";
                    MobileApplication.Modify;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit 1521;
        WorkflowEventHandling: Codeunit "Workflow Event Handling Ext";
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMobileApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCollateralApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCollateralReleaseForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberUpdateForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendJournalVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberFixedDepositForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendBankersChequeForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanBatchForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendGuarantorMgtForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanRecoveryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberActivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCheckOffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendChequeBookTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendInterAccountTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendAccountOpenningForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendBosaReceiptForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMobileApplicationForApprovalCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMobileApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCollateralApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCollateralReleaseForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberUpdateForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPaymentVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendJournalVoucherForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberFixedDepositForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendBankersChequeForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanBatchForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendGuarantorMgtForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendLoanRecoveryForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMemberActivationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendCheckOffForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendChequeBookTransactionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendInterAccountTransferForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendAccountOpenningForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendBosaReceiptForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendMobileApplicationForApprovalCode);
                end;
            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMobileApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelLoanApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelCollateralApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelCollateralReleaseApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMemberApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMemberUpdateApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelPaymentVoucherApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelJournalVoucherApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelTellerTransactionApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelStandingOrderApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMemberFixedDepositApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelBankersChequeApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelATMApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelLoanBatchApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMemberExitApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelGuarantorMgtApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelLoanRecoveryApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMemberActivationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelCheckOffApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelChequeBookApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelChequeBookTransactionApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelInterAccountTransferApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelAccountOpenningApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelBosaReceiptApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelMobileApplicationApprovalCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMobileApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelLoanApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelCollateralApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelCollateralReleaseApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMemberApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMemberUpdateApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelPaymentVoucherApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelJournalVoucherApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelTellerTransactionApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelStandingOrderApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMemberFixedDepositApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelBankersChequeApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelATMApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelLoanBatchApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMemberExitApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelGuarantorMgtApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelLoanRecoveryApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMemberActivationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelCheckOffApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelChequeBookApplicationApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelChequeBookTransactionApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelinterAccountTransferApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelAccountOpenningApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelBosaReceiptApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelMobileApplicationApprovalCode);
                end;
        end;
    end;

    var
        myInt: Integer;
}

codeunit 90014 "FOSA Management"
{
    trigger OnRun()
    begin

    end;

    procedure PostInterAccountTransfer(DocumentNo: code[20])
    var
        InterAccountTransfer: Record "Inter Account Transfer";
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        LineNo: Integer;
        PostingDate: date;
        PostingDescription: text[50];
        ProductFactory: Record "Product Factory";
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8 : code[20];
    begin
        InterAccountTransfer.Get(DocumentNo);
        JournalBatch := 'INTERACC';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Inter Account Transfers');
        PostingDescription := InterAccountTransfer."Posting Description";
        if PostingDescription = '' then
            PostingDescription := 'Inter Account Transfer';
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor,
            InterAccountTransfer."Transfer From",
            InterAccountTransfer."Posting Date",
            PostingDescription,
            InterAccountTransfer.Amount,
            Dim1, Dim2,
            InterAccountTransfer."Member No",
            InterAccountTransfer."Document No",
            GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
        LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor,
            InterAccountTransfer."Destination Account",
            InterAccountTransfer."Posting Date",
            PostingDescription,
            -1 * InterAccountTransfer.Amount,
            Dim1, Dim2,
            InterAccountTransfer."Destination Member",
            InterAccountTransfer."Document No",
            GlobalTransactionType::"Acc. Transfer", LineNo, 'FOSA', 'TRNS', DocumentNo,
            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
        JournalManagement.AddCharges(InterAccountTransfer."Charge Code", InterAccountTransfer."Transfer From", InterAccountTransfer.Amount, LineNo,
        DocumentNo, InterAccountTransfer."Member No", 'FOSA', 'TRNS', DocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6,
        Dim7, Dim8, InterAccountTransfer."Posting Date", True);
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        InterAccountTransfer.Posted := true;
        InterAccountTransfer."Posted By" := UserId;
        InterAccountTransfer."Posted On" := CurrentDateTime;
        InterAccountTransfer.Modify();
    end;

    procedure PrecheckTellerTransasction(TellerTransaction: Record "Teller Transactions")
    var
        myInt: Integer;
    begin
        if TellerTransaction."Transaction Type" <> TellerTransaction."Transaction Type"::"Cash Deposit" then begin
            if (TellerTransaction."Available Balance" - TellerTransaction.Amount) < 0 then begin
                Error('You cannot overdraw a members account');
            end;
        end;
    end;

    procedure PostFOSATransaction(FosaTransaction: Record "FOSA Transactions")
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        PostingDate: date;
        PostingDescription: text[50];
        ProductFactory: Record "Product Factory";
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8 : code[20];
    begin
        if CheckFOSATransaction(FosaTransaction) then begin
            JournalTemplate := 'SACCO';
            JournalBatch := 'FOSA';
            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'FOSA Batch');
            case FosaTransaction."Transaction Type" of
                FosaTransaction."Transaction Type"::"Send to Bank":
                    begin
                        PostingDescription := 'Return to Bank ' + FosaTransaction."Document No";
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"Bank Account",
                            FosaTransaction."Source No",
                            FosaTransaction."Posting Date",
                            PostingDescription,
                            -1 * FosaTransaction.Amount,
                            Dim1, Dim2,
                            '',
                            FosaTransaction."Document No",
                            GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"Bank Account",
                            FosaTransaction."Destination No",
                            FosaTransaction."Posting Date",
                            PostingDescription,
                            FosaTransaction.Amount,
                            Dim1, Dim2,
                            '',
                            FosaTransaction."Document No",
                            GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                        FosaTransaction.Posted := true;
                        FosaTransaction.Modify();
                    end;
                FosaTransaction."Transaction Type"::"Inter Teller Transfer":
                    begin
                        if FosaTransaction.Status = FosaTransaction.Status::Outbound then begin
                            FosaTransaction.Status := FosaTransaction.Status::Inbound;
                            FosaTransaction.Modify();
                        end else begin
                            PostingDescription := 'Inter Teller Transfer ' + FosaTransaction."Destination No";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"Bank Account",
                                FosaTransaction."Source No",
                                FosaTransaction."Posting Date",
                                PostingDescription,
                                -1 * FosaTransaction.Amount,
                                Dim1, Dim2,
                                '',
                                FosaTransaction."Document No",
                                GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            PostingDescription := 'Inter Teller Receipt ' + FosaTransaction."Source No";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"Bank Account",
                                FosaTransaction."Destination No",
                                FosaTransaction."Posting Date",
                                PostingDescription,
                                FosaTransaction.Amount,
                                Dim1, Dim2,
                                '',
                                FosaTransaction."Document No",
                                GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                            FosaTransaction.Posted := true;
                            FosaTransaction.Modify();
                        end;
                    end;
                FosaTransaction."Transaction Type"::"Receive From Bank":
                    begin
                        PostingDescription := 'Receive from Bank ' + FosaTransaction."Document No";
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"Bank Account",
                            FosaTransaction."Source No",
                            FosaTransaction."Posting Date",
                            PostingDescription,
                            -1 * FosaTransaction.Amount,
                            Dim1, Dim2,
                            '',
                            FosaTransaction."Document No",
                            GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::"Bank Account",
                            FosaTransaction."Destination No",
                            FosaTransaction."Posting Date",
                            PostingDescription,
                            FosaTransaction.Amount,
                            Dim1, Dim2,
                            '',
                            FosaTransaction."Document No",
                            GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                        FosaTransaction.Posted := true;
                        FosaTransaction.Modify();
                    end;
                FosaTransaction."Transaction Type"::"Return To Treasury":
                    begin
                        if FosaTransaction.Status = FosaTransaction.Status::Outbound then begin
                            FosaTransaction.Status := FosaTransaction.Status::Inbound;
                            FosaTransaction.Modify();
                        end else begin
                            PostingDescription := 'Return to Treasury ' + FosaTransaction."Document No";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"Bank Account",
                                FosaTransaction."Source No",
                                FosaTransaction."Posting Date",
                                PostingDescription,
                                -1 * FosaTransaction.Amount,
                                Dim1, Dim2,
                                '',
                                FosaTransaction."Document No",
                                GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"Bank Account",
                                FosaTransaction."Destination No",
                                FosaTransaction."Posting Date",
                                PostingDescription,
                                FosaTransaction.Amount,
                                Dim1, Dim2,
                                '',
                                FosaTransaction."Document No",
                                GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                            FosaTransaction.Posted := true;
                            FosaTransaction.Modify();
                        end;
                    end;
                FosaTransaction."Transaction Type"::"Request From Treasury":
                    begin
                        if FosaTransaction.Status = FosaTransaction.Status::Outbound then begin
                            FosaTransaction.Status := FosaTransaction.Status::Transit;
                            FosaTransaction.Modify();
                        end else
                            if FosaTransaction.Status = FosaTransaction.Status::Transit then begin
                                FosaTransaction.Status := FosaTransaction.Status::Inbound;
                                FosaTransaction.Modify();
                            end else begin
                                PostingDescription := 'Receive From Treasury ' + FosaTransaction."Document No";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    FosaTransaction."Source No",
                                    FosaTransaction."Posting Date",
                                    PostingDescription,
                                    FosaTransaction.Amount,
                                    Dim1, Dim2,
                                    '',
                                    FosaTransaction."Document No",
                                    GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                PostingDescription := 'Issue to Teller ' + FosaTransaction."Document No";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::"Bank Account",
                                    FosaTransaction."Destination No",
                                    FosaTransaction."Posting Date",
                                    PostingDescription,
                                    -1 * FosaTransaction.Amount,
                                    Dim1, Dim2,
                                    '',
                                    FosaTransaction."Document No",
                                    GlobalTransactionType::"Teller-Treasury", LineNo, 'FOSA', '', FosaTransaction."Payment Refrence No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                                FosaTransaction.Posted := true;
                                FosaTransaction.Modify();
                            end;
                    end;
            end;
        end;
    end;

    procedure ValidateTransactionCoinage(FosaTransaction: Record "FOSA Transactions")
    var
        TransactionCoinage: Record "FOSA Transaction Coinage";
        Coinage: Record Coinage;
    begin
        TransactionCoinage.Reset();
        TransactionCoinage.SetRange("Transaction Type", FosaTransaction."Transaction Type");
        TransactionCoinage.SetRange("Document No", FosaTransaction."Document No");
        if TransactionCoinage.FindSet() then
            TransactionCoinage.DeleteAll();
        Coinage.Reset();
        if Coinage.FindSet() then begin
            repeat
                TransactionCoinage.Init();
                TransactionCoinage."Transaction Type" := FosaTransaction."Transaction Type";
                TransactionCoinage."Document No" := FosaTransaction."Document No";
                TransactionCoinage."Coinage Code" := Coinage."Denomination Code";
                TransactionCoinage."Coinage Description" := Coinage.Description;
                TransactionCoinage."Coinage Value" := Coinage."Denomination Value";
                TransactionCoinage.Insert();
            until coinage.Next() = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostTellerTransaction(TellerTransaction: Record "Teller Transactions")
    begin
    end;

    procedure PostTellerTransaction(TellerTransaction: Record "Teller Transactions")
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Member: Record Members;
        JournalTemplate: Code[20];
        JournalBatch: Code[20];
        DocumentNo: Code[20];
        LineNo: Integer;
        PostingDate: date;
        JVLines: Record "JV Lines";
        ProductFactory: Record "Product Factory";
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8 : code[20];
        PostingDescription: Text[50];
    begin
        JournalBatch := 'TEL-TRANS';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Teller Transaction');
        if TellerTransaction."Transaction Type" = TellerTransaction."Transaction Type"::"Cash Deposit" then begin
            PostingDescription := 'Cash Deposit (OTC) ' + TellerTransaction."Transacted By Name" + TellerTransaction."Transacted By ID No";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"Bank Account",
                TellerTransaction.Till,
                TellerTransaction."Posting Date",
                PostingDescription,
                TellerTransaction.Amount,
                Dim1, Dim2,
                TellerTransaction."Member No",
                TellerTransaction."Document No",
                GlobalTransactionType::"Cash Deposit", LineNo, 'TELLER', TellerTransaction."Member No", TellerTransaction."Transacted By ID No",
                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor,
            TellerTransaction."Account No",
            TellerTransaction."Posting Date",
            PostingDescription,
            -1 * TellerTransaction.Amount,
            Dim1, Dim2,
            TellerTransaction."Member No",
            TellerTransaction."Document No",
            GlobalTransactionType::"Cash Deposit", LineNo, 'TELLER', TellerTransaction."Member No", TellerTransaction."Transacted By ID No",
            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
        end else begin
            Member.Get(TellerTransaction."Member No");
            PostingDescription := 'Cash Withdrawal (OTC) ' + Member."First Name" + ' ' + Member."National ID No";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"Bank Account",
                TellerTransaction.Till,
                TellerTransaction."Posting Date",
                PostingDescription,
                -1 * TellerTransaction.Amount,
                Dim1, Dim2,
                TellerTransaction."Member No",
                TellerTransaction."Document No",
                GlobalTransactionType::"Cash Deposit", LineNo, 'TELLER', TellerTransaction."Member No", TellerTransaction."Transacted By ID No",
                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            LineNo := JournalManagement.CreateJournalLine(
            GlobalAccountType::Vendor,
            TellerTransaction."Account No",
            TellerTransaction."Posting Date",
            PostingDescription,
            TellerTransaction.Amount,
            Dim1, Dim2,
            TellerTransaction."Member No",
            TellerTransaction."Document No",
            GlobalTransactionType::"Cash Deposit", LineNo, 'TELLER', TellerTransaction."Member No", TellerTransaction."Transacted By ID No",
            JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
        end;
        JournalManagement.AddCharges(TellerTransaction."Charge Code", TellerTransaction."Account No", TellerTransaction.Amount, LineNo, TellerTransaction."Document No", TellerTransaction."Member No", 'TELL', 'TELL', TellerTransaction."Transacted By ID No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, TellerTransaction."Posting Date", True);
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        TellerTransaction.Posted := true;
        TellerTransaction."Posted By" := UserId;
        TellerTransaction."Posted On" := CurrentDateTime;
        TellerTransaction.Modify();
        OnAfterPostTellerTransaction(TellerTransaction);
    end;

    procedure PostCheque(DocumentNo: Code[20]; PostingType: Option Clear,ClearX,Bounce,Reopen,Archive)
    var
        ChequeDeposit: Record "Cheque Deposits";
        JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, ReasonCode, SourceCode : code[20];
        LineNo: Integer;
        PostingDescription: Text[50];
        PostingDate: Date;
        ChequeInstructions: Record "Cheque Instructions";
        LoanApplication: Record "Loan Application";
        ProratedInterest, BaseAmount, PostingAmount : Decimal;
        SaccoSetup: Record "Sacco Setup";
        ProductSetup: Record "Product Factory";
        LoansMgt: Codeunit "Loans Management";
    begin
        PostingDate := Today;
        SaccoSetup.GET;
        JournalBatch := 'CTS';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Cheque Truncation System');
        ChequeDeposit.Get(DocumentNo);
        case PostingType of
            PostingType::Archive:
                ChequeDeposit."Document Status" := ChequeDeposit."Document Status"::Archived;
            PostingType::Reopen:
                ChequeDeposit."Document Status" := ChequeDeposit."Document Status"::New;
            PostingType::Clear, PostingType::ClearX:
                begin
                    //Debit Clearing Account                    
                    PostingDescription := 'Cheque Deposit ' + ChequeDeposit."Cheque No";
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::"Bank Account",
                        ChequeDeposit."Clearing Account No.",
                        PostingDate,
                        PostingDescription,
                        ChequeDeposit.Amount,
                        Dim1, Dim2,
                        ChequeDeposit."Member No",
                        DocumentNo,
                        GlobalTransactionType::"Cheque Deposit", LineNo, 'CTS', ChequeDeposit."Member No",
                         ChequeDeposit."Member No",
                        JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                    //Credit Target Account
                    LineNo := JournalManagement.CreateJournalLine(
                                 GlobalAccountType::Vendor,
                                 ChequeDeposit."Account No.",
                        PostingDate,
                                 PostingDescription,
                        -1 * ChequeDeposit.Amount,
                                 Dim1, Dim2,
                                 ChequeDeposit."Member No",
                        DocumentNo,
                        GlobalTransactionType::"Cheque Deposit", LineNo, 'CTS', ChequeDeposit."Member No",
                                 ChequeDeposit."Member No",
                                 JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                    //Post Instructions
                    ChequeInstructions.Reset();
                    ChequeInstructions.SetRange("Document No", DocumentNo);
                    if ChequeInstructions.FindSet() then begin
                        repeat
                            PostingDescription := '';
                            PostingDescription := 'Transfer to ' + ChequeInstructions."Account Name";
                            BaseAmount := 0;
                            BaseAmount := ChequeInstructions.Amount;
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor,
                                ChequeDeposit."Account No.",
                                PostingDate,
                                PostingDescription,
                                ChequeInstructions.Amount,
                                Dim1, Dim2,
                                ChequeDeposit."Member No",
                                DocumentNo,
                                GlobalTransactionType::"Cheque Deposit", LineNo, 'CTS', ChequeDeposit."Member No",
                                ChequeDeposit."Member No",
                                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            if ChequeInstructions."Account Type" = ChequeInstructions."Account Type"::Account then begin
                                PostingDescription := 'Transfer from ' + ChequeDeposit."Account Name" + '-' + ChequeDeposit."Cheque No";
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    ChequeInstructions."Account No",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * ChequeInstructions.Amount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Cheque Deposit", LineNo, 'CTS', ChequeDeposit."Member No",
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            end else begin
                                LoanApplication.Get(ChequeInstructions."Account No");
                                ProductSetup.Get(LoanApplication."Product Code");
                                ReasonCode := LoanApplication."Application No";
                                SourceCode := LoanApplication."Product Code";
                                ProratedInterest := LoansMgt.GetProratedInterest(ReasonCode, PostingDate);
                                LoanApplication.CalcFields("Interest Balance", "Penalty Balance", "Principle Balance");
                                postingAmount := 0;
                                LoanApplication."Interest Balance" += ProratedInterest;
                                if LoanApplication."Interest Balance" < 0 then
                                    LoanApplication."Interest Balance" := 0;
                                if LoanApplication."Penalty Balance" < 0 then
                                    LoanApplication."Penalty Balance" := 0;
                                if LoanApplication."Principle Balance" < 0 then
                                    LoanApplication."Principle Balance" := 0;
                                //Pay Penalty
                                PostingAmount := 0;
                                if LoanApplication."Penalty Balance" > BaseAmount then begin
                                    postingAmount := BaseAmount;
                                    BaseAmount := 0;
                                end else begin
                                    postingAmount := LoanApplication."Penalty Balance";
                                    BaseAmount -= postingAmount;
                                end;
                                PostingDescription := 'Penalty Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * postingAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Penalty Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                    LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    ProductSetup."Penalty Due Account",
                                    PostingDate,
                                    PostingDescription,
                                    postingAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Penalty Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                    LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    ProductSetup."Penalty Paid Account",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * postingAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Penalty Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                end;
                                //PayInterest
                                postingAmount := 0;
                                if LoanApplication."Interest Balance" > BaseAmount then begin
                                    postingAmount := BaseAmount;//0728129414
                                    BaseAmount := 0;
                                end else begin
                                    postingAmount := LoanApplication."Interest Balance";
                                    BaseAmount -= postingAmount;
                                end;
                                PostingDescription := 'Interest Due';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    PostingDescription,
                                    ProratedInterest,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Due", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                PostingDescription := 'Interest Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * postingAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                    //Debit Interest Due
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account",
                                        ProductSetup."Interest Due Account",
                                        PostingDate,
                                        PostingDescription,
                                        postingAmount,
                                        Dim1, Dim2,
                                        ChequeDeposit."Member No",
                                        DocumentNo,
                                        GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode,
                                        ChequeDeposit."Member No",
                                        JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                    //Credit Interest Paid
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account",
                                        ProductSetup."Interest Paid Account",
                                        PostingDate,
                                        PostingDescription,
                                        -1 * postingAmount,
                                        Dim1, Dim2,
                                        ChequeDeposit."Member No",
                                        DocumentNo,
                                        GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode,
                                        ChequeDeposit."Member No",
                                        JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                    //Post Prorated Interest
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account",
                                        ProductSetup."Interest Due Account",
                                        PostingDate,
                                        PostingDescription,
                                        -1 * ProratedInterest,
                                        Dim1, Dim2,
                                        ChequeDeposit."Member No",
                                        DocumentNo,
                                        GlobalTransactionType::"Penalty Paid", LineNo, SourceCode, ReasonCode,
                                        ChequeDeposit."Member No",
                                        JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                end else begin
                                    //Post Prorated Interest
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account",
                                        ProductSetup."Interest Paid Account",
                                        PostingDate,
                                        PostingDescription,
                                        -1 * ProratedInterest,
                                        Dim1, Dim2,
                                        ChequeDeposit."Member No",
                                        DocumentNo,
                                        GlobalTransactionType::"Penalty Paid", LineNo, SourceCode, ReasonCode,
                                        ChequeDeposit."Member No",
                                        JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                end;
                                //Pay principle
                                postingAmount := 0;
                                if BaseAmount > LoanApplication."Principle Balance" then begin
                                    postingAmount := LoanApplication."Principle Balance";
                                    BaseAmount -= postingAmount;
                                end else begin
                                    postingAmount := BaseAmount;
                                    BaseAmount := 0;
                                end;
                                PostingDescription := 'Principal Paid';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    LoanApplication."Loan Account",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * postingAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                                //Refund Any Amount excess
                                PostingDescription := 'Excess Loan Repayment Refund';
                                LineNo := JournalManagement.CreateJournalLine(
                                    GlobalAccountType::Vendor,
                                    ChequeDeposit."Account No.",
                                    PostingDate,
                                    PostingDescription,
                                    -1 * BaseAmount,
                                    Dim1, Dim2,
                                    ChequeDeposit."Member No",
                                    DocumentNo,
                                    GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode,
                                    ChequeDeposit."Member No",
                                    JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
                            end;
                        until ChequeInstructions.Next() = 0;
                    end;
                    ChequeDeposit."Document Status" := ChequeDeposit."Document Status"::Cleared;
                    //Add Charges
                    if PostingType = PostingType::Clear then begin
                        LineNo := JournalManagement.AddCharges(ChequeDeposit."Clearing Charges",
                        ChequeDeposit."Account No.",
                        ChequeDeposit.Amount,
                        LineNo,
                        DocumentNo,
                         ChequeDeposit."Member No",
                         'CTS', 'CTS', ChequeDeposit."Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                    end else begin
                        JournalManagement.AddCharges(ChequeDeposit."Express Clearing Charges",
                        ChequeDeposit."Account No.",
                        ChequeDeposit.Amount,
                        LineNo,
                        DocumentNo,
                         ChequeDeposit."Member No",
                         'CTS', 'CTS', ChequeDeposit."Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);

                    end;
                end;
            PostingType::Bounce:
                begin
                    JournalManagement.AddCharges(ChequeDeposit."Clearing Charges",
                                            ChequeDeposit."Account No.",
                                            ChequeDeposit.Amount,
                                            LineNo,
                                            DocumentNo,
                                             ChequeDeposit."Member No",
                                             'CTS', 'CTS', ChequeDeposit."Member No", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);
                    ChequeDeposit."Document Status" := ChequeDeposit."Document Status"::Bounced;
                end;
        end;
        JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
        ChequeDeposit.Modify();
    end;

    procedure PostBankersCheque(DocumentNo: code[20])
    var
        BankersCheque: Record "Bankers Cheque";
        BankersChequeType: Record "Bankers Cheque Types";
        LineNo: Integer;
        PostingDescription: Text;
        Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, JournalTemplate, JournalBatch : Code[20];
        PostingDate: Date;
    begin
        JournalBatch := 'BNKCHQ';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Bankers Cheques');
        BankersCheque.Reset();
        BankersCheque.SetRange("Document No.", DocumentNo);
        if BankersCheque.FindFirst() then begin
            BankersChequeType.Get(BankersCheque."Cheque Type");
            PostingDate := Today;
            //Debit Clearing Account                    
            PostingDescription := 'Bankers Cheque ' + BankersCheque."Leaf No.";
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::"Bank Account",
                BankersChequeType."Clearing Account",
                PostingDate,
                PostingDescription,
                -1 * BankersCheque.Amount,
                Dim1, Dim2,
                BankersCheque."Member No.",
                DocumentNo,
                GlobalTransactionType::"Bankers Cheque", LineNo, 'BCQ', 'BCQ',
                 BankersCheque."Member No.",
                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            LineNo := JournalManagement.CreateJournalLine(
                GlobalAccountType::Vendor,
                BankersCheque."Account Type",
                PostingDate,
                PostingDescription,
                BankersCheque.Amount,
                Dim1, Dim2,
                BankersCheque."Member No.",
                DocumentNo,
                GlobalTransactionType::"Bankers Cheque", LineNo, 'BCQ', 'BCQ',
                 BankersCheque."Member No.",
                JournalTemplate, JournalBatch, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8);
            LineNo := JournalManagement.AddCharges(BankersChequeType."Clearing Charges",
                BankersCheque."Account Type",
                BankersCheque.Amount,
                LineNo,
                DocumentNo,
                BankersCheque."Member No.",
                'BCQ', 'BCQ', BankersCheque."Member No.", JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, True);

            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
            BankersCheque.Posted := true;
            BankersCheque.Modify();
        end;
    end;

    local procedure CheckFOSATransaction(FOSATransaction: Record "FOSA Transactions") PostOk: Boolean
    var
        BankLedgerEntry: Record "Bank Account Ledger Entry";
        TellerSetup: Record "Teller Setup";
        BankAccount: Record "Bank Account";
    begin
        BankLedgerEntry.Reset();
        BankLedgerEntry.SetRange("Document No.", FOSATransaction."Document No");
        if BankLedgerEntry.FindSet() then begin
            FOSATransaction.Posted := true;
            FOSATransaction.Modify();
            PostOk := false;
            exit(PostOk);
        end;
        FOSATransaction.CalcFields(Coinage);
        if FOSATransaction.Coinage <> FOSATransaction.Amount then
            Error('The Coinage breakdown is not equal to the Total Amount');

        FOSATransaction.TestField("Payment Refrence No");
        FOSATransaction.TestField("Source No");
        FOSATransaction.TestField("Destination No");
        PostOk := true;
        case FOSATransaction."Transaction Type" of
            FOSATransaction."Transaction Type"::"Receive From Bank", FOSATransaction."Transaction Type"::"Send to Bank":
                begin
                    TellerSetup.Get(UserId, TellerSetup."Setup Type"::Treasury);
                    BankAccount.get(TellerSetup."Account Code");
                    BankAccount.CalcFields(Balance);
                    if FOSATransaction."Transaction Type" = FOSATransaction."Transaction Type"::"Receive From Bank" then begin
                        if (BankAccount.Balance + FOSATransaction.Amount) > TellerSetup."Maximum Capacity" then
                            Error('The Transaction cannot be completed. It will take the vault balance above the limit');
                    end;
                    if FOSATransaction."Transaction Type" = FOSATransaction."Transaction Type"::"Send to Bank" then begin
                        if (BankAccount.Balance - FOSATransaction.Amount) < TellerSetup."Minimum Capacity" then
                            Error('The Transaction cannot be completed. It will take the vault balance above the limit');
                    end;
                end;
            FOSATransaction."Transaction Type"::"Request From Treasury":
                begin
                    if FOSATransaction.Status IN [FOSATransaction.Status::Outbound, FOSATransaction.Status::Inbound] then begin
                        TellerSetup.Get(UserId, TellerSetup."Setup Type"::Teller);
                        BankAccount.get(TellerSetup."Account Code");
                        BankAccount.CalcFields(Balance);
                        if (BankAccount.Balance + FOSATransaction.Amount) > TellerSetup."Maximum Capacity" then
                            Error('The Transaction cannot be completed. It will take the Till balance above the limit');
                    end;
                    if FOSATransaction.Status = FOSATransaction.Status::Transit then begin
                        TellerSetup.Get(userid, TellerSetup."Setup Type"::Treasury);
                        BankAccount.get(TellerSetup."Account Code");
                        BankAccount.CalcFields(Balance);
                        if (BankAccount.Balance - FOSATransaction.Amount) < TellerSetup."Minimum Capacity" then
                            Error('The Transaction cannot be completed. It will take the vault balance below the limit');
                    end;
                end;
            FOSATransaction."Transaction Type"::"Inter Teller Transfer":
                begin
                    if FOSATransaction.Status = FOSATransaction.Status::Outbound then begin
                        TellerSetup.Get(UserId, TellerSetup."Setup Type"::Teller);
                        TellerSetup.TestField("Account Code", FOSATransaction."Source No");
                        BankAccount.get(FOSATransaction."Source No");
                        BankAccount.CalcFields(Balance);
                        if (BankAccount.Balance - FOSATransaction.Amount) < TellerSetup."Minimum Capacity" then
                            Error('The Transaction cannot be completed. It will take the Till balance below the limit');
                    end else begin
                        TellerSetup.Get(UserId, TellerSetup."Setup Type"::Teller);
                        TellerSetup.TestField("Account Code", FOSATransaction."Destination No");
                        BankAccount.get(TellerSetup."Account Code");
                        BankAccount.CalcFields(Balance);
                        if (BankAccount.Balance + FOSATransaction.Amount) > TellerSetup."Maximum Capacity" then
                            Error('The Transaction cannot be completed. It will take the Till balance above the limit');

                    end;
                end;
        end;
        exit(PostOk);
    end;

    procedure RunStandingOrder(STONo: Code[20]; RunDate: Date)
    var
        StandingOrder: record "Standing Order";
        Vendor: Record Vendor;
        DetailedLedger: Record "Detailed Vendor Ledg. Entry";
        AvailableAmount, RunAmount, TargetAmount, PostingAmount : Decimal;
        PostingDescription: Text[50];
        JournalTemplate, JournalBatch, DocumentNo, AccountNo, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8 : Code[20];
        LineNo, Day, Month, Year : Integer;
        PostingDate: Date;
        SaccoJournal: Codeunit "Journal Management";
        MemberNo, ExtDocNo, ReasonCode, SourceCode : Code[20];
        DateFilter: Text[50];
        StartDate: Date;
        LoanApplication: Record "Loan Application";
    begin
        if StandingOrder.Get(STONo) then begin
            StandingOrder.TestField("Run From Day");
            Day := StandingOrder."Run From Day";
            Month := Date2DMY(RunDate, 2);
            Year := Date2DMY(RunDate, 3);
            StartDate := DMY2Date(Day, Month, Year);
            MemberNo := StandingOrder."Member No";
            DocumentNo := STONo;
            if ((Vendor.get(StandingOrder."Account No")) AND (RunDate >= StartDate) AND (RunDate >= StandingOrder."Start Date")) then begin
                DateFilter := format(StartDate);
                JournalBatch := 'STO';
                JournalTemplate := 'SACCO';
                LineNo := SaccoJournal.PrepareJournal(JournalTemplate, JournalBatch, 'Standing Orders');
                PostingDate := StartDate;
                DetailedLedger.Reset();
                DetailedLedger.SetFilter("Posting Date", DateFilter);
                DetailedLedger.SetRange("Document No.", STONo);
                DetailedLedger.SetRange("Vendor No.", Vendor."No.");
                if DetailedLedger.FindSet() then begin
                    DetailedLedger.CalcSums("Debit Amount");
                    RunAmount := DetailedLedger."Debit Amount";
                end;
                Vendor.CalcFields(Balance);
                AvailableAmount := Vendor.Balance;
                TargetAmount := StandingOrder.Amount;
                PostingAmount := TargetAmount - RunAmount;
                if PostingAmount < 0 then
                    PostingAmount := 0;
                if PostingAmount > AvailableAmount then
                    PostingAmount := 0;
                if PostingAmount > 0 then begin
                    PostingDescription := 'STO Execution';
                    DocumentNo := STONo;
                    AccountNo := '';
                    AccountNo := Vendor."No.";
                    ReasonCode := StandingOrder."Document No";
                    LineNo := SaccoJournal.CreateJournalLine(
                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                    AccountNo := '';
                    AccountNo := StandingOrder."Destination Account";
                    case StandingOrder."Standing Order Class" of
                        StandingOrder."Standing Order Class"::Internal, StandingOrder."Standing Order Class"::External:
                            begin
                                LineNo := SaccoJournal.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Fixed Deposit", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        StandingOrder."Standing Order Class"::"Loan-Principle":
                            begin
                                LoanApplication.get(StandingOrder."Destination Account");
                                PostingAmount := StandingOrder.Amount;
                                LineNo := SaccoJournal.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        StandingOrder."Standing Order Class"::"Loan-Interest":
                            begin
                                LoanApplication.get(StandingOrder."Destination Account");
                                PostingAmount := StandingOrder.Amount;
                                LineNo := SaccoJournal.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                        StandingOrder."Standing Order Class"::"Loan Principle+Interest":
                            begin
                                LoanApplication.get(StandingOrder."Destination Account");
                                PostingAmount := StandingOrder.Amount;
                                LineNo := SaccoJournal.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExtDocNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            end;
                    end;
                    SaccoJournal.CompletePosting(JournalTemplate, JournalBatch);
                end;
            end;
        end;
    end;

    var
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        JournalManagement: Codeunit "Journal Management";
}

codeunit 90015 "Checkoff Management"
{
    trigger OnRun()
    begin

    end;

    procedure CalculateCheckoff(DocumentNo: Code[20])
    var
        Window: Dialog;
        All, Current, EntryNo : Integer;
        CheckoffUpload, CheckoffUpload1 : Record "Checkoff Upload";
        CheckoffLines: Record "Checkoff Lines";
        CurrentCheckNo, PreviousCheckNo, MemberNo : Code[20];
        TotalAmount: Decimal;
        LoansMgt: Codeunit "Loans Management";
        Member: Record Members;
        CheckOffCalculations: Record "Checkoff Calculation";
        CheckOff: Record "Checkoff Header";
    begin
        CheckOff.Get(DocumentNo);
        CheckoffLines.Reset();
        CheckoffLines.SetRange(Posted, true);
        CheckoffLines.SetRange("Document No", DocumentNo);
        if CheckoffLines.FindFirst() then
            Error('The Checkoff has some posted lines. Re-calculation is not allowed');
        CheckoffLines.Reset();
        CheckoffLines.SetRange("Document No", DocumentNo);
        if CheckoffLines.FindSet() then
            CheckoffLines.DeleteAll();

        CheckOffCalculations.Reset();
        CheckOffCalculations.SetRange("Document No", DocumentNo);
        if CheckOffCalculations.FindSet() then
            CheckOffCalculations.DeleteAll();
        EntryNo := 1000;
        CheckoffUpload.Reset();
        CheckoffUpload.SetRange("Document No", DocumentNo);
        CheckoffUpload.SetCurrentKey("Check No");
        if CheckoffUpload.FindSet() then begin
            All := CheckoffUpload.Count;
            Current := 1;
            Window.Open('Calculating \Member #1### \@2@@@');
            repeat
                Window.Update(1, ((Current / All) * 10000) div 1);
                Current += 1;
                CurrentCheckNo := CheckoffUpload."Check No";
                if CurrentCheckNo <> PreviousCheckNo then begin
                    CheckoffLines.Init();
                    CheckoffLines."Document No" := DocumentNo;
                    CheckoffLines."Member No" := GetMemberNo(CurrentCheckNo, CheckOff."Employer Code");
                    if Member.Get(CheckoffLines."Member No") then begin
                        CheckoffLines."Mobile Phone No" := Member."Mobile Phone No.";
                        CheckoffLines."Member Name" := Member."Full Name";
                        CheckoffLines."Check No" := CurrentCheckNo;
                        CheckoffLines."Collections Account" := LoansMgt.GetFOSAAccount(CheckoffLines."Member No");
                    end else begin
                        CheckoffLines."Suspense Account" := true;
                        CheckoffLines."Member Name" := 'Suspense Account';
                        CheckoffLines."Collections Account" := CheckOff."Suspense Account";
                        CheckoffLines."Check No" := CurrentCheckNo;
                    end;
                    CheckoffLines.Insert();
                    CheckoffUpload1.Reset();
                    CheckoffUpload1.SetRange("Check No", CurrentCheckNo);
                    CheckoffUpload1.SetRange("Document No", DocumentNo);
                    if CheckoffUpload1.FindSet() then begin
                        CheckoffUpload1.CalcSums(Amount);
                        TotalAmount := CheckoffUpload1.Amount;
                        CheckOffCalculations.Init();
                        CheckOffCalculations."Document No" := DocumentNo;
                        CheckOffCalculations."Member No" := GetMemberNo(CurrentCheckNo, CheckOff."Employer Code");
                        CheckOffCalculations."Check No" := CurrentCheckNo;
                        CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                        EntryNo += 1000;
                        CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Net Amount";
                        CheckOffCalculations.Amount := TotalAmount;
                        CheckOffCalculations."Amount (Base)" := CheckOffCalculations.Amount * -1;
                        CheckOffCalculations."Account No" := CheckoffLines."Collections Account";
                        CheckOffCalculations.Insert();
                    end;
                end;
                PreviousCheckNo := CurrentCheckNo;
            until CheckoffUpload.Next() = 0;
            CheckOff.CalcFields("Uploaded Amount");
            CheckOff.Variance := CheckOff."Uploaded Amount" - CheckOff.Amount;
            CheckOff.Modify();
            Window.Close();
        end;
        CheckOff.Variance := CheckOff."Uploaded Amount" - CheckOff.Amount;
        CheckOff.Modify();
    end;

    procedure GetMemberLoanAccount(MemberNo: code[20]; ProductCode: code[20]; CheckoffDate: Date) LoanNo: code[20]
    var
        LoanApplication: Record "Loan Application";
        LoanProduct: Record "Product Factory";
    begin
        LoanProduct.Reset();
        LoanProduct.SetRange("Search Code", ProductCode);
        if LoanProduct.FindFirst() then begin
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", MemberNo);
            LoanApplication.SetRange("Product Code", LoanProduct.Code);
            LoanApplication.SetFilter("Loan Balance", '>0');
            LoanApplication.SetFilter("Repayment Start Date", '<=%1', CheckoffDate);
            if LoanApplication.FindFirst() then
                LoanNo := LoanApplication."Application No"
            else
                LoanNo := 'PHILIP';
        end else begin
            LoanApplication.Reset();
            LoanApplication.SetRange("Member No.", MemberNo);
            LoanApplication.SetRange("Application No", ProductCode);
            LoanApplication.SetFilter("Loan Balance", '>0');
            LoanApplication.SetFilter("Repayment Start Date", '<=%1', CheckoffDate);
            if LoanApplication.FindFirst() then
                LoanNo := LoanApplication."Application No"
            else begin
                LoanApplication.Reset();
                LoanApplication.SetRange("Member No.", MemberNo);
                LoanApplication.SetRange("Product Code", ProductCode);
                LoanApplication.SetFilter("Loan Balance", '>0');
                LoanApplication.SetFilter("Repayment Start Date", '<=%1', CheckoffDate);
                if LoanApplication.FindFirst() then
                    LoanNo := LoanApplication."Application No"
                else
                    LoanNo := 'PHILIP';
            end;
        end;
        exit(LoanNo);
    end;

    procedure GetExpectedAmount(MemberNo: Code[20]; ProductCode: Code[20]; AsAtDate: Date; var LoanNo: Code[20]) Expected: Decimal
    var
        LoanApplication: Record "Loan Application";
        DateFilter: Text;
        LoansMgt: Codeunit "Loans Management";
        PDue, IntDue : Decimal;
    begin
        Expected := 0;
        DateFilter := '..' + Format(CalcDate('CM', AsAtDate));
        LoanApplication.Reset();
        LoanApplication.SetRange("Member No.", MemberNo);
        LoanApplication.SetRange("Product Code", ProductCode);
        LoanApplication.SetFilter("Loan Balance", '>0');
        LoanApplication.SetFilter("Date Filter", DateFilter);
        if LoanApplication.FindFirst() then begin
            LoanApplication.CalcFields("Interest Balance");
            if LoanApplication."Interest Balance" < 0 then
                LoanApplication."Interest Balance" := 0;
            IntDue := LoanApplication."Interest Balance";
        end;
        DateFilter := format(DMY2Date(01, Date2DMY(AsAtDate, 2), Date2DMY(AsAtDate, 3))) + '..' + Format(CalcDate('CM', AsAtDate));
        LoanApplication.Reset();
        LoanApplication.SetRange("Member No.", MemberNo);
        LoanApplication.SetRange("Product Code", ProductCode);
        LoanApplication.SetFilter("Loan Balance", '>0');
        LoanApplication.SetFilter("Date Filter", DateFilter);
        if LoanApplication.FindFirst() then begin
            LoanApplication.CalcFields("Principle Repayment");
            PDue := LoanApplication."Principle Repayment";
        end;
        LoanNo := LoanApplication."Application No";
        Expected := IntDue + PDue;
        exit(Expected);
    end;

    local procedure GetCheckOffEntryNo(DocumentNo: code[20]; MemberNo: code[20]; CheckNo: code[20]) EntryNo: Integer
    var
        CheckOffCalculation: Record "Checkoff Calculation";
    begin
        CheckOffCalculation.Reset();
        CheckOffCalculation.SetRange("Document No", DocumentNo);
        CheckOffCalculation.SetRange("Member No", MemberNo);
        CheckOffCalculation.SetRange("Check No", CheckNo);
        if CheckOffCalculation.FindLast() then
            exit(CheckOffCalculation."Entry No" + 1000)
        else
            exit(1000);
    end;

    procedure CalculateCheckoffRecoveries(DocumentNo: Code[20])
    var
        CheckoffUpload: Record "Checkoff Upload";
        CheckOffHeader: Record "Checkoff Header";
        CheckOffCalculations: Record "Checkoff Calculation";
        CheckoffLines: Record "Checkoff Lines";
        Window: Dialog;
        All, Current, EntryNo : Integer;
        AccountNo, MemberNo : Code[20];
        LoansMgt: Codeunit "Loans Management";
        ExpectedAmount, BaseAmount, STOCharge, ChargeAmount, RunningAmount, ExpectedPrincipal, ExpectedInterest, AmountDue, RecoveredAmount, STOAmount : Decimal;
        TransactionCharges: Record "Transaction Charges";
        TransactionRecoveries: Record "Transaction Recoveries";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        AccountType: Record "Product Factory";
        DateFilter: Text[100];
        JournalMgt: Codeunit "Journal Management";
        LoanNo: Code[20];
    begin
        CheckoffLines.Reset();
        CheckoffLines.SetRange("Document No", DocumentNo);
        CheckoffLines.SetRange("Suspense Account", false);
        if CheckoffLines.FindSet() then begin
            Window.Open('Updating Recoveries \#1###\@2@@@');
            All := CheckoffLines.Count;
            Current := 1;
            repeat
                MemberNo := '';
                MemberNo := CheckoffLines."Member No";
                Window.Update(1, CheckoffLines."Member Name" + MemberNo);
                Window.Update(2, ((Current / all) * 10000) div 1);
                Current += 1;
                CheckoffLines.CalcFields("Amount Earned");
                BaseAmount := 0;
                BaseAmount := Abs(CheckoffLines."Amount Earned");
                RunningAmount := 0;
                STOAmount := 0;
                STOCharge := 0;
                RunningAmount := BaseAmount;
                CheckOffHeader.Get(DocumentNo);
                CheckOffHeader.TestField("Posting Date");
                DateFilter := '..' + Format(calcdate('CM', CheckOffHeader."Posting Date"));
                if CheckOffHeader."Upload Type" = CheckOffHeader."Upload Type"::Salary then begin
                    if CheckOffHeader."Charge Code" <> '' then begin
                        TransactionCharges.Reset();
                        TransactionCharges.SetRange("Transaction Code", CheckOffHeader."Charge Code");
                        if TransactionCharges.FindSet() then begin
                            repeat
                                ChargeAmount := 0;
                                ChargeAmount := LoansMgt.GetChargeAmount(CheckOffHeader."Charge Code", TransactionCharges."Charge Code", BaseAmount);
                                CheckOffCalculations.Init();
                                CheckOffCalculations."Document No" := DocumentNo;
                                CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                CheckOffCalculations."Account Name" := TransactionCharges."Charge Description";
                                EntryNo += 1000;
                                CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::Commission;
                                CheckOffCalculations.Amount := ChargeAmount;
                                CheckOffCalculations."Amount (Base)" := ChargeAmount;
                                CheckOffCalculations."Account No" := TransactionCharges."Post to Account";
                                CheckOffCalculations.Insert();
                                BaseAmount -= ChargeAmount;
                            until TransactionCharges.Next() = 0;
                        end;
                        TransactionRecoveries.Reset();
                        TransactionRecoveries.SetRange("Transaction Code", CheckOffHeader."Charge Code");
                        TransactionRecoveries.SetCurrentKey(Prioirity);
                        TransactionRecoveries.SetAscending(Prioirity, true);
                        if TransactionRecoveries.FindSet() then begin
                            repeat
                                case TransactionRecoveries."Recovery Type" of
                                    TransactionRecoveries."Recovery Type"::Loan:
                                        begin
                                            AmountDue := 0;
                                            RecoveredAmount := 0;
                                            ExpectedInterest := 0;
                                            ExpectedPrincipal := 0;
                                            ExpectedAmount := 0;
                                            LoanNo := '';
                                            ExpectedAmount := GetExpectedAmount(MemberNo, TransactionRecoveries."Recovery Code", CheckOffHeader."Posting Date", LoanNo);
                                            if ExpectedAmount < 0 then
                                                ExpectedAmount := 0;
                                            if ExpectedAmount >= BaseAmount then begin
                                                RecoveredAmount := BaseAmount;
                                                BaseAmount := 0;
                                            end else begin
                                                RecoveredAmount := ExpectedAmount;
                                                BaseAmount -= RecoveredAmount;
                                            end;
                                            if RecoveredAmount > 0 then begin
                                                CheckOffCalculations.Reset();
                                                if CheckOffCalculations.FindLast() then
                                                    EntryNo := CheckOffCalculations."Entry No" + 1000;
                                                LoanApplication.Get(LoanNo);
                                                CheckOffCalculations.Init();
                                                CheckOffCalculations."Document No" := DocumentNo;
                                                CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                ;
                                                EntryNo += 1000;
                                                CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Loan Recovery";
                                                CheckOffCalculations.Amount := RecoveredAmount;
                                                CheckOffCalculations."Amount (Base)" := RecoveredAmount;
                                                CheckOffCalculations."Account Name" := LoanApplication."Product Description";
                                                CheckOffCalculations."Account No" := LoanApplication."Application No";
                                                CheckOffCalculations."Loan No" := LoanApplication."Application No";
                                                CheckOffCalculations.Insert();
                                            end;
                                        end;
                                    TransactionRecoveries."Recovery Type"::"Standing Order":
                                        begin
                                            StandingOrder.Reset();
                                            StandingOrder.SetRange("Member No", MemberNo);
                                            StandingOrder.SetRange("STO Type", TransactionRecoveries."Recovery Code");
                                            StandingOrder.SetRange(Running, true);
                                            StandingOrder.SetFilter("Start Date", '<=%1', CheckOffHeader."Posting Date");
                                            if StandingOrder.FindSet() then begin
                                                if StandingOrder."Amount Type" = StandingOrder."Amount Type"::Fixed then
                                                    STOAmount := StandingOrder.Amount
                                                else begin
                                                    STOAmount := RunningAmount;
                                                    RunningAmount := 0;
                                                end;
                                                if StandingOrder."Charge Code" <> '' then begin
                                                    STOCharge := JournalMgt.GetTransactionCharges(StandingOrder."Charge Code", STOAmount);
                                                end;
                                                if ((STOAmount + STOCharge) <= BaseAmount) then begin
                                                    RecoveredAmount := 0;
                                                    RecoveredAmount := STOAmount;
                                                    if RecoveredAmount > 0 then begin
                                                        CheckOffCalculations.Reset();
                                                        if CheckOffCalculations.FindLast() then
                                                            EntryNo := CheckOffCalculations."Entry No" + 1000;
                                                        CheckOffCalculations.Init();
                                                        CheckOffCalculations."Document No" := DocumentNo;
                                                        CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                        CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                        CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                        ;
                                                        EntryNo += 1000;
                                                        CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Standing Order";
                                                        CheckOffCalculations.Amount := RecoveredAmount;
                                                        CheckOffCalculations."Amount (Base)" := RecoveredAmount;
                                                        CheckOffCalculations."Account No" := StandingOrder."Document No";
                                                        CheckOffCalculations."Loan No" := StandingOrder."Document No";
                                                        CheckOffCalculations.Insert();
                                                    end;
                                                    BaseAmount -= RecoveredAmount;
                                                    RecoveredAmount := 0;
                                                    RecoveredAmount := STOCharge;
                                                    if RecoveredAmount > 0 then begin
                                                        CheckOffCalculations.Reset();
                                                        if CheckOffCalculations.FindLast() then
                                                            EntryNo := CheckOffCalculations."Entry No" + 1000;
                                                        CheckOffCalculations.Init();
                                                        CheckOffCalculations."Document No" := DocumentNo;
                                                        CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                        CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                        CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                        EntryNo += 1000;
                                                        CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Standing Order";
                                                        CheckOffCalculations.Amount := RecoveredAmount;
                                                        CheckOffCalculations."Amount (Base)" := RecoveredAmount;
                                                        CheckOffCalculations."Account No" := StandingOrder."Document No";
                                                        CheckOffCalculations."Loan No" := 'COMMISSION';
                                                        CheckOffCalculations.Insert();
                                                    end;
                                                    BaseAmount -= RecoveredAmount;
                                                end;
                                            end;
                                        end;
                                end;
                            until TransactionRecoveries.Next() = 0;
                        end;
                    end;
                end else begin
                    CheckoffUpload.Reset();
                    CheckoffUpload.SetRange("Check No", CheckoffLines."Check No");
                    CheckoffUpload.SetRange("Document No", DocumentNo);
                    if CheckoffUpload.FindSet() then begin
                        repeat
                            if CheckoffUpload.Remarks = '' then begin
                                AccountNo := '';
                                if CheckoffUpload.Refrence = '' then
                                    AccountNo := GetMemberAccount(CheckoffLines."Member No", 0)
                                else
                                    AccountNo := GetMemberAccountWithRefrence(CheckoffLines."Member No", 0, CheckoffUpload.Refrence);
                                if AccountNo <> 'PHILIP' then begin
                                    CheckOffCalculations.Init();
                                    CheckOffCalculations."Document No" := DocumentNo;
                                    CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                    CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                    CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                    EntryNo += 1000;
                                    CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Internal Deposit";
                                    CheckOffCalculations.Amount := CheckoffUpload.Amount;
                                    CheckOffCalculations."Amount (Base)" := CheckOffCalculations.Amount;
                                    CheckOffCalculations."Account No" := AccountNo;
                                    CheckOffCalculations.Insert();
                                end;
                            end else begin
                                case CheckoffUpload.Remarks of
                                    'DEP', 'DEPOSIT', 'DEPOSITS':
                                        begin
                                            AccountNo := '';
                                            if CheckoffUpload.Refrence = '' then
                                                AccountNo := GetMemberAccount(CheckoffLines."Member No", 0)
                                            else
                                                AccountNo := GetMemberAccountWithRefrence(CheckoffLines."Member No", 0, CheckoffUpload.Refrence);
                                            if AccountNo <> 'PHILIP' then begin
                                                CheckOffCalculations.Init();
                                                CheckOffCalculations."Document No" := DocumentNo;
                                                CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                EntryNo += 1000;
                                                CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Internal Deposit";
                                                CheckOffCalculations.Amount := CheckoffUpload.Amount;
                                                CheckOffCalculations."Amount (Base)" := CheckOffCalculations.Amount;
                                                CheckOffCalculations."Account No" := AccountNo;
                                                CheckOffCalculations.Insert();
                                            end;
                                        end;
                                    'SHARES', 'SHARECAPITAL', 'SSHARE', 'SCAP':
                                        begin
                                            AccountNo := '';
                                            if CheckoffUpload.Refrence = '' then
                                                AccountNo := GetMemberAccount(CheckoffLines."Member No", 1)
                                            else
                                                AccountNo := GetMemberAccountWithRefrence(CheckoffLines."Member No", 1, CheckoffUpload.Refrence);
                                            if AccountNo <> 'PHILIP' then begin
                                                CheckOffCalculations.Init();
                                                CheckOffCalculations."Document No" := DocumentNo;
                                                CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                EntryNo += 1000;
                                                CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Internal Deposit";
                                                CheckOffCalculations.Amount := CheckoffUpload.Amount;
                                                CheckOffCalculations."Amount (Base)" := CheckOffCalculations.Amount;
                                                CheckOffCalculations."Account No" := AccountNo;
                                                CheckOffCalculations.Insert();
                                            end;
                                        end;
                                    'SLOAN', 'LOAN', 'PRINCIPLE', 'SINTEREST', 'INTEREST':
                                        begin
                                            AccountNo := '';
                                            AccountNo := GetMemberLoanAccount(CheckoffLines."Member No", CheckoffUpload.Refrence, CheckOffHeader."Posting Date");
                                            if AccountNo <> 'PHILIP' then begin
                                                CheckOffCalculations.Init();
                                                CheckOffCalculations."Document No" := DocumentNo;
                                                CheckOffCalculations."Member No" := CheckoffLines."Member No";
                                                CheckOffCalculations."Check No" := CheckoffLines."Check No";
                                                CheckOffCalculations."Entry No" := GetCheckOffEntryNo(DocumentNo, CheckoffLines."Member No", CheckoffLines."Check No");
                                                EntryNo += 1000;
                                                CheckOffCalculations."Entry Type" := CheckOffCalculations."Entry Type"::"Loan Recovery";
                                                CheckOffCalculations.Amount := CheckoffUpload.Amount;
                                                CheckOffCalculations."Amount (Base)" := CheckOffCalculations.Amount;
                                                CheckOffCalculations."Account No" := AccountNo;
                                                CheckOffCalculations."Account Name" := CheckoffUpload.Refrence + ' Loan recovery';
                                                CheckOffCalculations.Insert();
                                            end;
                                        end;
                                end;
                            end;
                        until CheckoffUpload.Next() = 0
                    end;
                end;
            until CheckoffLines.Next() = 0;
            Window.Close();
        end;
    end;

    local procedure GetMemberAccount(MemberNo: Code[20]; LookupAccountType: Option NWD,Shares) NWDAccount: Code[20]
    var
        Vendor: Record Vendor;
        AccountType: Record "Product Factory";
    begin
        AccountType.Reset();
        if LookupAccountType = LookupAccountType::NWD then
            AccountType.SetRange("NWD Account", true)
        else
            AccountType.SetRange("Share Capital", true);
        if AccountType.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange("Member No.", MemberNo);
            Vendor.SetRange("Account Code", AccountType.Code);
            if Vendor.FindFirst() then
                NWDAccount := Vendor."No."
            else
                NWDAccount := 'PHILIP';
        end
        else
            NWDAccount := 'PHILIP';
        exit(NWDAccount);
    end;

    local procedure GetMemberAccountWithRefrence(MemberNo: Code[20]; LookupAccountType: Option NWD,Shares; Refrence: Code[20]) NWDAccount: Code[20]
    var
        Vendor: Record Vendor;
        AccountType: Record "Product Factory";
    begin
        AccountType.Reset();
        if LookupAccountType = LookupAccountType::NWD then
            AccountType.SetRange("NWD Account", true)
        else
            AccountType.SetRange("Share Capital", true);
        AccountType.SetRange("Search Code", Refrence);
        if AccountType.FindFirst() then begin
            Vendor.Reset();
            Vendor.SetRange("Member No.", MemberNo);
            Vendor.SetRange("Account Code", AccountType.Code);
            if Vendor.FindFirst() then
                NWDAccount := Vendor."No."
            else
                NWDAccount := 'PHILIP';
        end
        else
            NWDAccount := 'PHILIP';
        exit(NWDAccount);
    end;

    procedure GetMemberNo(CheckNo: Code[20]; EmployerCode: Code[20]) MemberNo: Code[20]
    var
        Vendor: Record Vendor;
        Members: Record Members;
    begin
        if Members.Get(CheckNo) then begin
            MemberNo := Members."Member No.";
        end else begin
            Members.Reset();
            Members.SetRange("Payroll No", CheckNo);
            Members.SetRange("Employer Code", EmployerCode);
            if Members.FindFirst() then begin
                MemberNo := Members."Member No.";
            end else begin
                Members.Reset();
                Members.SetRange("Payroll No.", CheckNo);
                Members.SetRange("Employer Code", EmployerCode);
                if Members.FindFirst() then begin
                    MemberNo := Members."Member No.";
                end else begin
                    if Vendor.get(CheckNo) then
                        MemberNo := Vendor."Member No."
                    else
                        MemberNo := 'SUSP:' + CheckNo;
                end;
            end;
        end;
        exit(MemberNo);
    end;

    procedure PostCheckoff(DocumentNo: Code[20])
    var
        CheckoffHeader: Record "Checkoff Header";
        CheckoffLines: Record "Checkoff Lines";
        CheckoffCalculation: Record "Checkoff Calculation";
        AccountNo, ExternalDocumentNo, MemberNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, ReasonCode, SourceCode : Code[20];
        LineNo, All, Current : Integer;
        JournalManagement: Codeunit "Journal Management";
        Window: Dialog;
        PostingDate: Date;
        PostingDescription: Text[50];
        PostingAmount, BaseAmount, InterestBalance, Principlebalance, BaseAmount1, InterestPaid, PrinciplePaid, RefundendAmount : Decimal;
        StandingOrder: Record "Standing Order";
        LoanApplication: Record "Loan Application";
        ProductFactory: Record "Product Factory";
        SaccoSetup: Record "Sacco Setup";
        LoansMgt: Codeunit "Loans Management";
        LoanProduct: Record "Product Factory";
        OutstandingPrinciple, OutstandingInterest : decimal;
    begin
        JournalBatch := 'CHECKOFF';
        JournalTemplate := 'SACCO';
        LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Loan Disbursements Batch');
        CheckoffHeader.get(DocumentNo);
        PostingDate := CheckoffHeader."Posting Date";
        CheckoffHeader.TestField("Suspense Account");
        CheckoffHeader.TestField("Balancing Account No");
        CheckoffLines.Reset();
        CheckoffLines.SetRange("Document No", DocumentNo);
        CheckoffLines.SetRange(Posted, false);
        if CheckoffLines.FindSet() then begin
            All := CheckoffLines.Count;
            Current := 1;
            Window.Open('Posting \#1### \@2@@@');
            repeat
                Window.Update(1, CheckoffLines."Member Name");
                Window.Update(2, ((Current / all) * 10000) div 1);
                Window.HideSubsequentDialogs;
                Current += 1;
                ReasonCode := Format(PostingDate);
                SourceCode := 'UPLOAD';
                MemberNo := CheckoffLines."Member No";
                AccountNo := '';
                ExternalDocumentNo := DocumentNo;
                PostingDescription := CheckoffHeader."Posting Description";
                //Debit Balancing Account
                AccountNo := CheckoffHeader."Balancing Account No";
                CheckoffLines.CalcFields("Amount Earned");
                PostingAmount := Abs(CheckoffLines."Amount Earned");
                if CheckoffHeader."Upload Type" = CheckoffHeader."Upload Type"::Checkoff then
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Customer, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Checkoff Pay", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8)
                else
                    LineNo := JournalManagement.CreateJournalLine(
                        GlobalAccountType::Customer, AccountNo, PostingDate, PostingDescription, PostingAmount,
                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                AccountNo := '';
                AccountNo := CheckoffLines."Collections Account";
                if CheckoffLines."Suspense Account" then begin
                    PostingDescription := copystr(CheckoffLines."Check No" + ':' + CheckoffLines."Member Name" + ':Suspense', 1, 50);
                    AccountNo := '';
                    AccountNo := CheckoffLines."Collections Account";
                    if CheckoffHeader."Upload Type" = CheckoffHeader."Upload Type"::Checkoff then
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Customer, AccountNo, PostingDate, PostingDescription, PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Checkoff Pay", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8)
                    else
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Customer, AccountNo, PostingDate, PostingDescription, PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                end else begin
                    if CheckoffHeader."Upload Type" = CheckoffHeader."Upload Type"::Checkoff then
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8)
                    else
                        LineNo := JournalManagement.CreateJournalLine(
                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Checkoff Pay", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                end;
                CheckoffCalculation.Reset();
                CheckoffCalculation.SetRange("Document No", DocumentNo);
                CheckoffCalculation.SetRange("Member No", CheckoffLines."Member No");
                CheckoffCalculation.SetFilter("Entry Type", '<>%1', CheckoffCalculation."Entry Type"::"Net Amount");
                if CheckoffCalculation.FindSet() then begin
                    repeat
                        PostingAmount := 0;
                        PostingAmount := Abs(CheckoffCalculation.Amount);
                        BaseAmount1 := PostingAmount;
                        AccountNo := '';
                        AccountNo := CheckoffLines."Collections Account";
                        PostingDescription := '';
                        PostingDescription := CheckoffCalculation."Account Name" + LoansMgt.GetDocumentNo(CheckoffHeader."Posting Date");
                        if CheckoffHeader."Upload Type" = CheckoffHeader."Upload Type"::Checkoff then
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Checkoff Pay", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8)
                        else
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                        case CheckoffCalculation."Entry Type" of
                            CheckoffCalculation."Entry Type"::"Internal Deposit":
                                begin
                                    PostingDescription := CheckoffCalculation."Account Name";
                                    AccountNo := '';
                                    AccountNo := CheckoffCalculation."Account No";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Checkoff Pay", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end;
                            CheckoffCalculation."Entry Type"::"Standing Order":
                                begin
                                    PostingDescription := '';
                                    PostingDescription := StandingOrder."Posting Description" + LoansMgt.GetDocumentNo(CheckoffHeader."Posting Date");
                                    AccountNo := '';
                                    StandingOrder.Get(CheckoffCalculation."Account No");
                                    case StandingOrder."Standing Order Class" of
                                        StandingOrder."Standing Order Class"::External, StandingOrder."Standing Order Class"::Internal:
                                            begin
                                                if PostingDescription = '' then
                                                    PostingDescription := 'STO:' + StandingOrder."Document No";
                                                AccountNo := StandingOrder."Destination Account";
                                                PostingAmount := 0;
                                                PostingAmount := CheckoffCalculation.Amount;
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            end;
                                        StandingOrder."Standing Order Class"::"Loan-Principle":
                                            begin
                                                LoanApplication.Reset();
                                                LoanApplication.SetRange("Application No", StandingOrder."Destination Account");
                                                if LoanApplication.FindSet() then begin
                                                    LoanApplication.CalcFields("Principle Balance");
                                                    AccountNo := LoanApplication."Loan Account";
                                                    PostingDescription := CopyStr('Principle Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                                    SourceCode := '';
                                                    ReasonCode := '';
                                                    SourceCode := LoanApplication."Product Code";
                                                    ReasonCode := LoanApplication."Application No";
                                                    if LoanApplication."Principle Balance" < 0 then
                                                        LoanApplication."Principle Balance" := 0;
                                                    if LoanApplication."Principle Balance" < CheckoffCalculation.Amount then begin
                                                        PostingAmount := LoanApplication."Principle Balance";
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        PostingDescription := CopyStr('Standing Order Refund ' + CheckoffHeader."Posting Description", 1, 50);
                                                        PostingAmount := 0;
                                                        PostingAmount := CheckoffCalculation.Amount - LoanApplication."Principle Balance";
                                                        SourceCode := '';
                                                        ReasonCode := '';
                                                        AccountNo := LoansMgt.GetFOSAAccount(LoanApplication."Member No.");
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    end else begin
                                                        PostingAmount := CheckoffCalculation.Amount;
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    end;
                                                end;
                                            end;
                                        StandingOrder."Standing Order Class"::"Loan-Interest":
                                            begin
                                                LoanApplication.Reset();
                                                LoanApplication.SetRange("Application No", StandingOrder."Destination Account");
                                                if LoanApplication.FindSet() then begin
                                                    LoanApplication.CalcFields("Interest Balance");
                                                    if LoanApplication."Interest Balance" < 0 then
                                                        LoanApplication."Interest Balance" := 0;
                                                    AccountNo := LoanApplication."Loan Account";
                                                    PostingDescription := CopyStr('Interest Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                                    SourceCode := '';
                                                    ReasonCode := '';
                                                    SourceCode := LoanApplication."Product Code";
                                                    ReasonCode := LoanApplication."Application No";
                                                    if LoanApplication."Interest Balance" < CheckoffCalculation.Amount then begin
                                                        PostingAmount := LoanApplication."Interest Balance";
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        SaccoSetup.Get();
                                                        if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                                            LoanProduct.Get(LoanApplication."Product Code");
                                                            AccountNo := LoanProduct."Interest Paid Account";
                                                            LineNo := JournalManagement.CreateJournalLine(
                                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                            AccountNo := LoanProduct."Interest Due Account";
                                                            LineNo := JournalManagement.CreateJournalLine(
                                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        end;
                                                        PostingDescription := CopyStr('Standing Order Refund ' + CheckoffHeader."Posting Description", 1, 50);
                                                        PostingAmount := 0;
                                                        PostingAmount := CheckoffCalculation.Amount - LoanApplication."Interest Balance";
                                                        SourceCode := '';
                                                        ReasonCode := '';
                                                        AccountNo := LoansMgt.GetFOSAAccount(LoanApplication."Member No.");
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    end else begin
                                                        PostingAmount := CheckoffCalculation.Amount;
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        SaccoSetup.Get();
                                                        if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                                            LoanProduct.Get(LoanApplication."Product Code");
                                                            AccountNo := LoanProduct."Interest Paid Account";
                                                            LineNo := JournalManagement.CreateJournalLine(
                                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                            AccountNo := LoanProduct."Interest Due Account";
                                                            LineNo := JournalManagement.CreateJournalLine(
                                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        StandingOrder."Standing Order Class"::"Loan Principle+Interest":
                                            begin
                                                LoanApplication.Reset();
                                                LoanApplication.SetRange("Application No", StandingOrder."Destination Account");
                                                if LoanApplication.FindSet() then begin
                                                    LoanApplication.CalcFields("Principle Balance", "Interest Balance");
                                                    BaseAmount := 0;
                                                    InterestBalance := 0;
                                                    Principlebalance := 0;
                                                    PrinciplePaid := 0;
                                                    InterestPaid := 0;
                                                    BaseAmount := CheckoffCalculation.Amount;
                                                    InterestBalance := LoanApplication."Interest Balance";
                                                    Principlebalance := LoanApplication."Principle Balance";
                                                    if InterestBalance < 0 then
                                                        InterestBalance := 0;
                                                    if Principlebalance < 0 then
                                                        Principlebalance := 0;
                                                    if InterestBalance > BaseAmount then begin
                                                        InterestPaid := BaseAmount;
                                                        BaseAmount := 0;
                                                    end else begin
                                                        InterestPaid := InterestBalance;
                                                        BaseAmount -= InterestPaid;
                                                    end;
                                                    RefundendAmount := 0;
                                                    if Principlebalance < BaseAmount then begin
                                                        PrinciplePaid := Principlebalance;
                                                        RefundendAmount := BaseAmount - PrinciplePaid;
                                                    end else
                                                        PrinciplePaid := BaseAmount;
                                                    AccountNo := LoanApplication."Loan Account";
                                                    PostingDescription := CopyStr('Principle Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                                    SourceCode := '';
                                                    ReasonCode := '';
                                                    SourceCode := LoanApplication."Product Code";
                                                    ReasonCode := LoanApplication."Application No";
                                                    PostingAmount := PrinciplePaid;
                                                    LineNo := JournalManagement.CreateJournalLine(
                                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    PostingDescription := CopyStr('Interest Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                                    PostingAmount := InterestPaid;
                                                    LineNo := JournalManagement.CreateJournalLine(
                                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    SaccoSetup.Get();
                                                    if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                                        LoanProduct.Get(LoanApplication."Product Code");
                                                        AccountNo := LoanProduct."Interest Paid Account";
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                        AccountNo := LoanProduct."Interest Due Account";
                                                        LineNo := JournalManagement.CreateJournalLine(
                                                            GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                    end;
                                                    PostingDescription := CopyStr('Checkoff Standing Order Refund ' + CheckoffHeader."Posting Description", 1, 50);
                                                    PostingAmount := RefundendAmount;
                                                    AccountNo := LoansMgt.GetFOSAAccount(LoanApplication."Member No.");
                                                    LineNo := JournalManagement.CreateJournalLine(
                                                        GlobalAccountType::Vendor, LoansMgt.GetFOSAAccount(MemberNo), PostingDate, PostingDescription, -1 * PostingAmount,
                                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                end;
                                            end;
                                    end;
                                    LineNo := JournalManagement.AddCharges(
                                                        StandingOrder."Charge Code", CheckoffLines."Collections Account", CheckoffLines."Amount Earned", LineNo, DocumentNo, MemberNo,
                                                        SourceCode, ReasonCode, ExternalDocumentNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, PostingDate, true);
                                end;
                            CheckoffCalculation."Entry Type"::Commission:
                                begin
                                    PostingAmount := 0;
                                    PostingAmount := CheckoffCalculation.Amount;
                                    PostingDescription := CheckoffCalculation."Account Name";
                                    AccountNo := CheckoffCalculation."Account No";
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"End Month Salary", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                end;
                            CheckoffCalculation."Entry Type"::"Loan Recovery":
                                begin
                                    PostingDescription := '';
                                    if LoanApplication.Get(CheckoffCalculation."Account No") then begin
                                        ReasonCode := LoanApplication."Application No";
                                        SourceCode := LoanApplication."Product Code";
                                        LoanApplication.CalcFields("Principle Balance", "Interest Balance");
                                        InterestBalance := 0;
                                        InterestBalance := LoanApplication."Interest Balance";
                                        if InterestBalance < 0 then
                                            InterestBalance := 0;
                                        Principlebalance := 0;
                                        Principlebalance := LoanApplication."Principle Balance";
                                        if LoanApplication."Principle Balance" < 0 then
                                            Principlebalance := 0;
                                        if InterestBalance < BaseAmount1 then begin
                                            InterestPaid := InterestBalance;
                                            BaseAmount1 -= InterestBalance;
                                        end else begin
                                            InterestPaid := BaseAmount1;
                                            BaseAmount1 := 0;
                                        end;
                                        if BaseAmount1 >= Principlebalance then begin
                                            PrinciplePaid := Principlebalance;
                                            BaseAmount1 -= PrinciplePaid;
                                        end else begin
                                            PrinciplePaid := BaseAmount1;
                                            BaseAmount1 := 0;
                                        end;
                                        PostingDescription := CopyStr('Interest Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                        AccountNo := LoanApplication."Loan Account";
                                        LineNo := JournalManagement.CreateJournalLine(
                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * InterestPaid,
                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        SaccoSetup.Get();
                                        if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                            LoanProduct.Get(LoanApplication."Product Code");
                                            AccountNo := LoanProduct."Interest Paid Account";
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * InterestPaid,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            AccountNo := LoanProduct."Interest Due Account";
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, InterestPaid,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        end;
                                        PostingDescription := CopyStr('Principle Paid ' + CheckoffHeader."Posting Description", 1, 50);
                                        LineNo := JournalManagement.CreateJournalLine(
                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PrinciplePaid,
                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        PostingDescription := CopyStr('Excess Loan Repayment ' + CheckoffHeader."Posting Description", 1, 50);
                                        AccountNo := CheckoffLines."Collections Account";
                                        LineNo := JournalManagement.CreateJournalLine(
                                            GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * BaseAmount1,
                                            Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                            JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    end;
                                end;
                        end;
                    until CheckoffCalculation.Next() = 0;
                end;
                JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                CheckoffLines.Posted := true;
                CheckoffLines.Modify();
                Commit();
            until CheckoffLines.Next() = 0;
            Window.Close();
        end;
        CheckoffHeader.Posted := true;
        CheckoffHeader.Modify();
    end;

    var

        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
}
codeunit 90016 "Gen. Jnl.-Post Ext"
{
    EventSubscriberInstance = Manual;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(Rec);
        Code(GenJnlLine);
        Rec.Copy(GenJnlLine);
    end;

    var
        JournalsScheduledMsg: Label 'Journal lines have been scheduled for posting.';
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        GenJnlsScheduled: Boolean;
        PreviewMode: Boolean;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        FALedgEntry: Record "FA Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJnlPostviaJobQueue: Codeunit "Gen. Jnl.-Post via Job Queue";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        ConfirmManagement: Codeunit "Confirm Management";
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        IsHandled: Boolean;
    begin
        HideDialog := true;
        OnBeforeCode(GenJnlLine, HideDialog);

        with GenJnlLine do begin
            GenJnlTemplate.Get("Journal Template Name");
            if GenJnlTemplate.Type = GenJnlTemplate.Type::Jobs then begin
                SourceCodeSetup.Get();
                if GenJnlTemplate."Source Code" = SourceCodeSetup."Job G/L WIP" then
                    Error(Text006, GenJnlTemplate.FieldCaption("Source Code"), GenJnlTemplate.TableCaption,
                      SourceCodeSetup.FieldCaption("Job G/L WIP"), SourceCodeSetup.TableCaption);
            end;
            GenJnlTemplate.TestField("Force Posting Report", false);
            if GenJnlTemplate.Recurring and (GetFilter("Posting Date") <> '') then
                FieldError("Posting Date", Text000);

            // if not (PreviewMode or HideDialog) then
            //   if not ConfirmManagement.GetResponseOrDefault(Text001, true) then
            //     exit;

            if "Account Type" = "Account Type"::"Fixed Asset" then begin
                FALedgEntry.SetRange("FA No.", "Account No.");
                FALedgEntry.SetRange("FA Posting Type", FALedgEntry."FA Posting Type"::Depreciation);
                if FALedgEntry.FindFirst and "Depr. Acquisition Cost" and not HideDialog then
                    if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text005, FieldCaption("Depr. Acquisition Cost")), true) then
                        exit;
            end;

            if not HideDialog then
                if not GenJnlPostBatch.ConfirmPostingUnvoidableChecks("Journal Batch Name", "Journal Template Name") then
                    exit;

            TempJnlBatchName := "Journal Batch Name";

            GeneralLedgerSetup.Get();
            GenJnlPostBatch.SetPreviewMode(PreviewMode);
            if GeneralLedgerSetup."Post with Job Queue" and not PreviewMode then begin
                // Add job queue entry for each document no.
                GenJnlLine.SetCurrentKey("Document No.");
                while GenJnlLine.FindFirst() do begin
                    GenJnlsScheduled := true;
                    GenJnlPostviaJobQueue.EnqueueGenJrnlLineWithUI(GenJnlLine, false);
                    GenJnlLine.SetFilter("Document No.", '>%1', GenJnlLine."Document No.");
                end;

                if GenJnlsScheduled then
                    Message(JournalsScheduledMsg);
            end else begin
                IsHandled := false;
                OnBeforeGenJnlPostBatchRun(GenJnlLine, IsHandled);
                if IsHandled then
                    exit;

                GenJnlPostBatch.Run(GenJnlLine);

                OnCodeOnAfterGenJnlPostBatchRun(GenJnlLine);

                if PreviewMode then
                    exit;

                if "Line No." = 0 then
                    Message(Text002)
                else
                    if TempJnlBatchName = "Journal Batch Name" then
                        Message(Text003)
                    else
                        Message(
                        Text004,
                        "Journal Batch Name");
            end;

            if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") or GeneralLedgerSetup."Post with Job Queue" then begin
                Reset;
                FilterGroup(2);
                SetRange("Journal Template Name", "Journal Template Name");
                SetRange("Journal Batch Name", "Journal Batch Name");
                OnGenJnlLineSetFilter(GenJnlLine);
                FilterGroup(0);
                "Line No." := 1;
            end;
        end;
    end;

    procedure Preview(var GenJournalLineSource: Record "Gen. Journal Line")
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        BindSubscription(GenJnlPost);
        GenJnlPostPreview.Preview(GenJnlPost, GenJournalLineSource);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCodeOnAfterGenJnlPostBatchRun(var GenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnRunPreview(var Result: Boolean; Subscriber: Variant; RecVar: Variant)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        GenJnlPost := Subscriber;
        GenJournalLine.Copy(RecVar);
        PreviewMode := true;
        Result := GenJnlPost.Run(GenJournalLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGenJnlLineSetFilter(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}

codeunit 90017 "Dividend Management"
{
    trigger OnRun()
    begin

    end;

    local procedure Initialize(DocumentNo: Code[20])
    var
        DividendLines: Record "Dividend Lines";
        DividendDetailLines: Record "Dividend Det. Lines";
        DividendHeader: Record "Dividend Header";
        DividendProgression: Record "Dividend Progression";
        DividendAllocation: Record "Dividend Allocations";
    begin
        DividendHeader.Get(DocumentNo);
        DividendHeader.TestField(Posted, false);
        DividendLines.Reset();
        DividendLines.SetRange(Posted, true);
        DividendLines.SetRange("Document No", DocumentNo);
        if DividendLines.FindSet() then
            Error('Some Lies have been posted. You Cannot recalculate');
        DividendLines.Reset();
        DividendLines.SetRange("Document No", DocumentNo);
        if DividendLines.FindSet() then
            DividendLines.DeleteAll();
        DividendDetailLines.Reset();
        DividendDetailLines.SetRange("Document No", DocumentNo);
        if DividendDetailLines.FindSet() then
            DividendDetailLines.DeleteAll();
        DividendProgression.Reset();
        DividendProgression.SetRange("Document No", DocumentNo);
        if DividendProgression.FindSet() then
            DividendProgression.DeleteAll();
        DividendAllocation.Reset();
        DividendAllocation.SetRange("Dividend Code", DocumentNo);
        if DividendAllocation.FindSet() then
            DividendAllocation.DeleteAll();
    end;

    local procedure PopulateMembers(DocumentNo: Code[20])
    var
        Window: Dialog;
        All, Current : integer;
        Member: Record Members;
        DividendParameters: record "Dividend Parameters";
        Vendor: Record Vendor;
        DividendLines: Record "Dividend Lines";
        DividendHeader: Record "Dividend Header";
        DividendDetailedEntries: Record "Dividend Det. Lines";
        Sdate, Edate, StartDate, EndDate, TempStartDate : Date;
        EntryNo: Integer;
        DividendProgression, DividendProgression1 : Record "Dividend Progression";
        MemberExit: Record "Member Exit Header";
    begin
        EntryNo := 1;
        DividendHeader.get(DocumentNo);
        StartDate := DividendHeader."Start Date";
        EndDate := DividendHeader."End  Date";
        Window.Open('Checking Member List \#1##');
        Member.Reset();
        if Member.FindSet() then begin
            repeat
                Window.Update(1, Member."Full Name");
                DividendParameters.Reset();
                DividendParameters.SetRange("Document No", DocumentNo);
                if DividendParameters.FindSet() then begin
                    repeat
                        TempStartDate := StartDate;
                        Vendor.Reset();
                        Vendor.SetRange("Member No.", Member."Member No.");
                        Vendor.SetRange("Account Code", DividendParameters."Account Type");
                        if Vendor.FindFirst() then begin
                            DividendLines.Init();
                            DividendLines."Document No" := DocumentNo;
                            DividendLines."Member No" := Member."Member No.";
                            DividendLines."Account No" := Vendor."No.";
                            DividendLines."Account Name" := Vendor.Name;
                            DividendLines."Member Name" := Member."Full Name";
                            DividendLines."Account Type" := DividendParameters."Account Type";
                            DividendLines.Insert();
                            TempStartDate := StartDate;
                            if DividendParameters."Rate Type" = DividendParameters."Rate Type"::"Pro-rated" then begin
                                DividendProgression.Init();
                                DividendProgression."Document No" := DocumentNo;
                                DividendProgression."Entry No" := EntryNo;
                                EntryNo += 1;
                                DividendProgression.Rate := DividendParameters.Rate;
                                DividendProgression."Rate Type" := DividendParameters."Rate Type";
                                DividendProgression."Account No" := Vendor."No.";
                                DividendProgression."Start Date" := 0D;
                                DividendProgression."Closing Date" := ClosingDate(CalcDate('-1D', TempStartDate));
                                DividendProgression."Member No" := Member."Member No.";
                                DividendProgression.Validate("Net Change");
                                DividendProgression.Insert();
                                repeat
                                    DividendProgression.Init();
                                    DividendProgression."Document No" := DocumentNo;
                                    DividendProgression."Entry No" := EntryNo;
                                    EntryNo += 1;
                                    DividendProgression.Rate := DividendParameters.Rate;
                                    DividendProgression."Rate Type" := DividendParameters."Rate Type";
                                    DividendProgression."Account No" := Vendor."No.";
                                    DividendProgression."Start Date" := TempStartDate;
                                    DividendProgression."Closing Date" := ClosingDate(CalcDate('CM', TempStartDate));
                                    DividendProgression."Member No" := Member."Member No.";
                                    DividendProgression.Validate("Net Change");
                                    Sdate := DMY2Date(01, Date2DMY(TempStartDate, 2), Date2DMY(TempStartDate, 3));
                                    Edate := ClosingDate(CalcDate('CM', TempStartDate));
                                    MemberExit.Reset();
                                    MemberExit.SetRange("Member No", DividendLines."Member No");
                                    MemberExit.SetRange(Posted, true);
                                    MemberExit.SetFilter("Posting Date", '%1..%2', SDate, Edate);
                                    if MemberExit.FindFirst() then begin
                                        DividendProgression1.Reset();
                                        DividendProgression1.SetRange("Document No", DocumentNo);
                                        DividendProgression1.SetRange("Member No", DividendLines."Member No");
                                        DividendProgression1.SetRange("Account No", DividendLines."Account No");
                                        DividendProgression1.SetFilter("Closing Date", '<%1', DividendProgression."Closing Date");
                                        if DividendProgression1.FindSet() then begin
                                            repeat
                                                DividendProgression1."Amount Earned" := 0;
                                                DividendProgression1.Modify();
                                            until DividendProgression1.Next() = 0;
                                        end;
                                        DividendProgression."Amount Earned" := 0;
                                    end;
                                    DividendProgression.Insert();
                                    TempStartDate := CalcDate('1M', TempStartDate);
                                until TempStartDate >= EndDate;
                            end else begin
                                DividendProgression.Init();
                                DividendProgression."Document No" := DocumentNo;
                                DividendProgression."Entry No" := EntryNo;
                                EntryNo += 1;
                                DividendProgression.Rate := DividendParameters.Rate;
                                DividendProgression."Rate Type" := DividendParameters."Rate Type";
                                DividendProgression."Account No" := Vendor."No.";
                                DividendProgression."Start Date" := TempStartDate;
                                DividendProgression."Closing Date" := ClosingDate(EndDate);
                                DividendProgression."Member No" := Member."Member No.";
                                DividendProgression.Validate("Net Change");
                                DividendProgression.Insert();
                            end;
                        end;
                    until DividendParameters.Next() = 0;
                end;
            until Member.Next() = 0;
        end;
        Window.Close();
    end;

    procedure CalculateDividend(DocumentNo: Code[20])
    var
    begin
        Initialize(DocumentNo);
        PopulateMembers(DocumentNo);
        AddCharges(DocumentNo);
        PopulateDividendAllocations(DocumentNo);
    end;

    local procedure AddCharges(DocumentNo: Code[20])
    var
        DividendHeader: Record "Dividend Header";
        DividendRecoveries: Record "Dividend Det. Lines";
        DividendLines: Record "Dividend Lines";
        Window: Dialog;
        All, Current : integer;
        BaseAmount, ChargeAmount : Decimal;
        LoansMgt: Codeunit "Loans Management";
        JournalMgt: Codeunit "Journal Management";
        TransactionCharges: Record "Transaction Charges";
        EntryNo: Integer;
        TransactionRecoveries: Record "Transaction Recoveries";
        LoanApplication: Record "Loan Application";
        InterestPaid, PrinciplePaid : Decimal;
        DividendDetLines: Record "Dividend Det. Lines";
    begin
        DividendHeader.Get(DocumentNo);
        if ((DividendHeader."Charge Code" <> '') AND (DividendHeader."Posting Type" = DividendHeader."Posting Type"::Payout)) then begin
            DividendLines.Reset();
            DividendLines.SetRange("Document No", DocumentNo);
            if DividendLines.FindSet() then begin
                All := DividendLines.Count;
                Current := 0;
                Window.Open('Checking Charges \#1## \@2@@@');
                repeat
                    Window.Update(1, DividendLines."Member Name");
                    Window.Update(2, Format(Current) + ' of ' + Format(All));
                    Current += 1;
                    DividendLines.CalcFields("Amount Earned");
                    BaseAmount := 0;
                    BaseAmount := DividendLines."Amount Earned";
                    TransactionCharges.Reset();
                    TransactionCharges.SetRange("Transaction Code", DividendHeader."Charge Code");
                    if TransactionCharges.FindSet() then begin
                        repeat
                            ChargeAmount := 0;
                            if ChargeAmount < 0 then
                                ChargeAmount := 0;
                            ChargeAmount := LoansMgt.GetChargeAmount(TransactionCharges."Transaction Code", TransactionCharges."Charge Code", BaseAmount);
                            if ChargeAmount > 0 then begin
                                DividendRecoveries.Init();
                                DividendRecoveries."Document No" := DocumentNo;
                                DividendRecoveries."Entry No" := EntryNo;
                                EntryNo += 1;
                                DividendRecoveries."Entry Type" := DividendRecoveries."Entry Type"::Recovery;
                                DividendRecoveries."Transaction Code" := TransactionCharges."Charge Code";
                                DividendRecoveries."Transaction Description" := TransactionCharges."Charge Description";
                                DividendRecoveries.Amount := ChargeAmount;
                                DividendRecoveries."Amount (Base)" := ChargeAmount;
                                DividendRecoveries."Account No" := DividendLines."Account No";
                                DividendRecoveries."Member No" := DividendLines."Member No";
                                DividendRecoveries."Post To Account" := TransactionCharges."Post to Account";
                                DividendRecoveries."Post to Account Type" := TransactionCharges."Post To Account Type"::"G/L Account";
                                DividendRecoveries.Insert();
                            end;
                        until TransactionCharges.Next() = 0;
                    end;
                    TransactionRecoveries.Reset();
                    TransactionRecoveries.SetRange("Transaction Code", DividendHeader."Charge Code");
                    TransactionRecoveries.SetCurrentKey(Prioirity);
                    if TransactionRecoveries.FindSet() then begin
                        repeat
                            InterestPaid := 0;
                            PrinciplePaid := 0;
                            case TransactionRecoveries."Recovery Type" of
                                TransactionRecoveries."Recovery Type"::Loan:
                                    begin
                                        LoanApplication.Reset();
                                        LoanApplication.SetRange("Member No.", DividendLines."Member No");
                                        LoanApplication.SetFilter("Loan Balance", '>0');
                                        LoanApplication.SetRange("Product Code", TransactionRecoveries."Recovery Code");
                                        if TransactionRecoveries."Recovery Amount" = TransactionRecoveries."Recovery Amount"::"Loan Arrears" then begin
                                            if LoanApplication."Interest Arrears" > BaseAmount then begin
                                                InterestPaid := BaseAmount;
                                                BaseAmount := 0;
                                            end else begin
                                                InterestPaid := LoanApplication."Interest Arrears";
                                                BaseAmount -= InterestPaid;
                                            end;
                                            if LoanApplication."Principle Arrears" > BaseAmount then begin
                                                PrinciplePaid := BaseAmount;
                                                BaseAmount := 0;
                                            end else begin
                                                PrinciplePaid := LoanApplication."Principle Arrears";
                                                BaseAmount -= PrinciplePaid;
                                            end;
                                            if InterestPaid > 0 then begin
                                                DividendRecoveries.Init();
                                                DividendRecoveries."Document No" := DocumentNo;
                                                DividendRecoveries."Entry No" := EntryNo;
                                                EntryNo += 1;
                                                DividendRecoveries."Entry Type" := DividendRecoveries."Entry Type"::Recovery;
                                                DividendRecoveries."Transaction Code" := LoanApplication."Application No";
                                                DividendRecoveries."Transaction Description" := LoanApplication."Product Description";
                                                DividendRecoveries.Amount := InterestPaid + PrinciplePaid;
                                                DividendRecoveries."Amount (Base)" := InterestPaid + PrinciplePaid;
                                                DividendRecoveries."Account No" := DividendLines."Account No";
                                                DividendRecoveries."Member No" := DividendLines."Member No";
                                                DividendRecoveries."Post To Account" := LoanApplication."Application No";
                                                DividendRecoveries."Post to Account Type" := DividendRecoveries."Post to Account Type"::Loan;
                                                DividendRecoveries.Insert();
                                            end;
                                        end;
                                    end;
                            end;
                        until TransactionRecoveries.Next() = 0;
                    end;
                until DividendLines.Next() = 0;
                Window.Close();
            end;
        end;
    end;

    local procedure PopulateDividendAllocations(DocumentNo: Code[20])
    var
        DividendHeader: Record "Dividend Header";
        DividendAllocations: Record "Dividend Allocations";
        DividendLines: Record "Dividend Lines";
        Window: Dialog;
        All, Current : integer;
    begin
        DividendHeader.Get(DocumentNo);
        if DividendHeader."Posting Type" = DividendHeader."Posting Type"::Payout then begin
            DividendLines.Reset();
            DividendLines.SetRange("Document No", DocumentNo);
            if DividendLines.FindSet() then begin
                All := DividendLines.Count;
                Current := 0;
                Window.Open('Checking \#1## \@2@@@');
                repeat
                    Window.Update(1, DividendLines."Member Name");
                    Window.Update(2, Format(Current) + ' of ' + Format(All));
                    DividendLines.CalcFields("Amount Earned", Recoveries);
                    DividendAllocations.Init();
                    DividendAllocations."Dividend Code" := DocumentNo;
                    DividendAllocations."Member No" := DividendLines."Member No";
                    DividendAllocations."Member Name" := DividendLines."Member Name";
                    DividendAllocations."Account No" := DividendLines."Account No";
                    DividendAllocations."Account Name" := DividendLines."Account Name";
                    DividendAllocations."Start Date" := DividendHeader."Start Date";
                    DividendAllocations."End Date" := DividendHeader."End  Date";
                    DividendAllocations."Gross Amount" := DividendLines."Amount Earned";
                    DividendAllocations.Charges := DividendLines.Recoveries;
                    DividendAllocations."Net Amount" := ABS(DividendAllocations."Gross Amount") - abs(DividendAllocations.Charges);
                    DividendAllocations."Created By" := UserId;
                    DividendAllocations."Created On" := CurrentDateTime;
                    DividendAllocations.Insert();
                until DividendLines.Next() = 0;
            end;
        end;
    end;

    procedure SubmitDividendAllocation(DividendCode: Code[20]; MemberNo: Code[20]; AccountNo: Code[20])
    var
        DividendAllocations: Record "Dividend Allocations";
    begin
        if DividendAllocations.Get(DividendCode, MemberNo, AccountNo) then begin
            DividendAllocations.Submitted := true;
            DividendAllocations."Member Allocated" := true;
            DividendAllocations."Allocated By" := UserId;
            DividendAllocations."Allocation Date" := CurrentDateTime;
            DividendAllocations.Modify(true);
        end;
    end;

    procedure PublishAllocations(DocumentNo: Code[20])
    var
        DividendHeader: Record "Dividend Header";
        DividendAllocations: Record "Dividend Allocations";
        Window: Dialog;
    begin
        DividendHeader.get(DocumentNo);
        DividendHeader.TestField("Allocation Expiry Date");
        DividendHeader.TestField("Mobile Payments Control");
        DividendHeader.TestField("Bank Transfers Control");
        DividendHeader.TestField("Posting Type", DividendHeader."Posting Type"::Payout);
        DividendAllocations.Reset();
        DividendAllocations.SetRange("Dividend Code", DocumentNo);
        if DividendAllocations.FindSet() then begin
            Window.Open('Publishing \#1###');
            repeat
                DividendAllocations."Pubished On" := CurrentDateTime;
                DividendAllocations."Expiry Date" := DividendHeader."Allocation Expiry Date";
                DividendAllocations.Published := true;
                DividendAllocations.Modify();
                Window.Update(1, DividendAllocations."Member Name");
            until DividendAllocations.Next() = 0;
            Window.Close();
        end;
    end;

    procedure PostDividend(DocumentNo: code[20])
    var
        ExternalDocumentNo, MemberNo, AccountNo, JournalBatch, JournalTemplate, Dim1, Dim2, Dim3, Dim4, Dim5, Dim6, Dim7, Dim8, ReasonCode, SourceCode : Code[20];
        DividendCalculationParameters: Record "Dividend Parameters";
        DividendLines: Record "Dividend Lines";
        DividendHeader: Record "Dividend Header";
        PostingDate: Date;
        PostingDescription: Text[50];
        LineNo: Integer;
        Window: Dialog;
        PostingAmount, BaseAmount, InterestBalance, PrincipleBalance, InterestPaid, PrinciplePaid : Decimal;
        LoansMgt: Codeunit "Loans Management";
        DividendDetLines: Record "Dividend Det. Lines";
        DividendAllocation: Record "Dividend Allocations";
        LoanApplication: Record "Loan Application";
        SaccoSetup: Record "Sacco Setup";
        LoanProduct: Record "Product Factory";
    begin
        DividendHeader.Get(DocumentNo);
        PostingDate := DividendHeader."Posting Date";
        JournalBatch := 'DIVIDEND';
        JournalTemplate := 'SACCO';
        SaccoSetup.get;
        DividendCalculationParameters.Reset();
        DividendCalculationParameters.SetRange("Document No", DocumentNo);
        if DividendCalculationParameters.FindSet() then begin
            Window.Open('Posting \#1### \#2###');
            repeat
                Window.Update(1, DividendCalculationParameters."Account Description");
                DividendLines.Reset();
                DividendLines.SetRange("Document No", DocumentNo);
                DividendLines.SetRange(Posted, false);
                DividendLines.SetRange("Account Type", DividendCalculationParameters."Account Type");
                if DividendLines.FindSet() then begin
                    repeat
                        if DividendHeader."Posting Type" = DividendHeader."Posting Type"::Payout then begin
                            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Dividend Posting');
                            //Debit Provision Account
                            MemberNo := DividendLines."Member No";
                            DividendLines.CalcFields("Amount Earned");
                            PostingAmount := 0;
                            PostingAmount := DividendLines."Amount Earned";
                            PostingDescription := DividendHeader."Posting Description";
                            AccountNo := DividendCalculationParameters."Debit Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            //CreditFosa
                            AccountNo := '';
                            AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            DividendDetLines.Reset();
                            DividendDetLines.SetRange("Document No", DocumentNo);
                            DividendDetLines.SetRange("Member No", MemberNo);
                            DividendDetLines.SetRange("Account No", DividendDetLines."Account No");
                            if DividendDetLines.FindSet() then begin
                                repeat
                                    PostingDescription := '';
                                    PostingDescription := DividendDetLines."Transaction Description";
                                    PostingAmount := 0;
                                    PostingAmount := DividendDetLines.Amount;
                                    AccountNo := '';
                                    AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
                                    LineNo := JournalManagement.CreateJournalLine(
                                        GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                        Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                        JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                    case DividendDetLines."Post to Account Type" of
                                        DividendDetLines."Post to Account Type"::"G/L Account":
                                            begin
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            end;
                                        DividendDetLines."Post to Account Type"::Loan:
                                            begin
                                                //WIP
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            end;
                                        DividendDetLines."Post to Account Type"::"Member Account":
                                            begin
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            end;
                                    end;
                                until DividendDetLines.Next() = 0;
                            end;
                            DividendAllocation.Reset();
                            DividendAllocation.SetRange("Dividend Code", DocumentNo);
                            DividendAllocation.SetRange("Member No", MemberNo);
                            DividendAllocation.SetRange("Account No", DividendLines."Account No");
                            DividendAllocation.SetRange(Submitted, true);
                            DividendAllocation.SetRange(Posted, false);
                            if DividendAllocation.FindSet() then begin
                                case DividendAllocation."Allocation Type" of
                                    DividendAllocation."Allocation Type"::"Bank Transfer", DividendAllocation."Allocation Type"::"Mobile Money":
                                        begin
                                            if DividendAllocation."Allocation Type" = DividendAllocation."Allocation Type"::"Bank Transfer" then
                                                AccountNo := DividendHeader."Bank Transfers Control"
                                            else
                                                AccountNo := DividendHeader."Mobile Payments Control";
                                            PostingAmount := DividendAllocation."Net Amount";
                                            PostingDescription := 'Allocation ' + Format(DividendAllocation."Allocation Type");
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        end;
                                    DividendAllocation."Allocation Type"::Capitalize:
                                        begin
                                            PostingAmount := 0;
                                            PostingAmount := DividendAllocation."Net Amount";
                                            AccountNo := DividendAllocation."Capitalize to Account";
                                            PostingDescription := 'Allocation ' + Format(DividendAllocation."Allocation Type");
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        end;
                                    DividendAllocation."Allocation Type"::"Loan Repayment":
                                        begin
                                            LoanApplication.Get(DividendAllocation."Loan No");
                                            LoanApplication.CalcFields("Principle Balance", "Interest Balance");
                                            BaseAmount := DividendAllocation."Net Amount";
                                            PrincipleBalance := LoanApplication."Principle Balance";
                                            InterestBalance := LoanApplication."Interest Balance";
                                            if InterestBalance > BaseAmount then begin
                                                InterestPaid := BaseAmount;
                                                BaseAmount := 0;
                                            end else begin
                                                InterestPaid := InterestBalance;
                                                BaseAmount -= InterestPaid;
                                            end;
                                            if PrincipleBalance > BaseAmount then begin
                                                PrinciplePaid := BaseAmount;
                                                BaseAmount := 0;
                                            end else begin
                                                PrinciplePaid := PrincipleBalance;
                                            end;
                                            ReasonCode := LoanApplication."Application No";
                                            SourceCode := LoanApplication."Product Code";
                                            AccountNo := '';
                                            AccountNo := LoanApplication."Loan Account";
                                            PostingDescription := 'Interest Paid';
                                            PostingAmount := 0;
                                            PostingAmount := InterestPaid;
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            if SaccoSetup."Interest Accrual Type" = SaccoSetup."Interest Accrual Type"::"Cash Basis" then begin
                                                LoanProduct.Get(LoanApplication."Product Code");
                                                AccountNo := '';
                                                AccountNo := LoanProduct."Interest Paid Account";
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                                AccountNo := '';
                                                AccountNo := LoanProduct."Interest Due Account";
                                                LineNo := JournalManagement.CreateJournalLine(
                                                    GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                    Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Interest Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                    JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            end;
                                            PostingDescription := 'Principle Paid';
                                            PostingAmount := 0;
                                            PostingAmount := PrinciplePaid;
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::"Principle Paid", LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                            PostingDescription := 'Allocation ' + Format(DividendAllocation."Allocation Type");
                                            PostingAmount := 0;
                                            PostingAmount := PrinciplePaid + InterestPaid;
                                            AccountNo := LoansMgt.GetFOSAAccount(MemberNo);
                                            LineNo := JournalManagement.CreateJournalLine(
                                                GlobalAccountType::Vendor, AccountNo, PostingDate, PostingDescription, PostingAmount,
                                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                                        end;
                                end;
                                DividendAllocation.Posted := true;
                                DividendAllocation."Posted On" := CurrentDateTime;
                                DividendAllocation.Modify();
                            end;
                            Commit();
                            Error('Get Here');
                            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                            DividendLines.Posted := true;
                            DividendLines.Modify();
                        end else begin
                            LineNo := JournalManagement.PrepareJournal(JournalTemplate, JournalBatch, 'Dividend Posting');
                            //Debit Provision Account
                            MemberNo := DividendLines."Member No";
                            DividendLines.CalcFields("Amount Earned");
                            PostingDescription := 'Dividend Provision ' + MemberNo;
                            PostingAmount := 0;
                            PostingAmount := DividendLines."Amount Earned";
                            PostingDescription := DividendHeader."Posting Description";
                            AccountNo := DividendHeader."Debit Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            //CreditFosa
                            AccountNo := '';
                            AccountNo := DividendHeader."Credit Account";
                            LineNo := JournalManagement.CreateJournalLine(
                                GlobalAccountType::"G/L Account", AccountNo, PostingDate, PostingDescription, -1 * PostingAmount,
                                Dim1, Dim2, MemberNo, DocumentNo, GlobalTransactionType::General, LineNo, SourceCode, ReasonCode, ExternalDocumentNo,
                                JournalTemplate, Journalbatch, Dim3, Dim4, Dim5, Dim6, DIm7, Dim8);
                            JournalManagement.CompletePosting(JournalTemplate, JournalBatch);
                            DividendLines.Posted := true;
                            DividendLines.Modify();
                        end;
                    until DividendLines.Next() = 0;
                end;
            until DividendCalculationParameters.Next() = 0;
            DividendHeader.Posted := true;
            DividendHeader.Modify();
            Window.Close();
        end;
    end;

    var
        GlobalTransactionType: Option General,"Cash Deposit","Cash Withdrawal",ATM,"Loan Disbursal","Interest Due","Interest Paid","Principle Paid","Mobile Dep","Mobile Wit","Acc. Transfer","Cheque Deposit","Bankers Cheque","Standing Order","Fixed Deposit","End Month Salary","Checkoff Pay","Inter Teller","Teller-Treasury","Disb. Rec","Mid Month Salary",Bonus,"Penalty Due","Penalty Paid";
        GlobalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        JournalManagement: Codeunit "Journal Management";
}

codeunit 90018 PortalIntegrations
{
    trigger OnRun()
    begin

    end;

    procedure GetMemberImage(var MemberNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Customer: Record Members;
        FileName: Text[250];
        Ostream: OutStream;
        ExportFile: File;
        MediaResourcesMgt: Codeunit "Media Resources Mgt.";
        iStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
    begin
        CLEAR(responseCode);
        CLEAR(responseMessage);
        IF Customer.GET(MemberNo) THEN BEGIN
            Customer.CalcFields("Member Image");
            responseCode := '00';
            responseMessage.ADDTEXT('{"Image":"');
            IF Customer."Member Image".HasValue THEN BEGIN
                FileName := 'C:\Attachments\' + FORMAT(Customer."Member No.") + '.png';
                Customer."Member Image".Export(FileName);
                IF ExportFile.OPEN(FileName) THEN BEGIN
                    ExportFile.CREATEINSTREAM(iStream);
                    responseMessage.AddText(Base64Convert.ToBase64(iStream));
                    ExportFile.CLOSE;
                END;
            END;
            responseMessage.ADDTEXT('"}');
        END ELSE BEGIN
            responseCode := '01';
            responseMessage.ADDTEXT('{"Response":"The Member Does Not Exist"}');
        END;
    end;

    procedure GetMemberSignature(var MemberNo: Code[20]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        Customer: Record Members;
        FileName: Text[250];
        Ostream: OutStream;
        ExportFile: File;
        MediaResourcesMgt: Codeunit "Media Resources Mgt.";
        iStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
    begin
        CLEAR(responseCode);
        CLEAR(responseMessage);
        IF Customer.GET(MemberNo) THEN BEGIN
            Customer.CalcFields("Member Signature");
            responseCode := '00';
            responseMessage.ADDTEXT('{"Signature":"');
            IF Customer."Member Image".HasValue THEN BEGIN
                FileName := 'C:\Attachments\' + FORMAT(Customer."Member No.") + '.png';
                Customer."Member Signature".Export(FileName);
                IF ExportFile.OPEN(FileName) THEN BEGIN
                    ExportFile.CREATEINSTREAM(iStream);
                    responseMessage.AddText(Base64Convert.ToBase64(iStream));
                    ExportFile.CLOSE;
                END;
            END;
            responseMessage.ADDTEXT('"}');
        END ELSE BEGIN
            responseCode := '01';
            responseMessage.ADDTEXT('{"Response":"The Member Does Not Exist"}');
        END;
    end;

    procedure ValidateIPRSData(var IDNo: Code[20]; var FirstName: Code[100]; var ResponseCode: Code[20]; var ResponseMessage: BigText)
    var
        MemberApplication: record "Member Application";
        HtClient: HttpClient;
        URLCode: TextConst ENU = 'https://test-api.ekenya.co.ke/Ushuru_APP_API/iprs';
        Content: HttpContent;
        Response: HttpResponseMessage;
        ok: Boolean;
        AuthString: Text;
        UserName: text[250];
        Password: Text[250];
        JToken, JLinesToken, ResultToken : JsonToken;
        JArray: JsonArray;
        JObject, NewJObject : JsonObject;
        JValue: JsonValue;
        i: Integer;
        ResponseText, PayLoad : Text;
        MpesaIntegrations: Codeunit "MPesa Integrations";
    begin
        PayLoad := '{'
            + '"phoneNumber":"254704113452"' + ','
            + '"idType":"GetDataByIdCard"' + ','
            + '"idNumber":"' + IDNo + '"' + ','
            + '"deviceId":"2345412341561"'
        + '}';
        JObject.ReadFrom(MpesaIntegrations.CallService('IPRS', URLCode, 2, PayLoad, '', ''));
        Clear(JToken);
        if JObject.Get('data', JLinesToken) then begin
            NewJObject := JLinesToken.AsObject();
            Clear(ResultToken);
            ResultToken := MpesaIntegrations.GetJsonToken(NewJObject, 'First_Name');
            MemberApplication."First Name" := ResultToken.AsValue().AsText();
        end;
        if UpperCase(ResultToken.AsValue().AsText()) = FirstName then begin
            ResponseCode := '00';
            ResponseMessage.AddText('{"Message":"The ID Number Name Combination Matches"}');
            exit;
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The ID Number Name Combination Does Not Exist"}');
            exit;
        end;
    end;

    procedure GenerateCalculatorSchedule(CalcNo: code[20])
    var
        LoansMgt: Codeunit "Loans Management";
        LoanCalculator: Record "Loan Calculator";
    begin
        if LoanCalculator.Get(CalcNo) then
            LoansMgt.GenerateCalculatorSchedule(LoanCalculator);
    end;

    procedure PopulateSubstitutionLines(DocumentNo: code[20])
    var
        LoansMgt: codeunit "Loans Management";
    begin
        LoansMgt.PopulateGuarantorSubLines(DocumentNo);
    end;

    procedure SetMemberImage(ApplicationNo: Code[20]; ImagePath: Text[250]; ImageType: Option MemberPicture,FronID,BackID,Signature)
    var
        MemberApplication: Record "Member Application";
        Members: Record Members;
    begin
        if MemberApplication.Get(ApplicationNo) then begin
            case ImageType of
                ImageType::MemberPicture:
                    MemberApplication."Member Image".Import(ImagePath);
                ImageType::BackID:
                    MemberApplication."Back ID Image".Import(ImagePath);
                ImageType::FronID:
                    MemberApplication."Front ID Image".Import(ImagePath);
                ImageType::Signature:
                    MemberApplication."Member Signature".Import(ImagePath);
            end;
            MemberApplication.Modify();
        end;

        if Members.Get(ApplicationNo) then begin
            case ImageType of
                ImageType::MemberPicture:
                    Members."Member Image".Import(ImagePath);
                ImageType::BackID:
                    Members."Back ID Image".Import(ImagePath);
                ImageType::FronID:
                    Members."Front ID Image".Import(ImagePath);
                ImageType::Signature:
                    Members."Member Signature".Import(ImagePath);
            end;
            Members.Modify();
        end;
    end;

    procedure ExportMemberImages(MemberNo: Code[100]; ImageType: Option MemberPicture,FronID,BackID,Signature) FPath: Text[250]
    var
        Members: Record Members;
    begin
        if Members.Get(MemberNo) then begin
            FPath := 'C:\Attachments\' + MemberNo + 'MP.png';
            Members."Member Image".Export(FPath);
            FPath := 'C:\Attachments\' + MemberNo + 'BID.png';
            Members."Back ID Image".Export(FPath);
            FPath := 'C:\Attachments\' + MemberNo + 'FID.png';
            Members."Front ID Image".Export(FPath);
            FPath := 'C:\Attachments\' + MemberNo + 'SIG.png';
            Members."Member Signature".Export(FPath);
        end;
        exit(FPath);
    end;

    procedure ProcessGuarantorRequest(LoanNo: Code[20]; MemberNo: code[20]; ResponseType: Option Accepted,Reject; Amount: Decimal; RequestType: Option Guarantor,Witness; var responseCode: Code[20])
    var
        OnlineGuarantors: Record "Online Guarantor Requests";
        SMSMgt: Codeunit "Notifications Management";
        SMSText, SMSNo : text[250];
        Member: Record Members;
        LoanApplication: Record "Loan Application";
        LoanGuarantees: Record "Loan Guarantees";
    begin
        OnlineGuarantors.Reset();
        OnlineGuarantors.SetRange("ID No", MemberNo);
        OnlineGuarantors.SetRange("Loan No", LoanNo);
        if RequestType = RequestType::Guarantor then
            OnlineGuarantors.SetRange("Request Type", OnlineGuarantors."Request Type"::Guarantor)
        else
            OnlineGuarantors.SetRange("Request Type", OnlineGuarantors."Request Type"::Witness);
        if OnlineGuarantors.FindSet() then begin
            MemberNo := OnlineGuarantors."Member No";
            if ResponseType = ResponseType::Accepted then begin
                OnlineGuarantors.Status := OnlineGuarantors.Status::Accepted;
                if RequestType = RequestType::Witness then begin
                    if LoanApplication.Get(LoanNo) then begin
                        LoanApplication.Validate(Witness, MemberNo);
                        LoanApplication.Modify();
                    end;
                end else begin
                    OnlineGuarantors."Amount Accepted" := Amount;
                    LoanGuarantees.Reset();
                    LoanGuarantees.SetRange("Loan No", LoanNo);
                    LoanGuarantees.SetRange("Member No", MemberNo);
                    if LoanGuarantees.FindSet() then
                        LoanGuarantees.DeleteAll();
                    if LoanApplication.Get(LoanNo) then begin
                        LoanGuarantees.Init();
                        LoanGuarantees."Loan No" := LoanNo;
                        LoanGuarantees.Validate("Member No", MemberNo);
                        LoanGuarantees."Guaranteed Amount" := Amount;
                        LoanGuarantees."Loan Owner" := LoanApplication."Member No.";
                        LoanGuarantees.Insert(true);
                    end;
                end;
            end else
                OnlineGuarantors.Status := OnlineGuarantors.Status::Rejected;
            OnlineGuarantors."Amount Accepted" := Amount;
            OnlineGuarantors."Responded On" := CurrentDateTime;
            OnlineGuarantors.Modify();
            responseCode := '00';
            if Member.Get(OnlineGuarantors.Applicant) then begin
                if OnlineGuarantors."Request Type" = OnlineGuarantors."Request Type"::Guarantor then
                    SMSText := 'Dear ' + Member."Full Name" + ', you have approved a loan guarantorship request from ' + OnlineGuarantors.ApplicantName + ', Amt: ' + Format(OnlineGuarantors.AppliedAmount) + '. If you didnt initiate this action kindly notify the sacco.'
                else
                    SMSText := 'Dear ' + Member."Full Name" + ', ' + OnlineGuarantors."Member Name" + ' has accepted your loan witness request';
                SMSNo := Member."Mobile Phone No.";
                SMSMgt.SendSms(SMSNo, SMSText);
            end;
        end else
            responseCode := '01';
    end;

    procedure SubmitLoanApplication(LoanNo: Code[20]; var ResponseCode: code[20])
    var
        OnlineLoanGuarantors: Record "Online Guarantor Requests";
        LoanApplication: Record "Online Loan Application";
    begin
        OnlineLoanGuarantors.Reset();
        OnlineLoanGuarantors.SetRange(Status, OnlineLoanGuarantors.Status::New);
        OnlineLoanGuarantors.SetRange("Loan No", LoanNo);
        if OnlineLoanGuarantors.FindFirst() then
            error('The %1 %2 has not responded to your request', OnlineLoanGuarantors."Request Type", OnlineLoanGuarantors."Member Name");
        LoanApplication.Get(LoanNo);
        if LoanApplication."Portal Status" <> LoanApplication."Portal Status"::New then
            Error('The Loan is already submitted');
        LoanApplication.CalcFields("Total Securities", "Total Collateral", "Total Repayment");
        if (LoanApplication."Total Securities" + LoanApplication."Total Collateral") < LoanApplication."Applied Amount" then
            Error('The Loan is unsecured');
        if LoanApplication."Total Repayment" = 0 then
            Error('Please Generate the Schedule');
        LoanApplication."Portal Status" := LoanApplication."Portal Status"::Submitted;
        LoanApplication."Submitted On" := CurrentDateTime;
        LoanApplication.Modify();
    end;

    procedure SubmitOnlineGuarantorRequest(LoanNo: code[20])
    var
        LoanApplication: Record "Loan Application";
        OnlineGuarantors: Record "Online Guarantor Requests";
    begin
        LoanApplication.Get(LoanNo);
        OnlineGuarantors.Reset();
        OnlineGuarantors.SetRange("Loan No", LoanNo);
        OnlineGuarantors.SetRange(Status, OnlineGuarantors.Status::New);
        if OnlineGuarantors.FindSet() then
            Error('Not all guarantors have responded to your requests!');
        LoanApplication.TestField("Source Type", LoanApplication."Source Type"::Channels);
        LoanApplication."Portal Status" := LoanApplication."Portal Status"::Submitted;
        LoanApplication.Modify();
    end;

    procedure SubmitOnlineGuarantorSubstitution(DocumentNo: code[20])
    var
        OnlineGuarantors: Record "Online Guarantor Sub.";
        GuarantorHeader: Record "Guarantor Lines";
    begin
        GuarantorHeader.Get(DocumentNo);
        OnlineGuarantors.Reset();
        OnlineGuarantors.SetRange("Document No", DocumentNo);
        OnlineGuarantors.SetRange(Status, OnlineGuarantors.Status::New);
        if OnlineGuarantors.FindSet() then
            Error('Not all guarantors have responded to your requests!');
    end;

    procedure RespondToGuarantorSubstituion(DocumentNo: code[20]; InitialGuarantor: Code[20]; MemberNo: Code[20]; var Amount: Decimal; ResponseType: Option Reject,Accept; var ResponseCode: Code[20])
    var
        OnlineRequest: Record "Online Guarantor Sub.";
    begin

    end;

    procedure OneThirdBasic(LoanNo: Code[20]) OneThird: Decimal
    var
        LoanApplication: Record "Loan Application";
        AppraisalParameters: Record "Loan Appraisal Parameters";
        OtherEarnings, NetIncome, ClearedEffect, BasicPay, HouseAllowance, OtherDeductions : Decimal;
        ParameterSetup: Record "Appraisal Parameters";
    begin
        AppraisalParameters.Reset();
        AppraisalParameters.SetRange("Loan No", LoanNo);
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
        OneThird := (1 / 3) * BasicPay;
        exit(OneThird);
    end;

    procedure AvailableRecovery(LoanNo: Code[20]) Available: Decimal
    var
        LoanApplication: Record "Loan Application";
        AppraisalParameters: Record "Loan Appraisal Parameters";
        OtherEarnings, OneThird, NetIncome, ClearedEffect, BasicPay, HouseAllowance, OtherDeductions : Decimal;
        ParameterSetup: Record "Appraisal Parameters";
    begin
        Available := 0;
        AppraisalParameters.Reset();
        AppraisalParameters.SetRange("Loan No", LoanNo);
        if AppraisalParameters.FindSet() then begin
            repeat
                ParameterSetup.Get(AppraisalParameters."Appraisal Code");
                if AppraisalParameters.Class = AppraisalParameters.Class::"Basic Pay" then
                    BasicPay += AppraisalParameters."Parameter Value";
            until AppraisalParameters.Next() = 0;
        end;
        Available := AdjustedNet(LoanNo) - (1 / 3 * BasicPay);
        exit(Available);
    end;

    procedure MonthlyRepayment(LoanNo: Code[20]) MonthlyInstallment: Decimal
    var
        LoanApplication: Record "Online Loan Application";
        AppraisalParameters: Record "Loan Appraisal Parameters";
        LoanProducts: Record "Product Factory";
        TotalMrepay, PrincipleAmnt, LPrincipal, LInterest, LBalance : Decimal;
    begin
        TotalMrepay := 0;
        LoanApplication.Get(LoanNo);
        PrincipleAmnt := LoanApplication."Applied Amount";
        IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::Amortised THEN BEGIN
            LoanApplication.TESTFIELD("Installments");
            IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                TotalMRepay := ROUND((LoanApplication."Interest Rate" / 12 / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 12 / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>')
            ELSE
                TotalMRepay := ROUND((LoanApplication."Interest Rate" / 100) / (1 - POWER((1 + (LoanApplication."Interest Rate" / 100)), -(LoanApplication."Installments"))) * (PrincipleAmnt), 0.0001, '>');
        END;
        IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Straight Line" THEN BEGIN
            LoanApplication.TESTFIELD("Installments");
            LPrincipal := PrincipleAmnt / LoanApplication."Installments";
            IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                LInterest := (LoanApplication."Interest Rate" / 12 / 100) * PrincipleAmnt
            ELSE
                LInterest := (LoanApplication."Interest Rate" / 100) * PrincipleAmnt;
            LInterest := LInterest;
            TotalMrepay := LPrincipal + LInterest;
        END;
        IF LoanApplication."Interest Repayment Method" = LoanApplication."Interest Repayment Method"::"Reducing Balance" THEN BEGIN
            LoanApplication.TESTFIELD("Installments");
            LPrincipal := PrincipleAmnt / LoanApplication."Installments";
            IF LoanProducts."Rate Type" = LoanProducts."Rate Type"::"Per-Annum" THEN
                LInterest := (LoanApplication."Interest Rate" / 12 / 100) * LBalance
            ELSE
                LInterest := (LoanApplication."Interest Rate" / 100) * LBalance;
            LInterest := LInterest;
            TotalMrepay := LPrincipal + LInterest;
        END;
        exit(TotalMrepay);
    end;

    procedure AdjustedNet(LoanNo: Code[20]) Adjusted: Decimal
    var
        AppraisalParameters: Record "Loan Appraisal Parameters";
        OtherEarnings, OneThird, NetIncome, ClearedEffect, BasicPay, HouseAllowance, OtherDeductions, OtherAllowances : Decimal;
        ParameterSetup: Record "Appraisal Parameters";
    begin
        Adjusted := 0;
        AppraisalParameters.Reset();
        AppraisalParameters.SetRange("Loan No", LoanNo);
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
        Adjusted := (BasicPay + HouseAllowance - OtherDeductions) + ClearedEffect + ((OtherEarnings) * 30 / 100);
        exit(Adjusted);
    end;

    procedure GetMemberLoans(MemberNo: code[20]; var LoanNo: code[20]; var ResponseMessage: BigText)
    var
        LoanApplication: Record "Loan Application";
        Member: Record Members;
        TempResponse: BigText;
    begin
        Clear(ResponseMessage);
        Clear(TempResponse);
        Member.Get(MemberNo);
        ResponseMessage.AddText('{"Loans":[');
        LoanApplication.Reset();
        LoanApplication.SetRange("Member No.", MemberNo);
        if LoanNo <> '' then
            LoanApplication.SetFilter("Application No", '<>%1', LoanNo);
        if LoanApplication.FindSet() then begin
            repeat
                LoanApplication.CalcFields("Loan Balance");
                TempResponse.ADDTEXT('{"Code":"' + LoanApplication."Application No"
                + '","Description":"' + LoanApplication."Product Description"
                + '","PrincipleAmount":"' + format(LoanApplication."Approved Amount")
                + '","CurrentBalance":"' + FORMAT(LoanApplication."Loan Balance")
                + '"}');
                TempResponse.ADDTEXT(',');
            until LoanApplication.Next() = 0;
            if STRLEN(FORMAT(TempResponse)) > 1 then
                ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
        END;
        ResponseMessage.AddText(']}');
    end;

    procedure GenerateAppraisalReport(LoanNo: code[20]) FilePath: Text[250]
    var
        LoanApplication: Record "Loan Application";
        AppraisalReport: Report "Loan Application";
    begin
        FilePath := 'C:\Attachments\Appraisal' + LoanNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        LoanApplication.Reset();
        LoanApplication.SetRange("Application No", LoanNo);
        if LoanApplication.FindSet() then begin
            Clear(AppraisalReport);
            AppraisalReport.SetTableView(LoanApplication);
            AppraisalReport.SaveAsPdf(FilePath);
        end;
        if File.Exists(FilePath) then
            exit(FilePath);
    end;

    procedure GenerateMemberApplication(ApplicationNo: code[20]) FilePath: Text[250]
    var
        MemberApplication: Record "Member Application";
        MemberApp: report "Membership Form";
    begin
        FilePath := 'C:\Attachments\' + ApplicationNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        MemberApplication.Reset();
        MemberApplication.SetRange("Application No.", ApplicationNo);
        if MemberApplication.FindSet() then begin
            Clear(MemberApp);
            MemberApp.SetTableView(MemberApplication);
            MemberApp.SaveAsPdf(FilePath);
        end;
        if File.Exists(FilePath) then
            exit(FilePath);
    end;

    procedure GenerateLoanSchedule(LoanNo: Code[20]) FilePath: Text[250]
    var
        LoanApplication: Record "Online Loan Application";
        LoanSchedule: Report "Online Repayment Schedule";
        LoansMgt: Codeunit "Loans Management";
    begin
        if LoanApplication.Get(LoanNo) then
            LoansMgt.GenerateOnlineLoanRepaymentSchedule(LoanApplication);
        FilePath := 'C:\Attachments\' + LoanNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        LoanApplication.Reset();
        LoanApplication.SetRange("Application No", LoanNo);
        if LoanApplication.FindSet() then begin
            Clear(LoanSchedule);
            LoanSchedule.SetTableView(LoanApplication);
            LoanSchedule.SaveAsPdf(FilePath);
        end;
        if File.Exists(FilePath) then
            exit(FilePath);
    end;

    procedure GetMemberProfileByMemberNo(var MemberNo: Code[20]; Var ResponseCode: Code[10]; var ResponseMessage: BigText)
    var
        Member: Record Members;
        Vendor: Record Vendor;
        LoanApplication: Record "Loan Application";
    begin
        Clear(ResponseCode);
        Clear(ResponseMessage);
        Clear(TempResponse);
        IF Member.GET(MemberNo) THEN BEGIN
            IF Member."E-Mail Address" = '' THEN
                Member."E-Mail Address" := 'phi';
            ResponseMessage.ADDTEXT('{"MemberNo":"' + Member."Member No." + '","DateOfRegistration":"' + Format(Member."Date of Registration") + '","FullName":"' + Member."Full Name" + '","NationalIDNo":"' + Member."National ID No" + '","Email":"' + Member."E-Mail Address" + '","Accounts":[');
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", Member."Member No.");
            IF Vendor.FINDSET THEN BEGIN
                ResponseCode := '00';
                REPEAT
                    Vendor.CALCFIELDS(Balance);
                    if Vendor.Balance > 0 then begin
                        TempResponse.ADDTEXT('{"Code":"' + Vendor."No."
                        + '","Description":"' + Vendor.Name
                        + '","ShareCapital":"' + FORMAT(Vendor."Share Capital Account")
                        + '","CashWithdrawAllowed":"' + FORMAT(Vendor."Cash Withdrawal Allowed")
                        + '","CashDepositAllowed":"' + FORMAT(Vendor."Cash Deposit Allowed")
                        + '","CashTransferAllowed":"' + FORMAT(Vendor."Cash Transfer Allowed")
                        + '","Balance":"' + FORMAT(Vendor.Balance, 0, 1)
                        + '"}');
                        TempResponse.ADDTEXT(',');
                    end;
                UNTIL Vendor.NEXT = 0;
                if STRLEN(FORMAT(TempResponse)) > 1 then
                    ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            END;
            ResponseMessage.ADDTEXT(']');
            ResponseMessage.ADDTEXT(',"Loans":[');
            CLEAR(TempResponse);
            LoanApplication.RESET;
            LoanApplication.SETRANGE("Member No.", Member."Member No.");
            IF LoanApplication.FINDSET THEN BEGIN
                REPEAT
                    LoanApplication.CALCFIELDS("Loan Balance", "Monthly Inistallment");
                    TempResponse.ADDTEXT('{"LoanNo":"' + LoanApplication."Application No"
                    + '","Description":"' + LoanApplication."Product Description"
                    + '","PrincipleAmount":"' + FORMAT(LoanApplication."Approved Amount", 0, 1)
                    + '","Installments":"' + FORMAT(LoanApplication.Installments)
                    + '","MonthlyInstallment":"' + FORMAT(ROUND(LoanApplication."Monthly Inistallment", 0.01, '>'), 0, 1)
                    + '","ApplicationDate":"' + FORMAT(LoanApplication."Posting Date")
                    + '","Status":"' + FORMAT(LoanApplication.Status)
                    + '","ControlAccount":"' + LoanApplication."Loan Account"
                    + '","Balance":"' + FORMAT(ROUND(LoanApplication."Loan Balance", 0.01, '>'), 0, 1)
                    + '"}');
                    TempResponse.ADDTEXT(',');
                UNTIL LoanApplication.NEXT = 0;
                if STRLEN(FORMAT(TempResponse)) > 1 then
                    ResponseMessage.ADDTEXT(COPYSTR(FORMAT(TempResponse), 1, STRLEN(FORMAT(TempResponse)) - 1));
            END;
            ResponseMessage.ADDTEXT(']}');
        end else begin
            ResponseCode := '01';
            ResponseMessage.AddText('{"Error":"The Member Does Not Exist ' + MemberNo + '"}');
        end;
    end;

    procedure GetMemberNoFromIDNo(var IDNo: code[20]) MemberNo: code[20]
    var
        Members: Record Members;
    begin
        MemberNo := '';
        Members.Reset();
        Members.SetRange("National ID No", IDNo);
        if Members.FindFirst() then
            MemberNo := Members."Member No."
        else
            Error('The ID No. %1 Does Not Exist', IDNo);
        exit(MemberNo);
    end;

    procedure GenerateAccountStatement(MemberNo: Code[20]; AccountNo: Code[20]) FilePath: Text[250]
    var
        Member: Record Members;
        AccountFilter: Text[100];
        MemberStatement: report "Member Statement";
    begin
        FilePath := 'C:\Attachments\' + MemberNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        AccountFilter := AccountNo;
        Member.Reset();
        Member.SetRange("Member No.", MemberNo);
        Member.SetFilter("Account Filter", AccountFilter);
        if Member.FindSet() then begin
            Clear(MemberStatement);
            MemberStatement.SetTableView(Member);
            MemberStatement.SaveAsPdf(FilePath);
        end;
        if File.Exists(FilePath) then
            exit(FilePath);
    end;

    procedure GetMemberGuarantors(MemberNo: Code[20]) FilePath: Text[250]
    var
        Members: record Members;
        MemberGrntrs: Report "Member Guarantors";
    begin
        FilePath := 'C:\Attachments\MemberGuarantors' + MemberNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        Members.Reset();
        Members.SetRange("Member No.", MemberNo);
        if Members.FindSet() then begin
            Clear(MemberGrntrs);
            MemberGrntrs.SetTableView(Members);
            MemberGrntrs.SaveAsPdf(FilePath);
        end;

    end;

    procedure GetMemberGuarantees(MemberNo: Code[20]) FilePath: Text[250]
    var
        Members: record Members;
        MemberGrntrs: Report "Member Guarantees";
    begin
        FilePath := 'C:\Attachments\MemberGuarantors' + MemberNo + '.pdf';
        if File.Exists(FilePath) then
            File.Erase(FilePath);
        Members.Reset();
        Members.SetRange("Member No.", MemberNo);
        if Members.FindSet() then begin
            Clear(MemberGrntrs);
            MemberGrntrs.SetTableView(Members);
            MemberGrntrs.SaveAsPdf(FilePath);
        end;

    end;

    var
        TempResponse: BigText;
}
codeunit 90019 "Cheque Book Management"
{
    trigger OnRun()
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeSendChequeBookApplicationForApproval()
    begin
    end;

    var
        myInt: Integer;
}
codeunit 90020 "Scheduled Activities"
{
    trigger OnRun()
    begin

    end;

    procedure updateGLEntry()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.Reset();
        if GLEntry.FindLast() then begin
            GLEntry.Rename(GLEntry."Entry No." + 20000);
        end;
    end;

    procedure ExecuteFunctions() response: Text
    var
        Integrations: Codeunit ThirdPartyIntegrations;
    begin
        Integrations.PostMobileTransactions();
        Integrations.PostATMTransactions();
    end;

    procedure ExecuteFunction(idx: Integer) response: Text
    var
        myInt: Integer;
    begin

    end;

    var
        myInt: Integer;
}
codeunit 90021 "Credit Email Management"
{
    trigger OnRun()
    begin

    end;

    internal procedure SendEmail(var BodyMessage: BigText; var MailSubject: Text[100]; var MessageReceipient: List of [Text]; var MessageReceipientCC: List of [Text]; AttachmentPath: Text[250]; AttachmentName: Text)
    var
        txtB64: Text;
        tmpBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        ExportFile: File;
        iStream: InStream;
    begin
        /*EmailAccounts.Reset();
        EmailAccounts.SetRange(Name, 'SACCO');
        if EmailAccounts.FindFirst() then begin
        IF ExportFile.OPEN(AttachmentPath) THEN BEGIN
            ExportFile.CREATEINSTREAM(iStream);
            txtB64 := Base64Convert.ToBase64(iStream);
            ExportFile.CLOSE;
        END;
        EmailMessage.Create(MessageReceipient, MailSubject, format(BodyMessage), true);
        EmailMessage.AddAttachment(AttachmentName + '.PDF', 'application/pdf', txtB64);
        EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default);*/
        //end;
    end;

    var
        EmailAccounts: Record "Email Account";
        EmailMessage: Codeunit "Email Message";
        EmailSend: Codeunit Email;

        Subject, Body, Receipient : Text;
}