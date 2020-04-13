page 50601 "Peg Board Factbox"
{
    Caption = 'Board';
    PageType = ListPart;
    SourceTable = "Peg Board";

    layout
    {
        area(Content)
        {
            field(Line1; BoardLine[1])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line2; BoardLine[2])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line3; BoardLine[3])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line4; BoardLine[4])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line5; BoardLine[5])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line6; BoardLine[6])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field(Line7; BoardLine[7])
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Prettify(Board);
    end;

    local procedure Prettify(Board: Text)
    var
        y: Integer;
        i: Integer;
        Pixel: Text;
    begin
        for y := 1 to 7 do begin
            BoardLine[y] := '';
            for i := 1 to 7 do begin
                case CopyStr(Board, ((y - 1) * 7) + i, 1) of
                    ' ':
                        BoardLine[y] += '    ';
                    '*':
                        BoardLine[y] += '  * ';
                    'O':
                        BoardLine[y] += ' O ';
                end;
            end;
        end;
    end;

    var
        BoardLine: array[7] of Text;
}