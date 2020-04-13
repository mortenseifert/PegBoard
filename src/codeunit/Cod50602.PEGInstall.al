codeunit 50602 "PEG Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        MarkDeadEnds();
    end;

    local procedure MarkDeadEnds()
    var
        PegBoard: Record "Peg Board";
        ChildPegBoard: Record "Peg Board";
        i: Integer;
    begin
        PegBoard.SetRange("In Queue", false);
        PegBoard.SetRange(Move, 0, 30);
        PegBoard.SetRange("Dead End", false);
        // if PegBoard.FindSet(true) then
        //     repeat
        //         i += 1;
        //         ChildPegBoard.SetRange("Parent Entry No.", PegBoard."Entry No.");
        //         if ChildPegBoard.IsEmpty() then begin
        //             PegBoard."Dead End" := true;
        //             PegBoard.Modify();
        //         end;
        //         if i mod 1000 = 0 then
        //             Commit();
        //     until (PegBoard.next() = 0) or ;
    end;
}