page 50603 "Peg Board Moves"
{
    Caption = 'Peg Board Moves';
    PageType = List;
    SourceTable = "Peg Board Moves";
    Editable = false;
    UsageCategory = History;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Repeater1)
            {
                field("Game No."; "Game No.")
                {
                    ApplicationArea = All;
                }
                field(Move; Move)
                {
                    ApplicationArea = All;
                }
                field(Moves; Moves)
                {
                    ApplicationArea = All;
                }
                field("Moves In Queue"; "Moves In Queue")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PegBoardMoves: Record "Peg Board Moves";
        PegBoard: Record "Peg Board";
        GameNo, Move : Integer;
    begin
        GameNo := PegBoard.GetLastGameNo();
        PegBoardMoves.SetRange("Game No.", GameNo);
        if not PegBoardMoves.IsEmpty() then
            exit;
        for Move := 0 to 31 do begin
            PegBoardMoves.Init();
            PegBoardMoves."Game No." := GameNo;
            PegBoardMoves.Move := Move;
            PegBoardMoves.Insert();
        end;
        CurrPage.Update();
    end;
}