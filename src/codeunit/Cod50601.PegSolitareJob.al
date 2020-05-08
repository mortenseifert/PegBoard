codeunit 50601 "Peg Solitare Job"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        case UpperCase("Parameter String".Substring(1, 1)) of
            'S':
                SolveBoards("Parameter String");
            'D':
                DeleteBoards("Parameter String");
        end;
    end;

    local procedure SolveBoards(ParameterString: Text)
    var
        Window: Dialog;
        PegBoard: Record "Peg Board";
            Limit, I, J : Integer;
        Backwards: Boolean;
    begin
        if not Evaluate(Limit, ParameterString.Substring(2)) then
            Limit := 1000;
        PegBoard.SetRange("In Queue", true);
        PegBoard.SetRange(Duplicate, false);
        PegBoard.SetRange("Game No.", PegBoard.GetLastGameNo());
        Backwards := Date2DWY(Today(), 1) mod 2 = 1;

        // Reverse        
        Window.Open('#1############ Backwards ' + Format(Backwards));
        // if Backwards then begin
        //     while PegBoard.Find('+') and (I < Limit) do begin
        //         J := 1;
        //         repeat
        //             I += 1;
        //             J += 1;
        //             UpdateStatus(Window, I, Limit);
        //             Codeunit.Run(Codeunit::"Peg Solitare Mgt.", PegBoard);
        //         until (PegBoard.Next(-1) = 0) or (J >= 100) or (I >= Limit);
        //     end;
        // end else begin
        if PegBoard.Find('-') then
            repeat
                I += 1;
                UpdateStatus(Window, I, Limit);
                Codeunit.Run(Codeunit::"Peg Solitare Mgt.", PegBoard);
            until (PegBoard.Next() = 0) or (I >= Limit);
        // end;
        Window.Close();
    end;

    local procedure UpdateStatus(var Window: Dialog; I: Integer; Limit: Integer)
    begin
        if I mod 10 = 0 then
            Window.Update(1, StrSubstNo('Board %1 of %2', I, Limit));
    end;

    local procedure DeleteBoards(ParameterString: Text)
    var
        PegBoard: Record "Peg Board";
        Limit: Integer;
    begin
        if not Evaluate(Limit, ParameterString.Substring(2)) then
            Limit := 1000;
        PegBoard.SetRange("Game No.", 0, PegBoard.GetLastGameNo() - 1);
        // Find first Entry No.
        if PegBoard.FindFirst() then begin
            PegBoard.SetRange("Entry No.", 0, PegBoard."Entry No." + Limit);
            PegBoard.DeleteAll();
        end;
    end;
}