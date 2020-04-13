codeunit 50601 "Peg Solitare Job"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        if UpperCase("Parameter String") in ['UP', 'DOWN', 'LEFT', 'RIGHT'] then
            SolveBoards("Parameter String")
        else
            DeleteBoards("Parameter String");
    end;

    local procedure SolveBoards(ParameterString: Text)
    var
        PegBoard: Record "Peg Board";
        I: Integer;
    begin
        case UpperCase(ParameterString) of
            'UP':
                PegBoard.SetRange(Direction, PegBoard.Direction::Up);
            'DOWN':
                PegBoard.SetRange(Direction, PegBoard.Direction::Down);
            'LEFT':
                PegBoard.SetRange(Direction, PegBoard.Direction::Left);
            'RIGHT':
                PegBoard.SetFilter(Direction, '%1|%2', PegBoard.Direction::" ", PegBoard.Direction::Right);
        end;
        PegBoard.SetRange("In Queue", true);
        PegBoard.SetRange("Game No.", PegBoard.GetLastGameNo());
        // Reverse        
        if PegBoard.find('+') then begin
            repeat
                I += 1;
                Codeunit.Run(Codeunit::"Peg Solitare Mgt.", PegBoard);
            until (PegBoard.Next(-1) = 0) or (I > 1000);
        end;
    end;

    local procedure DeleteBoards(ParameterString: Text)
    var
        PegBoard: Record "Peg Board";
        Limit: Integer;
    begin
        if not Evaluate(Limit, ParameterString) then
            Limit := 1000;
        PegBoard.SetRange("Game No.", 0, PegBoard.GetLastGameNo() - 1);
        PegBoard.SetRange("Entry No.", 0, PegBoard."Entry No." + Limit);
        PegBoard.DeleteAll();
    end;
}