page 50602 "Peg Board Activities"
{
    PageType = CardPart;
    SourceTable = "Peg Board Cue";

    layout
    {
        area(Content)
        {
            cuegroup(PegBoard)
            {
                field(Moves; Moves)
                {
                    Image = None;
                    ApplicationArea = All;
                }
                field("Max Move"; "Max Move")
                {
                    ApplicationArea = All;
                }
                field("In Queue"; "In Queue")
                {
                    Image = None;
                    ApplicationArea = All;
                }
                field(Duplicates; Duplicates)
                {
                    Image = None;
                    ApplicationArea = All;
                }
                field(Solutions; Solutions)
                {
                    Image = Heart;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        JobQueueEntry: Record "Job Queue Entry";
        PgeBoard: Record "Peg Board";
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
        SetRange("Game No. Filter", PgeBoard.GetLastGameNo());
    end;
}