codeunit 50600 "Peg Solitare Mgt."
{
    TableNo = "Peg Board";

    trigger OnRun()
    begin
        PegBoard := Rec;
        PegBoard."In Queue" := false;
        if IsSolved() then
            MarkAsSolution()
        else
            MakeMove();
    end;

    local procedure MarkAsSolution()
    begin
        PegBoard.Solution := true;
        PegBoard.Modify();
        while PegBoard."Parent Entry No." > 0 do begin
            PegBoard.Get(PegBoard."Parent Entry No.");
            PegBoard.Solution := true;
            PegBoard.Modify();
        end;
    end;

    procedure MakeMove()
    var
        NewMoveCreated: Boolean;
        x: Integer;
        y: Integer;
    begin
        if PegBoard.Move = 0 then begin
            MovePeg(4, 2);
        end else begin
            for x := 1 to 7 do
                for y := 1 to 7 do
                    NewMoveCreated := NewMoveCreated or MovePeg(x, y);
            PegBoard."Dead End" := not NewMoveCreated;
            PegBoard.Modify();
        end;
    end;

    local procedure MovePeg(x: Integer; y: Integer) NewMoveCreated: Boolean
    begin
        if HasPeg(x, y) then begin
            NewMoveCreated := NewMoveCreated or TryMoveUp(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveDown(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveLeft(x, y);
            NewMoveCreated := NewMoveCreated or TryMoveRight(x, y);
        end;
    end;

    local procedure TryMoveUp(x: Integer; y: Integer): Boolean
    begin
        if y <= 2 then
            exit;
        if not HasPeg(x, y - 1) then
            exit;
        if not IsEmptry(x, y - 2) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Up);
        exit(true);
    end;

    local procedure TryMoveDown(x: Integer; y: Integer): Boolean
    begin
        if y >= 6 then
            exit;
        if not HasPeg(x, y + 1) then
            exit;
        if not IsEmptry(x, y + 2) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Down);
        exit(true)
    end;

    local procedure TryMoveLeft(x: Integer; y: Integer): Boolean
    begin
        if x <= 2 then
            exit;
        if not HasPeg(x - 1, y) then
            exit;
        if not IsEmptry(x - 2, y) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Left);
        exit(true);
    end;

    local procedure TryMoveRight(x: Integer; y: Integer): Boolean
    begin
        if y >= 6 then
            exit;
        if not HasPeg(x + 1, y) then
            exit;
        if not IsEmptry(x + 2, y) then
            exit;

        // Move is valid
        MovePeg(x, y, PegBoard.Direction::Right);
        exit(true);
    end;

    local procedure MovePeg(x: Integer; y: Integer; Direction: enum "Peg Direction")
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        NewPegBoard := PegBoard;
        NewPegBoard."Parent Entry No." := PegBoard."Entry No.";
        NewPegBoard."Move" := PegBoard.Move + 1;
        NewPegBoard."Entry No." := 0;
        NewPegBoard.x := x;
        NewPegBoard.Y := y;
        NewPegBoard.Direction := Direction;
        RemovePeg(x, y);
        case Direction of
            Direction::Up:
                begin
                    RemovePeg(x, y - 1);
                    SetPeg(x, y - 2);
                end;
            Direction::Down:
                begin
                    RemovePeg(x, y + 1);
                    SetPeg(x, y + 2);
                end;
            Direction::Left:
                begin
                    RemovePeg(x - 1, y);
                    SetPeg(x - 2, y);
                end;
            Direction::Right:
                begin
                    RemovePeg(x + 1, y);
                    SetPeg(x + 2, y);
                end;
        end;
        NewPegBoard.Signature := CalcSignature(NewPegBoard.Board);
        if NewPegBoardIsNew() then begin
            NewPegBoard."In Queue" := true;
            NewPegBoard.Duplicate := false;
        end else begin
            NewPegBoard."In Queue" := false;
            NewPegBoard.Duplicate := true;
        end;
        NewPegBoard.Insert();
    end;

    local procedure RemovePeg(x: Integer; y: Integer)
    begin
        Replace(x, y, EmptyLbl);
    end;

    local procedure SetPeg(X: Integer; y: Integer)
    begin
        Replace(x, y, PegLbl);
    end;

    local procedure Replace(x: Integer; y: Integer; Value: Text[1])
    var
        Left: Text;
        Right: Text;
    begin
        Left := CopyStr(NewPegBoard.Board, 1, x + ((y - 1) * 7) - 1);
        Right := CopyStr(NewPegBoard.Board, x + ((y - 1) * 7) + 1, 7 - x + ((7 - y) * 7));
        NewPegBoard.Board := Left + Value + Right;
    end;

    local procedure HasPeg(x: Integer; y: Integer): Boolean
    begin
        exit(CopyStr(PegBoard.Board, x + (y - 1) * 7, 1) = PegLbl);
    end;

    local procedure IsEmptry(x: Integer; y: Integer): Boolean
    begin
        exit(CopyStr(PegBoard.Board, x + (y - 1) * 7, 1) = EmptyLbl);
    end;

    local procedure IsSolved(): Boolean
    begin
        exit(PegBoard.Board = BoardSolutionLbl);
    end;

    local procedure CalcSignature(Board: Text) Signature: Integer
    var
        I: Integer;
    begin
        for I := 1 to StrLen(Board) do begin
            case CopyStr(Board, I, 1) of
                '0':
                    begin
                        Signature *= 2;
                    end;
                '*':
                    begin
                        Signature *= 2;
                        Signature += 1;
                    end;
            end;
        end;
    end;

    local procedure NewPegBoardIsNew(): Boolean
    var
        PegBoardSeen: Record "Peg Board Seen";
    begin
        PegBoardSeen.Init();
        PegBoardSeen."Game No." := NewPegBoard."Game No.";
        PegBoardSeen.Signature := NewPegBoard.Signature;
        exit(PegBoardSeen.Insert())
    end;

    procedure InitBoard(NewPegBoard: Record "Peg Board")
    begin
        PegBoard := NewPegBoard;
    end;

    procedure InitBoard()
    begin
        PegBoard.Init();
        PegBoard."Board" := BoardInitLbl;
        PegBoard."Game No." := PegBoard.GetLastGameNo() + 1;
        PegBoard.Direction := PegBoard.Direction::" ";
        PegBoard."In Queue" := true;
        PegBoard.Insert();
    end;

    procedure CreateJob()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
            SetRange("Object Type to Run", "Object Type to Run"::Codeunit);
            SetRange("Object ID to Run", Codeunit::"Peg Solitare Job");
            if FindSet() then begin
                repeat
                    if not IsReadyToStart() then begin
                        Validate(Status, Status::Ready);
                        Modify(true);
                    end;
                until Next() = 0;
            end else begin
                CreateJob('Up');
                CreateJob('Down');
                CreateJob('Left');
                CreateJob('Right');
            end;
        end;
    end;

    local procedure CreateJob(ParameterString: Text)
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        with JobQueueEntry do begin
            Init();
            Validate("Object Type to Run", "Object Type to Run"::Codeunit);
            Validate("Object ID to Run", Codeunit::"Peg Solitare Job");
            Validate("Parameter String", ParameterString);
            Validate("Run on Mondays", true);
            Validate("Run on Tuesdays", true);
            Validate("Run on Wednesdays", true);
            Validate("Run on Thursdays", true);
            Validate("Run on Fridays", true);
            Validate("Run on Saturdays", true);
            Validate("Run on Sundays", true);
            Validate("No. of Minutes between Runs", 1);
            Insert(true);
            Validate(Status, Status::Ready);
            Modify(true);
        end;
    end;

    var
        PegBoard: Record "Peg Board";
        NewPegBoard: Record "Peg Board";
        PegLbl: Label '*', Locked = true;
        EmptyLbl: Label 'O', Locked = true;
        InvalidLbl: Label ' ', Locked = true;
        BoardInitLbl: Label '  ***    ***  **********O**********  ***    ***  ', Locked = true;
        BoardSolutionLbl: Label '  OOO    OOO  OOOOOOOOOO*OOOOOOOOOO  OOO    OOO  ', Locked = true;
}