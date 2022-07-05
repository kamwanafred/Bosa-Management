xmlport 90001 "Import Checkoff"
{
    Direction = Import;
    Format = VariableText;
    schema
    {
        textelement(CheckoffUpload)
        {
            tableelement("Checkoff"; "Checkoff Upload")
            {
                fieldattribute(CheckNo; Checkoff."Check No") { }
                fieldattribute(MemberName; Checkoff."Member Name") { }
                fieldattribute(Amount; Checkoff.Amount) { }
                fieldattribute(Remarks; Checkoff.Remarks) { }
                fieldattribute(Refrence; Checkoff.Refrence) { }
                trigger OnBeforeInsertRecord()
                begin
                    Checkoff."Document No" := DocumentNo;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                }
            }
        }

    }
    procedure SetCheckoffNo(CheckNo: code[20])
    var

    begin
        DocumentNo := CheckNo;
    end;

    var
        DocumentNo: Code[20];
}
xmlport 90002 "Import BulkSMS"
{
    Direction = Import;
    Format = VariableText;
    schema
    {
        textelement(BulkSMS)
        {
            tableelement("BulkSMSLines"; "Bulk SMS Lines")
            {
                fieldattribute(MemberName; BulkSMSLines."Full Name") { }
                fieldattribute(PhoneNo; BulkSMSLines."Phone No") { }
                trigger OnBeforeInsertRecord()
                begin
                    BulkSMSLines."Document No" := DocumentNo;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {

                }
            }
        }

    }
    procedure SetBulkSMSNo(CheckNo: code[20])
    var

    begin
        DocumentNo := CheckNo;
    end;

    var
        DocumentNo: Code[20];
}