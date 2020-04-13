page 50600 "Peg Boards"
{
    Caption = 'Peg Boards';
    PageType = List;
    SourceTable = "Peg Board";
    InsertAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Boards)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Parent Entry No."; "Parent Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Game No."; "Game No.")
                {
                    ApplicationArea = All;
                }
                field(Move; Move)
                {
                    ApplicationArea = All;
                }
                field(X; X)
                {
                    ApplicationArea = All;
                }
                field(Y; Y)
                {
                    ApplicationArea = All;
                }
                field(Direction; Direction)
                {
                    ApplicationArea = All;
                }
                field("In Queue"; "In Queue")
                {
                    ApplicationArea = All;
                }
                field("Dead End"; "Dead End")
                {
                    ApplicationArea = All;
                }
                field(Duplicate; Duplicate)
                {
                    ApplicationArea = All;
                }
                field(Solution; Solution)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part(PegBoardFactbox; "Peg Board Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewGame)
            {
                Caption = 'New Game';
                ApplicationArea = All;
                Image = New;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = false;

                trigger OnAction()
                var
                    PegSolitareMgt: Codeunit "Peg Solitare Mgt.";
                    PegBoard: Record "Peg Board";
                begin
                    PegSolitareMgt.InitBoard();
                    CurrPage.Update();

                    PegSolitareMgt.CreateJob();
                end;
            }
        }
    }
}